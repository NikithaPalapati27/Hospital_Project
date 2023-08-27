/* A company needs to set up 3 new pharmacies, they have come up with an idea 
that the pharmacy can be set up in cities where the pharmacy-to-prescription ratio is 
the lowest and the number of prescriptions should exceed 100. 
Assist the company to identify those cities where the pharmacy can be set up.*/
SELECT distinct a.city,
       COUNT(DISTINCT p.pharmacyid) AS num_pharmacies,
       COUNT(DISTINCT pr.prescriptionid) AS num_prescriptions,
       COUNT(DISTINCT p.pharmacyid) / COUNT(DISTINCT pr.prescriptionid) AS pharmacy_prescription_ratio
FROM address a
LEFT JOIN pharmacy p ON a.addressid = p.addressid
LEFT JOIN prescription pr ON p.pharmacyid = pr.pharmacyid
GROUP BY a.city
HAVING COUNT(pr.prescriptionid) > 100
order by pharmacy_prescription_ratio ;


/*The State of Alabama (AL) is trying to manage its healthcare resources more efficiently.
 For each city in their state, they need to identify the disease for which the maximum number 
 of patients have gone for treatment. Assist the state for this purpose.
Note: The state of Alabama is represented as AL in Address Table.*/
with report as(
select city,diseasename,count(distinct patientid) as Count from address join person using(addressid) 
join patient on patient.patientid=person.personid
join treatment using (patientid) join disease using(diseaseid) where state='AL' 
group by city,diseasename order by city)
select * from report where (city,count) in (select city,max(count) from report group by city);



/*The healthcare department needs a report about insurance plans. 
The report is required to include the insurance plan,
 which was claimed the most and least for each disease.  
 Assist to create such a report.*/
 with cte as (select d.diseasename , i.planName , count(i.planName) as cnt from 
treatment t right join claim c using(claimId) join disease d using(diseaseid)
join insuranceplan i using(UIN)
group by i.planName,d.diseasename),
cte2 as ( select diseasename , min(cnt) as minn, max(cnt) as maxx from cte group by diseasename)
select cte.* from cte2 join cte using(diseasename) where cnt in (cte2.minn, cte2.maxx) order by diseasename, cnt desc;

/*The Healthcare department wants to know which disease is most likely to infect multiple
 people in the same household. For each disease find the number of households that has 
 more than one patient with the same disease. 
Note: 2 people are considered to be in the same household if they have the same address. */
select diseasename,count(p.patientid) as count from disease
 join treatment using(diseaseid) join patient p
 using(patientid)
join person p1 on p.patientid=p1.personid 
join  address using(addressid)
group by address1,diseasename
having count>=2;

/*An Insurance company wants a state wise report of the treatments 
to claim ratio between 1st April 2021 
and 31st March 2022 (days both included). Assist them to create such a report.*/

select state,count(treatmentid)/count(claimid)  as ratio
from address left join person p1 using(addressid)
left join patient p2 on p1.personid=p2.patientid
left join treatment using(patientid)
left join claim using(claimid)
where date between '2021-04-01' and '2022-03-31'
group by state ; 






