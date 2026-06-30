-- 1. Create the DWH database if it does not exist
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DWH')
BEGIN
    CREATE DATABASE DWH;
END;

-- 2. Create the DB schema safely
EXEC('
    USE DWH;
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = ''DB'')
    BEGIN
        EXEC(''CREATE SCHEMA [DB]'');
    END;
');

-- 3. Create the Error schema safely
EXEC('
    USE DWH;
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = ''Error'')
    BEGIN
        EXEC(''CREATE SCHEMA [Error]'');
    END;
');