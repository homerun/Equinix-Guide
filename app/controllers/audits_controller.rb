class AuditsController < ApplicationController
  include ExceptionNotifiable
  local_addresses.clear if EXCEPTIONS_ON

  @@needs = {
   'Np2ntp' => ['networkterminationpoint_id','networkprovider_id','connectiontype_id'],
   'Poipreferrednp' => ['pointsofinterest_id','networkprovider_id'],
   'Poi2ntp' => ['pointsofinterest_id','networkterminationpoint_id','poiconnectiontype_id']
  }
  
  def rollback
    flash[:notice] = ''
    queue = Array.new
    audit_collection = Array.new
    "#{params[:audits]}".split(',').each do |auditId|
      audit = Audittrail.find_by_id(auditId)
      audit_collection << audit
      if meets_needs?(audit_collection,audit) then
        if audit.action == 'U' then
          @obj = update_with_audits(audit.table_name,{:id => audit.table_id,audit.field_name => audit.old_value})
          @obj.save!
        elsif audit.action == 'C' then
          delete_with_audits(audit.table_name,audit.table_id)
        elsif audit.action == 'D' then
          fieldValues = Hash.new
          audit_collection.each do |ac_audit|
            fieldValues[ac_audit.field_name] = ac_audit.old_value 
          end
          @obj = create_with_audits(audit.table_name,fieldValues)
          @obj.save!
        end
        audit_collection = Array.new
      end
      break if "#{audit.id}" == "#{params[:id]}"
    end
    if audit_collection.size != 0 then
      flash[:notice] += 'Some items were not rolled back due to incomplete rollback requests.'
    end
    redirect_to session[:original_uri]
  end
  
  def load_history
    if params[:range_option][:type] == "date" then
      beginDateTime = Time.parse("#{params[:range_parameter][:begin_month]} 1, #{params[:range_parameter][:begin_year]}")
      params[:range_parameter][:end_month] = "January" if params[:range_parameter][:end_month].blank?
      next_month = Date.const_get(:MONTHNAMES)[Date.const_get(:MONTHNAMES).index(params[:range_parameter][:end_month])%12+1]
      endDateTime = Time.parse("#{next_month} 1, #{params[:range_parameter][:end_year]}")
      endDateTime = endDateTime - 1
    else
      beginDateTime = nil
      endDateTime = nil
    end
    table_name = params[:table_name]
    table_id = params[:table_id].to_i
    table_obj = eval("#{table_name}.find_by_id(#{table_id})")
    grouped_audits = get_audits_for_object(table_name,table_id,beginDateTime,endDateTime)
    @history_items = combine_grouped_audits(table_obj,grouped_audits)
    if params[:range_option][:type] != "date" then
      @history_items[1].delete_if {|history| history[:changed_fields].blank? }
      @history_items[1] = @history_items[1].first(params[:range_parameter][:number_of_items].to_i)
    end
    render :partial => '/shared/history_items', :locals => {:table_name => table_name, :table_id => table_id}
  end
  
  private
  
  def meets_needs?(audit_collection,audit)
    return true if @@needs[audit.table_name] == nil
    @@needs[audit.table_name].each do |field|
      return false if !field_in_audit_collection?(audit_collection,field)
    end
    return true
  end
  
  def field_in_audit_collection?(audit_collection,field)
    audit_collection.each do |audit|
      return true if audit.field_name == field
    end
    return false
  end
end
