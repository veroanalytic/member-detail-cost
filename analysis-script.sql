USE Repository
--TRUNCATE TABLE Repository.dbo.Member_Detail_Cost

--DELETE FROM Repository.dbo.Member_Detail_Cost
--WHERE FileBatch_ID = '20220930225257'

SELECT DISTINCT FileBatch_ID
FROM Repository.dbo.Member_Detail_Cost 
ORDER BY FileBatch_ID

SELECT TOP 5
	  Member_ID
	, First_Name
	, Last_Name
	, DOB
	, Service_DT
	, Cost
	, FileBatch_ID
FROM Repository.dbo.Member_Detail_Cost 
ORDER BY FileBatch_ID DESC


-- Overall Count / Sum Cost / Average Cost
SELECT 
  COUNT(*) AS Overall_Count
, SUM(Cost) AS Overall_Sum_Cost
, AVG(Cost) AS Overall_Average_Cost
FROM Repository.dbo.Member_Detail_Cost 
GO

-- Overall Count / Sum Cost / Average Cost for members who have only one claim
WITH One_Occurrence
AS 
(
SELECT 
  Member_ID, First_Name, Last_Name, DOB, Service_DT, Cost
, COUNT(*) OVER (PARTITION BY Member_ID) AS Number_Of_Occurences
FROM Repository.dbo.Member_Detail_Cost 
)
SELECT 
  COUNT(*) AS One_Occurence_Count
, SUM(Cost) AS One_Occurence_Sum_Cost
, AVG(Cost) AS One_Occurence_Avg_Cost
FROM One_Occurrence AS occ
WHERE Number_Of_Occurences = 1
GO


-- Overall Count / Sum Cost / Average Cost for members who have more than one claim
WITH Multiple_Occurrences 
AS 
(
SELECT 
  Member_ID, First_Name, Last_Name, DOB, Service_DT, Cost
, COUNT(*) OVER (PARTITION BY Member_ID) AS Number_Of_Occurences
FROM Repository.dbo.Member_Detail_Cost 
)
SELECT 
  COUNT(*) AS Multiple_Occurence_Count
, SUM(Cost) AS Multiple_Occurence_Sum_Cost
, AVG(Cost) AS Multiple_Occurence_Avg_Cost
FROM Multiple_Occurrences
WHERE Number_Of_Occurences > 1
GO


-- Sum/Avg Cost by Occurence
WITH Multiple_Occurrences 
AS 
(
SELECT 
  Member_ID, First_Name, Last_Name, DOB, Service_DT, Cost
, COUNT(*) OVER (PARTITION BY Member_ID) AS Number_Of_Occurences
FROM Repository.dbo.Member_Detail_Cost 
)
SELECT
  Number_Of_Occurences
, COUNT(*) AS Member_Count
, SUM(Cost) AS Occurence_Sum_Cost
, AVG(Cost) AS Occurence_Avg_Cost
FROM Multiple_Occurrences
GROUP BY Number_Of_Occurences
GO



-- Find member(s) with highest cost
DECLARE @maxprice AS FLOAT
SET @maxprice = (SELECT MAX(Cost) FROM Repository.dbo.Member_Detail_Cost )
SELECT *  
FROM Repository.dbo.Member_Detail_Cost 
WHERE Cost = @maxprice


-- Find member(s) with lowest cost
DECLARE @minprice AS FLOAT
SET @minprice = (SELECT MIN(Cost) FROM Repository.dbo.Member_Detail_Cost )
SELECT *  
FROM Repository.dbo.Member_Detail_Cost 
WHERE Cost = @minprice
GO

-- Member list of those with only one occurence
WITH One_Occurrence
AS 
(
SELECT 
  Member_ID, First_Name, Last_Name, DOB, Service_DT, Cost
, COUNT(*) OVER (PARTITION BY Member_ID) AS Number_Of_Occurences
FROM Repository.dbo.Member_Detail_Cost 
)
SELECT *
FROM One_Occurrence AS occ
WHERE Number_Of_Occurences = 1
GO



-- Member list of those with multiple occurences
WITH One_Occurrence
AS 
(
SELECT 
  Member_ID, First_Name, Last_Name, DOB, Service_DT, Cost
, COUNT(*) OVER (PARTITION BY Member_ID) AS Number_Of_Occurences
FROM Repository.dbo.Member_Detail_Cost 
)
SELECT *
FROM One_Occurrence AS occ
WHERE Number_Of_Occurences > 1
ORDER BY Number_Of_Occurences DESC, Member_ID
GO


-- Earliest Service_DT per member, earliest date by product (cost in this case)
SELECT *
, MIN(Service_DT) OVER (PARTITION BY Member_ID) AS Earliest_Service_DT
, MIN(Service_DT) OVER (PARTITION BY Member_ID, Cost) AS Service_DT_By_Cost -- redundant in this dataset with no actual product, but wanted to do it as practice
FROM Repository.dbo.Member_Detail_Cost 
ORDER BY Earliest_Service_DT, Member_ID
GO


-- Not really useful in this use case, but if we wanted to track how many times a member was seen after the first time
WITH After_First_Service AS 
(
SELECT *
, MIN(Service_DT) OVER (PARTITION BY Member_ID) AS Earliest_Service_DT
, MIN(Service_DT) OVER (PARTITION BY Member_ID, Cost) AS Service_DT_By_Cost -- redundant in this dataset with no actual product, but wanted to do it as practice
FROM Repository.dbo.Member_Detail_Cost 
)
SELECT *
FROM After_First_Service
WHERE Earliest_Service_DT < Service_DT_By_Cost  
ORDER BY Earliest_Service_DT, Member_ID