# Genel Bilgiler
Bu bölümde, klasör içinde verilmiş olan yapılandırmaları kullanırken kullanabileceğiniz faydalı birkaç bilgiyi bulacaksınız.
# Servis Tipleri
Servis tanımlarında LoadBalancer kullanımını, eğer servis sadece diğer servisler tarafından kullanılmayıp dışarıdan erişilecekse tercih edilmesi gereken bir durumdur. Eğer erişilen servis HTTP/HTTPS ise ve arkada bir grup servise erişilecekse ingress de değerlendirilebilir. Servisler arası erişimin yeterli olduğu durumda ClusterIP çoğu senaryo için uygun bir yöntem olarak çalışacaktır.

Aşağıdaki görselde muhtemel senrayolar için akış örnekleri verilmiştir;

![Kubernetes Servis Expose Tipleri](assets/en/images/kbernetes_service_expose_types.png "Kubernetes Servis Expose Tipleri")

Burada görüleceği üzere değişik tiplerde değişik davranışlar söz konusudur. Proxy kullandığımızda servise client ClusterIP den erişirken, LoadBalancer kullandığımızda External IP'den bağlanır. Benzer şekilde diğer servisler de resimde gösterildiği şekildedir. Yapının büyüklüğü ve kullanım amacına göre değişik kullanımlar olmakla birlikte ağ yapılandırmasında fiziksel cluster dış erişimi için External IP adresleri route edilmiş olarak bulunur. Akılda bulundurulması gereken temel husus ClusterIP lerin sadece cluster içinden erişilebildiği, ExternalIP lerin cluster dışından erişilebildiğidir.
# Geliştiricilere Not
Bu aşamada artık olay akışı sunucusu ve veritabanı sunucularınız hazır. Size kolay gelsin.

