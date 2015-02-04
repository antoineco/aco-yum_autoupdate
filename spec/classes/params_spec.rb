require 'spec_helper'

describe 'yum_autoupdate::params', :type => :class do
  context "On RedHat" do
    let :facts do
      {
        :osfamily                  => 'RedHat',
        :operatingsystemmajrelease => '7',
        :operatingsystem           => 'RedHat'
      }
    end
    it { is_expected.to contain_yum_autoupdate__params }
    it "should only contain default resources" do
      expect(subject.resources.size).to eq(4)
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
    it { is_expected.to contain_yum_autoupdate__params }
    it "should only contain default resources" do
      expect(subject.resources.size).to eq(4)
    end
  end
end
