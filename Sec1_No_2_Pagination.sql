Sitechecker.pro, a technical SEO website, defines pagination as “an ordinal numbering of pages, which is usually located at the top or bottom of the site pages.” 
Sitechecker.pro, một trang web SEO kỹ thuật, định nghĩa phân trang là “đánh số thứ tự của các trang, thường nằm ở đầu hoặc cuối các trang của trang web”.

PageIndex được sử dụng để biểu thị số lượng trang và PageSize được sử dụng để biểu thị các bản ghi có trong một trang. 
There are only four types of SQL Server paging that I know: triple loop, max (primary key), and row_ Number keyword, offset / fetch next keyword 
(nó được tóm tắt bằng cách thu thập phương pháp của những người khác trên Internet. 
Nên có hiện tại chỉ có bốn phương pháp này và các phương pháp khác dựa trên sự biến dạng này).

Method 1: triple cycle thinking
Đầu tiên lấy 20 trang đầu tiên, sau đó đảo ngược thứ tự và lấy 10 bản ghi đầu tiên sau khi đảo ngược thứ tự. Bằng cách này, bạn có thể nhận được dữ liệu cần thiết để phân trang. Tuy nhiên, thứ tự đã bị đảo ngược. Sau đó, bạn có thể đảo ngược thứ tự một lần nữa hoặc bạn không thể sắp xếp nữa và giao trực tiếp cho giao diện người dùng để phân loại.
Có một phương pháp khác cũng có thể được coi là loại này. Chúng tôi sẽ không đưa ra mã ở đây, mà chỉ nói về ý tưởng. Đó là, trước tiên hãy truy vấn 10 bản ghi hàng đầu, sau đó loại trừ 10 bản ghi không có trong và sau đó truy vấn.

