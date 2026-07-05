# AI Assistant Usage in Student Life Analytics


## Table of Contents

1. [Data Overview](#1-data-overview)
   - 1.1 [Analytical Questions](#11-analytical-questions)
2. [Conceptual, Logical & Physical Model](#2-conceptual-logical--physical-model)
   - 2.1 [Logical Model](#21-logical-model)
   - 2.2 [Relational Model](#22-relational-model)
3. [SSIS Overview](#3-ssis-overview)
4. [Power BI Overview](#4-power-bi-overview)

---

## 1. Data Overview

The project is based on an **AI Assistance Usage in Student Life Dataset** comprising **10,000 rows**. The dataset is used to build a full-stack Business Intelligence solution using Python for EDA, SQL for Schema Creation, SSIS for ETL, and Power BI for interactive reporting.

### Data Source
- **Input Format:** CSV file
- **Columns:** SessionID, StudentLevel, Discipline, SessionDate, SessionLengthMin, TotalPrompts, TaskType, AI_AssistanceLevel, FinalOutcome, UsedAgain, SatisfactionRating

### Data Dictionary / Catalog

| Column Name | Description |
|-------------|-------------|
| SessionID | Unique identifier for each student session |
| StudentLevel | Student's academic level |
| Discipline | Academic subject area |
| SessionDate | Date when the session occurred |
| SessionLengthMin | Total session duration in minutes |
| TotalPrompts | Number of AI prompts/questions generated during the session |
| TaskType | Type of learning task |
| AI_AssistanceLevel | Level of AI assistance provided |
| FinalOutcome | Final result of the session/assignment |
| UsedAgain | Whether the student returned for another session |
| SatisfactionRating | Student satisfaction rating after session |

---

### Data Profiling Summary

| Column | Classification | Type | Unique | Nulls | Key Stats |
|--------|----------------|------|--------|-------|-----------|
| SessionID | IDENTIFIER | str | 10,000 | 0% | 100% Uppercase, Length: 12 |
| StudentLevel | CATEGORICAL | str | 3 | 0% | Undergraduate, Graduate, PhD |
| Discipline | CATEGORICAL | str | 7 | 0% | Computer Science, Psychology, Business |
| SessionDate | TEXT_DATE | str | 366 | 0% | 2024-06-24 to 2025-06-24 |
| SessionLengthMin | CONTINUOUS | float64 | 4,078 | 0% | Mean: 19.85, Skew: 1.35 |
| TotalPrompts | COUNT_DATA | int64 | 37 | 0% | Mean: 5.61, Skew: 1.77 |
| TaskType | CATEGORICAL | str | 6 | 0% | Studying, Coding, Quiz, Essay |
| AI_AssistanceLevel | ORDINAL | int64 | 5 | 0% | Mean: 3.48, Skew: -0.24 |
| FinalOutcome | CATEGORICAL | str | 4 | 0% | Completed, Failed, Withdrawn |
| UsedAgain | BINARY | bool | 2 | 0% | True/False |
| SatisfactionRating | CONTINUOUS | float64 | 41 | 0% | Mean: 3.42, Skew: -0.34 |

---

### Data Issues Found During EDA

| Issue Description | Suggested Solution |
|-------------------|-------------------|
| SessionID contains 'SESSION' prefix | Remove 'SESSION' from each row |
| SessionID data type is str | Change to int or index optimized type |
| SessionDate data type is str | Change to date type |
| AI_AssistanceLevel header formatting inconsistent | Standardize column header naming convention |

---

### 1.1 Analytical Questions

#### Q1: Session Length Optimization
> *"What is the optimal session length (SessionLengthMin) that maximizes satisfaction rating (SatisfactionRating) for students of different levels (StudentLevel), to identify the ideal session duration for each student segment?"*


---

## 2. Conceptual, Logical & Physical Model

### 2.1 Conceptual Model

The conceptual model defines the core entities, their roles, and relationships within the business context—abstracted away from technical implementation. It describes what data exists (Tables) and how it's related, without getting into physical storage or data types.

#### Conceptual ERD

<img width="1128" height="563" alt="7) Conceptual Model" src="https://github.com/user-attachments/assets/1ada65e8-ee5c-4f6b-9a32-abf42c24dca1" />


### 2.2 Logical Model

A logical model is a detailed, technology-independent representation of the data or information requirements of a system or business domain. It describes **what** data is needed and how it is structured, without specifying **how** it will be physically implemented.

<img width="871" height="430" alt="8) Logical Model" src="https://github.com/user-attachments/assets/5d59ed2d-aecf-4a01-8b8c-b923fb637761" />


### 2.3 Relational Model

<img width="1482" height="585" alt="9) Relational Model" src="https://github.com/user-attachments/assets/bcdc0171-3962-4d44-aa3e-819771d3acaf" />


| Table Name | Type | Description |
|------------|------|-------------|
| **FactSession** | Fact | Stores measurable metrics: satisfaction, session length, prompts, reuse |
| **DimDate** | Dimension | Calendar date attributes with pre-populated 2020–2030 range |
| **DimStudentLevel** | Dimension | Student academic level classifications |
| **DimDiscipline** | Dimension | Academic discipline categories |
| **DimOutcome** | Dimension | Final session outcome statuses |
| **DimTaskType** | Dimension | Task type classifications |
| **DimAIAssistanceLevel** | Dimension | AI assistance intensity levels |

**Structure Details:**

| Element | Description |
|---------|-------------|
| **Primary Keys** | Surrogate keys (NUMERIC(28) with IDENTITY) used for all tables |
| **Foreign Keys** | Defined between FactSession and all six dimensions |
| **Schema Type** | Star schema with one central fact surrounded by lookup dimensions |
| **Error Handling** | Dedicated lookup failure tables for ETL error handling |
| **Indexing** | Clustered primary keys on all tables |
| **Pre-seeding** | DimDate pre-seeded via system object cross join |

---

## 3. SSIS Overview

To build a clean, high-quality data model for analysis, a robust ETL (Extract, Transform, Load) pipeline was implemented using SQL Server Integration Services (SSIS). The pipeline processes raw flat files, performs necessary transformations and data cleansing, and loads the refined data into a structured Data Warehouse (DWH).

### ETL Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         ETL PIPELINE ARCHITECTURE                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   CSV Source ──► ODS Layer ──► Staging Layer ──► Data Warehouse Layer       │
│                                                                             │
│   ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐              │
│   │   CSV    │    │   ODS    │    │   STG    │    │   DWH    │              │
│   │  Source  │───►│  Load    │───►│  Clean   │───►│  Load    │              │
│   │  Files   │    │  Raw     │    │ & Trans  │    │  Star    │              │
│   └──────────┘    └──────────┘    └──────────┘    └──────────┘              │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Layer Descriptions

#### 1. Operational Data Store (ODS)
In the ODS layer, data from the source CSV files was loaded using Flat File Source components. This raw table preserves the original format and acts as a landing zone for further transformations.

| Component | Purpose | Key Transformations |
|-----------|---------|---------------------|
| **Flat File Source** | Read CSV data | - |
| **ODS Load** | Insert into raw table | Direct insert with minimal validation |


<img width="757" height="230" alt="1) ODS" src="https://github.com/user-attachments/assets/ee0ff31b-5cb8-4c7b-baba-b5897fa44bf2" />



<img width="520" height="251" alt="2) ODS" src="https://github.com/user-attachments/assets/a41c6dd6-8595-47ee-a027-46239d7e9295" />



#### 2. Staging Area (STG)
In the Staging layer, data was transformed and cleaned to prepare it for loading into the final warehouse schema. We are still using the **One Big Table Design Pattern**.

| Transformation | Purpose | Implementation |
|----------------|---------|----------------|
| **Derived Column** | Remove 'SESSION' word from SessionID | SESSION444 → 444 |
| **Data Conversion** | Standardize data types | All columns to DWH types |



<img width="731" height="240" alt="3) STG" src="https://github.com/user-attachments/assets/e04ca359-af0e-45f0-8cee-a9c77735a43a" />



<img width="730" height="372" alt="4) STG" src="https://github.com/user-attachments/assets/57755bde-c8fb-4cbe-a608-c3e707602c70" />



#### 3. Data Warehouse (DWH)
The final step in the ETL process was loading the clean data into the Data Warehouse layer, which follows a **star schema structure**.

| Component | Purpose | Key Features |
|-----------|---------|--------------|
| **Dimension Load** | Populate dimension tables | SCD Type 1 (overwrite) |
| **Fact Load** | Populate fact table | Insert new records |
| **Error Handling** | Log failed records | Error table for debugging |
| **Idempotency** | Truncate and reload | Ensures repeatability |

<img width="1366" height="416" alt="5) DWH" src="https://github.com/user-attachments/assets/f5192f70-a63a-4b2f-9ed2-913cce1d1273" />


<img width="908" height="368" alt="6) DWH" src="https://github.com/user-attachments/assets/0dc3ad95-5b2e-46fd-a376-19af7358bdc4" />
<img width="947" height="335" alt="7) DWH" src="https://github.com/user-attachments/assets/9a635cb1-7977-4ef6-89db-c55ff9671c5b" />
<img width="928" height="176" alt="8) DWH" src="https://github.com/user-attachments/assets/74fda6fc-391c-4865-b35b-620954ac30e0" />




---



## 4. Power BI Overview

### Dashboard Pages

#### Page 1: Landing Page

<img width="1127" height="636" alt="1" src="https://github.com/user-attachments/assets/f38cd4bf-a413-4370-8bf7-244df645c5ae" />


- **Purpose:** Navigation hub and high-level KPIs

#### Page 2: Report Purpose & Scope

<img width="1127" height="638" alt="2" src="https://github.com/user-attachments/assets/6e1b0795-e1a9-4ec7-84e1-8648fb840b4b" />


- **Purpose:** Explain report context and business questions
- **Key Visuals:** Text boxes, icons, question mapping

#### Page 3: Optimal Session Length Explorer

<img width="1127" height="634" alt="3" src="https://github.com/user-attachments/assets/d7ad7611-0f0b-4e64-ad57-9f48014996a3" />


- **Purpose:** Answer Q1 - Session length optimization
- - **Key Visuals:** KPI cards, navigation buttons, executive summary
- **Key Visuals:** Scatter plots, line charts, slicers by StudentLevel

#### Page 4: Segment Deep-Dive & Distribution

<img width="1122" height="636" alt="4" src="https://github.com/user-attachments/assets/63c8af43-d9d7-4a68-aeff-365ac789d1ca" />


- **Purpose:** Answer Q1 - Segmentation and distribution analysis
- **Key Visuals:** Bar charts, matrix visualizations, distribution plots



### DAX Measures Created

| Measure | DAX Formula | Purpose |
|---------|-------------|---------|
| Avg Satisfaction | `AVERAGE(FactSession[SatisfactionRating])` | Satisfaction tracking |
| Avg Session Length | `AVERAGE(FactSession[SessionLengthMin])` | Engagement tracking |

### Power BI Implementation Details

**Hard Parts Solved:**

| Challenge | Solution |
|-----------|----------|
| **Date Intelligence** | Created Date dimension with relationships |
| **DAX Measures** | Implemented 10+ measures for all KPIs |
| **Performance** | Optimized aggregations and query reduction |
| **Interactivity** | Slicers |
| **User Experience** | Clean design, intuitive navigation |

---

## 📊 System Architecture Summary

### Data Flow Pipeline
<img width="1263" height="634" alt="14) System Architecture" src="https://github.com/user-attachments/assets/1146161a-e60b-4bdd-b665-a9f2440d8a15" />


### Technology Stack Summary

| Phase | Tools | Purpose |
|-------|-------|---------|
| **Data Acquisition** | Kaggle, Python | Data source, EDA |
| **Data Modeling** | Draw.IO, Oracle Data Modeler | Conceptual, Logical, Relational |
| **Database** | SQL Server | ODS, STG, DWH |
| **ETL Pipeline** | SSIS | Extract, Transform, Load |
| **Analytics** | Power BI | Semantic layer, KPIs |
| **Reporting** | Power BI | Visuals, Dashboards |
| **Export** | Python | Data extraction for VM transfer |

---
