USE DWH;
GO

-- DimDate
IF OBJECT_ID('DB.DimDate', 'U') IS NOT NULL
    DROP TABLE DB.DimDate;

CREATE TABLE DB.DimDate 
    (
     FullDate DATE , 
     Year INTEGER , 
     Quarter INTEGER , 
     QuarterName NVARCHAR (2) , 
     Month INTEGER , 
     MonthName NVARCHAR (15) , 
     DayOfMonth INTEGER , 
     DayOfWeek INTEGER , 
     DayName NVARCHAR (15) , 
     WeekNumber INTEGER , 
     IsWeekend BIT , 
     DimDate_SK NUMERIC (28) NOT NULL 
    );

ALTER TABLE DB.DimDate ADD CONSTRAINT DimDate_PK PRIMARY KEY CLUSTERED (DimDate_SK) 
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON );

-- Automatic Population of DimDate (2020 to 2030)
DECLARE @StartDate DATE = '2020-01-01';
DECLARE @EndDate DATE = '2030-12-31';

INSERT INTO DB.DimDate (
    DimDate_SK, FullDate, Year, Quarter, QuarterName,
    Month, MonthName, DayOfMonth, DayOfWeek, DayName, WeekNumber, IsWeekend
)
SELECT 
    CAST(CONVERT(VARCHAR(8), d, 112) AS NUMERIC(28)) AS DimDate_SK,
    d AS FullDate,
    YEAR(d) AS Year,
    DATEPART(QUARTER, d) AS Quarter,
    'Q' + CAST(DATEPART(QUARTER, d) AS NVARCHAR(1)) AS QuarterName,
    MONTH(d) AS Month,
    DATENAME(MONTH, d) AS MonthName,
    DAY(d) AS DayOfMonth,
    DATEPART(WEEKDAY, d) AS DayOfWeek,
    DATENAME(WEEKDAY, d) AS DayName,
    DATEPART(WEEK, d) AS WeekNumber,
    CASE WHEN DATENAME(WEEKDAY, d) IN ('Saturday', 'Sunday') THEN 1 ELSE 0 END AS IsWeekend
FROM (
    SELECT TOP (DATEDIFF(DAY, @StartDate, @EndDate) + 1) 
        DATEADD(DAY, ROW_NUMBER() OVER (ORDER BY a.object_id) - 1, @StartDate) AS d
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
) AS DateSequence;

-- DimOutcome
IF OBJECT_ID('DB.DimOutcome', 'U') IS NOT NULL
    DROP TABLE DB.DimOutcome;

CREATE TABLE DB.DimOutcome 
    (
     FinalOutcome NVARCHAR (50) , 
     DimOutcome_SK NUMERIC (28) NOT NULL IDENTITY(1,1) 
    );

ALTER TABLE DB.DimOutcome ADD CONSTRAINT DimOutcome_PK PRIMARY KEY CLUSTERED (DimOutcome_SK)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON );

-- DimAIAssistanceLevel
IF OBJECT_ID('DB.DimAIAssistanceLevel', 'U') IS NOT NULL
    DROP TABLE DB.DimAIAssistanceLevel;

CREATE TABLE DB.DimAIAssistanceLevel 
    (
     AI_AssistanceLevel INTEGER , 
     DimAIAssistanceLevel_SK NUMERIC (28) NOT NULL IDENTITY(1,1) 
    );

ALTER TABLE DB.DimAIAssistanceLevel ADD CONSTRAINT DimAIAssistanceLevel_PK PRIMARY KEY CLUSTERED (DimAIAssistanceLevel_SK)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON );

-- DimTaskType
IF OBJECT_ID('DB.DimTaskType', 'U') IS NOT NULL
    DROP TABLE DB.DimTaskType;

CREATE TABLE DB.DimTaskType 
    (
     TaskType NVARCHAR (50) , 
     DimTaskType_SK NUMERIC (28) NOT NULL IDENTITY(1,1) 
    );

