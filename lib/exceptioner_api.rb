require 'pathname'

module Exceptioner
  module Api
    def self.root
      Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), "..")))
    end
  end
end

ER = Exceptioner
