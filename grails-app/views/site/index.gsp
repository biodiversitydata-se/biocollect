<%@ page import="java.text.SimpleDateFormat; grails.converters.JSON;" contentType="text/html;charset=UTF-8" %>
<g:set var="mapService" bean="mapService"></g:set>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="${hubConfig.skin}"/>
    <title>${site?.name?.encodeAsHTML()} | <g:message code="g.biocollect"/></title>
    <meta name="breadcrumbParent1" content="${createLink(controller: 'project', action: 'homePage')},${message(code: 'g.home')}"/>
    <meta name="breadcrumbParent2"
          content="${createLink(controller: 'site', action: 'list')},${message(code: 'g.sites')}"/>
    <meta name="breadcrumb" content="${site.name?.encodeAsHTML()}"/>

    <asset:script type="text/javascript">
        var fcConfig = {
            intersectService: "${createLink(controller: 'proxy', action: 'intersect')}",
            featuresService: "${createLink(controller: 'proxy', action: 'features')}",
            featureService: "${createLink(controller: 'proxy', action: 'feature')}",
            spatialWms: "${grailsApplication.config.spatial.geoserverUrl}",
            layersStyle: "${createLink(controller: 'regions', action: 'layersStyle')}",
            serverUrl: "${grailsApplication.config.grails.serverURL}",
            siteDeleteUrl: "${createLink(controller: 'site', action: 'ajaxDelete')}",
            siteListUrl: "${createLink(controller: 'site', action: 'list')}",
            addStarSiteUrl: "${createLink(controller: 'site', action: 'ajaxAddToFavourites')}",
            removeStarSiteUrl: "${createLink(controller: 'site', action: 'ajaxRemoveFromFavourites')}",
            spatialBaseUrl: "${grailsApplication.config.spatial.baseURL}",
            spatialWmsCacheUrl: "${grailsApplication.config.spatial.wms.cache.url}",
            spatialWmsUrl: "${grailsApplication.config.spatial.wms.url}",
            sldPolgonDefaultUrl: "${grailsApplication.config.sld.polgon.default.url}",
            sldPolgonHighlightUrl: "${grailsApplication.config.sld.polgon.highlight.url}",
            poiGalleryUrl: "${createLink(controller: 'site', action: 'getImages')}",
            imagesForPoiUrl: "${createLink(controller: 'site', action: 'getPoiImages')}",
            imageLeafletViewer: '${createLink(controller: 'resource', action: 'imageviewer', absolute: true)}',
            // copied from bioactivity/list.gsp
            activityUpdateUrl: "${createLink(controller: 'activity', action: 'ajaxUpdate')}",
            activityViewUrl: "${createLink(controller: 'bioActivity', action: 'index')}",
            activityEditUrl: "${createLink(controller: 'bioActivity', action: 'edit')}",
            activityDeleteUrl: "${createLink(controller: 'bioActivity', action: 'delete')}",
            activityAddUrl: "${createLink(controller: 'bioActivity', action: 'create')}",
            activityListUrl: "${createLink(controller: 'bioActivity', action: 'ajaxList')}",
            worksActivityEditUrl: "${createLink(controller: 'activity', action: 'enterData')}",
            worksActivityViewUrl: "${createLink(controller: 'activity', action: 'index')}",
            searchProjectActivitiesUrl: "${createLink(controller: 'bioActivity', action: 'searchProjectActivities')}",
            downloadProjectDataUrl: "${createLink(controller: 'bioActivity', action: 'downloadProjectData')}",
            recordListUrl: "${createLink(controller: 'record', action: 'ajaxList')}",
            recordDeleteUrl: "${createLink(controller: 'record', action: 'delete')}",
            projectIndexUrl: "${createLink(controller: 'project', action: 'index')}",
            bieUrl: "${grailsApplication.config.bie.baseURL}",
            speciesPage: "${grailsApplication.config.bie.baseURL}/species/",
            mapLayersConfig: ${mapService.getMapLayersConfig(project, pActivity) as JSON}
            },
            here = "${createLink(controller: 'site', action: 'index', id: site.siteId)}";
    </asset:script>
    <asset:stylesheet src="sites-manifest.css"/>
    <asset:stylesheet src="leaflet-manifest.css"/>
    <asset:javascript src="common.js"/>
    <asset:javascript src="leaflet-manifest.js"/>
    <asset:javascript src="sites-manifest.js"/>
    <script src="${grailsApplication.config.google.maps.url}" async defer></script>
