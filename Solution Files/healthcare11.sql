-- 1 
delimiter //
create procedure find_medicine (in input_medicineID int)
begin
	select pharmacyID,pharmacyname,phone from pharmacy p
	join keep k using(pharmacyID)
	join medicine m using(medicineID)
	where medicineID=input_medicineID;
end //
delimiter ;

call find_medicine(1);

-- 2
drop function if exists avg_cost_perprescription;
delimiter //
create function avg_cost_perprescription(input_pharmacyID int, input_year int)
returns decimal(10,2)
deterministic
begin 
	declare avg_total_cost decimal(10,2);
    with cte as(
		select prescriptionID,pharmacyID,round(avg(maxPrice*quantity),2) as avg_cost  from prescription p
		join treatment t using(treatmentID)
		join contain c using(prescriptionID)
		join medicine m using(medicineID)
		join pharmacy ph using(pharmacyID)
		where year(date)=input_year
		group by prescriptionID
		order by pharmacyID) 
	select avg(avg_cost) as total_average_cost into avg_total_cost from cte
	group by pharmacyID
	having pharmacyID=input_pharmacyID;
    return avg_total_cost;
end;
//
delimiter ;

SELECT avg_cost_perprescription(1008, 2021);

-- 3
drop function if exists most_disease;
delimiter //
create function most_disease(input_state varchar(100), input_year int)
returns varchar(300)
deterministic
begin 
	declare disease varchar(300);
    with cte as (
		select diseasename, count(diseaseID) disease_count, row_number() over( order by count(diseaseID) desc) as ranks from disease d
		join treatment t using(diseaseID)
		join patient p using(patientId)
		join person pe on pe.personID=p.patientID
		join address a using(addressID)
		where state=input_state and year(date)=input_year
		group by diseaseID
	)
	select diseasename into disease from cte
	where ranks=1;
    return disease;
end;
//
delimiter ;

select most_disease('OK', 2021);

-- 4
drop function if exists people_count;
delimiter //
create function people_count(input_city varchar(100), input_year int,input_disease varchar(300))
returns int
deterministic
begin 
	declare result int;
    select count(*) into result from disease d
	join treatment t using(diseaseID)
	join patient p using(patientId)
	join person pe on pe.personID=p.patientID
	join address a using(addressID)
	where city=input_city and year(date)=input_year and diseasename=input_disease;
    return result;
end;
//
delimiter ;

select people_count('Washington', 2021,'Stroke') as count;

-- 5
drop function if exists avg_claim_balance;
delimiter //
create function avg_claim_balance(input_companyname varchar(300))
returns decimal(10,2)
deterministic
begin 
	declare result decimal(10,2);
    select round(avg(balance),2) into result from insurancecompany ic
	join insuranceplan ip using(companyID)
	join claim c using(UIN)
	join treatment t using(claimID)
	group by companyName
	having companyname=input_companyname;
    return result;
end;
//
delimiter ;

select avg_claim_balance('Aditya Birla Health Insurance Co. Ltd');