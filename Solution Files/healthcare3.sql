-- 1
select pharmacyID,pharmacyname,count(hospitalExclusive) as total from treatment t
join prescription pr using(treatmentID)
join pharmacy p using(pharmacyID)
join contain c using(prescriptionID)
join medicine using(medicineID) 
where hospitalExclusive='S' and (year(date)=2021 or year(date)=2022)
group by pharmacyID
order by total desc;

-- Problem Statement 2: Insurance companies want to assess the performance of
--  their insurance plans. Generate a report that shows each insurance plan,
--  the company that issues the plan, and the number of treatments the plan was claimed for.
select ip.planname,companyname,count(treatmentID) from insurancecompany ic
join insuranceplan ip using(companyID)
join claim c using(UIN)
join treatment t using(claimID)
group by ip.planName,companyname
order by ip.planName;

-- Problem Statement 3: Insurance companies want to assess the performance of their
-- insurance plans. Generate a report that shows each insurance company's name with
--  their most and least claimed insurance plans.
SELECt ic.companyname AS insurance_company_name,MAX(ip.planname) AS most_claimed_insurance_plan,
MIN(ip.planname) AS least_claimed_insurance_plan
from insurancecompany ic
join insuranceplan ip using(companyID)
join claim c using(UIN)
group by companyname
ORDER BY companyname;

-- Problem Statement 4:  The healthcare department wants a state-wise health report to assess which
--  state requires more attention in the healthcare sector. Generate a report for them that shows 
--  the state name, number of registered people in the state, number of registered patients in the
--  state, and the people-to-patient ratio. sort the data by people-to-patient ratio. 
select state, count(personID) as registered_people,count(patientID) as registered_patients,count(personid)/count(patientid) as ratio
from address a
left join person p using(addressID)
left join patient pa on pa.patientID=p.personID
group by state;

-- Problem Statement 5:  Jhonny, from the finance department of Arizona(AZ), has requested a report that
--  lists the total quantity of medicine each pharmacy in his state has prescribed that falls under 
--  Tax criteria I for treatments that took place in 2021. Assist Jhonny in generating the report. 
select pharmacyname,count(m.medicineID) from pharmacy p
join address a using(addressID)
join prescription pr using(pharmacyID)
join contain c using(prescriptionID)
join medicine m using(medicineID)
where state='AZ' and taxCriteria='I'
group by pharmacyname;

