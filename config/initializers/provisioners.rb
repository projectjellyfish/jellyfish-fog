Rails.application.config.x.provisioners.merge!(
  JSON.parse(File.read(Jellyfish::Fog::Engine.root.join('config', 'provisioners.json')))
    .map { |product_type, provisioner| [product_type, provisioner.constantize] }.to_h
)
