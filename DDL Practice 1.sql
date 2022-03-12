-- Class 3 DDL 
-- creation of table into data base. Below are the name of column which has been created
-- In blue color, data type is mentioned. 
Create table OrderDetails(
OrderID int,
ItemName varchar(500),
OrderDate Date,
OrderTime Time,
Shipment_status Text,
OrderAvailability Binary,
[Priority] int Default 1);

-- To insert values into the above table by using (Insert into and Values)
-- against insert into - write column name and against values - write the values to be inserted
-- all the values should be seperated by (,) and it will change the order based on the column order

Insert into OrderDetails(OrderID,ItemName,OrderDate,OrderTime,Shipment_status,OrderAvailability)
values
(123, 'abcd', '2021-05-01', '11:30:36', 'in progress', 0),
(124, 'xyz', '2021-05-02', '11:35:36', 'Not started', 1),
(125, 'abcd', '2021-05-03', '11:40:36', 'On hold', 1)

select * from OrderDetails

-- if you want to add some data from one table to another, user (insert into select) statements 

create table OrderDetails2(
OrderID int,
ItemName varchar(500),
OrderDate Date,
OrderTime Time,
Shipment_status Text,
OrderAvailability Binary,
[Priority] int Default 1);

Insert into OrderDetails2(OrderID,ItemName,OrderDate,OrderTime,Shipment_status,OrderAvailability)
values
(001, 'Shorts', '2021-05-10', '10:30:36', 'Dispatched', 0),
(002, 'Jeans', '2021-05-11', '09:35:36', 'Not started', 1);



Insert into OrderDetails2(OrderID,ItemName,OrderDate,OrderTime,Shipment_status,OrderAvailability) -- this is the table from where you want the data 
select OrderID,ItemName,OrderDate,OrderTime,Shipment_status,OrderAvailability
from OrderDetails; -- this is the table in which you want to add the data 

select * from OrderDetails2;

-- Using (update) statement to modify the records 
update OrderDetails 
set ItemName = 'Paijamas', Shipment_status = 'Cancelled'
where OrderID = 125;

select * from OrderDetails

-- Use of (ALTER TABLE) - to change column, drop column & modify the properties of column
Alter table OrderDetails
Add Mahendi varchar(200), -- for adding column into the table 

Alter Table OrderDetails
Alter column SellerName varchar(500); -- to change the properties of column

Alter table OrderDetails
Drop column SellerName; -- remove the column. While removing column, do not mention the data type. 

Exec sp_rename 'OrderDetails.Mahendi', 'SellerINFO', 'column' -- this is not advisable to rename column or table. the query is just for info

-- in the meta data, you can see that allow ull option is there. it is default. If you dont want null to be allowed, while creating table, mention 'not null' after data type and you can check in meta data, the tick mark will be unticked

/* ----- Creation of Primary key and Foreign key with two different methods -- */

create table users(
UserID int identity primary key,    -- identity word denotes, that this column will pick up the default value and you dont need to enter the values for it. there is no relation with primary key 
username varchar(200),
[password] varchar (500),
email varchar (100)); -- you can check the primry key into meta data. it will be not null by default. 

Create table roles(
role_id int identity,
role_name text,
Primary key (role_id));  -- this is another method of creating a primary key 

-- what happens if we give the primary key to the column which accepts null value --
create table pkname(Id int, Id_name varchar (500));  -- here as we have not defined anything, by default it will take null values, lets add primary key

alter table pkname
add primary key (Id);  -- once we execute this, we will get error message because it is null and you can not define primary key here 

alter table pkname
alter column id int not null; -- define it as not null and then run the above query, you will be able to create the primary key with id

/* ----- Creation of Foreign key -- */
create table categories(      -- parent table
categoryID int identity primary key,
categoryName varchar(200) not null);

create table products(      -- child table
productID int identity primary key,
productName varchar(500) not null,
categoryID int,
constraint fk_category -- below three lines are fixed code as per SQL standard for creating foreign key 
foreign key (categoryID)
	references categories(categoryID));

-- example of constraint enforcement --

insert into categories(categoryName)
values
('Furtniture'),('Office supplies');

select*from categories;

insert into products(productName, categoryID)
values
('Chair',1), ('Tables',2), ('Binder',1), ('Envelope',2);

select*from products;

insert into products(productName, categoryID)
values
('Accesories',3); /* this will not allow to execute because, the category ID is a FK and in the categories table it is PK. under PK the ID 3 is not available. 
Two tables are connected by PK and FK and hence it will not allow. 
this is because of the constrainst fk_categories. if you drop the constraint then both the tables are independent and you can run that query */

alter table products
drop constraint fk_category; /* after executing this if you run above query then it would work. As i have dropped the constraint, FK is no longer available and both
the tables are independent */ -- this is known as referential integrety 

select*from products;

-- creating primary key and foreign key using alter statement--

drop table categories,products; -- here i am just deleting the above tables created and then below we will create PK and FK using alter statement 

create table categories(
categoryID int not null,
categoryName varchar(400) not null);

alter table categories 
add constraint pk_categories primary key (categoryID);

create table products(
productID int identity primary key,
prodcutName varchar(500) not null,
categoryID int);

alter table products
add constraint fk_categories foreign key (categoryID) references categories (categoryID);  -- fk can accept duplicate and null values unlike pk

-- Truncate table--
--when we truncate the table, essentially it will remove all the entries from the table. It will not remove the table from the data base but just delet all the entries 

truncate table categories;  -- cannot happen because the categories table is being referenced by FK contraint. 

alter table products
drop constraint fk_categories; -- after this, please run above query and check the categories table

select*from categories; -- as per below result =, it has deleted all the entries

/* Best practices in DDL of SQL */
-- in table names, always use singular and form and upper case
-- For column name, never use spaces. e.g. write the column name as Customer_ID
-- Use integer and identity column for primary key. Always name primary key as table name + ID
-- Never create primary key when the table is already having huge data, no matter how unique that column might be 
-- you can not create primary key constraint on an nullable column 
-- Avoide using alter column properties on tables already havig data. It might result in loss of data

drop table categories, OrderDetails, OrderDetails2, pkname, products, roles, users;  -- end of class 3 - DDL 


