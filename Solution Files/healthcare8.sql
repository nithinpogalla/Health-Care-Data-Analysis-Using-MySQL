-- Query 1: 
-- For each age(in years), how many patients have gone for treatment?
SELECT timestampdiff(year, dob , date) AS age, count(*) AS numTreatments
FROM Person
JOIN Patient ON Patient.patientID = Person.personID
JOIN Treatment ON Treatment.patientID = Patient.patientID
group by timestampdiff(year, dob , date)
order by numTreatments desc;
-- timestampdiff runs faster than datediff

-- Query 2: 
-- For each city, Find the number of registered people, number of pharmacies, and number of insurance companies.
select Address.city, 
			count(Pharmacy.pharmacyID) as numPharmacy, 
            count(InsuranceCompany.companyID) as numInsuranceCompany,
			count(Person.personID) as numRegisteredPeople
from address 
left join Pharmacy on Pharmacy.addressID = Address.addressID
left join InsuranceCompany on InsuranceCompany.addressID = Address.addressID
left join Person on Person.addressID = Address.addressID
group by city;
-- we can join multiple tables all at once

-- Query 3: 
-- Total quantity of medicine for each prescription prescribed by Ally Scripts
-- If the total quantity of medicine is less than 20 tag it as "Low Quantity".
-- If the total quantity of medicine is from 20 to 49 (both numbers including) tag it as "Medium Quantity".
-- If the quantity is more than equal to 50 then tag it as "High quantity".
select C.prescriptionID, 
	sum(quantity) as totalQuantity,
	CASE 
		WHEN sum(quantity) < 20 THEN 'Low Quantity'
        WHEN sum(quantity) < 50 THEN 'Medium Quantity'
        ELSE 'High Quantity' 
	END AS Tag
FROM Contain C
JOIN Prescription P on P.prescriptionID = C.prescriptionID
JOIN Pharmacy on Pharmacy.pharmacyID = P.pharmacyID and Pharmacy.pharmacyName = 'Ally Scripts'
group by C.prescriptionID;

-- Query 4: 
-- The total quantity of medicine in a prescription is the sum of the quantity of all the medicines in the prescription.
-- Select the prescriptions for which the total quantity of medicine exceeds
-- the avg of the total quantity of medicines for all the prescriptions.
drop table if exists t;
select pharmacyID, prescriptionID, totalQuantity from (
select Pharmacy.pharmacyID, Prescription.prescriptionID, sum(quantity) as totalQuantity,avg(sum(quantity)) over() as avgTotalQuantity
from Pharmacy
join Prescription on Pharmacy.pharmacyID = Prescription.pharmacyID
join Contain on Contain.prescriptionID = Prescription.prescriptionID
join Medicine on Medicine.medicineID = Contain.medicineID
join Treatment on Treatment.treatmentID = Prescription.treatmentID
where YEAR(date) = 2022
group by Pharmacy.pharmacyID, Prescription.prescriptionID
) as t
where totalQuantity > avgTotalQuantity;


-- Query 5: 
-- Select every disease that has 'p' in its name, and 
-- the number of times an insurance claim was made for each of them. 
SELECT Disease.diseaseName, COUNT(*) as numClaims
FROM Disease
JOIN Treatment ON Disease.diseaseID = Treatment.diseaseID
JOIN Claim On Treatment.claimID = Claim.claimID
WHERE diseaseName  LIKE '%p%'
GROUP BY diseaseName;

