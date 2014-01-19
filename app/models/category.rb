class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :watch
  belongs_to :user

  field   :name,  :type => String
end
