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
			projectID: parameter.projectId
			if parameter.impersonateServiceAccount == _|_ {
				credentials: source: "InjectedIdentity"
			}
			if parameter.impersonateServiceAccount != _|_ {
				credentials: {
					source: "ImpersonateServiceAccount"
					impersonateServiceAccount: name: parameter.impersonateServiceAccount
				}
			}
		}
	}

	parameter: {
		//+usage=GCP project ID to operate on
		projectId: string
		//+usage=GCP ServiceAccount to impersonate
		impersonateServiceAccount: string
	}
}

