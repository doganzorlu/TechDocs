# jenkins
Bu bölümde jenkins sunucu jenkins namespace içinde oluşturuluyor. 
## Kurulum
Kurulumu şağaıdaki komutlarla kolayca yapabilirsiniz;
```console
kubectl apply -f 00-namespace
kubectl apply -f 01-jenkins
```
Kurulum tamamlandığında external ip üzerinden bir browser aracılığı ile bağlandığınızda (tünel açık değil mi ?) ki IP adresini;
```console
kubectl get svc --namespace jenkins
NAME      TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)        AGE
jenkins   LoadBalancer   10.106.93.161   10.106.93.161   80:31362/TCP   24m
```
komutu ile alabilirsiniz admin parolası için bakılacak yeri söyleyecektir. Buradan admin parolasını almak için önce pod adını;
```console
kubectl get pods --namespace jenkins
NAME                       READY   STATUS    RESTARTS   AGE
jenkins-794f69ff77-5cl8s   1/1     Running   0          18s
```
komutu ile alıyoruz. Ardından;
```console
kubectl --namespace jenkins exec --tty --stdin jenkins-794f69ff77-5cl8s /bin/bash
root@jenkins-794f69ff77-5cl8s:/#
```
komutu ile ilgili pod içinde bir session açıyoruz. Bu sessionda;
```console
root@jenkins-794f69ff77-5cl8s:/# cat /var/jenkins_home/secrets/initialAdminPassword
1470946d35bd46e990e06d7867322c9c
```
komutu ile kurulan örneğin admin parolasını alabilirsiniz. Bu parola ile web arayüzünde devam ederek admin bir kullanıcı tanımlayarak çalışmaya başlayabilirsiniz.