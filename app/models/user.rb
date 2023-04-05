# frozen_string_literal: true

# app/models/user.rb
class User < ApplicationRecord
  has_many :viewing_party_users, dependent: :destroy
  has_many :viewing_parties, through: :viewing_party_users

  validates :name, :email, presence: true
  validates :email, uniqueness: true, 'valid_email_2/email': { strict_mx: true }
  validates :password_digest, presence: true
  
  has_secure_password

  enum role: %w(default registered admin)

  scope :all_except, ->(user) { where.not(id: user.id).order(:created_at) }
  scope :registered_users, -> { where(role: 1) }
end
