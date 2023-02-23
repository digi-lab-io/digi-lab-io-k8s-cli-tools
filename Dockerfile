
ARG suse_bci_base_version
FROM registry.suse.com/bci/bci-base:$suse_bci_base_version AS build
LABEL vendor="digi-lab.io"

ARG arch
ARG kubernetes_release_version
ARG krew_version

WORKDIR /bin
RUN zypper -n install curl tar gzip git jq
RUN set -x && curl -fsSLO https://storage.googleapis.com/kubernetes-release/release/${kubernetes_release_version}/bin/linux/${arch}/kubectl
RUN chmod +x kubectl
RUN set -x && OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
      arch="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
      krew_version="krew-${OS}_${arch}" && \
      echo "Krew: ${krew_version}" && \
      curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${krew_version}.tar.gz" &&  \
      tar zxvf "${krew_version}.tar.gz" && \
      ./"${krew_version}" install krew
RUN echo "export PATH=${KREW_ROOT:-$HOME/.krew}/bin:$PATH" >> /root/.bashrc
ENV PATH=/root/.krew:/root/.krew/bin:$PATH

RUN source /root/.bashrc && kubectl krew install slice
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
