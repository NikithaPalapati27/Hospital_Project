select pharmacyid,pharmacyname,
sum(quantity) as total_quantity,sum(case when hospitalexclusive='s' then quantity else 0 end)
as exclusive,sum(case when hospitalexclusive='s' then quantity else 0 end)/sum(quantity) as ratio
from pharmacy join prescription 
using(pharmacyid)
join treatment using(treatmentid)
join contain using(prescriptionid)
join medicine using(medicineid)
where year(date)='2022'
group by pharmacyid
order by ratio desc;


-- 2

select state,
(sum(if(claimid is null,1,0))/count(treatmentid))*100 as PERCENTAGE
from address join PERSON using(addressid)
join PATIENT ON PERSONID=PATIENTID
 join treatment using(PATIENTID)
 LEFT JOIN CLAIM USING(CLAIMID)
group by state
order by PERCENTAGE desc;

-- 3
with cte as (
select a.state ,t.diseaseid  , count(t.diseaseID) as cnt
from 
address a join person p using(addressID) 
join treatment t on t.patientID = p.personID 
where year(t.`date`) = 2022
group by a.state,t.diseaseID)
, cte2 as (select state , min(cnt) as minn, max(cnt) as maxx from cte group by state)
-- select * from cte2;
select cte.* from cte join cte2 on cte.state = cte2.state where cte.cnt in (cte2.minn, cte2.maxx );

-- 4
select city,count(patientid) as count_registered,
count(patientid)/count(personid) as ratio
from address join person 
using(addressid)
left join patient on personid=patientid
group by city
having count(patientid)>10;


-- 5
select companyname,count(medicineid) as count from medicine
where substancename='ranitidina'
group by companyname
order by count(medicineid) desc
limit 3;

