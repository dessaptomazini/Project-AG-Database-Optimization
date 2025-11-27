![Power Bi](https://img.shields.io/badge/power_bi-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Microsoft Excel](https://img.shields.io/badge/Microsoft_Excel-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white)
![SharePoint](https://img.shields.io/badge/SharePoint-0078D4?style=for-the-badge&logo=microsoft-sharepoint&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![Power Query](https://img.shields.io/badge/Power_Query-000000?style=for-the-badge&logo=json&logoColor=white)

📊 5-Year Financial & Legal Data Centralization & Cleansing Project

🎯 The Business Challenge

The Legal Department struggled to consolidate tax credit data scattered across multiple decentralized monthly spreadsheets. The critical pain points were:

Entity Duplication & Inconsistency: The same client appeared with different naming conventions across files (e.g., "Company X Ltd", "Company X", "Company X - 123"), making a consolidated view impossible.

Manual Process & Blind Spots: For 5 years, the lack of a centralized dashboard prevented any strategic analysis regarding finance, workload volume, or demand seasonality.

Complex Data Integration: inability to cross-reference Legal Proceedings data (internal database) with Billing & Fees data (external financial dataset) due to the lack of standardized unique keys.

💡 The Solution

I developed an End-to-End BI Solution with a heavy focus on Data Engineering within Power Query to guarantee information integrity before any visualization took place.

🛠️ Key Techniques Implemented

1. Automated ETL (SharePoint Integration) I implemented a direct connection to the company's SharePoint Folder. I wrote a custom M Language Script that:

Automatically detects new monthly files (.xlsx).

Filters out temporary or control files.

Combines data into a single Fact Table (fBaseCreditos).

Zero-Touch Update: The system is 100% automated; users simply save the file in the folder, and the dashboard updates.

2. Client Standardization Algorithm (Deduplication Logic) To solve the naming duplication, I created advanced logic in Power Query (Dim_Customers_Final) acting as a Master Data Management (MDM) layer:

Unique Identification: Scans for unique Tax IDs (CNPJs) across the entire dataset.

Grouping & Selection: Groups all naming variations for a specific ID and applies logic to automatically select the most complete name (longest string) as the "Official Name".

Sanitization: Performs robust cleaning of special characters and unwanted numbers.

New Entry Handling: Identifies and cleans new clients/CNPJs before they enter the Fact Table to prevent contamination.

Result: A clean, unique Customer Dimension that feeds back into the Fact Table, eliminating duplicates in reports.

3. Data Modeling (Star Schema & Bridge Tables)

Implementation of a standard Star Schema with a dedicated Date Dimension (dCalendar).

Complex Relationship Handling: Solved "Many-to-Many" relationships between Invoices and Lawsuits using a Bridge Table of unique IDs (Dim_CNPJ_CPF) created via DAX, ensuring accurate cross-filtering.

🛡️ Governance & Data Quality Control (DQC)

To ensure trust in the data, I built an exclusive Data Quality Dashboard:

Audit & Lineage:

Source Traceability: Implemented metadata columns in Power Query to track exactly which monthly file (e.g., "AUGUST 2025.xlsx") every single record originated from.

Anomaly Detection:

Monitoring of invalid or null Tax IDs.

Cross-validation between the Credit Base and the Invoices Base.

Visual alerts for records that failed automatic standardization.

Algorithmic Data Healing:

Reverse Filling: A logic that uses the validated historical customer base (Dim_Customers_Final) to automatically backfill missing information (such as null IDs in older records) in the Fact Table based on the client's name match.

📂 Repository Structure

Note: This repository contains only logic scripts due to data confidentiality (NDA).

ETL_Client_Standardization.m: Logic for client cleaning and deduplication.

ETL_Auto_Ingestion.m: Script for SharePoint connection and file combination.

Measures_and_Modeling.dax: Key metrics and calculated tables.
