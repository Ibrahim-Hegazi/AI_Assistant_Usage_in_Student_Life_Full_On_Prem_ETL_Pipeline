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
     UsedAgain BIT , 
     DimOutcome_SK NUMERIC (28) NOT NULL IDENTITY(1,1) 
    );

ALTER TABLE DB.DimOutcome ADD CONSTRAINT DimOutcome_PK PRIMARY KEY CLUSTERED (DimOutcome_SK)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON );

-- DimSession
IF OBJECT_ID('DB.DimSession', 'U') IS NOT NULL
    DROP TABLE DB.DimSession;

CREATE TABLE DB.DimSession 
    (
     SessionLengthMin FLOAT , 
     TotalPrompts INTEGER , 
     AIAssistanceLevel INTEGER , 
     DimSession_SK NUMERIC (28) NOT NULL IDENTITY(1,1) 
    );

ALTER TABLE DB.DimSession ADD CONSTRAINT DimSession_PK PRIMARY KEY CLUSTERED (DimSession_SK)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON );

-- DimStudent
IF OBJECT_ID('DB.DimStudent', 'U') IS NOT NULL
    DROP TABLE DB.DimStudent;

CREATE TABLE DB.DimStudent 
    (
     StudentLevel NVARCHAR (50) , 
     StudentDiscipline NVARCHAR (50) , 
     DimStudent_SK NUMERIC (28) NOT NULL IDENTITY(1,1) 
    );

ALTER TABLE DB.DimStudent ADD CONSTRAINT DimStudent_PK PRIMARY KEY CLUSTERED (DimStudent_SK) 
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