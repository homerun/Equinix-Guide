class PointsofinterestAggregationsController < ApplicationController
  include ExceptionNotifiable
  local_addresses.clear if EXCEPTIONS_ON
  
  def add_pointsofinterest_aggregation
    @change_to_edit = true
    existing_aggregation = PointsofinterestAggregation.find(:first,:conditions => ['aggregator_pointsofinterest_id = :aggregator and aggregated_pointsofinterest_id = :aggregated', {:aggregator => params[:pointsofinterest_aggregation][:aggregator_pointsofinterest_id],:aggregated => params[:pointsofinterest_aggregation][:aggregated_pointsofinterest_id]}])
    if existing_aggregation then
      @message = 'That Point of Interest has already been added.'
    else
      create_with_audits('PointsofinterestAggregation',params[:pointsofinterest_aggregation])
    end
    @pointsofinterest = Pointsofinterest.find_by_id(params[:pointsofinterest][:id])
    if @pointsofinterest.aggregations then
      @potential_aggregations = Pointsofinterest.find(:all, :order => 'name').collect {|p| [p.name,p.id]}
    else
      @potential_aggregations = Pointsofinterest.find(:all,:conditions => ["id not in (:current)", {:current => @pointsofinterest.aggregations.collect {|poi| poi.id} }], :order => 'name').collect {|p| [p.name,p.id]}
    end
    render :partial => 'pointsofinterest_aggregations/pointsofinterest_aggregations'
  end
  
  def remove_pointsofinterest_aggregations
    @change_to_edit = true
    params[:selected_pointsofinterest_aggregations].join('').split(',').each do |pointsofinterest_aggregation_id|
      delete_with_audits('PointsofinterestAggregation',pointsofinterest_aggregation_id)
    end
    @pointsofinterest = Pointsofinterest.find_by_id(params[:pointsofinterest][:id])
    if @pointsofinterest.aggregations then
      @potential_aggregations = Pointsofinterest.find(:all, :order => 'name').collect {|p| [p.name,p.id]}
    else
      @potential_aggregations = Pointsofinterest.find(:all,:conditions => ["id not in (:current)", {:current => @pointsofinterest.aggregations.collect {|poi| poi.id} }], :order => 'name').collect {|p| [p.name,p.id]}
    end
    render :partial => 'pointsofinterest_aggregations/pointsofinterest_aggregations'
  end
  
end