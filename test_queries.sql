-- Her bölümdeki toplam öğrenci sayısını hesaplama
select
    b.bolum_adi,
    count(o.ogrenci_id) as toplam_ogrenci_sayisi
from
    ogrenciler o
join
    bolumler b on o.bolum_id = b.bolum_id
group by
    b.bolum_adi
order by
    toplam_ogrenci_sayisi desc;

--------------------------------------------------------------------------------------

-- Her dersin ağırlıklı not ortalamasını hesaplama (Vize %40, Final %60)
select
    d.ders_kodu,
    d.ders_adi,
    round(
        avg(od.vize_notu * 0.40 + od.final_notu * 0.60),
        2
    ) as ders_ortalama
from
    ogrenci_dersleri od
join
    dersler d on od.ders_id = d.ders_id
where
    od.vize_notu is not null and od.final_notu is not null
group by
    d.ders_kodu, d.ders_adi
order by
	ders_ortalama desc;

----------------------------------------------------------------------------

-- Öğrenci adı ve kayıtlı olduğu bölüm adını getirme
select
    o.ogrenci_no,
    o.ad || ' ' || o.soyad as ogrenci_ad_soyad,
    b.bolum_adi
from
    ogrenciler o
join
    bolumler b ON o.bolum_id = b.bolum_id
order by
    b.bolum_adi, o.ad;

-----------------------------------------------------------------------------

-- Bir öğrencinin aldığı tüm dersleri, kredilerini ve notlarını listeleme
select
    o.ogrenci_no,
    o.ad || ' ' || o.soyad AS ogrenci_ad_soyad,
    d.ders_kodu,
    d.ders_adi,
    d.kredi,
    coalesce(od.vize_notu::text, 'G') as vize_notu,
    coalesce(od.final_notu::text, 'G') as final_notu,
    od.yil,
    od.donem
from
    ogrenciler o
join
    ogrenci_dersleri od on o.ogrenci_id = od.ogrenci_id
join
    dersler d on od.ders_id = d.ders_id
where
    o.ogrenci_no = '101001' 
order by
    od.yil desc, od.donem;

-------------------------------------------------------------------

-- Her dersin adını ve o dersi veren öğretmenin adını listeleme
select
    d.ders_kodu,
    d.ders_adi,
    t.ad || ' ' || t.soyad as ogretmen_ad_soyad,
    b.bolum_adi as ogretmen_bolumu
from
    dersler d
join
    ogretmenler t on d.ogretmen_id = t.ogretmen_id
join
    bolumler b on t.bolum_id = b.bolum_id
order by
    d.ders_kodu;

---------------------------------------------------------------------

-- TEST: fn_harf_notu_hesapla

select fn_harf_notu_hesapla(90, 95) as Sonuç;
select fn_harf_notu_hesapla(40, 40) as Sonuç;
select fn_harf_notu_hesapla(null, 70) as Sonuç; -- NULL durumu

----------------------------------------------------------------------

-- TEST: fn_ders_gecme_durumu

-- Test 1: Geçti (Ortalama 50+, Final 45+)
select fn_ders_gecme_durumu(60, 70) as Sonuç;

-- Test 2: Kaldı (Ortalama 50+, Final NOT 45-)
select fn_ders_gecme_durumu(80, 40) as Sonuç;

-- Test 3: Kaldı (Final 45+, Ortalama NOT 50+)
select fn_ders_gecme_durumu(30, 60) as Sonuç;

-- Test 4: NULL durumu
select fn_ders_gecme_durumu(55, NULL) as Sonuç;

--------------------------------------------------------------------------------

-- TEST: fn_ogretmen_ders_sayisi

select fn_ogretmen_ders_sayisi(2) as Ogretmen_1_Ders_Sayisi;











    