--Set the start of the execution time to view the performance
set statistics time on ;
--Paging query (general)
select * 
from (select top pageSize * 
from (select top (pageIndex*pageSize) * 
from student 
Order by SnO ASC -- in this layer, the ascending order must be specified. If omitted, the query result will be wrong.
as temp_sum_student 
order by sNo desc ) temp_order
order by sNo asc

--Pagination query page 2, each page has 10 records
select * 
from (select top 10 * 
from (select top 20 * 
from student 
Order by SnO ASC -- in this layer, the ascending order must be specified. If omitted, the query result will be wrong.
as temp_sum_student 
ord


Method 2: using max (primary key)
Đầu tiên, các bản ghi 11 hàng trên cùng, sau đó sử dụng max (ID) để lấy ID tối đa, rồi truy vấn lại 10 bản ghi đầu tiên trong bảng này, nhưng với điều kiện trong đó id> max (ID).
set statistics time on;
--Paging query (general)
select top pageSize * 
from student 
where sNo>=
(select max(sNo) 
from (select top ((pageIndex-1)*pageSize+1) sNo
from student 
order by sNo asc) temp_max_ids) 
order by sNo;


--Pagination query page 2, each page has 10 records
select top 10 * 
from student 
where sNo>=
(select max(sNo) 
from (select top 11 sNo
from student 
order by sNo asc) temp_max_ids) 
order by sNo;

Methods: three row method was used_ Number keyword
Direct useizationrow_number () over (order by id) Hàm tính số chuyến đi, chọn số hàng tương ứng để trả về, tuy nhiên từ khóa chỉ có trong SQL Server 2005 trở lên.
set statistics time on;
--Paging query (general)
select top pageSize * 
from (select row_number() 
over(order by sno asc) as rownumber,* 
from student) temp_row
where rownumber>((pageIndex-1)*pageSize);

set statistics time on;
--Pagination query page 2, each page has 10 records
select top 10 * 
from (select row_number() 
over(order by sno asc) as rownumber,* 
from student) temp_row
where rownumber>10;

The fourth method: offset / fetch next (only available in version 2012 and above)
set statistics time on;
--Paging query (general)
select * from student
order by sno 
offset ((@pageIndex-1)*@pageSize) rows
fetch next @pageSize rows only;

--Pagination query page 2, each page has 10 records
select * from student
order by sno 
offset 10 rows
fetch next 10 rows only ;
Chênh lệch một hàng, làm tròn bản ghi trước đó, chỉ tìm nạp hàng B tiếp theo và đọc ngược dữ liệu B.

Các thủ tục được lưu trữ được đóng gói. Cuối cùng, tôi đóng gói một thủ tục lưu trữ phân trang để bạn gọi, để khi bạn viết phân trang, bạn có thể gọi trực tiếp thủ tục được lưu trữ này. Phân trang các thủ tục được lưu trữ
create procedure paging_procedure
(@ PageIndex int, - what page
	@PageSize int -- number of records per page
)
as
begin 
	Select top (select @ PageSize) * -- note here that you can't put the variable here directly, you should use Select
	from (select row_number() over(order by sno) as rownumber,* 
			from student) temp_row 
	where rownumber>(@pageIndex-1)*@pageSize;
end

--At that time, it is OK to call the paging stored procedure by executing the following statement
exec paging_procedure @pageIndex=2,@pageSize=10;

...................................................................................................................................................................................................................................................................................................................................................................
Pagination in SQL Server
April 14, 2020 by Esat Erkec
ApexSQL pricing
Pagination is a process that is used to divide a large data into smaller discrete pages, and this process is also known as paging. Pagination is commonly used by web applications and can be seen on Google. When we search for something on Google, it shows the results on the separated page; this is the main idea of the pagination.

The answer to the “What is pagination” question

Now, we will discuss how to achieve pagination in SQL Server in the next parts of the article.

Preparing Sample Data
Before beginning to go into detail about the pagination, we will create a sample table and will populate it with some synthetic data. In the following query, we will create a SampleFruits table that stores fruit names and selling prices. In the next part of the article, we will use this table.

CREATE TABLE SampleFruits ( 
Id INT PRIMARY KEY IDENTITY(1,1) , 
FruitName VARCHAR(50) , 
Price INT
)
GO
INSERT INTO SampleFruits VALUES('Apple',20)
INSERT INTO SampleFruits VALUES('Apricot',12)
INSERT INTO SampleFruits VALUES('Banana',8)
INSERT INTO SampleFruits VALUES('Cherry',11)
INSERT INTO SampleFruits VALUES('Strawberry',26)
INSERT INTO SampleFruits VALUES('Lemon',4)  
INSERT INTO SampleFruits VALUES('Kiwi',14)  
INSERT INTO SampleFruits VALUES('Coconut',34) 
INSERT INTO SampleFruits VALUES('Orange',24)  
INSERT INTO SampleFruits VALUES('Raspberry',13)
INSERT INTO SampleFruits VALUES('Mango',9)
INSERT INTO SampleFruits VALUES('Mandarin',19)
INSERT INTO SampleFruits VALUES('Pineapple',22)
GO
SELECT * FROM SampleFruits
Sample table for paging in SQL
What is Pagination in SQL Server?
In terms of the SQL Server, the aim of the pagination is, dividing a resultset into discrete pages with the help of the query. When the OFFSET and FETCH arguments are used in with the ORDER BY clause in a SELECT statement, it will be a pagination solution for SQL Server.

OFFSET argument specifies how many rows will be skipped from the resultset of the query. In the following example, the query will skip the first 3 rows of the SampleFruits table and then return all remaining rows.

SELECT FruitName, Price
FROM SampleFruits
ORDER BY Price
OFFSET 3 ROWS
What is pagination in SQL Server?
When we set OFFSET value as 0, no rows will be skipped from the resultset. The following query can be an example of this usage type:

SELECT FruitName,Price FROM SampleFruits
ORDER BY Price 
OFFSET 0 ROWS
OFFSET argument usage in SQL Server
On the other hand, if we set the OFFSET value, which is greater than the total row number of the resultset, no rows will be displayed on the result. When we consider the following query, the SampleFruits table total number of the rows is 13, and we set OFFSET value as 20, so the query will not display any result.

SELECT FruitName,Price FROM SampleFruits
ORDER BY Price 
OFFSET 20 ROWS
OFFSET argument usage in SQL Server
FETCH argument specifies how many rows will be displayed in the result, and the FETCH argument must be used with the OFFSET argument. In the following example, we will skip the first 5 rows and then limit the resultset to 6 rows for our sample table.

SELECT FruitName, Price
FROM SampleFruits
ORDER BY Price
OFFSET 5 ROWS FETCH NEXT 6 ROWS ONLY
OFFSET – FETCH arguments usage for paging in SQL Server

Tip: The TOP CLAUSE limits the number of rows that returned from the SELECT statement. When we use the TOP clause without ORDER BY, it can be returned to arbitrary results. When we consider the following example, it will return 3 random rows on each execution of the query.

SELECT TOP 7 FruitName, Price
FROM SampleFruits
TOP clause usage in SQL Server
As we learned, the OFFSET-FETCH argument requires the ORDER BY clause in the SELECT statement. If we want to implement an undefined order which likes the previous usage of the TOP clause with OFFSET-FETCH arguments, we can use a query which looks like below:

SELECT  FruitName ,Price FROM SampleFruits
ORDER BY (SELECT NULL)
OFFSET 0 ROWS FETCH NEXT 7 ROWS ONLY
OFFSET-FETCH usage instead of the TOP clause
Pagination query in SQL Server
After figuring out the answer to “What is Pagination?” question, we will learn how we can write a pagination query in SQL Server. At first, we will execute the following query and will tackle the query:

DECLARE @PageNumber AS INT
DECLARE @RowsOfPage AS INT
SET @PageNumber=2
SET @RowsOfPage=4
SELECT FruitName,Price FROM SampleFruits
ORDER BY Price 
OFFSET (@PageNumber-1)*@RowsOfPage ROWS
FETCH NEXT @RowsOfPage ROWS ONLY
What is pagination in SQL Server
As we can see, we have declared two variables in the above query, and these variables are:

@PageNumber – It specifies the number of the page which will be displayed
@RowsOfPage – It specifies how many numbers of rows will be displayed on the page. As a result, the SELECT statement displays the second page, which contains 4 rows
Dynamic Sorting with Pagination
Applications may need to sort the data according to different columns either in ascending or descending order beside pagination. To overcome this type of requirement, we can use an ORDER BY clause with CASE conditions so that we obtain a query that can be sorted by the variables. The following query can be an example of this usage type:

DECLARE @PageNumber AS INT
DECLARE @RowsOfPage AS INT
DECLARE @SortingCol AS VARCHAR(100) ='FruitName'
DECLARE @SortType AS VARCHAR(100) = 'DESC'
SET @PageNumber=1
SET @RowsOfPage=4
SELECT FruitName,Price FROM SampleFruits
ORDER BY 
CASE WHEN @SortingCol = 'Price' AND @SortType ='ASC' THEN Price END ,
CASE WHEN @SortingCol = 'Price' AND @SortType ='DESC' THEN Price END DESC,
CASE WHEN @SortingCol = 'FruitName' AND @SortType ='ASC' THEN FruitName END ,
CASE WHEN @SortingCol = 'FruitName' AND @SortType ='DESC' THEN FruitName END DESC
OFFSET (@PageNumber-1)*@RowsOfPage ROWS
FETCH NEXT @RowsOfPage ROWS ONLY
Dynamic sorting with pagination
Also, we can change the sort column and sorting direction through the variables for the above query.

Pagination in a Loop
In this example, we will learn a query technique that returns all discrete page results with a single query.

DECLARE @PageNumber AS INT
            DECLARE @RowsOfPage AS INT
        DECLARE @MaxTablePage  AS FLOAT 
        SET @PageNumber=1
        SET @RowsOfPage=4
        SELECT @MaxTablePage = COUNT(*) FROM SampleFruits
        SET @MaxTablePage = CEILING(@MaxTablePage/@RowsOfPage)
        WHILE @MaxTablePage >= @PageNumber
        BEGIN
         SELECT FruitName,Price FROM SampleFruits
        ORDER BY Price 
        OFFSET (@PageNumber-1)*@RowsOfPage ROWS
        FETCH NEXT @RowsOfPage ROWS ONLY
        SET @PageNumber = @PageNumber + 1
        END
What is pagination in SQL Server
For this query, we created a pretty simple formula. At first, we assigned the total row number of the SampleFruit table to the @MaxTablePage variable, and then we divided it into how many rows will be displayed on a page. So, we have calculated the number of pages that will be displayed. However, the calculated value can be a decimal, and for that, we used the CEILING function to round it up to the smallest integer number that is bigger than the calculated number. As a second step, we implemented a WHILE-LOOP and iterated @PageNumber variable until the last page of the number.

Conclusion
In this article, we tried to find out the answer to “What is Pagination?” question, particularly for SQL Server. OFFSET-FETCH arguments help to implement how many rows we want to skip and how many rows we want to display in the resultset when we use them with the ORDER BY clause in the SELECT statements. And finally, we learned how we can achieve pagination in SQL Server with these arguments.