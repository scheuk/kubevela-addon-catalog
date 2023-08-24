package main

const: {
	// +usage=The const name of the resource
	name: "crossplane-family-gcp"
	// +usage=The namespace of the addon application
	namespace: "vela-system"
  //
  controllerConfigName: "provider-gcp-controller-config"
}

parameter: {
  //+usage=Deploy specific gcp provider families to the cluster, use a colon for multiple choises: cloudfunctions:cloudrun
  families: *"cloudplatform" | string
  //+usage=GCP IAM service account email for workload identity binding
  gcpSaEmail?: string
  //+usage=Kubernetes Service account name to run the provider under. Defaults to crossplane-gcp-sa
  k8sServiceAccountName: *"crossplane-gcp-sa" | string
  //+usage=Extra arugments to add to the provider. Example: ["--debug"]
  args?: [...string] 
}