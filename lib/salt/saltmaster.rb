# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module Salt
  class SaltMaster
    def initialize(args)
      @config = args
    end

    def jobs
      connection.get('/jobs').return_payload.map { |job_id, payload| Salt::Job.new(job_id, payload) }
    end

    def job(job_id)
      response = connection.get("/jobs/#{job_id}")
      job = Salt::Job.new(job_id, response.info)
      job.reports = response.return_payload.map { |node, payload| Salt::Report.new(node, payload) }
      job
    end

    def minions
      connection.get('/minions').return_payload.map { |node, payload| Salt::Minion.new(node, payload) }
    end

    def minion(id)
      response = connection.get("/minions/#{id}").return_payload
      Salt::Minion.new(id, response[id])
    end

    def execute(function, command, target, target_type = 'list')
      args = { fun: function, arg: command, tgt: target, expr_form: target_type }
      validate_execution_args(args)
      connection.post('/minions', args).return_payload['jid']
    end

    private

    def validate_execution_args(args)
      error_message = "#{args[:expr_form]} is not a valid target match type"
      raise ArgumentError, error_message unless %w(list grain compound).include? args[:expr_form]
    end

    def connection
      @__connection__ ||= Salt::Connection.new(@config)
    end
  end
end
