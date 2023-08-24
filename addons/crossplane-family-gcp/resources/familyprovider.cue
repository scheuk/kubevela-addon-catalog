package main

familyProvider: {
  name: "upbound-provider-family-gcp"
  type: "k8s-objects"
	properties: {
    objects: [{
      apiVersion: "pkg.crossplane.io/v1"
      kind: "Provider"
      metadata: name: "upbound-provider-family-gcp"
      spec: {
        package: "xpkg.upbound.io/upbound/provider-family-gcp:v" + context.metadata.version
        packagePullPolicy: "IfNotPresent"
        revisionActivationPolicy: "Automatic"
        revisionHistoryLimit: 1
        if _includeControllerConfig {
          controllerConfigRef: name: const.controllerConfigName
        }            
      }
    }]
  }
  if _includeControllerConfig {
    dependsOn: [const.controllerConfigName]
  }
}
