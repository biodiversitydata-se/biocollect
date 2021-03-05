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
</div>   
<!-- /ko -->
 <%-- End of site booking form --%>

    <m:map id="${id}" width="80%"></m:map>

<script>
    $(document).ready(function () {
        var siteBookingVM = new SiteBookingViewModel(${project.alertConfig.emailAddresses});
        ko.applyBindings(siteBookingVM, document.getElementById('siteBookingRequest'));
    }); 

    function initMap(params, id) {
        var overlayLayersMapControlConfig = Biocollect.MapUtilities.getOverlayConfig();
        var baseLayersAndOverlays = Biocollect.MapUtilities.getBaseLayerAndOverlayFromMapConfiguration(fcConfig.mapLayersConfig);

        var mapOptions = $.extend({
            autoZIndex: false,
            preserveZIndex: true,
            addLayersControlHeading: true,
            allowSearchLocationByAddress: false,
            drawControl: false,
            singleMarker: false,
            singleDraw: false,
            useMyLocation: false,
            allowSearchByAddress: false,
            draggableMarkers: false,
            showReset: false,
            zoomToObject: true,
            markerOrShapeNotBoth: false,
            trackWindowHeight: true,
            baseLayer: baseLayersAndOverlays.baseLayer,
            otherLayers: baseLayersAndOverlays.otherLayers,
            overlays: baseLayersAndOverlays.overlays,
            overlayLayersSelectedByDefault: baseLayersAndOverlays.overlayLayersSelectedByDefault,
            wmsFeatureUrl: overlayLayersMapControlConfig.wmsFeatureUrl,
            wmsLayerUrl: overlayLayersMapControlConfig.wmsLayerUrl
        }, params);

        var map = new ALA.Map(id, mapOptions);

        L.Icon.Default.imagePath = $('#' + id).attr('data-leaflet-img');

        map.addButton("<span class='fa fa-refresh reset-map' title='${message(code: 'site.map.resetZoom')}'></span>", map.fitBounds, "bottomright");

        return map;
    }
</script>