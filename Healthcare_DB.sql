#MFind all the patient's records in the appointments table
SELECT * FROM healthcare_database.`appointment analysis`;

# Find the patient ID of patients who had an appointment in the pediatrics department
SELECT patient_id FROM healthcare_database.`appointment analysis`
WHERE department_name = 'Pediatrics';

# Find out how many days on average the patients spent in the Cardiology department of the hospital
SELECT AVG(Days_in_the_hospital) AS average_days_cardiology
FROM healthcare_database.`hospital records`
WHERE department_name = 'Cardiology';

# Compare the average number of days the patients are spending in each department of the hospital
SELECT department_name,AVG(days_in_the_hospital) AS avg_days_per_department
FROM healthcare_database.`hospital records`
GROUP BY department_name
ORDER BY avg_days_per_department DESC ;

# Categorize patients based on their length of stay in the hospital

SELECT
ï»¿patient_id,
days_in_the_hospital,
CASE
WHEN days_in_the_hospital <=3 THEN 'Short'
WHEN days_in_the_hospital <= 5 THEN 'Medium'
ELSE 'Long'
END AS stay_category
FROM healthcare_database.`hospital records`

# Count the number of patients in each category created

SELECT
CASE
WHEN days_in_the_hospital <=3 THEN 'Short'
WHEN days_in_the_hospital <= 5 THEN 'Medium'
ELSE 'Long'
END AS stay_category,
COUNT(*) AS number_of_records
FROM healthcare_database.`hospital records`
GROUP BY
CASE
WHEN days_in_the_hospital <=3 THEN 'Short'
WHEN days_in_the_hospital <= 5 THEN 'Medium'
ELSE 'Long'
END;


# Extract the day of the week from the "appointment_date" column in integer

SELECT
  appointment_date,
  STR_TO_DATE(appointment_date, '%d/%m/%Y') AS converted_date
FROM `healthcare_database`.`appointment analysis`
LIMIT 10;

# Which patients on the "patients" table were hospitalized and for how many days

SELECT
p.ï»¿patient_id,
days_in_the_hospital
FROM
`healthcare_database`.`patients table` AS p
INNER JOIN `healthcare_database`.`hospital records` AS hr
ON p.ï»¿patient_id = hr.ï»¿patient_id

# Flag patients who are at risk due to interaction between their medication and smoking status

SELECT
patient_id,
diagnosis,
medication_prescribed,
smoker_status,
CASE
WHEN smoker_status = 'Y' AND medication_prescribed IN ('Insulin', 'Metformin', 'Lisinopril')
THEN 'Potential Safety Concern: Smoking and Medication Interactions'
ELSE 'No Safety Concern Identified'
END AS 'safety_concern'
FROM healthcare_database.`outpatient visits`;


# Classify patients into high, medium or low risk based on their BMI and family risk of hypertension

SELECT
ï»¿patient_id,
patient_name,
bmi,
family_history_of_hypertension,
CASE
WHEN bmi >= 30 AND family_history_of_hypertension = 'Yes' THEN 'High Risk'
WHEN bmi >= 25 AND family_history_of_hypertension = 'Yes' THEN 'Medium Risk'
ELSE 'Low Risk'
END risk_category
FROM `healthcare_database`.`hospital records`;


# Create a series of CASE statements to predict the likelihood of hypertension development based on
#patient's age, BMI and family history of hypertension

# Exclude children from this model*/

SELECT
p.ï»¿patient_id,
p.patient_name,
CASE
WHEN family_history_of_hypertension = 'Yes' THEN 1
WHEN family_history_of_hypertension = 'No' THEN 0
END AS family_history_of_hypertension,
CASE
WHEN BMI < 18.5 THEN 'Underweight'
WHEN BMI >= 18.5 AND BMI < 25 THEN 'Normal'
WHEN BMI >= 25 AND BMI <30 THEN 'Overweight'
ELSE 'Obese'
END AS bmi_category,
CASE
WHEN DATEDIFF(year, date_of_birth, getdate()) >= 50 THEN 1
ELSE 0
END AS age_over_50,
CASE
WHEN (family_history_of_hypertension = 'Yes' OR DATEDIFF(year, date_of_birth, getdate()) >= 50) AND BMI >=30
THEN 'High Risk'
WHEN (family_history_of_hypertension = 'Yes' OR DATEDIFF(year, date_of_birth, getdate()) >= 50) AND BMI >=25
AND BMI <30 THEN 'Medium Risk'
ELSE 'Low Risk'
END hypertension_prediction
FROM 
healthcare_database.`patients table` AS p
INNER JOIN healthcare_database.`hospital records` AS hr
ON p.ï»¿patient_id = hr.patient_id;

