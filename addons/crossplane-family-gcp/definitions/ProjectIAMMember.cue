"gcp-projectiammember": {
	alias: ""
	annotations: {}
	attributes: workload: definition: {
		apiVersion: "cloudplatform.gcp.upbound.io/v1beta1"
		kind:       "ProjectIAMMember"
	}
	description: "Project IAM Member resource"
	labels: {}
	type: "component"  
  // status: healthPolicy: #"""
	// 		isHealth: len(context.output.status.conditions) != 0 && context.output.status.conditions[0]["status"]=="True"
	// 		"""#
}

template: {
	output: {
		apiVersion: "cloudplatform.gcp.upbound.io/v1beta1"
		kind:       "ProjectIAMMember"
		spec: {
      providerConfigRef: name: parameter.providerConfigName
      forProvider: {
        member:          parameter.member
				project:         parameter.project
				role: 					 parameter.role
		  }
    }
	}
	outputs: {}
	parameter: {
    // +usage=Providerconfig for this instance
    providerConfigName: string
    // +usage=Principal to assign role to (user,group,serviceaccount)
    member: string
    // +usage=Processing units for this instances
    project: string
    // +usage=Force destroy
    role: string
  }
}
