# Kurulum

## Temel Kurulum

## Geliştirici Araçları

Bu aşamada geliştiriciler ve devops adminleri için rahat bir ortam oluşturacağız. Apple Silicon kullanan cihazlarda Arm64 uyumlu bileşenler gerekli olacağından bazı bölümler Intel Silicon'lu cihazlardan daha farklı olacak haliyle.

### VSCode

İlk olarak [BURAYA TIKLAYARAK](https://code.visualstudio.com "VSCode Sitesi") VSCode sitesinden VSCode uyglamasını indirip, zip içinden çıkan vscode uygulamasını Applications içine atalım. 

Benim geliştirme yaparken sürekli kullandığım bu editörden öte uygulama ile sistem içinde düzenleyeceğimiz tüm metin dosyalarını çok kolaylıkla düzenleyebileceğiz.

Visual Studio Code uygulamasını komut satırından da kullanabilmek için ise uygulamayı açıp Ctrl+Shipt+P tuşlarına basarak açılan command palette içinde "shell command" arayıp, buradan "Install 'code' command in PATH seçeneğini seçelim.

### brew

Homebrew sıkça lazım olacak. Kurulum için;

```console
dogan@MBP ~ % /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
işinizi görecektir. brew komutunu konsoldan kullanabilmek için shell environment içindeki PATH'e eklemek iyi bir fikir gibi geliyor bana. Bunun için;

```console
dogan@MBP ~ % (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/dogan/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
```    

### iTerm2

Ardından daha etkin bir terminal kullanımı için;

[BURAYA TIKLAYARAK](https://iterm2.com/ "iTerm2 Sitesi") 

ilgili uygulamayı kurup çalıştıralım. Uygulamanın ayarlarında profile içinde session bölümünde git vb. entegrasyonları ayarlayacağınız bir bölüm var. Buradan ben git i aktifleştirdim.

### Python

Yerleşik olarak python2 ile gelen MacOS içinde python3 kurmanın türlü türlü yolları var. Fakat ben en basit seçeneği kullandım;

```console
dogan@MBP ~ % python3
```

Bu komutla birlikte MacOS yerleşik geliştirme platformu kurucusu sizin için python ve pip için v3 kurulumlarını yapacaktır. Bu söylediğim Big Sur için geçerli. Daha önceki sürümlerde python sitesinden kurulumu indirip kurmak gerekecektir. Ardından;

```console
dogan@MBP ~ % sudo pip3 install poetry
```

ile poetry yi de kurduk mu python development hazır.

### Node

Sırada NodeJS kurulumu var. Hatırlarsınız brew kurmuştuk. Onunla kolayca bir kurulum yapıverelim;

```console
dogan@MBP ~ % brew install node
``````

Yolculuğumuzun üçte birlik kısmına yaklaştık diyebiliriz. Bu aşamadan sonra zaten elle tutulmaz olan sistemimizde daha da sanal ortamlar oluşturacağız. Herşey mış gibi olacak bu bölümde.

### Flutter

Hadi flutter'ı kuralım. Bunun için brew kullanmak iyi bir fikir olabilir.

```console
dogan@MBP ~ % brew install flutter
```
Bize rosetta da lazım olacak. Hızlıdan kuralım;

```console
dogan@MBP ~ % softwareupdate --install-rosetta
```

Flutter içinden xcode simulatöründe bir aydıt oluşturmak için minicik bir paket gerekli olacak. Bunu kurmak için;

```console
dogan@MBP ~ % sudo gem install cocoapods
```
komutunu kullanacağız. 

'flutter doctor' komutu ile gelen rapor, daha neleri yapmamız gerektiğini bize söyleyecek zaten. İlk XCode lazım olacak ve aşağıdaki komutla hızlıdan kurulumumuzu tamamlayalım.

```console
dogan@MBP ~ % sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

Lisansaları kabul etmeden kullanamayacağımıza göre, haydi komut satırından yapıverelim;

```console
dogan@MBP ~ % sudo xcodebuild -license
```
bu da tamam. Yine doctor'un önerdiği yerden Android Studio'yu indirip kuruyoruz ve özellikle komut satırı araçlarını yüklüyoruz. Ardından doktora sorduğumuzda, lisanları bir onayla bakalım diyecek. Haydi onaylayalım;

```console
dogan@MBP ~ % flutter doctor --android-licenses
```

## Virtualization Platform

Virtualization için elimizde hem apple hem de linux vm ler oluşturabileceğimiz bir araçla sizleri tanıştırmak istiyorum "tart"

Tart'ı kurmak için yine brew kullanacağız. 

```console
dogan@MBP ~ % brew install cirruslabs/cli/tart
```
Bu kadar. Artık Linux ve Apple VM ler çalıştırabiliriz. Burada akla neden bir VM çalıştıracağımız gelebilir. Bir geliştirici olarak bir sürü servisin birbiri ile bağımlı olduğu ortamlarda kod geliştiriyoruz çoğunlukla. Bir diğer bağımlı servislerin de yerel sürümlerini çalıştırmak, offline geliştirme için çok büyük konfor sağlıyor açıkçası. Bu nedenle docker, ya da doğal linux kullanmak gerekebiliyor. eğer docker'ı doğrudan mac de çalıştıracak olursanız, standby dan geri dönüşte pekçok servisin cevap vermediğini, hatta docker'ın da kafasının karıştığını göreceksiniz. Bu nedenle docker'ı da bir VM içinde kullanmak çok yararlı bir pratik oluyor. Ben Debian ARM64 iso sundan bir kurulum göstereceğim bu makalede.

Öncelikle debian sitesinden arm54 network installation iso dosyasını indirelim. Ardından bir VM oluşturmak için;

```console
dogan@MBP ~ % tart create <vm adi> --linux --disk-size 50
```
komutu ile 50gb diskli bir VM oluşturalım. ISO'dan kurulum için;

```console
dogan@MBP ~ % tart run <vm adi> --disk ~/Downloads/debian-12.2.0-arm64-netinst.iso
```
ile kurulumu gerçekleştiriyoruz. Bende debian 12 olduğundan bunu kullandım, siz artık hangi sürümü indirdiyseniz onu kullanın derim. Normal bir Debian kurulumundan hiçbir fark olmadan kurulumu bitirip yeniden başlatıyorsunuz. Önerim openSSH sunucuyu da kurmanız yönünde. İkide bir UI penceresi içinde cebelleşmek zorunda kalmazsınız. Artık makinemizi ihtiyaç halinde arka planda çalıştırmak için;

```console
dogan@MBP ~ % tart run <vm adi> --no-graphics &
```
demek yeterli olacaktır. tart komutlarını komutu boş kullanarak ve parametreleri ile ilgili yardımı da --help diyerek alabilirsiniz.

## Resolver & DNSMasq

Bunlar neden lazım, amma karıştırdın diyenler için özellikle wildcard isimler ile lokal bir service mesh oluşturmak için bir araç olarak kullanacağım. dnsmasq kurmak kolay, biliyorsunuz artık brew var :)

```console
dogan@MBP ~ % brew install dnsmasq
```

Ardından wildcard kullanacağınız domainin ip si (burada VM'in ip sini vereceğiz doğal olarak tart ip <vm adi> işinizi görür)

```console
dogan@MBP ~ % echo 'address=/.localdomain/192.168.64.2' >> /opt/homebrew/etc/dnsmasq.conf
```

böylelikle *.localdomain için 192.168.42.2 (benim VM in ip si) ni verdik dnsmasq'a ki bu sorguya hep bu ip adresini döndürsün. Ardından dnsmasq ın dinleyeceği ip adreslerini ekleyelim. Yerelden kullanacağınız için 127.0.0.1 yeterli;

```console
dogan@MBP ~ % echo 'listen-address=127.0.0.1' >> /opt/homebrew/etc/dnsmasq.conf
```
Bir de resolver için bu domaini dnsmasq dan kullanacağını söyledik mi bu iş tamam;

```console
dogan@MBP ~ % sudo mkdir /etc/resolver
dogan@MBP ~ % sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/localdomain'
```
Servisi bir yeniden başlatalım bakalım hayırlısıyla;
```console
dogan@MBP ~ % sudo brew services restart dnsmasq
```

Bir de test edelim;

```console
dogan@MBP ~ % ping aaa.localdomain
PING aaa.localdomain (192.168.64.2): 56 data bytes
```

tamamdır. Artık ip adresimiz çözülüyor. Şimdi'de service mesh için kalan kurulumu devam ettirelim.


## Service Mesh

### Linux VM

Ben bu iş için yukarıda traiflendiği şekilde bir debian VM kullanacağım. Adını pergen koydum. 

### Docker

pergen içinde docker kurulumunu bu bölümde detaylıca anlatacağım. Öncelikle root kullanıcı ile giriş yapıp, paket yöneticisini güncelleyerek kullanıcımızı sudo yetkisi ile donatalım;

```console
dogan@pergen:~# apt update
dogan@pergen:~# apt install sudo
dogan@pergen:~# usermod -aG sudo dogan
```

Artık kısıtlı kullanıcı ile sisteme giriş yapıp docker kurulumumuzu yapalım. Öncelikle gerekli paketler ve varsa şayet önceki paketleri kaldıralım;

```console
dogan@pergen:~/ sudo apt update
dogan@pergen:~/ sudo apt install ca-certificates curl gnupg lsb-release
dogan@pergen:~/ sudo apt-get remove docker docker-engine docker.io containerd runc
```

Docker repolarını paket yöneticisine ekleyelim;

```console
dogan@pergen:~/ curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
dogan@pergen:~/ echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
dogan@pergen:~/ sudo apt-get update
```
Artık docker kurulumu yapabiliriz ve ardından kullanıcımızı docker grubuna ekelyerek swarm'ı ilklendirelim;

```console
dogan@pergen:~/ sudo apt-get install docker-ce docker-ce-cli containerd.io
dogan@pergen:~/ sudo usermod -aG docker ${USER}
dogan@pergen:~/ sudo docker swarm init
dogan@pergen:~/ docker node ls
ID                            HOSTNAME   STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
q6qw6sv1o4izj34m49x5zozcv *   pergen     Ready     Active         Leader           24.0.7
```
Şimdide deploy edildiğinde oluşacak pod ların verilerini kalıcı hale getireceğimiz bir depolama alanını oluşturalım;
```console
dogan@pergen:~/ sudo mkdir /opt/datastore
dogan@pergen:~/ sudo chgrp docker /opt/datastore/
```
Şimdi kişisel klasörümüz içinde bir dizin oluşturalım ki stack tanım dosyalarını buraya koyabilelim;

```console
dogan@pergen:~/ mkdir stacks
```
Gerekli temel iki overlay ağı oluşturalım. Birisi pos lar dış dünya ile görüşsün diye, ikincisi geliştirme sırasında lazım olacak veritabanlarına erişmesini istediğimiz servisler için.
```console
dogan@pergen:~/ docker network create --driver overlay traefik-public
dogan@pergen:~/ docker network create --driver overlay database
```
Docker hazır. Haydi load balancer ve aynı zamanda ssl termination noktası olan ilk stack ile başlayalım;

### Traefik

Traefik service mesh için loadbalancer ve aynı zamanda ssl terminasyon noktası olarak iş görecek. Haydi kuralım. Aşağıdaki dosyayı Linux VM içinde kullanıcı klasörünüzde oluşturacağınız stack adındaki bir klasörde traefik.yaml olarak oluşturun. Çok detaya girmeyeceğim lakin bu yapılandırma basitçe hhtp isteklerini https e yönlendiriyor ve servisler için traefik-public adında bir bridge üzerinden dış dünya ile içerideki pod ların iletişimini sağlıyor. SSL sertifikaları için /opt/datastore/traefik/tools/certs dosyasını kullanıyor. Takip eden bölümde bir self signed sertifika oluşturup yapılandıracağız. 

Öncelikle gerekli dizinleri oluşturalım;

```console
dogan@pergen:/opt/datastore$ sudo mkdir -p /opt/datastore/traefik
dogan@pergen:/opt/datastore$ sudo mkdir -p /opt/datastore/traefik/tools/certs
```

Traefik için bir wildcard self servis sertifika oluşturalım ve cert.pem ve key.pem olarak /opt/datastore/traefik/tools/certs klasörüne koyalım.

#### SSL

Bu işlermler için geçici bir dizin kullanalım. cd komutunu verip enter tuşuna basarsanız kullanıcınızın ev dizinine ulaşırsınız. Burada;

```console
dogan@pergen:~/ mkdir certs
dogan@pergen:~/ cd certs
dogan@pergen:~/certs$ 

openssl genrsa -des3 -out ca.key 4096
openssl req -new -x509 -days 3650 -key ca.key -out ca.crt
openssl genrsa -out cert.key 2048
```
Şimdi bir request dosyası oluşturalım;

localdomain.cnf:

```conf
[req]
default_md = sha256
prompt = no
req_extensions = req_ext
distinguished_name = req_distinguished_name
[req_distinguished_name]
commonName = *.localdomain
countryName = TR
stateOrProvinceName = No state
localityName = Izmir
organizationName = Docker
[req_ext]
keyUsage=critical,digitalSignature,keyEncipherment
extendedKeyUsage=critical,serverAuth,clientAuth
subjectAltName = @alt_names
[alt_names]
DNS.1=localdomain
DNS.2=*.localdomain
```

```console
dogan@pergen:~/certs$ openssl req -new -nodes -key cert.key -config localdomain.cnf -out localdomain.csr
dogan@pergen:~/certs$ openssl x509 -req -in localdomain.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out cert.crt -days 1024 -sha256 -extfile localdomain.cnf -extensions req_ext
```

Artık .pem dosyalarını oluşturabiliriz;

```console
dogan@pergen:~/certs$ openssl rsa -in cert.key -text > cert.pem
dogan@pergen:~/certs$ openssl x509 -inform PEM -in cert.crt > cert.pem
```

CA sertifikasını scp ile yerele kopyalayıp keychain içinde trust olarak düzenlerseniz sertifika ile ilgili hata almazsınız. Özellikle servis-servis iletişiminde sorun yaşamamak için bu sertifikanın servis image içinde enjekte edilmesi gerekebilir.

```yaml
version: '3.3'
services:
  traefik:
    image: traefik:latest
    ports:
      - 80:80
      - 443:443
      - 8080:8080
    deploy:
      mode: global
      labels:
        - traefik.enable=true
        - traefik.docker.network=traefik-public
        - traefik.constraint-label=traefik-public
        - traefik.http.middlewares.https-redirect.redirectscheme.scheme=https
        - traefik.http.middlewares.https-redirect.redirectscheme.permanent=true
        - traefik.http.routers.traefik-public-http.priority=1
        - traefik.http.routers.traefik-public-http.rule=Host(`traefik.localdomain`)
        - traefik.http.routers.traefik-public-http.entrypoints=http
        - traefik.http.routers.traefik-public-http.middlewares=https-redirect
        - traefik.http.routers.traefik-public-https.rule=Host(`traefik.localdomain`)
        - traefik.http.routers.traefik-public-https.entrypoints=https
        - traefik.http.routers.traefik-public-https.tls=true
        - traefik.http.routers.traefik-public-https.tls.certresolver=dcresolver
        - traefik.http.routers.traefik-public-https.tls.domains[0].main=traefik.localdomain
        - traefik.http.routers.traefik-public-https.service=api@internal
        - traefik.http.routers.traefik-public-https.middlewares=authelia@docker
        - traefik.http.services.traefik-public.loadbalancer.server.port=8080
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /opt/datastore/traefik/tools/certs:/tools/certs
      - /opt/datastore/traefik/dynamic_conf:/etc/traefik/dynamic_conf
    command:
      - --providers.docker
      - --providers.docker.constraints=Label(`traefik.constraint-label`, `traefik-public`)
      - --providers.docker.exposedbydefault=false
      - --providers.docker.swarmmode
      - --providers.docker.watch
      - --providers.file.directory=/etc/traefik/dynamic_conf
      - --providers.file.watch=true
      - --entrypoints.http.address=:80
      - --entrypoints.http.forwardedHeaders.insecure=true
      - --entrypoints.https.address=:443
      - --entrypoints.https.forwardedHeaders.insecure=true
      - --serversTransport.insecureSkipVerify=true
      - --accesslog
      - --log
      - --api
    networks:
      - traefik-public
networks:
  traefik-public:
    external: true
```   

/opt/datastore/traefik/dynamic_conf klasörünü oluşturuyor ve içinde başlangıç için conf.yml adında bir dosyayı aşağıdaki içerikle  oluşturuyoruz. Bu klasör yoksa oluşturuyoruz.

```yaml
tls:
  certificates:
    - certFile: /tools/certs/cert.pem
      keyFile: /tools/certs/key.pem
      stores:
        - default
  stores:
    default:
      defaultCertificate:
        certFile: /tools/certs/cert.pem
        keyFile: /tools/certs/key.pem
```

Artık traefik stack deploy edilmeye hazır.

```console
dogan@pergen:~/certs$ docker stack deploy --compose-file traefik.yml
```

Servisin güncel durumunu;

```console
dogan@pergen:~/certs$ docker stack ps traefik --no-trunc
```
ile durumu kontrol edebiliriz.

Haydi artık mysql, mariadb ve phpmyadmin'i kuralım da ilk developer araç gereçleri kurulsun. compose file aşağıdaki gibi;

```yaml
version: "3.5"

services:
  mariadb:
    image: mariadb:latest
    ports:
      - 3306:3306
    restart: always
    volumes:
      - /opt/datastore/mysql/mariadb:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: <password>
    networks:
      - database

  mysql8:
    image: mysql:8.0
    ports:
      - 3307:3306
    restart: always
    volumes:
      - /opt/datastore/mysql/mysql8:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: <password>
    networks:
      - database

  phpmyadmin:
    image: linuxserver/phpmyadmin
    environment:
      PMA_HOSTS: mariadb,mysql8
      PMA_ARBITRARY: 1
    restart: always
    networks:
      - database
      - traefik-public
    deploy:
      labels:
        - "traefik.enable=true"
        - "traefik.http.routers.pma.entrypoints=http"
        - "traefik.http.routers.pma.rule=Host(`pma.localdomain`)"
        - "traefik.http.middlewares.pma-https-redirect.redirectscheme.scheme=https"
        - "traefik.http.routers.pma.middlewares=pma-https-redirect"
        - "traefik.http.routers.pma.service=pma"
        - "traefik.http.routers.pma-secure.entrypoints=https"
        - "traefik.http.routers.pma-secure.rule=Host(`pma.localdomain`)"
        - "traefik.http.routers.pma-secure.tls=true"
        - "traefik.http.routers.pma-secure.tls.certresolver=dcresolver"
        - "traefik.http.routers.pma-secure.tls.domains[0].main=pma.localdomain"
        - "traefik.http.routers.pma-secure.service=pma"
        - "traefik.http.services.pma.loadbalancer.server.port=80"
        - "traefik.docker.network=traefik-public"
        - "traefik.constraint-label=traefik-public"
      mode: replicated
      replicas: 1

networks:
  traefik-public:
    external: true
  database:
    external: true
```

Haydi mysql için bir de client tarafı araç yükleyelim. Service mesh içinde zaten çözülür durumda olan servise host'tan erişelim;

```console
dogan@pergen:~/ brew install --cask dbeaver-community
```

Şimdilik bu kadar yetsin. Bu işi bir video ile anlatmak da gerekli, yazarak bu kadar oluyor. Kolay gelsin.
