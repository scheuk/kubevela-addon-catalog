publicaccess: {
	alias: ""
	annotations: {

	}
	attributes: {
		appliesToWorkloads: ["gcp-cloudrun-service"]
	}
	description: "Make a Cloud Run service availible to the public"
	type: "trait"
}

template: {
	outputs: ServiceIAMMember: {
				apiVersion: "cloudrun.gcp.upbound.io/v1beta1"
				kind:       "ServiceIAMMember"
				metadata: labels: {
					"takeoff.com/name": context.name
				}
				spec: {
					forProvider: {
						location: "us-central1"
						member: "allUsers"
						role: "roles/run.invoker"
						serviceSelector:
							matchLabels: 
								"takeoff.com/name": context.name
					}
					providerConfigRef: {
						name: context.output.spec.providerConfigRef.name
					}
				}
			}
}

