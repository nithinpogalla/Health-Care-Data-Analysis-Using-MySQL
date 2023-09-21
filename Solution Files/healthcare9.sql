-- 1
select if(grouping(state),'All states',state),if(grouping(gender),'All Genders',gender), count(patientID) from address a
join person p using(addressID)
join patient pa on pa.patientID=p.personID
join treatment t using(patientID)
join Disease d using(diseaseID)
where diseasename='Autism'
group by state,gender with rollup;

-- 2
select planName,year(date),count(treatmentID) from InsuranceCompany ic
join insuranceplan ip using(companyID)
join claim c using(UIN)
join Treatment t using(claimID)
where year(date) in (2020,2021,2022)
group by planName,year(date) with rollup;

-- 3
with Treatment_count as
(
select state,diseaseName,count(treatmentiD) AS no_of_treatments,
	row_number() over(partition by state order by count(treatmentid) desc) as ranks1,
row_number() over(partition by state order by count(treatmentid)) as ranks2
from disease
join treatment using(diseaseId)
join patient using(patientId)
join person on patientId = personId
join address using(addressId)
where year(date) = 2022
group by state,diseaseName
),
-- Most Treated diseases for each state 
Most_Treated_Diseases as
(
	select state,diseaseName as Most_Treated_Disease,no_of_treatments
    from Treatment_count where ranks1 = 1
),
-- Least Treated diseases for each state 
Least_Treated_Diseases as
(
	select state,diseaseName as Least_Treated_Disease,no_of_treatments
    from Treatment_count where ranks2 = 1
)
select state,
    Most_Treated_Disease,
    SUM(t1.no_of_treatments) AS Total_Most_Treated,
    Least_Treated_Disease,
    SUM(t2.no_of_treatments) AS Total_Least_Treated from 
Most_Treated_Diseases t1 join Least_Treated_Diseases t2 using(state)
GROUP BY
    state,
    Most_Treated_Disease,
    Least_Treated_Disease
WITH ROLLUP;

-- 4
select pharmacyname,diseasename,count(prescriptionID) from pharmacy p
join prescription pr using(pharmacyID)
join treatment t using(treatmentID)
join Disease d using(diseaseID)
where year(date)=2022
group by pharmacyname,diseasename with rollup;

-- 5
select diseasename,sum(if(gender='male',1,0)) as male_count, sum(if(gender='female',1,0)) as female_count from disease d
join treatment t using(diseaseID)
join patient pa using(patientID)
join person p on p.personID=pa.patientID
where year(date)=2022
group by diseasename with rollup;



















