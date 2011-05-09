/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
function clearSelectionBox(selectBox){
    for(var i=selectBox.options.length-1;i>=0;i--){
        selectBox.remove(i);
    }
}

function disabledElement(elementArr){
    for(var i=0;i<elementArr.length;i++){
        elementArr[i].disabled=true;
    }
}

function enabledElement(elementArr){
    for(var i=0;i<elementArr.length;i++){
        elementArr[i].disabled=false;
    }
}

