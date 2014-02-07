module GuideHelper

def full_address(address,area,tel)
  address + ", " + area + ", " + tel
end

def review_rater(item,review,user)
  @this_item = Item.find(item)
  @this_review = Review.find(review)
  @this_user = User.find(user)
  all_ratings_for_review = ReviewRating.find_all_by_review_id_and_user_id(@this_review.id,@this_user.id)
  if all_ratings_for_review.nitems == 0
    render(:partial=>"review_rater_widget")
  end
end

end
