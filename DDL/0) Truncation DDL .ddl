-- Truncate ODS Database Tables
USE ODS;
GO
TRUNCATE TABLE DB.RawSessionData;
GO

-- Truncate STG Database Tables
USE STG;
GO
TRUNCATE TABLE DB.CleanedSessionData;
GO

-- Truncate DWH Database Tables (in proper order to avoid foreign key conflicts)
USE DWH;
GO

-- First truncate the Fact table (child tables)
TRUNCATE TABLE DB.FactSession;
GO

-- Then truncate all Dimension tables (parent tables)
-- TRUNCATE TABLE DB.DimDate;
-- GO
TRUNCATE TABLE DB.DimOutcome;
GO
TRUNCATE TABLE DB.DimAIAssistanceLevel;
GO
TRUNCATE TABLE DB.DimTaskType;
GO
TRUNCATE TABLE DB.DimDiscipline;
GO
TRUNCATE TABLE DB.DimStudentLevel;
GO



-- Then truncate all Lookup Error Tables
TRUNCATE TABLE [Error].[Task Type Dimension lookup Error];
GO

TRUNCATE TABLE [Error].[Outcome Dimension lookup Error];
GO

TRUNCATE TABLE [Error].[Date Dimension lookup Error];
GO

TRUNCATE TABLE [Error].[Student Level Dimension lookup Error];
GO

TRUNCATE TABLE [Error].[Student Discipline Dimension lookup Error];
GO

TRUNCATE TABLE [Error].[AIAssistanceLevel Dimension lookup Error];
GO