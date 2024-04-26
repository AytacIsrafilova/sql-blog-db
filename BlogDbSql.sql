create database BlogDbSql
use BlogDbSql

create table Categories (
Id int primary key Identity,
[Name] nvarchar(50) Unique NOT NULL)

create table Tags(
Id int primary key Identity,
[Name] nvarchar(50) Unique NOT NULL)

create table Users(
Id int primary key Identity,
UserName nvarchar Unique NOT NULL,
FullName nvarchar NOT NULL,
Age int CHECK (Age > 0 and Age < 150)
)


create table Comments(
Id int primary key Identity,
Content nvarchar not null Check(Len(Content)>0 and Len(Content)<250),
UserId int foreign key references Users(Id),
BlogId int foreign key references Blogs(Id)
)

create table Blogs(
Id int primary key Identity,
Title nvarchar(50) not null Check(Len(Title)>0 and Len(Title)<50),
[Description] nvarchar not null,
UserId int foreign key references Users(Id)
CategoryId int not null foreign key references  Categories(Id)
)

create table BlogTag(
Id int primary key Identity,
BlogId int foreign key references Blogs(Id),
TagId int foreign key references Tags(Id)
)
select b.Id as[Blog Id] b.Title as [Blog Title] from Blogs as b
join BlogTag as bt
on bt.BlogId=b.Id
join  Tags as t
on bt.TagId= t.Id

create view GetBlogsUsers
as
select Blogs.Title,Users.UserName,Users.FullName
from Blogs,Users

create view GetBlogsCategories
as
select Blogs.Title,Categories.Name
from Blogs,Categories

create procedure usp_GetUsersComments @userId int
as
select * from Users
where Users.Id=@userId
exec usp_GetUsersComments @userId=3


create procedure usp_GetUsersBlogs @userId int
as
select *from Users
where Users.Id=@userId
exec usp_GetUsersBlogs @userId=2

create function GetBlogsCount (@categoryId int)
Return int 
as
begin
declare @BlogCount int
select @BlogCount=Count (*)from Blogs
where Categories.Id=@categoryId
return @BlogCount 
end

create function GetBlogsTable (@userId int)
Return table 
as
begin
Declare Blogtable table
select  Id,Title,Description from Blogs
where Users.Id=@userId
return Blogtable
end

create trigger tr_GetBlogDeleted on Blogs
for delete
instead of delete
as
begin
select nocount on
update Blogs
set isDeleted=1
where Id in (select Id from deleted)
end