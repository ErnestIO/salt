# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module Salt
  class Report
    attr_reader :node

    def initialize(node, payload)
      @node = node
      @payload = payload
    end

    def pid
      @payload['pid']
    end

    def retcode
      if @payload.class == TrueClass
        0
      elsif @payload.class == FalseClass
        1
      else
        @payload['retcode']
      end
    end

    def stdout
      if @payload.class != String
        @payload['stdout']
      else
        ''
      end
    end

    def stderr
      if @payload.class != String
        @payload['stderr']
      else
        ''
      end
    end
  end
end
