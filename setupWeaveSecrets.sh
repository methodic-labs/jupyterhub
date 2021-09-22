openssl rand -hex 128 >weave-passwd
kubectl create secret -n kube-system generic weave-passwd --from-file=./weave-passwd
kubectl patch --namespace=kube-system daemonset/weave-net --type json -p '[ { "op": "add", "path": "/spec/template/spec/containers/0/env/0", "value": { "name": "WEAVE_PASSWORD", "valueFrom": { "secretKeyRef": { "key": "weave-passwd", "name": "weave-passwd" } } } } ]'
