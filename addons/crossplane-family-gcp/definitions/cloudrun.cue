"gcp-cloudrun-service": {
	type:        "component"
	description: "GCP CloudRun V2Service"
	attributes: { 
		workload: {
			type: "autodetects.core.oam.dev"
		}

		status: {
			customStatus: #"""
				ready: {
					url: *"Not Ready" | string
				} & {
					if context.output.status.atProvider.status[0].url != _|_ {
							url: context.output.status.atProvider.status[0].url
					}
				}
				message: "App URL: \(ready.url)"
			"""#
			healthPolicy: #"""
				isHealth: len(context.output.status.atProvider.status) != 0 && context.output.status.atProvider.status[0].conditions[0].status=="True"
				"""#
		}
	}
}

template: {
	output: {
		apiVersion: "cloudrun.gcp.upbound.io/v1beta1"
		kind:       "Service"
		metadata: labels: {
			"takeoff.com/name": context.name
		}
		spec: {
			forProvider: {
				location: "us-central1"
				template: [{
					spec: [{
						containers: [{
							image: parameter.image
						}]
					}]
				}]
				traffic: [{
					latestRevision: true
					percent: 100
				}]
			}
			providerConfigRef: {
				name: parameter.providerConfigName
			}
		}
	}

	parameter: {
		// +usage=The container Image to deploy
		image: string
		// +usage=The ProviderConfig name
		providerConfigName: *"gcp" | string
	}
}
