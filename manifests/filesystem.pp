#
# == Define: monit::filesystem
#
# Monitor a filesystem
#
# == Parameters
#
# [*fs_name*]
#   Monit's identifier for the filesystem. Must be unique and in a format that 
#   does not cause the monit configuration parser to choke. No default value.
# [*path*]
#   Filesystem path. For example '/boot'. No default value.
# [*space_usage*]
#   Notify if disk space usage on the filesystem exceeds this percentage. 
#   Defaults to '90%'.
# [*email*]
#   Email where monit notifications/alerts are sent. Defaults to global variable 
#   $::servermonitor.
#
define monit::filesystem
(
    $fs_name,
    $path,
    $space_usage = '90%',
    $email = $::servermonitor
)
{
    include monit::params

    file { "monit-${fs_name}-filesystem.monit":
        ensure  => present,
        name    => "${::monit::params::fragment_dir}/${fs_name}-filesystem.monit",
        content => template('monit/filesystem.monit.erb'),
        owner   => root,
        group   => "${::monit::params::admingroup}",
        mode    => 600,
        require => File['monit-conf.d'],
        notify  => Class['monit::service'],
    }
}
