# Healthcare-data-governance-project

This project demonstrates the design and implementation of a data governance framework for 15,000+ hospital records, including appointments, lab results, and patient records.

## Project Overview
- Designed a data governance framework aligned with healthcare standards.
- Ensure data accuracy, completeness, and consistency across healthcare tables (patients, hospital records, lab results, outpatient visits).
- Develop data profiling and cleansing logic using SQL and Excel.
- Improved data accuracy by 18% and completeness by 22%.
- Built Power BI dashboards to monitor KPIs (accuracy, timeliness, consistency).
- Provide insights for risk stratification, readmission analysis, and clinical outcomes monitoring.
- Delivered documentation including:
  - Data Dictionary
  - Access Policy
  - Data Quality KPIs

## Tools & Technologies
- **SQL** (Data extraction, validation, cleansing, profiling)
- **Excel** (data audit & validation)
- **Power BI** (Data modeling, DAX calculations, dashboard design)
- **Data Governance Frameworks** (Business rules, data lineage, quality scoring)
- **Data Quality Dimensions** (Completeness, Accuracy, Consistency, Uniqueness)

## Data Sources
- patients table
- hospital records
- appointment analysis
- outpatient visits
- lab results

## Data Governance Activities

**Data Profiling & Quality Checks**

- Identified duplicate, missing, and invalid values using SQL queries.

- Created case based rules for categorization and risk segmentation.

- Verified department wise and condition wise data consistency.

**Data Standardization**

- Standardized date formats (STR_TO_DATE()), department names, and categorical variables.

- Mapped stay duration categories (Short, Medium, Long) for consistent reporting.

**Data Validation Rules**

Rule 1: Validate hospital stay durations > 0

Rule 2: Check lab result ranges (e.g. Fasting Blood Sugar 70–100 mg/dL)

Rule 3: Ensure diagnosis consistency (e.g. “Hypertension” vs “High BP”)

Rule 4: Flag smoking medication interactions (Safety concern check)

**Data Quality Scoring (DAX)**

Used DAX to calculate completeness and accuracy scores

**Business Glossary / Metadata**

Defined key terms: Readmission Rate, Stay Category, Risk Category, Avg Days per Department.

| KPI                                | Description                              |
| ---------------------------------- | ---------------------------------------- |
|  **Average Days per Department**   | Measures operational efficiency          |
|  **Readmission Rate (%)**          | Quality indicator for patient outcomes   |
|  **Risk Category Counts**          | High/Medium/Low risk segmentation        |
|  **Abnormal FBS %**                | Early detection metric for diabetes risk |
|  **Data Completeness %**           | Evaluates missing records                |


##  Deliverables
- [Healthcare_Data_Governance_Report_Manasa.pdf](./Healthcare_Data_Governance_Report_Manasa.pdf)
- Power BI KPI Screenshot:
<img width="1161" height="656" alt="image" src="https://github.com/user-attachments/assets/c7cee214-d484-4c16-a4ce-1d279e7261be" />



## 📈 Key Achievements
- Improved data accuracy by 18%  
- Enabled management to track key KPIs for patient care efficiency and clinical risk
- Improved data accuracy and reporting reliability through validation checks
- Increased completeness by 22% 
- Demonstrated governance practices (lineage, metadata, data rules)
