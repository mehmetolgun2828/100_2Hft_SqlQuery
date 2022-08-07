

-- AGGREGATE FUNCTION (toplam fonksiyonları, gruplamalı fonksiyonlar)

--COUNT(*,kolonAd) =>  belirtilen satırdaki eleman sayısını sayar. SELECT komutundan sonra kullanılır.

-- ProductID kolonunda kaç kayıt vardır?

select COUNT(ProductID)
from Products

select * from Employees

select COUNT(EmployeeID)
from Employees

select COUNT(*)
from Employees

select COUNT(Region)
from Employees

-- NOT => COUNT , boş geçilebilen alanları saymaz bu yüzden NOT NULL  olduğunu bildiğimz kolonlarda saydırm işlemi yapmak kesinlikle daha doğru bir sonuç verir.

--çalışanlarımın kaç farklı şehirde yaşadığı bilgisini bulunuz.

select  distinct City from Employees

select  COUNT(distinct City) from Employees

-- select 5+5 as toplam,67-89 as cıkarma


--  SUM(kolonAd) => Verilen kolondaki değerleri toplar. Bu yüzden sadece sayısal kolonlarda iş yapar.

--Toplam stok miktarımı bulunuz.

select SUM(UnitsInStock) from Products

-- çalışanlarımın yaşları toplamını bulunuz.

select SUM(YEAR(GETDATE())-YEAR(BirthDate)) from Employees


--AVG (kolonAd) => Verilen kolondaki sayısal degerlerin ortalama degerini bulur.

-- çalışanlarımın ortalam yaşını bulunuz

select AVG(YEAR(GETDATE())-YEAR(BirthDate)) from Employees



------------------------------------------------------------


-- GROUP BY  => Sorgu sonucunu verdiğimiz kolon bazında gruplayarak bize gruplu bir sonuç döner.
-- ÇOK ÖNEMLİ NOT => GROUP BY kullanıyorsak SELECT ifadesinde listelenen sütunlar group by ifadesi tarafından kullanılmalı yani => groupby ve select beraber çalışmlaı. Çünkü grupladığımız tarfa aslınad bize tek bir veri döner buna dikkat etmeliyiz ve bu durumu büyük oranda AGGREGATE func ile göğüsleyebilirz.


-- çalışanlarımı ülkelerine göre gruplayınız(hangi ülkeden kaç kiiş gelmekte gösteriniz)

select Country,COUNT(*) as [Kişi sayısı]
from Employees
group by Country


-- birim fiyatı 35 dolardan az olan ürünleri kategorilerine göre gruplayınız.(hangi kategoride kaç eleman var)

select CategoryID,COUNT(*) as ToplamElemanSayısı
from Products
where UnitPrice<35
group by CategoryID


-- her bir siparişteki toplam ürün sayısını bulunuz.

select * from  [Order Details]

select OrderID,SUM(Quantity) as ToplamSiparisAdedi
from [Order Details]
group by OrderID

-- her bir siparişimi toplam tutarına göre çoktan aza sıralayınız.

select OrderID,sum(UnitPrice*Quantity*(1-Discount)) as ToplamTutar
from [Order Details]
group by OrderID
order by  ToplamTutar desc


----- HAVING => Sorgu sonucu gelen kümelerde Aggregate Func. bağlı olacak şekilde bir filtreleme yapılacaksa WHERE değil HAVING kullanılır. Eğer Agreeegate func. yok ise WHERE ile HVING aynı işi yapacaktır.

-- Satır satır eleme yapılacaksa WHERE de koşul konu fakat kümeleme işlemleri sonucnda koşul varsa bu HAVING ile yapılır. İkisi beraberde tabiki kullanılabilinir.


/*
				MANTIKSAL İŞLEM SIRASI		    	AŞAMA
							5                       SELECT
							1						FROM            hangi tablo
							2						WHERE           satır eleme
							3						GROUP BY        kümeleme/gruplama
							4						HAVING          grup üstünde işlem
							6						ORDER BY        sıralama

*/

