
--What is the maternal deaths by country
select Year, Entity, max([Number of maternal deaths]) as HighestMMR
from MortalityRate..number_of_maternal_deaths_by_region
where (Entity not like '%income%'
		and Entity not like '%south%'
		and Entity not like '%east%'
		and Entity not like '%sub%'
		and Entity not like '%world%')
GROUP by Entity, Year
order by Entity, HighestMMR DESC


--Maternal deaths in the world
select Year, Entity, [Number of maternal deaths]
from MortalityRate..number_of_maternal_deaths_by_region
where Entity like '%world%'

--Maternal deaths by continent
select Year, Entity, [Number of maternal deaths]
from MortalityRate..number_of_maternal_deaths_by_region
where (Entity like '%east%'
		or Entity like '%america%'
		or Entity like '%europe%'
		or Entity like '%asia%'
		or Entity like '%saharan%')

--Maternal deaths by income generated
select Year, Entity, max([Number of maternal deaths]) as incomeMMR
from MortalityRate..number_of_maternal_deaths_by_region
where Entity like '%income%'
GROUP by Entity, Year
order by Entity 

--Maternal Mortality Rate vs a country's Gross Domestic Product(GDP) per capita
select Year, Entity, max([GDP per capita, PPP (constant 2017 international $)]) as [GDP per capita], [Maternal Mortality Ratio (Gapminder (2010) and World Bank (2015)] as MMR, [Population (historical estimates)]
from MortalityRate..maternal_mortality_ratio_vs_gdp
group by Year, Entity, [Population (historical estimates)], [Maternal Mortality Ratio (Gapminder (2010) and World Bank (2015)]
order by Entity, [GDP per capita] ASC

--Lifetime risk of maternal death
select risk.Entity, risk.Year, risk.[Lifetime risk of maternal death (%)], dea.[Number of maternal deaths]
from MortalityRate..lifetime_risk_of_maternal_death risk
Join MortalityRate..number_of_maternal_deaths_by_region dea
	on risk.Entity = dea.Entity
	and risk.Year = dea.Year

--Lifetime risk of maternal death vs a country's GDP
select risk.Entity, risk.Year, [Lifetime risk of maternal death (%)], [Maternal Mortality Ratio (Gapminder (2010) and World Bank (2015)], [GDP per capita, PPP (constant 2017 international $)], [Population (historical estimates)]
from MortalityRate..lifetime_risk_of_maternal_death risk
join MortalityRate..maternal_mortality_ratio_vs_gdp gdp
	on risk.Entity = gdp.Entity
	and risk.Year = gdp.Year
--where risk.Entity = 'Korea'
order by Entity ASC, Year

--Births attended by health staff vs lifetime risk of maternal death
select attend.Entity, attend.Year, attend.[Births attended by skilled health staff (% of total)], risk.[Lifetime risk of maternal death (%)]
from MortalityRate..Births_attended_by_health_staff attend
Join MortalityRate..lifetime_risk_of_maternal_death risk
	on attend.Entity = risk.Entity
	and attend.Year = risk.Year
order by Entity, Year ASC, [Births attended by skilled health staff (% of total)] DESC

-- Comparison of Mortality Rate in 2000 vs 2017
select Entity, Year, [Maternal mortality ratio (modeled estimate, per 100,000 live bir] as MMR, [Maternal mortality ratio (modeled estimate, per 100,000 live bi1] as MMR2017, Year1
from MortalityRate..MMR_in_2000_and_2017


--Create view to store data for later visualizations
Use MortalityRate;
Drop View If Exists CountryMaternalDeaths
Go
Create View CountryMaternalDeaths as
select Year, Entity, max([Number of maternal deaths]) as HighestMMR
from MortalityRate..number_of_maternal_deaths_by_region
where (Entity not like '%income%'
		and Entity not like '%south%'
		and Entity not like '%east%'
		and Entity not like '%sub%'
		and Entity not like '%world%')
GROUP by Entity, Year
--order by Entity, HighestMMR DESC
Go

Drop View If Exists WorldMaternalDeaths
Go
Create View WorldMaternalDeaths as
select Year, Entity, [Number of maternal deaths]
from MortalityRate..number_of_maternal_deaths_by_region
where Entity like '%world%'
Go

Drop View If Exists ContMaternalDeaths
Go
Create View ContMaternalDeaths as
select Year, Entity, [Number of maternal deaths]
from MortalityRate..number_of_maternal_deaths_by_region
where (Entity like '%east%'
		or Entity like '%america%'
		or Entity like '%europe%'
		or Entity like '%asia%'
		or Entity like '%saharan%')
Go

Drop View If Exists IncomeGenerated
Go
Create View IncomeGenerated as
select Year, Entity, max([Number of maternal deaths]) as incomeMMR
from MortalityRate..number_of_maternal_deaths_by_region
where Entity like '%income%'
GROUP by Entity, Year
--order by Entity 
Go


Drop View If Exists [MMR-GDP]
Go
Create View [MMR-GDP] as
select Year, Entity, max([GDP per capita, PPP (constant 2017 international $)]) as [GDP per capita], [Maternal Mortality Ratio (Gapminder (2010) and World Bank (2015)] as MMR, [Population (historical estimates)]
from MortalityRate..maternal_mortality_ratio_vs_gdp
group by Year, Entity, [Population (historical estimates)], [Maternal Mortality Ratio (Gapminder (2010) and World Bank (2015)]
--order by Entity, [GDP per capita] ASC
Go


Drop View If Exists LifetimeRisk
Go
Create View LifetimeRisk as
select risk.Entity, risk.Year, risk.[Lifetime risk of maternal death (%)], dea.[Number of maternal deaths]
from MortalityRate..lifetime_risk_of_maternal_death risk
Join MortalityRate..number_of_maternal_deaths_by_region dea
	on risk.Entity = dea.Entity
	and risk.Year = dea.Year
Go


Drop View If Exists [LifetimeRisk-GDP]
Go
Create View [LifetimeRisk-GDP] as
select risk.Entity, risk.Year, [Lifetime risk of maternal death (%)], [Maternal Mortality Ratio (Gapminder (2010) and World Bank (2015)], [GDP per capita, PPP (constant 2017 international $)], [Population (historical estimates)]
from MortalityRate..lifetime_risk_of_maternal_death risk
join MortalityRate..maternal_mortality_ratio_vs_gdp gdp
	on risk.Entity = gdp.Entity
	and risk.Year = gdp.Year
--order by Entity ASC, Year
Go


Drop View If Exists HealthStaff
Go
Create View HealthStaff as
select attend.Entity, attend.Year, attend.[Births attended by skilled health staff (% of total)], risk.[Lifetime risk of maternal death (%)]
from MortalityRate..Births_attended_by_health_staff attend
Join MortalityRate..lifetime_risk_of_maternal_death risk
	on attend.Entity = risk.Entity
	and attend.Year = risk.Year
--order by Entity, Year ASC, [Births attended by skilled health staff (% of total)] DESC
Go


Drop View If Exists [MMR 2000/2017]
Go
Create View [MMR 2000/2017] as
select Entity, Year, [Maternal mortality ratio (modeled estimate, per 100,000 live bir] as MMR, [Maternal mortality ratio (modeled estimate, per 100,000 live bi1] as MMR2017, Year1
from MortalityRate..MMR_in_2000_and_2017
Go

