require 'codeme/agent/handler/base'

module Codeme
  module Agent
    module Handler
      class System < Base
        def resolve(data)
          @connection.logger.debug "echo data: #{data}"
        end
      end
    end
  end
end
