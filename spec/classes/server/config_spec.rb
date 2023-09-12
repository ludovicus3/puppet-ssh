# frozen_string_literal: true

require 'spec_helper'

describe 'ssh::server::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with managed sshd_config' do
        let(:pre_condition) { 'class { ssh: }' }

        it do
          is_expected.to compile
          is_expected.to contain_concat('/etc/ssh/sshd_config')
          is_expected.to contain_exec('ssh::server::config::test')
            .that_subscribes_to('Concat[/etc/ssh/sshd_config]')
            .that_notifies('Service[sshd]')
        end
      end

      context 'with unmanaged sshd_config' do
        let(:pre_condition) { 'class { ssh: manage_sshd_config => false }' }

        it do
          is_expected.to compile
          is_expected.not_to contain_concat('/etc/ssh/sshd_config')
          is_expected.not_to contain_exec('ssh::server::config::test')
        end
      end
    end
  end
end
