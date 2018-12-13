# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  belongs_to :ip

  has_many :ratings

  TOP_LIMIT = 1

  def update_average_rating!
    update!(average_rating: ratings.average(:value))
  end

  def self.top(limit)
    order(average_rating: :desc).limit(limit || TOP_LIMIT)
  end
end
