output: {
	type: "helm"
	properties: {
		repoType: "helm"
		url:      "https://charts.crossplane.io/stable"
		chart:    "crossplane"
		version:  context.metadata.version
	}
}
