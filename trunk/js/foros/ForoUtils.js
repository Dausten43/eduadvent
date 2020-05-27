class ForoUtils {

    parseDate (dateUnparsed){
        const date = new Date(dateUnparsed);
        let day = date.getDate() > 10 ? date.getDate(): "0" + date.getDate();
        let month = date.getMonth() > 9 ? date.getMonth() + 1 : "0" + (date.getMonth() + 1); 
        let hours = date.getHours() > 9 ? date.getHours() : "0" + date.getHours();
        let minutes = date.getMinutes() > 9 ? date.getMinutes() : "0" + date.getMinutes();
        let seconds = date.getSeconds() > 9 ? date.getSeconds() : "0" + date.getSeconds();

        const now = day + "/" + month + "/" + date.getFullYear() + " " + hours + ":" + minutes + ":" + seconds;
        return now;
    }

    generateUriParams(objParams){
        let params = "";
        let size = Object.keys(objParams).length;
        for(let key in objParams){
            params += key + "=" + objParams[key];
            if(--size > 0)
                params += "&";
        }
        return params;
    }

    noEmptyField(obj){
        for(let field in obj){
            if(!obj[field] || obj[field].toString().replace(/\s/g, '').length <= 0)
                return false;
        }

        return true;
    }

    resetInputs(inputs) {
        for(let input of inputs){
            if(input.type === 'checkbox')
                input.checked = false;
            else
                input.value = '';
        }
    }

    setInputs(inputs, values) {
        for(let input of inputs){
            let value = values[input.name];
            if(input.type === 'checkbox')
                input.checked = value;
            else
                input.value = value;
        }
    }

    fromInputsToObj(inputs){
        let inputsMapped = {};
        for(let input of inputs){
            if(input.type === 'checkbox')
                inputsMapped[input.name] = input.checked;
            else
                inputsMapped[input.name] = input.value;
        }
        return inputsMapped;
    }
}