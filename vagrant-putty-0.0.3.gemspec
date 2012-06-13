# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{vagrant-putty}
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Dellanoce"]
  s.date = %q{2011-10-22}
  s.description = %q{A Vagrant plugin to PuTTY into a VM}
  s.email = ["michael.dellanoce@gmail.com"]
  s.homepage = %q{http://rubygems.org/gems/vagrant-putty}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{vagrant-putty}
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{A Vagrant plugin to PuTTY into a VM}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<vagrant>, [">= 1.0.3"])
      s.add_development_dependency(%q<mocha>, ["~> 0.10.0"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
    else
      s.add_dependency(%q<vagrant>, [">= 1.0.3"])
      s.add_dependency(%q<mocha>, ["~> 0.10.0"])
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
    end
  else
    s.add_dependency(%q<vagrant>, [">= 1.0.3"])
    s.add_dependency(%q<mocha>, ["~> 0.10.0"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
  end
end
