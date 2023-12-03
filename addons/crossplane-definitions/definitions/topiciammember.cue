"gcp-topiciammember": {
	alias: ""
	annotations: {}
	attributes: {
	  status: healthPolicy: #"""
			isHealth: len(context.output.status.atProvider) != 0 && context.output.status.conditions[0]["status"]=="True"
			"""#
		workload: definition: {
		apiVersion: "pubsub.gcp.upbound.io/v1beta1"
		kind:       "TopicIAMMember"
		}
	}
	description: "GCP Pub/Sub Topic IAMMember resource"
	labels: {}
	type: "component"  
}

template: {
	output: {
		apiVersion: "pubsub.gcp.upbound.io/v1beta1"
		kind:       "TopicIAMMember"
		spec: {
      providerConfigRef: name: parameter.providerConfigName
      forProvider: {
				member: parameter.member
				role: parameter.role
				topicRef: name: parameter.topic
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
    topic: string
    // +usage=Role to assign to member
    role: *"roles/pubsub.publisher" | string
  }
}
