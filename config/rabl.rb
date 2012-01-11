require 'rabl'
require 'grape-rabl'

Rabl.register!
Rabl.configure do |config|
  config.include_json_root = false
end
