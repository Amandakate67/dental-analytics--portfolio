-- ============================================
-- DSO Portfolio Analytics Queries
-- Author: Amanda Thurman
-- Database: Treatment_Analytics.db
-- ============================================

-- Query 1: Locations with total production above practice average
-- Uses CTE to build total production per location
-- then filters against the overall average

WITH Location_Production AS (
    SELECT location_id,
    SUM(production_amount) AS Total_Production
    FROM staff_productivity
    GROUP BY location_id
)
SELECT loc.location_name,
lp.Total_Production
FROM locations loc
INNER JOIN Location_Production lp 
    ON loc.location_id = lp.location_id
WHERE lp.Total_Production > 
    (SELECT AVG(Total_Production) FROM Location_Production)
ORDER BY lp.Total_Production DESC;


-- Query 2: Locations with no-show rate above overall average
-- Uses CTE with CASE WHEN to calculate no-show rate as a percentage
-- then filters locations above the group benchmark

WITH Location_NoShow_Rates AS (
    SELECT location_id,
    ROUND(SUM(CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) 
        *100.0/COUNT(*), 2) AS NoShow_Rate
    FROM appointments
    GROUP BY location_id
)
SELECT loc.location_name,
nsr.NoShow_Rate
FROM locations loc
INNER JOIN Location_NoShow_Rates nsr 
    ON loc.location_id = nsr.location_id
WHERE nsr.NoShow_Rate > 
    (SELECT AVG(NoShow_Rate) FROM Location_NoShow_Rates)
ORDER BY nsr.NoShow_Rate DESC;


-- Query 3: Treatment acceptance vs declined side by side per category
-- Uses CASE WHEN inside SUM to pivot accepted and declined 
-- into separate columns for each procedure category

SELECT
procedure_category,
SUM(CASE WHEN accepted_or_declined = 'Accepted' 
    THEN treatment_amount ELSE 0 END) AS Accepted_Amount,
SUM(CASE WHEN accepted_or_declined = 'Declined' 
    THEN treatment_amount ELSE 0 END) AS Declined_Amount
FROM patient_treatments
GROUP BY procedure_category
ORDER BY procedure_category ASC;


-- Query 4: Providers above average total production
-- Uses CTE to build total production per provider
-- then joins to providers table for names

WITH Provider_Production AS (
    SELECT provider_id,
    SUM(production_amount) AS Total_Production
    FROM staff_productivity
    GROUP BY provider_id
)
SELECT p.provider_name,
pp.Total_Production
FROM providers p
INNER JOIN Provider_Production pp 
    ON p.provider_id = pp.provider_id
WHERE pp.Total_Production > 
    (SELECT AVG(Total_Production) FROM Provider_Production)
ORDER BY pp.Total_Production DESC;


-- Query 5: Top decline reasons with recommended actions
-- Joins patient_treatments to decline_reasons
-- to show what patients declined and what providers should do

SELECT 
dr.reason_category,
dr.recommended_action,
COUNT(*) AS Decline_Count
FROM patient_treatments pt
INNER JOIN decline_reasons dr
    ON pt.decline_reason_id = dr.reason_id
WHERE pt.accepted_or_declined = 'Declined'
GROUP BY dr.reason_category, dr.recommended_action
ORDER BY Decline_Count DESC;
