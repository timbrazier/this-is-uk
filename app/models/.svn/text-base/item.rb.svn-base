class Item < ActiveRecord::Base
  belongs_to :city
  belongs_to :category
  belongs_to :subcategory
  belongs_to :subsubcategory
  belongs_to :user
  has_one :picture
  has_many :reviews
  
  def validate
    errors.add_to_base "Please enter a title" if item_name == ""
    errors.add_to_base "Please enter an address" if item_address == ""
    errors.add_to_base "Please select categories" if subsubcategory_id == nil
  end
  
  def self.index_items(city_id)
    Item.find_by_sql(["select i.id, i.item_name, i.item_tel, i.item_address, r.review, i.item_area, c.cat_sys_name, sc.subcat_sys_name, ssc.subsubcat_sys_name " +
                      "from items i inner join reviews r on r.item_id = i.id " +
                      "inner join categories c on c.id = i.category_id " +
                      "inner join subcategories sc on sc.id = i.subcategory_id " +
                      "inner join subsubcategories ssc on ssc.id = i.subsubcategory_id " +
                      "where item_city = ? " +
                      "group by i.id " +
                      "order by i.id desc, r.rev_rating desc limit 6",city_id])
  end
  
  def self.items_by_category(category,subcategory,subsubcategory,city_id)
    Item.find_by_sql(["select i.id, i.item_name, i.item_tel, i.item_address, r.review, i.item_area " +
                      "from items i left join reviews r on r.item_id = i.id " +
                      "inner join categories c on c.id = i.category_id " +
                      "inner join subcategories sc on sc.id = i.subcategory_id " +
                      "inner join subsubcategories ssc on ssc.id = i.subsubcategory_id " +
                      "where c.cat_sys_name = ? and sc.subcat_sys_name like ? and ssc.subsubcat_sys_name like ? and item_city = ? " +
                      "group by i.id",category,subcategory,subsubcategory,city_id])
  end
  
  def self.item_detail(id)
    Item.find_by_sql(["select i.id, i.item_name, i.item_tel, i.item_address, i.item_area, i.user_id " +
                      "from items i inner join categories c on c.id = i.category_id " +
                      "inner join subcategories s on s.id = i.subcategory_id " +
                      "inner join subsubcategories ss on s.id = ss.subcategory_id " +
                      "where i.id = ? limit 1", id])
  end
  
  def self.ajax_list(value)
    Item.find_by_sql(["select i.id, i.item_name, i.item_tel, i.item_area, c.cat_name, c.cat_sys_name, s.subcat_sys_name, ss.subsubcat_sys_name " +
                               "from items i inner join categories c on c.id = i.category_id " +
                               "inner join subcategories s on s.id = i.subcategory_id " +
                               "inner join subsubcategories ss on ss.id = i.subsubcategory_id " +
                               "where lower(item_name) like ?",  '%' + value.downcase + '%'])
  end
  
end