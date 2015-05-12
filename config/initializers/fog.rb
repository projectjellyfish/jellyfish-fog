if ENV['MOCK_FOG'] == 'true' || %w(production staging).include?(Rails.env)
  Fog.mock!
end
