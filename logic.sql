
create or replace function fn_harf_notu_hesapla(
    p_vize_notu numeric,
    p_final_notu numeric
)
returns varchar as
$$
declare
    v_ortalama numeric(5, 2);
    v_harf_notu varchar(2);
begin
    if p_vize_notu is null or p_final_notu is null then
        return 'FF';
    end if;

    v_ortalama := (p_vize_notu * 0.40) + (p_final_notu * 0.60);

    case
        when v_ortalama >= 90 then v_harf_notu := 'AA';
        when v_ortalama >= 85 then v_harf_notu := 'BA';
        when v_ortalama >= 80 then v_harf_notu := 'BB';
        when v_ortalama >= 75 then v_harf_notu := 'CB';
        when v_ortalama >= 70 then v_harf_notu := 'CC';
        when v_ortalama >= 60 then v_harf_notu := 'DC';
        when v_ortalama >= 50 then v_harf_notu := 'DD';
        when v_ortalama >= 40 then v_harf_notu := 'FD';
        else v_harf_notu := 'FF';
    end case;

    return v_harf_notu;
end;
$$ language plpgsql;

--------------------------------------------------------------------

create or replace function fn_ders_gecme_durumu(
    p_vize_notu NUMERIC,
    p_final_notu NUMERIC
)
returns VARCHAR(6) as
$$
declare
    v_ortalama NUMERIC(5, 2);
begin
   
    if p_vize_notu is null or p_final_notu is null then
        return 'Kaldı';
    end if;

    v_ortalama := (p_vize_notu * 0.40) + (p_final_notu * 0.60);

    if v_ortalama >= 50 and p_final_notu >= 45 then
        return 'Geçti';
    else
        return 'Kaldı';
    end if;
end;
$$ language plpgsql;

-------------------------------------------------------------------------------

create or replace function fn_ogretmen_ders_sayisi(p_ogretmen_id int)
returns int as
$$
declare
    v_ders_sayisi INT;
begin
    select count(ders_id) into v_ders_sayisi
    from dersler
    where ogretmen_id = p_ogretmen_id;
    
    returns v_ders_sayisi;
end;
$$ language plpgsql;

-----------------------------------------------------------------------------------

create or replace procedure sp_ogrenci_derse_kayit(
    p_ogrenci_id int,
    p_ders_id int,
    p_yil varchar,
    p_donem varchar
)
language plpgsql
as $$
declare
    v_kayit_sayisi int;
begin
    select count(*)
    into v_kayit_sayisi
    from ogrenci_dersleri
    where ogrenci_id = p_ogrenci_id
      and ders_id = p_ders_id
      and yil = p_yil
      and donem = p_donem;

    if v_kayit_sayisi > 0 then
        
        raise exception 'KAYIT_HATASI: Öğrenci ID % bu dersi (ID %) % % döneminde zaten almaktadır.',
                        p_ogrenci_id, p_ders_id, p_yil, p_donem;
    end if;

 
    insert into ogrenci_dersleri (ogrenci_id, ders_id, yil, donem)
    values (p_ogrenci_id, p_ders_id, p_yil, p_donem);
    
    -- Başarılı Kayıt Mesajı
    raise notice 'Öğrenci ID % derse (ID %) başarılı bir şekilde kaydedildi.', p_ogrenci_id, p_ders_id;

end;
$$;

----------------------------------------------------------------------------------------------------------------------

create or replace procedure sp_not_girisi(
    p_kayit_id int,
    p_vize int, 
    p_final int  
)
language plpgsql
as $$
begin
    if p_vize is not null and (p_vize < 0 or p_vize > 100) then
        raise exception 'NOT_HATASI: Vize notu %s, 0 ile 100 arasında olmalıdır.', p_vize;
    end if;

    if p_final is not null and (p_final < 0 or p_final > 100) then
        raise exception 'NOT_HATASI: Final notu %s, 0 ile 100 arasında olmalıdır.', p_final;
    end if;

    update ogrenci_dersleri
    set vize_notu = p_vize,
        final_notu = p_final
    where kayit_id = p_kayit_id;

    if not found then
        raise exception 'KAYIT_BULUNAMADI: Kayıt ID %s ile eşleşen bir öğrenci ders kaydı bulunamadı.', p_kayit_id;
    end if;
    
    raise notice 'Kayıt ID %s için notlar başarıyla güncellendi.', p_kayit_id;

end;
$$;










































































