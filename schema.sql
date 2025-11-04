create table bolumler (
    bolum_id serial primary key,
    bolum_adi varchar(100) not null unique
);

create table ogretmenler(
	ogretmen_id serial primary key,
	ad varchar(50) not null,
	soyad varchar(50) not null,
	bolum_id int not null,
	constraint fk_bolum
		foreign key (bolum_id)
		references bolumler (bolum_id)
		on delete restrict
);

create table dersler(
	ders_id serial primary key,
	ders_kodu varchar(10) not null unique,
	ders_adi varchar(100) not null,
	kredi numeric(2,1) not null,
	ogretmen_id int not null, 	
	constraint fk_ogretmen
		foreign key (ogretmen_id)
		references ogretmenler (ogretmen_id)
		on delete restrict
);

create table ogrenciler (
	ogrenci_id serial primary key, 
	ogrenci_no varchar(20) not null unique, 
	ad varchar(50) not null, 
	soyad varchar(50) not null, 
	bolum_id int not null,
	constraint fk_ogr_bolum
		foreign key (bolum_id)
		references bolumler (bolum_id)
		on delete restrict
);


create table ogrenci_dersleri (
    kayit_id serial, 
    ogrenci_id int not null,
    ders_id int not null, 
    vize_notu smallint check (vize_notu between 0 and 100), 
    final_notu smallint check (final_notu between 0 and 100), 
    yil smallint not null, 
    donem varchar(20) not null,
    
    primary key (ogrenci_id, ders_id, yil, donem), 
    
    constraint fk_ogr_ders_ogrenci
        foreign key (ogrenci_id)
        references ogrenciler (ogrenci_id)
        on delete restrict,
        
    constraint fk_ogr_ders_ders
        foreign key (ders_id)
        references dersler (ders_id)
        on delete restrict,
  
    constraint uq_kayit_id unique (kayit_id)
);



alter table ogrenci_dersleri
alter column yil TYPE varchar(4);

truncate table ogrenci_dersleri

















