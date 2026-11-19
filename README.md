# kubernetes-production

GitOps repo for the homelab cluster (kubeadm on Proxmox). Argo CD syncs everything here.

```
bootstrap/root-app.yaml   app-of-apps: the only manual apply
argocd/                   ApplicationSets: platform/* and apps/*
platform/                 cluster infra: metallb, envoy-gateway (+ Gateway "lan"), coredns
charts/webapp/            generic chart: Deployment, Service, PVC, HTTPRoute
apps/<app>/               values.yaml + values-<env>.yaml (image.tag is bumped by CI)
```

## Bootstrap

```bash
# Argo CD already installed in namespace argocd
kubectl create ns homectl
kubectl -n homectl create secret docker-registry ghcr \
  --docker-server=ghcr.io --docker-username=moisesjuniorops --docker-password="$TOKEN"
kubectl apply -f bootstrap/root-app.yaml
kubectl -n argocd get applications -w
```

## Deploy flow

1. Push to `homectl` → GitHub Actions builds `ghcr.io/moisesjuniorops/homectl:<sha>`.
2. CI commits `image.tag: <sha>` to `apps/homectl/values-prod.yaml` here.
3. Argo CD syncs and rolls out. Rollback = `git revert` the bump commit.

## Adding an app

Create `apps/<name>/values.yaml` + `values-prod.yaml` and add `{ app: <name>, env: prod }`
to `argocd/apps-appset.yaml`.
