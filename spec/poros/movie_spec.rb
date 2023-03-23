# frozen_string_literal: true

require 'rails_helper'

describe Movie do
  it 'exists' do
    attrs = {
      id: 1,
      title: 'The Godfather',
      vote_average: 4.8
    }

    godfather = Movie.new(attrs)

    expect(godfather).to be_a Movie
    expect(godfather.id).to eq(1)
    expect(godfather.title).to eq('The Godfather')
    expect(godfather.vote_average).to eq(4.8)
  end

end
