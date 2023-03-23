 # frozen_string_literal: true

# app/poros/review.rb
class Review
  attr_reader :character,
              :name

  def initialize(attributes)
    @author = attributes[:author]
    @rating = attributes[:author_details][:rating]
    @content = attributes[:content]
  end
end
