# Drone kustomize plugin

Kustomize plugin for Drone CI.

## Usage

The most basic usage requires `kubeconfig` (preferably as secret) with
kubeconfig content and `folderpath` pointing to a path inside a repo where
`kustomization.yaml` file is placed. For debugging purpose one can set `debug` and `dryrun ` flags which default to `false`

```yaml
steps:
  - name: deploy-stage
    image: marcinbojko/drone-kustomize
    settings:
      kubeconfig:
        from_secret: kubeconfig
      folderpath: deploy/overlays/production
      debug: true
      dryrun: true

```

## Variables

- PLUGIN_VERSIONS - display versions on `kubectl`, `helm` and `kustomize`

```yaml
steps:
  - name: deploy-stage
    image: marcinbojko/drone-kustomize
    settings:
      kubeconfig:
        from_secret: kubeconfig
      folderpath: deploy/overlays/production
      debug: true
      dryrun: true
      versions: true
```

- PLUGIN_DATREE_CHECK and PLUGIN_DATREE_PARAMETERS

`PLUGIN_DATREE_CHECK` enables to validate kustomize manifests through `datree` passing `PLUGIN_DATREE_PARAMETERS` as parameters list.
By default `PLUGIN_DATREE_PARAMETERS` is set to "--ignore-missing-schemas --verbose --no-record"

```yaml
steps:
  - name: deploy-stage
    image: marcinbojko/drone-kustomize
    settings:
      kubeconfig:
        from_secret: kubeconfig
      folderpath: deploy/overlays/production
      debug: true
      dryrun: true
      versions: true
      datree_check: true
      datree_parameters: "--ignore-missing-schemas --verbose --no-record"
```

- PLUGIN_NAMESPACE

By providing `PLUGIN_NAMESPACE` all kustomize manifests are deployed to this namespace. If ommited, kubectl deploys to default namespace.
If you manifest has 'namespace' set as parameter, this setting won't override it.

## Forked from

[https://github.com/gaurav-magassian/drone-kustomize](https://github.com/gaurav-magassian/drone-kustomize)
