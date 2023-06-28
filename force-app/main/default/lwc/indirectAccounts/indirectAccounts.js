import { LightningElement,api, wire } from 'lwc';
import {refreshApex} from '@salesforce/apex';

import FIRST_NAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LAST_NAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import RELATION_FIELD from '@salesforce/schema/AccountContactRelation.Roles';

import getContacts from '@salesforce/apex/IndirectController.getContacts';

const COLUMNS = [
    { label: 'First Name', fieldName: FIRST_NAME_FIELD.fieldApiName, type: 'text', sortable:'true', hideDefaultActions:'true'},
    { label: 'Last Name', fieldName: LAST_NAME_FIELD.fieldApiName, type: 'text', hideDefaultActions:'true' },
    { label: 'Email', fieldName: EMAIL_FIELD.fieldApiName, type: 'text', hideDefaultActions:'true' },
    { label: 'Relation Type', fieldName: RELATION_FIELD.fieldApiName, type: 'text', hideDefaultActions:'true' },
    { label: 'Times', fieldName: 'Times', type: 'Integer', sortable:'true' , hideDefaultActions:'true'}
];

/*They would like the users to see the indirect Account relationships via Contacts directly on the Account record using a 
custom Lightning WebComponent. The admins would be able to drop this component interactively on the record detail page
using the App Builder. The admins should also be able to configure it so that the number of items shown can be changed and the 
list of items can be sorted by name or number of times the relationship occurs.*/

export default class IndirectAccounts extends LightningElement {
    @api recordId;
    @api numRecords; 
    recData;
    errors;
    text;
    columns = COLUMNS;
    sortedBy;
    sortedDirection;

    @wire (getContacts, {recordId: '$recordId', numRecords: '$numRecords'})
    contacts({data,error}){
        if(data){
            this.recData =  data.map(record => 
                Object.assign({'FirstName' : record.Contact.FirstName, 'LastName' : record.Contact.LastName, 'Email' : record.Contact.Email },record));

                //Check the multipicklist and duplicate a record per iteration adding a count

        }
        if(error){
            this.errors = error;
        }
    };

    connectedCallback(){
        refreshApex (this.contacts);
    }

    get errors() {
        return this.contacts.error;
    }

    // The method onsort event handler
    updateColumnSorting(event) {
        var fieldName = event.detail.fieldName;
        var sortDirection = event.detail.sortDirection;
        // assign the latest attribute with the sorted column fieldName and sorted direction
        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;
        
        let parseData = JSON.parse(JSON.stringify(this.recData));
        // Return the value stored in the field
        let keyValue = (a) => {
            //exclude objects
            return a[fieldName];
        };

        // cheking reverse direction
        let isReverse = sortDirection === 'asc' ? 1: -1;
        // sorting data 

        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.recData = parseData; 
   }

   
    

}