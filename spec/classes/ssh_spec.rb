# frozen_string_literal: true

require 'spec_helper'

describe 'ssh' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          'package_names' => 'openssh',
          'clients_package_names' => 'openssh-clients',
          'server_package_names' => 'openssh-server',
          'server_service_name' => 'sshd',
        }
      end

      it do
        is_expected.to compile
        is_expected.to contain_class('ssh::install')
        is_expected.to contain_class('ssh::clients')
        is_expected.to contain_class('ssh::server')
      end
    end
  end
end
