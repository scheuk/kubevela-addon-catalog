import (
	"encoding/json"
)

"gcp-takeoff-service": {
	alias: ""
	annotations: {}
	attributes: {
	  status: healthPolicy: #"""
			isHealth: len([for i in context.output.status.conditions if (i.type == "Ready") && (i.status == "True") {i}]) > 0
			"""#
		workload: definition: {
		apiVersion: "takeoff.com/v1beta1"
		kind:       "Service"
		}
	}
	description: "Deploy a service on GCP Cloud Run"
	labels: {}
	type: "component"  
}

template: {
	output: {
		apiVersion: "takeoff.com/v1beta1"
		kind:       "Service"
		spec: {
			image: parameter.image
			location: parameter.location
			if parameter.public != _|_ {
				public: parameter.public
			}
			if parameter.port != _|_ {
				port: parameter.port
			}
			if parameter.ingressType != _|_ {
				ingressType: parameter.ingressType
			}
			if parameter.containerConcurrency != _|_ {
				containerConcurrency: parameter.containerConcurrency
			}
			if parameter.maxInstances != _|_ {
				maxInstances: parameter.maxInstances
			}
			if parameter.env != _|_ {
				env: [for v in parameter.env {{
					name: v.name
					if v.value != _|_ {
						value: v.value
					}
					if v.valueFromEnv != _|_ {
						valueFromEnv: v.valueFromEnv
					}
				}}]
			}
			if parameter.spanner != _|_ {
				spanner: parameter.spanner
			}
			if parameter.topics != _|_ {
				topics: [for v in parameter.topics {{
					if v.type != _|_ {
						type: v.type
					}
					name: v.name
					if v.fullName != _|_ {
						fullName: v.fullName
					}
					envKey: v.envKey
					if v.projectId != _|_ {
						projectId: v.projectId
					}
				}}]
			}
			if parameter.loadBalancer != _|_ {
				loadBalancer: parameter.loadBalancer
			}
    }
	}

	parameter: {
		// +usage=The container Image to deploy
		image: string
		// +usage=The location to deploy the container
		location: *"us-central1" | string
		// +usage=Enable public access to the service, default false
		public?: bool
		// +usage=The port to expose, default 8080
		port?: *8080 | int
		// +usage=Ingress restriction type (all,internal,internal-and-cloud-load-balancing)
		// ingressType?: "all","internal","internal-and-cloud-load-balancing"
		ingressType?: string
		// +usage=Container Concurrency
		containerConcurrency?: int
		// +usage=Max Instanances
		maxInstances?: int
		// +usage=Env variables to pass to the image
		env?: [...{
			name: string
			value?: string
			valueFromEnv?: string
		}]
		#spannerConfig: {
			// +usage=The name of the Spanner Database to create
			dbname: string
			// +usage=The spanner instance to create the database in, defaults to shared-spanner
			instance?: string
			// +usage=The database dialect to use, defaults to GOOGLE_STANDARD_SQL
			databaseDialect?: "GOOGLE_STANDARD_SQL" | "POSTGRESQL"
			// +usage=Enable deletion protection, defaults to false
			deletionProtection?: bool
			// +usage=The environment variable to pass the database name to
			envKey: string
		}
		// +usage=Create a spanner database for the service
		spanner?: #spannerConfig
		// +usage=PubSub topics to create for the service
		topics?: [...{
			// +usage=Create or connect to an exsisting topic, defaults to CREATE
			type?: "CREATE" | "CONNECT"
			// +usage=The name of the topic to create, example: servicename.topicname
			name: string
			// +usage=Override the name field and create a topic with the fullName. Only used with create
			fullName?: string
			// +usage=The environment variable to pass the topic name to
			envKey: string
			// +usage=If projectId is defined, we will only bind permissions to the topic above for the given project. 
			projectId?: string
			// +usage=If fullName is defined, 
		}]
		// +ussage=Enable global loadbalancer for the service and create a DNS record. 
		loadBalancer?: {
			// +usage=Set to true to create the loadbalancer, defaults to false
			enable: bool
			// +usage=Enable the idp Proxy for the loadbalancer, defaults to false
			idpProxy?: bool
		}
  }
}
