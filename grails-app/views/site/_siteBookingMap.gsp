<!-- ko stopBinding: true -->
<div id="siteBookingMap" class="well">
    <m:map width="90%" id="bookingMap"></m:map>
</div>   
<!-- /ko -->

<asset:script type="text/javascript">
    function initialiseSiteBookingMap(pActivitiesVM) {
        var siteBookingVM = new SiteBookingViewModel(pActivitiesVM);
        ko.applyBindings(siteBookingVM, document.getElementById('siteBookingMap'));
        var volunteerMap = siteBookingVM.initMap({}, 'bookingMap');
        siteBookingVM.plotGeoJson(volunteerMap, false);
    };
</asset:script>