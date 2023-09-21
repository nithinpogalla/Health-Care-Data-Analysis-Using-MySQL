-- 1
select personname,count(treatmentID) as nooftreatments,dob,timestampdiff(year,dob,now()) age
from person p 
join patient pa on pa.patientID=p.personID
join treatment using(patientID)
group by personID
having nooftreatments>1
order by nooftreatments desc;

-- 2
select diseasename,sum(if(gender='male', 1,0)) as male_patients_count,
					sum(if(gender='female', 1,0)) as female_patients_count,
                    sum(if(gender='male', 1,0))/sum(if(gender='female', 1,0)) as maletofemalepatientsratio 
from disease s
left join treatment t using(diseaseID)
left join patient pa using(patientID)
left join person p on p.personID=pa.patientID
where year(date)=2021
group by diseaseID;

-- 3
select * from 
(select diseasename,city,count(treatmentID),row_number() over(partition by diseaseName order by count(treatmentID) desc) as rowrank from disease s 
join treatment t using(diseaseID)
join prescription p using(treatmentID)
join pharmacy ph using(pharmacyID)
join address using(addressID)
group by diseasename,city
order by diseasename,count(treatmentID) desc) as derived_table
where rowrank in (1,2,3);

-- 4
select pharmacyname,diseaseName,sum(if(year(date) ='2021',1,0)) as count_of_prescriptions_in_2021,sum(if(year(date) ='2022',1,0)) as count_of_prescriptions_in_2022
from pharmacy ph
join prescription p using(pharmacyID)
join Treatment t using(TreatmentID)
join disease d using(diseaseID)
group by pharmacyname,diseaseID
order by pharmacyname,diseasename;

-- 5
select companyname,state,count(claimID)
from insurancecompany ic 
join address a using(addressID)
join insuranceplan ip using(companyID)
join Claim c using(UIN)
group by companyID,state
order by companyname,state;
