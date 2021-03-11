# frozen_string_literal: true

require 'spec_helper'

describe 'ssh::clients' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          'package_names' => 'openssh-clients',
        }
      end

      it do
        is_expected.to compile
        is_expected.to contain_class('ssh::clients::install')
        is_expected.to contain_class('ssh::clients::config')
      end
    end
  end
end
