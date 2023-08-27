delimiter $$
create procedure my_Procedure(in id int)
begin
with cte as (select planname,diseasename,count(claimid) as claim_count ,
rank() over(partition by planname order by count(claimid) desc) as rnk
from insuranceplan join claim using(uin)
join treatment using(claimid)
join disease using(diseaseid)
where companyid=id
group by planname,diseasename
),
cte2 as (select planname,sum(claim_count) as total from cte group by planname)
select planname,total,claim_count,diseasename from cte join cte2 using(planname) 
where rnk=1;
end $$
drop procedure my_procedure;
call my_Procedure(1933);
-- 2
delimiter $$
create procedure p1(in name varchar(30))
begin
with cte as (SELECT Pharmacyname, COUNT(*) AS PreferenceCount
    FROM pharmacy join prescription using(pharmacyid)
    join treatment using(treatmentid) 
    join disease using(diseaseid)
    WHERE Diseasename= name AND Year(date) = '2021'
    GROUP BY Pharmacyname
    ORDER BY PreferenceCount DESC limit 3),
cte2 as (SELECT Pharmacyname, COUNT(*) AS PreferenceCount
    FROM pharmacy join prescription using(pharmacyid)
    join treatment using(treatmentid) 
    join disease using(diseaseid)
    WHERE Diseasename= name AND Year(date) = '2022'
    GROUP BY Pharmacyname
    ORDER BY PreferenceCount DESC limit 3)
    SELECT DISTINCT T1.Pharmacyname AS CommonPharmacy
    FROM cte T1
    JOIN cte  T2 ON T1.Pharmacyname = T2.Pharmacyname;
    end $$
drop procedure p2;
call p1('Asthma');
select * from disease;

-- 3
drop procedure p2;
delimiter $$
create procedure p_1(in state1 varchar(10))
begin
 with cte as (select state,count(patientid) as num_patients,count(companyid) as 
 num_insurance_companies,
count(companyid)/count(patientid) as insurance_patient_ratio
from address a
left join person p using(addressid)
left join patient pa on p.personid=pa.patientid
left join insurancecompany ic using(addressid)
group by state)

select *,(select avg(insurance_patient_ratio) from cte),
case when insurance_patient_ratio<(select avg(insurance_patient_ratio) from cte) then 'Recommended'
else 'Not Recommended' end as category 
from cte where state1 = state;
end $$
delimiter ;
call p_1('OK');

-- 4
drop table PlacesAdded;
create table if not exists PlacesAdded(
 placeID int auto_increment primary key ,
 placeName varchar(50) not null,
 placeType ENUM('city', 'state') NOT NULL,
 timeAdded datetime not null);
 
drop trigger for_placesAdded1;
delimiter //
 create trigger for_PlacesAdded1
 after insert on address for each row
 begin
	insert into PlacesAdded(placeName,placeType,timeAdded) values(new.city,'city',now());
    insert into PlacesAdded(placeName,placeType,timeAdded) values(new.state,'state',now());
 end;
 //
delimiter ;

delete from address where addressID=100241;
INSERT INTO Address VALUES (100241,'21323 North 64th Avenue','Glendale','AZ',85308);

select * from placesAdded;


-- 5
drop table keep_log;
create table if not exists Keep_Log(
id int auto_increment primary key,
medicineID int not null,
quantity int not null);

delimiter //
create trigger update_log
after update on keep for each row
begin
if old.quantity <> new.quantity then
	insert into Keep_Log(medicineID,quantity) values(new.medicineID,new.quantity-old.quantity);
end if;
end //
delimiter ;

select * from keep;
update keep set keep.quantity= 5940 where (pharmacyID=1008 and medicineID=1111);
select * from Keep_Log;


