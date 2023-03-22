# frozen_string_literal: true

# app/models/viewing_party_user.rb
class ViewingPartyUser < ApplicationRecord
  belongs_to :user
  belongs_to :viewing_party

  enum user_type: ["invitee", "host"]
end
