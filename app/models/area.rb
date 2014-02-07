class Area < ActiveRecord::Base
belongs_to :city

  def validate
    errors.add_to_base "Please enter a name" if area_name == ""
  end
end
