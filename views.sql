
create or replace view view_bolum_ders_listesi as
select
    b.bolum_adi,
    d.ders_kodu,
    d.ders_adi,
    d.kredi,
    t.ad || ' ' || t.soyad as ogretmen_ad_soyad
from
    bolumler b
join
    ogretmenler t on b.bolum_id = t.bolum_id 
join
    dersler d on t.ogretmen_id = d.ogretmen_id 
order by
    b.bolum_adi, d.ders_kodu;

--------------------------------------------------------------

create or replace view view_transkript as
select
    o.ogrenci_no,
    o.ad || ' ' || o.soyad as ogrenci_ad_soyad,
    d.ders_kodu,
    d.ders_adi,
    d.kredi,
    od.yil,
    od.donem,
    

    coalesce(od.vize_notu::text, 'G') as vize_notu,
    coalesce(od.final_notu::text, 'G') as final_notu,
    
    case 
  
        when od.vize_notu is null or od.final_notu is null then'G'
        else fn_harf_notu_hesapla(od.vize_notu, od.final_notu)
    end as harf_notu,

    case 
        when od.vize_notu is null or od.final_notu is null then 'Kaldı'
        else fn_ders_gecme_durumu(od.vize_notu, od.final_notu)
    end as gecme_durumu
    
from
    ogrenciler o
join
    ogrenci_dersleri od on o.ogrenci_id = od.ogrenci_id
join
    dersler d ON od.ders_id = d.ders_id
order by
    o.ogrenci_no, od.yil desc, od.donem desc;


