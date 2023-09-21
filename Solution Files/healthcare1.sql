-- Problem Statement 1:  Jimmy, from the healthcare department, has requested a report that shows 
-- how the number of treatments each age category of patients has gone through in the year 2022. 
-- The age category is as follows, Children (00-14 years), Youth (15-24 years), Adults (25-64 years),
--  and Seniors (65 years and over).Assist Jimmy in generating the report
select 
case
	when (timestampdiff(year,dob,date)) between 0 and 14 then 'Children'
    when (timestampdiff(year,dob,date)) between 15 and 24 then 'Youth'
    when (timestampdiff(year,dob,date)) between 25 and 64 then 'Adults'
    when (timestampdiff(year,dob,date)) >= 65 then 'Seniors'
end as age,
count(*) from patient
join treatment using(patientid)
where year(date)=2022
group by age;

-- Problem Statement 2:  Jimmy, from the healthcare department, wants to know which disease is
--  infecting people of which gender more often. Assist Jimmy with this purpose by generating
--  a report that shows for each disease the male-to-female ratio. Sort the data in a way that is helpful for Jimmy.
select diseasename,sum(case gender when 'male' then 1 else 0 end)/sum(case gender when 'female' then 1 else 0 end) as male_to_female_ratio from disease d
join treatment t using(diseaseid)
join patient p using (patientid)
join person pe on pe.personID=p.patientID
group by diseasename
order by male_to_female_ratio desc;

-- Problem Statement 3: Jacob, from insurance management, has noticed that insurance claims are not made for all the treatments.
--  He also wants to figure out if the gender of the patient has any impact on the insurance claim. Assist Jacob in this 
--  situation by generating a report that finds for each gender the number of treatments, number of claims, and treatment
--  -to-claim ratio. And notice if there is a significant difference between the treatment-to-claim ratio of male and female patients.
select gender, count(treatmentID), count(claimid),count(treatmentID)/count(claimid) from treatment t
join patient p using(patientID)
join person pe on pe.personID=p.patientID
group by gender;

-- Problem Statement 4: The Healthcare department wants a report about the inventory of pharmacies. 
-- Generate a report on their behalf that shows how many units of medicine each pharmacy has in their inventory,
--  the total maximum retail price of those medicines, and the total price of all the medicines after discount. 
-- Note: discount field in keep signifies the percentage of discount on the maximum price.
select pharmacyname,sum(quantity) as total_quantity,sum(quantity*maxPrice) as total_price,sum(quantity*maxPrice-(discount/100)*(quantity*maxPrice)) as total_discounted_Price from pharmacy 
join keep using(pharmacyID)
join medicine using(medicineID)
group by pharmacyID;

-- Problem Statement 5:  The healthcare department suspects that some pharmacies prescribe more medicines than others
--  in a single prescription, for them, generate a report that finds for each pharmacy the maximum, minimum and 
--  average number of medicines prescribed in their prescriptions. 
select pharmacyID,max(quantity),min(quantity),avg(quantity) from prescription p
join contain c using(prescriptionID)
group by pharmacyID;




