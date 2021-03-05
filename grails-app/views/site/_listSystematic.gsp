<asset:stylesheet src="sites-manifest.css"/>
<asset:stylesheet src="leaflet-manifest.css"/>
<asset:javascript src="common.js"/>
<asset:javascript src="leaflet-manifest.js"/>
<asset:javascript src="sites-manifest.js"/>
<script src="${grailsApplication.config.google.maps.url}" async defer></script>
<!-- ko stopBinding: true -->
    <div id="siteSearch" class="container-fluid margin-top-10">
        <g:render template="/site/searchSite"></g:render>
        <div class="row-fluid">
            <div class="span3 well">
                <bc:koLoading>
                    <g:render template="/site/resultStats"></g:render>
                    <g:render template="/site/facetView"></g:render>
                </bc:koLoading>
            </div>

            <div class="span9">

                <bc:koLoading>
                    <div class="alert alert-block hide well" data-bind="slideVisible: error() != ''">
                        <button type="button" class="close" data-dismiss="alert">&times;</button>
                        <span data-bind="text: error"></span>
                    </div>
                    <g:if test="${flash.errorMessage || flash.message}">
                        <div class="alert alert-error">
                            <button class="close" onclick="$('.alert').fadeOut();" href="#">×</button>
                            ${flash.errorMessage ?: flash.message}
                        </div>
                    </g:if>
                    <div class="row-fluid">
                        <div class="well">
                            <div class="span12 margin-top-10">
                                <div class="row-fluid">
                                    <div class="span12">
                                        <h3 data-bind="visible: sitesLoaded"><g:message code="g.found"/> <!-- ko text: pagination.totalResults --> <!-- /ko --> <g:message code="g.sites"/></h3>
                                        <span data-bind="visible: !sitesLoaded()"><span class="fa fa-spin fa-spinner"></span>&nbsp; <g:message code='site.list.loading'/>...</span>
                                    </div>
                                </div>
                                <ul class="nav nav-tabs" id="siteListResultTab">
                                    <li><a href="#list" id="list-tab" data-toggle="tab"><g:message code="g.list"/></a></li>
                                    <li><a href="#booking" id="booking-tab" data-toggle="tab"><g:message code="project.admin.siteBooking"/></a></li>
                                    <li><a href="#admin" id="admin-tab" data-toggle="tab"><g:message code="g.admin"/></a></li>
                                </ul>

                                <div class="tab-content">
                                    <div class="tab-pane" id="list">
                                        <g:render template="/site/listView"></g:render>
                                    </div>

                                    <div class="tab-pane" id="booking">
                                        <g:render template="/site/siteBookingRequest" model="${[id: 'bookingMap']}"></g:render>
                                    </div>

                                    <div class="tab-pane" id="admin">
                                        <%-- <g:render template="" model="${[]}"></g:render> --%>
                                    </div>

                                </div>
                            </div>

                            <div class="row-fluid">
                                <div class="span12 text-center margin-top-10">
                                    <g:render template="/shared/pagination"></g:render>
                                </div>
                            </div>
                        </div>
                    </div>
                </bc:koLoading>
            </div>
        </div>
    </div>
<!-- /ko -->

<script>


var SITES_TAB_AMPLIFY_VAR = 'site-list-result-tab'
function initialiseSites(facets) {
    RestoreTab('siteListResultTab', 'list-tab')
    var sites = new SitesListViewModel(params, facets);
    var params = {
        loadOnInit: false
    }
    ko.applyBindings(sites, document.getElementById('siteSearch'));
    
    sites.sites.subscribe(plotGeoJSON);

    var map = initMap({}, 'bookingMap');

    $("body").on("shown.bs.tab", "#booking-tab", function () {
        map.getMapImpl().invalidateSize();
        map.fitBounds()
    });

    function plotGeoJSON() {
        var siteList = sites.sites();
        map.clearMarkers();
        map.clearLayers();
        siteList.forEach(function (site) {
            var feature = site.extent
            if (feature && feature.source != 'none' && feature.geometry) {
                var lng, lat, geoJson;

                try {

                    if (feature.geometry.centre && feature.geometry.centre.length) {
                        lng = parseFloat(feature.geometry.centre[0]);
                        lat = parseFloat(feature.geometry.centre[1]);
                        if (!feature.geometry.coordinates ) {
                            feature.geometry.coordinates = [lng, lat];
                            if (feature.geometry.aream2 > 0){
                                feature.geometry.type = 'Point'
                            }
                        }
                        // construct elements for point popup  
                        var url = fcConfig.viewSiteUrl + '/' + site.siteId();
                        var isBooked = (site.bookedBy() != undefined && site.bookedBy() != '' && site.bookedBy() != null) ? true : false;
                        var message1 = "";
                        var message2 = "";

                        message1 = "<i class='icon-map-marker'></i> <a href=" 
                            + url + ">" + site.name() + "</a>"
                        
                        if (!isBooked){
                            message2 = "<br>Är du intresserad av att göra rutten, klicka på den gröna knappen Boka"
                        } else {
                            message2 = "<br>Rutten är bokad";
                        } 

                        // use map plugin to display point sites as circle markers color-coded dependent on the booking state 
                        geoJson = Biocollect.MapUtilities.featureToValidGeoJson(feature.geometry);
                        geoJson.properties.isBooked = isBooked;
                        geoJson.properties.popupContent = message1 + message2;

                        var markerOptions = {
                            markerLocation: [lat, lng]
                            // popup: $('#popup' + site.siteId).html()
                        };

                        // display name and fetch the id (hidden field) of selected site
                        var displaySiteDetails = function(){
                            self.selectedSiteId = site.siteId();
                            self.siteName = site.name();
                            $("#siteNameAdmin").val(site.name());
                            $("#siteName").val(site.name());

                            if (site.bookedBy() != undefined && site.bookedBy != '' && site.bookedBy() != null){
                                $('#btnRequestBooking').css("visibility", "hidden");
                                $('#bookedByLink').html("");
                                $('#bookedByLink').append(
                                    $(document.createElement('a')).prop({
                                    target: '_blank',
                                    href:'/person/index/' + site.bookedBy,
                                    innerText: 'See who booked this site'
                                    })
                                )
                            } else {
                                $('#bookedByLink').html("Site is not booked. Type in the person ID in the field 'Book for'") 
                                $('#btnRequestBooking').css("visibility", "visible");
                            }
                        };

                        var siteProperties = {
                            id: site.siteId(), 
                            name: site.name(), 
                            bookedBy: site.bookedBy(),
                            displaySiteDetails: displaySiteDetails,
                            layerOptions: markerOptions
                        }

                        if (feature.geometry.type == 'Point') {
                            map.setGeoJSONAsCircleMarker(geoJson, siteProperties);
                        } 
                    }
                } catch (exception){
                    console.log("Site: "+ site.siteId +" reports exception, on: " + exception)
                }
            }
        });
    }
}
</script>
