<%@ page import="grails.converters.JSON" %>
<asset:stylesheet src="map-activity.css"/>
<g:set var="noImageUrl" value="${asset.assetPath([src: "no-image-2.png"])}"/>
<!-- ko stopBinding: true -->
<div id="survey-all-activities-content">
    <div id="activities-placeholder"></div>
    <div data-bind="visible: version().length == 0">
        <g:render template="/bioActivity/search"/>
    </div>

    <div class="row-fluid">
        <div class="span12">
            <div class="span3 text-left">

                <div class="well">
                    <g:render template="/shared/simpleFacetsFilterView"></g:render>
                </div>

            </div>
            <div class="span9 text-left well activities-search-panel">
                <g:if test="${hubConfig.content?.showNote}">
                    <div class="alert alert-info">
                        <strong>Note!</strong> ${hubConfig.content?.recordNote?.encodeAsHTML()}
                    </div>
                </g:if>
                <g:if test="${isProjectContributingDataToALA}">
                    <div class="row-fluid margin-bottom-1">
                        <div class="span12">
                            <a class="btn btn-ala" data-bind="attr:{href: biocacheUrl}">
                                View records in occurrence explorer
                            </a>
                            <a class="btn btn-ala" data-bind="attr:{href: spatialUrl}">
                                View records in spatial portal
                            </a>
                        </div>
                    </div>
                </g:if>
                <ul class="nav nav-tabs" id="tabDifferentViews">
                    <li class="active"><a id="recordVis-tab" href="#recordVis" data-toggle="tab" >List</a></li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane active" id="recordVis">
                        <!-- ko if: activities().length == 0 -->
                            <div class="row-fluid">
                                <h3 class="text-left margin-bottom-five">
                                    <span data-bind="if: $root.searchTerm() == '' && $root.filterViewModel.selectedFacets().length == 0 && !$root.transients.loading()">
                                        No data has been recorded for this project yet
                                    </span>
                                    <span data-bind="if: $root.searchTerm() != '' || $root.filterViewModel.selectedFacets().length > 0 && !$root.transients.loading()">No results</span>
                                </h3>
                            </div>
                        <!-- /ko -->

                            <!-- ko if: activities().length > 0 -->

                            <div class="alert alert-info hide" id="downloadStartedMsg"><i class="fa fa-spin fa-spinner">&nbsp;&nbsp;</i>Preparing download, please wait...</div>

                            <div class="row-fluid" data-bind="visible: version().length == 0">
                                <div class="span12">
                                    <h3 class="text-left margin-bottom-2">Found <span data-bind="text: total()"></span> activities</h3>
                                    <div class="pull-right margin-bottom-2 margin-top-1">
                                        <!-- ko if:  transients.isBulkActionsEnabled -->
                                        <span>Bulk actions -
                                            <div class="btn-group">
                                                <button data-bind="disable: !transients.activitiesToDelete().length, click: bulkDelete" class="btn btn-default"><span class="fa fa-trash">&nbsp;</span> <g:message code="project.bulkactions.delete"/></button>
                                                <button data-bind="disable: !transients.activitiesToDelete().length, click: bulkEmbargo" class="btn btn-default"><span class="fa fa-lock">&nbsp;</span> <g:message code="project.bulkactions.embargo"/></button>
                                                <button data-bind="disable: !transients.activitiesToDelete().length, click: bulkRelease" class="btn btn-default"><span class="fa fa-unlock">&nbsp;</span> <g:message code="project.bulkactions.release"/></button>
                                            </div>
                                        </span>
                                        <!-- /ko -->
                                        <button data-bind="click: download, disable: transients.loading" data-email-threshold="${grailsApplication.config.download.email.threshold ?: 200}" class="btn btn-primary padding-top-1"><span class="fa fa-download">&nbsp;</span>Download</button>
                                    </div>

                                </div>
                            </div>
                        <div class="row-fluid" data-bind="visible: transients.showEmailDownloadPrompt()">
                                <div class="well info-panel">
                                    <div class="margin-bottom-2">
                                        <span class="fa fa-info-circle">&nbsp;&nbsp;</span>This download may take several minutes. Please provide your email address, and we will notify you by email when the download is ready.
                                    </div>

                                    <div class="clearfix control-group">
                                        <label class="control-label span2" for="email">Email address</label>

                                        <div class="controls span10">
                                            <g:textField class="input-xxlarge" type="email" data-bind="value: transients.downloadEmail" name="email"/>
                                        </div>
                                    </div>

                                    <button data-bind="click: asyncDownload" class="btn btn-primary padding-top-1"><span class="fa fa-download">&nbsp;</span>Download</button>
                                </div>
                            </div>

                            <g:render template="/shared/pagination"/>
                            <table class="full-width table table-hover">
                                <thead>
                                
                            <%-- THIS WORKS --%>
                                <tr>
                                    <!-- ko foreach : columnConfig -->
                                    <!-- ko if:  type != 'checkbox' -->
                                    
                                        <th>
                                            <!-- ko if: isSortable -->
                                            <div class="pointer" data-bind="click: $parent.sortByColumn">
                                                <!-- ko text: displayName --> <!-- /ko -->
                                                <span data-bind="css: $parent.sortClass($data)"></span>
                                            </div>

                                            <!-- /ko -->
                                            <!-- ko ifnot: isSortable -->
                                                <!-- ko text: displayName --><!-- /ko -->
                                            <!-- /ko -->
                                            </th>
                                        <!-- /ko -->
                                    <!-- /ko -->
                                </tr>
                                </thead>
                                <%-- THIS WORKS --%>

                                <%-- <tbody>
                                <!-- ko foreach : activities -->

                                    <tr>
                                    <td data-bind="text: ownerName"></td>
                                    <td><a data-bind="attr: {href: siteUrl}, text: siteName"></a></td>
                                    <td data-bind="text: lastUpdated"></td>
                                <td>
                                    <div>
                                        <span>
                                            <a data-bind="attr:{'href': transients.viewUrl}" title="View record" class="btn btn-small editBtn btn-default"><i class="fa fa-file-o"></i> View</a>
                                        </span>
                                        <!-- ko if: showCrud -->
                                        <span data-bind="visible: !readOnly()">
                                            <a data-bind="attr:{'href': transients.editUrl}" title="Edit record" class="btn btn-small editBtn btn-default"><i class="fa fa-pencil"></i> Edit</a>
                                        </span>
                                        <span data-bind="visible: !readOnly()">
                                            <button class="btn btn-small btn-default" data-bind="click: $parent.delete" title="Delete record"><i class="fa fa-trash"></i>&nbsp;Delete</button>
                                        </span>
                                        <!-- /ko -->
                                    </div>
                                </td>
                                    </tr>    
                                    <!-- /ko -->
                                </tbody> --%>

                                <tbody>
                                      <!-- ko foreach : activities -->
                                      <tr>
                                      <!-- ko if: type == 'details' -->
                                        <td>
                                            <div class="row-fluid">
                                                <div class="span12">
                                                    <div>
                                                        Recorded on: <span
                                                            data-bind="text: $parent.eventDate.formattedDate"></span>
                                                        <span data-bind="visible: $parent.eventTime, text: $parent.eventTime"></span>
                                                    </div>
                                                    <div>
                                                        Submitted on: <span
                                                            data-bind="text: $parents[1].lastUpdated.formattedDate"></span>
                                                    </div>
                                                    <div>
                                                        Recorded by: <span
                                                            data-bind="text: $parents[1].ownerName"></span>
                                                    </div>
                                                    <div>
                                                        Coordinate: <span class="display-inline-block ellipsis-50"
                                                            data-bind="text: $parent.coordinates[0], attr: {title: $parent.coordinates[0]}"></span>
                                                        <span class="display-inline-block ellipsis-50"
                                                            data-bind="text: ',' + $parent.coordinates[1], attr: {title: $parent.coordinates[1]}"></span>
                                                    </div>
                                                    <div>
                                                        Survey name:
                                                        <a data-bind="attr:{'href': $parents[1].transients.addUrl}">
                                                            <span data-bind="text: $parents[1].name"></span>
                                                        </a>
                                                    </div>
                                                    <div>
                                                        Project name: <a
                                                            data-bind="attr:{'href': $parents[1].projectUrl()}"><span
                                                                data-bind="text: $parents[1].projectName"></span></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <!-- /ko -->
                                      </tr>
                                      <!-- /ko -->  
                                </tbody>
                            </table>
                            <div class="margin-top-2"></div>
                            <g:render template="/shared/pagination"/>
                            <!-- ko if : activities().length > 0 -->
                            <div class="row-fluid">
                                <div class="span12 pull-right">
                                    <div class="span12 text-right">
                                        <div><small class="text-right"><span class="fa fa-lock"></span> indicates that only project members can access the record.
                                        </small></div>
                                        <div><small class="text-right"><span class="fa fa-caret-up fa-2x" style="vertical-align: -3px;"></span>  indicates species absence record.
                                        </small></div>
                                    </div>

                                </div>
                            </div>
                            <!-- /ko -->
                        <!-- /ko -->
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- /ko -->

