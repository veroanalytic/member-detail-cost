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