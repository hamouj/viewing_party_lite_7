# frozen_string_literal: true

# app/models/user.rb
class User < ApplicationRecord
  has_many :viewing_party_users, dependent: :destroy
  has_many :viewing_parties, through: :viewing_party_users

  validates :name, :email, presence: true
  validates :email, uniqueness: true, 'valid_email_2/email': { strict_mx: true }
  validates :password, presence: true
  
  has_secure_password

  scope :all_except, ->(user) { where.not(id: user.id).order(:created_at) }
end
