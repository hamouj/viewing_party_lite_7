# frozen_string_literal: true

require 'rails_helper'

describe ViewingPartyUser, type: :model do
  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :viewing_party }
  end

  describe 'enums' do
    it { should define_enum_for(:user_type).with_values(['invitee', 'host']) }
  end
end