# Servislere Erişim
kubernetes içindeki servislere iki şekilde erişebilirsiniz. Bir tanesi;
```console
minikube service -n <namespace> <service> --url
```
ile elde edeceğiniz erişim adres ve port bilgisini kullanmak şeklindedir. Diğeri ise admin yetkisi ile açılmış bir konsoldan;
```console
C:\Users\Administrator>minikube tunnel
```
komutunu vererek tüm loadbalancer için ExternalIP adreslerini set etmek ve servislere doğal portlarından erişmektir. 
```console
C:\Users\user>kubectl get svc
NAME         TYPE           CLUSTER-IP     EXTERNAL-IP    PORT(S)          AGE
kubernetes   ClusterIP      10.96.0.1      <none>         443/TCP          6d20h
mysql        LoadBalancer   10.96.211.42   10.96.211.42   3306:32407/TCP   41h
pgadmin      LoadBalancer   10.96.60.57    10.96.60.57    80:30248/TCP     5d17h
postgres     LoadBalancer   10.98.200.91   10.98.200.91   5432:31484/TCP   6d18h
```
komutunda görebileceğiniz gibi external ip ler hazır ve yönlendirilmiş durumda. 
# Çalışan Makine
Bu kısımda, kendi kullandığım komponentlerin deploy edilmesi için gerekli bilgileri veriyorum. Bende şu anda 16GB RAM, Windows 10 ve birinci nesil i5 mekine var ve tüm servislerin makine açıldığında up olması yaklaşık 5dk sürüyor. Tüm servisler çalışırken makinedeki durum ise aşağıdaki gibi..
## Nodes
```console
C:\Users\dogan\Documents\Projects\TechDocs>kubectl get nodes
NAME       STATUS   ROLES                  AGE     VERSION
minikube   Ready    control-plane,master   7d20h   v1.20.0
```
## Namespaces
```console
C:\Users\dogan\Documents\Projects\TechDocs>kubectl get svc --all-namespaces
NAMESPACE              NAME                        TYPE           CLUSTER-IP       EXTERNAL-IP    PORT(S)                  AGE
default                kafka-monitor               ClusterIP      10.103.47.21     <none>         9999/TCP                 22h
default                kubernetes                  ClusterIP      10.96.0.1        <none>         443/TCP                  7d20h
default                mysql                       LoadBalancer   10.96.211.42     10.96.211.42   3306:32407/TCP           2d17h
default                pgadmin                     LoadBalancer   10.96.60.57      10.96.60.57    80:30248/TCP             6d17h
default                postgres                    LoadBalancer   10.98.200.91     10.98.200.91   5432:31484/TCP           7d18h
kafka-ca1              kafka                       ClusterIP      None             <none>         9092/TCP,9999/TCP        22h
kafka-ca1              kafka-manager               NodePort       10.103.179.255   <none>         9000:31792/TCP           22h
kafka-ca1              zookeeper-service           NodePort       10.106.14.17     <none>         2181:30264/TCP           22h
kube-system            kube-dns                    ClusterIP      10.96.0.10       <none>         53/UDP,53/TCP,9153/TCP   7d20h
kubernetes-dashboard   dashboard-metrics-scraper   ClusterIP      10.98.54.135     <none>         8000/TCP                 18h
kubernetes-dashboard   kubernetes-dashboard        ClusterIP      10.105.154.179   <none>         80/TCP                   18h
```
## ConfigMaps
```console
C:\Users\dogan\Documents\Projects\TechDocs>kubectl get configmaps --all-namespaces
NAMESPACE              NAME                                 DATA   AGE
default                kube-root-ca.crt                     1      7d20h
default                mysql-config                         1      2d17h
default                postgres-config                      3      7d18h
kafka-ca1              kafka-monitor-volume                 2      22h
kafka-ca1              kube-root-ca.crt                     1      22h
kafka-ca1              multi-cluster-monitor-volume         1      22h
kube-node-lease        kube-root-ca.crt                     1      7d20h
kube-public            cluster-info                         1      7d20h
kube-public            kube-root-ca.crt                     1      7d20h
kube-system            coredns                              1      7d20h
kube-system            extension-apiserver-authentication   6      7d20h
kube-system            kube-proxy                           2      7d20h
kube-system            kube-root-ca.crt                     1      7d20h
kube-system            kubeadm-config                       2      7d20h
kube-system            kubelet-config-1.20                  1      7d20h
kubernetes-dashboard   kube-root-ca.crt                     1      18h
kubernetes-dashboard   kubernetes-dashboard-settings        0      18h
```
## Secrets
```console
C:\Users\dogan\Documents\Projects\TechDocs>kubectl get secrets --all-namespaces
NAMESPACE              NAME                                             TYPE                                  DATA   AGE
default                default-token-tzd6p                              kubernetes.io/service-account-token   3      7d20h
kafka-ca1              default-token-525t4                              kubernetes.io/service-account-token   3      22h
kube-node-lease        default-token-nt5nj                              kubernetes.io/service-account-token   3      7d20h
kube-public            default-token-lrwhs                              kubernetes.io/service-account-token   3      7d20h
kube-system            attachdetach-controller-token-wwgqh              kubernetes.io/service-account-token   3      7d20h
kube-system            bootstrap-signer-token-48zq4                     kubernetes.io/service-account-token   3      7d20h
kube-system            certificate-controller-token-899zb               kubernetes.io/service-account-token   3      7d20h
kube-system            clusterrole-aggregation-controller-token-fjh7m   kubernetes.io/service-account-token   3      7d20h
kube-system            coredns-token-vhqqh                              kubernetes.io/service-account-token   3      7d20h
kube-system            cronjob-controller-token-2hjwx                   kubernetes.io/service-account-token   3      7d20h
kube-system            daemon-set-controller-token-jqb5l                kubernetes.io/service-account-token   3      7d20h
kube-system            default-token-wr2t7                              kubernetes.io/service-account-token   3      7d20h
kube-system            deployment-controller-token-sgjmv                kubernetes.io/service-account-token   3      7d20h
kube-system            disruption-controller-token-5lv66                kubernetes.io/service-account-token   3      7d20h
kube-system            endpoint-controller-token-h2vxg                  kubernetes.io/service-account-token   3      7d20h
kube-system            endpointslice-controller-token-w2brc             kubernetes.io/service-account-token   3      7d20h
kube-system            endpointslicemirroring-controller-token-j84pg    kubernetes.io/service-account-token   3      7d20h
kube-system            expand-controller-token-l84vc                    kubernetes.io/service-account-token   3      7d20h
kube-system            generic-garbage-collector-token-f5lwx            kubernetes.io/service-account-token   3      7d20h
kube-system            horizontal-pod-autoscaler-token-8st6r            kubernetes.io/service-account-token   3      7d20h
kube-system            job-controller-token-rx4x5                       kubernetes.io/service-account-token   3      7d20h
kube-system            kube-proxy-token-7s9l5                           kubernetes.io/service-account-token   3      7d20h
kube-system            namespace-controller-token-krk7t                 kubernetes.io/service-account-token   3      7d20h
kube-system            node-controller-token-lrd8s                      kubernetes.io/service-account-token   3      7d20h
kube-system            persistent-volume-binder-token-4bsfh             kubernetes.io/service-account-token   3      7d20h
kube-system            pod-garbage-collector-token-fcgvd                kubernetes.io/service-account-token   3      7d20h
kube-system            pv-protection-controller-token-l77x7             kubernetes.io/service-account-token   3      7d20h
kube-system            pvc-protection-controller-token-vhvt9            kubernetes.io/service-account-token   3      7d20h
kube-system            replicaset-controller-token-khzmm                kubernetes.io/service-account-token   3      7d20h
kube-system            replication-controller-token-4xr2n               kubernetes.io/service-account-token   3      7d20h
kube-system            resourcequota-controller-token-26b4d             kubernetes.io/service-account-token   3      7d20h
kube-system            root-ca-cert-publisher-token-km7kl               kubernetes.io/service-account-token   3      7d20h
kube-system            service-account-controller-token-79sk2           kubernetes.io/service-account-token   3      7d20h
kube-system            service-controller-token-dn6xq                   kubernetes.io/service-account-token   3      7d20h
kube-system            statefulset-controller-token-5zklw               kubernetes.io/service-account-token   3      7d20h
kube-system            storage-provisioner-token-xgq28                  kubernetes.io/service-account-token   3      7d20h
kube-system            token-cleaner-token-xtscq                        kubernetes.io/service-account-token   3      7d20h
kube-system            ttl-controller-token-jbl6p                       kubernetes.io/service-account-token   3      7d20h
kubernetes-dashboard   default-token-vhnxr                              kubernetes.io/service-account-token   3      18h
kubernetes-dashboard   kubernetes-dashboard-certs                       Opaque                                0      18h
kubernetes-dashboard   kubernetes-dashboard-csrf                        Opaque                                1      18h
kubernetes-dashboard   kubernetes-dashboard-key-holder                  Opaque                                2      18h
kubernetes-dashboard   kubernetes-dashboard-token-lnh6z                 kubernetes.io/service-account-token   3      18h
```
## Deployments
```console
C:\Users\dogan\Documents\Projects\TechDocs>kubectl get deployments --all-namespaces
NAMESPACE              NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
default                mysql                       1/1     1            1           2d17h
default                pgadmin                     1/1     1            1           6d17h
default                postgres                    1/1     1            1           7d18h
kafka-ca1              kafka-manager               1/1     1            1           22h
kafka-ca1              kafka-monitor               1/1     1            1           22h
kafka-ca1              zookeeper                   1/1     1            1           22h
kube-system            coredns                     1/1     1            1           7d20h
kubernetes-dashboard   dashboard-metrics-scraper   1/1     1            1           18h
kubernetes-dashboard   kubernetes-dashboard        1/1     1            1           18h
```
## Pods
```console
C:\Users\dogan\Documents\Projects\TechDocs>kubectl get pods --all-namespaces
NAMESPACE              NAME                                        READY   STATUS    RESTARTS   AGE
default                mysql-56f96d4c56-7brjm                      1/1     Running   10         2d17h
default                pgadmin-7c96f49469-9bmtr                    1/1     Running   5          6d17h
default                postgres-84ff4497db-9vgqf                   1/1     Running   6          7d18h
kafka-ca1              kafka-0                                     1/1     Running   3          22h
kafka-ca1              kafka-1                                     1/1     Running   3          22h
kafka-ca1              kafka-2                                     1/1     Running   6          22h
kafka-ca1              kafka-manager-7b8fb9f6c6-ln6pn              1/1     Running   2          22h
kafka-ca1              kafka-monitor-6795444469-pbdh7              1/1     Running   3          22h
kafka-ca1              zookeeper-7b69697846-g79zp                  1/1     Running   2          22h
kube-system            coredns-74ff55c5b-dcwvx                     1/1     Running   29         7d20h
kube-system            etcd-minikube                               1/1     Running   28         7d20h
kube-system            kube-apiserver-minikube                     1/1     Running   37         7d20h
kube-system            kube-controller-manager-minikube            1/1     Running   47         7d20h
kube-system            kube-proxy-mhn9q                            1/1     Running   6          7d20h
kube-system            kube-scheduler-minikube                     1/1     Running   21         7d20h
kube-system            storage-provisioner                         1/1     Running   34         7d20h
kubernetes-dashboard   dashboard-metrics-scraper-c95fcf479-tslll   1/1     Running   29         18h
kubernetes-dashboard   kubernetes-dashboard-6cff4c7c4f-dc7qk       1/1     Running   46         18h
```
## ReplicaSets
```console
C:\Users\dogan\Documents\Projects\TechDocs>kubectl get replicasets --all-namespaces
NAMESPACE              NAME                                  DESIRED   CURRENT   READY   AGE
default                mysql-56f96d4c56                      1         1         1       2d17h
default                pgadmin-5b67d79bcc                    0         0         0       6d17h
default                pgadmin-64d5658fb5                    0         0         0       6d17h
default                pgadmin-7c96f49469                    1         1         1       6d17h
default                pgadmin-bd864cd49                     0         0         0       6d17h
default                postgres-84ff4497db                   1         1         1       7d18h
kafka-ca1              kafka-manager-7b8fb9f6c6              1         1         1       22h
kafka-ca1              kafka-monitor-6795444469              1         1         1       22h
kafka-ca1              zookeeper-7b69697846                  1         1         1       22h
kube-system            coredns-74ff55c5b                     1         1         1       7d20h
kubernetes-dashboard   dashboard-metrics-scraper-c95fcf479   1         1         1       18h
kubernetes-dashboard   kubernetes-dashboard-6cff4c7c4f       1         1         1       18h
```
## DaemonSets
```console
C:\Users\dogan\Documents\Projects\TechDocs>kubectl get daemonsets --all-namespaces
NAMESPACE     NAME         DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
kube-system   kube-proxy   1         1         1       1            1           kubernetes.io/os=linux   7d20h
```
## Persistent Volumes
```console
C:\Users\dogan\Documents\Projects\TechDocs>kubectl get pv --all-namespaces
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                          STORAGECLASS   REASON   AGE
mysql-pv-volume                            20Gi       RWO            Retain           Bound    default/mysql-pv-claim                         manual                  2d17h
postgres-pv-volume                         5Gi        RWX            Retain           Bound    default/postgres-pv-claim                      manual                  7d19h
pvc-af25f8db-fa6d-4260-86c8-b0bf80f70741   1Gi        RWO            Delete           Bound    default/pgadmin-persistent-volume-claims-cfg   standard                6d17h
```
## Persistent Volume Claims
```console
C:\Users\dogan\Documents\Projects\TechDocs>kubectl get pvc --all-namespaces
NAMESPACE   NAME                                   STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
default     mysql-pv-claim                         Bound    mysql-pv-volume                            20Gi       RWO            manual         2d17h
default     pgadmin-persistent-volume-claims-cfg   Bound    pvc-af25f8db-fa6d-4260-86c8-b0bf80f70741   1Gi        RWO            standard       6d17h
default     postgres-pv-claim                      Bound    postgres-pv-volume                         5Gi        RWX            manual         7d19h
```
## Services
```console
C:\Users\dogan\Documents\Projects\TechDocs>kubectl get services --all-namespaces
NAMESPACE              NAME                        TYPE           CLUSTER-IP       EXTERNAL-IP    PORT(S)                  AGE
default                kafka-monitor               ClusterIP      10.103.47.21     <none>         9999/TCP                 22h
default                kubernetes                  ClusterIP      10.96.0.1        <none>         443/TCP                  7d20h
default                mysql                       LoadBalancer   10.96.211.42     10.96.211.42   3306:32407/TCP           2d17h
default                pgadmin                     LoadBalancer   10.96.60.57      10.96.60.57    80:30248/TCP             6d17h
default                postgres                    LoadBalancer   10.98.200.91     10.98.200.91   5432:31484/TCP           7d18h
kafka-ca1              kafka                       ClusterIP      None             <none>         9092/TCP,9999/TCP        22h
kafka-ca1              kafka-manager               NodePort       10.103.179.255   <none>         9000:31792/TCP           22h
kafka-ca1              zookeeper-service           NodePort       10.106.14.17     <none>         2181:30264/TCP           22h
kube-system            kube-dns                    ClusterIP      10.96.0.10       <none>         53/UDP,53/TCP,9153/TCP   7d20h
kubernetes-dashboard   dashboard-metrics-scraper   ClusterIP      10.98.54.135     <none>         8000/TCP                 18h
kubernetes-dashboard   kubernetes-dashboard        ClusterIP      10.105.154.179   <none>         80/TCP                   18h
```