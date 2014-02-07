class Subsubcategory < ActiveRecord::Base

belongs_to :subcategory
has_many :items

def validate
    errors.add_to_base "Please enter a name" if subsubcat_name == ""
    errors.add_to_base "Please enter a system name" if subsubcat_sys_name == ""
end

  def self.get_subsubcat_list(subcat_name)
    Subcategory.find_by_sql(["select ssc.subsubcat_name, ssc.subsubcat_sys_name from subsubcategories ssc " +
                             "inner join subcategories sc on ssc.subcategory_id = sc.id " +
                             "and sc.subcat_sys_name = ? order by subsubcat_name",subcat_name])
  end
  
  def self.get_subsubcat(subsubcat_name)
    Subsubcategory.find_by_subsubcat_sys_name(subsubcat_name)
  end
  
end
