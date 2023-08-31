package main

_includeControllerConfig: *false | bool

if parameter.terraformSaEmail != _|_ || parameter.args != _|_ {
	_includeControllerConfig: true
}

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	metadata: {
		namespace: const.namespace
	}
	spec: {
		components: [
			provider,
			if _includeControllerConfig {controllerConfig},
		]
	}
}
