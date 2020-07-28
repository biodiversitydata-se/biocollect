<!-- ko stopBinding: true -->

<div id="pActivitySiteBooking" class="well">

    <%-- Start of site booking form  --%>
    <bs:form action="update" inline="true" class="form-horizontal">
        <div class="control-group">
            <label class="control-label" for="emailAddress1">User's email address</label>
            <div class="controls">
                <input class="input-xlarge validate[required,custom[email]]" id="emailAddress1" placeholder="enter a user's email address" type="text"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="">Site name</label>
            <div class="controls">
                <input class="input-xlarge" disabled id="siteName" data-bind="value: name"/>
                <input class="input-xlarge" disabled hidden id="siteId" data-bind="value: siteId"/>
                <input id="isBooked" data-bind="value: isBooked"/>

            </div>
        </div>
        <div class="control-group">
            <div class="controls">
                <button id="save" class="btn btn-primary btn-small">Book</button>
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
        <g:render template="/projectActivity/siteBookingMap" model="${[id: 'leafletMap']}"></g:render>
    </br>
    <%-- End of map --%>

</div>   
<!-- /ko -->


<asset:script type="text/javascript">
    var map = initMap({}, 'leafletMap'); 

    function initialiseProjectActivitiesSiteBooking(pActivitiesVM) {
        <%-- var pActivitiesSiteBookingVM = new ProjectActivitiesSiteBookingViewModel(pActivitiesVM); --%>
        var pActivitiesSiteBookingVM = new SiteBookingViewModel(pActivitiesVM);
        ko.applyBindings(pActivitiesSiteBookingVM, document.getElementById('pActivitySiteBooking'));
        pActivitiesSiteBookingVM.plotGeoJson();
    };

    $('#save').click(function () {

        <%-- TODO Validate - does the email address exist?  --%>

            var data = { site: {
                isBooked: document.getElementById("isBooked").value,
                projectId: 'dab767a5-929e-4733-b8eb-c9113194201f',
                projects: ['dab767a5-929e-4733-b8eb-c9113194201f']
                 }};

            var siteId = document.getElementById("siteId").value;

            $.ajax({
                url: fcConfig.ajaxBookSiteUrl + siteId,
                type: 'POST',
                data: JSON.stringify(data),
                contentType: 'application/json',
                success: function (data) {
                    <%-- TODO change the url to something like back to project admin tab --%>
                    document.location.href = fcConfig.homePagePath;
                },
                error: function (data) {
                    var errorMessage = data.responseText || 'There was a problem saving this site'
                    bootbox.alert(errorMessage);
                }
            });
    });
</asset:script>