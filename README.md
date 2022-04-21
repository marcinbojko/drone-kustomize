# Drone kustomize plugin

Kustomize plugin for Drone CI.

# Usage

The most basic usage requires `kubeconfig` (preferably as secret) with
kubeconfig content and `folderpath` pointing to a path inside a repo where
`kustomization.yaml` file is placed. For debugging purpose one can set `debug` and `dryrun ` flags which default to `false`

```
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

```
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

## Forked from

[https://github.com/gaurav-magassian/drone-kustomize](https://github.com/gaurav-magassian/drone-kustomize)

