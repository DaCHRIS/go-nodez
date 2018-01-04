Pod::Spec.new do |spec|
  spec.name         = 'Nodez'
  spec.version      = '{{.Version}}'
  spec.license      = { :type => 'GNU Lesser General Public License, Version 3.0' }
  spec.homepage     = 'https://github.com/NodezCrypto/go-nodez'
  spec.authors      = { {{range .Contributors}}
		'{{.Name}}' => '{{.Email}}',{{end}}
	}
  spec.summary      = 'iOS Nodez Client'
  spec.source       = { :git => 'https://github.com/NodezCrypto/go-nodez.git', :commit => '{{.Commit}}' }

	spec.platform = :ios
  spec.ios.deployment_target  = '9.0'
	spec.ios.vendored_frameworks = 'Frameworks/Nodez.framework'

	spec.prepare_command = <<-CMD
    curl https://gethstore.blob.core.windows.net/builds/{{.Archive}}.tar.gz | tar -xvz
    mkdir Frameworks
    mv {{.Archive}}/Nodez.framework Frameworks
    rm -rf {{.Archive}}
  CMD
end
