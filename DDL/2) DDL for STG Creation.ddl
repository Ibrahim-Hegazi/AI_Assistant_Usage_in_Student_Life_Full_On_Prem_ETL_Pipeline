-- 1. Create the STG database if it does not exist
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'STG')
BEGIN
    CREATE DATABASE STG;
END;

-- 2. Create the DB schema inside the STG database safely
EXEC('
    USE STG;
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = ''DB'')
    BEGIN
        EXEC(''CREATE SCHEMA [DB]'');
    END;
');

-- 3. Create the Error schema inside the STG database safely
EXEC('
    USE STG;
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = ''Error'')
    BEGIN
        EXEC(''CREATE SCHEMA [Error]'');
    END;
');

-- 4. Truncate or Create the properly-typed Staging table
EXEC('
    USE STG;
    IF OBJECT_ID(''DB.CleanedSessionData'', ''U'') IS NOT NULL
    BEGIN
        -- Table exists, clear the old data
        TRUNCATE TABLE DB.CleanedSessionData;
    END
    ELSE
    BEGIN
        -- Table does not exist, create it with DWH datatypes
        CREATE TABLE DB.CleanedSessionData (
            SessionID INT,
            StudentLevel NVARCHAR(50),
            Discipline NVARCHAR(50),
            SessionDate DATE,
            SessionLength FLOAT,
            TotalPrompts INT,
            TaskType NVARCHAR(50),
            AI_Assistance INT,
            FinalOutcome NVARCHAR(50),
            UsedAgain BOOLEAN,
            Satisfaction FLOAT
        );
    END;
');