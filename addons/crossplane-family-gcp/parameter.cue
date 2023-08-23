package main

const: {
	// +usage=The const name of the resource
	name: "crossplane-family-gcp"
	// +usage=The namespace of the addon application
	namespace: "vela-system"
}

parameter: {
  //+usage=Deploy specific gcp provider families to the cluster
  families: *["cloudplatform"] | [...string]
  //+usage=Apply specified controllerConfig to the provider
  controllerConfig?: string
}