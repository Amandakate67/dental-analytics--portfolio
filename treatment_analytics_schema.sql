-- ================================================
-- TREATMENT ANALYTICS DATABASE
-- Author: Amanda Thurman
-- Description: Three table database tracking dental
-- treatment acceptance and decline reasons with
-- provider specialty and recommended patient actions.
-- Built from 16+ years of clinical dental experience.
-- Created: April 2026
-- ================================================

CREATE TABLE decline_reasons (
    reason_id INTEGER,
    reason_category TEXT,
    reason_description TEXT,
    recommended_action TEXT
)
CREATE TABLE providers (
    provider_id INTEGER,
    provider_name TEXT,
    specialty TEXT,
    location TEXT
)
CREATE TABLE patient_treatments (
    treatment_id INTEGER,
    patient_id INTEGER,
    provider_id INTEGER,
    procedure_category TEXT,
    treatment_amount REAL,
    accepted_or_declined TEXT,
    decline_reason_id INTEGER,
    treatment_date DATE
)
