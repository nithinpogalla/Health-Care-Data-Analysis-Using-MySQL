-- 1
drop procedure Performance_of_insurance_plans;
delimiter //
create procedure Performance_of_insurance_plans(insurance_id int)
begin
	with Plan_Disease as
    (
	select planName,diseaseName,count(claimId) as claim_count,row_number() over(partition by planName order by count(claimId) desc) as ranks
	from InsurancePlan 
    join claim using(uin)
    join treatment using(claimId)
    join disease using(diseaseID)
    where companyId = insurance_id
    group by planName,diseaseName
    ),
    Total_Treatment_counts as
    (
		select planName,sum(claim_count) as total_treatment_count from plan_disease group by planName
	)
    select planName,Total_treatment_count,diseaseName,claim_count
    from plan_disease
    join Total_Treatment_counts using(planName) where ranks = 1;
end //
delimiter ;
call Performance_of_insurance_plans(1933);


-- 2
drop procedure Top3_pharmacies;
delimiter //
create procedure Top3_Pharmacies(input_diseaseename varchar(100))
begin
	with Pharmacy_Patient_count as
    (
	select pharmacyName,year(date) as year,count(patientId) as patient_count,
    row_number() over(partition by year(date) order by count(patientID) desc) ranks
    from pharmacy
    join prescription using(pharmacyId)
    join treatment using(treatmentId)
    join patient using(patientId)
    where year(date) between 2021 and 2022 and diseaseId in (select diseaseId from disease where diseaseName = input_diseaseename)
    group by pharmacyName,year(date)
    ),
    Top3_pharmacies as
	(
		select * from Pharmacy_Patient_count where ranks <= 3
	),
    GetFormattedRecords as
    (
		select year,
        max(case when ranks = 1 then pharmacyName end) as Top1,
        max(case when ranks = 2 then pharmacyName end) as Top2,
        max(case when ranks = 3 then pharmacyName end) as Top3
        from Top3_pharmacies where year = 2021
        union all
        select year,
        max(case when ranks = 1 then pharmacyName end) as Top1,
        max(case when ranks = 2 then pharmacyName end) as Top2,
        max(case when ranks = 3 then pharmacyName end) as Top3
        from Top3_pharmacies where year = 2022
	)
    select * from GetFormattedRecords;
end //
call Top3_pharmacies("Asthma");
call Top3_pharmacies("Psoriasis");

-- 3
drop procedure appropriate_state;
delimiter //
create procedure appropriate_state(input_state varchar(100))
begin
	with cte as(
	select state, count(patientID) as num_patients ,count(companyID) as num_insurance_companies,
					count(companyID)/count(patientID) as insurance_patient_ratio 
    from address a 
	left join person p using(addressID)
    left join patient pa on pa.patientID=p.personID
	left join insurancecompany ic using(addressID)
	group by state)
	select *,(select avg(insurance_patient_ratio) from cte) as avg_insurance_patient_ratio,
	case
		when insurance_patient_ratio< (select avg(insurance_patient_ratio) from cte) then 'Recommended'
		else 'Not Recommended'
	end as recommendation
	from cte
    where input_state=state;
end //
delimiter ;

call appropriate_state('OK');

-- 4
CREATE TABLE IF NOT EXISTS PlacesAdded (
    placeID INT AUTO_INCREMENT PRIMARY KEY,
    placeName VARCHAR(255) NOT NULL,
    placeType ENUM('city', 'state') NOT NULL,
    timeAdded DATETIME NOT NULL
);

drop trigger add_values_to_placesAdded;
delimiter //
create trigger add_values_to_placesAdded
before insert on address
for each row
begin
	insert into PlacesAdded (placeName, placeType, timeAdded) values (new.city,'city',now());
    insert into PlacesAdded (placeName, placeType, timeAdded) values (new.state,'state',now());
end;
//
delimiter ;

delete from address where addressID=724329;
INSERT IGNORE INTO Address VALUES (724329,'21323 North 64th Avenue','Glendale','AZ',85308);
select * from placesAdded;

-- 5
create table if not exists keep_log (
id int auto_increment primary key,
medicineID int not null,
quantity int not null
);

drop trigger if exists insert_to_keep_log;
delimiter //
create trigger insert_to_keep_log 
after update on keep
for each row
begin
	declare diff int;
    set diff=new.quantity-old.quantity;
    insert into keep_log(medicineID,quantity) values (new.medicineID,diff);
end;
//
delimiter ;


update keep set quantity = 8008 where pharmacyID=1008 and medicineID=1111;
select * from keep_log;
update keep set quantity = 7008 where pharmacyID=1008 and medicineID=1111;
select * from keep_log;


