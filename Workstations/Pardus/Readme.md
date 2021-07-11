# Pardus İş İstasyonu 

Bu bölümde, yazılım geliştirme ekiplerince kullanılabilecek bir "İdeal" Pardus iş istasyonu kurulumu ile ilgili uygulama örneği bulacaksınız. Benim tercihim Pardus 19.5 fakat siz güncelde hangi sürüm varsa onu kullanabilirsiniz.

Donanım önerisi: 16GB RAM (min 8GB), i5 ve üzeri işlemci, 500GB (min 256GB) disk alanı

# OS Kurulumu

Kurulum için Pardus resmi sitesinden 19.5 XFCE ürününün ISO dosyasını indirip makinamıza kuralım. Daha güncel sürümler geldikçe elbette o sürümleri de kullanabiliriz. Ardından mevcut tüm güncellemeleri geçelim ve kurulum için hazır hale gelelim.

```console
user@machine:~$ sudo apt-get update
user@machine:~$ sudo apt-get upgrade
user@machine:~$ sudo sync
user@machine:~$ sudo reboot
```

Eğer bir bir sanal makine olarak kurduysanız ilgili platformun misafir eklentilerini de yüklemeniz gerekecek. VirtualBox özelinde Virtualbox guest additions derleme için gerekli tüm paketler aşağıdaki şekilde yüklenir:

```console
user@machine:~$ sudo apt-get install build-essential dkms linux-headers-$(uname -r)
```

Kernel modülünün derlenmesi, yerleşik sağlanan kurulumda bu kernel sürümü çin modül olmamasından kaynaklanmaktadır. Ardından VirtualBox Aygıtlar->Misafir Eklentileri CD Kalıbını Yerleştir seçeneği ile misafir eklentileri disk kalıbı bu sanal makineye bağlanır;

```console
user@machine:~$ cd /media/cdrom
user@machine:~$ sudo sh ./VBoxLinuxAdditions.sh
```

Önemli not:

Zaman içinde kernel güncellemeleri geldikçe kernel modülünün yeniden oluşturulması gerekir. Virtualbox içinde pano çift yönlü olarak aktive edilirse kopyalama ve yapıştırma da mümkün olacaktır.

Artık VirtualBox içinde neredeyse doğal bir Pardus kurulumu yapılmış olur.

Pardus içinde CTRL+ALT+Ok tuşu kombinasyonu ile konsollar içinde dolaşabilmek mümkündür. Konsollardan standart bir kurulumda sadece bir tanesi grafik arayüzü gösteriyor olacaktır.

Paket yöneticisi olarak snap, ihtiyaç duyulan birkaç bileşenin kurulumunu oldukça kolaylaştıracaktır. Bunun için hızlıdan kurulumunu yapalım;

```console
user@machine:~$ sudo apt-get install snapd
user@machine:~$ sudo snap install core
```

Bu aşamada snap binary lerine erişebilmek için bir logout yapmak gerekecek. 

XFCE oldukça basit ve temel pencere yönetimi özellikleri sunuyor. Bu nedenle KDE veya GNOME daha uygun bir pencere yöneticisi olacaktır. Özellikle çoklu ekran kullanımında XFCE saç baş yoldurabilir. KDE kurulumu için;

```console
user@machine:~$ sudo apt install kde-full
```

Komutu ile kuralım. Ardından logout edip ilk login ekranında sağ üstteki üç çizgi menüsünden plasma yı seçerek KDE’ye geçiş yapabiliriz.

# Temel Yapılandırma

## Geliştirici Araçları

Bu aşamada geliştiriciler için rahat bir ortam oluşturacağız. 
## Pencil

Pencil çok güzel bir UIX aracı. Bu araç gerek mockup dizaynı ve gerekse akış tasarımı gibi pekçok konuda iyi bir çözüm sağlıyor. Kurmak için ise öncelikle **https://pencil.evolus.vn/Downloads.html** adresinden 64bit debian paketini indirip ardından;

