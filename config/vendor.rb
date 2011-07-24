Dir["#{Exceptioner::Api.root}/vendor/*"].each { |f| $: << "#{f}/lib/" }
