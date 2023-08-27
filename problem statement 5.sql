-- 1

select p1.personname,count(t.treatmentid) as count,timestampdiff(Year,dob,now()) as age 
from person p1 join patient p2
on p1.personid=p2.patientid
join treatment t
on p2.patientid=t.patientid
group by personname,
timestampdiff(Year,dob,now())
having count(t.treatmentid)>1
order by count(t.treatmentid) desc;

-- 2

select *,t.malecount/t.femalecount as male_to_female from (select diseasename,sum(case when gender='Male' then 1 else 0 end) as malecount,
sum(case when gender='female' then 1 else 0 end) as femalecount 
from treatment join disease using(diseaseid)
join patient using(patientid)
join person on patientid=personid
where Year(date)='2021'
group by diseasename) t;

-- 3
with Disease_City_Treatments as
(
select diseaseName,city,count(treatmentID) as no_of_treatments
from patient
join treatment using(patientId)
join person on patientId = personId
join disease using(diseaseId)
join address using(addressId)
group by diseaseName,city
),Rank_For_Top3_Cities as
(
	select *,row_number() over(partition by diseaseName order by no_of_treatments desc) as ranks
    from Disease_City_Treatments
)
select distinct a.diseaseName,b.city as city,c.city as city2,d.city as city3  from 
(select diseaseName from Rank_For_Top3_Cities) a left join
(select diseaseName,city from Rank_For_Top3_Cities where ranks =1) b on a.diseaseName = b.diseaseName left join 
(select diseaseName,city from Rank_For_Top3_Cities where ranks =2) c on a.diseaseName = c.diseaseName left join
(select diseaseName,city from Rank_For_Top3_Cities where ranks =3) d on a.diseaseName = d.diseaseName;


-- 4
SELECT pharmacyname,diseasename,
SUM(CASE WHEN year(date) = 2021 THEN 1 ELSE 0 END) AS prescriptions_2021,
SUM(CASE WHEN year(date) = 2022 THEN 1 ELSE 0 END) AS prescriptions_2022
from prescription join pharmacy using(pharmacyid)
join treatment using(treatmentid) 
join disease using(diseaseid)
group by pharmacyname,diseasename
order by pharmacyname;

-- 5
SELECT  companyname,state, COUNT(claimid) AS claim_count
 from address join insurancecompany
 using(addressid)
JOIN insuranceplan using(companyid)
join claim using(uin)
GROUP BY companyname,state
ORDER BY  companyname,state,count(*) DESC ;





