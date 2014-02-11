---
layout: post
title: "Reviewing SQL Joins"
date: 2012-11-01 13:43
comments: true
categories: [sql, joins, database]
published: true
---

In relation to the Yellowpill project (an application for generating sql queries) that I'm working on. I figured I needed to review what I know about
SQL Joins so that I can properly do the job. 

For this post I'll be using two tables: ```tbl_students``` and ```tbl_school```

**tbl_school**

![table1](/images/posts/sqljoins/table1.jpg)


**tbl_students**

![table2](/images/posts/sqljoins/table2.jpg)

Note that I have used the term first table which refers to the table that you have specified after the ```FROM``` keyword
which can also be referred to as left table. And the second table is the table that you're trying to join with the first table.
The second table can also be reffered as the right table.

- **INNER JOIN** - selects the rows which has a match on both tables. 
This is also the same with just using ```JOIN``` or ```CROSS JOIN```.

```sql
SELECT name, hobby, school FROM tbl_students
INNER JOIN tbl_school ON tbl_students.school_id = tbl_school.id
```

**Result:**

![inner_join](/images/posts/sqljoins/inner_join.jpg)

- **LEFT OUTER JOIN** - selects every record on the first table even if it doesn't have
a match on the second table. Note that this is also the same with ```LEFT JOIN```
```
SELECT name, hobby, school FROM tbl_students
LEFT OUTER JOIN tbl_school ON tbl_students.school_id = tbl_school.id
```

**Result:**

![left_join](/images/posts/sqljoins/left_outerjoin.jpg)


- **RIGHT OUTER JOIN** - selects every record on the second table even if it doesn't have a match on the first table. 
Note that this is also the same with ```RIGHT JOIN```.

```
SELECT school, name, hobby FROM tbl_students
RIGHT OUTER JOIN tbl_school ON tbl_students.school_id = tbl_school.id
```

**Result:**

![right_join](/images/posts/sqljoins/right_outerjoin.jpg)

As I am writing this blog post I also discovered a convention that can be used when writing queries.
And that is putting the fields which are from the first table on the left part of the query string, and the fields from 
the second table in the right part of the query string. This really helps to see which rows are ```NULL``` from which table.
If the nulls in the result are in the left part it means that the type of join used is a ```RIGHT OUTER JOIN``` and if the nulls shows
up in the right part it means that the type of join is ```LEFT OUTER JOIN```. But that type of thing also depends on which
fields were selected or if they have actual data on it.


- **WHERE JOINS** - this isn't actually a type of join, just an alternative used by other people. ```WHERE JOIN``` is performing 
table joins without using the ```JOIN``` keyword. The condition is supplied after the ```WHERE``` keyword instead.
Here's an example:

```
SELECT name, hobby, school FROM tbl_students, tbl_school 
WHERE tbl_students.school_id = tbl_school.id
```

As you can see from the result below, it yields the same result as that of ```INNER JOIN```

**Result:**

![where_join](/images/posts/sqljoins/where_join.jpg)



###Resources

- [A visual explanation of sql joins](http://www.codinghorror.com/blog/2007/10/a-visual-explanation-of-sql-joins.html)
- [Difference between using these two joining table approaches](http://stackoverflow.com/questions/5294311/difference-between-these-two-joining-table-approaches)
