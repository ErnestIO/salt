# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require_relative '../../spec_helper'

describe Salt::SaltMaster do
  let!(:endpoint)	{ nil }
  let!(:port)		{ nil }
  let!(:user)		{ nil }
  let!(:pass)		{ 'password' }

  let!(:args) do
    { endpoint: 	endpoint,
      port: 	  	port,
      user: 	  	user,
      pass: 	  	pass }
  end

  let!(:subject) { Salt::SaltMaster.new args }

  describe '#jobs' do
    before do
      stub_request(:get, 'https://127.0.0.1:8000/jobs')
        .to_return(json_response_for(:jobs))
      @jobs = subject.jobs
    end

    it 'should return an array of jobs' do
      expect(@jobs).to be_an_instance_of(Array)
      expect(@jobs.collect(&:class).uniq.count).to eq 1
      expect(@jobs.first).to be_an_instance_of(Salt::Job)
    end

    it 'should return exactly 3 jobs' do
      expect(@jobs.count).to eq 3
    end
  end

  describe '#job' do
    before do
      stub_request(:get, 'https://127.0.0.1:8000/jobs/20150423190320435268')
        .to_return(json_response_for(:job))
      @job = subject.job('20150423190320435268')
    end

    it 'should return a single job instance' do
      expect(@job).to be_an_instance_of(Salt::Job)
    end

    it 'should load the correct values into Job instance' do
      expect(@job.id).to eq '20150423190320435268'
      expect(@job.function).to eq 'cmd.run_all'
    end
  end

  describe '#minions' do
    before do
      stub_request(:get, 'https://127.0.0.1:8000/minions')
        .to_return(json_response_for(:minions))
      @minions = subject.minions
    end

    it 'should return an array of minions' do
      expect(@minions).to be_an_instance_of(Array)
      expect(@minions.collect(&:class).uniq.count).to eq 1
      expect(@minions.first).to be_an_instance_of(Salt::Minion)
    end

    it 'should return exactly 1 minion' do
      expect(@minions.count).to eq 1
    end
  end

  describe '#minion' do
    before do
      stub_request(:get, 'https://127.0.0.1:8000/minions/test-host')
        .to_return(json_response_for(:minion))
      @minion = subject.minion('test-host')
    end

    it 'should return an array of minions' do
      expect(@minion).to be_an_instance_of(Salt::Minion)
    end

    it 'should load the correct values into Minion instance' do
      expect(@minion.node).to eq 'test-host'
      expect(@minion.os).to eq 'CentOS'
      expect(@minion.cpus).to eq 2
      expect(@minion.memory).to eq 3832
    end
  end

  describe '#execute' do
    before do
      stub_request(:post, 'https://127.0.0.1:8000/minions')
        .to_return(json_response_for(:execution))
      @execution = subject.execute('cmd.run_all', 'date', 'salt-master.localdomain')
    end

    it 'should return the correct job id ' do
      expect(@execution).to eq '20150423190320435268'
    end

    it 'should fail when we specify an invalid target_type parameter' do
      params = ['cmd.run_all', 'date', 'salt-master.localdomain', 'false-flag']
      expect { subject.execute(*params) }.to raise_error(ArgumentError)
    end
  end
end
