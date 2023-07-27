output: {
  type: "k8s-objects"
	properties: {
    objects: [{
      apiVersion: "pkg.crossplane.io/v1"
      kind: "Provider"
      metadata: name: "provider-gcp"
      spec: {
        package: "xpkg.upbound.io/upbound/provider-terraform:v" + context.metadata.version
        packagePullPolicy: "IfNotPresent"
        revisionActivationPolicy: "Automatic"
        revisionHistoryLimit: 1
        if parameter.controllerConfig != _|_ {
          controllerConfigRef: name: parameter.controllerConfig
        }        
      }
    }]
  }
}