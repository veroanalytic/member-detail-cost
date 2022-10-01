USE Repository
CREATE TABLE dbo.Member_Detail_Cost 
(
  Member_ID BIGINT
, First_Name VARCHAR(120)
, Last_Name VARCHAR(120)
, DOB DATE
, Service_DT DATE
, Cost FLOAT
, FileBatch_ID CHAR(15)
)

SELECT *
FROM Repository.dbo.Member_Detail_Cost 


USE Repository
CREATE TABLE dbo.Batch_Control_Table
(
  Name_File VARCHAR(120)
, Batch_Control_ID BIGINT
, FileBatch_ID CHAR(15)
, Load_Date DATE

)

SELECT *
FROM Repository.dbo.Batch_Control_Table

INSERT INTO Repository.dbo.Batch_Control_Table
VALUES
  ('Mockedup_Member_Detail_20220930213111_Static.txt', 1, '20220930225750', '9/30/2022')
, ('Static_Cohort_Member_Detail_20220930220427.txt', 2, '20220930225744', '9/30/2022')
, ('Mockedup_Member_Detail_20220930221049.txt', 3, '20220930225714', '9/30/2022')
, ('Static_Cohort_Member_Detail_20220930225714.txt', 4, '20220930221049', '9/30/2022')
, ('Static_Cohort_Member_Detail_20220930225744.txt', 5, '20220930220427', '9/30/2022')
, ('Static_Cohort_Member_Detail_20220930225750.txt', 6, '20220930213111', '9/30/2022')
