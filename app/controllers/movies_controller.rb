class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort_column = params[:sort] || "title"
    @css_class_title = sort_column == "title" ? "hilite" : nil
    @css_class_release = sort_column == "release_date" ? "hilite" : nil
    @movies = Movie.order(sort_column)
    if params[:ratings]
      @movies = Movie.where(params[:ratings].present? ? {:rating => (params[:ratings].keys)} :{}).order(params[:sort])
    end
    @available_ratings = Movie.all_ratings
    @ratings_selected = []
    if !params[:ratings].nil?
      params[:ratings].each_key do |key|
        @ratings_selected << key
      end
    elsif
      @ratings_selected = @available_ratings
    end
    @set_ratings = params[:ratings]
    if !@set_ratings
      @set_ratings = Hash.new
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end