# BookStack Helm Chart

Deploys the BookStack wiki platform on Kubernetes with optional MariaDB and Redis sub-charts.

---

## Versioning

The chart uses **dual semantic versioning**:

```
<chart semver>+<upstream BookStack semver>
# example: 1.2.3+25.2.3
```

This allows Helm to track compatibility changes independently from upstream BookStack releases.

---

## Prerequisites

* Helm 3
* Kubernetes 1.24+
* (Optional) External MariaDB 10.5+ and/or Redis 6+ instances if you disable the bundled sub‑charts

---

## Quick start

```bash
helm repo add morlana https://charts.morlana.net
helm repo update

helm install bookstack morlana/bookstack \
  --namespace bookstack --create-namespace
```

The first run generates a **Laravel APP\_KEY** secret. The deployment automatically restarts once the key is present.

---

## Upgrading

```bash
helm upgrade bookstack morlana/bookstack -n bookstack --reuse-values
```

Helm recognises new chart versions that follow the `x.y.z+<bookstack>` scheme. Check the upstream project’s release notes as well as the chart’s `CHANGELOG.md` before upgrading across major versions.

---

## Uninstalling

```bash
helm uninstall bookstack -n bookstack
```

PersistentVolumeClaims and One-Time generated secrets are **not** removed automatically.

---

## Configuration (excerpt)

| Key                             | Description                                         | Default               |
| ------------------------------- | --------------------------------------------------- | --------------------- |
| `bookstack.image.repository`    | Container image repository                          | `solidnerd`           |
| `bookstack.image.name`          | Image name                                          | `bookstack`           |
| `bookstack.image.tag`           | Image tag (defaults to upstream version when empty) | `""`                  |
| `bookstack.replicaCount`        | Number of pods                                      | `1`                   |
| `bookstack.config.app.url`      | Public URL users will access                        | `https://example.com` |
| `bookstack.config.app.key`      | Laravel APP\_KEY (auto‑generated if empty)          | `""`                  |
| `bookstack.mail.host`           | SMTP host (set to enable e‑mail)                    | `""`                  |
| `bookstack.mail.port`           | SMTP port                                           | `1025`                |
| `bookstack.persistence.enabled` | Persist uploads and storage                         | `true`                |
| `bookstack.persistence.size`    | PVC size                                            | `10Gi`                |
| `service.type`                  | Kubernetes Service type                             | `ClusterIP`           |
| `ingress.enabled`               | Create an Ingress                                   | `false`               |
| `db.enabled`                    | Deploy bundled MariaDB                              | `true`                |
| `redis.enabled`                 | Deploy bundled Redis                                | `true`                |

Override values with `--set key=value` or put them in `my-values.yaml` and pass `-f`.

---

## Persistence

A single ReadWriteMany PVC is created by default so all replicas share the same data. Customise size, StorageClass or accessMode via `bookstack.persistence.*`.

---

## Ingress example

```yaml
ingress:
  enabled: true
  class: nginx
  hostname: wiki.example.com
  tls:
    - hosts: [wiki.example.com]
      secretName: wiki-tls
```

---

## Using external services

Disable the sub‑charts and point BookStack at existing database/redis servers:

```yaml
db:
  enabled: false

bookstack:
  externalDatabase:
    host: mariadb.example.com
    database: bookstack
    username: bookstack
    password: supersecret

redis:
  enabled: false

bookstack:
  externalRedis:
    servers: redis://:password@redis.example.com:6379/0
```

---

## Backup & restore

* **Database**: use `mysqldump` / `mysql` against the MariaDB service (or your external DB).
* **Application data**: back up the BookStack PVC with your preferred tool (Velero, restic, etc.).

---

## Contributing

Bug reports and pull requests are welcome in the [chart repository](https://git.morlana.online/f.weber/bookstack-chart).
For issues specific to BookStack itself, please use the [upstream project’s tracker](https://github.com/BookStackApp/BookStack/issues).

Happy documenting! 📚
