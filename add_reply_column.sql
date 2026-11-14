-- Add Reply column to ReportIssue table
-- Run this script in your SQL Server database

USE JourneyX;
GO

-- Check if the Reply column already exists
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'ReportIssue' AND COLUMN_NAME = 'Reply')
BEGIN
    -- Add the Reply column
    ALTER TABLE ReportIssue 
    ADD Reply NVARCHAR(MAX) NULL;
    
    PRINT 'Reply column added successfully to ReportIssue table';
END
ELSE
BEGIN
    PRINT 'Reply column already exists in ReportIssue table';
END
GO
