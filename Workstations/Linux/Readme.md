# Linux İş İstasyonu

Bu bölümde, yazılım geliştirme ekiplerince kullanılabilecek bir "İdeal" Linux iş istasyonu kurulumu ile ilgili uygulama örneği bulacaksınız. Benim tercihim Ubuntu 20.04 LTS fakat siz güncelde hangi sürüm varsa onu kullanabilirsiniz.

# Kurulum

Kurulum için ubuntu resmi sitesinden 20.04 LTS Desktop ürününü makinamıza kuralım. Daha güncel sürümler geldikçe elbette o sürümleri de kullanabiliriz. Ardından mevcut tüm güncellemeleri geçelim ve kurulum için hazır hale gelelim.

## Temel Kurulum


## Geliştirici Araçları

Bu aşamada geliştiriciler ve devops adminleri için rahat bir ortam oluşturacağız. 

### VSCode

Birkaç komutla vscode uygulamamızı kuralım.
```code
user@machine:~/ wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
user@machine:~/ sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
user@machine:~/ sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
user@machine:~/ rm -f packages.microsoft.gpg
user@machine:~/ sudo apt install apt-transport-https
user@machine:~/ sudo apt update
user@machine:~/ sudo apt install code
```
Benim geliştirme yaparken sürekli kullandığım bu editörden öte uygulama ile sistem içinde düzenleyeceğimiz tüm metin dosyalarını çok kolaylıkla düzenleyebileceğiz.

### Terminator

Ardından daha etkin bir terminal kullanımı için ayarlar yapacağız. Öncelikle Linux üzerinde shell için kullanabileceğimiz bir sürü terminal uygulaması mevcut. Bu makalede sizi **Terminator** ile tanıştırmak istiyorum. Kurulum için;

```console
user@machine:~/ sudo apt-get install terminator fonts-powerline
```
komutunu kullanabilirsiniz. Ardından Andres Gongora tarafından hazırlanmış bir scripti bash için daha iyi bir görüntü için kullanacağız. **https://github.com/ChrisTitusTech/scripts/blob/master/fancy-bash-promt.sh** adresindeki bölümü;
```console
vi ~/.bashrc
```
komutu ile açacağınız dosyanın en altına ekleyip değişikliği görmek için terminator uygulamasını tekrar çalıştırabilirsiniz. Ben vi kullanıyorum eğer kullanmayı bilmiyorsanız öğrenmenizi tavsiye ederim. Ancak isterseniz **nano** editörü de kullanabilirsiniz.

## Python

Bu makalede bahsettiğim dağıtım ile yerleşik olarak python3 geliyor. Bu nedenle sadece pip kurulması ve ardından paket kurucu olarak poetry nin kurulması yeterli olacaktır.

```console
user@machine:~/ sudo apt-get install python3-pip
user@machine:~/ pip3 install poetry
```
Sırada NodeJS kurulumu var. 
```console
user@machine:~/ sudo apt install nodejs
user@machine:~/ sudo apt install npm
```
Hepsi bu. Eğer birden fazla sürümle çalışma ihtiyacınız varsa **Node Version Manager** ile bu soruna kolay bir çözüm de bulabilirsiniz. Yolculuğumuzun üçte birlik kısmına yaklaştık diyebiliriz. Bu aşamadan sonra zaten elle tutulmaz olan sistemimizde daha da sanal ortamlar oluşturacağız. Herşey mış gibi olacak bu bölümde.

## Virtualization Platform

Geliştirici makinemizde sanallaştırma platformu olarak KVM kullanacağız. Linux çekirdeğinde yerleşik geliyor ve sadece vm manager kurarak kulaylıkla yönetebiliriz (bildiniz komut satırından yönetebiliyoruz). Buyrun birlikte kuralım;
```console
user@machine:~/ sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-daemon bridge-utils
user@machine:~/ sudo apt-get install virt-manager
```
Bu kadar. Artık hazırız.

# Minikube ?

Geliştirme için gerekli olacak birkaç tane servisin yapılandırma dosyalarını ekledim. Bu dosyalardaki credential bilgileri admin123 parolası kullanıyor. Eğer production da bu yapılandırmaları kullanacak olursanız değiştirmeniz gerekir. Çalışırken yeni başlayanlar için belki daha kolay olur diye minikube kurup, geliştirme için bunu da opsiyon olarak ekleyeyim istedim. Öncelikle kurulum çok kolay. 
```console
user@machine:~/ wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 -O minikube
user@machine:~/ sudo mv minikube /usr/local/bin/
user@machine:~/ sudo chmod 755 /usr/local/bin/minikube
```  
ile çalıştırılabilir dosya olarak işaretliyoruz.

```console
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
sudo mv kubectl /usr/local/bin
chmod +x /usr/local/bin/kubectl
```
ile kubectl yi de hazır hale getiriryoruz.

Artık minikube kurmaya hazırız.

```cosole
user@machine:~/ minikube start --cpus 2 --memory 4000
```

komutu ile makinemizde kurulu KVM i kullanarak kendi image dosyasını indirip kendi VM ini oluşturacaktır. Eğer KVM i doğrudan kullanamayacak olursa driver parametresi ile göstermek gerekebilir.Bellek miktarı ile cpu sayısını sonradan değiştiremezsiniz. Mutlaka mevcut cluster'ı kaldırıp yeniden kurmanız gerekir.

Bu projenin kök dizininde Infrastructure diye bir klasör göreceksiniz. Haydi oradaki postgis servisini deploy edelim;

```console
user@machine:~/ kubectl apply -f 00-namespace
user@machine:~/ kubectl apply -f 02-postgis
```

evet bu kadar. Bu dosyaların ne olduğunu daha sonra açıklayacağım. Servisin durumu nedir bakalım;

```console
user@machine:~/ kubectl describe deployment -n postgres
Name:                   postgis
Namespace:              postgres
CreationTimestamp:      Mon, 01 Feb 2021 13:59:02 +0300
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=postgis
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=postgis
  Containers:
   postgis:
    Image:      postgis/postgis
    Port:       5432/TCP
    Host Port:  0/TCP
    Environment Variables from:
      postgis-config  ConfigMap  Optional: false
    Environment:      <none>
    Mounts:
      /var/lib/postgresql/data from postgisdb (rw)
  Volumes:
   postgisdb:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  postgis-pv-claim
    ReadOnly:   false
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   postgis-647c7475bf (1/1 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  9m28s  deployment-controller  Scaled up replica set postgis-647c7475bf to 1
```
Herşey yolunda görünüyor. Bu şekilde minikube kurulumu yapmış olduk. Sadece development yapacak başka da birşeyle uğraşmayacaklar için sadece bu platform yeterli olacaktır.