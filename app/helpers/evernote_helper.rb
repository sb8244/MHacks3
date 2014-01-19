module EvernoteHelper
  def self.associate_content_with_evernote(user, history)
    if user.evernote_token
      watch = history.watch
      ensure_notebook(user)

      client = EvernoteOAuth::Client.new(
        token: user.evernote_token
      )
      note_store = client.note_store
      
      #create a tag & push up
      tags = watch.category.collect(&:name)
      create_many_tags tags, note_store

      unless watch.evernote_note.nil?
        guid = watch.evernote_note
        begin
          note_store.expungeNote(user.evernote_token, guid)
        rescue
          #ignore
        end
      end

      #create a note with the given image
      note = create_note_with_image("http://content2img.com:4000/images/#{history.image_id}.png",
                              watch.url, watch.selector)
      note.notebookGuid = user.evernote_notebook

      #Add the category tags and save
      note.tagNames = tags
      note = note_store.createNote(user.evernote_token, note)

      #log the guid for the future
      watch.evernote_note = note.guid
      watch.save
    end
  end

  def self.create_tag(tag_name)
    tag = Evernote::EDAM::Type::Tag.new()
    tag.name = tag_name
    tag
  end

  def self.create_many_tags(tag_names, store)
    tag_names.each do |tag_name|
      begin
        tag = create_tag tag_name
        store.createTag(user.evernote_token, tag) unless tag.nil?
      rescue
        #ignore
      end
    end
  end

  def self.create_note_with_image(image_src, url, selector)
    image = Net::HTTP.get(URI(image_src))
    hashHex = Digest::MD5.new.hexdigest(image)

    data = Evernote::EDAM::Type::Data.new()
    data.size = image.size
    data.bodyHash = hashHex
    data.body = image

    resource = Evernote::EDAM::Type::Resource.new()
    resource.mime = "image/png"
    resource.data = data
    resource.attributes = Evernote::EDAM::Type::ResourceAttributes.new()
    resource.attributes.fileName = image_src

    note = Evernote::EDAM::Type::Note.new()
    note.title = "#{url} :: #{selector}"
    note.content = '<?xml version="1.0" encoding="UTF-8"?>' +
      '<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">' +
      '<en-note>' +
      '<en-media type="' + resource.mime + '" hash="' + hashHex + '"/>' +
      '</en-note>'
    note.resources = [ resource ] 
    note   
  end

  def self.ensure_notebook(current_user)
    if current_user.evernote_token
      client = EvernoteOAuth::Client.new(
        token: current_user.evernote_token
      )
      note_store = client.note_store
      existing_notebook = note_store.listNotebooks.select do |notebook|
        notebook.name == "Content Watching"
      end
      notebook = existing_notebook.first

      unless notebook
        notebook = Evernote::EDAM::Type::Notebook.new()
        notebook.name = "Content Watching"
        notebook = note_store.createNotebook(current_user.evernote_token, notebook)
      end

      if current_user.evernote_notebook.nil?
        current_user.evernote_notebook = notebook.guid
        current_user.save!
      end
    end
  end
end