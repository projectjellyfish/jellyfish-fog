if ENV['JELLYFISH_MOCK_FOG'] != 'false' || !%w(production staging).include?(Rails.env)
  Fog.mock!
end
