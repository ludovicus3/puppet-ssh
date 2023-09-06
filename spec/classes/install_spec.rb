# frozen_string_literal: true

require 'spec_helper'

describe 'ssh::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with managed install' do
        let(:pre_condition) { 'class { ssh: }' }

        it do
          is_expected.to compile
          is_expected.to contain_package('openssh')
        end
      end

      context 'with unmanaged install' do
        let(:pre_condition) { 'class { ssh: manage_install => false }' }

        it do
          is_expected.to compile
          is_expected.not_to contain_package('openssh')
        end
      end
    end
  end
end
