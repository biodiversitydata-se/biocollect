'use strict';

var SystematicSiteViewModel = function (valuesForVM) {
    var site = valuesForVM.site,
     mapOptions = valuesForVM.mapOptions,
     mapContainerId = valuesForVM.mapContainerId,
     ownerId = valuesForVM.personId,
     self = $.extend(this, new Documents());

    // create model for a new site
    self.site = ko.observable({
        name: ko.observable(),
        siteId: ko.observable(),
        externalId: ko.observable(),
        catchment: ko.observable(),
        type: ko.observable(),
        area: ko.observable(),
        description: ko.observable(),
        notes: ko.observable(),
        owner: ko.observable(ownerId),
        projects: ko.observableArray(),
        verificationStatus: ko.observable('inkommen'),
        adminProperties: ko.observable({
            internalSiteId: ko.observable()
        }),
        extent: ko.observable({
            source: ko.observable(),
            geometry:  ko.observable({
                decimalLatitude: ko.observable(),
                decimalLongitude: ko.observable(),
                uncertainty: ko.observable(),
                precision: ko.observable(),
                datum: ko.observable(),
                type: ko.observable(),
                radius: ko.observable(),
                areaKmSq: ko.observable(),
                coordinates: ko.observable(),
                centre: ko.observable(),
                bbox: ko.observable(),
                pid: ko.observable(),
                name: ko.observable(),
                layerName: ko.observable()
            })
        })
    });
    self.pointsOfInterest = ko.observableArray();
    self.transectParts = ko.observableArray();
    self.verificationStatusOptions = ["ej relevant", "inkommen", "godkänd", "ej godkänd"];
    self.showPointAttributes = ko.observable(false);
    self.allowPointsOfInterest = ko.observable(mapOptions.allowPointsOfInterest || false);
    self.displayAreaInReadableFormat = null; // not needed because extent is a centroid - a point

    // to edit existing site load saved values
    self.loadSite = function (site) {
        var siteModel = self.site();
        siteModel.name(exists(site, "name"));
        siteModel.verificationStatus(site.verificationStatus || "inkommen");
        siteModel.siteId(exists(site, "siteId"));
        siteModel.externalId(exists(site, "externalId"));
        siteModel.type(exists(site, "type"));
        siteModel.area(exists(site, "area"));
        siteModel.description(exists(site, "description"));
        siteModel.notes(exists(site, "notes"));
        siteModel.owner(site.owner || ownerId);
        siteModel.projects(site.projects || []);
        siteModel.adminProperties(site.adminProperties || {});
        
        // add the specific fields for each project

        if (!site.adminProperties.internalSiteId)
            site.adminProperties.internalSiteId = ko.observable();
        if (!site.adminProperties.lan)
            site.adminProperties.lan = ko.observable();
        if (!site.adminProperties.StnRegOSId)
            site.adminProperties.StnRegOSId = ko.observable();
        if (!site.adminProperties.StnRegPPId)
            site.adminProperties.StnRegPPId = ko.observable();
        
        site.projects.forEach (function (eltProject) {

            switch(eltProject) {
              case "b7eee643-d5fe-465e-af38-36b217440bd2": // PUNKTRUTTER
                if (!site.adminProperties.kartaTx) site.adminProperties.kartaTx = ko.observable();
                if (!site.adminProperties.sevin) site.adminProperties.sevin = ko.observable();
                if (!site.adminProperties.start) site.adminProperties.start = ko.observable();
                break;
              case "89383d0f-9735-4fe7-8eb4-8b2e9e9b7b5c": // STD
                if (!site.adminProperties.lsk) site.adminProperties.lsk = ko.observable();
                if (!site.adminProperties.fjall104) site.adminProperties.fjall104 = ko.observable();
                if (!site.adminProperties.fjall142) site.adminProperties.fjall142 = ko.observable();
                if (!site.adminProperties.bookingComment) site.adminProperties.bookingComment = ko.observable();
                if (!site.adminProperties.paperSurveySubmitted) site.adminProperties.paperSurveySubmitted = ko.observable();
                if (!site.adminProperties.anonymizedId) site.adminProperties.anonymizedId = ko.observable();
                break;
              case "d0b2f329-c394-464b-b5ab-e1e205585a7c": // NATT
                if (!site.adminProperties.bookingComment) site.adminProperties.bookingComment = ko.observable();
                if (!site.adminProperties.paperSurveySubmitted) site.adminProperties.paperSurveySubmitted = ko.observable();
                break;
              case "49f55dc1-a63a-4ebf-962b-4d486db0ab16": // KUST
                if (!site.adminProperties.bookingComment) site.adminProperties.bookingComment = ko.observable();
                if (!site.adminProperties.summarySurveySubmitted) site.adminProperties.summarySurveySubmitted = ko.observable();
                if (!site.adminProperties.routetype) site.adminProperties.routetype = ko.observable();
                if (!site.adminProperties.area_m2) site.adminProperties.area_m2 = ko.observable();
                if (!site.adminProperties.mitt_5x5_wgs84_lat) site.adminProperties.mitt_5x5_wgs84_lat = ko.observable();
                if (!site.adminProperties.mitt_5x5_wgs84_lon) site.adminProperties.mitt_5x5_wgs84_lon = ko.observable();
                break;
              case "50b1cb29-cf33-4d43-a805-b07ae4de1750": // IWC
                if (!site.adminProperties.goose) site.adminProperties.goose = ko.observable();
                if (!site.adminProperties.helcom_sub) site.adminProperties.helcom_sub = ko.observable();
                if (!site.adminProperties.ln_karta) site.adminProperties.ln_karta = ko.observable();
                if (!site.adminProperties.ki) site.adminProperties.ki = ko.observable();
                if (!site.adminProperties.ev) site.adminProperties.ev = ko.observable();
                if (!site.adminProperties.area) site.adminProperties.area = ko.observable();
                break;
            } 


        })

        

        if (site.extent) {
            self.site().extent().source(exists(site.extent, "source"));
            self.loadGeometry(site.extent.geometry || {});
        } else {
            self.site().extent().source('');
            self.loadGeometry({});
        }

        // if transect parts are saved - get them 
        if (!_.isEmpty(site.transectParts)) {
            site.transectParts.forEach(function (transectPart) {
                createTransectPart(transectPart);
                self.renderTransect();
            });
        }
    };


    self.loadGeometry = function (geometry) {
        var geometryObservable = self.site().extent().geometry();
        geometryObservable.decimalLatitude(exists(geometry, 'decimalLatitude')),
        geometryObservable.decimalLongitude(exists(geometry, 'decimalLongitude')),
        geometryObservable.datum(exists(geometry, 'datum')),
        geometryObservable.type(exists(geometry, 'type')),
        geometryObservable.radius(exists(geometry, 'radius')),
        geometryObservable.areaKmSq(exists(geometry, 'areaKmSq')),
        geometryObservable.coordinates(exists(geometry, 'coordinates')),
        geometryObservable.centre(exists(geometry, 'centre')),
        geometryObservable.bbox(exists(geometry, 'bbox')),
        geometryObservable.pid(exists(geometry, 'pid')),
        geometryObservable.name(exists(geometry, 'name')),
        geometryObservable.layerName(exists(geometry, 'layerName'))

        return geometryObservable;
    };

    self.addTransectPartFromMap = function () {
        var featuresAreDrawn = transformDrawnFeaturesToTransectParts(),
         layersCount = self.map.countFeatures(),
         countTransectParts = self.transectParts().length;

        if (featuresAreDrawn && (layersCount == countTransectParts || layersCount < countTransectParts)){
            self.renderTransect();
            $('#save').removeAttr('disabled');
        } else {
            bootbox.alert("Draw on the map first.");
        }

    };


    function createTransectPart(lngLatFeature) {

        var transectPart = new TransectPart(lngLatFeature),
         geometry = lngLatFeature.geometry,
         lngLatCoordinates = geometry.coordinates,
         popup = transectPart.name();

        /* a geometry to display on leaflet map will be created here so coordinate order needs to be changed
        from [lng, lat] that came from geoJSON to [lat, lng] for any leaflet feature */
        function toLatLng(lngLatCoordinates) {
            var latLngCoordinates = [];
            lngLatCoordinates.forEach(function(lngLat) {
                var lat = lngLat[1];
                var lng = lngLat[0];
                latLngCoordinates.push([lat, lng]);
            });
            return latLngCoordinates;
        }

        if (geometry.type == "Point"){
            transectPart.feature = ALA.MapUtils.createMarker(lngLatCoordinates[1], lngLatCoordinates[0], popup, {});
        } else if (geometry.type == "LineString"){
            var latLngCoordinates = toLatLng(lngLatCoordinates);
            transectPart.feature = ALA.MapUtils.createSegment(latLngCoordinates, popup);
        } else if (geometry.type == "Polygon"){
            // polygon coordinates have one additional level of nesting in a geojson so take index 0
            var latLngCoordinates = toLatLng(lngLatCoordinates[0]);
            transectPart.feature = ALA.MapUtils.createPolygon(latLngCoordinates, popup);
        }
        
        transectPart.feature.on("dragend", transectPart.dragEvent);
        transectPart.feature.on("edit", transectPart.editEvent);
        // on hover change line color to be able to distinguish between adjacent lines  
        if (geometry.type == "LineString"){
            transectPart.feature.on("mouseover", transectPart.highlight);
            transectPart.feature.on("mouseout", transectPart.unhighlight);
        }
        if (geometry.type == "Polygon"){
            transectPart.feature.setStyle({fillOpacity: 0});
        }
        self.transectParts.push(transectPart);
        transectFeatureGroup.addLayer(transectPart.feature);
    }

    self.renderTransect = function(){
        self.map.resetMap();
        self.map.getMapImpl();
        self.map.addLayer(transectFeatureGroup);
        self.map.fitBounds();
    }

    self.removeTransectPart = function (transectPart) {
        self.transectParts.remove(transectPart);
        transectFeatureGroup.removeLayer(transectPart.feature);
    };
    self.toJS = function() {
        var js = ko.toJS(self.site);
        js.transectParts = [];
        self.transectParts().forEach(function (transectPart) {
            js.transectParts.push(transectPart.toJSON())
        });
        js.geoIndex = Biocollect.MapUtilities.constructGeoIndexObject(js);
        return js;
    };

    self.modelAsJSON = function () {
        return JSON.stringify(self.toJS());
    };

    self.saved = function () {
        return self.site().siteId();
    };

    function initialiseViewModel() {
        var baseLayersAndOverlays = Biocollect.MapUtilities.getBaseLayerAndOverlayFromMapConfiguration(fcConfig.mapLayersConfig);
        var options =  {
            autoZIndex: false,
            preserveZIndex: true,
            addLayersControlHeading: true,
            maxZoom: 20,
            wmsLayerUrl: mapOptions.spatialWms + "/wms/reflect?",
            wmsFeatureUrl: mapOptions.featureService + "?featureId=",
            drawOptions: mapOptions.drawOptions,
            singleDraw: mapOptions.singleDraw,
            markerOrShapeNotBoth: mapOptions.markerOrShapeNotBoth,
            singleMarker: mapOptions.singleMarker,
            showReset: false,
            baseLayer: baseLayersAndOverlays.baseLayer,
            overlays: baseLayersAndOverlays.overlays,
            otherLayers: baseLayersAndOverlays.otherLayers
        };

        for (var option in mapOptions) {
            if (mapOptions.hasOwnProperty(option)){
                options[option] = mapOptions[option];
            }
        }

        if (mapOptions.readonly){
            var readonlyProps = {
                drawControl: false,
                singleMarker: false,
                markerOrShapeNotBoth: false,
                useMyLocation: false,
                allowSearchLocationByAddress: false,
                allowSearchRegionByAddress: false,
                draggableMarkers: false,
                showReset: false
            };
            for(var prop in readonlyProps){
                options[prop] = readonlyProps[prop]
            }
        }

        self.map = new ALA.Map(mapContainerId, options);

        if(!mapOptions.readonly){
            var regionSelector = Biocollect.MapUtilities.createKnownShapeMapControl(self.map, mapOptions.featuresService, mapOptions.regionListUrl);
            self.map.addControl(regionSelector);
        }

        self.map.addButton("<span class='fa fa-undo reset-map' title='Reset map'></span>", function () {
            self.map.resetMap();
            self.transectParts([]);
            self.loadGeometry({});
            self.loadSite(site || {});
        }, "bottomright");

        self.map.registerListener("draw:created", function (event) {
            var geoJson = self.map.getGeoJSON();
            var count = geoJson.features.length;
            var layer = event.layer;
            var geoType = determineGeoType(event.layerType);
            layer.bindPopup(geoType + count);
        });

        self.loadSite(site);
    }

    // convert feature type into more human-friendly
    function determineGeoType (geoType){
        var type = null;
        if (geoType == 'LineString' || geoType == 'polyline') {
            type = 'Line';
        } else if (geoType == 'Polygon' || geoType == 'polygon') {
            type = 'Area';
        }
        else if (geoType == 'Point' || geoType == 'marker') {
            type = 'Point';
        }
        return type;
    }

    function limitDecimalPlaces(coordinatePair) {
        coordinatePair = coordinatePair.map(function(coordinate) {
            return coordinate = parseFloat(coordinate.toFixed(5));
        });
        return coordinatePair
    }

    function extractCoordinates(rawCoordinates, geoType){
        var coordinates;
        switch (geoType){
            case 'Point':
                coordinates = limitDecimalPlaces(rawCoordinates);
                break;
            case 'Polygon':
                coordinates = [rawCoordinates[0].map(function(coordinatePair) { 
                    return limitDecimalPlaces(coordinatePair)
                })];
                break; 
            case 'LineString':
                coordinates = rawCoordinates.map(function(coordinatePair) { 
                    return limitDecimalPlaces(coordinatePair)
                }); 
                break;
            default:
                coordinates = rawCoordinates;                    
        }
        return coordinates;
    }

    // checks if new features have been drawn on the map - if yes create new transectPart object from each new feature  
    function transformDrawnFeaturesToTransectParts() {
        var geoJson = self.map.getGeoJSON();
        var mapFeatures = geoJson.features;
        
        if (mapFeatures && mapFeatures.length > 0) {
            var i = self.transectParts().length,
             index = (i == 0) ? 0 : 1;

            for (index; index < mapFeatures.length; index++){
                // used here old version of leaflet doesn't support requests for limited coordinate length
                // it ends up being doubles with 14 decimal places. This is a roundabout way of limiting decimal places to 5 
                var geoType = mapFeatures[index].geometry.type,
                 coordinates = extractCoordinates(mapFeatures[index].geometry.coordinates, geoType),
                 name = self.transectParts().length + 1,
                 dictionary = {"Point": "Punkt ", "Line": "Linje ", "Area": "Sektor "};

                createTransectPart({
                    name: dictionary[determineGeoType(geoType)] + String(name),
                    geometry: {
                        type: geoType,
                        coordinates: coordinates
                    }
                });
            }
            return true;     
        } else {
            return false;
        }
    }

    initialiseViewModel();
};

