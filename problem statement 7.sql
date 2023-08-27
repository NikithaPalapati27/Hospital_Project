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

call claim_rate(30,@result);
select @result;


-- 2
drop procedure p3;
delimiter $$
create procedure p3(in id int)
begin
with a as (select diseasename,
	sum(case when gender ='male' then 1 else 0 end) as male_count,
	sum(case when gender ='female' then 1 else 0 end) as female_count
from disease join 
treatment using (diseaseid) 
join patient using(patientid)
join person on personid=patientid
where diseaseid=id
group by diseasename)
select diseasename,male_count,female_count,
case 
	when male_count>female_count then 'male'
	when male_count=female_count then 'same'
    else 'female' end as most_treated_gender from a;

end $$
delimiter ;
call p3(5);


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
case when maxprice>1000 then 'pricey'
when maxprice<5 then 'affordable' end as price_category
from medicine;

