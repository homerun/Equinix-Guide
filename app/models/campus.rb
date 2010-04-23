class Campus < ActiveRecord::Base
  has_many :ntps, :class_name => 'Networkterminationpoint'
  belongs_to :contact, :class_name => 'User', :foreign_key => 'user_contact'
  belongs_to :networktermptowner
  has_many :networkterminationpoints, :order => 'name'
  
  
  def contains_ntp(the_ntp)
    return false if ntps == nil
    ntps.each do |ntp|
      return true if ntp == the_ntp
    end
    return false
  end
end
