<!-- ko stopBinding: true -->

<div id="pActivitySiteBooking" class="well">

    <!-- Start of survey selection-->
        <div class="row-fluid">
            <div class="span12 text-left">
                <!-- ko if: projectActivities().length > 0 -->
                 <span> <b> Select survey: </b></span>
                 <div class="btn-group">

                 <button type="button" class="btn btn-small btn-primary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    <!-- ko  foreach: projectActivities -->
                        <span data-bind="if: current">
                           <span data-bind="text: name"></span> <span class="caret"></span>
                        </span>
                    <!-- /ko -->
                  </button>

                  <ul class="dropdown-menu" role="menu" style="height: auto;max-height: 200px;overflow-x: hidden;">
                    <!-- ko  foreach: projectActivities -->
                        <li>
                            <a href="#" data-bind="click: $root.setCurrent" >
                                <span data-bind="attr:{'class': published() ? 'badge badge-success' : 'badge badge-important'}">
                                <span data-bind="if:published()"> <small>P</small></span>
                                <span data-bind="if:!published()"> <small>X</small></span>
                                </span>
                                <span data-bind="text: name"></span>
                                <span data-bind="if: current"> <span class="badge badge-info">selected</span></span>
                            </a>
                        </li>
                        </br>
                    <!-- /ko -->
                  </ul>
                </div>
                <!-- /ko -->
            </div>

        </div>
    <!-- End of survey selection-->

    <%-- Start of map --%>
    </br>
    <g:render template="/projectActivity/siteBookingMap" model="${[id: 'leafletMap']}"></g:render>
    </br>
    <%-- End of map --%>

    <!-- Start of booking form -->
    <%-- <div id="booking" style="visibility: hidden"> --%>
    <div id="booking">

        <h4>Booking</h4>
        <label>Site name:</label>
        <input disabled id="siteName" data-bind="value: name"/>
        <input disabled id="siteId" data-bind="value: siteId"/>
        <input id="isBooked" data-bind="value: isBooked"/>


            <label>Booked by:</label>
            <input data-bind="" data-validation-engine="validate[required]"
                class="span12" id="email" type="autocomplete" value=""
                placeholder="email address"/>
            <button type="button" class="btn btn-small btn-primary">Book</button>

    </div>
    <!-- End of booking form -->

</div>   
<!-- /ko -->


<asset:script type="text/javascript">
    var map = initMap({}, 'leafletMap'); 

    function initialiseProjectActivitiesSiteBooking(pActivitiesVM) {
        var pActivitiesSiteBookingVM = new ProjectActivitiesSiteBookingViewModel(pActivitiesVM);
        ko.applyBindings(pActivitiesSiteBookingVM, document.getElementById('pActivitySiteBooking'));
        pActivitiesSiteBookingVM.plotGeoJson();
    };

</asset:script>