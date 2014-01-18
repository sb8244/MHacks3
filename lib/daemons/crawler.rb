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
  watches.each do |watch|
    uri = URI(watch.url)
    #Grab a hash of the page and compare it to the old hash
    new_page_hash = Digest::MD5.hexdigest( Net::HTTP.get( uri ) )

    trigger_job = false
    trigger_job = true if watch.history.last.nil? || new_page_hash != watch.history.last.page_hash

    if trigger_job 
      #This service will take an image of the content for the very specific selector we have
      result = open("http://content2img.com:4000?url=#{ERB::Util::url_encode(watch.url)}&selector=#{ERB::Util::url_encode(watch.selector)}").read
      json = JSON.parse(result)
      unless json['content']['html'] == watch.history.last.content 
        history = History.new do |h|
          h.content = json['content']['html'] unless json['error'] == 'not found'
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
  sleep 1
end
