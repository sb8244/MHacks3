class Watch
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user, validate: true
  has_and_belongs_to_many :category
  has_many :history

  field :url,       :type => String
  field :selector,  :type => String
  field :evernote_note, :type => String
end
