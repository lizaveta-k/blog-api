# frozen_string_literal: true

module V1
  class RatingsController < ApplicationController
    def create
      result = CreateRating.run(rating_params)

      if result[:success]
        render json: PostSerializer.new(result[:success]), status: :created
      else
        render json: result[:error], status: :unprocessable_entity
      end
    end

    private

    def rating_params
      params.permit(:post_id, :value)
    end
  end
end
