# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Ratings resource', type: :request do
  let(:post1) { CreatePost.run(login: '1', ip: '1', content: '1', title: '1')[:success] }

  it 'adds new rating to post and recalculates average rating' do
    CreateRating.run(post_id: post1.id, value: 5)

    post v1_post_rating_path(post1.id), params: { value: 1 }

    json_post = JSON.parse(response.body).with_indifferent_access[:data]

    expect(response.status).to eq(201)
    expect(json_post[:id]).to eq(post1.id.to_s)
    expect(json_post[:attributes][:average_rating]).to eq('3.0')
  end

  it 'returns errors when params are invalid' do
    CreateRating.run(post_id: post1.id, value: 5)

    post v1_post_rating_path(post1.id + 1), params: { value: 999 }

    body = JSON.parse(response.body).with_indifferent_access

    expect(response.status).to eq(422)
    expect(body[:value]).to eq('must be less than or equal to 5')
    expect(body[:post]).to eq('not found')
  end
end
