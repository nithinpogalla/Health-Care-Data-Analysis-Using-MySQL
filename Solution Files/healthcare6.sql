-- 1
select pharmacyID,pharmacyname,count(prescriptionID) as prescription_count,
		count(hospitalExclusive) as hospitalexclusive_count,
        count(hospitalExclusive)/ count(prescriptionID) as exclusive_to_prescription_ratio
from pharmacy p
left join prescription pr using(pharmacyID)
left join treatment t using(treatmentID)
left join contain c using(prescriptionID)
left join medicine m using(medicineID)
where year(date)=2022
group by pharmacyID;

-- 2
select state,count(treatmentId) as treatment_counts,count(claimID) as claim_counts,
			(count(claimID)/count(treatmentId))*100 as claim_to_treatment_ratio
from address a
left join person p using(addressID)
left join patient pa on p.personID=pa.patientID
left join treatment t using(patientID)
left join claim c using(claimID)
group by state;

-- 3
select t1.state,t1.diseaseID as max_disease_id,max_treatment_count,t2.diseaseID as min_disease_id,min_treatment_count from (SELECT state, diseaseID, max_treatment_count 
FROM (
    SELECT state, diseaseID, COUNT(treatmentID) AS max_treatment_count,
           ROW_NUMBER() OVER (PARTITION BY state ORDER BY COUNT(treatmentID) DESC) AS rowrank
    FROM address a
	JOIN person p USING (addressID)
	JOIN patient pa ON p.personID = pa.patientID
	JOIN treatment t USING (patientID)
	JOIN disease d USING (diseaseID)
    GROUP BY state, diseaseID
) ranked_data
WHERE rowrank = 1) as t1
join 
(SELECT state, diseaseID, min_treatment_count 
FROM (
    SELECT state, diseaseID, COUNT(treatmentID) AS min_treatment_count,
           ROW_NUMBER() OVER (PARTITION BY state ORDER BY COUNT(treatmentID)) AS rowrank
    FROM address a
	JOIN person p USING (addressID)
	JOIN patient pa ON p.personID = pa.patientID
	JOIN treatment t USING (patientID)
	JOIN disease d USING (diseaseID)
    GROUP BY state, diseaseID
) ranked_data
WHERE rowrank = 1) as t2 on t1.state=t2.state;

-- 4
select city,count(personID) as registered_people,count(patientID) as patient_count,(count(patientID)/count(personID))*100 as patient_to_person_ratio
from address a 
left join person p using(addressId)
left join patient pa on p.personID=pa.patientID
group by city
having count(personID)>=10;

-- 5
select companyname, count(medicineID) as medicine_count
from medicine
where substanceName like '%ranitidina%'
group by companyname
order by medicine_count desc
limit 3;