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
    
---------------------------------------------------------------------------------
    
-- Query 2: Providers above average total production
-- Uses CTE to build total production per provider
-- Window function ranks providers highest to lowest
-- WHERE filters only above average producers

WITH Provider_Production AS (
    SELECT
    provider_id,
    SUM(treatment_amount) AS Total_Production
    FROM patient_treatments
    GROUP BY provider_id
)
SELECT
dr.provider_name,
dr.specialty,
Total_Production,
RANK() OVER (ORDER BY Total_Production DESC) AS Provider_Rank
FROM providers dr
INNER JOIN Provider_Production 
    ON dr.provider_id = Provider_Production.provider_id
WHERE Total_Production > (SELECT AVG(Total_Production) FROM Provider_Production);
GO

-----------------------------------------------------------------------------------
    
-- Query 3: Providers with no-show rate above overall average
-- Uses CTE with CASE WHEN to calculate no-show rate per provider
-- Filters providers above the group benchmark
-- SQL Server syntax with CAST and DECIMAL

WITH No_ShowRate AS (
    SELECT
    appt.provider_id,
    CAST(ROUND(SUM(CASE WHEN no_show = 'Yes' 
        THEN 1 ELSE 0 END) *100.0/COUNT(*), 2) 
        AS DECIMAL(10,2)) AS No_Show_Rate
    FROM appointments appt
    GROUP BY appt.provider_id
)
SELECT
dr.provider_name,
dr.specialty,
No_Show_Rate
FROM providers dr
JOIN No_ShowRate nsr ON dr.provider_id = nsr.provider_id
WHERE No_Show_Rate > (SELECT AVG(No_Show_Rate) FROM No_ShowRate)
ORDER BY No_Show_Rate DESC;
GO

-----------------------------------------------------------------------------------
-- Query 4: Provider performance scorecard
-- CTE builds total production per provider
-- RANK window function ranks highest to lowest
-- CASE WHEN labels above or below practice average
-- SQL Server syntax with CAST and DECIMAL

WITH Total_Pract AS (
    SELECT
    pt.provider_id,
    SUM(treatment_amount) AS Total_Production
    FROM patient_treatments pt
    GROUP BY pt.provider_id
)
SELECT
dr.provider_name,
dr.specialty,
Total_Production,
RANK() OVER (ORDER BY Total_Production DESC) AS Rank_Production,
CASE WHEN Total_Production > (SELECT AVG(Total_Production) FROM Total_Pract)
    THEN 'Above Average'
    ELSE 'Below Average'
    END AS Performance
FROM providers dr
JOIN Total_Pract tp ON dr.provider_id = tp.provider_id;
GO

-----------------------------------------------------------------------------------------

-- Query 5: Insurance carrier collection rate analysis
-- Shows total billed, insurance paid, patient portion
-- and collection rate as a percentage per carrier
-- Collection rate = (insurance paid + patient portion) / total billed
-- SQL Server syntax with CAST and DECIMAL

SELECT
ic.insurance_carrier,
SUM(ic.billed_amount) AS Total_Amount_Billed,
SUM(ic.insurance_paid) AS Paid_By_Insurance,
SUM(ic.patient_portion) AS Total_Pt_Portion,
CAST(ROUND(
    (SUM(ic.insurance_paid + ic.patient_portion))
    * 100.0 / SUM(ic.billed_amount)
, 2) AS DECIMAL(10,2)) AS Collection_Rate
FROM insurance_claims ic
GROUP BY ic.insurance_carrier
ORDER BY Collection_Rate DESC;
GO

-----------------------------------------------------------------------------------------
-- Query 6: Outstanding balance by insurance carrier
-- Joins payments to insurance_claims to get carrier names
-- Filters to insurance payer only with outstanding balance > 0
-- Shows what each carrier still owes the practice

SELECT
ic.insurance_carrier,
SUM(p.outstanding_balance) AS Total_Outstanding
FROM payments p
JOIN insurance_claims ic ON p.patient_id = ic.patient_id
WHERE p.outstanding_balance > 0
AND p.payer = 'Insurance'
GROUP BY ic.insurance_carrier
ORDER BY Total_Outstanding DESC;
GO

------------------------------------------------------------------------------------------

-- Query 7: Location no-show rate ranking
-- CTE builds total appointments, total no-shows, and no-show rate per location
-- RANK window function orders locations by no-show rate highest to lowest
-- WHERE filters active locations only
-- SQL Server syntax with CAST and DECIMAL

WITH Rate_Table AS (
    SELECT
    apt.location_id,
    COUNT(*) AS Total_Appointments,
    SUM(CASE WHEN apt.no_show = 'Yes' 
        THEN 1 ELSE 0 END) AS Total_NoShows,
    CAST(ROUND(SUM(CASE WHEN apt.no_show = 'Yes'
        THEN 1 ELSE 0 END) *100.0/COUNT(*), 2)
        AS DECIMAL(10,2)) AS No_Show_Rate
    FROM appointments apt
    GROUP BY apt.location_id
)
SELECT
loc.location_name,
rt.Total_Appointments,
rt.Total_NoShows,
rt.No_Show_Rate,
RANK() OVER (ORDER BY rt.No_Show_Rate DESC) AS Location_Rank
FROM locations loc
JOIN Rate_Table rt ON loc.location_id = rt.location_id
WHERE loc.active = 'Yes'
GROUP BY loc.location_name, rt.Total_Appointments,
rt.Total_NoShows, rt.No_Show_Rate
ORDER BY Location_Rank;
GO
