# k8s_Projekt2 - Anleitung

> **ACHTUNG:** Um das Projekt zu realisieren müssen **helm** und **k3d** installiert werden und ein funktionierendes WSL bzw. eine Linux Distro bestehen.

**als root user anmelden**

```bash
su
```

**Repository klonen**<br>
```bash
git clone https://github.com/Senkoiii/k8s_Projekt2
```

**Kubernetes-Cluster erstellen:**<br>
```bash
k3d cluster create projekt2-mongo-cluster --servers 1 --agents 2 -p "3000:3000@loadbalancer"
```

**Helm-Chart erstellen:**<br>
```bash
helm create projekt2-mongodb
cd projekt2-mongodb
```

**Unnötige Default Dateien entfernen:**<br>
```bash
rm templates/deployment.yaml templates/service.yaml
cd templates
rm -rf tests/
```

**YAML-Files aus Repository in Helm-Chart kopieren**
> **ACHTUNG:** Dafür muss man aus dem root gehen (exit) damit man es kopieren kann. Danach kann man wieder mit `su` zurück ins root
> 

```bash
exit
```
```bash
sudo cp ~/k8s_Projekt2/templates/*.yaml ~/projekt2-mongodb/templates/
```
```bash
su
```
**Docker-Image bauen: (k8s_Projekt2/web)**
<br>
```bash
cd k8s_Projekt2/web
docker build -t k8s_mongodb_projekt2_web:latest .
```

**Image in Cluster kopieren:**
<br>
```bash
k3d image import k8s_mongodb_projekt2_web:latest -c projekt2-mongo-cluster
```

**Configmap erstellen: (/k8s_Projekt2)**

```bash
cd ..
kubectl create configmap projekt2-init-script --from-file=init-replica.sh
```

**Helm-Chart installieren:**
```bash
cd ../projekt2-mongodb
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

> **ACHTUNG:** Warte, bis die ReplikaSets erfolgreich durchgelaufen sind und alle 3 MongoDB-Pods verfügbar sind.


**Filme anzeigen:**
```bash
http://localhost:3000
```

**Filme hinzufügen:**

```bash
http://localhost:3000/movies/add?title=Oppenheimer
```