<asset:script type="text/javascript">
    var activitiesViewModel, alaMap, results;
    function initialiseData(view) {
        var user = '${user ? user as grails.converters.JSON : "{}"}',
        configImageGallery;
        if (user) {
            user = JSON.parse(user);
        } else {
            user = null;
        }

        var columnConfig =${ hubConfig.getDataColumns(grailsApplication) as grails.converters.JSON}

        activitiesViewModel = new ActivitiesAndRecordsViewModel('activities-placeholder', view, user, ${showSites}, false, ${doNotStoreFacetFilters?:false}, columnConfig);
        ko.applyBindings(activitiesViewModel, document.getElementById('survey-all-activities-content'));

    }

    // initialise tab
    var recordsTab = getUrlParameterValue('recordsTab'),
        tabId;
    switch (recordsTab){
        case 'map':
            tabId = '#dataMapTab';
            break;
        case 'list':
            tabId = '#recordVis-tab';
            break;
        case 'image':
            tabId = '#dataImageTab';
            break;
    }

    tabId && $(tabId).tab('show');
</asset:script>
<asset:script type="text/html" id="script-popup-template">
    <div class="record-map-popup">
        <div class="container-fluid">
            <h3>Record (<!-- ko text: index() + 1 --> <!-- /ko --> of <!-- ko text: features.length --> <!-- /ko -->)</h3>
            <!-- ko foreach: features -->
            <div data-bind="if: $root.index() == $index()">
                <div class="row-fluid margin-bottom-10" data-bind="if: $data.properties.thumbnailUrl">
                    <div class="span12">
                        <div class="projectLogo image-centre">
                            <a target="_blank" data-bind="attr: { href: fcConfig.activityViewUrl + '/' + $data.properties.activityId }">
                                <img class="image-window image-logo" onload="findLogoScalingClass(this, 200, 150)" alt="Click to view record"  data-bind="attr: {src: $data.properties.thumbnailUrl || fcConfig.imageLocation + 'no-image-2.png'}" onerror="imageError(this, fcConfig.imageLocation + 'no-image-2.png');">
                            </a>
                        </div>
                    </div>
                </div>
                <div class="row-fluid" data-bind="if: $data.properties.recordNameFacet">
                    <div class="span6"><span><g:message code="record.popup.scientificname"/></span></div>
                    <div class="span6" data-bind="text: $data.properties.recordNameFacet"></div>
                </div>
                <div class="row-fluid" data-bind="if: $data.properties.projectActivityNameFacet">
                    <div class="span6"><span><g:message code="record.popup.survey"/></span></div>
                    <div class="span6" data-bind="text: $data.properties.projectActivityNameFacet"></div>
                </div>
                <div class="row-fluid" data-bind="if: $data.properties.projectNameFacet">
                    <div class="span6"><span><g:message code="record.popup.project"/></span></div>
                    <div class="span6">
                        <a title="View details of this project" target="_blank"
                           data-bind="attr: { href: fcConfig.projectIndexUrl + '/' + $data.properties.projectId }, text: $data.properties.projectNameFacet">
                        </a>
                    </div>
                </div>
                <div class="row-fluid" data-bind="if: $data.geometry.coordinates">
                    <div class="span6"><span><g:message code="record.popup.latlon"/></span></div>
                    <div class="span6">
                        <!-- ko text: Math.floor($data.geometry.coordinates[1]*10000)/10000 --> <!-- /ko --> &
                        <!-- ko text: Math.floor($data.geometry.coordinates[0]*10000)/10000 --> <!-- /ko -->
                    </div>
                </div>
                <div class="row-fluid" data-bind="if: $data.properties.surveyMonthFacet && $data.properties.surveyYearFacet">
                    <div class="span6"><span><g:message code="record.popup.created"/></span></div>
                    <div class="span6">
                    <!-- ko text: $data.properties.surveyMonthFacet --> <!-- /ko -->,
                    <!-- ko text: $data.properties.surveyYearFacet --> <!-- /ko -->
                    </div>
                </div>
                <div class="btn-group">
                    <button type="button" class="btn btn-mini" title="Previous record" data-bind="click: $root.index($root.index() - 1), disable: $root.index() == 0"><span>«</span></button>
                    <button type="button" class="btn btn-mini" title="Next record" data-bind="click: $root.index($root.index() + 1), disable: $root.index() == ($root.features.length - 1)"><span>»</span></button>
                </div>
                <a class="btn btn-mini" title="View details of this record" target="_blank" data-bind="attr: { href: fcConfig.activityViewUrl + '/' + $data.properties.activityId }"><span><g:message code="record.popup.view"/></span></a>
            </div>
            <!-- /ko -->
        </div>
    </div>
</asset:script>