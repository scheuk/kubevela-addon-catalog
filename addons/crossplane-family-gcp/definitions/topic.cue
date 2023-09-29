"gcp-topic": {
	alias: ""
	annotations: {}
	attributes: {
	  status: healthPolicy: #"""
			isHealth: len(context.output.status.atProvider) != 0 && context.output.status.conditions[0]["status"]=="True"
			"""#
		workload: definition: {
		apiVersion: "pubsub.gcp.upbound.io/v1beta1"
		kind:       "Topic"
		}
	}
	description: "GCP Pub/Sub Topic resource"
	labels: {}
	type: "component"  
  status: healthPolicy: #"""
			isHealth: len(context.output.status.atProvider) != 0 && context.output.status.conditions[0]["status"]=="True"
			"""#
}

template: {
	output: {
		apiVersion: "pubsub.gcp.upbound.io/v1beta1"
		kind:       "Topic"
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
