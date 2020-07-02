<%-- TODO This might be just based on permissions or might display a table with booked and unbooked sites  --%>

<div id="pActivitySiteBooking" class="well">
                 <%-- <button type="button" class="btn btn-small btn-primary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    <!-- ko  foreach: projectActivities -->
                           <span data-bind="text: name"></span> <span class="caret"></span>
                    <!-- /ko -->
                  </button> --%>
                  ${projectActivities.sites}
</div>   

<asset:script type="text/javascript">
    <%-- function initialiseProjectActivitiesSiteBooking(pActivitiesVM) {
        var pActivitiesSiteBookingVM = new ProjectActivitiesSiteBookingViewModel(pActivitiesVM);
        ko.applyBindings(pActivitiesSiteBookingVM, document.getElementById('pActivitySiteBooking'));
    }; --%>
</asset:script>