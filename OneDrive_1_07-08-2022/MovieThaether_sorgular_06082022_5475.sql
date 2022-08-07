
--create database Filmler


--CREATE table Categories
--(
-- CategoryId int identity(1,1) primary key,
-- CategoryName nvarchar(60) not null
--)

--create table Seans
--(
--Seans int identity(1,1) primary key,
--SeansSaat time not null
--)

--create table Weeks
--(
--WeekId int identity(1,1) primary key,
--WeekStart datetime  not null,
--WeekEnd datetime not null
--)

--create table Saloon
--(
--SalonId int identity(1,1) primary key,
--SalonAd nvarchar(40) not null,
--SalonKapasitesi int not null
--)


--create table Movies (
--MovieId int identity(1,1) primary key,
--MovieAd nvarchar(50) not null,
--MovieAcıklaması nvarchar(90) not null,
--MovieSure int not null

--)

--create table CategoryMovie
--(
--CategoryID int ,
--MovieID int,
--primary key (CategoryID,MovieID),
--constraint fk_category foreign key(CategoryID)  references Categories(CategoryId),
--constraint fk_movies foreign key(MovieID)  references Movies(MovieId)

--)


--create table MovieInfo
--(
--ID int identity(1,1) primary key,
--SeansId int,
--SalonID int,
--WeekId int,
--MovieId int,
--constraint fk_seans foreign key(SeansId)  references Seans(Seans),
--constraint fk_salon foreign key(SalonID)  references Saloon(SalonId),
--constraint fk_week foreign key(WeekId)  references Weeks(WeekId),
--constraint fk_moviess foreign key(MovieId)  references Movies(MovieId)
--)


------ TABLOLARI SORGULAMAK

--select kolonAd1,kolonad2,.... FROM tabloAd
--select *  from tabloAd (o tablonun tüm kolonlarını getirir)

select * from Categories

select CategoryID,CategoryName  from Categories


-- Kolonların isimlendirilmesi

select Title as Unvan,FirstName Ad, Soyad=LastName from Employees

select Title ,FirstName , LastName from Employees


-- Kolonların tek bir hücrede birleştirilmesi


select  Title+'  '+FirstName+'  '+LastName as [Tam Ad] from Employees

select  Title+SPACE(4)+FirstName+SPACE(4)+LastName as [Tam Ad] from Employees


--Çalışanların şehirlerini getirniz.
select City from Employees

select distinct City from Employees


--city bilgisi LOndon olanları getiriniz.
  
  select * from Employees where City='London'
  select City,FirstName,LastName from Employees where City='London'


-- Çalışanlarımdan Andrew Fuller rapor verenleri getiirniz.

select ReportsTo,FirstName,LastName from Employees where ReportsTo=2

-- Doğum yılı 1960 olan çalışanlarmı listeleyiniz.

select * from Employees where year(BirthDate)=1960

-- Doğum yılı 1950 ile 1960 arasında olanlar getiriniz.
-- NOT => and (ve)  bağlanan ifadelerin ikisi de DOĞRU olmalı/sağlanmalı.
--     => or  (veya/yada) bağlanan iki ifadeden birinin DOĞRU olması şartı sağlar.

select * from Employees where YEAR(BirthDate)<=1960 and YEAR(BirthDate)>=1950

-- Amerikada yaşayan Kadın çalışanlarımın ad, soyad,ülke bilgiisni getiirniz.
select FirstName,LastName,Country,TitleOfCourtesy from Employees 
where Country='USA' and (TitleOfCourtesy='Ms.' or TitleOfCourtesy='Mrs.')

-- NULL VERİLERİ SORGULAMAK

select Region,FirstName from Employees where  Region is null --  null olanlar gelsin

select Region,FirstName
from Employees
where  Region is not  null -- null olmayanalr gelsin


----- SIRALAMA İŞLEMLERİ - ORDER BY 

--ASC(ASCENDİNG) yada DESC(DESCENDING) olarak sıralama yapılabiliriz.
-- ASC => azdan çoka sıralar (sayısal degerlerde), a -> z HARFİNE GÖRE SIRAALAR (metinsel ifadede),geçmişten -> geleceğe (yakın tarihe) göre sıralar (tarihsel ifadelerde.)

-- NOT => AKSİ SÖYLENMEDİĞİ SÜRECE ASC olarak sıralandığı kabu edilir.

-- ÜRÜNLERİMİ ıd bilgilerine göre çoktan aza sıralayınız.

select * 
from Products
where ProductID<=8 and ProductID>=5
order by ProductID desc


select * 
from Products
where ProductID<=8 and ProductID>=5
order by ProductName 


select Title,LastName,FirstName,HireDate,TitleOfCourtesy 
from Employees
order by 2,4 desc

-- NOT => order by ifaedesindeki sayısal kolonlar aslında SELECT ifadesşinde seçilen kolon adlarının 1den başlayarak sıralmasıdır. YUlarıdaki örnekte order by da LastName kolonuna göre ASC ve aynı veriyle karşılaşıldğında 4. sıradaki HİREdATE KOLONUNA GÖRE desc OLARAK SIRALAMA yapılacaktır demektir.


--- çalışanlarımı yaşlarına göre çoktan aza sıralayınız.

select DATEDIFF(YEAR,BirthDate,GETDATE()) as yas
from Employees
order by yas desc

select FirstName,LastName,YEAR(GETDATE())-YEAR(BirthDate) as Yas
from Employees
order by Yas desc


--SELECT FirstName, LastName,BirthDate from Employees ORDER BY year(BirthDate) 


---alfabetik olarak çalışanlarımdan robert ve janet arasında kalanları isimlerine göre çoktan aza sıralayınız.

select FirstName, LastName
 From Employees
 where FirstName >= 'Janet' and FirstName <= 'Robert'
 order by 1  desc

 select FirstName, LastName 
 From Employees
 where FirstName between 'Janet' and 'Robert'
 order by 1  desc

 --not => BETWEEN de sınırlar dahil kabul edilir.


 -- Ünvanı DR. yada Mr. olan çalışanlarımı getiirniz.

 select *
 from Employees
 where TitleOfCourtesy='Dr.' or  TitleOfCourtesy='Mr.'


select *
from Employees
where TitleOfCourtesy in ('Dr.','Mr.')


-- En pahalı 3 ürünümü getiriniz.

select top 3*  -- tüm kolonlarını getirir.
from Products
order by UnitPrice desc

select top 3 UnitPrice,ProductName,ProductID  -- seçilen kolonlarını getirir.
from Products
order by UnitPrice desc

--benimle beraber çalışan en eski 5 çalışanımı getiriniz.

select top 5 FirstName,LastName,YEAR(GETDATE())- YEAR(HireDate) as KacYıldırCalısıyor 
from Employees
order by HireDate 

-- LIKE  KULLANMI

-- ADININ BAŞ HARFİ A OLANLAR
SELECT * FROM Employees where FirstName like 'A%'

-- ADIIN İÇİNDE A HARFİ OLANLAR

SELECT * FROM Employees where FirstName like '%A%'

-- ADININ SON HARFİ A OLANLAR
SELECT * FROM Employees where FirstName like '%A'