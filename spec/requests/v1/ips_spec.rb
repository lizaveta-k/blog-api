# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'IPs resource', type: :request do
  it 'returns list of all ips with number of associated user greater than 2' do
    CreatePost.run(login: '1', ip: '1', content: '1', title: '1')
    CreatePost.run(login: '2', ip: '2', content: '1', title: '1')
    CreatePost.run(login: '3', ip: '2', content: '1', title: '1')

    get v1_ips_path

    body = JSON.parse(response.body).with_indifferent_access

    expect(response.status).to eq(200)
    expect(body[:data].length).to eq(1)

    ip = body[:data][0]

    expect(ip[:id]).to eq(Ip.find_by(ip: '2').id.to_s)
    expect(ip[:attributes][:user_logins]).to match_array(%w[2 3])
  end
end
