
# COVID-19 Data Analysis Project

This project analyzes global COVID-19 data to track cases, deaths, vaccinations, and their relationship to population demographics.

## 📌 Project Overview
- Analyzes COVID-19 trends using SQL queries
- Calculates key metrics like death rates, infection rates, and vaccination progress
- Uses joins, CTEs, temp tables, and views for complex analysis
- Focuses on country-level and continent-level insights

## 🛠️ Technologies Used
- Microsoft SQL Server
- T-SQL (Transact-SQL)
- Data visualization-ready outputs

## 📂 Database Tables
1. `CovidDeaths$` - Case and mortality data
2. `CovidVaccinations$` - Vaccination rollout data

## 🔍 Key Analyses

### 1. Basic Data Exploration
```sql
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM portfolioproject..CovidDeaths$
ORDER BY 1,2
