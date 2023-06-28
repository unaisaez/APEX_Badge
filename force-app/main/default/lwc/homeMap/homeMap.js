import { LightningElement, wire, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getCorporateAccounts from '@salesforce/apex/homeMap.getCorporateAccounts';

// Declare the const SUPPORTED_COUNTRIES FIELD
const SUPPORTED_COUNTRIES = 'Account.Supported_countries__c';
const MAP_FIELDS = [SUPPORTED_COUNTRIES];

export default class HomeMap extends LightningElement {
    @api zoomLevel; 
    @api recordId='';
    error = undefined;
    text1 ='';
    hasRecord = false;
    text2 ='';
    mapMarkers = [];

    // Getting record's location to construct map markers using recordId
    @wire (getRecord, {recordId: '$recordId', fields: MAP_FIELDS}) 
    accDetails({error, data}) {
      if (data){
        this.error = undefined;
        this.updateMap(data, 1);
      } else if (error) {
        this.error = error;
        this.recordId = undefined;
        this.mapMarkers = [];
  }
    };

    @wire (getCorporateAccounts)
        wiredRecord({ error, data }) {
          // Error handling
          if (data) {
                this.error = undefined;
                if (!this.hasRecord) this.updateMap(data, 0);
          } else if (error) {
                this.error = error;
                this.mapMarkers = [];
          }
      }

    // Creates the map markers array with the current locations for the map.
    updateMap(accounts, flag) {
      
        var newMarkers = [];
        this.text1 = this.text1 + 'TEXT1 - '  + JSON.stringify(accounts);
        if (accounts){  
          if(flag == 1){   
              this.hasRecord = true;
              newMarkers = accounts.fields.Supported_countries__c.value.split(';').map(cc=>{
                return {
                  title: cc,
                  location: {
                    Country: cc
                  }
                }
              });
            
          } else {
            newMarkers = accounts.map(account=>{
              return {
                title: account.Name,
                location: {
                    Latitude: account.Billing_Location__Latitude__s,
                    Longitude: account.Billing_Location__Longitude__s
                }
              };
            });
          }
          //this.text = 'MAP' +  JSON.stringify(newMarkers);
          this.mapMarkers = newMarkers;
        }
        
    }
    // Getter method for displaying the map component, or a helper method.
    get showMap() {
        return this.mapMarkers.length > 0;
    }
}