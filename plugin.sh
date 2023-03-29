#!/usr/bin/env bash

if [[ "$PLUGIN_VERSIONS" == "true" ]]; then
    echo "Versions: helm                - $(helm version --client)"
    echo "Versions: kubectl             - $(kubectl version --client)"
    echo "Versions: kustomize           - $(kustomize version)"
    echo "Versions: kubeconform         - $(kubeconform -v)"
    echo "Versions: datree              - $(datree version)"
    echo "Variables: PLUGIN_NAMESPACE   - $PLUGIN_NAMESPACE"
    echo "Variables: PLUGIN_CONTEXT     - $PLUGIN_CONTEXT"
fi

set -e pipefail

"${PLUGIN_DEBUG:-false}" && set -x

# Let's build parameters for kubectl
kube_params=""
if [[ -n "${PLUGIN_NAMESPACE:-}" ]]; then
    kube_params+=" --namespace=${PLUGIN_NAMESPACE}"
fi
if [[ -n "${PLUGIN_CONTEXT:-}" ]]; then
    kube_params+=" --context=${PLUGIN_CONTEXT}"
fi
echo "Kube Parameters: $kube_params"


# let's check for defaults in datree parameters
if [[ -z "${PLUGIN_DATREE_PARAMETERS:-}" ]]; then
    PLUGIN_DATREE_PARAMETERS="--ignore-missing-schemas --verbose --no-record -p Default -s 1.22.0"
fi

if [[ -z "${PLUGIN_DATREE_CHECK:-}" ]]; then
    PLUGIN_DATREE_CHECK="false"
fi


# First let's check for datree
# We don't require mandatory stuff like kubeconfig or namespace

if [ "$PLUGIN_DATREE_CHECK" == "true" ] && [ -n "$PLUGIN_FOLDERPATH" ]; then
        echo "Checking : $PLUGIN_FOLDERPATH"
        datree kustomize test "$PLUGIN_FOLDERPATH" $PLUGIN_DATREE_PARAMETERS
        echo "Folder   : $PLUGIN_FOLDERPATH check completed"
else
    echo "Skipping Datree Check: PLUGIN_DATREE_CHECK - $PLUGIN_DATREE_CHECK"
fi

#then let's continue

if [ "$PLUGIN_KUSTOMIZE_DEPLOY" == "true" ]; then
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
            echo "Deploying: $PLUGIN_FOLDERPATH to namespace: $PLUGIN_NAMESPACE with [optional] context: $PLUGIN_CONTEXT"
            kustomize build "${PLUGIN_FOLDERPATH}" | kubectl apply $kube_params -f -
    fi
else
    echo "Skipping Kustomize Deploy: PLUGIN_KUSTOMIZE_DEPLOY - $PLUGIN_KUSTOMIZE_DEPLOY"
fi
if [[ "$PLUGIN_KUBECONFORM_BUILD" == "true" ]]; then
    if [ -z "$PLUGIN_KUBECONFORM_PARAMETERS" ]; then
        PLUGIN_KUBECONFORM_PARAMETERS="-skip Route"
    fi
    for DIR in $(echo "$PLUGIN_KUBECONFORM_PATHS" |tr , " "); do
        echo "$DIR"
        kustomize build "$DIR" | kubeconform -summary $PLUGIN_KUBECONFORM_PARAMETERS
        echo "------------------"
    done
fi
