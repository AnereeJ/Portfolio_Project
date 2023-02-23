select * from portfolio_project..CovidDeaths$ order by 3,4;

--select * from portfolio_project..CovidVaccinations order by 3,4;

select location, date, total_cases, new_cases,total_deaths, population
from portfolio_project..CovidDeaths$ 
order by 1,2;

--total cases vs total deaths
select location,total_cases, total_deaths, (total_deaths/total_cases)* 100 Average_deaths_Percent
from portfolio_project..CovidDeaths$
where location like 'India'
order by 1;

--looking at total cases vs popluation
select location,total_cases, total_deaths, population, (total_cases/population)* 100 Cases_Percent
from portfolio_project..CovidDeaths$
where location like 'India'
order by 1;

--looking at countries with highest infection rates compared to population
select location, population, max(total_cases) Highest_Infection, max((total_cases/population))* 100 
as Infected_Percent
from portfolio_project..CovidDeaths$
group by population, location
order by Infected_Percent desc;

--looking for countries with highest death per popluation
select location, population, max(cast(total_deaths as int)) as Maximum_deaths, max((total_deaths/population))* 100 as Death_Percent
from portfolio_project..CovidDeaths$
where continent is not null
group by location, population
order by Maximum_deaths desc;

--looking for maximum deaths in continents
select distinct(continent) from portfolio_project..CovidDeaths$

select continent, max(cast(total_deaths as int)) as Maximum_deaths 
from portfolio_project..CovidDeaths$
where continent is not null
group by continent
order by Maximum_deaths desc;

-- looking for global deaths
select sum(cast(total_cases as bigint)) as Total_Cases,sum(cast(total_deaths as bigint)) as Total_Deaths, sum(cast(total_deaths as bigint))/sum(total_cases)* 100 as Death_Percent
from portfolio_project..CovidDeaths$
order by Death_Percent desc;



select *
from portfolio_project..CovidDeaths$ cd
join portfolio_project..CovidVaccinations$ cv on
cd.iso_code = cv.iso_code;

-- total people with total population
select cd.continent, cd.location, cd.date, cd.population, cv.total_vaccinations
from portfolio_project..CovidDeaths$ cd
join portfolio_project..CovidVaccinations$ cv on
cd.location = cv.location and
cd.date = cv.date
where cd.continent is not null
order by 2,3

-- total people vs new vaccination, with cte
with popvac (Continent, Location, Population, New_Vaccination, Total_New_Vaccination)
as
(
select cd.continent, cd.location, cd.population, cv.new_vaccinations,
sum(convert(int, cv.new_vaccinations)) over (partition by cd.location order by cd.location, cd.date) as Total_New_Vaccination
from portfolio_project..CovidDeaths$ cd
join portfolio_project..CovidVaccinations$ cv on
cd.location = cv.location and
cd.date = cv.date
where cd.continent is not null
)

select *, (Total_New_Vaccination/Population)* 100 Vaccinated_People_Percentage from popvac

-- create table to store popvac to form a new table with specific data.
drop table if exists vaccinatedpercentage
create table vaccinatedpercentage(
continent nvarchar(255),
location nvarchar(255),
population bigint,
New_Vaccination bigint,
TotalNewVaccination bigint
)
Insert into vaccinatedpercentage
select cd.continent, cd.location, cd.population, cv.new_vaccinations,
sum(convert(int, cv.new_vaccinations)) over (partition by cd.location order by cd.location, cd.date) as Total_New_Vaccination
from portfolio_project..CovidDeaths$ cd
join portfolio_project..CovidVaccinations$ cv on
cd.location = cv.location and
cd.date = cv.date
where cd.continent is not null


select *, (TotalNewVaccination/Population)* 100 as Vaccinated_People_Percentage from vaccinatedpercentage

-- creating view for later visualization
create view view_vac_percentage as
select continent, max(cast(total_deaths as int)) as Maximum_deaths 
from portfolio_project..CovidDeaths$
where continent is not null
group by continent;

select * from view_vac_percentage












