-- Query 1: Top Decline Reasons by Procedure
-- Business Purpose: Identifies why patients decline
-- specific procedures so providers can adjust their
-- case presentation approach and recover lost production.

SELECT
procedure_category,
reason_category,
Count(*) as Decline_Count,
recommended_action

FROM providers Dr
INNER JOIN  patient_treatments tx ON Dr.provider_id = tx.provider_id
INNER JOIN decline_reasons ON tx.decline_reason_id = decline_reasons.reason_id

WHERE accepted_or_declined = 'Declined'

Group by procedure_category, recommended_action

ORDER BY Decline_Count DESC;
