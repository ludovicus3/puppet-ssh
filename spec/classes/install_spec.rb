# frozen_string_literal: true

require 'spec_helper'

describe 'ssh::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { "class {'ssh': package_names => 'openssh', clients_package_names => 'openssh-clients', server_package_names => 'openssh-server', server_service_name => 'sshd'}" }

      it do
        is_expected.to compile
        is_expected.to contain_package('openssh')
      end
    end
  end
end
