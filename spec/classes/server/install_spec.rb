# frozen_string_literal: true

require 'spec_helper'

describe 'ssh::server::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { "class { 'ssh::server': package_names => 'openssh-server', service_name => 'sshd' }" }

      it do 
        is_expected.to compile
        is_expected.to contain_package('openssh-server')
      end
    end
  end
end
