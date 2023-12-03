"gcp-spanner-instance": {
	alias: ""
	annotations: {}
	attributes: {
	  status: healthPolicy: #"""
			isHealth: len(context.output.status.atProvider) != 0 && context.output.status.conditions[0]["status"]=="True"
			"""#
		workload: definition: {
		apiVersion: "spanner.gcp.upbound.io/v1beta1"
		kind:       "Instance"
		}
	}
	description: "Deploy a spanner instance"
	labels: {}
	type: "component"  
}

template: {
	output: {
		apiVersion: "spanner.gcp.upbound.io/v1beta1"
		kind:       "Instance"
		spec: {
      providerConfigRef: name: parameter.providerConfigName
      forProvider: {
        config:          parameter.config
        displayName:     context.name
        forceDestroy:    parameter.forceDestroy
        processingUnits: parameter.processingUnits
		  }
    }
	}
	outputs: {}
	parameter: {
    // +usage=Providerconfig for this instance
    providerConfigName: string
    // +usage=Location configuration for spanner instance
    config: *"regional-us-central1" | string
    // +usage=Processing units for this instances
    processingUnits: *100 | int
    // +usage=Force destroy
    forceDestroy: *false | bool
  }
}
