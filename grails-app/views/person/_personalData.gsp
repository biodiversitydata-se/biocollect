<div class="row-fluid validationEngineContainer" id="personal-details-form">
        <h2><g:message code=""/>Personal details</h2>

        <div class="span6">
            <label for=""><g:message code=""/>Person ID<g:message code=""/></label>
           <input disabled data-bind="value: person().personId" id="personId" type="text" class="span12"/>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Personal code<g:message code=""/></label>
           <input data-bind="value: person().personCode" id="personCode" type="text" class="span12"/>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>First name<g:message code=""/></label>
           <input data-bind="value: person().firstName" id="firstName" type="text" class="span12"/>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Last name<g:message code=""/></label>
           <input data-bind="value: person().lastName" id="lastName" type="text" class="span12"/>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Email address<g:message code=""/></label>
           <input data-bind="value: person().email" id="email" type="text" class="span12"/>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Address 1<g:message code=""/></label>
           <input data-bind="value: person().address1"  type="text" class="span12"/>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Address 2<g:message code=""/></label>
           <input data-bind="value: person().address2"  type="text" class="span12"/>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Postcode<g:message code=""/></label>
           <input data-bind="value: person().postCode"  type="text" class="span12"/>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Town<g:message code=""/></label>
           <input data-bind="value: person().town"  type="text" class="span12"/>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Phone number<g:message code=""/></label>
           <input data-bind="value: person().phoneNum"  type="text" class="span12"/>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Mobile number<g:message code=""/></label>
           <input data-bind="value: person().mobileNum"  type="text" class="span12"/>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Gender<g:message code=""/></label>
           <input data-bind="value: person().gender"  type="text" class="span12"/>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Year of birth<g:message code=""/></label>
           <input data-bind="value: person().birthDate"  type="text" class="span12"/>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Additional info<g:message code=""/></label>
           <input data-bind="value: person().extra"  type="text" class="span12"/>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>modTyp<g:message code=""/></label>
           <input data-bind="value: person().modTyp"  type="text" class="span12"/>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>eProt<g:message code=""/></label>
           <input data-bind="value: person().eProt"  type="text" class="span12"/>
        </div>
         <div class="row-fluid">
                <div class="form-actions span12">
                    <button type="button" id="save" class="btn btn-primary" data-bind="click: save">Save changes</button>
                    <button type="button" id="cancel" class="btn">Cancel</button>
                    <button type="button" id="delete" class="btn btn-danger" data-bind="click: deletePerson">Delete person</button>
                </div>
        </div>
</div>
