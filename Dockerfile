FROM marcinbojko/pipetools-k8s:v0.25.23 AS build

LABEL version="v1.0.9"
LABEL release="drone-kustomize"
LABEL maintainer="marcinbojko"
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]

# install kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && chmod +x ./kustomize && mv kustomize /usr/bin/kustomize \
&& kustomize version

# install kubeconform
RUN wget -qO- "https://github.com/yannh/kubeconform/releases/download/v0.4.14/kubeconform-linux-amd64.tar.gz" | tar xvz -C /usr/bin/

# copy plugin.sh which contains deployment logic
COPY plugin.sh /drone/

ENTRYPOINT [ "/drone/plugin.sh" ]
