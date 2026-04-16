-- ================================================
-- DENTAL COMPLIANCE ANALYTICS QUERIES
-- Author: Amanda Thurman
-- Database: DSO_Analytics
-- Purpose: Identifying compliance failure patterns
-- across test types and locations to support
-- DSO infection control and patient safety programs
-- ================================================

-- Query 1: Failure Rate by Test Type
-- Business Purpose: Waterline Cleaning and Spore Testing
-- are critical infection control measures in any dental
-- practice. This query calculates the failure rate for
-- each test type to identify which compliance category
-- poses the greatest risk. A DSO managing multiple
-- locations needs this visibility to prioritize
-- corrective action and staff education.
-- 
-- Result insight: Waterline Cleaning failed at 33%
-- and Spore Testing at 26% -- both are significantly
-- above acceptable thresholds, indicating systemic
-- compliance gaps that require immediate intervention.
SELECT
test_type,
Count (*) as Total_Tests,
ROUND(SUM(Case when Result = 'Fail' Then 1 ELSE 0 END)* 100.0 / COUNT(*), 2) as Failure_Rate	
FROM compliance_tests
Group by test_type
Order by Failure_Rate DESC;

-- ================================================
-- Query 2: Failure Count by Location
-- Business Purpose: In a DSO managing multiple locations,
-- identifying which specific offices have the highest
-- compliance failure rates is critical for targeting
-- corrective action, additional staff training, and
-- resource allocation. This query ranks locations by
-- total failures so operations teams know exactly
-- where to focus first.
-- 
-- Result insight: Coastal Smiles had the highest failure
-- count at 4, making it the highest priority location
-- for compliance intervention. Lakeview and Sunrise
-- Dental had the lowest failure counts, serving as
-- benchmark locations for best practices.

SELECT
    l.location_name,
    COUNT(*) AS failures
FROM compliance_tests ct
INNER JOIN locations l ON ct.location_id = l.location_id
WHERE result = 'Fail'
GROUP BY l.location_name
ORDER BY failures DESC;

-- ================================================
-- Query 3: Location Compliance Risk Classification
-- Business Purpose: Beyond simply counting failures,
-- a DSO needs to know which locations are performing
-- WORSE than the network average. This query compares
-- each location against the average failure rate and
-- automatically classifies them as Critical, Needs
-- Attention, or Compliant. This allows regional
-- directors to prioritize interventions and allocate
-- compliance resources where they are needed most.
-- A location flagged as Critical requires immediate
-- corrective action -- failed tests, retraining, and
-- possible audit.

SELECT
    l.location_name,
    failure_count,
    CASE
        WHEN failure_count > 1 THEN 'Critical'
        WHEN failure_count = 1 THEN 'Needs Attention'
        ELSE 'Compliant'
    END AS compliance_status
FROM (
    SELECT ct.location_id,
           COUNT(*) AS failure_count
    FROM compliance_tests ct
    WHERE result = 'Fail'
    GROUP BY ct.location_id
) AS location_failures
INNER JOIN locations l ON location_failures.location_id = l.location_id
GROUP BY l.location_name
HAVING failure_count > (
    SELECT AVG(failure_count)
    FROM (
        SELECT COUNT(*) AS failure_count
        FROM compliance_tests
        WHERE result = 'Fail'
        GROUP BY location_id));
