class Movie < ActiveRecord::Base
  def self.ratings
    return self.find(:all, :select=>"distinct(rating)")
  end
end

