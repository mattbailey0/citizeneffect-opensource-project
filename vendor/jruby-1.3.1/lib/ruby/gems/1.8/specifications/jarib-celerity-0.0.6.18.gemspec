# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jarib-celerity}
  s.version = "0.0.6.18"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jari Bakken", "T. Alexander Lystad", "Knut Johannes Dahle"]
  s.date = %q{2009-08-25}
  s.description = %q{Celerity is a JRuby wrapper around HtmlUnit – a headless Java browser with JavaScript support. It provides a simple API for programmatic navigation through web applications. Celerity aims at being API compatible with Watir.}
  s.email = %q{jari.bakken@finn.no}
  s.extra_rdoc_files = ["History.txt", "License.txt"]
  s.files = ["History.txt", "lib", "lib/celerity", "lib/celerity/browser.rb", "lib/celerity/clickable_element.rb", "lib/celerity/collections.rb", "lib/celerity/container.rb", "lib/celerity/default_viewer.rb", "lib/celerity/disabled_element.rb", "lib/celerity/element.rb", "lib/celerity/element_collection.rb", "lib/celerity/element_locator.rb", "lib/celerity/elements", "lib/celerity/elements/button.rb", "lib/celerity/elements/file_field.rb", "lib/celerity/elements/form.rb", "lib/celerity/elements/frame.rb", "lib/celerity/elements/image.rb", "lib/celerity/elements/label.rb", "lib/celerity/elements/link.rb", "lib/celerity/elements/meta.rb", "lib/celerity/elements/non_control_elements.rb", "lib/celerity/elements/option.rb", "lib/celerity/elements/radio_check.rb", "lib/celerity/elements/select_list.rb", "lib/celerity/elements/table.rb", "lib/celerity/elements/table_cell.rb", "lib/celerity/elements/table_elements.rb", "lib/celerity/elements/table_row.rb", "lib/celerity/elements/text_field.rb", "lib/celerity/exception.rb", "lib/celerity/htmlunit", "lib/celerity/htmlunit/commons-codec-1.4.jar", "lib/celerity/htmlunit/commons-collections-3.2.1.jar", "lib/celerity/htmlunit/commons-httpclient-3.1.jar", "lib/celerity/htmlunit/commons-io-1.4.jar", "lib/celerity/htmlunit/commons-lang-2.4.jar", "lib/celerity/htmlunit/commons-logging-1.1.1.jar", "lib/celerity/htmlunit/cssparser-0.9.5.jar", "lib/celerity/htmlunit/htmlunit-2.6-SNAPSHOT.jar", "lib/celerity/htmlunit/htmlunit-core-js-2.6-SNAPSHOT.jar", "lib/celerity/htmlunit/nekohtml-1.9.13-20090820.100833-15.jar", "lib/celerity/htmlunit/sac-1.3.jar", "lib/celerity/htmlunit/serializer-2.7.1.jar", "lib/celerity/htmlunit/xalan-2.7.1.jar", "lib/celerity/htmlunit/xercesImpl-2.9.1.jar", "lib/celerity/htmlunit/xml-apis-1.3.04.jar", "lib/celerity/htmlunit.rb", "lib/celerity/identifier.rb", "lib/celerity/ignoring_web_connection.rb", "lib/celerity/input_element.rb", "lib/celerity/listener.rb", "lib/celerity/resources", "lib/celerity/resources/no_viewer.png", "lib/celerity/short_inspect.rb", "lib/celerity/util.rb", "lib/celerity/version.rb", "lib/celerity/viewer_connection.rb", "lib/celerity/watir_compatibility.rb", "lib/celerity/xpath_support.rb", "lib/celerity.rb", "License.txt", "Rakefile", "README.markdown", "tasks", "tasks/jar.rake", "tasks/rdoc.rake"]
  s.homepage = %q{http://celerity.rubyforge.org}
  s.rdoc_options = ["--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{celerity}
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Celerity is a JRuby library for easy and fast functional test automation for web applications}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<sinatra>, [">= 0.9.4"])
      s.add_development_dependency(%q<hoe>, [">= 2.3.2"])
    else
      s.add_dependency(%q<sinatra>, [">= 0.9.4"])
      s.add_dependency(%q<hoe>, [">= 2.3.2"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 0.9.4"])
    s.add_dependency(%q<hoe>, [">= 2.3.2"])
  end
end
