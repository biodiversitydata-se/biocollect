<!-- ko stopBinding: true -->
<div id="siteBookingRequest" class="well">

 <%-- Start of site request form  --%>
    <form inline="true" class="form-horizontal">
    <h4><g:message code="project.admin.siteBooking.clickOnMap"/></h4>
        <div class="control-group">
            <label class="control-label" for="siteName"><g:message code="project.admin.siteBooking.siteName"/></label>
            <div class="controls">
                <input class="input-xlarge" disabled id="siteName" data-bind="value: siteName"/>
                <g:hiddenField name="siteId" id="siteId" data-bind="value: siteId"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label"><g:message code='project.admin.siteBooking.requestMsg'/></label>
            <div class="controls">
                <textarea class="input-xlarge" data-bind="value: message" type="text"></textarea>
            </div>
        </div>
        <div class="control-group">
            <div class="controls">
                <button id="btnRequestBooking" style="visibility:hidden" class="btn btn-primary form-control" data-bind="click: requestBooking"><g:message code="btn.book"/></button>
            </div>
        </div>
    </form> 
    <div id="messageSuccessfulRequest" class="hide alert alert-success">
        <button class="close" onclick="$('#messageSuccessfulRequest').fadeOut();" href="#">×</button>
        <span></span>
    </div>

    <%-- End of site booking form --%>

    <m:map width="90%" id="bookingMap"></m:map>
</div>   
<!-- /ko -->

<asset:script type="text/javascript">
    function initialiseSiteBookingRequest(pActivitiesVM) {
        var siteBookingVM = new SiteBookingViewModel(pActivitiesVM, [${projectActivities[0].alert.emailAddresses}]);
        ko.applyBindings(siteBookingVM, document.getElementById('siteBookingRequest'));
        var volunteerMap = siteBookingVM.initMap({}, 'bookingMap');
        siteBookingVM.plotGeoJson(volunteerMap, false);
    };
</asset:script>