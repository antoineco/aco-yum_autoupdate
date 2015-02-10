require 'spec_helper'

describe 'yum_autoupdate::params' do
  context "On RedHat" do
    let :facts do
      {
        :osfamily                  => 'RedHat',
        :operatingsystemmajrelease => '7',
        :operatingsystem           => 'RedHat'
      }
    end
    it { is_expected.to contain_class('yum_autoupdate::params') }
    it 'should not contain any resource' do
      is_expected.to have_resource_count(0)
    end
  end
  context "On Fedora" do
    let :facts do
      {
        :osfamily                  => 'RedHat',
        :operatingsystemmajrelease => '21',
        :operatingsystem           => 'Fedora'
      }
    end
    it { is_expected.to contain_class('yum_autoupdate::params') }
    it 'should not contain any resource' do
      is_expected.to have_resource_count(0)
    end
  end
end
