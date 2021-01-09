# Apache Kafka - Genel Bilgiler

Orjinali [Minikube Apache Kafka](https://github.com/d1egoaz/minikube-kafka-cluster 'Minikube Apache Kafka') sitesinde yer alan dağıtımın güncellenmiş sürümü. Diego Alvarez'e teşekkürler.

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
open $(minikube service -n kafka-ca1 kafka-manager --url)
```

konsoldan yeni bir cluster oluşturup, zookeper için 
``console
zookeeper-service:2181
```
kullanmalısınız. Zira deployment sırasında verdiğimiz zookeper servis ismi ve portu bu şekilde.