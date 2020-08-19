<ul class="nav nav-tabs" id="personDetailsTab">
    <li><a href="#personal" id="personal-tab" data-toggle="tab">Personal info</a></li>
    <%-- <li><a href="#surveys" id="surveys-tab" data-toggle="tab">Surveys</a></li> --%>
</ul>
<div class="tab-content">
    <div class="tab-pane" id="personal">
        <g:render template="personalData"></g:render>
    </div>
    <%-- <div class="tab-pane" id="surveys">
        <g:render template="personSurveys"></g:render>
    </div> --%>
</div>
<asset:script type="text/javascript">

    new RestoreTab('personDetailsTab', 'personal-tab');

</asset:script>