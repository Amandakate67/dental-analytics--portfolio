--DSO Analytics Database
--Author: Amanda Thurman
--Description: Multi-location dental DSO database tracking
--providers, patients, locations, treatments, and compliance
--tracking data. Built from 16+ years clinical experience.
--Created: April 2026

CREATE TABLE locations(
location_id INTEGER,
location_name TEXT,
city TEXT,
state TEXT,
region TEXT,
opening_date date)
CREATE TABLE providers(
provider_id INTEGER,
location_id INTEGER,
provider_name TEXT,
provider_type TEXT,
hire_date DATE)
CREATE TABLE patients(
patient_id INTEGER,
location_id INTEGER,
first_name TEXT,
last_name TEXT,
age INTEGER,
gender TEXT,
insurance_type TEXT)
CREATE TABLE treatments(
treatment_id INTEGER,
patient_id INTEGER,
provider_id INTEGER,
procedure_category TEXT,
treatment_amount REAL,
accepted_or_declined TEXT,
treatment_date DATE)
CREATE TABLE compliance_tests(
test_id INTEGER,
location_id INTEGER,
test_date DATE,
test_type TEXT,
result TEXT,
bacteria_count REAL,
corrective_action TEXT)
