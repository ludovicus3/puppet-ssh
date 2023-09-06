# frozen_string_literal: true

require 'spec_helper'

describe 'ssh::server::service' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with managed service' do
        let(:pre_condition) { 'class { ssh: }' }

        it do
          is_expected.to compile
          is_expected.to contain_service('sshd')
        end
      end

      context 'with unmanaged service' do
        let(:pre_condition) { 'class { ssh: manage_service => false }' }

        it do
          is_expected.to compile
          is_expected.not_to contain_service('sshd')
        end
      end
    end
  end
end
