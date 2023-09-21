-- Problem Statement 1: A company needs to set up 3 new pharmacies, they have come up with
--  an idea that the pharmacy can be set up in cities where the pharmacy-to-prescription
--  ratio is the lowest and the number of prescriptions should exceed 100. Assist the 
--  company to identify those cities where the pharmacy can be set up.
SELECT a.city,
       COUNT(DISTINCT p.pharmacyid) AS num_pharmacies,
       COUNT(DISTINCT pr.prescriptionid) AS num_prescriptions,
       COUNT(DISTINCT p.pharmacyid) / COUNT(DISTINCT pr.prescriptionid) AS pharmacy_prescription_ratio
FROM address a
LEFT JOIN pharmacy p ON a.addressid = p.addressid
LEFT JOIN prescription pr ON p.pharmacyid = pr.pharmacyid
GROUP BY a.city
HAVING COUNT(DISTINCT pr.prescriptionid) > 100;

-- Problem Statement 2: The State of Alabama (AL) is trying to manage its healthcare 
-- resources more efficiently. For each city in their state, they need to identify the
-- disease for which the maximum number of patients have gone for treatment. Assist the state
-- for this purpose. Note: The state of Alabama is represented as AL in Address Table.
select city,count(patientID) patient_count,diseaseName from address a
join person p using(addressID)
join patient pa on pa.patientID=p.personID
join treatment t using(patientID)
join disease d using(diseaseID)
where state='AL'
group by city,diseaseName
order by patient_count desc;

-- Problem Statement 3: The healthcare department needs a report about insurance plans. 
-- The report is required to include the insurance plan, which was claimed the most and
--  least for each disease.  Assist to create such a report.
with cte as 
(select t.diseaseID , i.planName , count(i.planName) as cnt 
from treatment t 
right join claim c using(claimId)
join insuranceplan i using(UIN)
group by i.planName,t.diseaseID),
cte2 as 
( select diseaseID , min(cnt) as minn, max(cnt) as maxx 
from cte 
group by diseaseID)
select cte.* from cte2 
join cte using(diseaseId) 
where cnt in (cte2.minn, cte2.maxx) 
order by diseaseID,cnt desc;

-- Problem Statement 4: The Healthcare department wants to know which disease is most likely
--  to infect multiple people in the same household. For each disease find the number of households
--  that has more than one patient with the same disease. 
with cte as(
select diseaseName,addressID,count(personID) as personcount from address a
join person p using(addressID)
join patient pa on pa.patientID=p.personID
join treatment t using(patientID)
join disease d using(diseaseID)
group by diseaseName,addressID
having count(personID)>1)
select diseaseName,count(addressID)
from cte
group by diseaseName;

-- Problem Statement 5:  An Insurance company wants a state wise report of the treatments to claim
--  ratio between 1st April 2021 and 31st March 2022 (days both included). 
--  Assist them to create such a report.
select state,count(treatmentID)/count(claimID) as treatment_to_claim_ratio from address a
left join person p using(addressID)
left join patient pa on p.personId=pa.patientID
left join treatment t using(patientID)
left join claim c using(claimid)
where date between '2021-04-01' and '2022-03-31'
group by state;
