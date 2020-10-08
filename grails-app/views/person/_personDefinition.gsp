<ul class="nav nav-tabs" id="personDetailsTab">
    <li><a href="#personal" id="personal-tab" data-toggle="tab">Personal info</a></li>
    <g:if test="${fc.userIsAlaOrFcAdmin()}">
        <li><a href="#siteBooking" id="booking-tab" data-toggle="tab">Site booking</a></li>
    </g:if> 
</ul>
<div class="tab-content">
    <div class="tab-pane" id="personal">
        <g:render template="personalData"></g:render>
    </div>
    <div class="tab-pane" id="siteBooking">
        <g:render template="siteBooking"></g:render>
    </div>
</div>
<asset:script type="text/javascript">

    new RestoreTab('personDetailsTab', 'personal-tab');

</asset:script>