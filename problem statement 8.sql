-- 1

WITH AgeCTE AS (
    SELECT
        patientID,
        DATEDIFF(YEAR, dob, GETDATE()) AS age
    FROM Person
    JOIN Patient ON Patient.patientID = Person.personID
)SELECT age,COUNT(*) AS numTreatments
FROM AgeCTE
JOIN Treatment ON Treatment.patientID = AgeCTE.patientID
GROUP BY age
ORDER BY numTreatments DESC;

-- 2
WITH PharmacyCount AS (
    SELECT Address.city, COUNT(Pharmacy.pharmacyID) AS numPharmacy
    FROM Pharmacy
    RIGHT JOIN Address ON Pharmacy.addressID = Address.addressID
    GROUP BY Address.city
),
InsuranceCompanyCount AS (
    SELECT Address.city, COUNT(InsuranceCompany.companyID) AS numInsuranceCompany
    FROM InsuranceCompany
    RIGHT JOIN Address ON InsuranceCompany.addressID = Address.addressID
    GROUP BY Address.city
),
RegisteredPeopleCount AS (
    SELECT Address.city, COUNT(Person.personID) AS numRegisteredPeople
    FROM Person
    RIGHT JOIN Address ON Person.addressID = Address.addressID
    GROUP BY Address.city
)

SELECT pc.city, rp.numRegisteredPeople, ic.numInsuranceCompany, pc.numPharmacy
FROM PharmacyCount pc
JOIN InsuranceCompanyCount ic ON pc.city = ic.city
JOIN RegisteredPeopleCount rp ON pc.city = rp.city
ORDER BY rp.numRegisteredPeople DESC;


-- 3
SELECT 
    C.prescriptionID,
    SUM(quantity) AS totalQuantity,
    CASE 
        WHEN SUM(quantity) < 20 THEN 'Low Quantity'
        WHEN SUM(quantity) < 50 THEN 'Medium Quantity'
        ELSE 'High Quantity' 
    END AS Tag
FROM Contain C
JOIN Prescription P ON P.prescriptionID = C.prescriptionID
JOIN Pharmacy ON Pharmacy.pharmacyID = P.pharmacyID
WHERE Pharmacy.pharmacyName = 'Ally Scripts'
GROUP BY C.prescriptionID, Tag;

-- 4
WITH PrescriptionsWithQuantity AS (
    SELECT 
        Pharmacy.pharmacyID, 
        Prescription.prescriptionID, 
        SUM(quantity) AS totalQuantity
    FROM Pharmacy
    JOIN Prescription ON Pharmacy.pharmacyID = Prescription.pharmacyID
    JOIN Contain ON Contain.prescriptionID = Prescription.prescriptionID
    JOIN Medicine ON Medicine.medicineID = Contain.medicineID
    JOIN Treatment ON Treatment.treatmentID = Prescription.treatmentID
    WHERE YEAR(date) = 2022
    GROUP BY Pharmacy.pharmacyID, Prescription.prescriptionID
),
AverageQuantity AS (
    SELECT AVG(totalQuantity) AS avgQuantity FROM PrescriptionsWithQuantity
)

SELECT P.*
FROM PrescriptionsWithQuantity P
CROSS JOIN AverageQuantity A
WHERE P.totalQuantity > A.avgQuantity;



-- 5
SELECT Disease.diseaseName, COUNT(*) AS numClaims
FROM Disease
JOIN Treatment ON Disease.diseaseID = Treatment.diseaseID
JOIN Claim ON Treatment.claimID = Claim.claimID
WHERE Disease.diseaseName LIKE '%p%'
GROUP BY Disease.diseaseName;




