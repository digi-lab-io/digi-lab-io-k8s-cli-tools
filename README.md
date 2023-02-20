# digi-lab.io | Kubernetes Command Line Interface (CLI) Tools

CI/CD Kubernetes CLI tools for pipelines and local builds.
Includes kubectl and in addition:
	- [krew](https://krew.sigs.k8s.io).
	- [kubcetl-slice](https://github.com/patrickdappollonio/kubectl-slice).
	- [kustomize](https://kubectl.docs.kubernetes.io).

## Usage

### Docker

```bash
nerdctl run -it --rm ghcr.io/digi-lab-io/digi-lab-io-k8s-cli-tools:latest kubectl slice --help
nerdctl run -it --rm ghcr.io/digi-lab-io/digi-lab-io-k8s-cli-tools:latest kubectl-slice --help
nerdctl run -it --rm ghcr.io/digi-lab-io/digi-lab-io-k8s-cli-tools:latest kustomize --help
```
