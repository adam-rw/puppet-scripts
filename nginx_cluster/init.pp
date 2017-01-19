class { 'nginx_cluster': }

class nginx_cluster {
    # install package. asuuming nginx repo present or happy to use default version in centos repo
    package { 'nginx':
        ensure => present
    }

    # configure service
    service { 'nginx':
        ensure => running,
        enable => true,
        require => Package['nginx']
    }

    # create node web root directories
    file { ["/srv/www", "/srv/www/node3", "/srv/www/node4"]:
        ensure => directory,
        owner => 'nginx',
        group => 'nginx',
        require => Package['nginx']
    }

    # node3 config
    file { "/etc/nginx/conf.d/node3.conf":
        ensure => file,
        owner => 'nginx',
        group => 'nginx',
        source => "puppet:///modules/nginx_cluster/node3.conf",
        notify => Service['nginx']
    }

    file { "/srv/www/node3/index.html":
        ensure => file,
        owner => 'nginx',
        group => 'nginx',
        content => '<h1>Node3</h1>'
    }

    # node4 config
    file { "/etc/nginx/conf.d/node4.conf":
        ensure => file,  
        owner => 'nginx',
        group => 'nginx',   
        source => "puppet:///modules/nginx_cluster/node4.conf",
        notify => Service['nginx']
    }

    file { "/srv/www/node4/index.html":
        ensure => file,
        owner => 'nginx',
        group => 'nginx',
        content => '<h1>Node4</h1>'
    }

    # lb config
    file { "/etc/nginx/conf.d/lb85.conf":
        ensure => file,  
        owner => 'nginx',
        group => 'nginx',   
        source => "puppet:///modules/nginx_cluster/lb85.conf",
        notify => Service['nginx']
    }
}
