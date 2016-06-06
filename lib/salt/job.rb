# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module Salt
  class Job
    attr_reader :id, :function, :target, :user, :start_time, :target_type, :arguments, :minions, :reports

    def initialize(id, args)
      @id = id
      @function = args['Function']
      @target = args['Target']
      @user = args['User']
      @start_time = args['StartTime']
      @target_type = args['Target-type']
      @arguments = args['Arguments']
      @minions = args['Minions']
    end

    attr_writer :reports
  end
end
