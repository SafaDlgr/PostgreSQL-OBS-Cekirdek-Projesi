## 📝 OBS Çekirdek Tasarımı

Bu veritabanı şeması, **3. Normal Form (3NF)** kurallarına uygun olarak tasarlanmıştır. Amaç, veri bütünlüğünü en üst düzeyde sağlamaktır.

### Temel Tasarım Kararları

* **Veri Bütünlüğü:** Tablolar arası ilişkilerde **`FOREIGN KEY`** ve **`ON DELETE RESTRICT`** kuralı kullanılarak veri kaybı önlenmiştir.
* **Benzersizlik:** Öğrenci numarası ve ders kodu gibi ana alanlar **`UNIQUE`** olarak belirlenmiştir.
* **Kayıt Kontrolü:** `ogrenci_dersleri` tablosunda **Bileşik Anahtar** (`ogrenci_id`, `ders_id`, `yil`, `donem`) kullanılarak, aynı kaydın tekrarlanması engellenmiştir.

### İş Mantığı ve PL/pgSQL

* **PL/pgSQL Fonksiyonları** (`fn_harf_notu_hesapla`) ile not hesaplaması otomatikleştirilmiştir.
* **Stored Procedure'ler** (`sp_ogrenci_derse_kayit`, `sp_not_girisi`) ile kurallar kontrol edilmiş ve **`RAISE EXCEPTION`** ile sistem seviyesinde hata döndürülmüştür.
* **Görünümler (Views)** ile Transkript raporlaması basitleştirilmiştir.