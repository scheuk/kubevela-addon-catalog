"gcp-spanner-project": {
	alias: ""
	annotations: {}
	attributes: {
	  status: healthPolicy: #"""
			isHealth: len(context.output.status.atProvider) != 0 && context.output.status.conditions[0]["status"]=="True"
			"""#
		workload: definition: {
		apiVersion: "gcp.takeoff.com/v1beta1"
		kind:       "SpannerProject"
		}
	}
	description: "Deploy a spanner instance in a dedicated project"
	labels: {}
	type: "component"  
}

template: {
	output: {
		apiVersion: "gcp.takeoff.com/v1beta1"
		kind:       "SpannerProject"
		spec: {
      spanner: {
        config:          parameter.config
        forceDestroy:    parameter.forceDestroy
        processingUnits: parameter.processingUnits
		  }
    }
	}

	parameter: {
    // +usage=Location configuration for spanner instance
    config: *"regional-us-central1" | string
    // +usage=Processing units for this instances
    processingUnits: *100 | int
    // +usage=Force destroy
    forceDestroy: *false | bool
  }
}