--- Toplam tutarı 2500 ile 3500 arasında olan siparişlerimi çoktan aza sıralayınız.

select OrderID,sum(UnitPrice*Quantity*(1-Discount)) as Tutar
from [Order Details]
group by OrderID
having sum(UnitPrice*Quantity*(1-Discount)) between 2500 and 3500
order by Tutar desc


--Her bir siparişteki toplam ürün adedi 200 den az olanları getirirniz.

select OrderID,SUM(Quantity) as ToplamSiparisAdedi
from [Order Details]
group by OrderID
having SUM(Quantity)<200
order by ToplamSiparisAdedi desc


--------------  SUB QUERY (içiçe sorgu)

---fiyatı ortalama birim fiyatın üzerinde olan ürünlerimi getiirniz.

select * from Products where UnitPrice>(select  AVG(UnitPrice) from Products)


-- ürünler tablosunda satışını yaptığım ürünleri listeleyiniz.

select * from Products where ProductID in (select ProductID from [Order Details])


select CompanyName from Suppliers where SupplierID in (select SupplierID from Products where ProductID in (select ProductID from [Order Details]))

--Romero y tomillo firmasına göndrdiğim ürünlerin siparişini hangi çalışanlarım onaylamıştır.

select FirstName+SPACE(3)+LastName from Employees where EmployeeID in (select EmployeeID from Orders where CustomerID in (select CustomerID from Customers where CompanyName='Romero y tomillo'))

--Kuzey bölgesinden sorumlu çalışanlarımın ad soyad title bilgsini getiriniz.


select FirstName+SPACE(6)+LastName from Employees where EmployeeID in (select EmployeeID from EmployeeTerritories where TerritoryID in (select TerritoryID from Territories where RegionID=3))


------------------------------------------------

/*
 JOIN farklı tabloları üzerinde bulunan ortak anahtarlar sayesinde birleştirip sanal tek bir tablo yaratmak işlemidir, kalıcı değildir. Sorgu sırasında kullanılır.

	1 ) (INNER) JOIN => birleşen iki tablonun kesişiminde yer alan , boş verinin olmadığı satırlar oluşur.

	2 )  (OUTER ) JOIN 

		* LEFT (OUTER) JOIN 
		*RIGHT (OUTER) JOIN

		JOIN , sağ tarafında kalna tablo HEP RIGHT TABLE, solunda kalan tablo ise LEFT TABLE . LEFT joın yapıldığında soldaki tablonun tüm verileri diğer tablonun ise ilişkili verileri gelir . Aynı şekilde RIGHT join yapıldığında ise sağda kalan tablonun tüm verileri diğer tablonun ise ilişkli verileri gelir.

*/

-- ürünlerimin productName ve CategoryName bilgiisni getiiriniz.

select ProductID,ProductName,CategoryName,[Description]
from Products join Categories on Products.CategoryID=Categories.CategoryID


---

select CategoryName,ProductName,CompanyName,c.CategoryID 
from Categories c join Products p on p.CategoryID=c.CategoryID
                  join Suppliers s on s.SupplierID=p.SupplierID


-----categoryNamelerine göre ürünlerin toplam stok miktarını bulunuz.

select CategoryName,SUM(UnitsInStock) as toplamStok
from Products p join Categories c on c.CategoryID=p.CategoryID
group by CategoryName


-- her bir çalışanın ne kadarlık satış yaptığını bulunuz.

select FirstName+space(3)+LastName as TamAd,sum(UnitPrice*Quantity*(1-Discount)) as SatısTutarı,e.EmployeeID
from Employees e join Orders o on o.EmployeeID=e.EmployeeID
                 join [Order Details] od on od.OrderID=o.OrderID
group by FirstName+space(3)+LastName,e.EmployeeID
