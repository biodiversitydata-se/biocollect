<!-- ko stopBinding: true -->

<div id="pActivitySiteBooking" class="well">



    <%-- Start of site booking form  --%>
    <bs:form action="update" inline="true" class="form-horizontal">
        <div class="control-group">
            <label class="control-label" for="bookedById">Code of the person who is booking</label>
            <div class="controls">
                <%-- This value will update the site object's field 'bookedBy'  --%>
                <input class="input-xlarge" id="bookedById" data-bind="value: bookedBy" placeholder="enter personal code" type="text"/>
            </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="bookedByEmail">Email address</label>
                <div class="controls">
                    <input class="input-xlarge" id="bookedByEmail" placeholder="email address" type="text"/>
                </div>
            </div>
        <div class="control-group">
            <label class="control-label" for="">Site name</label>
            <div class="controls">
                <input class="input-xlarge" disabled id="siteName"/>
                <g:hiddenField name="siteId" id="siteId" data-bind="value: siteId"/>
            </div>
        </div>
        <div class="control-group">
            <div class="controls">
                <button id="save" class="btn btn-primary btn-small" data-bind="click: bookSite">Book</button>
                <g:img uri="${asset.assetPath(src:'spinner.gif')}" id="spinner1" class="hide spinner" alt="spinner icon"/>
            </div>
        </div>
    </bs:form> 
    <%-- End of site booking form --%>

    <!-- Start of survey selection-->
        <%-- <div class="row-fluid">
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

        </div> --%>
    <!-- End of survey selection-->

    <%-- Start of map --%>
    </br>
        <g:render template="/site/siteBookingMap" model="${[id: 'leafletMap']}"></g:render>
    </br>
    <%-- End of map --%>

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