module Minilab
  class ConnectionState #@private
    def initialize
      @connected = false
    end

    def connected?
      @connected
    end

    def connected=(value)
      @connected = value
    end
  end
end
