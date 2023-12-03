apigeeproxy: {
	alias: ""
	annotations: {}
	attributes: workload: type: "autodetects.core.oam.dev"
	description: "Deploy an apigee proxy for the named component"
	type: "component"
	status: {}
}

template: {
	output: {
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
					value: parameter.component
				}, {
					key:   "base_path"
					value: parameter.path
				}, {
					key:   "cloudrun_url"
					value: parameter.cloudrun_url
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
  outputs: {
		ServiceIAMMember: {
			apiVersion: "cloudrun.gcp.upbound.io/v1beta1"
			kind:       "ServiceIAMMember"
			metadata: labels: {
				"takeoff.com/name": parameter.component
			}
			spec: {
				forProvider: {
					location: "us-central1"
					member: "serviceAccount:sa-apigee-invoker@" + parameter.apigee_project_id + ".iam.gserviceaccount.com"
					role: "roles/run.invoker"
					serviceSelector:
						matchLabels: 
							"takeoff.com/name": parameter.component
				}
				providerConfigRef: {
					name: parameter.cloudrun_project_id
				}
			}
		}
	}
	parameter: {
		// +usage=Component to proxy to
		component: string
		// +usage=Path to map on the apigee gateway
		path: string
		// +usage=Proxy template to use
		template: *"basicReverseProxy" | string
		apigee_project_id: *"prj-sche-apigee-f2ad" | string
		cloudrun_project_id: string
		// +usage=Cloud Run service URL
		cloudrun_url: string
	}
}

