class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def self.find_movies_by_director(director)
    find_same_by_director(director)
  end
end
