exec { 'nginx_module':
    command => "/bin/puppet module install puppet/nginx",
    onlyif => "/usr/bin/test ! -d /etc/puppet/modules/nginx"
}

class { 'nginx': 
    require => Exec['nginx_module']
}

$backend_config = {
    least_conn => ''
}

nginx::resource::upstream { 'http_backends':
    members => [
	'localhost:81 weight=1',
	'localhost:82 weight=2'
    ],
    upstream_cfg_prepend => $backend_config
}

nginx::resource::server { 'node1':
    listen_port => 81,
    www_root => '/srv/www/node1'
}

nginx::resource::server { 'node2':
    listen_port => 82,
    www_root => '/srv/www/node2'
}

nginx::resource::server { 'example.com':
    proxy => 'http://http_backends'
}


file { [ '/srv/www', '/srv/www/node1', '/srv/www/node2' ]: 
    ensure => directory,
    owner => 'nginx',
    group => 'nginx',
    require => Class['nginx']
}

file { '/srv/www/node1/index.html':
    ensure => file,
    owner => 'nginx',
    group => 'nginx',
    content => '<h1>Node1</h1>',
    require => File['/srv/www/node1']
}

file { '/srv/www/node2/index.html':
    ensure => file,
    owner => 'nginx',
    group => 'nginx',
    content => '<h1>Node2</h1>',
    require => File['/srv/www/node2']
}

