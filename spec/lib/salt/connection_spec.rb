# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require_relative '../../spec_helper'

describe Salt::Connection do
  let!(:endpoint)	{ nil }
  let!(:port)		{ nil }
  let!(:user)		{ nil }
  let!(:pass)		{ 'password' }

  let!(:args) do
    { endpoint: 	endpoint,
      port: 		port,
      user: 		user,
      pass: 		pass }
  end

  let!(:subject) { Salt::Connection.new args }

  describe '#get' do
    before do
      stub_request(:get, 'https://127.0.0.1:8000/minions')
        .to_return(json_response_for(:minions))
      @response = subject.get('/minions')
    end

    describe 'when i make a get request to the salt master' do
      it 'should have authenticated' do
        expect(WebMock).to have_requested(:post, 'https://127.0.0.1:8000/login')
      end

      it 'should have made a request' do
        expect(WebMock).to have_requested(:get, 'https://127.0.0.1:8000/minions')
      end

      it 'should return a succesful salt response' do
        expect(@response).to be_an_instance_of(Salt::Response)
      end
    end
  end

  describe '#post' do
    before do
      stub_request(:post, 'https://127.0.0.1:8000/minions')
        .to_return(json_response_for(:execution))
      params = { fun: 'cmd.run_all', arg: 'date', expr_type: 'list', tgt: 'salt-master.localdomain' }
      @response = subject.post('/minions', params)
    end

    describe 'when i make a post request to the salt master' do
      it 'should have authenticated' do
        expect(WebMock).to have_requested(:post, 'https://127.0.0.1:8000/login')
      end

      it 'should have made a request' do
        expect(WebMock).to have_requested(:post, 'https://127.0.0.1:8000/minions')
      end

      it 'should return a succesful salt response' do
        expect(@response).to be_an_instance_of(Salt::Response)
      end
    end
  end
end
