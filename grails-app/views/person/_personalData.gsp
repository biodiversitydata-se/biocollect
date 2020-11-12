<div class="row-fluid validationEngineContainer" id="personal-details-form">
        <h2><g:message code="project.admin.members.details"/></h2>
        <div class="span6">
            <label>ID</label>
           <input disabled data-bind="value: person().personId" id="personId" type="text" class="span12"/>
        </div>
        <div class="span6">
            <label><g:message code="person.personalInfo.code"/></label>
           <input data-bind="value: person().personCode" id="personCode" type="text" class="span12"/>
        </div>
        <div class="span6">
            <label><g:message code="person.personalInfo.first"/><span class="req-field"></span></label>
           <input data-validation-engine="validate[required]" data-bind="value: person().firstName" id="firstName" type="text" class="span12"/>
        </div>
        <div class="span6">
            <label><g:message code="person.personalInfo.last"/><span class="req-field"></span></label>
           <input data-validation-engine="validate[required]" data-bind="value: person().lastName" id="lastName" type="text" class="span12"/>
        </div>
        <div class="span6">
            <label><g:message code="person.personalInfo.email"/><span class="req-field"></span></label>
           <input data-validation-engine="validate[required,custom[email]]" data-bind="value: person().email" id="email" type="text" class="span12"/>
        </div>
        <div class="span6">
            <label><g:message code="person.personalInfo.address"/> 1<span class="req-field"></span></label>
           <input data-validation-engine="validate[required]" data-bind="value: person().address1"  type="text" class="span12"/>
        </div>
        <div class="span6">
            <label><g:message code="person.personalInfo.address"/> 2</label>
           <input data-bind="value: person().address2"  type="text" class="span12"/>
        </div>
        <div class="span6">
            <label><g:message code="person.personalInfo.postcode"/><span class="req-field"></span></label>
           <input data-validation-engine="validate[required]" data-bind="value: person().postCode"  type="text" class="span12"/>
        </div>
        <div class="span6">
            <label><g:message code="person.personalInfo.town"/><span class="req-field"></span></label>
           <input data-validation-engine="validate[required]" data-bind="value: person().town"  type="text" class="span12"/>
        </div>
        <div class="span6">
            <label><g:message code="person.personalInfo.phone"/></label>
           <input data-bind="value: person().phoneNum"  type="text" class="span12"/>
        </div>
        <div class="span6">
            <label><g:message code="person.personalInfo.mobile"/></label>
           <input data-bind="value: person().mobileNum"  type="text" class="span12"/>
        </div>
        <div class="span6">
            <label><g:message code="person.personalInfo.gender"/></label>
           <input data-bind="value: person().gender"  type="text" class="span12"/>
        </div>
        <div class="span6">
            <label><g:message code="person.personalInfo.dob"/></label>
           <input data-bind="value: person().birthDate"  type="text" class="span12"/>
        </div>
        <div class="span6">
            <label><g:message code="person.personalInfo.extra"/></label>
           <input data-bind="value: person().extra"  type="text" class="span12"/>
        </div>
         <div class="row-fluid">
            <div class="form-actions span12">
                <button type="button" id="save" class="btn btn-primary" data-bind="click: save"><g:message code="g.save"/></button>
                <button type="button" id="cancel" class="btn"><g:message code="g.cancel"/></button>
                <button type="button" id="delete" class="btn btn-danger" data-bind="click: deletePerson"><g:message code="btn.delete"/></button>
            </div>
        </div>
</div>
