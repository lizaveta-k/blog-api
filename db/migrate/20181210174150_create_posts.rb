# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.decimal :average_rating, default: 0, index: true
      t.references :user, foreign_key: true
      t.references :ip, foreign_key: true

      t.timestamps
    end
  end
end
