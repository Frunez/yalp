class ReviewsController < ApplicationController

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.build_with_user(review_params, current_user)

    if @review.save
      redirect_to restaurants_path
    else
      if @review.errors[:user]
        redirect_to restaurants_path, alert: 'You have already reviewed this restaurant'
      else
        render :new
      end
    end
    # @review = Review.new(review_params)
    # @review.restaurant = @restaurant
    # @review.user = current_user
    # @review.save
    # @restaurant.reviews.create(review_params)
    # redirect_to '/restaurants'
  end

  def destroy
    review = Review.find(params[:id])
    if review.destroy_with_user(current_user)
      flash[:notice] = 'Review has been deleted'
    else
      flash[:notice] = 'Cannot delete someone else\'s review'
    end
    redirect_to restaurants_path
  end

  private

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end
end
