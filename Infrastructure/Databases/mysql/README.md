# MySQL
Tek örnek çalışacak şekilde bir yapılandırmadır. configmap dosyasında yer alan oturum bilgilerini kullanır. Bu dağıtımın geliştirici makinesinde çalışacağı ve dış ağa yönlendirilmeyeceği düşünülerek basit bir parola ile oluşturulmuştur. Dış ağa açılması söz konusu olduğunda mutlaka daha güçlü bir koruma oluşturulmalıdır.
Kurulumla birlikte bir phpmyadmin yöneticisi de otomatik olarak deploy edilmektedir.
# Kurulum
Kurulum için basitçe aşağıdaki komutlar çalıştırılmalıdır (mysql % ile baişlayanlar komutlar, hemen altındakiler çıktılarıdır);
```console
mysql % kubectl apply -f 00-namespace 
namespace/mysql created
mysql % kubectl apply -f 01-Service  
configmap/mysql-config created
persistentvolume/mysql-pv-volume created
persistentvolumeclaim/mysql-pv-claim created
service/mysql created
deployment.apps/mysql created
mysql % kubectl apply -f 02-phpmyadmin 
service/phpmyadmin-service created
deployment.apps/phpmyadmin-deployment created
```

Bazı uygulamalar mysql 5 sürümü isteyebilir. Bu durumlar için de mysql56 adında bir deployment ve servis opsiyonel olarak buraya oluşturdum. Gerekli olduğu durumda üstteki yapılandırmadan sonra;
```console
mysql % kubectl apply -f 03-mysql56 
persistentvolume/mysql56-pv-volume created
persistentvolumeclaim/mysql56-pv-claim created
service/mysql56 created
deployment.apps/mysql56 created
```
komutu ile oluşturabilirsiniz.
# Komut çalıştırma
 MySQL komutları çalıştırmak için;
```console
kubectl run -it --rm --image=mysql:latest --restart=Never mysql-client -- mysql -h mysql.mysql.svc.cluster.local -padmin123
```
Hemen burada çapraz namespace servislerine erişmek gerektiğinde dns isimlendirmesinin nasıl olduğunu ana dökümanda tariflemiştik hatırlarsanız.