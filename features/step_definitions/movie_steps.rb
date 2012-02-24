# Add a declarative step here for populating the DB with movies.



#Then the director of "Alien" should be "Ridley Scott" 
Then /the director of "(.*)" should be "(.*)"/ do |e1, e2|
  movie = Movie.find(:first, :conditions => ["title=?", e1])
  assert movie.director == e2
end



Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(:title => movie[:title], 
		  :release_date => movie[:release_date],
		  :rating => movie[:rating])
  end
#  assert false, "Unimplmemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  #puts /.*#{e1}.*#{e2}.*/.match(page.body)
  #check = page.body =~ /.*<td>#{e1}.*<td>#{e2}.*/
  assert /.*#{e1}.*#{e2}.*/.should match(page.text.gsub(/\n/,''))

  #assert false, "Unimplmemented"
end

Then /I should see all the movies/ do 

  page.should have_css "table#movies tr", :count =>Movie.all.count + 1
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  list = rating_list.delete(' ').split(',')
  if uncheck
     begin
	list.each do |rate|
	step %Q{I uncheck "ratings_#{rate}"}
 	end
     end
  else
     begin
  	list.each do |rate|
     	step %Q{I check "ratings_#{rate}"}
  	end
     end
  end
end
