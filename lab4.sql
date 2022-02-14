create database ecommerce;
use ecommerce;
show databases;
create table supplier (SUPP_ID int primary key,SUPP_NAME varchar(50),SUPP_CITY varchar(50),SUPP_PHONE varchar(10));
create table customer (CUS_ID int primary key,CUS_NAME varchar(50),CUS_PHONE varchar(10),CUS_CITY varchar(25),CUS_GENDER varchar(1));
create table category(CAT_ID int primary key,CAT_NAME varchar(50));
create table product (PRO_ID int primary key,PRO_NAME varchar(50),PRO_DESC varchar(50),CAT_ID int,foreign key(CAT_ID) references category(CAT_ID));
create table productDetails(PROD_ID int primary key,PRO_ID int ,SUPP_ID int ,PRICE float,foreign key (PRO_ID) references product(PRO_ID),foreign key (SUPP_ID)references supplier (SUPP_ID));
create table orders(ORD_ID int primary key,ORD_AMOUNT float ,ORD_DATE date,CUS_ID int,PROD_ID int,foreign key (PROD_ID) references  productDetails(PROD_ID),foreign key (CUS_ID) references customer (CUS_ID ));
create table rating (RAT_ID int primary key,CUS_ID int,SUPP_ID int ,RAT_RATSTARS int, foreign key(CUS_ID) references  customer (CUS_ID),foreign key(SUPP_ID) references  supplier (SUPP_ID));
show tables;
desc supplier;
desc customer;
desc category;
desc product;
desc productDetails;
desc orders;
desc rating;
insert into supplier values(1,"Rajesh Retails","Delhi","1234567890");
insert into supplier values(2,	'Appario Ltd.',	'Mumbai','2589631470');
insert into supplier values(3,'Knome products','Banglore',	'9785462315');
insert into supplier values(4,'Bansal Retails','Kochi','8975463285');
insert into supplier values(5,'Mittal Ltd.'	,'Lucknow','7898456532');
select * from supplier;
insert into customer values(1,'AAKASH','9999999999','DELHI','M');
insert into customer values(2,'AMAN','9785463215','NOIDA','M');
insert into customer values(3,'NEHA','9999999999','	MUMBAI','F');
insert into customer values(4,'MEGHA','9994562399','KOLKATA','F');
insert into customer values(5,'PULKIT','7895999999','LUCKNOW','M');

select * from customer;
insert into category values(1,'BOOKS');
insert into category values(2,'GAMES');
insert into category values(3,'GROCERIES');
insert into category values(4,'ELECTRONICS');
insert into category values(5,'CLOTHES');
select * from category;
insert into product values(1,'GTA V','DFJDJFDJFDJFDJFJF',2);
insert into product values(2,'TSHIRT','DFDFJDFJDKFD',5);
insert into product values(3,'ROG LAPTOP','DFNTTNTNTERND',4);
insert into product values(4,'OATS','REURENTBTOTH',3);
insert into product values(5,'HARRY POTTER','NBEMCTHTJTH',1);
select * from product;
insert into productDetails values(1,1,2,1500);
insert into productDetails values(2,3,5,30000);
insert into productDetails values(3,5,1,3000);
insert into productDetails values(4,2,3,2500);
insert into productDetails values(5,4,1,1000);
select * from productDetails;
insert into orders values(20,1500,'2021-10-12',3,5);
insert into orders values(25,30500,'2021-09-16',5,2);
insert into orders values(26,2000,'2021-10-05',1,1);
insert into orders values(30,3500,'2021-08-16',4,3);
insert into orders values(50,2000,'2021-10-06',2,1);
select * from orders;
insert into rating values(1,2,2	,4);
insert into rating values(2,3,4	,3);
insert into rating values(3,5,1	,5);
insert into rating values(4	,1,3,2);
insert into rating values(5,4,5,4);
select * from rating;
/* 10)	Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.*/
select c.cus_gender,count(*) as count from customer c inner join orders o on c.cus_id=o.cus_id where o.ORD_AMOUNT>=3000 group by (c.cus_gender);
/*11)	Display all the orders along with the product name ordered by a customer having Customer_Id=2.*/
desc product;
desc orders;
select o.*,p.pro_name from orders o,product p,productdetails pd where o.cus_id=2 and pd.pro_id=p.pro_id and o.prod_id=pd.prod_id;
/*12)	Display the Supplier details who can supply more than one product*/
select s.* from supplier s,productdetails pd;

select s.* from supplier s,productdetails pd where s.supp_id=pd.supp_id;
select s.* from supplier s,productdetails pd where s.supp_id in(select pd.supp_id from productdetails pd group by pd.supp_id having count(pd.pro_id)>1)group  by s.supp_id;
/*13)	Find the category of the product whose order amount is minimum.*/
select c.* from category c,product p,productdetails pd,orders o where c.cat_id=p.cat_id and pd.prod_id=o.prod_id having min(o.ord_amount);
/*14)	Display the Id and Name of the Product ordered after “2021-10-05”.*/
select p.pro_id,p.pro_name from product p,productdetails pd,orders o where pd.prod_id=o.prod_id and pd.pro_id=p.pro_id and o.ord_date>"2021-10-05";
/*15)	Display customer name and gender whose names start or end with character 'A'.*/
select cus_name,cus_gender from customer where cus_name like "A%" or cus_name like "%A";
/*16)	Create a stored procedure to display the Rating for a Supplier 
if any along with the Verdict on that rating if any like if rating >4 
then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier 
should not be considered”.*/


select supplier.supp_id,supplier.supp_name,rating.rat_ratstars,
CASE 
   WHEN rating.rat_ratstars>4 THEN 'Genuine Supplier'
   WHEN rating.rat_ratstars>2 THEN 'Average Supplier'
   ELSE 'Supplier should not be considered'
END AS Verdict from rating inner join supplier on supplier.supp_id=rating.supp_id