ALTER TABLE DB.DimTaskType ADD CONSTRAINT DimTaskType_PK PRIMARY KEY CLUSTERED (DimTaskType_SK) 
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON );

-- DimDiscipline
IF OBJECT_ID('DB.DimDiscipline', 'U') IS NOT NULL
    DROP TABLE DB.DimDiscipline;

CREATE TABLE DB.DimDiscipline 
    (
     Discipline NVARCHAR (50) , 
     DimDiscipline_SK NUMERIC (28) NOT NULL IDENTITY(1,1) 
    );

ALTER TABLE DB.DimDiscipline ADD CONSTRAINT DimDiscipline_PK PRIMARY KEY CLUSTERED (DimDiscipline_SK) 
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON );

-- DimStudentLevel
IF OBJECT_ID('DB.DimStudentLevel', 'U') IS NOT NULL
    DROP TABLE DB.DimStudentLevel;

CREATE TABLE DB.DimStudentLevel 
    (
     StudentLevel NVARCHAR (50) , 
     DimStudentLevel_SK NUMERIC (28) NOT NULL IDENTITY(1,1) 
    );

ALTER TABLE DB.DimStudentLevel ADD CONSTRAINT DimStudentLevel_PK PRIMARY KEY CLUSTERED (DimStudentLevel_SK) 
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON );

USE DWH;
GO

-- FactSession
IF OBJECT_ID('DB.FactSession', 'U') IS NOT NULL
    DROP TABLE DB.FactSession;

CREATE TABLE DB.FactSession 
    (
     FactSession_SK NUMERIC (28) NOT NULL IDENTITY(1,1) ,
     SatisfactionRating FLOAT , 
     UsedAgain BIT , 
     TotalPrompts INTEGER ,
     SessionLengthMin FLOAT , 
     DimStudentLevel_SK NUMERIC (28) NOT NULL , 
     DimDiscipline_SK NUMERIC (28) NOT NULL , 
     DimOutcome_SK NUMERIC (28) NOT NULL , 
     DimTaskType_SK NUMERIC (28) NOT NULL , 
     DimAIAssistanceLevel_SK NUMERIC (28) NOT NULL , 
     DimDate_SK NUMERIC (28) NOT NULL  
    );

ALTER TABLE DB.FactSession ADD CONSTRAINT FactSession_PK PRIMARY KEY CLUSTERED (FactSession_SK)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON );



/*
-- Foreign Key Constraints (Updated with clean column names)
ALTER TABLE DB.FactSession 
    ADD CONSTRAINT FactSession_DimDate_FK FOREIGN KEY (DimDate_SK) 
    REFERENCES DB.DimDate (DimDate_SK) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION;

ALTER TABLE DB.FactSession 
    ADD CONSTRAINT FactSession_DimOutcome_FK FOREIGN KEY (DimOutcome_SK) 
    REFERENCES DB.DimOutcome (DimOutcome_SK) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION;

ALTER TABLE DB.FactSession 
    ADD CONSTRAINT FactSession_DimAIAssistanceLevel_FK FOREIGN KEY (DimAIAssistanceLevel_SK) 
    REFERENCES DB.DimAIAssistanceLevel (DimAIAssistanceLevel_SK) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION;

ALTER TABLE DB.FactSession 
    ADD CONSTRAINT FactSession_DimTaskType_FK FOREIGN KEY (DimTaskType_SK) 
    REFERENCES DB.DimTaskType (DimTaskType_SK) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION;

ALTER TABLE DB.FactSession 
    ADD CONSTRAINT FactSession_DimDiscipline_FK FOREIGN KEY (DimDiscipline_SK) 
    REFERENCES DB.DimDiscipline (DimDiscipline_SK) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION;

ALTER TABLE DB.FactSession 
    ADD CONSTRAINT FactSession_DimStudentLevel_FK FOREIGN KEY (DimStudentLevel_SK) 
    REFERENCES DB.DimStudentLevel (DimStudentLevel_SK) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION;
*/