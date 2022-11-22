FROM marcinbojko/pipetools-k8s:v0.26.24 AS build

LABEL version="v1.0.14"
LABEL release="drone-kustomize"
LABEL maintainer="marcinbojko"
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]

# install kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && chmod +x ./kustomize && mv kustomize /usr/bin/kustomize

# install datree
COPY --from=datree/datree:1.8.1 /datree /usr/bin/datree

# install kubeconform
COPY --from=ghcr.io/yannh/kubeconform:v0.5.0-amd64-alpine /kubeconform /usr/bin/kubeconform

RUN chmod +x /usr/bin/datree && chmod +x /usr/bin/kubeconform

# copy plugin.sh which contains deployment logic
COPY plugin.sh /drone/

ENTRYPOINT [ "/drone/plugin.sh" ]

