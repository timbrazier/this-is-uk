class Review < ActiveRecord::Base
  belongs_to :item
  belongs_to :user
  has_many :review_ratings

  def validate
    errors.add_to_base "Please enter a description" if review == ""
    errors.add_to_base "Please don't use profane or abusive language" if review =~ /shit/ || review =~ /fuck/ || review =~/cunt/
  end
  
  def self.average_rating_for_user(user)
    Review.find_by_sql(["select avg(rev_rating) as rating from reviews where user_id = ?",user])
  end
  
  def self.average_rating_for_item(item)
    Review.find_by_sql(["select avg(rev_rating) as rating, avg(rev_value) as value from reviews where item_id = ?",item])
  end
  
end
