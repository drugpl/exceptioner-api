require 'mongoid'

DATABASE = case ENV['RACK_ENV']
           when "test", "production"
             "exceptioner_#{ENV['RACK_ENV']}"
           else
             "exceptioner_development"
           end

Mongoid.configure do |config|
  config.database = Mongo::Connection.new.db(DATABASE)
end
