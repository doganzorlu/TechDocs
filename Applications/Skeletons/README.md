# Skeletons

Bu bölümde, kurulu sistemde CI/CD akışları için kullanılabilecek yöntem ve bazı platformlar için iskelet yapılar yer alıyor.

# Minikube Hazırlık
```console
minikube addons enable registry
```
Ardından registry nin insecure olarak minikube içindeki docker yapılandırmasına eklenmesini sağlayalım. Bunun için ~/.minikube/machines/<PROFILE_NAME>/config.json dosyasında insecure_registry anahtarını bulup buraya ekliyoruz.

komutu ile minikube özel registry eklentisi aktifleştirilir. Development ve iç test platformları için bu güvensiz registry kullanılabilir. Örnekler içindeki container ları oluşturmak, minikube registry sine push etmek ve yine sistemde bir deployment oluşturmak için gerekli olan işlemler her bir klasörde ayrı ayrı tanımlandı.