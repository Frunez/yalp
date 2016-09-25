class RestaurantsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end


  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user
    if @restaurant.save
      redirect_to '/restaurants'
    else
      render 'new'
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.user != current_user
      flash[:notice] = 'Cannot edit a restaurant you don\'t own'
      redirect_to restaurants_path
    end
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    @restaurant.update(restaurant_params)

    redirect_to restaurants_path
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.destroy_with_user(current_user)
      flash[:notice] = 'Restaurant deleted successfully'
    else
      flash[:notice] = 'Cannot delete a restaurant you don\'t own'
    end
    redirect_to restaurants_path
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :image)
  end

end