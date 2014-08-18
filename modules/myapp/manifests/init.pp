# myapp manifest
#
#

class myapp {

  $myapp_version = 'v1.0'

  file { '/tmp/myapp.json':
    ensure      => file,
    mode        => '0644',
    owner       => 'root',
    group       => 'root',
    source      => 'puppet:///modules/myapp/myapp.json',
  }

  file { '/tmp/myapp.conf':
    ensure      => present,
    mode        => '0644',
    owner       => 'root',
    group       => 'root',
    content     => template('myapp/myapp.conf.erb'),
  }

}
