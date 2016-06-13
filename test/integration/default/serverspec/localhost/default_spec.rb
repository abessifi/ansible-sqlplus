# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'spec_helper'

describe 'Check for "baz" File' do
  describe file('/tmp/baz') do
    it { should be_file }
    it { should be_owned_by 'vagrant' }
    it { should be_grouped_into 'vagrant' }
  end
end
