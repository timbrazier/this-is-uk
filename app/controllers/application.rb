# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  def set_destination
    session[:destination]=request.request_uri
  end
  
  def get_user
    if session[:user_id]
      @logged_in_user = User.find(session[:user_id])
    end
  end
  
  def authorize
    if session[:user_id]
      @admin_user = User.find(session[:user_id])
      if ! @admin_user
        flash[:notice] = "You are not logged in as an administrator!"
        redirect_to(:controller => "users",:action=>"login")
      else
        unless @admin_user.user_status=="admin"
          flash[:notice] = "You are not logged in as an administrator!"
          redirect_to(:controller => "users",:action=>"login")
        end
      end
    else
      flash[:notice] = "You are not logged in as an administrator!"
      redirect_to(:controller => "users",:action=>"login")
    end
  end
  
  def get_all_categories
    @areas = Area.find(:all,
                       :conditions => "city_id = #{@current_city.id}",
                       :order => "area_name")
    @categories = Category.find(:all,:order=>"cat_sys_name")
    if params[:cat_sys_name]
      @category = Category.find_by_cat_sys_name(params[:cat_sys_name])
    else
      @category = @categories[0]
    end
    @subcategories = @category.subcategories
    if params[:subcat_sys_name] && params[:subcat_sys_name] != "all"
      @subcategory = Subcategory.find_by_subcat_sys_name(params[:subcat_sys_name])
    else
      @subcategory = @subcategories[0]
    end
    @subsubcategories = @subcategory.subsubcategories
  end
  
  def get_city
    current_url = request.host.split(".")
    if current_url[1]=="info"
      city_part = current_url[0].gsub("thisis","")
    elsif current_url.nitems==1
      city_part = "sheffield"
    else
      city_part = current_url[1].gsub("thisis","")
    end
    @current_city = City.find_by_city_name(city_part)
    if !@current_city
      redirect_to("http://www.peoplesguide.info")
      #@current_city = City.find(1)
    end
  end
  
  def add_city_to_apache(city)
    Thread.current['user'] = 'rails'
    f = File.new("#{RAILS_ROOT}/domains/" + city.city_name,"w+")
    f.puts "ServerAlias thisis" + city.city_name + ".info\n"
    f.puts "ServerAlias *.thisis" + city.city_name + ".info\n" 
    f.close
  end

end