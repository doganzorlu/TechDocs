# Nasıl Çalışır ?

Öncelikle minikube içerisindeki docker daemon u kullanacağız. Bunun için 
```console
eval $(minikube docker-env)
```
komutu ile uzak docker için çevre değişkenlerimizi ayarlıyoruz. Ardından container dizini içerisinde
```console
docker build --tag $(minikube ip):5000/react-sample-dev .
```
komutu ile image oluşturulup registry içinde react-dev olarak konumlandırılır. İskelet içinde app klasörü, eğer bu iskeleti kendi ürününüz için kullanmayı düşünüyorsanız geliştirdiğiniz ürünün konumlanacağı yer.

```console
docker images
```
komutu ile yüklediğimiz/oluşturduğumuz image docker image listesinde görünecektir. Yerel registry ye push edebiliriz.
```console
docker push $(minikube ip):5000/react-sample-dev
```
Artık deploy etmeye hazırız.. Deployments dizinine geçip;
```console
kubectl apply -f 00-namespace
kubectl apply -f 01-deploy-dev
```

Bir sorun oluşursa pod konsoluna erişip kontrol etmek gerekebilir.