var TransectPart = function (data) {
    var self = this;
    self.feature = null;

    // create attributes that can be assigned to transect part
    self.transectPartId = ko.observable(exists(data, 'transectPartId'));
    self.name = ko.observable(exists(data, 'name'));
    self.type = ko.observable(exists(data, 'type'));
    self.description = ko.observable(exists(data, 'description'));
    self.displayProperties = ko.observable({
        habitat: ko.observableArray(exists(data.displayProperties, 'habitat')),
        detail: ko.observableArray(exists(data.displayProperties, 'detail'))
    });
    
    self.detailList = ko.observableArray(['D1. Kraftledningsgata', 'D2. Grusväg', 'D3. Asfaltsväg',
        'D4. Aktivt bete', 'D5. Upphörd hävd', 'D6. Glänta', 'D7. Åkerren', 'D8. Skyddat område']);
    self.addDetail = function() {
        self.displayProperties().detail.push(this); 
    };
    self.splitDetailStr = function () {
        if (typeof self.displayProperties().detail() == 'string'){
            var detailArray = self.displayProperties().detail().split(",");
            self.displayProperties().detail(detailArray);
        }
        return self.displayProperties().detail();
    };

    self.habitatList = ko.observableArray(['Lövskog', 'Blandskog', 'Barrskog', 'Hygge', 'Buskmark', 'Alvamark', 
        'Ljunghed', 'Sanddynområde', 'Betesmark', 'Åkermark', 'Kärr', 'Mosse', 'Havsstrandsdäng', 
        'Strandäng vid sjö eller vattendrag', 'Bebyggelse och trädgård', 'Häll- eller blockmark',
        'Fjällterräng']);
    self.addHabitat = function() {
            self.displayProperties().habitat.push(this); 
        };
    self.splitHabitatStr = function () {
        if (typeof self.displayProperties().habitat() == 'string'){
            var habitatArray = self.displayProperties().habitat().split(",");
            self.displayProperties().habitat(habitatArray);
        }
        return self.displayProperties().habitat();
    };

    self.length = null;

    // create geometry
    if (!_.isUndefined(data.geometry)) {
        self.geometry = ko.observable({
            type: data.geometry.type,
            decimalLatitude: ko.observable(exists(data.geometry, 'decimalLatitude')),
            decimalLongitude: ko.observable(exists(data.geometry, 'decimalLongitude')),
            coordinates: ko.observable(exists(data.geometry, 'coordinates'))
        });
    };
    
    self.editEvent = function (event) {
        var newCoords = this.getLatLngs();
        var coordArray = []; 
        newCoords.forEach(function(coordPair) {
            var lat = coordPair.lat;
            var lng = coordPair.lng;
            coordArray.push([lng, lat])
        });
        self.geometry().coordinates = coordArray;
    }
    self.dragEvent = function (event) {

        var lat = event.target.getLatLng().lat;
        var lng = event.target.getLatLng().lng;
        self.geometry().decimalLatitude(lat);
        self.geometry().decimalLongitude(lng);
        self.geometry().coordinates([lng, lat]);
    };

    self.highlight = function (){
        this.setStyle({
            'color': '#eb6f10',
            'weight': 4,
            'opacity': 1
        });
    };
    self.unhighlight = function (){
        this.setStyle({
            'color': 'blue',
            'weight': 4,
            'opacity': 1
        });
    };

    self.toJSON = function () {
        var js = {
            transectPartId: self.transectPartId(),
            name: self.name(),
            type: self.type(),
            displayProperties: ko.toJS(self.displayProperties),
            description: self.description(),
            geometry: ko.toJS(self.geometry)
        };
        return js;
    };
};
