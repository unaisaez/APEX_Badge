public with sharing class IndirectController {

    @AuraEnabled (cacheable=true)
    public static List<AccountContactRelation> getContacts(String recordId, Integer numRecords){
        return [SELECT Id, Contact.FirstName, Contact.LastName, Contact.Email, Roles  FROM AccountContactRelation WHERE AccountId = :recordId LIMIT :numRecords];
    }
}

/*List<Contact> ctList = new List<Contact>();
        List<AccountContactRelation> indirect = [SELECT Id, Contact.FirstName, Contact.LastName, Contact.Email, Roles  FROM AccountContactRelation WHERE AccountId = :recordId ];
        for(AccountContactRelation act: indirect){
            Contact ct = new Contact();
            
            ctList.add(ct);
        }*/