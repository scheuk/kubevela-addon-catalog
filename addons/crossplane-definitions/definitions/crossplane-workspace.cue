import "strings"

"crossplane-terraform-workspace": {
	type:        "component"
	description: "Create a workspace for the Crossplane Terraform Provider"
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	output: {
		apiVersion: "tf.upbound.io/v1beta1"
		kind:       "Workspace"
		spec: {
      providerConfigRef: name: parameter.providerConfigRef
			forProvider:
				initArgs: [
					"-backend-config=prefix=\(context.namespace)/\(context.name)"
				]
				source: parameter.source
				module: parameter.module
				vars: module.vars
		}
	}

	parameter: {
		//+usage=The name of Crossplane Provider Terraform, default to `default`
		// name: *"default" | string
		//+usage= ProviderConfig to use
		providerConfigRef: string
		//+usage=GCP google storage bucket to store state
		gcsStorageBucket: string
		//+usage=Define the source of the modile Inline:Source 
		source: "Inline" | "Source"
		//+usage=Either the module code or a module source url
		module: string
		vars: *[] | [...string]
	}
}
