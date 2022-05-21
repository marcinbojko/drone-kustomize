#!/usr/bin/env bash

if [[ "$PLUGIN_VERSIONS" == "true" ]]; then
    echo "Versions: helm        - $(helm version --client)"
    echo "Versions: kubectl     - $(kubectl version --client)"
    echo "Versions: kustomize   - $(kustomize version)"
fi

set -eu pipefail

"${PLUGIN_DEBUG:-false}" && set -x


if [ -z "$PLUGIN_KUBECONFIG" ] || [ -z "$PLUGIN_FOLDERPATH" ]; then
    echo "KUBECONFIG and/or FILEPATH not supplied"
    exit 1
fi

if [ -n "$PLUGIN_KUBECONFIG" ];then
    [ -d "$HOME"/.kube ] || mkdir "$HOME"/.kube  # uncomment post testing
    echo "# Plugin PLUGIN_KUBECONFIG available" >&2
    echo "$PLUGIN_KUBECONFIG" > "$HOME"/.kube/config # uncomment post testing
    unset PLUGIN_KUBECONFIG
fi

[ -n "${PLUGIN_DEBUG:-false}" ] && kustomize build "${PLUGIN_FOLDERPATH}"

if [ "$PLUGIN_DRYRUN" = false ]; then
    kustomize build "${PLUGIN_FOLDERPATH}" | kubectl apply -f -
fi