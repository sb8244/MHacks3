class History
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :watch

  field  :content,   :type => String
  field  :page_hash, :type => String
  field  :image_id,  :type => Integer
end
