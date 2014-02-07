class Subcategory < ActiveRecord::Base
  belongs_to :category
  has_many :subsubcategories
  has_many :items
  
  def validate
    errors.add_to_base "Please enter a name" if subcat_name == ""
    errors.add_to_base "Please enter a system name" if subcat_sys_name == ""
  end
  
  def self.get_subcat_list(cat_name)
    Subcategory.find_by_sql(["select sc.subcat_name, sc.subcat_sys_name from subcategories sc " +
                             "inner join categories c on sc.category_id = c.id " +
                             "and c.cat_sys_name = ? order by subcat_name",cat_name])
  end
  
  def self.get_subcat(subcat_name)
    Subcategory.find_by_subcat_sys_name(subcat_name)
  end
end
