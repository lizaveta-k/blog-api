# frozen_string_literal: true

class Ip < ApplicationRecord
  has_many :posts
  has_many :users, -> { distinct }, through: :posts

  def add_user_login!(login)
    return if user_logins.include?(login)

    update!(user_logins: user_logins << login, user_count: user_count + 1)
  end

  def self.with_multiple_users
    where('user_count > 1')
  end
end
