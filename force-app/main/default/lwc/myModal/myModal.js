import { wire, api } from 'lwc';
import LightningModal from 'lightning/modal';


export default class MyModal extends LightningModal {
    @api content;
    @api label;
    @api size;
    @api description;
    @api originId;
    @api fields;
    @api object;

    //constructor(){super();}

    //connectedCallback(){}
    
    //render(){}

    //renderedCallback(){}

    handleOkay(){
        this.close('Related ' + this.content + ' was reviewed');
    }

}