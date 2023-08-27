/* Jimmy, from the healthcare department, has requested a report that shows how the number of treatments each age category of patients has gone through in the year 2022. 
The age category is as follows, Children (00-14 years), Youth (15-24 years), Adults (25-64 years), and Seniors (65 years and over).
Assist Jimmy in generating the report. 
*/
SELECT CASE 
	WHEN YEAR(CURDATE())-YEAR(DOB) <=14 THEN 'CHILDREN'
    WHEN YEAR(CURDATE())-YEAR(DOB) >=15 AND YEAR(CURDATE())-YEAR(DOB) <=24 THEN 'YOUTH'
    WHEN YEAR(CURDATE())-YEAR(DOB) >=25 AND YEAR(CURDATE())-YEAR(DOB) <=64 THEN 'ADULTS'
    ELSE 'SENIORS'
    END AS AGE_CATEGORY,COUNT(PATIENTID) AS COUNT FROM PATIENT JOIN TREATMENT USING(PATIENTID) WHERE YEAR(DATE)='2022' GROUP BY AGE_CATEGORY;

/*Jimmy, from the healthcare department, wants to know which disease is infecting people of which gender more often.
Assist Jimmy with this purpose by generating a report that shows for each disease the male-to-female ratio. Sort the data in a way that is helpful for Jimmy.
*/
SELECT DISEASENAME,SUM(CASE WHEN GENDER='MALE' THEN 1 ELSE 0 END)
/SUM(CASE WHEN GENDER='FEMALE' THEN 1 ELSE 0 END)  RATIO
 FROM DISEASE JOIN TREATMENT USING(DISEASEID) 
JOIN PATIENT P1 USING(PATIENTID) 
JOIN PERSON P2 ON P1.PATIENTID=P2.PERSONID GROUP BY DISEASENAME ORDER BY RATIO DESC; 


/* Jacob, from insurance management, has noticed that insurance claims are not made for 
all the treatments.He also wants to figure out if the gender of the patient has any 
impact on the insurance claim.Assist Jacob in this situation by generating a 
report that finds for each gender the number of treatments,
 number of claims, and treatment-to-claim ratio. 
 And notice if there is a significant difference between the treatment-to-claim ratio 
 of male and female patients.*/
 
SELECT P2.GENDER,COUNT(TREATMENTID) AS TREATMENT,COUNT(CLAIMID) AS CLAIM,
 COUNT(TREATMENTID)/COUNT(CLAIMID) AS RATIO
 FROM TREATMENT JOIN PATIENT P1 USING(PATIENTID) 
 JOIN PERSON P2 ON P1.PATIENTID=P2.PERSONID
 GROUP BY P2.GENDER;
 
 
 /*The Healthcare department wants a report about the inventory of pharmacies.
 Generate a report on their behalf that shows how many units of medicine each pharmacy has 
 in their inventory, the total maximum retail price of those medicines, and the 
 total price of all the medicines after discount. 
Note: discount field in keep signifies the percentage of discount on the maximum price.*/

SELECT PHARMACYNAME,SUM(QUANTITY) AS UNIT,
SUM(QUANTITY*MAXPRICE) AS RETAIL_PRICE,
ROUND(SUM(QUANTITY*MAXPRICE-(DISCOUNT/100)*(QUANTITY*MAXPRICE)),2) 
AS DISCOUNT FROM 
KEEP JOIN MEDICINE USING(MEDICINEID) 
JOIN PHARMACY USING(PHARMACYID) 
GROUP BY PHARMACYNAME;
 
 
 /*The healthcare department suspects that some pharmacies prescribe more medicines 
 than others in a single prescription, for them, generate a report that finds for 
 each pharmacy the maximum, minimum and average number of medicines prescribed 
 in their prescriptions. */
  SELECT PHARMACYID,MAX(QUANTITY),MIN(QUANTITY),AVG(QUANTITY) 
  FROM CONTAIN JOIN PRESCRIPTION USING(PRESCRIPTIONID) 
  GROUP BY PHARMACYID;

