package main

controllerConfig: {
  name: const.controllerConfigName
  type: "k8s-objects"
	properties: {
    objects: [{
      apiVersion: "pkg.crossplane.io/v1alpha1"
      kind: "ControllerConfig"
      metadata: {
        name: const.controllerConfigName
        if parameter.gcpSaEmail != _|_ {
          annotations: 
            "iam.gke.io/gcp-service-account": parameter.gcpSaEmail
        }
      }
      spec: {
        if parameter.gcpSaEmail != _|_ {
          serviceAccountName: parameter.k8sServiceAccountName
        }
        if parameter.args != _|_ {
          args: parameter.args
        }
      }
    }]
  }
}