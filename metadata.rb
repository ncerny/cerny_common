name 'cerny_common'
maintainer 'Nathan Cerny'
maintainer_email 'ncerny@gmail.com'
license 'apache2'
description 'cerny environment common cookbook'
long_description 'The base/common cookbook for my personal environment.'
version '0.3.0'

supports 'redhat', '>= 7.0.0'

depends 'ntp'
depends 'chef-client'
depends 'firewalld'
