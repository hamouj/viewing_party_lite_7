# frozen_string_literal: true

# db/migrate/20230321025545_create_viewing_party_users.rb
class CreateViewingPartyUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :viewing_party_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :viewing_party, null: false, foreign_key: true
      t.integer :user_type

      t.timestamps
    end
  end
end
