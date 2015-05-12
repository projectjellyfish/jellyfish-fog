if ENV['MOCK_FOG'] != 'false' || !%w(production staging).include?(Rails.env)
  Fog.mock!
end
