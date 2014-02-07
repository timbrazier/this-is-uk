class AddSiteNameToCities < ActiveRecord::Migration
  def self.up
    add_column :cities, :site_name, :string
  end

  def self.down
    remove_column :cities, :site_name
  end
end
