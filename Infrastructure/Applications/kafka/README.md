# Apache Kafka - Genel Bilgiler

Orjinali [Minikube Apache Kafka](https://github.com/d1egoaz/minikube-kafka-cluster 'Minikube Apache Kafka') sitesinde yer alan dağıtımın güncellenmiş sürümü. Ayrıca monitor olarak da yine Diego'nun image i kullanılıyor. Diego Alvarez'e teşekkürler. Biraz daha geliştirdiğimizde monitoring işini java yerine merkeze konumlandıracağımız ZABBIX üzerinden yapıyor olacağız.

# Kurulum

ca1 klasöründe kafka-ca1 clusterını oluşturmak için gerekli tanımlar mevcut. Bu klasöre gidip;

```console
kubectl apply -f 00-namespace/
kubectl apply -f 01-zookeeper/
kubectl apply -f 02-kafka/
kubectl apply -f 03-yahoo-kafka-manager/
kubectl apply -f 04-kafka-monitor/
```
komutlarını çalıştırarak cluster oluşturma işlemini gerçekleştirebilirsiniz. Eğer kafka replikasyon kullanacaksanız, ca2 klasöründe tanımlanmış kafka-ca2 namespace içinde ikinci cluster ı da oluşturmalısınız. Bunun için ca2 içine gidip;
```console
kubectl apply -f 00-namespace/
kubectl apply -f 01-zookeeper/
kubectl apply -f 02-kafka/
kubectl apply -f 03-yahoo-kafka-manager/
kubectl apply -f 04-kafka-monitor/
```
komutlarını kullanmalısınız. Tabi bu durumda mirror işlemini yapacak deployment için ca1 klasöründe;
```console
kubectl apply -f 05-kafka-mirrormaker/
```
komutunu kullanabilirsiniz.

# Yönetim Konsolu

```console
minikube service -n kafka-ca1 kafka-manager --url
```
yukarıdaki komutla verilen adrese web browser üzerinden erişerek, konsoldan yeni bir cluster oluşturup, zookeper için 
```console
zookeeper-service:2181
```
kullanmalısınız. Zira deployment sırasında verdiğimiz zookeper servis ismi ve portu bu şekilde.

# Kaynakları İzleme

Yükleme ve kaynakların anlık durumlarını izlemek için;

```console
kubectl -n kafka-ca1 get deployments
NAME            READY   UP-TO-DATE   AVAILABLE   AGE
kafka-manager   1/1     1            1           8m34s
kafka-monitor   1/1     1            1           8m28s
zookeeper       1/1     1            1           8m46s
```
Deployment tarafı iyi gitmiş. Tümü çalışır durumda.
```console
kubectl -n kafka-ca1 get statefulsets
NAME    READY   AGE
kafka   3/3     10m
```
Statefulset ler de tamam görünüyor. Kafka kendi cluster nodları arasında kendisi veri bütünlüğü sağladığı için Statefulset olarak oluşturuyor pod ları. Böylelikle her bir pod için kalıcı depolama alanı o pod için özel oluyor.
```console
kubectl -n kafka-ca1 get services
NAME                TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
kafka               ClusterIP   None             <none>        9092/TCP,9999/TCP   11m
kafka-manager       NodePort    10.103.179.255   <none>        9000:31792/TCP      11m
zookeeper-service   NodePort    10.106.14.17     <none>        2181:30264/TCP      11m
```
Servislerimiz ve expose edilmiş portlarımız burada.
```console
kubectl -n kafka-ca1 get pods
NAME                             READY   STATUS    RESTARTS   AGE
kafka-0                          1/1     Running   0          12m
kafka-1                          1/1     Running   0          10m
kafka-2                          1/1     Running   0          10m
kafka-manager-7b8fb9f6c6-ln6pn   1/1     Running   0          12m
kafka-monitor-6795444469-pbdh7   1/1     Running   0          12m
zookeeper-7b69697846-g79zp       1/1     Running   0          12m
```
Üç node kafka, manager, monitor ve zookeper çalışır durumda. Son olarak servislerimizin erişim için kullanılacağı adres ve portlara da bir bakalım;
```console
minikube service list --namespace kafka-ca1
|-----------|-------------------|---------------------|-----------------------------|
| NAMESPACE |       NAME        |     TARGET PORT     |             URL             |
|-----------|-------------------|---------------------|-----------------------------|
| kafka-ca1 | kafka             | No node port        |
| kafka-ca1 | kafka-manager     |                9000 | http://192.168.99.100:31792 |
| kafka-ca1 | zookeeper-service | zookeeper-port/2181 | http://192.168.99.100:30264 |
|-----------|-------------------|---------------------|-----------------------------|
```
Herşey hazır. 

# Logs
Çalışan servislerin loglarına bir göz atmak her zaman iyidir. Yolunda gitmeyen birşey varsa çok hızlı gözlenebilir. Bunun için;

```console
kubectl -n kafka-ca1 exec kafka-0 -- tail -f /opt/kafka/logs/state-change.log
kubectl -n kafka-ca1 exec kafka-0 -- tail -f /opt/kafka/logs/server.log
kubectl -n kafka-ca1 exec kafka-0 -- tail -f /opt/kafka/logs/controller.log
```
komutları ile kafka ile ilgili loglara göz atabilirsiniz. Bunlar ilk cluster node için, diğer node lar için tabi ki kafka-1, kafka-2 ye de bakmanız gerekebilir.

# Monitoring

Öncelikle;
```console
kubectl -n kafka-ca1 get pods
NAME                             READY   STATUS    RESTARTS   AGE
kafka-0                          1/1     Running   0          12m
kafka-1                          1/1     Running   0          10m
kafka-2                          1/1     Running   0          10m
kafka-manager-7b8fb9f6c6-ln6pn   1/1     Running   0          12m
kafka-monitor-6795444469-pbdh7   1/1     Running   0          12m
zookeeper-7b69697846-g79zp       1/1     Running   0          12m
```
ile baktığımızda monitor pod olarak **kafka-monitor-6795444469-pbdh7** adını görüyoruz. Haydi portu forward edip bir göz atalım;

```console
kubectl -n kafka-ca1 port-forward kafka-monitor-6795444469-pbdh7 9999
```
jconsole ile bağlanıp değerlere bakalım;
```console
jconsole localhost:9999
```
Unutmadan jconsole jdk/bin klasöründe. PATH içinde yoksa tam yolu vermeniz gerekecektir.
# Sonuç
Artık tek yapmanız gereken topic lerinizi oluşturup Kafka keyfi sürmek. Unutmayın, kafka kalıcı veriyi tüm cluster üzerinde koruyor. İstediğiniz sürelerle saklayabiliyorsunuz. Özellikle cloud native bir uygulama geliştirecekseniz merkeze bunun gibi bir servisi konumlandırmak inanılmaz bir esneklik ve operasyon kolaylığı sağlayacaktır. 

Hiçbirşey mükemmel olmadığı gibi bu şekilde yapılara ilerledikçe geliştiricinin makinesinde çalışması gereken servisler de hızla artıyor. Bu aşamada minikube ve mikrok8s gibi olanaklar imdada yetişiyor.