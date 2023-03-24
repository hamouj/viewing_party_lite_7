# frozen_string_literal: true

require 'rails_helper'

describe Cast do
  it 'has attributes' do
    attr = {
      adult: false,
      gender: 1,
      id: 41292,
      known_for_department: 'Acting',
      name: 'Keri Russell',
      original_name: 'Keri Russell',
      popularity: 42.735,
      profile_path: '/u81mC6vZwliDRfnX1DpdGmmex61.jpg',
      cast_id: 9,
      character: 'Sari',
      credit_id: '60e67c1a8de0ae00469a6e4d',
      order: 0
    }

    cast = Cast.new(attr)

    expect(cast).to be_a Cast
    expect(cast.name).to eq('Keri Russell')
    expect(cast.character).to eq('Sari')
  end
end
