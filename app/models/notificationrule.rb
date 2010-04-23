class Notificationrule < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :user_id, :seq_num, :l_paren, :r_paren, :object_name, :field_name

  def print
    types = ''
    if self.get_news == true then
      if self.get_additions == true then
        if self.get_updates == true then
          types = 'News, Additions and Updates'
        else
          types = 'News and Additions'
        end
      else
        if self.get_updates == true then
          types = 'News and Updates'
        else
          types = 'News'
        end
      end
    else
      if self.get_additions == true then
        if self.get_updates == true then
          types = 'Additions and Updates'
        else
          types = 'Additions'
        end
      else
        if self.get_updates == true then
          types = 'Updates'
        else
          types = ''
        end
      end
    end
    types = " for notifications on #{types}" if !types.blank?
    if self.object_name == 'ALL' then
      if self.field_name == 'ALL' then
        return "Track All Objects#{types}"
      else
        return "Track All Objects whose title or name contains \"#{self.comparison_value[1..(self.comparison_value.size-2)]}\"#{types}"
      end
    else
      object_name_label = Tablelabel.find(:first,:conditions => ["table_name = :name",{:name => self.object_name}])
      return "Corrupt Notification Rule" if object_name_label == nil
      if self.field_name == 'ALL' then
        return "Track All #{object_name_label.plural}#{types}"
      else
        if self.comparison_operator == 'like'
          return "Track #{object_name_label.plural} whose title or name contains \"#{self.comparison_value[1..(self.comparison_value.size-2)]}\"#{types}"
        else
          if self.comparison_operator == 'checkboxes' then
            return "Invalid Rule" if self.comparison_value.blank?
            list_of_checkbox_values = Array.new
            self.comparison_value.split(',').each do |checkbox_field|
              label = Tablefieldlabel.find(:first,:conditions => ["table_name = :table and field_name = :field",{:table => self.object_name, :field => checkbox_field}])
              list_of_checkbox_values << label.label
            end
            list_of_checkbox_values.sort! {|x,y| x.downcase <=> y.downcase}
            return "Track #{object_name_label.plural} who have #{self.field_name} of #{list_of_checkbox_values.join(', ')}#{types}"
          else
            return "Invalid Rule" if self.comparison_value[1..(self.comparison_value.size-2)].blank?
            relationship = {'id' => 'in the list:', 'networktermpttype_id' => 'whose type is in the list:', 'networkProviderTypes' => 'whose type is in the list:', 'poitype_id' => 'whose type is in the list:', 'country_id' => 'that are in one of the following countries:', 'unsubregion_id' => 'that are in one of the following regions:'}
            list_of_values = Array.new
            if self.field_name == 'id' then
              self.comparison_value[1..(self.comparison_value.size-2)].split(',').each do |val_id|
                list_of_values << object_name_label.title(val_id)
              end
            else
              label = Tablefieldlabel.find(:first,:conditions => ["table_name = :table and field_name = :field",{:table => self.object_name, :field => self.field_name}])
              self.comparison_value[1..(self.comparison_value.size-2)].split(',').each do |val_id|
                list_of_values << label.translate_value(val_id)
              end
            end
            list_of_values.sort! {|x,y| x.downcase <=> y.downcase}
            return "Track #{object_name_label.plural} #{relationship[self.field_name]} #{list_of_values.join(', ')}#{types}"
          end
        end
      end
    end
  end
end