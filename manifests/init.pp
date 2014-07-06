class elasticsearch (
  $version     = '1.1.0',
  $destination = '/opt') {

  $filename = "elasticsearch-${version}"
  $tar_file = "${filename}.tar.gz"
  $url      = "https://download.elasticsearch.org/elasticsearch/elasticsearch/${tar_file}"

  class { 'java': }

  exec { "wget ${filename}":
    command => "wget -q ${url} -O ${destination}/${tar_file}",
    path => ["/usr/bin", "/bin"],
  }

  exec { "untar ${filename}":
    command => "tar -xf ${destination}/${tar_file} -C ${destination}",
    path => ["/usr/bin", "/bin"],
    subscribe => Exec["wget ${filename}"],
    refreshonly => true,
  }

  file { '/etc/init/elasticsearch.conf':
    ensure => file,
    content => template('elasticsearch/elasticsearch.conf.erb'),
  }

  service { 'elasticsearch':
    ensure => running,
    provider => 'upstart',
    require => File['/etc/init/elasticsearch.conf'],
  }
}