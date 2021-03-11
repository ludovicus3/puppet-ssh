# frozen_string_literal: true

require 'spec_helper'

describe 'ssh::server::service' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { "class { 'ssh::server': package_names => 'test', service_name => 'sshd' }" }

      it do
        is_expected.to compile
        is_expected.to contain_service('sshd')
      end
    end
  end
end
