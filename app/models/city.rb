class City < ActiveRecord::Base

  validates_presence_of :city_longname
  validates_uniqueness_of :city_longname
  
  def before_create
    self.city_name = self.city_longname.gsub(" ","").downcase
  end


end
