# k8s_Projekt2 - Anleitung

**Repository klonen**<br>
```bash
git clone https://github.com/Senkoiii/k8s_Projekt2
```

**Kubernetes-Cluster erstellen:**<br>
```bash
k3d cluster create projekt2-mongo-cluster --servers 1 --agents 2 -p "3000:3000@loadbalancer"
```

**Helm-Chart erstellen: (innerhalb der geklonten Repository)**<br>
```bash
helm create projekt2-mongodb
cd projekt2-mongodb-project
```

**Unnötige Default Dateien entfernen:**<br>
```bash
rm templates/deployment.yaml templates/service.yaml
cd templates
rm -rf tests/
```

**YAML-Files aus Repository in Helm-Chart kopieren**
```bash
cp k8s_Projekt2/templates/*.yaml projekt2-mongodb/templates/
```

**Docker-Image bauen: (dafür muss man im /projekt2-mongodb/web sein)**<br>
```bash
docker build -t k8s_mongodb_projekt2_web:latest .
```

**Image in Cluster kopieren: (Im Cluster)**<br>
```bash
k3d image import k8s_mongodb_projekt2_web:latest -c projekt2-mongo-cluster
```

**Configmap erstellen: (/pfad wo init drin)**

```bash
kubectl create configmap projekt2-init-script --from-file=init-replica.sh
```

**Helm-Chart installieren:**
```bash
helm install projekt2-mongodb .
``` 
<br>

**Überprüfen:** 

<br>

**Zeigt alle installierten Helm-Charts im Cluster**
```bash
helm list
```
**Listet alle laufenden Pods im Cluster auf**
```bash
kubectl get pods
```
**Zeigt abgeschlossene oder laufende Kubernetes-Jobs**
```bash
kubectl get jobs
```
 **Zeigt alle Services, inklusive Cluster-IP und Ports**
```bash
kubectl get svc
```
**Log des Init-Jobs öffnen**
```bash
kubectl logs job/projekt2-mongo-init
```
<br>

> **ACHTUNG:** Warte im Log des Init-Jobs, bis das ReplikaSet erfolgreich gestartet wurde und alle 3 MongoDB-Pods verfügbar sind.
<br><br>

Filme anzeigen:
```bash
http://localhost:3000
```

Filme hinzufügen

```bash
http://localhost:3000/movies/add?title=Oppenheimer
```





