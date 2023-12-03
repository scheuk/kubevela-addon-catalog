import "strings"

"crossplane-terraform-providerconfig": {
	type:        "component"
	description: "Create a ProviderConfig for the Crossplane Terraform Provider"
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	output: {
		apiVersion: "tf.upbound.io/v1beta1"
		kind:       "ProviderConfig"
		spec: {
			credentials: parameter.credentials
			configuration: """
				provider "google" {
					project = "\(parameter.projectId)"
					impersonate_service_account = "\(parameter.serviceAccount)"
				}
				provider "google-beta" {
					project = "\(parameter.projectId)"
					impersonate_service_account = "\(parameter.serviceAccount)"
				}
				// Modules _must_ use remote state. The provider does not persist state.
				terraform {
					backend "gcs" {
						bucket = "\(parameter.storageBucket)"
						prefix = "changeme"
					}
				}
			"""
		}
	}

	parameter: {
		//+usage=The name of Crossplane Provider Terraform, default to `default`
		// name: *"default" | string
		//+usage=GCP Project_ID to operate on
		projectId: *"" | string
		//+usage=GCP ServiceAccount to impersonate
		serviceAccount: string
		//+usage=GCP google storage bucket to store state
		storageBucket: string
		//+usage=Define the credentials to use for this providerConfig
		credentials: *[] | [...{}]
	}
}
