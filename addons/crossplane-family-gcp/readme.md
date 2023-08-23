# Crossplane GCP

[AWS Provider](https://github.com/crossplane-contrib/provider-gcp) for Crossplane.

## Provision GCP cloud resources

- Enable addon `crossplane-family-gcp`

```shell
$ vela addon enable crossplane-gcp
```

- Authenticate GCP Provider for Crossplane

Need to describe out todo this

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: aws
  namespace: vela-system
spec:
  components:
    - name: aws
      type: crossplane-gcp
      # fix gcp provider secret config
      # properties:
      #   name: aws
      #   AWS_ACCESS_KEY_ID: xxx
      #   AWS_SECRET_ACCESS_KEY: yyy

```

- Provision cloud resources
TODO fill this out