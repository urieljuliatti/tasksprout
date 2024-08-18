# frozen_string_literal: true

require 'jwt'

# Encodes and decodes the payload
class JsonWebTokenService
  def self.encode(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base).first
  rescue JWT::DecodeError
    nil
  end
end
