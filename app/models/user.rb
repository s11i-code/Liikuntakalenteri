# == Schema Information
# Schema version: 20110113103803
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#  approved           :boolean



require 'digest'
class User < ActiveRecord::Base


  attr_accessor :password, :yol_username, :yol_password
  attr_accessible :name, :email, :password, :password_confirmation

  has_many :events, :dependent => :destroy
  has_many :ongoing_reservations, :dependent => :destroy

  has_many :recognitions, :dependent => :destroy, :foreign_key => "recogniser_id"
  has_many :reverse_recognitions, :dependent => :destroy, :foreign_key => "recognised_id", :class_name => "Recognition"

  has_many :recognisers, :through => :reverse_recognitions, :source => :recogniser
  has_many :recognising, :through => :recognitions, :source => :recognised

  email_regex = /\A[\w+\-.]+@[a-z\d]+\.[a-z]+\w/i

  validates :name,
    :presence => true,
    :length => {:within => 2..50}

  validates :email, :presence => true,
    :uniqueness => {:case_sensitive => false},
    :format =>{:with => email_regex}

  validates :password,
    :confirmation => true,
    :length => {:minimum => 6, :maximum => 40}
 
  validates :yol_password, :confirmation => true

  before_save :encrypt_password

  
  #Friendship methods

  def recognise!(user)
     raise 'User must be approved.' if !user.approved?
    self.recognitions.create!(:recognised_id => user.id)
  end

  def recognised_by?(user)
    user.recognitions.find_by_recognised_id(self.id)? true: false
  end
  
  def friends_with?(user)
    self.recognised_by?(user) && user.recognised_by?(self)
  end

  def waiting_friendship_confirmation_from?(user)
    user.recognised_by?(self) && !self.recognised_by?(user)
  end
  
  def friends
    self.recognising & self.recognisers
  end

  def friendship_requesters
    self.recognisers  - self.recognising
  end
  
  def anonymise_with(user)
    oneway = user.recognitions.find_by_recognised_id(self.id)
    opposite = self.recognitions.find_by_recognised_id(user.id)
    oneway.destroy if(oneway)
    opposite.destroy if(opposite)
  end


  #User authentication methods

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

 
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    (user && user.has_password?(submitted_password))? user : nil
  end

  def self.authenticate_with_salt(id, salt)
    user = User.find_by_id(id)
    (user && user.salt = salt)? user : nil
  end

  def event_feed
    from_ids = self.friends.map{|friend| friend.id} << self.id
    Event.where(:user_id => from_ids)
  end
  private

  def create_salt
    secure_hash("#{Time.zone.now.utc}--#{self.password}")
  end

  def encrypt_password
    self.salt = create_salt if new_record?
    self.encrypted_password = encrypt(password) unless password.blank?
  end

  def encrypt(string)
    secure_hash("#{self.salt}--#{string}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end


end

