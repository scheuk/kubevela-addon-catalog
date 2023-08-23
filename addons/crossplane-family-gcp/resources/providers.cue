package main

providers: {
  name: const.name
  type: "k8s-objects"
	properties: {
    objects: [for family in parameter.families {
      apiVersion: "pkg.crossplane.io/v1"
      kind: "Provider"
      metadata: name: "provider-gcp-" + family
      spec: {
        package: "xpkg.upbound.io/upbound/provider-gcp-" + family + ":v" + context.metadata.version
        packagePullPolicy: "IfNotPresent"
        revisionActivationPolicy: "Automatic"
        revisionHistoryLimit: 1
        if parameter.controllerConfig != _|_ {
          controllerConfigRef: name: parameter.controllerConfig
        }        
      }
    }] + _familyProvider
  }
}

_familyProvider: [{
  apiVersion: "pkg.crossplane.io/v1"
  kind: "Provider"
  metadata: name: "provider-family-gcp"
  spec: {
    package: "xpkg.upbound.io/upbound/provider-family-gcp:v" + context.metadata.version
    packagePullPolicy: "IfNotPresent"
    revisionActivationPolicy: "Automatic"
    revisionHistoryLimit: 1
    if parameter.controllerConfig != _|_ {
      controllerConfigRef: name: parameter.controllerConfig
    }        
  }
}]