```console
user@machine:~$ cd ~/İndirilenler
user@machine:~$ sudo apt install ./pencil_3.1.0.ga_amd64.deb
```
ile kurulumunu yapmak mümkün. Artık geliştirme öncesi analizlerinizde kullanabileceğiniz harika bir aracınız oldu.
### Edge Browser Kurulumu:

Bilindiği üzere MS EDGE, Chromium tabanlı bir browser ve sync özellikleri ile çoklu makinede kullananlar için gerekli olabilir.

```console
user@machine:~$ sudo apt-get install curl
user@machine:~$ curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
user@machine:~$ sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
user@machine:~$ sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'
user@machine:~$ sudo rm microsoft.gpg
user@machine:~$ sudo apt update && sudo apt install microsoft-edge-beta
```

### Terminator

Ardından daha etkin bir terminal kullanımı için ayarlar yapacağız. Öncelikle Linux üzerinde shell için kullanabileceğimiz bir sürü terminal uygulaması mevcut. Bu makalede sizi **Terminator** ile tanıştırmak istiyorum. Kurulum için;

```console
user@machine:~$ sudo apt-get install terminator fonts-powerline
```
komutunu kullanabilirsiniz. Ardından Andres Gongora tarafından hazırlanmış bir scripti bash için daha iyi bir görüntü için kullanacağız. **https://github.com/ChrisTitusTech/scripts/blob/master/fancy-bash-promt.sh** adresindeki bölümü;
```console
user@machine:~$ vi ~/.bashrc
```
komutu ile açacağınız dosyanın en altına ekleyip değişikliği görmek için terminator uygulamasını tekrar çalıştırabilirsiniz. Ben vi kullanıyorum eğer kullanmayı bilmiyorsanız öğrenmenizi tavsiye ederim. Ancak isterseniz **nano** editörü de kullanabilirsiniz.

### GIT

GIT olmazsa olmazımız;

```console
user@machine:~$ sudo apt-get install git
```

Bu aşamada genel yapılandırmayı oluşturalım;

```console
user@machine:~$ git config --global user.name "<Adınız>"
user@machine:~$ git config --global user.email <Eposta Adresiniz>
```

### VSCode

Edge için microsoft pardus depolarını ayarlamıştık, VSCode da bu depoda yer alıyor;

```code
user@machine:~$ sudo apt-get install code
```
yeterli olacaktır.

### Python 3
Python 3 ü sistem için ön tanımlı hale getirelim;

```console
user@machine:~$ sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
```

Ardından pip kuralım;

```console
user@machine:~$ sudo apt-get install python3-pip
user@machine:~$ sudo update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1
```

Python işi de tamam. Ben poetry kullanıyorum paket yönetimi için haydi onu da kuralım;

```console
user@machine:~$ sudo pip install poetry
```

### Flutter

Özellikle desktop ve frontend geliştirmede tek codebase kullanmak isteyenler için yakın zamanda popüler bir geliştirme aracı flutter. Bu araç ile Pardus üzerinde web, linux için desktop ve Android platformları için geliştirme yapabiliriz. iOS için bir MacOS çalıştıran makineye ihtiyacınız olacaktır. Yine snap paket yöneticisi ile hızlıdan kuralım;

```console
user@machine:~$ sudo snap install flutter --classic
user@machine:~$ flutter sdk-path
```

Web geliştirmesi için flutter chrome browser gerektiriyo;

```console
user@machine:~$ sudo snap install chromium
user@machine:~$ sudo ln -s /snap/bin/chromium /usr/bin/google-chrome
```

Linux desktop geliştirmek için ise gerekli paketleri yükleyelim;

```console
user@machine:~$ sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev
```

Android geliştirme için android studio ya ihtiyacımız olacak;

```console
user@machine:~$ sudo snap install android-studio
```
SDK yüklemek için;

```console
user@machine:~$ android-studio
```

Bu aşamada Android SDK larını yüklüyoruz. Dikkat edilecek husus Android SDK ayarları içinde SDK Araçları menüsünden komut satırı araçlarını yüklemiş olmak. Aksi takdirde lisans onayı vermek mümkün olmayacaktır. Artık lisans onayı da verip kurulumu tamamlayalım;

