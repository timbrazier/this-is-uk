class User < ActiveRecord::Base

  validates_presence_of :first_name, :last_name, :username, :password
  validates_uniqueness_of :username, :password
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  has_many :reviews
  has_many :items
  has_many :review_ratings
  
  def self.login(username, password)
    find(:first,
         :conditions => ["username = ? and password = ? and user_status <> 'blocked'",
                          username, password])
  end
  
  def try_to_login
    User.login(self.username, self.password)
  end
  
  def full_name
    first_name + " " + last_name
  end

end
