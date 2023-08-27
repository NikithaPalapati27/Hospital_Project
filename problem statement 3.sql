/* :  Some complaints have been lodged by patients that they have been prescribed 
hospital-exclusive medicine that they can’t find elsewhere and facing problems due to that. 
Joshua, from the pharmacy management, wants to get a report of which pharmacies have prescribed 
hospital-exclusive medicines the most in the years 2021 and 2022. 
Assist Joshua to generate the report so that the pharmacies who prescribe 
hospital-exclusive medicine more often are advised to avoid such practice if possible.   */
SELECT
    P.pharmacyID,P.pharmacyName,COUNT(m.hospitalexclusive) AS prescriptionsCount
FROM Pharmacy P
JOIN  PRESCRIPTION P1 ON P.PHARMACYID=P1.PHARMACYID
JOIN Treatment T ON P1.TREATMENTID = T.TREATMENTID
JOIN contain c ON p1.prescriptionID = c.prescriptionID
JOIN Medicine M ON c.medicineID = M.medicineID
WHERE
M.hospitalExclusive = 'S'
AND T.date BETWEEN '2021-01-01' AND '2022-12-31'
GROUP BY P.pharmacyID, P.pharmacyName
ORDER BY prescriptionsCount DESC;


/*Insurance companies want to assess the performance of their insurance plans. 
Generate a report that shows each insurance plan, the company that issues the plan, 
and the number of treatments the plan was claimed for.*/

select planname,companyname,count(treatmentid) as count 
from insurancecompany join insuranceplan
using(companyid)
join claim using(uin)
join treatment using(claimid)
group by planname,companyname;


/*Insurance companies want to assess the performance of their insurance plans.
 Generate a report that shows each insurance company's 
name with their most and least claimed insurance plans.*/
with 
 performance_report as (select ic.CompanyName,ip.planName,count(tr.claimid) as claim_count from insurancecompany ic
 join insuranceplan ip using(companyid) join claim c using(uin) join treatment tr using(claimid) 
 group by ic.CompanyName,ip.planName order by ic.companyName),
 most_claimed as ( select CompanyName,planName as 'Most claimed plan',claim_count from performance_report where (CompanyName,claim_count) 
 in (select CompanyName,max(claim_count) as claim_count from performance_report group by CompanyName)),
 least_claimed as ( select CompanyName,planName as 'least claimed plan',claim_count from performance_report where (CompanyName,claim_count) 
 in (select CompanyName,min(claim_count) as claim_count from performance_report group by CompanyName))
select * from least_claimed join most_claimed using(companyName);

/*The healthcare department wants a state-wise health report to assess which state 
requires more attention in the healthcare sector.
 Generate a report for them that shows the state name, number of registered people in the 
 state, number of registered patients in the state, and the people-to-patient ratio. 
 sort the data by people-to-patient ratio. */
 
select a.state,count(personid) as person_count,
count(patientid) as patient_count,
count(personid)/count(patientid) as ratio
from address a left join person p1 on a.addressid=p1.addressid
left join patient p2 
on p1.personid=p2.patientid
group by a.state; 


/*Jhonny, from the finance department of Arizona(AZ), has requested a report that 
lists the total quantity of medicine each pharmacy in his state has prescribed that 
falls under Tax criteria I for treatments that took place in 2021. 
Assist Jhonny in generating the report. */

select p1.pharmacyname,sum(c.quantity) as count from address a join
pharmacy p1 on a.addressid=p1.addressid
join prescription p2 
on p1.pharmacyid=p2.pharmacyid
join contain c on 
p2.prescriptionid=c.prescriptionid
join medicine m 
on c.medicineid=m.medicineid
join treatment using(treatmentid)
where m.taxcriteria='I' and year(date)='2021' and a.state='AZ'
group by p1.pharmacyname;


