#!/usr/bin/env ruby
require 'open-uri'
# You might want to change this
ENV["RAILS_ENV"] ||= "development"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
  #this could be optimized by combining same domains into 1 request
  #could also be parallelized, but this is a hackathon and i'm lazy
  watches = Watch.all 
  Parallel.each(watches, :in_threads => 4) do |watch|
    begin
      #Check to see if 2 minutes have passed since the last check
      if(watch.history.last.nil? || watch.history.last.updated_at - (Time.now - 2.minutes) < 0 )
        uri = URI(watch.url)
        
        last = watch.history.last
        if last 
          last.updated_at = DateTime.now
          last.save
        end

        #Grab a hash of the page and compare it to the old hash
        new_page_hash = Digest::MD5.hexdigest( Net::HTTP.get( uri ) )

        #trigger a job if the last history is null or the page content has changed
        trigger_job = watch.history.last.nil? || new_page_hash != watch.history.last.page_hash
        if trigger_job 
          #This service will take an image of the content for the very specific selector we have
          #should probably rescue read / timeout errors instead of throwing
          result = open("http://content2img.com:4000?trim=30&url=#{ERB::Util::url_encode(watch.url)}&selector=#{ERB::Util::url_encode(watch.selector)}",
                        'r', :read_timeout=>15).read
          json = JSON.parse(result)
          last_content = watch.history.last ? watch.history.last.content : ""
          #always process if this is the first
          process = watch.history.last.nil?
          #process this if there is an error and the last content was not an error
          process = process || !json['error'].nil? && last_content != "not found"
          #process this if the content is not null and does not equal the last content
          process = process || (!json['content'].nil? && json['content']['html'] != last_content)
          puts "#{watch.url} #{process}"
          if process 
            history = History.new do |h|
              h.content = json['content']['html'] unless json['error'] == 'not found'
              h.content = "not found" if json['error'] == 'not found'
              h.page_hash = new_page_hash
              h.watch = watch
              h.image_id = json['id']
              h.save
            end
            ChangeMailer.notify_user(watch.user, history).deliver
            puts "Job processed & Notified: #{watch.url}::#{watch.selector}"
          end
        end
      end  
    rescue StandardError => e
      puts "Exception caught: #{e.message}"
    end  
    sleep 5
  end
end
