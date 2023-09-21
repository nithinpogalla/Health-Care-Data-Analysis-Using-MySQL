-- 1
select *,
case
	when producttype=1 then 'Generic'
	when producttype=2 then 'Patent' 
	when producttype=3 then 'Reference' 
	when producttype=4 then 'Similar'
	when producttype=5 then 'New'
	when producttype=6 then 'Specific'
end as product_type_words 
from medicine
where productType in (1,2,3) and taxCriteria='I'
union
select *,
case
	when producttype=1 then 'Generic'
	when producttype=2 then 'Patent' 
	when producttype=3 then 'Reference' 
	when producttype=4 then 'Similar'
	when producttype=5 then 'New'
	when producttype=6 then 'Specific'
end as product_type_words 
 from medicine
where productType in (4,5,6) and taxCriteria='II';

-- 2
with cte as
(select p.prescriptionID,sum(quantity) as totalQuantity
from prescription p
join contain c using(prescriptionID)
group by p.prescriptionID)
select *, 
case
	when totalQuantity<20 then 'Low Quantity'
    when totalQuantity between 20 and 49 then 'Medium Quantity'
    else 'High Quantity'
end as tag 
from cte;

-- 3
select pharmacyName,quantity,discount,
case
	when quantity>7500 then 'High Quantity'
    when quantity<1000 then 'Low Quantity'
end as quantity_type,
case
	when discount >=30 then 'High'
    when discount=0 then 'None'
end as discount_type
 from pharmacy p
join keep k using(pharmacyID)
having pharmacyname like '%Spot Rx%' and quantity_type is not null and discount_type is not null;

-- 4
select productName as medicinename,
case 
	when maxPrice < 0.5 *(select avg(maxPrice) from medicine) then 'Affordable'
    when maxPrice > 2 *(select avg(maxPrice) from medicine) then 'Costly'
end as medicine_type
 from medicine
where hospitalExclusive='S' 
having medicine_type is not null;

-- 5
select personname,gender,dob,
case
	when dob >= '2005-01-01' then ( case when gender='male' then 'YoungMale' else 'YoungFemale' end)
    when dob <'2005-01-01' and dob >='1985-01-01' then ( case when gender='male' then 'AdultMale' else 'AdultFemale' end)
    when dob <'1985-01-01' and dob >='1970-01-01' then ( case when gender='male' then 'MidAgeMale' else 'MidAgeFemale' end)
    else ( case when gender='male' then 'ElderMale' else 'ElderFemale' end)
end as age_category
from patient pa
join person p on p.personID=pa.patientID;

select * from person;