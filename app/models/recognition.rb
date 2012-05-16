# == Schema Information
# Schema version: 20110119205614
#
# Table name: recognitions
#
#  id            :integer
#       not null, primary key
#  recogniser_id :integer
#  recognised_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Recognition < ActiveRecord::Base

  attr_accessible :recognised_id
  
  belongs_to :recogniser, :class_name => "User"
  belongs_to :recognised, :class_name => "User"

  validates :recogniser_id, :presence => true
  validates :recognised_id, :presence => true

  validate :recogniser_cannot_be_same_as_recognised

  before_save :delete_if_recognition_exists
  
  def delete_if_recognition_exists
    if(rec = self.recogniser.recognitions.find_by_recognised_id(self.recognised.id))
      rec.destroy
    end
  end

  def recogniser_cannot_be_same_as_recognised
    errors.add(:recogniser, "can't be same as recognised") if
      recogniser == recognised
  end

end
