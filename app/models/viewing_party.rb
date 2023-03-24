# frozen_string_literal: true

# app/models/viewing_party.rb
class ViewingParty < ApplicationRecord
  has_many :viewing_party_users, dependent: :destroy
  has_many :users, through: :viewing_party_users

  validates :event_datetime, :duration, presence: true
  validates :duration, numericality: true

  def self.host_viewing_parties(user)
    joins(:viewing_party_users)
      .where(viewing_party_users: { user_id: user, user_type: 1 })
      .distinct
  end

  def self.invited_viewing_parties(user)
    joins(:viewing_party_users)
      .where(viewing_party_users: { user_id: user, user_type: 0 })
      .distinct
  end

  def list_invitees
    users
      .joins(:viewing_party_users)
      .where(viewing_party_users: { user_type: 0 })
  end

  def list_host
    users
      .joins(:viewing_party_users)
      .where(viewing_party_users: { user_type: 1 })
      .first
  end

  def self.list_movie_ids(user)
    joins(:viewing_party_users)
      .where(viewing_party_users: { user_id: user.id })
      .distinct
      .pluck(:movie_id)
  end
end
