<ul class="nav nav-tabs" id="personDetailsTab">
    <li><a href="#personal" id="personal-tab" data-toggle="tab"><g:message code="person.info.heading"/></a></li>
    <li><a href="#surveys" id="surveys-tab" data-toggle="tab"><g:message code='project.tab.surveys'/></a></li>
    <li><a href="#siteBooking" id="booking-tab" data-toggle="tab"><g:message code="person.siteBooking.heading"/></a></li>
</ul>
<div class="tab-content">
    <div class="tab-pane" id="personal">
        <g:render template="personalData"></g:render>
    </div>
    <div class="tab-pane" id="surveys">
        <g:render template="personSurveys"></g:render>
    </div>
    <div class="tab-pane" id="siteBooking">
        <g:render template="siteBooking"></g:render>
    </div>
</div>
<div>
    <div class="alert alert-info hide" id="downloadStartedMsg"><i class="fa fa-spin fa-spinner">&nbsp;&nbsp;</i>Nedladdning pågår, vänligen vänta...</div>
    <button data-bind="click: downloadLURecords, disable: transients.loading" data-email-threshold="${grailsApplication.config.download.email.threshold ?: 200}" class="btn btn-primary padding-top-1"><span class="fa fa-download">&nbsp;</span><g:message code="g.downloadLURecords"/></button>
</div>
<asset:script type="text/javascript">

    new RestoreTab('personDetailsTab', 'personal-tab');

</asset:script>