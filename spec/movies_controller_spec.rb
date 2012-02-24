require 'spec_helper'


describe Movie do
  describe "calls movie model methods" do
  it "call new created method find same by director" do
    fake_movie = mock('Movie')
    fake_movie.stub(:director).and_return("Johnson")
    Movie.find_movies_by_director(fake_movie.director)
  end
  end

end

describe MoviesController do
  describe 'Restful route for Find Similar Movies' do
    before :each do
     @fake_movie = mock('Movie')
     @fake_movie.stub(:title).and_return("fake")
     @fake_movie.stub(:rating).and_return("G")
     @fake_movie.stub(:director).and_return ("Johnson")
     @fake_movie.stub(:id).and_return(1)
     @fake_movie.stub(:release_date).and_return("2011-11-11")
    end
    
    it 'creates movie' do
     post :create, {:title => @fake_movie.title,
                    :rating => @fake_movie.rating,
                    :director => @fake_movie.director,
                    :release_date => @fake_movie.release_date}
     response.should redirect_to movies_path
    end
    
    it 'deletes movie' do
     post :create, {:title => @fake_movie.title,
                    :rating => @fake_movie.rating,
                    :director => @fake_movie.director,
                    :release_date => @fake_movie.release_date}
     post :destroy, {:id => @fake_movie.id}
     response.should redirect_to movies_path
    end
    
  end
  
  describe 'Controller method to receive the click on "Find with same director"' do
    before :each do
     @fake_movie = mock('Movie')
     @fake_movie.stub(:director).and_return('George Lucas')
     Movie.should_receive(:find_by_id).and_return(@fake_movie)
     @fake_movies = [mock('Movie', :title=>'THX-1138', 
                                   :rating=>'R', 
                                   :director => 'George Lucas')]
     Movie.should_receive(:find_all_by_director).and_return(@fake_movies)
    end
    
    it 'show list of movies'do
     get :findmovieswithsamedirector, {:id=>'1'}
    end
    
    it 'renders the view' do
     get :findmovieswithsamedirector, {:id=>'2'}
     response.should render_template('findmovieswithsamedirector')
    end
    
    it 'get correct movies' do
     get :findmovieswithsamedirector, {:id=>'1'}
     assigns(:same_director_movies).should == @fake_movies
    end
  end
  
  describe 'cant find movies and return to home page' do
    it 'controller method redirect back to home page'do
      fake_movie = mock('Movie')
      fake_movie.stub(:title).and_return("Alien")
      fake_movie.stub(:director)
    
      Movie.should_receive(:find_by_id).and_return (fake_movie)
      Movie.should_not_receive(:find_all_by_director).and_return(fake_movie)
     get :findmovieswithsamedirector, {:id => '3'}
     response.should redirect_to movies_path
    end
    
  end
 
end
