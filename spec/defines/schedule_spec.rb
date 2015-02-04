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
  describe "general assumptions" do
    it { is_expected.to contain_class("yum_autoupdate") }
    it { is_expected.to contain_class("yum_autoupdate::params") }
    it do 
      is_expected.to contain_file('yum-cron rspec hourly schedule').with({
        'ensure' => 'present',
        'path'   => '/etc/yum/schedules/yum-cron_rspechourly',
        'mode'   => '0755'
      }).with_content(/rspechourly$/)
    end
  end
  describe "os-specific considerations" do
    context "on RedHat 5" do
      let :facts do
        {
          :osfamily                  => 'RedHat',
          :operatingsystemmajrelease => '5',
          :operatingsystem           => 'RedHat'
        }
      end
      it do 
        is_expected.to contain_file('yum-cron rspec hourly config').with({
          'ensure' => 'present',
          'path'   => '/etc/sysconfig/yum-cron_rspechourly',
          'mode'   => '0644'
        }).with_content(/^YUM_PARAMETER/)
      end
    end
     context "on RedHat 6" do
      let :facts do
        {
          :osfamily                  => 'RedHat',
          :operatingsystemmajrelease => '6',
          :operatingsystem           => 'RedHat'
        }
      end
      it do 
        is_expected.to contain_file('yum-cron rspec hourly config').with({
          'ensure' => 'present',
          'path'   => '/etc/sysconfig/yum-cron_rspechourly',
          'mode'   => '0644'
        }).with_content(/^YUM_PARAMETER/)
      end
    end
    context "on RedHat 7" do
      let :facts do
        {
          :osfamily                  => 'RedHat',
          :operatingsystemmajrelease => '7',
          :operatingsystem           => 'RedHat'
        }
      end
      it do 
        is_expected.to contain_file('yum-cron rspec hourly config').with({
          'ensure' => 'present',
          'path'   => '/etc/yum/yum-cron.conf_rspechourly',
          'mode'   => '0644'
        }).with_content(/^update_cmd/)
      end
    end
    context "on Fedora" do
      let :facts do
        {
          :osfamily                  => 'RedHat',
          :operatingsystemmajrelease => '21',
          :operatingsystem           => 'Fedora'
        }
      end
      it do 
        is_expected.to contain_file('yum-cron rspec hourly config').with({
          'ensure' => 'present',
          'path'   => '/etc/yum/yum-cron.conf_rspechourly',
          'mode'   => '0644'
        }).with_content(/^update_cmd/)
      end
    end
  end
  describe "cron job" do
    context "with default parameters" do
      it do
        is_expected.to contain_cron('yum-cron rspec hourly schedule').with({
          'ensure' => 'present',
          'user'   => 'root'
        })
      end
    end
    context "with custom parameters" do
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
        is_expected.to contain_cron('yum-cron rspec hourly schedule').with({
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
  describe "configuration file with default parameters" do
    context "on RedHat 5" do
      let :facts do
        {
          :osfamily                  => 'RedHat',
          :operatingsystemmajrelease => '5',
          :operatingsystem           => 'RedHat'
        }
      end
      it do
        is_expected.to contain_file('yum-cron rspec hourly config').with_content("# ******************\n# Managed by Puppet\n# ******************\n\nYUM_PARAMETER=\nCHECK_ONLY=no\nDOWNLOAD_ONLY=no\nERROR_LEVEL=0\nDEBUG_LEVEL=1\nMAILTO=root\nRANDOMWAIT=\"60\"\n")
      end
    end
    context "on RedHat 6" do
      let :facts do
        {
          :osfamily                  => 'RedHat',
          :operatingsystemmajrelease => '6',
          :operatingsystem           => 'RedHat'
        }
      end
      it do
        is_expected.to contain_file('yum-cron rspec hourly config').with_content("# ******************\n# Managed by Puppet\n# ******************\n\nYUM_PARAMETER=\nCHECK_ONLY=no\nDOWNLOAD_ONLY=no\nCHECK_FIRST=no\nERROR_LEVEL=0\nDEBUG_LEVEL=1\nMAILTO=root\n#SYSTEMNAME=\"\"\nRANDOMWAIT=60\n#DAYS_OF_WEEK=\"0123456\" \nCLEANDAY=\"0\"\nSERVICE_WAITS=yes\nSERVICE_WAIT_TIME=300\n\n## extra options from the aco-yum_autoupdate Puppet module\nMAILFROM=root\n")
      end
    end
    context "on new generation" do
      it do
        is_expected.to contain_file('yum-cron rspec hourly config').with_content("# ******************\n# Managed by Puppet\n# ******************\n\n[commands]\nupdate_cmd = default\nupdate_messages = yes\ndownload_updates = yes\napply_updates = yes\nrandom_sleep = 60\n\n[emitters]\nsystem_name = None\nemit_via = email\noutput_width = 80\n\n[email]\nemail_from = root\nemail_to = root\nemail_host = localhost\n\n[groups]\ngroup_list = None\ngroup_package_types = mandatory, default\n\n[base]\ndebuglevel = -1\nerrorlevel = 0\n# skip_broken = True\nmdpolicy = group:main\n# assumeyes = True\n")
      end
    end
  end
  describe "configuration file with all parameters overriden" do
    let :params do
      {
        'action'       => 'check',
        'exclude'      => ['httpd','kernel'],
        'notify_email' => false,
        'email_to'     => 'admin@example.com',
        'email_from'   => 'updates@localhost',
        'debug_level'  => 4,
        'error_level'  => 2,
        'update_cmd'   => 'security',
        'randomwait'   => 120
      }
    end
    context "on RedHat 5" do
      let :facts do
        {
          :osfamily                  => 'RedHat',
          :operatingsystemmajrelease => '5',
          :operatingsystem           => 'RedHat'
        }
      end
      it do
        is_expected.to contain_file('yum-cron rspec hourly config').with_content("# ******************\n# Managed by Puppet\n# ******************\n\nYUM_PARAMETER=--exclude=httpd\\ --exclude=kernel\nCHECK_ONLY=yes\nDOWNLOAD_ONLY=no\nERROR_LEVEL=2\nDEBUG_LEVEL=-1\nMAILTO=admin@example.com\nRANDOMWAIT=\"120\"\n")
      end
    end
    context "on RedHat 6" do
      let :facts do
        {
          :osfamily                  => 'RedHat',
          :operatingsystemmajrelease => '6',
          :operatingsystem           => 'RedHat'
        }
      end
      it do
        is_expected.to contain_file('yum-cron rspec hourly config').with_content("# ******************\n# Managed by Puppet\n# ******************\n\nYUM_PARAMETER=--exclude=httpd\\ --exclude=kernel\nCHECK_ONLY=yes\nDOWNLOAD_ONLY=no\nCHECK_FIRST=no\nERROR_LEVEL=2\nDEBUG_LEVEL=-1\nMAILTO=admin@example.com\n#SYSTEMNAME=\"\"\nRANDOMWAIT=120\n#DAYS_OF_WEEK=\"0123456\" \nCLEANDAY=\"0\"\nSERVICE_WAITS=yes\nSERVICE_WAIT_TIME=300\n\n## extra options from the aco-yum_autoupdate Puppet module\nMAILFROM=updates@localhost\n")
      end
    end
    context "on new generation" do
      it do
        is_expected.to contain_file('yum-cron rspec hourly config').with_content("# ******************\n# Managed by Puppet\n# ******************\n\n[commands]\nupdate_cmd = security\nupdate_messages = no\ndownload_updates = no\napply_updates = no\nrandom_sleep = 120\n\n[emitters]\nsystem_name = None\nemit_via = email\noutput_width = 80\n\n[email]\nemail_from = updates@localhost\nemail_to = admin@example.com\nemail_host = localhost\n\n[groups]\ngroup_list = None\ngroup_package_types = mandatory, default\n\n[base]\ndebuglevel = -1\nerrorlevel = 2\n# skip_broken = True\nmdpolicy = group:main\n# assumeyes = True\nexclude=httpd kernel\n")
      end
    end
   end
end
