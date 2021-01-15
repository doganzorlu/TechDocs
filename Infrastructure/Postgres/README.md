# Postgres

Bu bölümde postgres veritabanı ve pgadmin4 yöneticisi postgres namespace içinde oluşturuluyor. Bir not, eğer bir deployment kaldırılıp tekrar yüklenirse PersistentVolume temizlenmeli. Bunun için;

```console
- name: pv-recycler
    image: "k8s.gcr.io/busybox"
    command: ["/bin/sh", "-c", "test -e /scrub && rm -rf /scrub/..?* /scrub/.[!.]* /scrub/*  && test -z \"$(ls -A /scrub)\" || exit 1"]
    volumeMounts:
    - name: postgredb
    mountPath: /scrub
```
gibi bir konteynera dizini bağlayıp silmeniz gerekecektir.
