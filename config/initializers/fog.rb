if ENV.key?('MOCK_FOG') || !%w(production staging).include?(Rails.env)
  Fog.mock!
end
