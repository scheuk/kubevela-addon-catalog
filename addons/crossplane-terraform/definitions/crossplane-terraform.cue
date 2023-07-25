import "strings"

"crossplane-terraform": {
	type:        "component"
	description: "Terraform Provider for Crossplane"
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	output: {
		apiVersion: "tf.upbound.io/v1beta1"
		kind:       "ProviderConfig"
		metadata: {
			name: parameter.name
			namespace: "vela-system"
		}
		spec: {
			credentials: [
				{
				env: 
					name: "GOOGLE_IMPERSONATE_SERVICE_ACCOUNT"
				filename: "credentials.json"
				source: "Secret"
				secretRef: {
					namespace: "vela-system"
					name:      parameter.name + "-account-creds-crossplane"
					key:       "credentials"
				}
				}
			]
			configuration: """
				// Modules _must_ use remote state. The provider does not persist state.
				terraform {
					backend "kubernetes" {
						secret_suffix     = "providerconfig-default"
						namespace         = "vela-system"
						in_cluster_config = true
					}
				}
			"""
		}
	}

	outputs: {
		"credential": {
			apiVersion: "v1"
			kind:       "Secret"
			metadata: {
				name:      parameter.name + "-account-creds-crossplane"
				namespace: "vela-system"
			}
			type: "Opaque"
			stringData: credentials: parameter.SERVICE_ACCOUNT
		}
	}

	parameter: {
		//+usage=The name of Crossplane Provider Terraform, default to `default`
		name: *"default" | string
		//+usage=GCP ServiceAccount to run terraform under
		SERVICE_ACCOUNT: string
	}
}
