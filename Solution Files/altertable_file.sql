describe contain;
-- claim
alter table claim add constraint fk_uin_claim foreign key (uin) references insuranceplan(uin);

-- contain 
alter table contain add constraint fk_contain_precriptionid foreign key (prescriptionID) references prescription(prescriptionId);
alter table contain add constraint fk_contain_medicineid foreign key (medicineID) references medicine(medicineId);

-- insurancecompany
alter table insurancecompany add constraint fk_insurancecompany_addressid foreign key (addressID) references address(addressId);

-- insuranceplan
alter table insuranceplan add constraint fk_insuranceplan_companyid foreign key (companyID) references insurancecompany(companyId);

-- keep 
alter table keep add constraint fk_keep_pharmacyid foreign key (pharmacyID) references pharmacy(pharmacyId);
alter table keep add constraint fk_keep_medicineid foreign key (medicineID) references Medicine(medicineId);

-- patient
alter table patient add constraint fk_patient_personid foreign key (patientID) references person(personId);

-- person
alter table person add constraint fk_person_addressid foreign key (addressID) references Address(addressId);

-- pharmacy
alter table pharmacy add constraint fk_pharmacy_pharmacyid foreign key (addressID) references Address(addressId);

-- prescription
alter table prescription add constraint fk_prescription_treatmentid foreign key (treatmentID) references treatment(treatmentId);
alter table prescription add constraint fk_prescription_pharmacyid foreign key (pharmacyID) references pharmacy(pharmacyId);

-- treatment
alter table treatment add constraint fk_treatment_diseaseid foreign key (diseaseID) references disease(diseaseId);
alter table treatment add constraint fk_treatment_patientid foreign key (patientID) references patient(patientId);








