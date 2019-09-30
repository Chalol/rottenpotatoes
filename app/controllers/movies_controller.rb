class MoviesController < ApplicationController
    def index
        @movies = Movie.all
    end
    
    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.html.haml by default
    end
    
    def new
        @movies = Movie.new
    end
    
    def create
        @movie = Movie.create!(movie_params)
        flash[:notice] = "#{@movie.title} was successfully created."
        redirect_to movies_path
    end
    
    def movie_params
      params.require(:movie).permit(:title, :rating, :description,
    :release_date)
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
    
    def search_tmdb
      find = Tmdb::Search.new
      find.resource('movie')
      find.query("'#{params[:search_terms]}'")
      found = find.fetch
      
      if found[0] == nil
        flash[:warning] = "'#{params[:search_terms]}' was not found in TMDb!!."
      else
        found.each do |each|
          @movie = Movie.create!(title: each['title'], rating: '-',
          description: each['overview'], release_date: each['release_date'])
          
          flash[:notice] = "'#{params[:search_terms]}' was found in TMDb!!."
        end
      end
      #puts found[0]
      redirect_to movies_path
    end

end