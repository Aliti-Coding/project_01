-- Theory

--1. In what order are the keywords of an SQL query executed?
-- when we execute a sql query it starts with FROM to target the table.
-- the order is: FROM -> WHERE -> GROUP BY -> HAVING -> ORDER BY -> SELECT

--2. What is a primary key?
--a primary key is a identificator to the table, and helps us connect tables.
--Pimary keys are essentials for DBMS.


--3. Is a foreign key reference between two tables necessary to perform a join between the tables? Why/Why not?
-- it is not necessary to have a foreign key reference to join between tables, but the data you join will not 
-- make any sence. The datatype has to be the same, but when joining between tables, it will be randomly joins. 
-- We usually want foreign key reference to keep the integrity of the data.


--4. What is the difference between a full join and a inner join?
-- if you do a full join between two tables you will join what is in left and right table 
-- even if their is no match. you will get for instance null values also.
-- if you do a inner join, you will only get the matches between two tables
-- you are joining.



--1.In the person schema you'll find all the different contact types. 
--Write a query that returns the ID and name of all different types of managers.
select c.contacttypeid, c."name" from person.contacttype c 

--2.Find the business entity ID and full names of all persons who are purchasing managers.
--Your query should return only two columns. Sort descending by the full name.
select p.businessentityid, concat(p.firstname,' ',p.lastname) as full_name from person.person p
join person.businessentitycontact b on p.businessentityid = b.personid  
join person.contacttype c on b.contacttypeid = c.contacttypeid 
where c."name"  like 'Purchasing Manager'
order by full_name desc;




--3.Write a query that returns three columns: contact type ID, contact type name, and number of contacts. 
--Return only those contact types for which there are more than 20 contacts.
select c.contacttypeid, c."name", count(b.personid)   from person.person p 
join person.businessentitycontact b on b.personid  = p.businessentityid 
join person.contacttype c on c.contacttypeid = b.contacttypeid 
group by c.contacttypeid, c."name"
having count(b.personid) > 20;



--4.In the production schema you'll find all the products produced by AdventureWorks. 
--Write a query that returns the product IDs of the products that are of subcategory cranksets.
select p.productid from production.product p
join production.productsubcategory p2 on p.productsubcategoryid = p2.productsubcategoryid
where p2."name" like 'Cranksets';

--5.In the person schema you'll find the addresses of customers. 
--Write a query that returns the address ID of all addresses in London.
select a.addressid, a.city  from person.address a 
where a.city like 'London';


--6 In the sales schema you'll find all orders processed by AdventureWorks. 
--In the table salesorderheader you'll find sales headers, and in salesorderdetail you'll find the individual order lines for each header. 
--Write a query that answers how many crankset type products have been ordered to customers in London. 
--Use the queries from the last two problems to achieve this. Hint: the answer is 39.
select sum(s2.orderqty) from sales.salesorderheader s 
join sales.salesorderdetail s2 on s.salesorderid = s2.salesorderid 
join production.product p on s2.productid = p.productid 
join production.productsubcategory p2 on p.productsubcategoryid = p2.productsubcategoryid 
join person.address a on s.billtoaddressid = a.addressid 
where a.city = 'London' and p2."name" = 'Cranksets'

select sum(s2.orderqty) from sales.salesorderheader s 
join sales.salesorderdetail s2 on s.salesorderid = s2.salesorderid 
where s.billtoaddressid in 
(select a.addressid from person.address a 
where a.city like 'London') and 
s2.productid in (select p.productid from production.product p
join production.productsubcategory p2 on p.productsubcategoryid = p2.productsubcategoryid
where p2."name" like 'Cranksets')

-- CTE query
with london_adress as (select a.addressid from person.address a 
where a.city like 'London'),
crankset as (select p.productid from production.product p
join production.productsubcategory p2 on p.productsubcategoryid = p2.productsubcategoryid
where p2."name" like 'Cranksets')
select sum(s2.orderqty) from sales.salesorderheader s 
join sales.salesorderdetail s2 on s.salesorderid = s2.salesorderid 
where s.billtoaddressid  in (select * from london_adress)
and 
s2.productid in (select * from crankset);







