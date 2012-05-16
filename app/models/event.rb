# == Schema Information
# Schema version: 20110128131711
#
# Table name: events
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  name       :string(255)
#  start_at   :datetime
#  end_at     :datetime
#  created_at :datetime
#  updated_at :datetime
#  location   :string(255)
#

class Event < ActiveRecord::Base


  belongs_to :user

  attr_accessor :yol_event_url

  attr_accessible :start_at, :end_at, :name, :yol_event_url, :location

  private

  def self.yol_event_url_regex
    /reservableId=(\d+)/
  end

  public

  validates :yol_event_url, :presence => true, :format =>{:with => yol_event_url_regex }, :length => {:minimum => 6, :maximum => 200}

  validates :name, :presence => true

  validates :end_at, :presence => true

  validates :start_at, :presence => true

  validates :user_id, :presence => true

  validates :yol_event_id, :presence => true

  default_scope :order => 'events.start_at DESC'

  before_validation :extract_yol_event_id
  
  def extract_yol_event_id
    if(self.yol_event_url =~ Event.yol_event_url_regex)
      self.yol_event_id = $1
    end
  end


end