/*SOLUTION: Identify individuals at high risk of developing diabetes within a population based on smoker
#status and glucose levels

Individuals who are smokers and have glucose level more or equal to 126 are considered at High Risk
-Individuals who are smokers and have glucose level more or equal to 100, but less than 126 are considered 
  at Medium Risk
- Everyone else is Low Risk*/


SELECT
CASE
WHEN smoker_status = 'Y' OR result_value >= 126 THEN 'High Risk for Diabetes'
WHEN smoker_status = 'Y' OR (result_value >=100 AND result_value <126) THEN 'Medium Risk for Diabetes'
ELSE 'Low Risk for Diabetes'
END AS risk_category,
COUNT(*) AS population_count
FROM
healthcare_database.`outpatient visits` AS ov
INNER JOIN healthcare_database.`lab results` AS lr
ON ov.ï»¿visit_id = lr.visit_id
WHERE test_name = 'fasting blood sugar'
GROUP BY
CASE
WHEN smoker_status = 'Y' OR result_value >= 126 THEN 'High Risk for Diabetes'
WHEN smoker_status = 'Y' OR (result_value >=100 AND result_value <126) THEN 'Medium Risk for Diabetes'
ELSE 'Low Risk for Diabetes'
END;

# Identify the readmission rates per department

SELECT
department_name,
COUNT(ï»¿patient_id) AS total_patients,
COUNT(CASE WHEN days_in_the_hospital > 1 THEN ï»¿patient_id END) AS readmitted_patients,
(COUNT(CASE WHEN days_in_the_hospital > 1 THEN ï»¿patient_id END) *100.0)/COUNT(ï»¿patient_id) AS readmission_rate
FROM healthcare_database.`hospital records`
GROUP BY department_name;

# What are the most commonly ordered lab tests?

SELECT
test_name,
COUNT(*) AS test_count
FROM healthcare_database.`lab results`
GROUP BY test_name
ORDER BY test_count DESC;

/*Typically, fasting blood sugar levels falls between 70-100 mg/dL. Our goal is to identify patients 
whose lab results are outside this normal range to implement early intervention.*/

SELECT
p.ï»¿patient_id,
p.patient_name,
result_value
FROM healthcare_database.`patients table` AS p
INNER JOIN healthcare_database.`outpatient visits` AS ov
ON p.ï»¿patient_id = ov.patient_id
INNER JOIN healthcare_database.`lab results` AS lr
ON ov.ï»¿visit_id= lr.visit_id
WHERE lr.test_name = 'Fasting Blood Sugar'
AND (lr.result_value < 70 OR lr.result_value >100)

/* Assess how many patients are considered High, Medium, and Low Risk.

High Risk: patients who are smokers and have been diagnosed with either hypertension or diabetes.
Medium Risk: patients who are non-smokers and have been diagnosed with either hypertension or diabetes.
Low Risk: patients who do not fall into the High or Medium Risk categories. This includes patients who are not
smokers and do not have a diagnosis of hypertension or diabetes.*/


SELECT
CASE
WHEN smoker_status = 'Y' AND (diagnosis = 'Hypertension' OR diagnosis = 'Diabetes') THEN 'High Risk'
WHEN smoker_status = 'N' AND (diagnosis = 'Hypertension' OR diagnosis = 'Diabetes') THEN 'Medium Risk'
ELSE 'Low Risk'
END AS Risk_category,
COUNT(patient_id) AS num_patients
FROM healthcare_database.`outpatient visits`
GROUP BY
CASE
WHEN smoker_status = 'Y' AND (diagnosis = 'Hypertension' OR diagnosis = 'Diabetes') THEN 'High Risk'
WHEN smoker_status = 'N' AND (diagnosis = 'Hypertension' OR diagnosis = 'Diabetes') THEN 'Medium Risk'
ELSE 'Low Risk'
END


