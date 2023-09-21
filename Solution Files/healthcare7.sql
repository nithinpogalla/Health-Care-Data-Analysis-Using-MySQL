DELIMITER //
CREATE PROCEDURE claim_rate(IN diseaseID INT, OUT result VARCHAR(30))
BEGIN
    DECLARE avg_claim_count INT;
    SELECT AVG(claim_count) INTO avg_claim_count FROM (
        SELECT COUNT(claimID) AS claim_count
        FROM disease d
        JOIN treatment t USING(diseaseID)
        JOIN claim c USING(claimID)
        WHERE diseaseID = diseaseID
        GROUP BY diseaseID
    ) AS cte_avg;

    SELECT 
        IF(claim_count > avg_claim_count, 'claimed higher than average', 'claimed lower than average') INTO result
    FROM (
        SELECT diseaseID, COUNT(claimID) AS claim_count
        FROM disease d
        JOIN treatment t USING(diseaseID)
        JOIN claim c USING(claimID)
        WHERE diseaseID = diseaseID
        GROUP BY diseaseID
    ) AS cte;
END //
DELIMITER ;

call claim_rate(40,@result);
select @result;

-- 2
drop procedure disease_data;
DELIMITER //
CREATE PROCEDURE disease_data(IN input_diseaseID INT)
BEGIN
    select diseasename,sum(if(gender='male',1,0)) as number_of_male_treated,
						sum(if(gender='female',1,0)) as number_of_female_treated,
                        if (sum(if(gender='male',1,0)) > sum(if(gender='female',1,0)) , 'male','female') as more_treated_gender
	from disease d
    JOIN treatment t USING(diseaseID)
    join patient p using(patientID)
    join person pe on pe.personID=p.patientID
    where diseaseID=input_diseaseID
    group by diseaseID;
END //
DELIMITER ;

call disease_data(30);

-- 3

(select planname,count(claimID) as claim_count, 'most_claimed' as claim_category from InsurancePlan ip 
join claim c using(UIN)
group by UIN
order by count(claimID) desc
limit 3)
union all
(select planname,count(claimID) as claim_count, 'least_claimed' as claim_category from InsurancePlan ip 
join claim c using(UIN)
group by UIN
order by count(claimID)
limit 3)
order by claim_count desc;

-- 4
select personname,gender,dob,
case
	when dob >= '2005-01-01' then ( case when gender='male' then 'YoungMale' else 'YoungFemale' end)
    when dob <'2005-01-01' and dob >='1985-01-01' then ( case when gender='male' then 'AdultMale' else 'AdultFemale' end)
    when dob <'1985-01-01' and dob >='1970-01-01' then ( case when gender='male' then 'MidAgeMale' else 'MidAgeFemale' end)
    else ( case when gender='male' then 'ElderMale' else 'ElderFemale' end)
end as age_category
from patient pa
join person p on p.personID=pa.patientID;

-- 5
select companyname,productname,description,maxprice,
case
	when maxPrice>1000 then 'Pricey'
    when maxPrice<5 then 'affordabele'
end as price_category
from medicine
having price_category is not null;