```console
user@machine:~$ flutter doctor --android-licenses
```

Bu aşamadan sonra flutter için bakalım her şey yolunda mı;

```console
user@machine:~$ flutter doctor

Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 2.2.1, on Linux, locale tr_TR.UTF-8)
[✓] Android toolchain - develop for Android devices (Android SDK version 30.0.3)
[✓] Chrome - develop for the web
[✓] Android Studio (version 4.2)
[✓] VS Code (version 1.57.1)
[✓] Connected device (1 available)

• No issues found!
```
### NodeJS
Sırada NodeJS kurulumu var. 
```console
user@machine:~$ sudo apt install nodejs
user@machine:~$ sudo apt install npm
```
Hepsi bu. Eğer birden fazla sürümle çalışma ihtiyacınız varsa **Node Version Manager** ile bu soruna kolay bir çözüm de bulabilirsiniz. Yolculuğumuzun üçte birlik kısmına yaklaştık diyebiliriz. Bu aşamadan sonra zaten elle tutulmaz olan sistemimizde daha da sanal ortamlar oluşturacağız. Herşey mış gibi olacak bu bölümde.

## DevOps ve Backend Araçları

Bu aşamada backend geliştiriciler ve DevOps insanları için rahat bir ortam oluşturacağız. Herşey tamam görünüyor. Makinemize doğal olarak kuracağımız neredeyse herşeyi kurduk. Bu aşamadan sonra gerekli olacak tüm gereksinimlerimiz (backend, database vs) için;

* KVM içinde kuracağımız sanal makineler, 
* KVM içinde oluşturacağımız kubernetes içindeki konteynerlar
* LXD konteynerları 

kullanılabilir olacak. Bu sayede sanallaştırma ve konteynerizasyon için mevcut neredeyse tüm seçenekleri kullandığımız bu makineye yüklemiş olacağız. Bundan sonrası -mış- gibi adını verdiğim sanallaştırma ve konteyner platformunun oluşturulmasını içeriyor.

### KVM
Bu sistem Pardus üzerinde doğala yakın bir performans ile sanal makineler çalıştırmamızı sağlayacak.

```console
user@machine:~$ sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-daemon bridge-utils
user@machine:~$ sudo apt-get install virt-manager
user@machine:~$ sudo usermod -a -G libvirt <username>
```
KVM sanallaştırma artık kullanıma hazır. 

### LXD
LXD, Pardus içinde Pardus Kernel'ini kullanarak başka Linux ların konteyner halinde çalışmalarını sağlayan bir konteyner platformudur. Şimdi LXD kurulumunu da yapalım;
```console
user@machine:~$ sudo snap install lxd
user@machine:~$ sudo lxd init
```
bu aşamada lxd yapılandırmasını yapıyoruz. Geldiği gibi devam edebilir ya da kendi ihtiyacınıza göre yapılandırabilirsiniz.
```console
user@machine:~$ sudo usermod -a -G lxd <username>
```
kendi kullanıcınızın lxc komutu ile sistemi kontrol edebilmesi için gerekli ayarlamayı yapacak. Tabi yeniden login ettikten sonra.

Artık Pardus makinemiz hem VM, hem de Container olarak iki farklı tipte sanallaştırmayı destekler hale geldi. 

### Kubernetes
Makinemizde bir minik kubernetes olsa iyi olur zira developer dostların ihtiyacı olacak. Neden doğrudan Docker kurup onu kullanmadık sorusu akla gelebilir. Bu aşamada kubernetes konusunda kendimizi geliştirmek ve doğal olarak bulut uygulamalarını anlamak ve geliştirdiğimiz uygulamaları CN üzerinde yayınlamak buradaki temel motivasyonumuz. 
```console
user@machine:~$ wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 -O minikube
user@machine:~$ sudo mv minikube /usr/local/bin/
user@machine:~$ sudo chmod 755 /usr/local/bin/minikube
user@machine:~$ minikube start --cpus 2 --memory 4000
```
4GB ram ve 2 işlemcili bir kubernetes kullanıma hazır. kubectl olmazsa kubernetes’i yönetemeyiz. Bunun için;
```console
user@machine:~$ curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
user@machine:~$ sudo mv kubectl /usr/local/bin
user@machine:~$ chmod +x /usr/local/bin/kubectl
```
Tamam gibiyiz. 

