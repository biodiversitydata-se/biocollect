<!-- ko stopBinding: true -->

<div id="siteBookingAdmin" class="well">

    <%-- Start of site booking form  --%>
    <form action="update" inline="true" class="form-horizontal" id="individualBookingForm">
    <h4><g:message code="project.admin.siteBooking.clickOnMap"/></h4>
        <div class="control-group">
            <%-- This value will update the site object's field 'bookedBy'  --%>
            <label class="control-label"><g:message code="project.admin.siteBooking.bookFor"/></label>
            <div class="controls">
                <input class="input-xlarge validate[required]" data-bind="value: bookedBy" placeholder="${message(code:'project.admin.siteBooking.placeholder')}" type="text"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label"><g:message code="project.admin.siteBooking.siteName"/></label>
            <div class="controls">
                <input id="siteNameAdmin" class="input-xlarge" disabled />
                <g:hiddenField name="siteId" id="siteId" data-bind="value: siteId"/>
            </div>
        </div>
        <div class="control-group">
            <div class="controls">
                <button id="save" class="btn btn-primary form-control" data-bind="click: bookSite"><g:message code="btn.book"/></button>
            </div>
        </div>
    </form> 
    <label id="bookedByLink"></label>
    <div id="messageSuccess1" class="hide alert alert-success">
        <button class="close" onclick="$('#messageSuccess1').fadeOut();" href="#">×</button>
        <span></span>
    </div>

    <div id="messageFail1" class="hide alert alert-danger">
        <button class="close" onclick="$('#messageFail1').fadeOut();" href="#">×</button>
        <span></span>
    </div>

    <%-- End of site booking form --%>

<m:map width="90%" id="adminMap"></m:map>

</div>   
<!-- /ko -->

<asset:script type="text/javascript">
    function initialiseSiteBookingAdmin(pActivitiesVM) {
        var siteBookingAdminVM = new SiteBookingViewModel(pActivitiesVM);
        ko.applyBindings(siteBookingAdminVM, document.getElementById('siteBookingAdmin'));
        var adminMap = siteBookingAdminVM.initMap({}, 'adminMap')
        siteBookingAdminVM.plotGeoJson(adminMap, true);
    };
</asset:script>


