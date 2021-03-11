# frozen_string_literal: true

require 'spec_helper'

describe 'ssh::server' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          'package_names' => 'openssh-server',
          'service_name' => 'sshd',
        }
      end

      it do
        is_expected.to compile
        is_expected.to contain_class('ssh::server::install')
        is_expected.to contain_class('ssh::server::config')
        is_expected.to contain_class('ssh::server::service')
      end
    end
  end
end
