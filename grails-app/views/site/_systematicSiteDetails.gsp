<!-- ko stopBinding: true -->
<div class="well" id="sitemap">

<%-- This assigns a site owner - it is only accessible via the link sent to the admin when a new site is created --%>
<g:if test="${userIsAlaOrFcAdmin}">
    <div class="well" style="border:solid red">
        <h3 style="color:red"><g:message code="site.details.adminOnly"/></h3>

        <div style="display: table-row">
            <div style="display: table-cell; min-width:120px"><h4><g:message code="record.edit.verificationStatus"/></h4></div>
            <div style="display: table-cell"><fc:select data-bind="options:verificationStatusOptions, value: site().verificationStatus"/></div>
        </div>

        <div data-bind="foreach: {data: $data.site().adminProperties, as: '_data'}">
            <div data-bind="foreach: {data: Object.keys(_data), as: '_propkey'}">
                <div style="display: table-row; width:100%"">
                    <div style="display: table-cell"><h4><span data-bind="text: _propkey"></span></h4> </div>
                    <div style="display: table-cell"><input type="text" data-bind="value: _data[_propkey]"/></div>
                </div>
            </div>
        </div>

    </div>
</g:if>

    <div class="row-fluid">
        <h2><g:message code="site.details.title"/></h2>

        <p class="media-heading">
            <g:message code="site.transect.help"/>
        </p>
    </div>

    <div class="row-fluid">
        <div class="span6">
            <h4><g:message code="site.transect.step.title" /> 1</h4>
            <label for="name"><g:message code="site.transect.step1"/></label>
            <label for="name"><g:message code="site.details.siteName"/> <fc:iconHelp
                    title="Site name"><g:message code="site.details.siteName.help"/></fc:iconHelp>
                <span class="req-field"></span>
            </label>
            <input data-bind="value: site().name" data-validation-engine="validate[required]"
                   class="span12" id="name" type="text" value="${site?.name?.encodeAsHTML()}"
                   placeholder="${message(code: 'site.details.siteName.placeholder')}"/>
        </div>
    </div>
    <div class="row-fluid">
        <div class="span6">
            <g:set var="helpDesc" value="${fc.iconHelp(title: message(code: 'site.details.description'), {
                message(code: 'site.details.description.help')
            })}"/>
            <fc:textArea data-bind="value: site().description" id="description" label="${message(code: 'site.details.description')} ${helpDesc}"
                            class="span12"
                            rows="3" cols="50"/>
                        
        </div>
    </div>

    <h4><g:message code="site.transect.step.title" /> 2</h4>
    <label for="name"><g:message code="site.transect.step2"/></label>
    <g:render template="/site/systematicSiteDefinition"/>

    <br><br>
    <div class="row-fluid">
        <h4><g:message code="site.transect.step4"/></h4>
    </div>
</div>
<!-- /ko -->
