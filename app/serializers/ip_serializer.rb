# frozen_string_literal: true

class IpSerializer
  include FastJsonapi::ObjectSerializer

  attributes :ip, :user_logins
end
