public with sharing class homeMap {
    @AuraEnabled (cacheable=true)
    public static List<Account> getCorporateAccounts(){
        return [SELECT Id, Name, Type, Billing_Location__Latitude__s, Billing_Location__Longitude__s FROM Account where type = 'HQ'];
    }

    @invocableMethod (label='Update Location' description='Get the location coordinates of an account')
    public static void updateLocation(List<sObject> a){
        double lat;
        double lng;
        String city = null;
        String street = null;
           String stateCode = null; 
        String countryCode = null;

        Account ax = (Account) a.get(0);
        
        Account record = [SELECT BillingAddress FROM Account WHERE Id  = :ax.id LIMIT 1];
        System.debug('accounts' + a.size());
        System.debug(record.id);
        
        Address customAddress = record.BillingAddress;
            if (customAddress!=null){
            //Remove white spaces from address components
            if(customAddress.getCity() != null){
                city = customAddress.getCity().deleteWhitespace();
            }
            if(customAddress.getStreet() != null){
                street = customAddress.getStreet().deleteWhitespace();
            }
            if(customAddress.getCountryCode() != null){
                countryCode = customAddress.getCountryCode();
            }    
            
            //concatenate strings
            String address = street+city+countryCode;

            System.debug('address' + address);

            try {
                getLatitude(address, record.id );
            } catch (Exception e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }

    }

    @future(callout=true)
    private static void getLatitude(String address, Id idAccount){
        double lat;
        double lng;
        
        Account record = [SELECT BillingAddress FROM Account WHERE Id  = :idAccount LIMIT 1];

        String key='EMPTY';
        Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        // Set the endpoint URL.
        // USING GOOGLE MAP API 
        String endpoint = 'https://maps.googleapis.com/maps/api/geocode/json?address='+address+'&key='+key;
        request.setEndPoint(endpoint);
        // Set the HTTP verb to GET.
        request.setMethod('GET');
        // Send the HTTP request and get the response.
        // The response is in JSON format.
        HttpResponse response = httpProtocol.send(request);

        System.debug('response' + response.getBody());
    
       // Parse JSON response to get all the totalPrice field values.
        JSONParser parser = JSON.createParser(response.getBody());
        
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'lat')) {
                parser.nextToken();
                // Get latitude
                lat = parser.getDoubleValue();
           
                parser.nextToken();
                parser.nextToken();
                //Get longitude    
                lng = parser.getDoubleValue();
            } 
        }
        // Update lat long of account record
        record.Billing_Location__Latitude__s=lat;
        record.Billing_Location__Longitude__s=lng;
    
        System.debug('Latitude__s' + lat + 'Longitude__s' + lng);
        
        update record;

    }
}