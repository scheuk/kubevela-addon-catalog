import "strconv"

"gcp-cloudrun-service": {
	type:        "component"
	description: "GCP CloudRun Service"
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
				metadata: [{
					if parameter.ingressType != _|_ {
						annotations: "run.googleapis.com/ingress": parameter.ingressType
					}
				}]
				template: [{
					metadata: [{
						if parameter.maxInstances != _|_ {
							annotations: "autoscaling.knative.dev/maxScale": strconv.FormatInt(parameter.maxInstances, 10)
						}
					}]
					spec: [{
						containers: [{
							image: parameter.image
							if parameter.env != _|_ {
								env: parameter.env
							}
						}]
						if parameter.containerConcurrency != _|_ {
							containerConcurrency: parameter.containerConcurrency
						}
						if parameter.serviceAccount != _|_ {
							serviceAccountName: parameter.serviceAccount
						}
					}]
				}]
				traffic: [{
					latestRevision: true
					percent: 100
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
		// +usage=Env variables to pass to the image
		env?: [...#Env]
		// +usage=Container Concurrency
		containerConcurrency?: int
		// +usage=Max Instanances
		maxInstances?: int
		// +usage=ServiceAccount name for this service
		serviceAccount?: string
		// +usage=Ingress restriction type (all,internal,internal-and-cloud-load-balancing)
		// ingressType?: "all","internal","internal-and-cloud-load-balancing"
		ingressType?: string
	}
}
