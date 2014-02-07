class Category < ActiveRecord::Base
  has_many :subcategories
  has_many :items
  
  def self.get_cat(cat_name)
    Category.find_by_cat_sys_name(cat_name)
  end
end
