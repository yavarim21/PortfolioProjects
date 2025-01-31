--select data that we are going to be used  total_cases,population
select total_cases,population
from portfolioproject..CovidDeaths$


select * 
from portfolioproject..CovidDeaths$

select Location,date, new_cases, total_deaths, population
From portfolioproject..CovidDeaths$
order by 3,4 

--looking at total cases/total Death
--show Likelihood of dying  if you contract covid in your country 

select Location,date, total_deaths, population,total_cases,(total_deaths/total_cases)*100 as DeathPercentage
From portfolioproject..CovidDeaths$
order by 1,2

SELECT 
    Location, 
    date, 
    total_deaths, 
    population, 
    total_cases, 
    CASE 
        WHEN total_cases = 0 THEN 0 -- Avoid division by zero
        ELSE (total_deaths * 100.0 / total_cases) -- Ensure float division
    END AS DeathPercentage
FROM 
    portfolioproject..CovidDeaths$
ORDER BY 
    Location, date;
------------------------unitedStates-----------------
	SELECT 
    Location, 
    date, 
    TRY_CONVERT(INT, total_deaths) AS total_deaths, 
    TRY_CONVERT(BIGINT, population) AS population, 
    TRY_CONVERT(INT, total_cases) AS total_cases, 
    CASE 
        WHEN TRY_CONVERT(INT, total_cases) = 0 OR TRY_CONVERT(INT, total_cases) IS NULL THEN 0 
        ELSE CAST(TRY_CONVERT(INT, total_deaths) * 100.0 / TRY_CONVERT(INT, total_cases) AS DECIMAL(10,2)) 
    END AS DeathPercentage
FROM 
    portfolioproject..CovidDeaths$
WHERE 
    Location LIKE '%states%'  
ORDER BY 
    Location, date;



	--- looking at total cases / population 
		SELECT Location, 
       date, 
       population, 
       total_cases, 
       (total_cases / population) * 100 AS CovidCasesPercentage
FROM portfolioproject..CovidDeaths$
WHERE Location LIKE '%states%' 
  AND date BETWEEN '2021-01-01' AND '2022-12-31'
ORDER BY Location, date;

--Looking at countries with the highest infection Rate compared to population 

SELECT Location,  
       population, 
       MAX(total_cases) as HighestInfectionCount, 
       MAX(total_cases / population) * 100 AS PercentPopulationInfected
FROM portfolioproject..CovidDeaths$
Group by Location,population
ORDER BY PercentPopulationInfected 

--Showing countries with the highest rate of Death over population

SELECT Location,  
       population, 
       MAX(cast(total_deaths as int)) as HighestDeathsCount, 
       MAX(total_deaths / population) * 100 AS Deathrate
FROM portfolioproject..CovidDeaths$
Group by Location,population
ORDER BY Deathrate 


---continent -----------
SELECT  continent,
       population, 
       MAX(cast(total_deaths as int)) as HighestDeathsCount, 
       MAX(total_deaths / population) * 100 AS Deathrate
FROM portfolioproject..CovidDeaths$
Group by Location,population
ORDER BY Deathrate 

------------------------------------------------
select *
from portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
----------------------------------------------------

select dea.location, dea.date,dea.population,vac.new_vaccinations
from portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
order by 1,2
------------------------------------
---Looking at total population vs vaccination
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
from portfolioproject..CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date


select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.Date) as RollingPeopleVaccinated

from portfolioproject .. CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

---Use CTE ...(Common Table Expression)
 
 with PopvsVac (Continent,location,Date,Population,new_vaccinations,RollingPeopleVaccinated)

 as (select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.Date) as RollingPeopleVaccinated

from portfolioproject .. CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select * ,(RollingPeopleVaccinated/Population)*100 as percentageofRolling
from PopvsVac

---Create TeMP Table

Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population Numeric,
New_Vaccinations Numeric,
RollingPeopleVaccinated numeric)
Insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.Date) as RollingPeopleVaccinated

from portfolioproject .. CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date

select *,(RollingPeopleVaccinated/population)*100
 from #PercentPopulationVaccinated

 --Creating view to store data for later visualisation 
create view PercentPopulationVaccinated as 
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.Date) as RollingPeopleVaccinated

from portfolioproject .. CovidDeaths$ dea
join portfolioproject..CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null

select * from PercentPopulationVaccinated


 