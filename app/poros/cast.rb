# frozen_string_literal: true

# app/poros/cast.rb
class Cast
  attr_reader :character,
              :name

  def initialize(attributes)
    @character = attributes[:character]
    @name = attributes[:name]
  end
end
