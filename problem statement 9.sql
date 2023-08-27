-- 1
select state,coalesce(gender,'total') as gender,count(treatmentid)  as count
from address join person using(addressid)
join patient on personid=patientid
join treatment using(patientid)
join disease using(diseaseid)
where diseasename='Autism'
group by state,gender with rollup;



-- approach 2

with cte9 as (select state,coalesce(gender,'Total') as gender,count(distinct(treatmentID)) as cou from address a left join person p using(addressID)
join patient pt on pt.patientID=p.personID
join treatment using(patientID) 
join disease using(diseaseID)
where diseaseName='Autism' group by state,gender with rollup)
select state,sum(male_cou) as male_count,sum(female_cou) as female_count,sum(total_cou) as total_count from (
select state,case when gender='male' then cou end as male_cou,case when gender='female' then cou end as female_cou,case when gender='Total' then cou
end as total_cou from cte9) a where a.state is not null group by state;
-- 2
select planname,companyname,coalesce(year,'total 3 years') as year,count from 
(select planname,coalesce(companyname,'No company') as companyname,year(date) as year,count(treatmentid) as count 
from insurancecompany join insuranceplan using(companyid)
join claim using(UIN) join treatment using(claimid)
where year(date) in ('2020','2021','2022')
group by planname,companyname,year with rollup) as t;

-- 3
select * from (
select state,total_count,case when rnk1 = 2 then diseasename end as most_treated_disease ,case when rnk2=1 then diseasename end as least_treated_disease from (
select state,diseasename,count(treatmentid) as total_count ,row_number()
over(partition by state order by count(treatmentid) desc) as rnk1,
row_number() over(partition by state order by count(treatmentid) asc) as rnk2 
from address join person using(addressid) join patient on personid=patientid
join treatment using(patientid) join disease using(diseaseid)
where year(date)='2022'
group by state,diseasename with rollup) as p1) as p2 where 
(most_treated_disease is null and least_treated_disease is not null) or 
(most_treated_disease is not null and least_treated_disease is null) or 
(state is null and most_treated_disease is  null and least_treated_disease is null);

-- 4
with cte as (select pharmacyname,coalesce(diseasename,'Total_count') as diseasename,count(prescriptionid) as prescription_count from pharmacy join
prescription using(pharmacyid) join treatment using(treatmentid) join disease using(diseaseid)
where year(date)='2022'
group by pharmacyname,diseasename with rollup),
cte2 as (select diseasename,count(prescriptionid) as prescription_for_disease 
from prescription join treatment using(treatmentid) join disease using(diseaseid) 
where year(date)='2022' group by diseasename)

select cte.*,cte2.prescription_for_disease from cte join cte2 using(diseasename);

-- 5
select diseasename,sum(case when gender='male' then 1 else 0 end) as male_count,
sum(case when gender='female' then 1 else 0 end) as female_count from person
join patient on personid=patientid join treatment using(patientid) 
join disease using(diseaseid)
where year(date)='2022'
group by diseasename with rollup;













