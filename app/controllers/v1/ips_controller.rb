# frozen_string_literal: true

module V1
  class IpsController < ApplicationController
    def index
      render json: IpSerializer.new(Ip.with_multiple_users)
    end
  end
end
