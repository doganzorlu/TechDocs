# ORACLE Express Edition 11g Server
Tek örnek çalışacak şekilde bir yapılandırmadır. configmap dosyasında yer alan sa bilgilerini kullanır. Bu dağıtımın geliştirici makinesinde çalışacağı ve dış ağa yönlendirilmeyeceği düşünülerek default parola korunmuştur. SYS/SYSDBA parolası **oracle** dır. Apex için kullanıcı kodu ve parola ise **ADMIN:admin** olarak korunmuştur.

# Kurulum
Kurulum için basitçe aşağıdaki komutlar çalıştırılmalıdır (mysql % ile baişlayanlar komutlar, hemen altındakiler çıktılarıdır);
```console
mysql % kubectl apply -f 00-namespace 
namespace/oracle-xe-11g created
mysql % kubectl apply -f 01-oracle-xe-11g  
configmap/oracle-xe-11g-config created
persistentvolume/oracle-xe-11g-pv-volume created
persistentvolumeclaim/oracle-xe-11g-pv-claim created
service/oracle-xe-11g created
deployment.apps/oracle-xe-11g created
```
# Bağlantı Testi

Bağlanmak için kullanılacak port ve ip adresini alalım;

```console
minikube service oracle-xe-11g -n oracle-xe-11g
|---------------|---------------|-------------|-----------------------------|
|   NAMESPACE   |     NAME      | TARGET PORT |             URL             |
|---------------|---------------|-------------|-----------------------------|
| oracle-xe-11g | oracle-xe-11g | oracle/1521 | http://192.168.99.102:30215 |
|               |               | xdb/8080    | http://192.168.99.102:30999 |
|---------------|---------------|-------------|-----------------------------|
```

Artık oluşan poda bir bağlantı açıp test edebiliriz;
```console
kubectl exec --tty --stdin -n oracle-xe-11g <podname> /bin/bash
```
ile bağlantı kurabiliriz. podname'i bulmak için;
```console
kubectl get pods -n oracle-xe-11g
NAME                             READY   STATUS    RESTARTS   AGE
oracle-xe-11g-6df97d4c8f-hg929   1/1     Running   0          7m50s
```
Konsoldan;
```console
root@oracle-xe-11g-6df97d4c8f-hg929:/# su - oracle
oracle@oracle-xe-11g-6df97d4c8f-hg929:~$ sqlplus / as sysdba

SQL*Plus: Release 11.2.0.2.0 Production on Mon Jan 25 18:38:11 2021

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Express Edition Release 11.2.0.2.0 - 64bit Production

SQL>
```
ile oracle kullanıcısı altından sisteme erişebilir ve yukardaki gibi versiyon görülebilir. Sizdeki kurulumda IP ve port doğal olarak farklı olacaktır. Aynı şekilde browser dan 8080 portunun expose edilmiş portundan da apex arayüzüne erişilebilir;

http://192.168.99.102:30999/apex/apex_admin

adresi yukardaki komutla bulduğumuzu unutmayın.

Bu kadar, güle güle kullanın.