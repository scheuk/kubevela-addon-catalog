import "strings"

"tkf-gcp-project": {
	type:        "component"
	description: "Create google project in the environment"
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	output: {
		apiVersion: "tf.upbound.io/v1beta1"
		kind:       "Workspace"
		spec: {
      providerConfigRef: name: parameter.providerConfigRef
			forProvider: {
				initArgs: [
					"-backend-config=prefix=\(context.namespace)/\(context.name)"
				]
				source: "Remote"
				module: "github.com/takeoff-com/on-demand-env.git//terraform/modules"
				entrypoint: "project"
				vars: [
					{
						key: "name"
						value: context.name
					}
				]
				varFiles: [
					{
						format: "JSON"
						configMapKeyRef: {
							key: "global-vars.tfvar.json"
							name: "global-vars"
							namespace: "vela-system"
						}
						source: "ConfigMapKey"
					}
				]
			}
		}
	}

	parameter: {
		//+usage= ProviderConfig to use
		providerConfigRef: string
	}
}
