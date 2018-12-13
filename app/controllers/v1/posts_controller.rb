# frozen_string_literal: true

module V1
  class PostsController < ApplicationController
    def index
      limit = params[:limit] =~ /\A\d+\Z/ && params[:limit]

      render json: PostSerializer.new(Post.top(limit))
    end

    def create
      result = CreatePost.run(post_params)

      if result[:success]
        render json: PostSerializer.new(result[:success]), status: :created
      else
        render json: result[:error], status: :unprocessable_entity
      end
    end

    private

    def post_params
      params.permit(:title, :content, :ip, :login)
    end
  end
end
