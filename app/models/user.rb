require 'digest/sha1'
class User < ActiveRecord::Base
  
  belongs_to :role
  has_many :sharedreports, :dependent => :destroy
  has_many :reports, :through => :sharedreports
  has_many :reports, :dependent => :destroy
  has_many :poi_accounts, :class_name => 'Poiaccountexecutive', :foreign_key => 'user_id'
  
  has_many :newscomments, :dependent => :destroy
  has_many :newsratings, :dependent => :destroy
  has_many :notification_rules, :class_name => 'Notificationrule', :order => 'seq_num', :dependent => :destroy
  has_many :poi2ntpnotes, :dependent => :destroy
  has_many :poiaccountexecutives, :dependent => :destroy
  has_many :poiaccountnotes, :dependent => :destroy
  
  has_many :userlistitems, :dependent => :destroy
  has_many :userlists, :through => :userlistitems
  
  has_many :user_nps, :dependent => :destroy
  has_many :networkproviders, :through => :user_nps
  
  has_many :user_pois, :dependent => :destroy
  has_many :pointsofinterests, :through => :user_pois
  
  has_many :user_ntp_owners, :dependent => :destroy
  has_many :networktermptowners, :through => :user_ntp_owners
  
  has_many :inquiries, :dependent => :destroy
  
  has_many :user_customer_groups, :dependent => :destroy
  has_many :customer_groups, :through => :user_customer_groups
  has_many :customer_group_rules, :through => :customer_groups
  
  validates_presence_of     :email, :first_name, :last_name, :role_id
  validates_uniqueness_of   :email
 
  attr_accessor :password_confirmation
  validates_confirmation_of :password
  
  has_many :user_activity_sessions, :order => 'first_activity DESC'

  def validate
    errors.add_to_base("Missing password") if hashed_password.blank?
  end

  def set_last_activity(ip_address,type_of_activity)
    if type_of_activity == 'L' \
        or self.user_activity_sessions.nil? or self.user_activity_sessions[0].nil? \
        or datetime_difference_in_seconds(self.user_activity_sessions[0].last_activity,Time.now)/60 > 15 \
        or ip_address != self.user_activity_sessions[0].ip_address then
      activity_session = UserActivitySession.new
      activity_session.user_id = self.id
      activity_session.first_activity = DateTime.now
      activity_session.last_activity = DateTime.now
      activity_session.ip_address = ip_address
      activity_session.activity_type = type_of_activity
      activity_session.save!
    else
      self.user_activity_sessions[0].last_activity = DateTime.now
      self.user_activity_sessions[0].save!
    end
  end
  
  def self.authenticate(email, password)
    user = self.find_by_email(email)
    logger.info("MADE IT TO THE MODEL")
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password or user.active != 'Y'
        user = nil
      end
    end
    user
  end
  
  
  def password
    @password
  end
  
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end
  
  def has_role?(role)
    self.role_id == role.id
  end
  
  def is_equinix_user?
    self.has_role?(Role.find_by_name("Super User")) || !self.networktermptowners.find_by_name('Equinix').nil?
  end
  
  def is_super?
    self.has_role?(Role.find_by_name("Super User"))
  end
  
  def is_admin?
    self.has_role?(Role.find_by_name("Administrator")) || self.is_super?
  end
  
  def is_editor?
    self.has_role?(Role.find_by_name("Editor")) || self.is_admin? || self.is_super?
  end
  
  def is_contact?
    self.has_role?(Role.find_by_name("Contact"))
  end
  
  def has_admin_role?
    return (self.is_super? or self.is_admin?)
  end
  
  def has_editor_role?
    return (self.is_super? or self.is_admin? or self.is_editor?)
  end
  
  def is_np_editor?
    self.is_editor? && !self.networkproviders.nil?
  end
  
  def is_poi_editor?
    self.has_role?(Role.find_by_name("Editor")) && !self.pointofinterests.nil?
  end
  
  def can_edit_pointsofinterest?(poi_id=nil)
    return true if self.is_super?
    return true if self.has_editor_role? and self.is_equinix_user?
    return true if self.has_editor_role? and self.associated_with_pointsofinterest?(poi_id)
    return false
  end
  
  def can_edit_networkterminationpoint?(ntp_id=nil)
    return true if self.is_super?
    return true if self.has_editor_role? and self.is_equinix_user?
    return true if self.has_editor_role? and (self.associated_networkterminationpoints.collect{|ntp| ntp.id}).include?(ntp_id)
    return false
  end
  
  def can_edit_networkprovider?(np_id=nil)
    return true if self.is_super?
    return true if self.has_editor_role? and self.is_equinix_user?
    return true if self.has_editor_role? and self.associated_with_networkprovider?(np_id)
    return false
  end
  
  def can_edit_networktermptowner?(ntp_owner_id=nil)
    return true if self.is_super?
    return true if self.has_editor_role? and self.is_equinix_user?
    return true if self.has_editor_role? and self.associated_with_networktermptowner?(ntp_owner_id)
    return false
  end
  
  def can_edit_campus?(campusId=nil)
    return true if self.is_super?
    return true if self.has_editor_role? and self.is_equinix_user?
    return false
  end
  
  def can_view_page?(page,id=nil)
    return true if self.is_equinix_user?
    return true if page == 'edit_networkprovider' and self.associated_with_networkprovider? and (id.nil? or self.associated_with_networkprovider?(id))
    return true if page == 'edit_ntp' and self.associated_with_networkterminationpoint? and (id.nil? or self.associated_with_networkterminationpoint?(id))
    return true if page == 'edit_poi' and self.associated_with_pointsofinterest? and (id.nil? or self.associated_with_pointsofinterest?(id))
    return true if page == 'edit_ntp_owner' and self.associated_with_networktermptowner? and (id == nil or self.associated_with_networktermptowner?(id))
    #return true if ['edit_poi','edit_ntp','edit_networkprovider'].include?(page) and self.is_extranet_provider?
    self.customer_groups.each do |customer_group|
      customer_group.customer_group_rules.each do |rule|
        return true if rule.all_pages
        return true if rule.page_name == page and (id.nil? or rule.id_list == 'ALL' or rule.id_list.split(',').include?("#{id}"))
      end if !customer_group.customer_group_rules.nil?
    end if !self.customer_groups.nil?
    return false
  end
  
  def viewable_objects_on_page(page)
    table_name = CustomerGroupRule.hash_of_pages[page][:object]
    associated_objects = Array.new
    return eval("#{table_name}.find(:all)") if self.is_equinix_user?
    associated_objects = self.networkproviders.uniq if page == 'edit_networkprovider' and !self.networkproviders.nil?
    associated_objects = self.associated_networkterminationpoints.uniq if page == 'edit_ntp' and !self.associated_networkterminationpoints.nil?
    associated_objects = self.pointsofinterests.uniq if page == 'edit_poi' and !self.pointsofinterests.nil?
    associated_objects = self.networktermptowners.uniq if page == 'edit_ntp_owner' and !self.networktermptowners.nil?
    return eval("#{table_name}.find(:all)") if ['edit_poi','edit_ntp','edit_networkprovider'].include?(page) and self.is_extranet_provider?
    self.customer_groups.each do |customer_group|
      customer_group.customer_group_rules.each do |rule|
        return eval("#{table_name}.find(:all)") if rule.all_pages or (rule.page_name == page and rule.id_list == 'ALL')
        associated_objects.concat( eval("#{table_name}.find(:all,:conditions => ['id in (:id_list)', {:id_list => rule.id_list.split(',')}])") ) if rule.page_name == page and rule.id_list != 'ALL'
      end if !customer_group.customer_group_rules.nil?
    end if !self.customer_groups.nil?
    associated_objects.uniq!
    return associated_objects
  end
  
  def is_extranet_provider?
    self.networkproviders.each do |networkprovider|
      return true if (networkprovider.extranet_type == true)
    end if !self.networkproviders.nil?
    return false
  end
  
  def associated_networkterminationpoints
    networkterminationpoints = Array.new
    self.networktermptowners.each do |ntp_owner|
      ntp_owner.networkterminationpoints.each {|ntp| networkterminationpoints << ntp}
    end if !self.networktermptowners.nil?
    return networkterminationpoints
  end
  
  def associated_with_pointsofinterest?(poi_id="any")
    if poi_id == "any" then
      return true if !self.pointsofinterests.nil? and self.pointsofinterests.size > 0
    else
      self.pointsofinterests.each do |poi|
        return true if "#{poi.id}" == "#{poi_id}"
      end
    end
    return false
  end
  
  def associated_with_networkterminationpoint?(ntp_id="any")
    if ntp_id == "any" then
      return true if !self.networktermptowners.nil? and self.networktermptowners.size > 0
    else
      self.networktermptowners.each do |ntp_owner|
        ntp_owner.networkterminationpoints.each {|ntp| return true if "#{ntp.id}" == "#{ntp_id}"}
      end if !self.networktermptowners.nil?
    end
    return false
  end
  
  def associated_with_networkprovider?(np_id="any")
    if np_id == "any" then
      return true if !self.networkproviders.nil? and self.networkproviders.size > 0
    else
      self.networkproviders.each do |np|
        return true if "#{np.id}" == "#{np_id}"
      end
    end
    return false
  end
  
  def associated_with_networktermptowner?(ntp_owner_id="any")
    if ntp_owner_id == "any" then
      return true if !self.networktermptowners.nil? and self.networktermptowners.size > 0
    else
      self.networktermptowners.each do |ntp_owner|
        return true if "#{ntp_owner.id}" == "#{ntp_owner_id}"
      end
    end
    return false
  end
  
  def after_destroy
    if User.count.zero?
      raise "Can't delete last user"
    end
  end
  
  def print_name
    return "#{self.first_name} #{self.last_name}"
  end
  
  def print_name_with_email
    return "#{self.first_name} #{self.last_name}(#{self.email})"
  end
  
  def print_name_with_association
    associations = Array.new
    self.networktermptowners.each{|ntp_owner| associations << ntp_owner.name}
    self.networkproviders.each{|np| associations << np.name}
    self.pointsofinterests.each{|poi| associations << poi.name}
    associations.uniq!
    return "#{self.print_name} (#{(associations.empty?)?('No Association'):(associations.join(', '))})"
  end
  
  def print_association
    associations = Array.new
    self.networktermptowners.each{|ntp_owner| associations << ntp_owner.name}
    self.networkproviders.each{|np| associations << np.name}
    self.pointsofinterests.each{|poi| associations << poi.name}
    return "#{(associations.empty?)?('No Association'):(associations.join(', '))}"
  end
  
  def print_association_type
    associations = Array.new
    associations << 'Network Termination Point Owner' if !self.networktermptowners.nil?
    associations << 'Network Provider' if !self.networkproviders.nil?
    associations << 'Points of Interest' if !self.pointsofinterests.nil?
    return "#{(associations.empty?)?('None'):(associations.join(', '))}"
  end
  
  def hash_id(inject_str=nil)
    inject_str = 'equinix' if inject_str.nil?
    string_to_hash = "#{self.id}#{inject_str}#{self.email}"
    string_to_hash.unpack('U'*string_to_hash.length).join
  end
  
  private
  
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  
  def self.encrypted_password(password, salt)
    string_to_hash = password + "eqx" + salt
    string_to_hash.unpack('U'*string_to_hash.length).join
  end
  
  def datetime_difference_in_seconds(dt1,dt2)
    diff = 0
    if dt2 > dt1 then
      temp = dt1
      dt1 = dt2
      dt2 = temp
    end
    diff += (dt1.year - dt2.year)*(365*24*60*60)
    diff += (dt1.yday - dt2.yday)*(24*60*60)
    diff += (dt1.hour - dt2.hour)*(60*60)
    diff += (dt1.min - dt2.min)*60
    diff += (dt1.sec - dt2.sec)
    return diff
  end

end
