# k8s_Projekt2 - Anleitung

**Repository ziehen**<br>
```bash
git clone https://github.com/Senkoiii/k8s_Projekt2/tree/main/k8s_Projekt2
```

**Cluster erstellen:**<br>
```bash
k3d cluster create projekt2-mongo-cluster --servers 1 --agents 2 -p "3000:3000@loadbalancer"
```

**Helm erstellen: (ausserhalb der Repository)**<br>
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



**Image bauen: (dafür muss man im /projekt2-mongodb/web sein)**<br>
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

**Helm installieren:**
```bash
helm install projekt2-mongodb .
``` 

**Überprüfen:**<br>
```bash
helm list
```
```bash
kubectl get pods
```
```bash
kubectl get jobs
```
```bash
kubectl get svc
```
```bash
kubectl logs job/projekt2-mongo-init
```
<br><br>


Warten, bis bei `kubectl logs job/projekt2-mongo-init` alle 3 pods erfolgreich erstellt wurden<br><br>

Jetzt ist die App per `http://localhost:3000` erreichbar und zeigt alle Filme in der Datenbank.<br>
Mit `http://localhost:3000/movies/add?title=Oppenheimer` lassen sich Filme hinzufügen.






