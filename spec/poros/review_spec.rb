# frozen_string_literal: true

require 'rails_helper'

describe Review do
  it 'has attributes' do
    attr = {
      author: 'MSB',
      author_details: {
        name: 'MSB',
        username: 'msbreviews',
        avatar_path: '/https://www.gravatar.com/avatar/992eef352126a53d7e141bf9e8707576.jpg',
        rating: 6.0
      },
      content: "FULL SPOILER-FREE REVIEW @ https://www.msbreviews.com/movie-reviews/cocaine-bear-review\r\n\r\n\"COCAINE BEAR offers what one expects from it: an absolutely INSANE bear wreaking gory, bloody havoc while also doing the stupidest things imaginable. A totally nonsensical yet extremely entertaining time where nothing else matters besides the bear who did cocaine.\"\r\n\r\nRating: B-",
      created_at: '2023-02-23T21:14:37.835Z',
      id: '63f7d73d68b1ea0079cc0a45',
      updated_at: '2023-02-23T21:14:37.955Z',
      url: 'https://www.themoviedb.org/review/63f7d73d68b1ea0079cc0a45'
    }

    review = Review.new(attr)

    expect(review).to be_a Review
    expect(review.author).to eq('MSB')
    expect(review.rating).to eq(6.0)
    expect(review.content).to eq("FULL SPOILER-FREE REVIEW @ https://www.msbreviews.com/movie-reviews/cocaine-bear-review\r\n\r\n\"COCAINE BEAR offers what one expects from it: an absolutely INSANE bear wreaking gory, bloody havoc while also doing the stupidest things imaginable. A totally nonsensical yet extremely entertaining time where nothing else matters besides the bear who did cocaine.\"\r\n\r\nRating: B-")
  end
end
