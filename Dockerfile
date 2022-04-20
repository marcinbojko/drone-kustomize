FROM marcinbojko/pipetools-k8s:v0.20.20 AS build

LABEL version="v1.0.2"
LABEL release="drone-kustomize"
LABEL maintainer="marcinbojko"
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]

# install kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && chmod +x ./kustomize && mv kustomize /usr/bin/kustomize \
&& kustomize version

# copy plugin.sh which contains deployment logic
COPY plugin.sh /drone/

ENTRYPOINT [ "/drone/plugin.sh" ]
