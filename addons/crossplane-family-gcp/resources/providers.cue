package main

import "strings"

providers: {
  name: const.name
  type: "k8s-objects"
	properties: {
    objects:  [for family in strings.Split(parameter.families, ":") {
      apiVersion: "pkg.crossplane.io/v1"
      kind: "Provider"
      metadata: name: "upbound-provider-gcp-" + family
      spec: {
        package: "xpkg.upbound.io/upbound/provider-gcp-" + family + ":v" + context.metadata.version
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
    if _includeControllerConfig {const.controllerConfigName},
    "upbound-provider-family-gcp"
  ]
}
