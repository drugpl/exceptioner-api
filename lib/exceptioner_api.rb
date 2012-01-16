require 'exceptioner_api/version'
require 'pathname'

module Exceptioner
  module Api
    class << self
      def root
        Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), "..")))
      end
    end
  end
end

ER = Exceptioner
