module NewsHelper
  
    def print_tag_links
      link_items = Array.new
      if news.poitags != nil then
        news.poitags.each do |poiTag|
          link_items << {:name => poiTag.poi.name, :link => "/pointsofinterests/edit/#{ poiTag.poi.id }?selected_tab_row=1&selected_tab=4"}
        end
      end
    end
end
