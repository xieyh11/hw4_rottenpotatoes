Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  x = page.body.split(e1)
  assert x.length == 3
  x = x[2].split(e2)
  assert x.length == 3
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(%r{\s*,\s*}).each_with_index{
    |name, index|
      if(!index)
        When %Q{I #{uncheck}check "ratings[#{name}]"}
      else
        And %Q{I #{uncheck}check "ratings[#{name}]"}
      end
  }
end

Then /I should( not)? see all of the movies/ do |orNot|
  Movie.all.each_with_index{
    |movie, index|
      name = movie[:title]
      if(!index)
        Then %Q{I should#{orNot} see "#{name}"}
      else
        And %Q{I should#{orNot} see "#{name}"}
      end
  }
end

Then /the director of "(.*)" should be "(.*)"/ do |title, director|
  m = Movie.find_by_title(title)
  assert director == m.director
end
