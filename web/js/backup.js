/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function getButtonGroupValue(buttonGroup){
    for(var i=0;i<buttonGroup.length;i++){
        if(buttonGroup[i].checked){
            return buttonGroup[i].value;
        }
    }
}


