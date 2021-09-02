Question 1: Combine Two Tables.

--Table: Person

--+-------------+---------+
--| Column Name | Type    |
--+-------------+---------+
--| PersonId    | int     |
--| FirstName   | varchar |
--| LastName    | varchar |
--+-------------+---------+
--PersonId is the primary key column for this table.
--Table: Address

--+-------------+---------+
--| Column Name | Type    |
--+-------------+---------+
--| AddressId   | int     |
--| PersonId    | int     |
--| City        | varchar |
--| State       | varchar |
--+-------------+---------+
--AddressId is the primary key column for this table.
--Q: Write a SQL query for a report that provides the following information for each person in the Person table, regardless if there is an address for each of those people:
--FirstName, LastName, City, State

Solution: 

Select FirstName, LastName, City, State
from Person 
Left Join Address 
ON Person.PersonId = Address.PersonId

IF WE DONT WANT NULL VALUES:

Select FirstName, LastName, City, State
from Person 
Left Join Address 
ON Person.PersonId = Address.PersonId
Where City And State IS NOT NULL
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Question 2: Second Highest Salary

--Write a SQL query to get the second highest salary from the Employee table.

--+----+--------+
--| Id | Salary |
--+----+--------+
--| 1  | 100    |
--| 2  | 200    |
--| 3  | 300    |
--+----+--------+
--For example, given the above Employee table, the query should return 200 as the second highest salary. If there is no second highest salary, then the query should return null.

--+---------------------+
--| SecondHighestSalary |
--+---------------------+
--| 200                 |
--+---------------------+

SOLUTION: 

With CTE AS (

Select Salary, DENSE_RANK ( ) OVER ( ORDER BY Salary desc) As Salary_rank from Employee
         )
Select ISNULL(
              (select TOP 1 salary from cte where Salary_rank = 2),
			  NULL) AS SecondHighestSalary;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Question 3 

--The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.

--+----+-------+--------+-----------+
--| Id | Name  | Salary | ManagerId |
--+----+-------+--------+-----------+
--| 1  | Joe   | 70000  | 3         |
--| 2  | Henry | 80000  | 4         |
--| 3  | Sam   | 60000  | NULL      |
--| 4  | Max   | 90000  | NULL      |
--+----+-------+--------+-----------+
--Given the Employee table, write a SQL query that finds out employees who earn more than their managers. For the above table, Joe is the only employee who earns more than his manager.

--+----------+
--| Employee |
--+----------+
--| Joe      |
--+----------+

SOLUTION:

Select A.Name as 'Employee' from Employee A 
join Employee B 
on A.ManagerId = B.Id
where A.Salary > B.Salary 

OR

Select A.Name as 'Employee' 
from Employee A,
     Employee B 
Where A.ManagerId = B.Id
      and  A.Salary > B.Salary 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--QUESTION 4:

--Write a SQL query to find all duplicate emails in a table named Person.

--+----+---------+
--| Id | Email   |
--+----+---------+
--| 1  | a@b.com |
--| 2  | c@d.com |
--| 3  | a@b.com |
--+----+---------+
--For example, your query should return the following for the above table:

--+---------+
--| Email   |
--+---------+
--| a@b.com |
--+---------+

Solution:

Select Email 
from Person 
group by email
Having Count(email)> 1 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Question 5 

--Suppose that a website contains two tables, the Customers table and the Orders table. Write a SQL query to find all customers who never order anything.

--Table: Customers.

--+----+-------+
--| Id | Name  |
--+----+-------+
--| 1  | Joe   |
--| 2  | Henry |
--| 3  | Sam   |
--| 4  | Max   |
--+----+-------+
--Table: Orders.

--+----+------------+
--| Id | CustomerId |
--+----+------------+
--| 1  | 3          |
--| 2  | 1          |
--+----+------------+
--Using the above tables as example, return the following:

--+-----------+
--| Customers |
--+-----------+
--| Henry     |
--| Max       |
--+-----------+

Solution:

Select Name as 'Customers' from Customers where Id not in (Select C.Id 
from Customers C
Right Join Orders O
On C.Id = O.CustomerId)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Question 6: Rising Temperature

--Table: Weather

--+---------------+---------+
--| Column Name   | Type    |
--+---------------+---------+
--| id            | int     |
--| recordDate    | date    |
--| temperature   | int     |
--+---------------+---------+
--id is the primary key for this table.
--This table contains information about the temperature in a certain day.
 

