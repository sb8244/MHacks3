class Watch
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user, validate: true
  has_many :history

  field :url,       :type => String
  field :selector,  :type => String
end
