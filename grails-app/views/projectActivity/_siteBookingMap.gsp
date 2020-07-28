<m:map id="${id}"></m:map>
<div class="hide">
    <!-- ko foreach: sites -->
    <div class="margin-left-20" data-bind="attr:{id: 'popup'+siteId}">
        <div><i class="icon-map-marker"></i> <a href="" data-bind="text: name"></a></div>
        <!-- TODO the flag here should be on the level of survey or project - eg. isSiteBookingMandatory-->
        <g:if test="${hubConfig?.isSystematic}">
            <div data-bind="visible: isBooked != undefined"><span><i class="icon-star-empty"></i> Booked:</span> <span
                data-bind="text: isBooked"></span><br></div>
        </g:if>
    </div>
    <!-- /ko -->
</div>

<script>
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
            overlayLayersSelectedByDefault: baseLayersAndOverlays.overlayLayersSelectedByDefault,
            wmsFeatureUrl: overlayLayersMapControlConfig.wmsFeatureUrl,
            wmsLayerUrl: overlayLayersMapControlConfig.wmsLayerUrl
        }, params);

        var map = new ALA.Map('leafletMap', mapOptions);

        L.Icon.Default.imagePath = $('#' + id).attr('data-leaflet-img');

        map.addButton("<span class='fa fa-refresh reset-map' title='Reset zoom'></span>", map.fitBounds, "bottomright");

        return map;
    }

</script>