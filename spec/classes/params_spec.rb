require 'spec_helper'

describe 'yum_autoupdate::params' do
  let :facts do
    {
      :osfamily                  => 'RedHat',
      :operatingsystemmajrelease => '7',
      :operatingsystem           => 'RedHat'
    }
  end
  it { is_expected.to contain_class('yum_autoupdate::params') }
  it { is_expected.to have_resource_count(0) }
end
