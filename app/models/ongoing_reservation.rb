# == Schema Information
# Schema version: 20110113113405
#
# Table name: ongoing_reservations
#
#  id            :integer         not null, primary key
#  cookie        :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  yol_event_url :string(255)
#  user_id       :integer
#

class OngoingReservation < ActiveRecord::Base

  
  attr_accessible :yol_username, :yol_password, :yol_event_url
  
  attr_accessor :yol_username, :yol_password

  belongs_to :user

  private

  def self.yol_event_url_regex
    /reservableId=(\d+)/
  end
  
  public

  #validates :yol_username, :presence => true

 # validates :yol_password, :presence => true
  
  validates :yol_event_url, :presence => true, :format =>{:with => yol_event_url_regex }, :length => {:minimum => 6, :maximum => 200}

  def yol_event_id
    if (self.yol_event_url =~ OngoingReservation.yol_event_url_regex)
      $1
    end
  end
end
