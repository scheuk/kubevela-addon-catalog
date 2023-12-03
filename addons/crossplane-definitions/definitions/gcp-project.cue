"gcp-project": {
	alias: ""
	annotations: {}
	attributes: {
	  status: healthPolicy: #"""
			isHealth: len(context.output.status.atProvider) != 0 && context.output.status.conditions[0]["status"]=="True"
			"""#
		workload: definition: {
		apiVersion: "gcp.takeoff.com/v1beta1"
		kind:       "Project"
		}
	}
	description: "create a google project"
	labels: {}
	type: "component"  
}

template: {
	output: {
		apiVersion: "gcp.takeoff.com/v1beta1"
		kind:       "Project"
		if parameter.activateApis != _|_ {
			spec: activateApis: parameter.activateApis
		}
	}

	parameter: {
		//+usage=APIs to activate
		activateApis?: [...string]
  }
}
