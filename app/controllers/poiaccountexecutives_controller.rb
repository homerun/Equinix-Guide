class PoiaccountexecutivesController < ApplicationController
  include ExceptionNotifiable
  local_addresses.clear if EXCEPTIONS_ON
  
  def create
    @change_to_edit = true
    @pointsofinterest = Pointsofinterest.find(params[:poiaccountexecutive][:pointsofinterest_id])
    @poiaccountexecutive = Poiaccountexecutive.new(params[:poiaccountexecutive])
    if @poiaccountexecutive.save
      flash[:notice] = 'Account Executive added successfully'
      Audittrail.new.create_new_audit(@current_user, "Poiaccountexecutive", @poiaccountexecutive.id)
    end
    user_networktermptowner_ids = UserNtpOwner.find(:all, :conditions => "networktermptowner_id = #{Networktermptowner.find_by_name('Equinix').id}").collect{|u| u.user_id}
    @list_of_equinix_users = User.find(:all, :conditions => "id in (#{user_networktermptowner_ids.join(',')})", :order => 'last_name, first_name').collect { |user| ["#{user.print_name}", user.id] }
    render :partial => 'pointsofinterests/poi2ntp_account_executives'
  end
  
  def destroy
    params[:selectedAccountExecutives].join('').split(',').each do |account_exec_id|
      delete_with_audits('Poiaccountexecutive',account_exec_id)
    end
    @pointsofinterest = Pointsofinterest.find_by_id(params[:poiaccountexecutive][:pointsofinterest_id])
    user_networktermptowner_ids = UserNtpOwner.find(:all, :conditions => "networktermptowner_id = #{Networktermptowner.find_by_name('Equinix').id}").collect{|u| u.user_id}
    @list_of_equinix_users = User.find(:all, :conditions => "id in (#{user_networktermptowner_ids.join(',')})", :order => 'last_name, first_name').collect { |user| ["#{user.print_name}", user.id] }
    render :partial => 'pointsofinterests/poi2ntp_account_executives'
  end
end
