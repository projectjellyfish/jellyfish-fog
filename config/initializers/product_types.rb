Dir.glob(Jellyfish::Fog::Engine.root.join('config', 'product_questions', '*.json')) do |filename|
  product_type = JSON.parse(File.read(filename))
  Rails.application.config.x.product_types.merge!(
    product_type['title'] => product_type
  )
end
