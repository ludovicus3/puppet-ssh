# frozen_string_literal: true

require 'spec_helper'

describe 'ssh::clients::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { "class {'ssh::clients': package_names => 'openssh-clients'}" }

      it do
        is_expected.to compile
      end
    end
  end
end
