class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  has_many :watch
  has_many :category

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:github, :facebook]

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  # Evernote
  field :evernote_token,     :type => String
  field :evernote_notebook,  :type => String
  def self.find_for_oauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      if(user.category.empty?)
        c1 = Category.create ({:name => "Finance", :user => user, :image => ""})
        c2 = Category.create ({:name => "Academic", :user => user, :image => "http://blogs.sjsu.edu/mysjsu/files/2013/05/grades-1ict9ds.jpg"})
        c3 = Category.create ({:name => "Play", :user => user, :image => "http://bragthemes.com/demo/pinstrap/files/2012/10/modern-bike-220x146.jpeg"})
        c4 = Category.create ({:name => "Home Life", :user => user, :image => "http://bragthemes.com/demo/pinstrap/files/2012/10/modern-shower.jpeg"})
        c5 = Category.create ({:name => "Work", :user => user, :image => "http://bragthemes.com/demo/pinstrap/files/2012/10/white-house.jpeg"})
        user.category.push(c1,c2,c3,c4,c5)
      end
      user.save!
    end
  end
  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time
end
