<!-- ko stopBinding: true -->

<div id="pActivitySiteBooking" class="well">
<g:if test="${projectContent.sites.isUserAdmin}">
    <g:render template="/site/siteBookingAdmin"></g:render>
</g:if>
    <g:render template="/site/siteBookingMap" model="${[id: 'leafletMap']}"></g:render>

</div>   
<!-- /ko -->


<asset:script type="text/javascript">
    var map = initMap({}, 'leafletMap'); 

    function initialiseSiteBooking(pActivitiesVM) {
        var pActivitiesSiteBookingVM = new SiteBookingViewModel(pActivitiesVM);
        ko.applyBindings(pActivitiesSiteBookingVM, document.getElementById('pActivitySiteBooking'));
        pActivitiesSiteBookingVM.plotGeoJson();
    };
</asset:script>