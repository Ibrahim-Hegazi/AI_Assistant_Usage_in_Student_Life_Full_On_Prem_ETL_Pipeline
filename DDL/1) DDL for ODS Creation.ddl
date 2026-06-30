-- 1. Create the ODS database if it does not exist
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'ODS')
BEGIN
    CREATE DATABASE ODS;
END;

-- 2. Create the DB schema inside the ODS database safely
EXEC('
    USE ODS;
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = ''DB'')
    BEGIN
        EXEC(''CREATE SCHEMA [DB]'');
    END;
');

-- 3. Create the Error schema inside the ODS database safely
EXEC('
    USE ODS;
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = ''Error'')
    BEGIN
        EXEC(''CREATE SCHEMA [Error]'');
    END;
');

-- 4. Truncate or Create the RawSessionData table inside the ODS database
EXEC('
    USE ODS;
    IF OBJECT_ID(''DB.RawSessionData'', ''U'') IS NOT NULL
    BEGIN
        -- Table exists, clear the old data
        TRUNCATE TABLE DB.RawSessionData;
    END
    ELSE
    BEGIN
        -- Table does not exist, create it
        CREATE TABLE DB.RawSessionData (
            SessionID VARCHAR(255),
            StudentLevel VARCHAR(255),
            Discipline VARCHAR(255),
            SessionDate VARCHAR(255),
            SessionLength VARCHAR(255),
            TotalPrompts VARCHAR(255),
            TaskType VARCHAR(255),
            AI_Assistance VARCHAR(255),
            FinalOutcome VARCHAR(255),
            UsedAgain VARCHAR(255),
            Satisfaction VARCHAR(255)
        );
    END;
');