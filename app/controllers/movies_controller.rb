class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort_by = params[:by]
    @pfilter = params[:ratings]
    if @sort_by == nil and @pfilter == nil and session[:params] 
      redirect_to movies_path(session[:params])
    end

    if @pfilter == nil and session[:filter] 
      @pfilter = session[:filter]
    end

    @all_ratings = {}
    Movie.ratings.each{ |row|  @all_ratings[row.rating] = (@pfilter == nil) }
    
    filter = {}
    if @pfilter
      filter[:rating] = []
      for item, _ in @pfilter do 
        filter[:rating] << item
        @all_ratings[item] = true
      end
    end

    order = nil
    if @sort_by == 'title' 
      order = 'title'
    elsif @sort_by == 'date' 
      order = 'release_date'
    end

    @params = {:by => @sort_by, :ratings => @pfilter }
    @movies = Movie.find(:all, :conditions=> filter, :order => order ) 
    session[:params] = @params
    session[:filter] = @pfilter
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path(session[:params])
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path(session[:params])
  end

end