Kubernetes üzerine iş yükü yüklemek için helm güzel bir paket yöneticisi olan HELM yükleyerek devam edelim.
```console
user@machine:~$ sudo snap install helm --classic
user@machine:~$ helm repo add stable https://charts.helm.sh/stable
user@machine:~$ helm repo update
```
helm paket yöneticisi de hazır. Hem deneme, hem de yönetim için minikube kubernetes üzerine bir rancher deploy edelim;
```console
user@machine:~$ helm repo add jetstack https://charts.jetstack.io
user@machine:~$ helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
user@machine:~$ helm repo update
user@machine:~$ kubectl create namespace cert-manager
user@machine:~$ kubectl create namespace cattle-system
user@machine:~$ kubectl apply --validate=false -f 
user@machine:~$ https://github.com/jetstack/cert-manager/releases/download/v1.0.4/cert-manager.crds.yaml
user@machine:~$ helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.0.4
user@machine:~$ helm install rancher rancher-latest/rancher --namespace cattle-system --set hostname=rancher.<domain>
```
Burada önemli not <domain> bölümünde localhost veya localdomain kullanmayın buradaki hostname içinde ve bu hostname’i /etc/hosts içine ekleyeceğiz daha sonra.
```console
user@machine:~$ kubectl -n cattle-system rollout status deploy/rancher
Waiting for deployment "rancher" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "rancher" rollout to finish: 1 of 3 updated replicas are available...
Waiting for deployment "rancher" rollout to finish: 2 of 3 updated replicas are available...
deployment "rancher" successfully rolled out
user@machine:~$ kubectl -n cattle-system get deploy rancher
```
tüm replikalar çalıştığında tekrar komut satırına dönecektir. Rancher da hazır olduğuna göre PaaS hazır. (Aslında tüm yapıyı siz yönettiğiniz için kendiniz için bir IaaS olduğu da söylenebilir tabi) 

Servisin cluster IP adresini almak için;
```console
user@machine:~$ kubectl get svc -n cattle-system

NAME              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
rancher           ClusterIP   10.107.191.74    <none>        80/TCP,443/TCP   3m19s
rancher-webhook   ClusterIP   10.101.188.215   <none>        443/TCP          15s
```
/etc/hosts içine;

```console
10.107.191.74 rancher.<domain>
```
bilgisini girerek addan erişimi mümkün hale getirelim. Burada <domain> kurulumda verilen domain olacak. Başka bir terminalde;
```console
user@machine:~$ minikube tunnel
```
komutunu kullanarak cluster için bir router oluşturup artık kubernetes içindeki servislere cluster ip leri üzerinden erişebiliriz.

## Diğer

Video konferans sıkça kullanılan bir çalışma şekli. Bunun için iki uygulamayı yükleyelim. Birisi Zoom, Diğeri MS Teams.

### Zoom

```console
user@machine:~$ sudo snap install zoom-client
```

### Tems

```console
user@machine:~$ sudo snap install teams
```
### Eğlence

Elbette bu makineyi kullanacak kişinin biraz da eğlenmeye hakkı var. Spotify üzerinden müzik dinlemek yerinde güzel bir fikir;

```console
user@machine:~$ sudo snap install spotify
```
# Sonuç
Pardus makinemiz bir geliştirici ve/veya DevOps için giriş seviyesinde hazır hale geldi. Başka geliştirme araçları kullanan geliştiriciler de kendi ihtiyaçlarına göre araç gereç bunun üstüne yükleyebilirler. DevOps bu makine ile ne yapacak derseniz bir yerel registry, bir GIT surunucu ve bir image oluşturu hazırlayıp GIT üzerinden uygulama image leri hazırlayıp bunları yerel registry ye gönderip bu registry üzerinden delivery testleri yapabilir.
