import "strings"

"crossplane-gcp": {
	type:        "component"
	description: "GCP Provider for Crossplane"
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	output: {
		apiVersion: "gcp.upbound.io/v1beta1"
		kind:       "ProviderConfig"
		metadata:
			name: context.name
		spec: {
			projectID: context.name
			credentials: source: "InjectedIdentity"
		}
	}

	parameter: {}
}
