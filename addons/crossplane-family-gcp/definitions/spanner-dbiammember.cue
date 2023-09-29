"gcp-spanner-databaseiammember": {
	alias: ""
	annotations: {}
	attributes: {
	  status: healthPolicy: #"""
			isHealth: len(context.output.status.atProvider) != 0 && context.output.status.conditions[0]["status"]=="True"
			"""#
		workload: definition: {
		apiVersion: "spanner.gcp.upbound.io/v1beta1"
		kind:       "DatabaseIAMMember"
		}
	}
	description: "GCP Pub/Sub Topic IAMMember resource"
	labels: {}
	type: "component"  
}

template: {
	output: {
		apiVersion: "spanner.gcp.upbound.io/v1beta1"
		kind:       "DatabaseIAMMember"
		spec: {
      providerConfigRef: name: parameter.providerConfigName
      forProvider: {
				member: parameter.member
				role: parameter.role
				instance: parameter.instance
				database: parameter.database
			}
    }
	}
	outputs: {}
	parameter: {
    // +usage=Providerconfig for this instance
    providerConfigName: string
    // +usage=Principal to assign role to (user,group,serviceaccount)
    member: string
		// +usage=Spanner Instance Name
		instance: string
		// +usage=Spanner Database Name
		database: string
    // +usage=Force destroy
    role: *"roles/spanner.databaseUser" | string
  }
}
