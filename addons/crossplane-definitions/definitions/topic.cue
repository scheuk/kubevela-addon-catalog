import "strings"

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
		kind:       "TopicIAMMember"
		metadata: name: parameter.metadataname
		spec: {
      providerConfigRef: name: parameter.providerConfigName
      forProvider: {
				member: parameter.member
				role: parameter.role
				topicRef: name: parameter.metadataname
			}
    }
	}
	outputs: topic: {
		apiVersion: "pubsub.gcp.upbound.io/v1beta1"
		kind:       "Topic"
		metadata: {
			annotations: "crossplane.io/external-name": context.name
			name: parameter.metadataname
		}
		spec: {
      providerConfigRef: name: parameter.providerConfigName
      forProvider: displayName: context.name
    }
	}

	parameter: {
    // +usage=Providerconfig for this instance
    providerConfigName: string
    // +usage=Principal to assign role to (user,group,serviceaccount)
    member: string
    // +usage=Role to assign to member, defaults to roles/pubsub.publisher
    role: *"roles/pubsub.publisher" | string
		// need to not have . in the k8s object name
		metadataname: *strings.Replace(context.name, ".", "-", -1) | string
  }
}
