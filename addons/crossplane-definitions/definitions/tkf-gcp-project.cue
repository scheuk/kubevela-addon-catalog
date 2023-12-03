import "strings"

"tkf-gcp-project": {
	type:        "component"
	description: "Create google project in the environment"
	attributes: {
		workload: definition: {
			apiVersion: "tf.upbound.io/v1beta1"
			kind:       "Workspace"
		}
		status: {
			healthPolicy: #"""
			isHealth: len(context.output.status.conditions) != 0 && context.output.status.conditions[0]["status"]=="True"
			"""#
		}
	}
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
				module: "github.com/takeoff-com/on-demand-env.git//terraform/modules?ref=PROD-11065-deploy-tote-manager"
				entrypoint: "project"
				varmap: {
					name: context.name
					impersonate_project_sa: true
					if parameter.activateApis != _|_ {
						activate_apis: parameter.activateApis
					}
				}
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
		//+usage=ProviderConfig to use
		providerConfigRef: string
		//+usage=APIs to activate
		activateApis?: [...string]
	}
}
