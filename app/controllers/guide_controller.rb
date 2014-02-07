class GuideController < ApplicationController

before_filter :set_destination
before_filter :get_city
before_filter :get_user, :except => :get_user

  def auto_complete_for_item_item_name
    auto_complete_responder_for_items params[:item][:item_name]
  end
  
  auto_complete_for :area, :area_name
  
  def index
    @page_title="Rate, review & promote places to eat, stay, hang out and shop in " + @current_city.city_longname
    @categories = Category.find(:all,
                                :order => "id")
    @items = Item.index_items(@current_city.id)
  end
  
  def transfer
      if ! session[:user_id]
        redirect_to(:controller => "users", :action => "login")
      else
        redirect_to(:action=>"add_item",:cat_sys_name => params[:cat_sys_name])
      end
  end
  
  def categories
    get_cat_lists(params[:cat_sys_name],params[:subcat_sys_name])
    @category = Category.find(:first,
                              :conditions => ["cat_sys_name = ?",params[:cat_sys_name]])
    @subcategory = Subcategory.find(:first,
                                    :conditions => ["subcat_sys_name = ?",params[:subcat_sys_name]])
    subcategory = params[:subcat_sys_name]
    if subcategory == "all"
      subcategory = "%"
    end
    subsubcategory = params[:subsubcat_sys_name]
    if subsubcategory == "all"
      subsubcategory = "%"
    end
    @items = Item.items_by_category(params[:cat_sys_name],subcategory,subsubcategory,@current_city.id)
    
    category = Category.get_cat(params[:cat_sys_name]).cat_name
    begin
      subcategory = Subcategory.get_subcat(params[:subcat_sys_name]).subcat_name
    rescue
      subcategory = "All"
    end
    
    begin 
      subsubcategory = Subsubcategory.get_subsubcat(params[:subsubcat_sys_name]).subsubcat_name
    rescue
      subsubcategory = "All"
    end
    
    case subcategory
      when "All"
        @page_title = subcategory + " " + category + " in #{@current_city.city_longname}"
      else
        @page_title = subsubcategory + " " + subcategory + " in #{@current_city.city_longname}"
    end
    capture_categories
  end
  
  def detail
    get_cat_lists(params[:cat_sys_name],params[:subcat_sys_name])
    @items = Item.item_detail(params[:id])
    @item = @items[0]
    @reviews = Review.find(:all,
                           :conditions => ["item_id = :id",params])#,
                          # :joins      => "as r inner join users u on r.user_id = u.id")
    #Start calculating the averages...
    rating_average = 0
    value_average = 0
    child_average = 0
    @reviews.each do |review|
      rating_average = rating_average + review.rev_rating
      value_average = value_average + review.rev_value
      child_average = child_average + review.rev_child
    end
    if @reviews.nitems > 0
      rating_average = rating_average / @reviews.nitems
      value_average = value_average / @reviews.nitems
      child_average = child_average / @reviews.nitems
      #Grade the curve...
      rating_average = (rating_average - 0.5) * 1.25
      value_average = (value_average - 0.5) * 1.25
      child_average = (child_average - 0.5) * 1.25
      @rating_average = rating_average.to_i
      @value_average = value_average.to_i
      @child_average = child_average.to_i
      @add_review_text = "Add a review"
    else
      @rating_average = 0
      @value_average = 0
      @child_average = 0
      @add_review_text = "Be the first to review this item"
    end
    #Lastly, see if a currently logged-in user has already submitted a review...
    @only_one_review_per_user = Review.find(:all,
                                           :conditions => ["item_id = ? and user_id = ?",params[:id],session[:user_id]])
    #and whether they've also rated the review!                        
  end
  
  def helpfulness
    @this_review = Review.find(params[:id])
    current_rating = @this_review.total_rating
    case params[:direction]
      when "up"
        delta = 1
      when "down"
        delta = -1
    end
    #Update the total rating score for this review
    @this_review.update_attributes(:total_rating => (current_rating + delta).to_s)
    redirect_to(:action=>"detail",
                :cat_sys_name => params[:cat_sys_name],
                :subcat_sys_name => params[:subcat_sys_name],
                :subsubcat_sys_name => params[:subsubcat_sys_name],
                :id => params[:item])
    ReviewRating.create(:review_id => @this_review.id,
                        :user_id => session[:user_id])
  end
  
  def add_review
    @item = Item.find(params[:id])
    if ! session[:user_id]
      redirect_to(:controller => "users", :action => "login")
    end
    if request.post?
      @review = Review.new(params[:review])
      @review.item_id = @item.id
      @review.user_id = session[:user_id]
      if @review.save
        flash[:notice] = "Your review has been added."
        redirect_to(:action => "detail", :cat_sys_name => params[:cat_sys_name],:subcat_sys_name => params[:subcat_sys_name],:subsubcat_sys_name => params[:subsubcat_sys_name],:id => @item.id)
      end
    end
  end
  
  def suggest_new
    if ! session[:user_id]
      redirect_to(:controller => "users", :action => "login")
    end
  end
  
  def add_business
    if ! session[:user_id]
      redirect_to(:controller => "users", :action => "login")
    end
    get_all_categories
    @item = Item.new
    if request.post?
      @item = Item.new(params[:item])
      @item.city = @current_city
      if @item.save
        @item.update_attributes(
          :item_area => params[:area][:area_name],
          :category_id => params[:item][:category_id],
          :subcategory_id => params[:item][:subcategory_id],
          :subsubcategory_id => params[:item][:subsubcategory_id]
          )
        if params[:ownership]
          @item.update_attributes(:user_id => session[:user_id])
         end
        flash[:notice] = "Your business has been added."
        redirect_to(:action=>"detail",:id=>@item.id)
      end
    end
  end
  
  def add_item
      if ! session[:user_id]
        redirect_to(:controller => "users", :action => "login")
      end
      category = Category.find_by_cat_sys_name(params[:cat_sys_name])
      @areas = Area.find(:all,
                         :conditions => "city_id = #{@current_city.id}",
                         :order => "area_name")
                         
      @subcategory = Subcategory.find_by_subcat_sys_name(session[:subcat_sys_name])
      @subsubcategory = Subsubcategory.find_by_subsubcat_sys_name(session[:subsubcat_sys_name])
      @subcategories = Subcategory.find(:all,
                                        :order => "subcat_name",
                                        :conditions => ["category_id = ?",category.id])
      if @subcategory
        @subsubcategories = Subsubcategory.find(:all,
                                                :order => "subsubcat_name",
                                                :conditions => ["subcategory_id = ?",@subcategory.id])
      end
      if request.post?
      @item = Item.new(
          :item_name          => params[:item_name],
          :category_id        => category.id,
          :subcategory_id     => params[:subcategory_id],
          :subsubcategory_id  => params[:subsubcategory_id],
          :item_area          => params[:area][:area_name],
          :item_url           => params[:item_url],
          :item_tel           => params[:item_tel],
          :item_address       => params[:item_address],
          :item_pocode        => params[:item_pocode],
          :user_id            => @logged_in_user.id
          )
          @item.city = @current_city
        if @item.save
          if params[:ownership]
            @item.update_attributes(:user_id => session[:user_id])
            flash[:notice] = "Your item has been added, and you have been listed as the owner."
          else
            flash[:notice] = "Your item has been added."
          end
          redirect_to(:action=>"detail",:id=>@item.id)
        end
      end
  end
  
  def add_subcat
    if ! session[:user_id]
      redirect_to(:controller => "users", :action => "login")
    end
      @categories = Category.find(:all,
                                  :order => "id")
      if request.post?
      @subcategory = Subcategory.new(
          :category_id      => params[:category_id],
          :subcat_name      => params[:subcat_name],
          :subcat_sys_name  => params[:subcat_sys_name]
          )
        if @subcategory.save
          flash[:notice] = "Your subcategory has been added."
        end
      end
  end
  
  def add_subsubcat
    if ! session[:user_id]
      redirect_to(:controller => "users", :action => "login")
    end
      @categories = Category.find(:all,
                                  :order => "id")
      @subcategories = Subcategory.find(:all,
                                  :order => "id")
      if request.post?
      @subsubcategory = Subsubcategory.new(
          :subcategory_id     => params[:item][:subcategory_id],
          :subsubcat_name     => params[:subsubcat_name],
          :subsubcat_sys_name => params[:subsubcat_sys_name]
          )
        if @subsubcategory.save
          flash[:notice] = "Your subsubcategory has been added."
        end
      end
  end
  
  def add_area
    if ! session[:user_id]
      redirect_to(:controller => "users", :action => "login")
    end
      if request.post?
      @area = Area.new(
          :area_name    => params[:area_name],
          :city_id      => @current_city.id
          )
        if @area.save
          flash[:notice] = "Your area has been added."
        end
      end
  end
  
  def add_city
    if ! session[:user_id]
      redirect_to(:controller => "users", :action => "login")
    end
    @newcity = City.new
      if request.post?
      @newcity = City.new(params[:city])
        if @newcity.save
          flash[:notice] = "Your city has been added."
          #add_city_to_apache(@newcity)
        else
          flash[:notice] = "Couldn't save that city - you either entered a blank, or the city is already in the database."
        end
      end
  end
  
  def one_list
    @subcategory = request.raw_post
    @subsubcategories = Subsubcategory.find(:all,
                                            :conditions => "subcategory_id=#{@subcategory}",
                                            :order => "subsubcat_sys_name")
  end
  
  def subcat_list
    category = request.raw_post
    @subcategories = Subcategory.find(:all,
                                      :conditions => "category_id=#{category}",
                                      :order => "subcat_sys_name")
  end
  
  def subsubcat_list
    subcategory = params[:subcategory]
    @subsubcategories = Subsubcategory.find(:all,
                                            :conditions => "subcategory_id=#{subcategory}")
  end
  
  def both_lists
    all_params = params[:item]
    category = all_params["category_id"]
    @selected_subcat = all_params["subcategory_id"]
    @selected_subsubcat = all_params["subsubcategory_id"]
    @subcategories = Subcategory.find(:all,
                                      :conditions => "category_id = #{category}",
                                      :order => "subcat_sys_name")
    @subsubcategories = Subsubcategory.find(:all,
                                            :conditions => "subcategory_id=#{@selected_subcat}",
                                            :order => "subsubcat_sys_name")
  end
  
  def take_ownership
    @item = Item.find(params[:id])
    @item.update_attributes(:user_id => session[:user_id])
    flash[:notice] = "You have taken ownership of this item."
    redirect_to(:action=>"detail", :cat_sys_name => params[:cat_sys_name], :subcat_sys_name => params[:subcat_sys_name], :subsubcat_sys_name => params[:subsubcat_sys_name], :id => @item.id)
  end
  
  def contact
    @contact_request = ContactRequest.new
    if request.post?
      @contact_request = ContactRequest.new(params[:contact_request])
      if @contact_request.save
      email = ContactMailer.create_contact_request(@contact_request)
      email.set_content_type("text/html")
      ContactMailer.deliver(email)
      flash[:notice] = '<span id="flash_ok">Your login details have been emailed to you</span>'
        flash[:notice] = "Thanks - we'll be in touch soon."
        redirect_to(:action=>"index")
      end
    end
  end
  
  def fix_all_missing_subcats
    @subcategories = Subcategory.find(:all,
                                      :conditions => "id not in (select subcategory_id from subsubcategories)")
    for subcategory in @subcategories
      Subsubcategory.create(:subcategory_id => subcategory.id,
                            :subsubcat_name => "General",
                            :subsubcat_sys_name => "general")
    end
  end
    
  private
  def auto_complete_responder_for_items(value)
    @items = Item.ajax_list(value)
    render :partial => 'items_list'
  end
  
  def get_cat_lists(cat_sys_name,subcat_sys_name)
    @categories = Category.find(:all,
                                :order => "id")
    @subcategories = Subcategory.get_subcat_list(cat_sys_name)
    @subsubcategories = Subsubcategory.get_subsubcat_list(subcat_sys_name)
  end
  
  def capture_categories
    session[:subcat_sys_name] = params[:subcat_sys_name]
    session[:subsubcat_sys_name] = params[:subsubcat_sys_name]
  end
  
end
