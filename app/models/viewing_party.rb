# frozen_string_literal: true

# app/models/viewing_party.rb
class ViewingParty < ApplicationRecord
  has_many :viewing_party_users
  has_many :users, through: :viewing_party_users
end
