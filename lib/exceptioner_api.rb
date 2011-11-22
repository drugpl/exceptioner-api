require 'bundler/setup'
require 'goliath/api'

module Exceptioner
  module API
    def self.root
      Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), "..")))
    end
  end
end
