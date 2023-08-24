package main

_includeControllerConfig: *false | bool

if parameter.gcpSaEmail != _|_ || parameter.args != _|_ {
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
			familyProvider,
			providers,
			if _includeControllerConfig {controllerConfig},
		]
	}
}
