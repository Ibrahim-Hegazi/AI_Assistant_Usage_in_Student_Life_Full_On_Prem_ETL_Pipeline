-- FactSession
IF OBJECT_ID('DB.FactSession', 'U') IS NOT NULL
BEGIN
    TRUNCATE TABLE DB.FactSession;
END
ELSE
BEGIN
    CREATE TABLE DB.FactSession 
        (
         SatisfactionRating FLOAT , 
         DimStudent_DimStudent_SK NUMERIC (28) NOT NULL , 
         DimOutcome_DimOutcome_SK NUMERIC (28) NOT NULL , 
         DimTaskType_DimTaskType_SK NUMERIC (28) NOT NULL , 
         DimSession_DimSession_SK NUMERIC (28) NOT NULL , 
         DimDate_DimDate_SK NUMERIC (28) NOT NULL  
        );
END;