package main

provider: {
  type: "k8s-objects"
	properties: {
    objects: [{
      apiVersion: "pkg.crossplane.io/v1"
      kind: "Provider"
      metadata: name: "upbound-provider-terraform"
      spec: {
        package: "xpkg.upbound.io/upbound/provider-terraform:v" + context.metadata.version
        packagePullPolicy: "IfNotPresent"
        revisionActivationPolicy: "Automatic"
        revisionHistoryLimit: 1
        if _includeControllerConfig {
          controllerConfigRef: name: const.controllerConfigName
        }     
      }
    }]
  }
  dependsOn: [
    if _includeControllerConfig {const.controllerConfigName}
  ]
}