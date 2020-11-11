#!/bin/sh

set -euo pipefail

PLUGIN_KUBECONFIG="test data"
PLUGIN_FILEPATH="deploy/overlays/production/kustomization.yaml"
PLUGIN_DEBUG=true
PLUGIN_DRYRUN=true

[ -n "${PLUGIN_DEBUG:-false}" ] && set -x

if [ -z "$PLUGIN_KUBECONFIG" || -z "$PLUGIN_FILEPATH"]; then
    echo "KUBECONFIG and/or FILEPATH not supplied"
    exit 1
fi

if [ -n "$PLUGIN_KUBECONFIG" ];then
    #[ -d $HOME/.kube ] || mkdir $HOME/.kube
    [ -d $HOME/.test ] || mkdir $HOME/.test
    echo "# Plugin PLUGIN_KUBECONFIG available" >&2
    #echo "$PLUGIN_KUBECONFIG" > $HOME/.kube/config
    echo "$PLUGIN_KUBECONFIG" > $HOME/.test/config
    unset PLUGIN_KUBECONFIG
fi

[ -n "${PLUGIN_DEBUG:-false}" ] && kustomize build

if [ "$PLUGIN_DRYRUN" = false]; then
    kustomize build | kubectl apply -f -
fi

