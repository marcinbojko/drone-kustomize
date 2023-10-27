
FROM alpine:3.18.2 AS build
ENV KUBE_VERSION=v1.23.17
#ENV HELM_VERSION=v3.12.3
#ENV HELM_FILENAME=helm-${HELM_VERSION}-linux-amd64.tar.gz
ENV TZ=UTC
LABEL version="v1.0.21"
LABEL release="drone-kustomize"
LABEL maintainer="marcinbojko"
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]

RUN apk add --no-cache --update -t deps ca-certificates curl bash\
  && apk update \
  && apk upgrade --no-cache \
  && curl -fsL https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl -o /bin/kubectl && chmod +x /bin/kubectl \
  && mkdir -p ~/.ssh \
  && eval "$(ssh-agent -s)" \
  && echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config \
  && chmod -R 700 ~/.ssh

COPY --from=k8s.gcr.io/kustomize/kustomize:v4.5.7 /app/kustomize /usr/bin/kustomize
# install datree
COPY --from=datree/datree:1.9.19 /datree /usr/bin/datree
# install kubeconform
COPY --from=ghcr.io/yannh/kubeconform:v0.6.1-amd64-alpine /kubeconform /usr/bin/kubeconform
RUN chmod +x /usr/bin/datree && chmod +x /usr/bin/kubeconform
# copy plugin.sh which contains deployment logic
COPY plugin.sh /drone/
ENTRYPOINT [ "/drone/plugin.sh" ]

