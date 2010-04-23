class Service < ActiveRecord::Base
  belongs_to :poi, :class_name => 'Pointsofinterest', :foreign_key => :pointsofinterest_id
  has_many :guidelines, :class_name => 'ServiceGuideline', :foreign_key => 'service_id', :order => 'effective_date DESC', :dependent => :destroy
  
  def current_guideline_summary
    return nil if guidelines == nil
    current_guideline = nil
    self.guidelines.each do |guideline|
      current_guideline = guideline if (current_guideline == nil and guideline.effective_date <= Time.now) or (guideline.effective_date <= Time.now and guideline.effective_date > current_guideline.effective_date)
    end
    return nil if current_guideline == nil
    return "#{current_guideline.effective_date.strftime('%m/%d/%Y')} - #{current_guideline.guideline_text}"
  end
  
  validates_presence_of :pointsofinterest_id
  validates_uniqueness_of :service_acronym
end