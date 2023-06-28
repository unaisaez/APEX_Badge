import { LightningElement, track, wire, api } from 'lwc';
import getConfigs from '@salesforce/apex/ProcessConfigurations.getConfigs';
import getFieldList from '@salesforce/apex/ProcessConfigurations.getFieldList';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';
import {getRecord} from 'lightning/uiRecordApi';

import myModal from 'c/myModal';


export default class SalesConfigurator extends LightningElement {
    //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    isModalOpen = false;
    recordDetails;
    relatedData;
    configs=[];
    fields=[];
    text;
    configuredObject;
    error = undefined;
    @api objectDesc;
    objectSelected ='';
    @api recordId;
    creationFields;

    connectedCallback(){
        this.configuredObject = this.objectDesc;
    }

    //variable to get Confgirations to open the modal 
    @wire (getConfigs, {objectDes:'$configuredObject'})
    configs({data,error}){
        if(data){
            //If has fields consider to be added to the layout
            for(let i=0; i<data.length; i++){
                if(data[i].Field__c){
                    this.fields.push(data[i]);
                }
                //if no field is being used for related lists
                else{
                    this.configs.push(data[i]);
                }
            }
            this.text='';
        }
        if(error){
            alert(JSON.stringify(error));
            this.error = error;
        }
    };

    

     // GET the recordDetails to be shared with the modal
   @wire(getRecord, {
        recordId: '$recordId',
        layoutTypes: 'Full'
    }) oppDetails({data,error}){
        if(data){
            this.recordDetails = JSON.stringify(data);
        }
        if(error){
            alert(JSON.stringify(error));
            this.error = error;
        }
    };

    // GET the related list to be shared with the modal (hardcoded for demo purposes and to avoid apex classes)
    @wire(getRelatedListRecords, {
        parentRecordId: '$recordId',
        relatedListId: 'Partners', //this.configs
        optionalFields: ['Partner.ContactId', 'Partner.Role']
    }) relatedDetails({data,error}){
        if(data){
            this.relatedData = JSON.stringify(data);
        }
        if(error){
            alert(JSON.stringify(error));
            this.error = error;
        }
    };

    //get all fields from an object to create a new record in the modal
    async getFields(selectedObject){
        await getFieldList({objectType: selectedObject})
        .then((data)=>{
            this.creationFields = data;
        })
        .catch((error)=>{
            console.log(error);
        });
    }

    

    //Method to open the modal
    async handleModal(e){
        this.objectSelected = e.target.label;
        await this.getFields(this.objectSelected);
        setTimeout(1000);
        this.recordData = await myModal.open({
            description: this.recordDetails,
            size: 'large',
            content: this.relatedData,
            label: 'Component',
            originId: this.objectSelected,
            object: this.objectSelected,
            fields: this.creationFields
        });

    }


    //methods to show a modal in the same components
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }

    
}