</head>

<body>
<div class="container-fluid">
    <div class="alert alert-block hide well" data-bind="slideVisible: message" id="message">
        <button type="button" class="close" data-dismiss="alert">&times;</button>
        <span data-bind="text: message"></span>
    </div>
    <g:if test="${!hubConfig?.isSystematicMonitoring}">
        <div class="alert alert-info">
            <button type="button" class="close" data-dismiss="alert">&times;</button>
            <strong><g:message code="site.details.headsUp"/></strong> <g:message code="site.details.editWarning"/> 
        </div>
    </g:if>
    <ul class="breadcrumb pull-right margin-top-10">
        <li>
            <g:set var="disabled">${(!user) ? "disabled='disabled' title='login required'" : ''}</g:set>
        %{--Favourite functionality only available to authenticated users --}%
            <g:if test="${site?.transectParts instanceof List && userIsAlaOrFcAdmin}">
                <g:link action="editSystematic" id="${site.siteId}" class="btn btn-small"><i
                    class="icon-edit"></i> <g:message code="site.details.editSystematic"/> </g:link>
            </g:if>
            <g:elseif test="${site?.transectParts == null}">
                <g:link action="edit" id="${site.siteId}" class="btn btn-small">
                    <i class="icon-edit"></i> <g:message code="site.details.editSite"/> 
                </g:link>
            </g:elseif>
            %{-- TODO - delete button could be for volunteers too but maybe have an alert before delete happens --}%
            <g:if test="${userIsAlaOrFcAdmin}">
                <div class="btn btn-small btn-danger" onclick="deleteSite()"><i
                        class="fa fa-remove"></i> <g:message code="site.details.deleteSite"/> 
                </div>
            </g:if>
            <g:if test="${site?.extent?.geometry?.pid}">
                <a href="${grailsApplication.config.spatial.layersUrl}/shape/shp/${site.extent.geometry.pid}"
                   class="btn btn-small">
                    <i class="icon-download"></i>
                    <g:message code="site.details.downloadShp"/>
                </a>
                <a href="${grailsApplication.config.spatial.baseURL}/?pid=${site.extent.geometry.pid}"
                   class="btn btn-small"><i class="fa fa-map"></i> <g:message code="site.details.viewInSpatialPortal"/></a>
            </g:if>
        </li>
    </ul>
    <div class="row-fluid space-after">
        <div class="span6"><!-- left block of header -->
            <g:if test="${flash.errorMessage || flash.message}">
                <div>
                    <div class="alert alert-error">
                        <button class="close" onclick="$('.alert').fadeOut();" href="#">×</button>
                        ${flash.errorMessage ?: flash.message}
                    </div>
                </div>
            </g:if>
            <div>
                <div class="clearfix">
                    <h1 class="pull-left"><strong>${site?.name?.encodeAsHTML()}</strong></h1>
                </div>
                <g:if test="${site.description?.encodeAsHTML()}">
                    <dl>
                        <dt><h3><g:message code="site.details.siteDescription"/></h3></dt>
                        <dd>${site.description?.encodeAsHTML()}</dd>
                    </dl>
                </g:if>
            </div>

            <g:if test="${site?.transectParts instanceof List}">

                <dl class="dl-horizontal">

                <div class="accordion-group">
                    <div class="accordion-heading">
                        <a class="accordion-toggle" data-toggle="collapse" href="#collapse1">
                            <g:message code= "site.transect.displayCoordinates"/>
                        </a>
                    </div>
                    <div id="collapse1" class="accordion-body collapse">
                        <div class="accordion-inner">
                            <div class="control-group">
                        <button id="downloadBtn" class="btn btn-primary padding-top-1"><span class="fa fa-download">&nbsp;</span><g:message code="g.download"/></button>
                                <table class="table table-striped table-bordered table-hover dataTable no-footer">
                                    <th><g:message code="site.metadata.name"/></th>
                                    <th>RT90 2.5 gon V</th>
                                    <th>SWEREF99 TM</th>
                                    <th>WGS84</th>
                                    <%-- if transectParts have otherCRS then print the value --%>
                                    <g:each in="${site?.transectParts}">
                                        <tr>
                                            <td>${it?.name}</td>
                                            <td>${it?.otherCRS?.coords_3021}</td>
                                            <td>${it?.otherCRS?.coords_3006}</td>
                                            <td>${it?.geometry.coordinates}</td>
                                        </tr>
                                    </g:each>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <g:if test="${!site?.transectParts?.isEmpty()}">
                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle" data-toggle="collapse" href="#collapse2">
                                <g:message code= "site.transect.displayOtherDetails"/>
                            </a>
                        </div>
                        <div id="collapse2" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <div class="control-group">
                                    <table class="table table-striped table-bordered table-hover dataTable no-footer">
                                        <th><g:message code="site.metadata.name" /></th>
                                        <th><g:message code="site.details.description" /></th>
                                        <th><g:message code="site.transect.transectPart.length" /> (m)</th>
                                        <g:each var="property" in="${site?.transectParts[0]?.displayProperties}">
                                            <th>${property.key}</th>
                                        </g:each>
                                        <g:each var="segment" in="${site?.transectParts}">
                                            <tr>
                                                <td>${segment?.name}</td>
                                                <td>${segment?.description}</td>
                                                <g:if test="${segment?.length}">
                                                    <td><g:formatNumber number="${segment?.length}" type="number" maxFractionDigits="2"/></td>
                                                </g:if>
                                                <g:else>
                                                    <td></td>
                                                </g:else>
                                                <g:each in="${segment?.displayProperties}">
                                                    <td>${it.value}</td>
                                                </g:each>
                                            </tr>
                                        </g:each>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <g:if test="${userIsAlaOrFcAdmin && site?.adminProperties}">
                        <div class="accordion-group">
                            <div class="accordion-heading">
                                <a class="accordion-toggle" data-toggle="collapse" href="#collapse3">
                                    <g:message code= "site.transect.displayAdminProps"/>
                                </a>
                            </div>
                            <div id="collapse3" class="accordion-body collapse">
                                <div class="accordion-inner">
                                    <div class="control-group">
                                    <table>
                                    <g:each var="property" in="${site?.adminProperties}">
                                        <tr>
                                            <td><b>${property.key}</b></td> 
                                            <td>${property.value}</td>
                                        </tr>
                                    </g:each>
                                    </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </g:if>
                </g:if>


                <%-- end --%>

                <g:if test="${site?.notes}">
                    <dt><g:message code="site.details.notes"/></dt>
                    <dd>${site.notes?.encodeAsHTML()}</dd>
                </g:if>
                </dl>
            </g:if>

            <g:else>
                <h3><g:message code="site.details.siteMetadata"/></h3>
                <dl class="dl-horizontal">
                    <dt><g:message code="site.details.externalId"/></dt>
                    <dd>${site.externalId ?: 'Not specified'}</dd>
                    <dt><g:message code="site.details.type"/></dt>
                    <dd>${site.type ?: 'Not specified'}</dd>
                    <dt><g:message code="site.details.catchment"/></dt>
                    <dd>${site.catchment ?: 'Not specified'}</dd>
                    <dt><g:message code="site.details.area"/></dt>
                    <dd>
                        <g:if test="${site?.extent?.geometry?.area}">
                            ${site.extent.geometry.area} <g:message code="site.details.area.sqKm"/>
                        </g:if>
                        <g:else>
                            <g:message code="site.details.notSpecified"/>
                        </g:else>
                    </dd>
                    <g:if test="${site.extent?.geometry}">
                        <fc:siteFacet site="${site}" label="State/territory" facet="state" showPreview="${true}" trimSize="${80}"/>
                        <fc:siteFacet label="Local government area" site="${site}" facet="lga" showPreview="${true}" trimSize="${80}"/>
                        <fc:siteFacet label="NRM" site="${site}" facet="nrm" showPreview="${true}" trimSize="${80}"/>
                        <dt><g:message code="site.metadata.locality"/></dt>
                        <dd>${site.extent.geometry.locality ?: 'Not specified'}</dd>
                        <dt data-toggle="tooltip" title="NVIS major vegetation group"><g:message code="site.metadata.nvisGroup"/></dt>
                        <dd>${site.extent.geometry.mvg ?: 'Not specified'}</dd>
                        <dt data-toggle="tooltip" title="NVIS major vegetation subgroup"><g:message code="site.metadata.nvisSubgroup"/></dt>
                        <dd>${site.extent.geometry.mvs ?: 'Not specified'}</dd>
                    </g:if>
                    <g:if test="${site.notes}">
                        <dt><g:message code="site.details.notes"/></dt>
                        <dd>${site.notes?.encodeAsHTML()}</dd>
                    </g:if>
                </dl>
            </g:else>
            <script>
                $('.dl-horizontal').tooltip()
            </script>
        </div>

        <div class="span6">
            <div id="siteNotDefined" class="hide pull-right">
                <span class="label label-important"><g:message code="site.details.noGeoreference"/></span>
            </div>
            <m:map id="smallMap" width="100%" height="500px"/>
        </div>
    </div>
    <g:if test="${!hubConfig?.isSystematicMonitoring}">
        <h3><g:message code="site.associated.title"/>:</h3>
        <div id="detailsLinkedToSite">
            <ul class="nav nav-tabs" id="myTab">
                <g:if test="${site.projects}">
                    <li><a href="#siteProjects" data-toggle="tab"><g:message code="g.projects"/></a></li>
                </g:if>
                <li class="active"><a href="#siteActivities" data-toggle="tab"><g:message code="site.details.associated.surveysAndActivities"/></a></li>
                <li><a href="#sitePhotopoints" data-toggle="tab"><g:message code="site.details.photoPoints"/></a></li>
            </ul>

            <div class="tab-content">
                <!-- ko stopBinding: true -->
                <div class="tab-pane" id="sitePhotopoints">
                    <g:render template="poiGallery"
                            model="${[siteId: site.siteId, siteElementId: 'sitePhotopoints']}"></g:render>
                </div>
                <!-- /ko -->
                <div class="tab-pane" id="siteProjects">
                    <g:if test="${site.projects}">
                        <div>
                            <p> <g:message code="site.details.associated.projects"/> -</p>
                            <ol>
                                <g:each in="${site.projects}" var="p" status="count">
                                    <li>
                                        <g:link controller="project" action="index"
                                                id="${p.projectId}">${p.name?.encodeAsHTML()}</g:link>
                                    </li>
                                </g:each>
                            </ol>
                        </div>
                    </g:if>
                </div>

                <div class="tab-pane active" id="siteActivities">
                    <!-- ko if: activities().length == 0 -->
                    <div class="row-fluid">
                        <h4 class="text-left margin-bottom-five">
                            <!-- ko if: $root.searchTerm() != "" || $root.selectedFilters().length > 0 -->
                            <g:message code="site.details.noResults"/>
                            <!-- /ko -->
                        </h4>
                    </div>
                    <!-- /ko -->

                    <!-- ko if: activities().length > 0 -->

                    <div class="alert alert-info hide" id="downloadStartedMsg"><i
                            class="fa fa-spin fa-spinner">&nbsp;&nbsp;</i><g:message code="site.details.downloading"/>...</div>

                    <div class="row-fluid">
                        <div class="span9">
                            <h3 class="text-left margin-bottom-2"><g:message code="g.found"/> <span data-bind="text: total()"></span> <g:message code="g.records"/>
                            </h3>
                        </div>
                    </div>
                    <g:render template="/shared/pagination"/>
                    <!-- ko foreach : activities -->
                    <div class="row-fluid">
                        <div class="span12">
                            <div data-bind="attr:{class: embargoed() ? 'searchResultSection locked' : 'searchResultSection'}">

                                <div class="span9 text-left">
                                    <div>
                                        <h4>
                                            <!-- ko if: embargoed() -->
                                            <a href="#" class="helphover"
                                            data-bind="popover: {title:'Only project members can access the record.', content:'Embargoed until : ' + moment(embargoUntil()).format('DD/MM/YYYY')}">
                                                <span class="fa fa-lock"></span>
                                            </a>
                                            <!--/ko -->
                                            <g:message code="site.details.surveyName"/>:
                                            <a data-bind="attr:{'href': transients.viewUrl}">
                                                <span data-bind="text: name"></span>
                                            </a>
                                        </h4>
                                    </div>

                                    <div class="row-fluid">
                                        <div class="span12">
                                            <div class="span7">
                                                <div>
                                                    <h6><g:message code="site.details.projectName"/>: <a
                                                            data-bind="attr:{'href': projectUrl()}"><span
                                                                data-bind="text: projectName"></span></a></h6>
                                                </div>

                                                <div>
                                                    <h6><g:message code="site.details.submittedBy"/>: <span
                                                            data-bind="text: ownerName"></span> on <span
                                                            data-bind="text: lastUpdated.formattedDate"></span>
                                                    </h6>
                                                </div>
                                            </div>

                                            <div class="span5">
                                                <!-- ko if : records().length > 0 -->
                                                <div>
                                                    <h6>
                                                        <g:message code="g.species"/> :
                                                        <!-- ko foreach : records -->
                                                        <a target="_blank"
                                                        data-bind="visible: guid, attr:{href: $root.transients.bieUrl + '/species/' + guid()}">
                                                            <span data-bind="text: $index()+1"></span>. <span
                                                                data-bind="text: name"></span>
                                                        </a>
                                                        <span data-bind="visible: !guid()">
                                                            <span data-bind="text: $index()+1"></span>. <span
                                                                data-bind="text: name"></span>
                                                        </span>
                                                        <span data-bind="if: $parent.records().length != $index()+1">
                                                            <b>|</b>
                                                        </span>
                                                        <!-- /ko -->
                                                    </h6>
                                                </div>
                                                <!-- /ko -->

                                            </div>
                                        </div>

                                    </div>
                                </div>

                                <div class="span3 text-right">

                                    <!-- looks awkward to show view eye icon by itself. Users can view the survey by clicking the survey title.-->
                                    <div class="padding-top-0" data-bind="if: showCrud()">
                                        <span class="margin-left-1">
                                            <a data-bind="attr:{'href': transients.viewUrl}"><i
                                                    class="fa fa-eye" title="View survey"></i></a>
                                        </span>
                                        <span class="margin-left-1" data-bind="visible: showAdd()">
                                            <a data-bind="attr:{'href': transients.addUrl}"><i
                                                    class="fa fa-plus" title="Add survey"></i></a>
                                        </span>
                                        <span class="margin-left-1">
                                            <a data-bind="attr:{'href': transients.editUrl}"><i
                                                    class="fa fa-edit" title="Edit survey"></i></a>
                                        </span>
                                        <span class="margin-left-1" data-bind="visible: false">
                                            <a href="#" data-bind="click: $parent.remove"><i
                                                    class="fa fa-remove" title="Delete survey"></i></a>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <hr/>
                    <!-- /ko -->
                    <div class="margin-top-2"></div>
                    <g:render template="/shared/pagination"/>
                    <!-- ko if : activities().length > 0 -->
                    <div class="row-fluid">
                        <div class="span12 pull-right">
                            <div class="span12 text-right">
                                <div><small class="text-right"><span class="fa fa-lock"></span> <g:message code="site.details.accessRestrictedTip"/>
                                </small></div>
                            </div>

                        </div>
                    </div>
                    <!-- /ko -->

                    <!-- /ko -->
                </div>
            </div>
        </div>
    </g:if>
    <small class="pull-right"><em><g:message code="site.details.createdOn"/> <fc:formatDateString date="${site.dateCreated}"
                                                                  inputFormat="yyyy-MM-dd'T'HH:mm:ss'Z'"
                                                                  format="dd-MM-yyyy"/>
    <g:message code="site.details.lastUpdated"/> <fc:formatDateString date="${site.lastUpdated}" inputFormat="yyyy-MM-dd'T'HH:mm:ss'Z'"
                                             format="dd-MM-yyyy"/></em></small>
    <g:if env="development">
        <div class="expandable-debug">
            <hr/>

            <h3>Debug</h3>

            <div>
                <h4>KO model</h4>
                <pre data-bind="text:ko.toJSON($root,null,2)"></pre>
                <h4>Activities</h4>
                <pre>${site.activities?.encodeAsHTML()}</pre>
                <h4>Site</h4>
                <pre>${site}</pre>
                <h4>Projects</h4>
                <pre>${projects?.encodeAsHTML()}</pre>
                <h4>Features</h4>
                <pre>${mapFeatures}</pre>
                <h4>Surveys</h4>
                <pre>${survey}</pre>
            </div>
        </div>
    </g:if>
