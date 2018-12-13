# frozen_string_literal: true

class CreateIps < ActiveRecord::Migration[5.2]
  def change
    create_table :ips do |t|
      t.string :ip, index: { unique: true }
      t.integer :user_count, default: 0, index: true
      t.string :user_logins, default: [], array: true

      t.timestamps
    end
  end
end
