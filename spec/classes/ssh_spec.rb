# frozen_string_literal: true

require 'spec_helper'

describe 'ssh' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it do
        is_expected.to compile
        is_expected.to contain_class('ssh::install')
        is_expected.to contain_class('ssh::client')
        is_expected.to contain_class('ssh::server')
      end
    end
  end
end
