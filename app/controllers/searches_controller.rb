class SearchesController < ApplicationController

  # TODO possibly add join table for venues returned by a search so those can be saved along with the search (just saving midpoint atm)?
  # would this saving happen in here or in model?

  def new
    @search = Search.new
    2.times {@search.locations << Location.new}
  end

  def create
    # TODO add validation so the same search isn't saved to the
    # db more than once for the same user? then put create in an if statement
    @search = Search.new
    @search.locations = params[:search][:location].map {|location| Location.find_or_create_by(address: location[:address])}
    @search.midpoint = Midpoint.calculate(@search.locations)
    @search.save
    redirect_to search_path(@search)
  end

  def show
    @search = Search.find(params[:id])
    render 'results.html.erb'
  end

  def index
    @searches = Search.all
  end

  def destroy
    @search = Search.find(params[:id])
    @search.destroy
  end

  private

  def search_params
    params.require(:search).permit(:address, :name, :latitude, :longitude)
  end

end
