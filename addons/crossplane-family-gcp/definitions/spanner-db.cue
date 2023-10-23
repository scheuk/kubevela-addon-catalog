"gcp-spanner-db": {
	alias: ""
	annotations: {}
	attributes: {
	  status: healthPolicy: #"""
			isHealth: len(context.output.status.atProvider) != 0 && context.output.status.conditions[0]["status"]=="True"
			"""#
		workload: definition: {
		apiVersion: "spanner.gcp.upbound.io/v1beta1"
		kind:       "Database"
		}
	}
	description: ""
	labels: {}
	type: "component"
}

template: {
	output: {
		apiVersion: "spanner.gcp.upbound.io/v1beta1"
		kind:       "Database"
		spec: {
			forProvider: {
				databaseDialect: parameter.databaseDialect
				deletionProtection: parameter.deletionProtection
				instanceRef: name: parameter.instance
				versionRetentionPeriod: parameter.versionRetentionPeriod
			}
			providerConfigRef: name: parameter.providerConfigName
		}
	}
	outputs: iam: {
		apiVersion: "spanner.gcp.upbound.io/v1beta1"
		kind:       "DatabaseIAMMember"
		spec: {
      providerConfigRef: name: parameter.providerConfigName
      forProvider: {
				member: parameter.member
				role: parameter.role
				instance: parameter.instance
				database: context.name
			}
    }
	}	

	parameter: {
		// +usage=Providerconfig for this instance
    providerConfigName: string
		// +usage=Database dialect to use
		databaseDialect: *"GOOGLE_STANDARD_SQL" | string
		// +usage=Deletion Protection
		deletionProtection: *false | bool
		// +usage=Version Retention period
		versionRetentionPeriod: *"1d" | string
		// +usage=Spanner Instance Name
		instance: string
    // +usage=Principal to assign role to (user,group,serviceaccount)
    member: string
    // +usage=Role to assign to member, defaults to roles/spanner.databaseUser
    role: *"roles/spanner.databaseUser" | string
	}
}