</div>
<asset:script type="text/javascript">    

    var downloadBtn = document.getElementById('downloadBtn');
    downloadBtn.addEventListener('click', function () {
        var coordinatesOfOtherCrs = [["Name", "WGS84_x", "WGS84_y", "SWEREF99_x", "SWEREF99_y", "RT90_x", "RT90_y"]];
        var segments = ${site?.transectParts};
        segments.forEach(function(segment){
            if (segment.otherCRS !== undefined){
                var row = [
                    segment.name, 
                    segment.geometry.coordinates[0], segment.geometry.coordinates[1],
                    segment.otherCRS.coords_3006[0], segment.otherCRS.coords_3006[1], 
                    segment.otherCRS.coords_3021[0], segment.otherCRS.coords_3021[1]
                    ];
                coordinatesOfOtherCrs.push(row);
            } else if (segment.geometry.type == "Point" && segment.otherCRS == undefined) {
                var row = [
                    segment.name, 
                    segment.geometry.coordinates[0], segment.geometry.coordinates[1],
                    'n/a', 'n/a',
                    'n/a', 'n/a'
                    ];
                coordinatesOfOtherCrs.push(row);
            } else {
                bootbox.alert("Coordinates for some segments (lines and polygons) cannot be downloaded. Only point coordinates will be saved");
            }
        });

        var csvContent = "data:text/csv;charset=utf-8,";
        coordinatesOfOtherCrs.forEach(function(rowArray) {
            let row = rowArray.join(",");
            csvContent += row + "\r\n";
        });

        var encodedUri = encodeURI(csvContent);
        var link = document.createElement("a");
        link.setAttribute("href", encodedUri);
        link.setAttribute("download", "site.csv");
        document.body.appendChild(link); // Required for FF

        link.click();

    }, false);

    $(function(){
        var mapFeatures = $.parseJSON('${mapFeatures?.encodeAsJavaScript()}');
        var overlayLayersMapControlConfig = Biocollect.MapUtilities.getOverlayConfig();
        var baseLayersAndOverlays = Biocollect.MapUtilities.getBaseLayerAndOverlayFromMapConfiguration(fcConfig.mapLayersConfig);

        var mapOptions = {
            autoZIndex: false,
            preserveZIndex: true,
            addLayersControlHeading: true,
            allowSearchLocationByAddress: false,
            allowSearchRegionByAddress: false,
            drawControl: false,
            singleMarker: false,
            useMyLocation: false,
            allowSearchByAddress: false,
            draggableMarkers: false,
            showReset: false,
            maxZoom: 20,
            baseLayer: baseLayersAndOverlays.baseLayer,
            otherLayers: baseLayersAndOverlays.otherLayers,
            overlays: baseLayersAndOverlays.overlays,
            overlayLayersSelectedByDefault: baseLayersAndOverlays.overlayLayersSelectedByDefault,
            wmsFeatureUrl: overlayLayersMapControlConfig.wmsFeatureUrl,
            wmsLayerUrl: overlayLayersMapControlConfig.wmsLayerUrl
        };
        var smallMap = new ALA.Map("smallMap", mapOptions);

        <%-- if site is systematic display all parts of the transect but don't show the extent (centroid) --%>
        var transectParts = mapFeatures.transectParts;
        if(transectParts === undefined || transectParts.length == 0){
            if(mapFeatures.features === undefined || mapFeatures.features.length == 0){
                $('#siteNotDefined').show();
            } else {
                var geoJson = Biocollect.MapUtilities.featureToValidGeoJson(mapFeatures.features[0]);
                smallMap.setGeoJSON(geoJson);
            }

            var activitiesAndRecordsViewModel = new ActivitiesAndRecordsViewModel('data-result-placeholder', null, null, true, true, false)
            activitiesAndRecordsViewModel.searchTerm('siteId:${site.siteId}');
            activitiesAndRecordsViewModel.search();
            ko.applyBindings(activitiesAndRecordsViewModel, document.getElementById('siteActivities'));
            var params = {
                params: {
                    id: '${site.siteId}'
                }
            }
            initPoiGallery(params,'sitePhotopoints');
        } else {
            transectParts.forEach(function(part) {
                var geoJson = Biocollect.MapUtilities.featureToValidGeoJson(part.geometry);
                geoJson.properties.popupContent = part.name;
                smallMap.setTransectFromGeoJSON(geoJson);
            });
        }

    });
    function Message (){
        var self = this;
        self.message = ko.observable();
        self.clear = function(){
            self.message('')
        }

        self.message.subscribe(function(){
            setTimeout(self.clear, 3000);
        })
    }
    var msg = new Message();
    ko.applyBindings(msg, document.getElementById('message'))

    function deleteSite(){
        var url = fcConfig.siteDeleteUrl + '/' + "${site.siteId}"
        $.ajax({
            url: url,
            success: function(){
                msg.message('Successfully deleted site. Redirecting in 3 seconds.');
                setTimeout(function(){ window.location = fcConfig.siteListUrl}, 3000);
            },
            error: function(xhr){
                msg.message(xhr.responseText);
            }
        })
    }
</asset:script>
</body>
</html>