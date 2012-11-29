# encoding: UTF-8
require File.expand_path('../lib/sshwitch_version', __FILE__)

version = Sshwitch::VERSION
Gem::Specification.new do |s|
  s.name        = 'sshwitch'
  s.version     = version
  s.date        = '2012-10-29'
  s.summary     = "Manage your ssh keys"
  s.description = "Manage different sets of keys in your home folder"
  s.authors     = ["Agustín Leñero"]
  s.email       = 'agush@roca9.com'
  s.files       = ["bin/sshwitch"]
  s.executables = ["sshwitch"]
  s.homepage    = 'http://rubygems.org/gems/sshwitch'
end
