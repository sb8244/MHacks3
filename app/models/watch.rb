class Watch
  include Mongoid::Document
  include Mongoid::Timestamps

  has_one :user, validate: true

  field :url,       :type => String
  field :selector,  :type => String
  field :history,   :type => Array
end
