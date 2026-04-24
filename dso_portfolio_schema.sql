-- ============================================
-- DSO Portfolio Database Schema
-- Author: Amanda Thurman
-- Database: Treatment_Analytics.db
-- 12 tables covering full dental practice lifecycle
-- ============================================

CREATE TABLE locations (
    location_id INTEGER,
    location_name TEXT,
    city TEXT,
    state TEXT,
    region TEXT,
    market_type TEXT,
    opening_date DATE,
    total_operatories INTEGER,
    hygiene_chairs INTEGER,
    doctor_chairs INTEGER,
    office_manager TEXT,
    monthly_rent INTEGER,
    square_footage INTEGER,
    active TEXT
);

CREATE TABLE providers (
    provider_id INTEGER,
    provider_name TEXT,
    specialty TEXT,
    location TEXT,
    location_id INTEGER
);

CREATE TABLE patients (
    patient_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    age INTEGER,
    gender TEXT,
    insurance_type TEXT
);

CREATE TABLE patient_treatments (
    treatment_id INTEGER,
    patient_id INTEGER,
    provider_id INTEGER,
    location_id INTEGER,
    procedure_category TEXT,
    treatment_amount REAL,
    accepted_or_declined TEXT,
    decline_reason_id INTEGER,
    treatment_date DATE
);

CREATE TABLE decline_reasons (
    reason_id INTEGER,
    reason_category TEXT,
    reason_description TEXT,
    recommended_action TEXT
);

CREATE TABLE appointments (
    appointment_id INTEGER,
    patient_id INTEGER,
    provider_id INTEGER,
    location_id INTEGER,
    appointment_date DATE,
    appointment_time TEXT,
    appointment_type TEXT,
    department TEXT,
    status TEXT,
    confirmed TEXT,
    no_show TEXT,
    cancellation_reason TEXT,
    scheduled_duration_min INTEGER,
    actual_duration_min INTEGER
);

CREATE TABLE insurance_claims (
    claim_id INTEGER,
    patient_id INTEGER,
    provider_id INTEGER,
    location_id INTEGER,
    treatment_id INTEGER,
    claim_date DATE,
    insurance_carrier TEXT,
    procedure_code TEXT,
    billed_amount REAL,
    allowed_amount REAL,
    insurance_paid REAL,
    patient_portion REAL,
    claim_status TEXT,
    denial_reason TEXT,
    submission_date DATE,
    payment_date DATE,
    days_to_payment INTEGER
);

CREATE TABLE front_desk_workflow (
    workflow_id INTEGER,
    patient_id INTEGER,
    appointment_id INTEGER,
    insurance_verified TEXT,
    treatment_plan_presented TEXT,
    financial_arrangement TEXT,
    payment_plan_offered TEXT,
    follow_up_call_made TEXT,
    follow_up_call_date DATE,
    patient_response TEXT,
    notes TEXT
);

CREATE TABLE patient_behavior (
    behavior_id INTEGER,
    patient_id INTEGER,
    age_group TEXT,
    insurance_type TEXT,
    total_visits INTEGER,
    recall_compliant TEXT,
    last_visit_date DATE,
    months_since_last_visit INTEGER,
    treatment_acceptance_rate REAL,
    elective_acceptance TEXT,
    urgent_acceptance TEXT,
    preferred_contact TEXT,
    patient_since_year INTEGER
);

CREATE TABLE recall_list (
    recall_id INTEGER,
    patient_id INTEGER,
    provider_id INTEGER,
    last_hygiene_date DATE,
    recall_interval_months INTEGER,
    next_due_date DATE,
    overdue TEXT,
    contact_attempts INTEGER,
    last_contact_date DATE,
    contact_method TEXT,
    recall_outcome TEXT,
    appointment_scheduled TEXT,
    scheduled_date DATE
);

CREATE TABLE staff_productivity (
    productivity_id INTEGER,
    provider_id INTEGER,
    location_id INTEGER,
    work_date DATE,
    hours_worked REAL,
    patients_seen INTEGER,
    production_amount REAL,
    production_per_hour REAL,
    chair_time_used_min INTEGER,
    chair_time_available_min INTEGER,
    utilization_rate REAL,
    new_patients INTEGER,
    hygiene_patients INTEGER,
    doctor_patients INTEGER
);

CREATE TABLE payments (
    payment_id INTEGER,
    patient_id INTEGER,
    claim_id INTEGER,
    treatment_id INTEGER,
    payment_date DATE,
    payment_amount REAL,
    payment_method TEXT,
    payer TEXT,
    total_billed REAL,
    total_collected REAL,
    outstanding_balance REAL,
    payment_plan TEXT,
    payment_plan_installment INTEGER
);

CREATE TABLE treatment_notes (
    note_id INTEGER,
    patient_id INTEGER,
    treatment_id INTEGER,
    provider_id INTEGER,
    note_date DATE,
    urgency_level TEXT,
    treatment_type TEXT,
    medical_alert TEXT,
    perio_risk TEXT,
    caries_risk TEXT,
    follow_up_required TEXT,
    follow_up_timeframe TEXT,
    provider_notes TEXT
);
