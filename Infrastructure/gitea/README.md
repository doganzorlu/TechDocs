# GITEA - Genel Bilgiler

Gitea harika bir git sunucusu. Ekibinizin kod yönetimi için kullanabileceğiniz gibi, bu dökümanda işlenen tek adam makinesinde de kod deposu uygulaması olarak yer alıyor.

# Kurulum

ca1 klasöründe kafka-ca1 clusterını oluşturmak için gerekli tanımlar mevcut. Bu klasöre gidip;

```console
kubectl apply -f 00-namespace/
kubectl apply -f 01-gitea/
```
komutlarını çalıştırarak kurulumu bitirebilirsiniz. Ardından;
```console
kubectl get svc --namespace gitea
NAME    TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)        AGE
gitea   LoadBalancer   10.107.27.227   10.107.27.227   80:30221/TCP   63m
```
Şeklinde kullanacağınız IP yi görebilirsiniz. Unutmayın External IP alabilmek için mutlaka;
```console
kubectl tunnel
```
komutunu admin olarak açılmış bir oturumdan başlatmalısınız. Tek yapmanız gereken browser dan konsola erişmek. Bu aşamada temel bilgileri soracak. Ben bir kişinin çalışacağını ön görereqk sqllite ile devam ettim. Buradaki yapılandırmada yer alan mysql üzerinde bir db oluşturup onu da kullanabilirsiniz.

Sistem yöneticisi hesabı ilk register olan hesap oluyor. Nasıl login olacağız diye soranlar için.