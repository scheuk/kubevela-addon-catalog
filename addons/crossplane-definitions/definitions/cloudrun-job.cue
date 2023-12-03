import "strconv"

"gcp-cloudrun-job": {
	type:        "component"
	description: "GCP CloudRun Job"
	attributes: { 
		workload: {
			type: "autodetects.core.oam.dev"
		}

		status: {
			// customStatus: #"""
			// 	ready: {
			// 		url: *"Not Ready" | string
			// 	} & {
			// 		if context.output.status.atProvider.status[0].url != _|_ {
			// 				url: context.output.status.atProvider.status[0].url
			// 		}
			// 	}
			// 	message: "App URL: \(ready.url)"
			// """#
			healthPolicy: #"""
				isHealth: len(context.output.status.atProvider) != 0 && context.output.status.conditions[0]["status"]=="True"
				"""#
		}
	}
}

template: {
	output: {
		apiVersion: "cloudrun.gcp.upbound.io/v1beta1"
		kind:       "V2Job"
		metadata: labels: {
			"takeoff.com/name": context.name
		}
		spec: {
			forProvider: {
				location: parameter.location
				template: [{
					template: [{
						containers: [{
							if parameter.args != _|_ {
								args: parameter.args
							}
							if parameter.env != _|_ {
								env: parameter.env
							}
							image: parameter.image
						}]
						if parameter.serviceAccount != _|_ {
							serviceAccount: parameter.serviceAccount
						}
						timeout: parameter.timeout
					}]
				}]
			}
			providerConfigRef: name: parameter.providerConfigName
		}
	}

	#Env: {
		name:  string
		value: string
	}

	parameter: {
		// +usage=The container Image to deploy
		image: string
		// +usage=The ProviderConfig name
		providerConfigName: *"gcp" | string
		// +usage=Cloud run Region
		location: *"us-central1" | string
		// +usage=Env variables to pass to the image
		env?: [...#Env]
		// +usage=ServiceAccount name for this service
		serviceAccount?: string
		// +usage=Args to pass to the container image
		args?: [...string]
		// +usage=Timeout for the job
		timeout: "600s" | string
	}
}
