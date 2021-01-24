# MS SQL Server
Tek örnek çalışacak şekilde bir yapılandırmadır. configmap dosyasında yer alan sa bilgilerini kullanır. Bu dağıtımın geliştirici makinesinde çalışacağı ve dış ağa yönlendirilmeyeceği düşünülerek basit bir **"güçlü"** parola ile oluşturulmuştur. Dış ağa açılması söz konusu olduğunda mutlaka daha güçlü bir koruma oluşturulmalıdır.
Kurulumla birlikte bir phpmyadmin yöneticisi de otomatik olarak deploy edilmektedir.
# Kurulum
Kurulum için basitçe aşağıdaki komutlar çalıştırılmalıdır (mysql % ile baişlayanlar komutlar, hemen altındakiler çıktılarıdır);
```console
mysql % kubectl apply -f 00-namespace 
namespace/mssql created
mysql % kubectl apply -f 01-Service  
configmap/mssql-config created
persistentvolume/mssql-pv-volume created
persistentvolumeclaim/mssql-pv-claim created
service/mssql created
deployment.apps/mssql created
```
# Bağlantı Testi

Bağlanmak için kullanılacak port ve ip adresini alalım;

```console
minikube service mssql --namespace=mssql
|-----------|-------|-------------|-----------------------------|
| NAMESPACE | NAME  | TARGET PORT |             URL             |
|-----------|-------|-------------|-----------------------------|
| mssql     | mssql |        1403 | http://192.168.99.102:30724 |
|-----------|-------|-------------|-----------------------------|
```

Artık SSMS içinden, Azure Data Studio içinden (Windows, MacOS ve Linux üzerinde çalışır) veya komut satırından sqlcmd ile;
```console
kubectl run -it --rm --image=mcr.microsoft.com/mssql/server:2019-latest --restart=Never mssql-client -- /opt/mssql-tools/bin/sqlcmd -S mssql.mssql.svc.cluster.local -Usa -PMinikubeStr0ng!Passw0rd
```
ile bağlantı kurabiliriz. Sizdeki kurulumda IP ve port doğal olarak farklı olacaktır.

# Bazı Faydalı Yapılandırmalar

```console
kubectl exec --tty --stdin --namespace=mssql mssql-6668d78ddb-7pztr /bin/bash
```
komutu ile sunucuya bağlanabilirsiniz. Buradaki pod ismi mssql-6668d78ddb-7pztr. Sizdekini öğrenmek için;
```console
kubectl get pods --namespace=mssql
```
komutunu kullanabilirsiniz. Bende yüklenen sürüm;

```console
1> select @@version
2> go
Microsoft SQL Server 2019 (RTM-CU8-GDR) (KB4583459) - 15.0.4083.2 (X64)
        Nov  2 2020 18:35:09
        Copyright (C) 2019 Microsoft Corporation
        Developer Edition (64-bit) on Linux (Ubuntu 18.04.5 LTS) <X64>
```

* SQLAgent Aktifleştirme: /opt/mssql/bin/mssql-conf set sqlagent.enabled true 
* Email profili değiştirme: /opt/mssql/bin/mssql-conf set sqlagent.databasemailprofile <profile_name>
* Collation Değiştirme: /opt/mssql/bin/mssql-conf set-collation

Bu kadar, güle güle kullanın.