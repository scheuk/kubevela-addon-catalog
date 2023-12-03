apigateway: {
	alias: ""
	annotations: {

	}
	attributes: {
		appliesToWorkloads: ["gcp-cloudrun-service"]
		stage: "PostDispatch"
	}
	description: "Make a Cloud Run service availible through the apigateway"
	type: "trait"
}

template: {
	parameter: {
		// +usage=Path to map on the apigee gateway
		path: string
		// +usage=Proxy template to use
		template: *"basicReverseProxy" | string
		apigee_project_id: *"prj-sche-apigee-f2ad" | string
	}
	outputs: {
		poxyConfig: {
			apiVersion: "tf.upbound.io/v1beta1"
			kind:       "Workspace"
			metadata: labels: {
				"takeoff.com/name": context.name
			}
			spec: {
				forProvider: {
					module: "github.com/takeoff-com/on-demand-env.git//kubevela/terraform/apigee-proxy?ref=POC-kubevela"
					source: "Remote"
					vars: [{
						key:   "component_name"
						value: context.name
					}, {
						key:   "base_path"
						value: parameter.path
					}, {
						key:   "cloudrun_url"
						value: context.output.status.atProvider.status[0].url
					}, {
						key:   "apigee_project_id"
						value: parameter.apigee_project_id
					}, {
						key:   "proxy_template"
						value: parameter.template
					}]
				}
				providerConfigRef: name: "gcp-wi"
			}
		}
		ServiceIAMMember: {
			apiVersion: "cloudrun.gcp.upbound.io/v1beta1"
			kind:       "ServiceIAMMember"
			metadata: labels: {
				"takeoff.com/name": context.name
			}
			spec: {
				forProvider: {
					location: "us-central1"
					member: "serviceAccount:sa-apigee-invoker@" + parameter.apigee_project_id + ".iam.gserviceaccount.com"
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
}

