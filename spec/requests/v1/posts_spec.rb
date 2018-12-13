# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts resource', type: :request do
  let(:valid_params) { { login: '1', ip: '1', content: '1', title: '1' } }

  describe 'top n' do
    let(:post1) { CreatePost.run(valid_params)[:success] }
    let(:post2) { CreatePost.run(valid_params)[:success] }
    let(:post3) { CreatePost.run(valid_params)[:success] }

    before do
      CreateRating.run(post_id: post1.id, value: 5)
      CreateRating.run(post_id: post2.id, value: 5)
      CreateRating.run(post_id: post3.id, value: 5)
      CreateRating.run(post_id: post1.id, value: 1)
      CreateRating.run(post_id: post2.id, value: 2)
    end

    it 'returns posts ordered by average rating' do
      get v1_posts_path, params: { limit: 2 }

      body = JSON.parse(response.body).with_indifferent_access

      expect(response.status).to eq(200)
      expect(body[:data].length).to eq(2)

      expect(body[:data][0][:id]).to eq(post3.id.to_s)
      expect(body[:data][1][:id]).to eq(post2.id.to_s)
    end

    it 'returns 1 top post if limit is not specifies' do
      get v1_posts_path

      body = JSON.parse(response.body).with_indifferent_access

      expect(response.status).to eq(200)
      expect(body[:data].length).to eq(1)

      expect(body[:data][0][:id]).to eq(post3.id.to_s)
    end

    it 'ignores non integer limit parameter' do
      get v1_posts_path, params: { limit: 'abc' }

      body = JSON.parse(response.body).with_indifferent_access

      expect(response.status).to eq(200)
      expect(body[:data].length).to eq(1)

      expect(body[:data][0][:id]).to eq(post3.id.to_s)
    end
  end

  describe 'post creation' do
    it 'creates new post and returns it' do
      expect do
        post v1_posts_path, params: valid_params
      end.to change(Post, :count).by(1)

      json_post = JSON.parse(response.body).with_indifferent_access[:data]
      post = Post.last

      expect(response.status).to eq(201)
      expect(post.title).to eq(valid_params[:title])
      expect(post.content).to eq(valid_params[:content])
      expect(json_post[:id]).to eq(post.id.to_s)
      expect(json_post[:attributes][:title]).to eq(post.title)
      expect(json_post[:attributes][:content]).to eq(post.content)
    end

    it 'creates new user' do
      expect do
        post v1_posts_path, params: valid_params
      end.to change(User, :count).by(1)

      user = User.last

      expect(response.status).to eq(201)
      expect(user.login).to eq(valid_params[:login])
    end

    it 'creates new ip' do
      expect do
        post v1_posts_path, params: valid_params
      end.to change(Ip, :count).by(1)

      ip = Ip.last

      expect(response.status).to eq(201)
      expect(ip.ip).to eq(valid_params[:ip])
    end

    it 'returns errors for invalid params' do
      expect do
        post v1_posts_path, params: {}
      end.to change(Post, :count).by(0)

      expect(response.status).to eq(422)

      body = JSON.parse(response.body)

      %w[title content login ip].each do |field|
        expect(body[field]).to eq("can't be blank")
      end
    end
  end
end
