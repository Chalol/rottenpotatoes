Myrottenpotatoes::Application.routes.draw do
  resources :movies
  # Route that posts 'Search TMDb' form
  post '/movies/search_tmdb'
  root :to => redirect('/movies')
end