# frozen_string_literal: true

# db/migrate/20230321025240_create_viewing_parties.rb
class CreateViewingParties < ActiveRecord::Migration[7.0]
  def change
    create_table :viewing_parties do |t|
      t.datetime :event_datetime
      t.integer :duration
      t.integer :movie_id

      t.timestamps
    end
  end
end
