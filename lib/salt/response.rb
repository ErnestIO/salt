# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module Salt
  class Response
    def initialize(response)
      @json = JSON.parse(response.body)
    end

    def info
      @json['info'] ? @json['info'].first : {}
    end

    def return_payload
      @json['return'] ? @json['return'].first : {}
    end

    def to_s
      { info: info, ret: ret }.to_s
    end
  end
end
