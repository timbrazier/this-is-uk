# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 4) do

  create_table "areas", :force => true do |t|
    t.column "city_id",       :integer, :limit => 6,  :default => 0,  :null => false
    t.column "area_name",     :string,  :limit => 64, :default => "", :null => false
    t.column "abb_area_name", :string,  :limit => 24, :default => "", :null => false
  end

  create_table "categories", :force => true do |t|
    t.column "cat_name",     :string,   :limit => 32, :default => "", :null => false
    t.column "cat_sys_name", :string,   :limit => 32, :default => "", :null => false
    t.column "cat_style",    :string,   :limit => 24, :default => "", :null => false
    t.column "created_at",   :datetime,                               :null => false
  end

  add_index "categories", ["cat_style"], :name => "cat_style", :unique => true

  create_table "cities", :force => true do |t|
    t.column "city_name",     :string, :limit => 24, :default => "", :null => false
    t.column "city_longname", :string, :limit => 64, :default => "", :null => false
    t.column "city_image",    :string
    t.column "site_name",     :string
    t.column "phone_prefix",  :string
  end

  create_table "contact_requests", :force => true do |t|
    t.column "created_at", :datetime,                                :null => false
    t.column "name",       :string,   :limit => 100, :default => "", :null => false
    t.column "email",      :string,   :limit => 100, :default => "", :null => false
    t.column "phone",      :string,   :limit => 100, :default => "", :null => false
    t.column "message",    :text,                                    :null => false
  end

  create_table "images", :force => true do |t|
    t.column "item_id",             :integer, :limit => 6,                                :default => 0,   :null => false
    t.column "image_rating",        :decimal,               :precision => 3, :scale => 2, :default => 0.0, :null => false
    t.column "image_review",        :integer, :limit => 6,                                :default => 0,   :null => false
    t.column "image_fname",         :string,  :limit => 32,                               :default => "",  :null => false
    t.column "image_desc",          :string,                                              :default => "",  :null => false
    t.column "image_uploaded_user", :integer, :limit => 6,                                :default => 0,   :null => false
    t.column "image_modevent",      :integer, :limit => 6,                                :default => 0,   :null => false
    t.column "image_status",        :string,  :limit => 0,                                :default => "0", :null => false
  end

  add_index "images", ["id"], :name => "image_id", :unique => true
  add_index "images", ["item_id"], :name => "image_item"
  add_index "images", ["image_review"], :name => "image_review"

  create_table "items", :force => true do |t|
    t.column "item_name",          :string,   :limit => 64,                               :default => "",  :null => false
    t.column "item_status",        :string,   :limit => 0,                                :default => "0", :null => false
    t.column "category_id",        :integer,  :limit => 6,                                :default => 0,   :null => false
    t.column "subcategory_id",     :integer,  :limit => 6,                                :default => 0,   :null => false
    t.column "subsubcategory_id",  :integer,                                              :default => 0,   :null => false
    t.column "item_cat2",          :integer,  :limit => 6,                                :default => 0,   :null => false
    t.column "item_subcat_cat2",   :integer,  :limit => 6,                                :default => 0,   :null => false
    t.column "item_image_index",   :integer,  :limit => 6,                                :default => 0,   :null => false
    t.column "item_avrating",      :decimal,                :precision => 3, :scale => 2, :default => 0.0, :null => false
    t.column "item_avpricing",     :decimal,                :precision => 3, :scale => 2, :default => 0.0, :null => false
    t.column "item_created_date",  :integer,  :limit => 10,                               :default => 0,   :null => false
    t.column "item_created_user",  :integer,  :limit => 6,                                :default => 0,   :null => false
    t.column "item_modified_date", :integer,  :limit => 10,                               :default => 0,   :null => false
    t.column "item_modified_user", :integer,  :limit => 6,                                :default => 0,   :null => false
    t.column "mod_event",          :integer,  :limit => 6,                                :default => 0,   :null => false
    t.column "item_url",           :string,   :limit => 64,                               :default => "",  :null => false
    t.column "item_tel",           :string,   :limit => 24,                               :default => "",  :null => false
    t.column "item_address",       :string,                                               :default => "",  :null => false
    t.column "item_pocode",        :string,   :limit => 12,                               :default => "",  :null => false
    t.column "item_area",          :string
    t.column "item_city",          :integer,  :limit => 6,                                :default => 0,   :null => false
    t.column "created_at",         :datetime,                                                              :null => false
    t.column "user_id",            :integer,                                              :default => 0,   :null => false
    t.column "approved",           :string,   :limit => 1,                                :default => "0", :null => false
    t.column "city_id",            :integer
    t.column "wifi",               :integer,  :limit => 4,                                :default => 0,   :null => false
  end

  add_index "items", ["category_id", "item_created_user", "item_city"], :name => "item_cat1"
  add_index "items", ["item_status"], :name => "item_status"

  create_table "modevents", :id => false, :force => true do |t|
    t.column "mod_event_id",   :integer, :limit => 6,                 :null => false
    t.column "mod_event_code", :integer, :limit => 4,  :default => 0, :null => false
    t.column "mod_item_id",    :integer, :limit => 6,  :default => 0, :null => false
    t.column "mod_review_id",  :integer, :limit => 6,  :default => 0, :null => false
    t.column "mod_user_id",    :integer, :limit => 6,  :default => 0, :null => false
    t.column "mod_moddate",    :integer, :limit => 10, :default => 0, :null => false
  end

  create_table "review_ratings", :force => true do |t|
    t.column "review_id",  :integer,  :default => 0, :null => false
    t.column "user_id",    :integer,  :default => 0, :null => false
    t.column "created_at", :datetime,                :null => false
  end

  create_table "reviews", :force => true do |t|
    t.column "item_id",           :integer,  :limit => 6,                                :default => 0,   :null => false
    t.column "user_id",           :integer,                                              :default => 0,   :null => false
    t.column "image_id",          :integer,  :limit => 6,                                :default => 0,   :null => false
    t.column "rev_title",         :string,   :limit => 36,                               :default => "",  :null => false
    t.column "review",            :text,                                                                  :null => false
    t.column "rev_comments",      :text,                                                                  :null => false
    t.column "rev_status",        :string,   :limit => 0,                                :default => "0", :null => false
    t.column "rev_rating",        :decimal,                :precision => 3, :scale => 2, :default => 0.0, :null => false
    t.column "rev_value",         :decimal,                :precision => 3, :scale => 2, :default => 0.0, :null => false
    t.column "rev_child",         :decimal,                :precision => 3, :scale => 2, :default => 0.0, :null => false
    t.column "rev_mod_rating",    :decimal,                :precision => 3, :scale => 2, :default => 0.0, :null => false
    t.column "rev_mod_event",     :integer,  :limit => 6,                                :default => 0,   :null => false
    t.column "rev_created",       :integer,  :limit => 10,                               :default => 0,   :null => false
    t.column "rev_created_user",  :integer,  :limit => 6,                                :default => 0,   :null => false
    t.column "rev_modified",      :integer,  :limit => 10,                               :default => 0,   :null => false
    t.column "rev_modified_user", :integer,  :limit => 6,                                :default => 0,   :null => false
    t.column "created_at",        :datetime,                                                              :null => false
    t.column "approved",          :string,   :limit => 1,                                :default => "0", :null => false
    t.column "total_rating",      :integer,                                              :default => 0,   :null => false
  end

  add_index "reviews", ["item_id", "image_id", "rev_mod_event"], :name => "rev_item"
  add_index "reviews", ["review", "rev_comments"], :name => "rev_desc"

  create_table "sessions", :force => true do |t|
    t.column "sessid",     :string,   :limit => 32, :default => "", :null => false
    t.column "data",       :text,                                   :null => false
    t.column "created_at", :datetime,                               :null => false
  end

  add_index "sessions", ["sessid"], :name => "sessid"

  create_table "subcategories", :force => true do |t|
    t.column "category_id",     :integer, :limit => 6,  :default => 0,  :null => false
    t.column "subcat_name",     :string,  :limit => 24, :default => "", :null => false
    t.column "subcat_sys_name", :string,  :limit => 32, :default => "", :null => false
  end

  create_table "subsubcategories", :force => true do |t|
    t.column "subcategory_id",     :integer,               :default => 0,  :null => false
    t.column "subsubcat_name",     :string,  :limit => 32, :default => "", :null => false
    t.column "subsubcat_sys_name", :string,  :limit => 32, :default => "", :null => false
  end

  create_table "users", :force => true do |t|
    t.column "created_at",     :datetime,                                                                 :null => false
    t.column "username",       :string,   :limit => 18,                               :default => "",     :null => false
    t.column "password",       :string,   :limit => 18,                               :default => "",     :null => false
    t.column "first_name",     :string,   :limit => 18,                               :default => "",     :null => false
    t.column "last_name",      :string,   :limit => 24,                               :default => "",     :null => false
    t.column "email",          :string,   :limit => 64,                               :default => "",     :null => false
    t.column "user_rating",    :decimal,                :precision => 3, :scale => 2, :default => 0.0,    :null => false
    t.column "user_joindate",  :integer,  :limit => 10,                               :default => 0,      :null => false
    t.column "user_lastlogin", :integer,  :limit => 10,                               :default => 0,      :null => false
    t.column "user_status",    :string,   :limit => 0,                                :default => "user", :null => false
    t.column "user_active",    :string,   :limit => 0,                                :default => "0",    :null => false
  end

  add_index "users", ["username", "password"], :name => "user_name"

end
