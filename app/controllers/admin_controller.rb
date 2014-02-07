class AdminController < ApplicationController

before_filter :authorize
before_filter :set_destination

  def index
    get_pending_reviews
    get_pending_items
    @all_items = Item.find(:all,:order=>:item_name)
    if request.post?
      if params[:all_items]
        redirect_to(:action=>"item_detail",:id=>params[:all_items])
      end
    end
  end
  
  def delete_item
    @item = Item.find(params[:id])
    @reviews=@item.reviews.nitems
    if request.post?
      @item.destroy
      Review.delete_all(["item_id = ?",params[:id]])
      redirect_to(:action=>"index")
    end
  end

  def review_detail
    get_pending_reviews    
    @this_review = Review.find(params[:id])
    @review_index = 0
    for review in @pending_reviews
      @review_index += 1
      if @this_review.id == review.id
        @next_review_index = @review_index  
      end
    end
    @next_review = @pending_reviews[@next_review_index]
    @this_user = User.find(@this_review.user_id)
    @this_item = Item.find(@this_review.item_id)
    @recent_reviews_of_item = Review.find(:all,
                                          :conditions => ["item_id = ? and rev_status<>'0'",@this_item.id],
                                          :limit => 10,
                                          :order => "id desc")
    @all_reviews_of_item = Review.find(:all,
                                       :conditions => ["item_id = ?",@this_item.id])
    @recent_reviews_by_user = Review.find(:all,
                                          :conditions => ["user_id = ?",@this_user.id],
                                          :limit => 10,
                                          :order => "id desc")
    @all_reviews_by_user = Review.find(:all,
                                          :conditions => ["user_id = ?",@this_user.id])
    @user_average = (Review.average_rating_for_user(@this_user.id)[0].rating.to_f / 0.05).to_s + "%"
    @item_average_rating = Review.average_rating_for_item(@this_item.id)[0].rating.to_i
    @item_average_value = Review.average_rating_for_item(@this_item.id)[0].value.to_i
    if @item_average_value / @this_review.rev_rating > 2 || @item_average_value / @this_review.rev_rating < 0.25
      @item_alert = "Warning: Differs significantly from average"
    else
      @item_alert = "&nbsp;"
    end
  end
  
  def item_detail
    @item = Item.find(params[:id])
    @recent_reviews_of_item = Review.find(:all,
                                          :conditions => ["item_id = ? and rev_status<>'0'",@item.id],
                                          :limit => 10,
                                          :order => "id desc")
    @all_reviews_of_item = Review.find(:all,
                                       :conditions => ["item_id = ?",@item.id])
    @item_average_rating = Review.average_rating_for_item(@item.id)[0].rating.to_i
    @item_average_value = Review.average_rating_for_item(@item.id)[0].value.to_i
    @categories = Category.find(:all)
    @subcategories = Subcategory.find(:all)
    @subsubcategories = Subsubcategory.find(:all)
    @areas = Area.find(:all)
    if request.post?
      if @item.update_attributes(params[:item])
        redirect_to(:action => "index")
      end
    end
  end
  
  def delete_review
    Review.find(params[:id]).destroy
    flash[:notice] = "Review deleted."
    redirect_to(:action=>"index")
  end

  def hold_review
    Review.find(params[:id]).update_attributes(:hold => "1")
    redirect_to(:action=>"index")
  end
  
  def update_review_status
    Review.find(params[:id]).update_attributes(:rev_status => params[:status])
    flash[:notice] = "Review accepted."
    redirect_to(:action=>"index")
  end

  def user_detail
    @user = User.find(params[:id])
  end
  
  def block_user
    User.find(params[:id]).update_attributes(:user_status => "blocked")
    flash[:notice] = "User blocked."
    redirect_to(:action=>"index")
  end
  
  def get_pending_reviews
    @pending_reviews = Review.find(:all,
                                   :conditions => ["rev_status = '0'"],
                                   :order => "id desc")
  end
  
  def get_pending_items
    @pending_items = Item.find(:all,
                               :conditions => ["approved = '0'"],
                               :order => "id desc")
  end

  def skip_review
    redirect_to(:action=>"review_detail",:id=>params[:next])
  end
  
  def fix_domains
    Dir.chdir("#{RAILS_ROOT}/public/domains/")
        File.readlines("domains.txt").each do |line|
        this_domain = line.gsub("\r\n","")
        this_domain = this_domain.gsub("^M","")
        f = File.new(this_domain.gsub(".info",""),"w+")
        f.puts "ServerAlias " + this_domain
        f.puts "ServerAlias *." + this_domain
        f.close
    end
  end
end
