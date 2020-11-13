<!-- ko stopBinding: true -->

<div id="siteBookingAdmin" class="well">

    <%-- Start of site booking form  --%>
    <form action="update" inline="true" class="form-horizontal" id="individualBookingForm">
    <h4>Click on the site on the map to see its status</h4>
        <div class="control-group">
            <%-- This value will update the site object's field 'bookedBy'  --%>
            <label class="control-label" for="siteName">Book for</label>
            <div class="controls">
                <input class="input-xlarge validate[required]" data-bind="value: bookedBy" placeholder="enter person ID" type="text"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="siteName">Site name</label>
            <div class="controls">
                <input class="input-xlarge" disabled id="siteName"/>
                <g:hiddenField name="siteId" id="siteId" data-bind="value: siteId"/>
            </div>
        </div>
        <div class="control-group">
            <div class="controls">
                <button id="save" class="btn btn-primary form-control" data-bind="click: bookSite">Book</button>
                <g:img uri="${asset.assetPath(src:'spinner.gif')}" id="spinner1" class="hide spinner" alt="spinner icon"/>
            </div>
        </div>
    </form> 
    <label id="bookedByLink"></label>
    <div id="messageSuccess1" class="span7 hide alert alert-success" >
        <ul></ul>
    </div>
    <div id="messageFail1" class="span7 hide alert alert-danger">
        <ul></ul>
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


