class CustomerGroupsController < ApplicationController
  include ExceptionNotifiable
  local_addresses.clear if EXCEPTIONS_ON
  
  before_filter :variables
  
  def index
    session[:original_uri] = request.request_uri
    session[:page] = 'customer_groups'
    set_json_vars
  end

  def json
    set_json_vars
    render :text => get_yui_hash(@model, @table_name, @columns, @order_by, @where).to_json
  end
  
  def new_customer_group_rule_step_one
    @customer_group_id = params[:id]
    @page_name_options = Array.new
    CustomerGroupRule.hash_of_pages.each_pair do |key,val|
      @page_name_options << [val[:title],key]
    end
    @page_name_options.sort! {|x,y| x[0].downcase <=> y[0].downcase}
    @page_name_options.insert(0,['All pages','ALL'])
    render :partial => 'new_customer_group_rule_step_one'
  end

  def new_customer_group_rule_step_two
    @customer_group_id = params[:customer_group_rule][:customer_group_id]
    @page_name = params[:customer_group_rule][:page_name]
    @all_pages = (params[:customer_group_rule][:page_name] == 'ALL' ? true : false)
    if CustomerGroupRule.non_object_pages.include?(params[:customer_group_rule][:page_name]) then
      @id_list = 'NONE'
    elsif params[:customer_group_rule][:all_objects] == 'yes' or @all_pages then
      @id_list = 'ALL' 
    else
      table_name = CustomerGroupRule.hash_of_pages[@page_name][:object]
      table_label_object = table_label(table_name)
      @list_of_ids = Array.new
      object_array = eval("#{CustomerGroupRule.hash_of_pages[@page_name][:object]}.find(:all)")
      @list_of_ids = object_array.collect {|x| [eval("x.#{table_label_object.look_up_field}"),"#{x.id}"]} if object_array != nil
      @list_of_ids.sort! {|x,y| x[0].downcase <=> y[0].downcase}
    end
    render :partial => 'new_customer_group_rule_step_two'
  end
  
  def create_new_customer_group_rule
    if params[:customer_group_rule][:id_list] != 'ALL' and params[:customer_group_rule][:id_list] != 'NONE' then
      params[:customer_group_rule][:id_list] = params[:customer_group_rule][:id_list].join('')
    end
    @customer_group_rule = create_with_audits('CustomerGroupRule',params[:customer_group_rule])
    redirect_to :action => 'edit', :id => params[:customer_group_rule][:customer_group_id]
  end
  
  def remove_customer_group_rule
    delete_with_audits('CustomerGroupRule',params[:deleteId])
    @customer_group = CustomerGroup.find_by_id(params[:customer_group_id])
    render :partial => 'current_customer_group_rules'
  end
  
  def edit
    @customer_group = CustomerGroup.find_by_id(params[:id])
  end
  
  def update
    @customer_group = CustomerGroup.find(params[:id])
    if @customer_group.update_attributes(params[:customer_group])
      flash[:notice] = "Customer Group successfully updated"
      redirect_to :action => "index"
    else
      set_edit_report_variables(@report)
      render :action => "edit"
    end
  end
  
  def destroy
    CustomerGroup.find(params[:id]).destroy
    redirect_to :action => "index"
  end
  
  def create
    create_with_audits('CustomerGroup',params[:customer_group])
    redirect_to :action => "index"
  end
  
  def add_user
    
  end
  
  def remove_user
    
  end
  
  def export
    set_json_vars
    send_data( get_csv_export(@model, @table_name, @columns, @order_by, @where), 
               :type => get_csv_content_type,
               :filename => "customer_groups.csv")
  end
  
  private
  
  def set_json_vars
    @model = CustomerGroup
    set_yui_vars
    @export_csv = false
    @order_by = "#{@table_name}.name"
    @where = ""
    @columns = [
      { :name => "name", :type => "string", :label => "Customer", :sortable => true },
      { :name => "notes", :type => "text", :label => "Notes", :sortable => true },
      { :name => "edit", :type => "string", :label => "Edit", :sortable => false, :link_type => "edit" },
      { :name => "destroy", :type => "string", :label => "Delete", :sortable => false, :link_type => "destroy" },
      { :name => "id", :type => "integer", :hidden => true }
    ]
  end
  
  def variables
    @subnav = "customer_groups"
  end
  
end
