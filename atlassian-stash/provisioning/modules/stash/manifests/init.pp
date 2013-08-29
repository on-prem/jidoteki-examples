# Downloads and installs Atlassian Stash
#
#

notify { "Running Puppet manifests for Stash v${stash_version}": }

class stash {

  $stash_version  = '2.6.4'
  $stash_home     = '/home/stash/stash-home'
  $jvm_args       = '-Dstash.allow.openjdk=true'

  # Make sure curl is present (it's in the preseed, but still..)
  package { 'curl':
    ensure      => present,
    provider    => apt,
  }

  # Download Atlassian Stash
  exec { 'download_stash':
    command     => "curl -L http://www.atlassian.com/software/stash/downloads/binary/atlassian-stash-${stash_version}.tar.gz | tar zx",
    require     => Package['curl'],
    cwd         => '/home/stash',
    user        => 'stash',
    group       => 'stash',
    path        => '/usr/bin/:/bin/',
    logoutput   => true,
    creates     => "/home/stash/atlassian-stash-${stash_version}",
  }

  # Give Stash the proper directory permissions
  file { "/home/stash/atlassian-stash-${stash_version}":
    ensure      => directory,
    require     => Exec['download_stash'],
    mode        => '0755',
    owner       => 'stash',
    group       => 'stash',
  }

  # Create symlink for the latest stash
  file { '/home/stash/stash-latest':
    ensure      => symlink,
    require     => Exec['download_stash'],
    owner       => 'stash',
    group       => 'stash',
    target      => "/home/stash/atlassian-stash-${stash_version}",
  }

  # Create stash group
  group { 'stash':
    ensure      => present,
  }

  # Create stash user
  user { 'stash':
    ensure      => present,
    gid         => 'stash',
    shell       => '/bin/bash',
    home        => '/home/stash',
    managehome  => true,
  }

  # Fix stash user dir permissions
  file { '/home/stash':
    ensure      => directory,
    mode        => '0750',
    owner       => 'stash',
    group       => 'stash',
    require     => Exec['download_stash'],
  }

  # Fix stash-home dir permissions (and make sure puppet never deletes it)
  file { "${stash_home}":
    ensure      => directory,
    require     => Exec['download_stash'],
    mode        => '0750',
    owner       => 'stash',
    group       => 'stash',
    recurse     => false,
    purge       => false,
    replace     => false,
  }

  # Create a custom setenv.sh
  file { '/home/stash/stash-latest/bin/setenv.sh':
    ensure      => file,
    mode        => '0755',
    owner       => 'stash',
    group       => 'stash',
    replace     => true,
    content     => template('stash/setenv.sh.erb'),
  }

  # Copy the stash startup script
  file { '/etc/init.d/stash':
    ensure      => present,
    require     => File['/home/stash/stash-latest'],
    mode        => '0755',
    owner       => 'root',
    group       => 'root',
    source      => 'puppet:///modules/stash/etc/init.d/stash',
  }

  # Make sure openjdk is the most recent
  package { 'openjdk-7-jdk':
    ensure      => latest,
    provider    => apt,
  }

  # Stash startup script service
  service { 'stash':
    ensure      => running,
    enable      => true,
    hasrestart  => true,
    hasstatus   => true,
    provider    => debian,
    require     => [
      File["${stash_home}"],
      File['/home/stash/stash-latest/bin/setenv.sh'],
      File['/etc/init.d/stash'],
      Package['openjdk-7-jdk'],
    ],
  }

}
