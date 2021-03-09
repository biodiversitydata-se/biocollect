<m:map id="${id}" width="80%"></m:map>

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