package main

const: {
	// +usage=The const name of the resource
	name: "crossplane-terraform"
	// +usage=The namespace of the addon application
	namespace: "vela-system"
  //
  controllerConfigName: "provider-terraform-controller-config"
}

parameter: {
  //+usage=GCP IAM service account email for workload identity binding
  terraformSaEmail?: string
  //+usage=Kubernetes Service account name to run the provider under. Defaults to crossplane-gcp-sa
  k8sServiceAccountName: *"crossplane-terraform-sa" | string
  //+usage=Extra arugments to add to the provider. Example: ["--debug"]
  args?: [...string] 
}