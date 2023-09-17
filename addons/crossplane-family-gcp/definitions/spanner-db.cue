"gcp-spanner-db": {
	alias: ""
	annotations: {}
	attributes: workload: definition: {
		apiVersion: "spanner.gcp.upbound.io/v1beta1"
		kind:       "Database"
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
				instanceRef: name: parameter.instanceName
				versionRetentionPeriod: parameter.versionRetentionPeriod
			}
			providerConfigRef: name: parameter.providerConfigName
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
		// +usage=Instance Name
		instanceName: string
	}
}
