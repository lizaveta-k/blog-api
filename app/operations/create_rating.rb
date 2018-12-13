# frozen_string_literal: true

class CreateRating < BaseOperation
  validates_presence_of :post_id, :value
  validates_numericality_of :value, greater_than_or_equal_to: 1, less_than_or_equal_to: 5
  validate :post_existance

  def run
    post.with_lock do
      Rating.create!(
        post_id: params[:post_id],
        value: params[:value]
      )

      post.update_average_rating!
      post
    end
  end

  private

  def post
    return if params[:post_id].blank?

    @post ||= Post.find_by(id: params[:post_id])
  end

  def post_existance
    return if post

    errors.add(:post, 'not found')
  end
end
