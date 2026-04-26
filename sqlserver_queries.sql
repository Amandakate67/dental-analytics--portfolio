-- ============================================================
-- DSO Analytics Queries -- SQL Server Express
-- Author: Amanda Thurman
-- Database: TreatmentAnalytics
-- Note: SQL Server syntax -- use TOP instead of LIMIT
--       CAST/DECIMAL instead of ROUND for precise decimals
-- ============================================================

USE TreatmentAnalytics;
GO

-- Query 1: Locations with no-show rate above overall average
-- Uses CTE with CASE WHEN to calculate no-show rate per location
-- Filters locations above the group benchmark

WITH Location_Performance AS (
    SELECT
    a.location_id,
    CAST(ROUND(SUM(CASE WHEN a.no_show = 'Yes' 
        THEN 1 ELSE 0 END) *100.0/COUNT(*), 2) 
        AS DECIMAL(10,2)) AS NoShow_Rate
    FROM appointments a
    GROUP BY a.location_id
)
SELECT
l.location_name,
lp.NoShow_Rate
FROM locations l
INNER JOIN Location_Performance lp 
    ON l.location_id = lp.location_id
WHERE lp.NoShow_Rate > (SELECT AVG(NoShow_Rate) FROM Location_Performance)
ORDER BY lp.NoShow_Rate DESC;
GO
