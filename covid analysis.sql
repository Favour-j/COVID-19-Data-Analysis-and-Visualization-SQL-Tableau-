--SELECT * 
--FROM projectd..[Covid  Vaccinations]
--ORDER BY 3,4


SELECT * 
FROM projectd..[Covid Deaths]
Where continent is not null
ORDER BY 3,4



SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM projectd..[Covid Deaths]
order by 1,2



SELECT Location, date, total_cases, total_deaths, (CONVERT(FLOAT,total_deaths) / NULLIF(CONVERT(FLOAT,total_cases), 0))* 100 AS Deathpercentage
FROM projectd..[Covid Deaths]
WHERE location Like '%Nigeria%'
order by 1,2





SELECT 
    Location, 
    date, 
    population, 
    total_cases, 
    (TRY_CONVERT(FLOAT, total_cases) / NULLIF(population, 0)) * 100 AS DeathPercentage
FROM projectd..[Covid Deaths]
WHERE location LIKE '%Nigeria%'
ORDER BY 1, 2;



SELECT 
    Location, 
    population, 
    MAX(TRY_CONVERT(INT, total_cases)) AS HighestInfectionCount, 
    (MAX(TRY_CONVERT(FLOAT, total_cases)) / NULLIF(population, 0)) * 100 AS PercentagePopulationInfected
FROM projectd..[Covid Deaths]
GROUP BY Location, population
ORDER BY PercentagePopulationInfected DESC;

 

SELECT Location, MAX(total_deaths) as Totaldeathcount
FROM projectd..[Covid Deaths]
Where continent is not null
GROUP BY Location
ORDER BY Totaldeathcount DESC;



SELECT continent, MAX(total_deaths) as Totaldeathcount
FROM projectd..[Covid Deaths]
Where continent is not null
GROUP BY continent
ORDER BY Totaldeathcount DESC;



SELECT continent, MAX(total_deaths) as Totaldeathcount
FROM projectd..[Covid Deaths]
Where continent is not null
GROUP BY continent
ORDER BY Totaldeathcount DESC;



SELECT SUM(CONVERT(FLOAT, new_cases)) as total_cases, SUM(CONVERT(FLOAT, new_deaths)) as total_deaths, SUM(CONVERT(FLOAT, new_deaths))/SUM(CONVERT(FLOAT, new_cases))*100 as Deathpercentage
FROM projectd..[Covid Deaths]
Where continent is not null
order by 1,2



Select * 
FROM projectd..[Covid  Vaccinations]





Select * 
FROM projectd..[Covid Deaths] dea
join projectd..[Covid  Vaccinations] vac
	on dea.location = vac.location
	and dea.date = vac.date



SELECT dea.continent, dea.location, dea.date, dea.population,  CONVERT(FLOAT, vac.new_vaccinations) as New_vaccinations, sum(CONVERT(FLOAT, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rolling_people_vaccinated
FROM projectd..[Covid Deaths] dea
join projectd..[Covid  Vaccinations] vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3



With PopvsVac (continent, location, date, population, New_vaccinations, Rolling_people_vaccinated)
as 
(
SELECT dea.continent, dea.location, dea.date, dea.population,  CONVERT(FLOAT, vac.new_vaccinations) as New_vaccinations, sum(CONVERT(FLOAT, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rolling_people_vaccinated
FROM projectd..[Covid Deaths] dea
join projectd..[Covid  Vaccinations] vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)
Select *, (Rolling_people_vaccinated/population)*100 as percentage_Rolling_people_vaccinated
from PopvsVac

 


Create Table #populationvaccinatedpercent
( 
Continent nvarchar(255),
Location nvarchar(255),
Date nvarchar(50),
Population numeric,
New_vaccinations numeric,
Rolling_people_vaccinated numeric
)

Insert into #populationvaccinatedpercent
SELECT dea.continent, dea.location, dea.date, dea.population,  CONVERT(FLOAT, vac.new_vaccinations) as New_vaccinations, sum(CONVERT(FLOAT, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rolling_people_vaccinated
FROM projectd..[Covid Deaths] dea
join projectd..[Covid  Vaccinations] vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null


Select *, (Rolling_people_vaccinated/population)*100 as percentage_Rolling_people_vaccinated
from #populationvaccinatedpercent



DROP VIEW IF EXISTS populationvaccinatedpercent;

USE projectd;
GO  

DROP VIEW IF EXISTS populationvaccinatedpercent;
GO  

CREATE VIEW populationvaccinatedpercent AS 
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population,  
    CONVERT(FLOAT, vac.new_vaccinations) AS New_vaccinations,  
    SUM(CONVERT(FLOAT, vac.new_vaccinations)) 
        OVER (PARTITION BY dea.location ORDER BY dea.date) AS Rolling_people_vaccinated
FROM projectd..[Covid Deaths] dea
join projectd..[Covid  Vaccinations] vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;
GO  

