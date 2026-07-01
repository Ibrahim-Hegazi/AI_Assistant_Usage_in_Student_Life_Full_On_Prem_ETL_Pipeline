USE DWH;
GO

-- FactSession
IF OBJECT_ID('DB.FactSession', 'U') IS NOT NULL
    DROP TABLE DB.FactSession;

CREATE TABLE DB.FactSession 
    (
     FactSession_SK NUMERIC (28) NOT NULL IDENTITY(1,1) ,
     SatisfactionRating FLOAT , 
     DimStudent_SK NUMERIC (28) NOT NULL , 
     DimOutcome_SK NUMERIC (28) NOT NULL , 
     DimTaskType_SK NUMERIC (28) NOT NULL , 
     DimSession_SK NUMERIC (28) NOT NULL , 
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
    ADD CONSTRAINT FactSession_DimSession_FK FOREIGN KEY (DimSession_SK) 
    REFERENCES DB.DimSession (DimSession_SK) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION;

ALTER TABLE DB.FactSession 
    ADD CONSTRAINT FactSession_DimStudent_FK FOREIGN KEY (DimStudent_SK) 
    REFERENCES DB.DimStudent (DimStudent_SK) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION;

ALTER TABLE DB.FactSession 
    ADD CONSTRAINT FactSession_DimTaskType_FK FOREIGN KEY (DimTaskType_SK) 
    REFERENCES DB.DimTaskType (DimTaskType_SK) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION;
*/