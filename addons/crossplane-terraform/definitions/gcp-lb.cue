import "strconv"

"gcp-lb": {
	alias: ""
	annotations: {}
	attributes: workload: type: "autodetects.core.oam.dev"
	description: "Enable dns based web traffic for the component"
	labels: {}
	type: "component"
}

template: {
	let serviceName = context.appName + "-lb"
	let providerConfigRefName = parameter.providerConfigName + "-tf"

	output: {
		apiVersion: "tf.upbound.io/v1beta1"
		kind:      	"Workspace"
		metadata: name: "\(serviceName)"
		spec: {
			providerConfigRef: name: "\(providerConfigRefName)"
			forProvider: {
				initArgs: [
					"-backend-config=prefix=\(context.namespace)/\(serviceName)"
				]
				source: "Remote"
				module: "github.com/takeoff-com/on-demand-env.git//terraform/modules?ref=PROD-11065-deploy-tote-manager"
				entrypoint: "http-lb"
				varmap: {
					cloud_run_name: context.appName + "-service"
					service_name: context.appName
					project_id: parameter.projectId
					domain: "scheukidptm.ode.takeofftech.org"
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
		// +usage=The ProviderConfig name
		providerConfigName: *"gcp" | string
		// +usage=The Runtime ProjectID
		projectId: string
	}
}