--Write an SQL query to find all dates' id with higher temperature compared to its previous dates (yesterday).

--Return the result table in any order.

--The query result format is in the following example:

--Weather
--+----+------------+-------------+
--| id | recordDate | Temperature |
--+----+------------+-------------+
--| 1  | 2015-01-01 | 10          |
--| 2  | 2015-01-02 | 25          |
--| 3  | 2015-01-03 | 20          |
--| 4  | 2015-01-04 | 30          |
--+----+------------+-------------+

--Result table:
--+----+
--| id |
--+----+
--| 2  |
--| 4  |
--+----+
--In 2015-01-02, temperature was higher than the previous day (10 -> 25).
--In 2015-01-04, temperature was higher than the previous day (20 -> 30).

Solutions:

SELECT t1.id AS 'id'
FROM 
    Weather t1
    ,Weather t2 
WHERE 
    t1.Temperature > t2.Temperature 
    AND DATEDIFF(day, t2.recordDate, t1.recordDate)=1
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Question 7: 

--Select all employee's name and bonus whose bonus is < 1000.

--Table:Employee

--+-------+--------+-----------+--------+
--| empId |  name  | supervisor| salary |
--+-------+--------+-----------+--------+
--|   1   | John   |  3        | 1000   |
--|   2   | Dan    |  3        | 2000   |
--|   3   | Brad   |  null     | 4000   |
--|   4   | Thomas |  3        | 4000   |
--+-------+--------+-----------+--------+
--empId is the primary key column for this table.
--Table: Bonus

--+-------+-------+
--| empId | bonus |
--+-------+-------+
--| 2     | 500   |
--| 4     | 2000  |
--+-------+-------+
--empId is the primary key column for this table.
--Example ouput:

--+-------+-------+
--| name  | bonus |
--+-------+-------+
--| John  | null  |
--| Dan   | 500   |
--| Brad  | null  |
--+-------+-------+

Solution:

Select E.name, B.bonus 
from Employee E
Left Join Bonus B
on E.empId = B.empId
where B.bonus < 1000
      or B.bonus is null
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Question 8:

--Given a table customer holding customers information and the referee.

--+------+------+-----------+
--| id   | name | referee_id|
--+------+------+-----------+
--|    1 | Will |      NULL |
--|    2 | Jane |      NULL |
--|    3 | Alex |         2 |
--|    4 | Bill |      NULL |
--|    5 | Zack |         1 |
--|    6 | Mark |         2 |
--+------+------+-----------+
--Write a query to return the list of customers NOT referred by the person with id '2'.

--For the sample data above, the result is:

--+------+
--| name |
--+------+
--| Will |
--| Jane |
--| Bill |
--| Zack |
--+------+

Solution:

Select name from Customer where id not in(Select id from customer where referee_id = 2)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Question 9:

--Table: Orders

--+-----------------+----------+
--| Column Name     | Type     |
--+-----------------+----------+
--| order_number    | int      |
--| customer_number | int      |
--+-----------------+----------+
--order_number is the primary key for this table.
--This table contains information about the order ID and the customer ID.
 

--Write an SQL query to find the customer_number for the customer who has placed the largest number of orders.

--It is guaranteed that exactly one customer will have placed more orders than any other customer.

--The query result format is in the following example:

 

--Orders table:
--+--------------+-----------------+
--| order_number | customer_number |
--+--------------+-----------------+
--| 1            | 1               |
--| 2            | 2               |
--| 3            | 3               |
--| 4            | 3               |
--+--------------+-----------------+

--Result table:
--+-----------------+
--| customer_number |
--+-----------------+
--| 3               |
--+-----------------+
--The customer with number 3 has two orders, which is greater than either customer 1 or 2 because each of them only has one order. 
--So the result is customer_number 3.

Solution:

Select Top 1 O.customer_number From (Select customer_number, count(customer_number) as 'Count' from Orders 
group by customer_number
Having count(customer_number) > 1) O
order by O.Count DESC
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Question 10:

--There is a table courses with columns: student and class

--Please list out all classes which have more than or equal to 5 students.

--For example, the table:

