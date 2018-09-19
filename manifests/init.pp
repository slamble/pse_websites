# websites: manages five Apache websites using the Puppetlabs Apache module.
#
# @summary For the PSE evaluation.
#
# @example
#   include websites
class websites (Array $vhosts = [ 'vhost1', 'vhost2', 'vhost3', 'vhost4', 'vhost5'] ) {
  notify { "Websites coming from the dev branch": }
  class { 'apache':
    default_vhost => false,
  }

  group { 'www-data':
    ensure => present,
  }
  user { 'www-data':
    ensure => present,
    shell  => '/bin/true',
    gid    => 'www-data',
  }
  $docroot = '/var/www/vhost'
  file { $docroot:
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
  }
  $vhosts.each |Integer $index, String $vhost| {
    apache::vhost { $vhost:
      port          => 8000 + $index,
      docroot       => "${docroot}/${vhost}",
      docroot_owner => 'www-data',
      docroot_group => 'www-data',
    }
    file { "${docroot}/${vhost}/index.html":
      ensure => present,
      owner => 'www-data',
      group => 'www-data',
      content => "<HTML><HEAD><TITLE>Test website ${vhost}</TITLE></HEAD><BODY>Just a test website for vhost ${vhost}.</BODY></HTML>",
    }
  }
}
