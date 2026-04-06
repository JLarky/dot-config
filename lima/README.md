# Lima

Create `mine` VM.

```bash
bash lima/provision.sh
```

Clone `mine` VM to `default`.

```bash
limactl stop mine; limactl stop default; limactl delete default; limactl clone mine default
```

Install stuff into the VM.

```bash
```
