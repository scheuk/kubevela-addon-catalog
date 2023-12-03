"gcp-serviceaccount": {
	alias: ""
	annotations: {}
	attributes: {
		status: healthPolicy: #"""
				isHealth: len(context.output.status.atProvider) != 0 && context.output.status.conditions[0]["status"]=="True"
				"""#
		workload: definition: {
		apiVersion: "cloudplatform.gcp.upbound.io/v1beta1"
		kind:       "ServiceAccount"
		}
	}
	description: "GCP ServiceAccount resource"
	labels: {}
	type: "component"  
}

template: {
	output: {
		apiVersion: "cloudplatform.gcp.upbound.io/v1beta1"
		kind:       "ServiceAccount"
		spec: {
      providerConfigRef: name: parameter.providerConfigName
      forProvider: displayName: context.name
    }
	}
	outputs: {}
	parameter: {
    // +usage=Providerconfig for this instance
    providerConfigName: string
  }
}
