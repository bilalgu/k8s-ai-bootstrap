# Step 5 – Kubernetes Observability

**Objective:**

Add a minimal observability stack to the cluster to collect and visualize logs from all pods:
- Centralize logs with Loki
- Collect node/pod logs with Promtail
- Query and visualize logs with Grafana

**Stack:**

- [Loki](https://grafana.com/docs/loki/latest/)
- [Promtail](https://grafana.com/docs/loki/latest/send-data/promtail/)
- [Grafana](https://grafana.com/docs/)

**File structure:**

```
.  
├── k8s/
│   └── observability/
│       ├── 01-namespace.yaml
│       ├── 02-loki.yaml
│       ├── 03-promtail.yaml
│       └── 04-grafana.yaml
```

**Notes:**

- `Loki` runs as a `StatefulSet` to persist logs (1 replica, local config).
- `Promtail` runs as a `DaemonSet` to tail logs from `/var/log` on each node.
- `Grafana` connects to Loki as a datasource to visualize logs.

**Deployment:**

> Requirements: the cluster must already be deployed (see [02-kubernetes-k3d.md](02-kubernetes-k3d.md) & [04-security-k8s.md](04-security-k8s.md)).

Apply all resources:

```bash
kubectl apply -f k8s/observability/01-namespace.yaml
kubectl apply -f k8s/observability/02-loki.yaml
kubectl apply -f k8s/observability/03-promtail.yaml
kubectl apply -f k8s/observability/04-grafana.yaml
```

**Validation:**

1. Check resources:

```bash
kubectl get statefulsets,services,daemonsets,configmaps,deployments -n observability
```

2. Test Loki:

```bash
kubectl run test-client --rm -it --image alpine/curl -- /bin/sh
```

```bash
curl -I http://loki.observability.svc.cluster.local:3100/loki/api/v1/push
```

> *A `405 Method Not Allowed` is normal — this endpoint is not meant for GET requests, but it confirms that Loki is reachable and responding.*

3. Access Grafana:

```bash
kubectl port-forward -n observability services/grafana 3000:3000
```

Open [http://localhost:3000](http://localhost:3000)  
Login: `admin/admin`

4. Add Loki as data source:

- Connections → Data sources
- URL: `http://loki.observability.svc.cluster.local:3100`

5. Run a log query:

- Explore → Select Loki data source
- Run: `{job="varlogs"}`

6. Generate log manually to test Promtail:

```bash
kubectl exec -it -n observability <promtail-pod-name> -- /bin/sh
```

```bash
echo "#Test $(date)" >> /var/log/test.log
```

Reload the query in Grafana → you should see your test log.