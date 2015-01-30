require 'spec_helper'

describe 'yum_autoupdate::schedule', :type => :define do
  let :pre_condition do
    'include yum_autoupdate'
  end
  let :title do
    'rspec hourly'
  end
  let :facts do
    {
      :osfamily                  => 'RedHat',
      :operatingsystemmajrelease => '7',
      :operatingsystem           => 'RedHat'
    }
  end
  describe 'general assumptions' do
    it { is_expected.to contain_class("yum_autoupdate") }
    it { is_expected.to contain_class("yum_autoupdate::params") }
    it do 
      should contain_file('yum-cron rspec hourly schedule').with({
        'ensure' => 'present',
        'path'   => '/etc/yum/schedules/yum-cron_rspechourly',
        'mode'   => '0755'
      }).with_content(/rspechourly$/)
    end
  end
  describe 'config file' do
    context "on RedHat systems" do
      let :facts do
        {
          :osfamily                  => 'RedHat',
          :operatingsystemmajrelease => '7',
          :operatingsystem           => 'CentOS'
        }
      end
      it do 
        should contain_file('yum-cron rspec hourly config').with({
          'ensure' => 'present',
          'path'   => '/etc/yum/yum-cron.conf_rspechourly',
          'mode'   => '0644'
        }).with_content(/^update_cmd/)
      end
    end
    context "on Fedora systems" do
      let :facts do
        {
          :osfamily                  => 'RedHat',
          :operatingsystemmajrelease => '21',
          :operatingsystem           => 'Fedora'
        }
      end
      it do 
        should contain_file('yum-cron rspec hourly config').with({
          'ensure' => 'present',
          'path'   => '/etc/yum/yum-cron.conf_rspechourly',
          'mode'   => '0644'
        }).with_content(/^update_cmd/)
      end
    end
  end
  describe 'cron' do
    context 'default params' do
      it do
        should contain_cron('yum-cron rspec hourly schedule').with({
          'ensure' => 'present',
          'user'   => 'root'
        })
      end
    end
    context 'custom params' do
      let :params do
        {
          :hour     => '23',
          :minute   => '30',
          :month    => '*',
          :monthday => '*/2',
          :weekday  => '1-5'
        }
      end
      it do
        should contain_cron('yum-cron rspec hourly schedule').with({
          'ensure'   => 'present',
          'user'     => 'root',
          'hour'     => '23',
          'minute'   => '30',
          'monthday' => '*/2',
          'month'    => '*',
          'weekday'  => '1-5'
        })
      end
    end
  end
end