--+---------+------------+
--| student | class      |
--+---------+------------+
--| A       | Math       |
--| B       | English    |
--| C       | Math       |
--| D       | Biology    |
--| E       | Math       |
--| F       | Computer   |
--| G       | Math       |
--| H       | Math       |
--| I       | Math       |
--+---------+------------+
--Should output:

--+---------+
--| class   |
--+---------+
--| Math    |
--+---------+

Solution:

Select class from courses 
group by class 
having Count(distinct student) >= 5
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Question 11:

--Table: FriendRequest

--+----------------+---------+
--| Column Name    | Type    |
--+----------------+---------+
--| sender_id      | int     |
--| send_to_id     | int     |
--| request_date   | date    |
--+----------------+---------+
--There is no primary key for this table, it may contain duplicates.
--This table contains the ID of the user who sent the request, the ID of the user who received the request, and the date of the request.
 

--Table: RequestAccepted

--+----------------+---------+
--| Column Name    | Type    |
--+----------------+---------+
--| requester_id   | int     |
--| accepter_id    | int     |
--| accept_date    | date    |
--+----------------+---------+
--There is no primary key for this table, it may contain duplicates.
--This table contains the ID of the user who sent the request, the ID of the user who received the request, and the date when the request was accepted.
 

--Write an SQL query to find the overall acceptance rate of requests, which is the number of acceptance divided by the number of requests. Return the answer rounded to 2 decimals places.

--Note that:

--The accepted requests are not necessarily from the table friend_request. In this case, you just need to simply count the total accepted requests (no matter whether they are in the original requests), and divide it by the number of requests to get the acceptance rate.
--It is possible that a sender sends multiple requests to the same receiver, and a request could be accepted more than once. In this case, the ‘duplicated’ requests or acceptances are only counted once.
--If there are no requests at all, you should return 0.00 as the accept_rate.
--The query result format is in the following example:

 

--FriendRequest table:
--+-----------+------------+--------------+
--| sender_id | send_to_id | request_date |
--+-----------+------------+--------------+
--| 1         | 2          | 2016/06/01   |
--| 1         | 3          | 2016/06/01   |
--| 1         | 4          | 2016/06/01   |
--| 2         | 3          | 2016/06/02   |
--| 3         | 4          | 2016/06/09   |
--+-----------+------------+--------------+

--RequestAccepted table:
--+--------------+-------------+-------------+
--| requester_id | accepter_id | accept_date |
--+--------------+-------------+-------------+
--| 1            | 2           | 2016/06/03  |
--| 1            | 3           | 2016/06/08  |
--| 2            | 3           | 2016/06/08  |
--| 3            | 4           | 2016/06/09  |
--| 3            | 4           | 2016/06/10  |
--+--------------+-------------+-------------+

--Result table:
--+-------------+
--| accept_rate |
--+-------------+
--| 0.8         |
--+-------------+
--There are 4 unique accepted requests, and there are 5 requests in total. So the rate is 0.80.

Solution:

SELECT
    ROUND ( IFNULL(
    (SELECT COUNT(*) FROM (SELECT DISTINCT requester_id, accepter_id FROM RequestAccepted) AS A)
    /
    (SELECT COUNT(*) FROM (SELECT DISTINCT sender_id, send_to_id FROM FriendRequest) AS B),
    0),2)  AS accept_rate;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Question 12: 

--There is a table World

--+-----------------+------------+------------+--------------+---------------+
--| name            | continent  | area       | population   | gdp           |
--+-----------------+------------+------------+--------------+---------------+
--| Afghanistan     | Asia       | 652230     | 25500100     | 20343000      |
--| Albania         | Europe     | 28748      | 2831741      | 12960000      |
--| Algeria         | Africa     | 2381741    | 37100000     | 188681000     |
--| Andorra         | Europe     | 468        | 78115        | 3712000       |
--| Angola          | Africa     | 1246700    | 20609294     | 100990000     |
--+-----------------+------------+------------+--------------+---------------+
--A country is big if it has an area of bigger than 3 million square km or a population of more than 25 million.

--Write a SQL solution to output big countries name, population and area.

--For example, according to the above table, we should output:

--+--------------+-------------+--------------+
--| name         | population  | area         |
--+--------------+-------------+--------------+
--| Afghanistan  | 25500100    | 652230       |
--| Algeria      | 37100000    | 2381741      |
--+--------------+-------------+--------------+
 

Solution:

Select name, population, area from World
having population > 25000000
    or area > 3000000
