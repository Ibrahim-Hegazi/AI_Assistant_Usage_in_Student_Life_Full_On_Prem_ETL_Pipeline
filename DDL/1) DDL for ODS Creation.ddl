-- 1. Create the new database
CREATE DATABASE ODS;

-- you may need to switch context to the new database before executing the next steps.
USE ODS;

-- 2. Create the required schemas
CREATE SCHEMA DB;
CREATE SCHEMA Error;

-- 3. Create the big table within the DB schema
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