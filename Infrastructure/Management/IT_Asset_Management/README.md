# Asset MAnagement

Bu bölümde bir organizasyonun olmazsa olmazı varlık yönetimi konusunda kullanabileceği araçları bulabilirsiniz. Buradaki varlıklar "Bilgi Varlıkları" olarak okunmalı.

GEnel olarak iki türlü faaliyet şekli var bu konuda;
* Bilgi Varlıklarını Yönetmek
* Bilgi Varlıklarının Sizi Yönetmesi

İkincisi tercih edilmemesi gereken bir faaliyet şekli zira bu durumda günlük olarak oluşan olaylara müdahalae ile yürüyen bir iş modeli söz konusudur. Birincisi için bu bölümde önerdiğimiz bileşenler;
* OCSInventory - Uçbirim (Sabit ve Taşınabilir Aygıtlar örn: windows, androis, MacOS) varlık oluşturucu
* GLPI - Varlık Yöneticisi
* ZABBIX - Varlık İzleme Sistemi

# Kurulum

Öncelikle namespace oluşturarak başlayalım.

```console
# cd <techdocs>/infrastructure/Management/IT_Asset_Management
# kubectl apply -f 00-namespace
```

## ocsinventory

Veritabanı oluşturalım (mysql56'yi kurmuş olmalısınız. Kurmadıysanız Infrastructure/Database/MySQL bölümüne bakabilirsiniz);

```console
# kubectl run -it --rm --image=mysql:latest --restart=Never mysql-client -- mysql -h mysql57.mysql.svc.cluster.local -padmin123
mysql> CREATE DATABASE ocsweb CHARACTER SET utf8 COLLATE utf8_general_ci;
mysql> grant all privileges on ocsweb.* to ocs@'%' identified by 'P@ssw0rd.321';
```

Artık konteynerlarımızı oluşturabiliriz;

```console
# kubectl apply -f 01-ocsinventory
configmap/ocsinventory-config created
persistentvolume/ocsinventory-pv-volume created
persistentvolumeclaim/ocsinventory-pv-claim created
service/ocsinventory created
deployment.apps/ocsinventory created
```

Bu aşamada kurulum için gerekli dosyanın konteyner içine kopyalanarak kurulum sonrası silinmesi gerekiyor;

```console
# kubectl get pods -n assetmanagement
NAME                           READY   STATUS    RESTARTS   AGE
ocsinventory-697dd9c6f-2tbc9   1/1     Running   0          12m
# kubectl exec --tty --stdin ocsinventory-697dd9c6f-2tbc9 /bin/bash -n assetmanagement
# cd /usr/share/ocsinventory-reports/ocsreports
# wget https://raw.githubusercontent.com/OCSInventory-NG/OCSInventory-ocsreports/master/install.php
```
Burada gördüğümüz konteyner ID si sizde farklı olacaktır. Siz o ID yi kullanmalısınız.

Artık web arayüzüne gidip ilk kurulumu tamamlayalım;

```console
# minikube service list
|-----------------|--------------------|--------------|-----------------------------|
|    NAMESPACE    |        NAME        | TARGET PORT  |             URL             |
|-----------------|--------------------|--------------|-----------------------------|
| assetmanagement | ocsinventory       | srhttp/80    | http://192.168.99.104:32527 |
|                 |                    | srhttps/443  | http://192.168.99.104:31930 |
| default         | kubernetes         | No node port |
| kube-system     | kube-dns           | No node port |
| mysql           | mysql              |         3306 | http://192.168.99.104:31659 |
| mysql           | mysql56            |         3306 | http://192.168.99.104:32108 |
| mysql           | mysql57            |         3306 | http://192.168.99.104:32752 |
| mysql           | phpmyadmin-service |           80 | http://192.168.99.104:31171 |
|-----------------|--------------------|--------------|-----------------------------|
```

Buradan ocsinventory srhttp/80 yazan satırdaki adresi kullanarak;

```url
http://http://192.168.99.104:32527/ocsreports
```
adresine gidip gelen diyalog ile kurulumu yapıp ardından;
```console
# kubectl get pods -n assetmanagement
NAME                           READY   STATUS    RESTARTS   AGE
ocsinventory-697dd9c6f-2tbc9   1/1     Running   0          12m
# kubectl exec --tty --stdin ocsinventory-697dd9c6f-2tbc9 /bin/bash -n assetmanagement
# cd /usr/share/ocsinventory-reports/ocsreports
# rm install.php
```
ile install.php yi kaldırıyoruz. Evet artık hazırız.