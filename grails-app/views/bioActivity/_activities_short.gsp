<%@ page import="grails.converters.JSON" %>
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
                                <tbody>
                                      <!-- ko foreach : activities -->
                                      <tr>
                                      <!-- ko foreach: $parent.columnConfig -->
                                        <!-- ko if: type == 'action' -->
                                        <td>
                                            <div>
                                                <span>
                                                    <a data-bind="attr: {href: $parent.transients.viewUrl}" title="View record" class="btn btn-small editBtn btn-default margin-top-5"><i class="fa fa-file-o"></i> View</a>
                                                </span>
                                                
                                                <span data-bind="visible: !$parent.readOnly, if: $parent.showCrud">
                                                    <a data-bind="attr: {href: $parent.transients.editUrl }" title="Edit record" class="btn btn-small editBtn btn-default margin-top-5"><i class="fa fa-pencil"></i> Edit</a>
                                                </span>
                                                
                                            </div>
                                        </td>
                                        <!-- /ko -->
                                        <!-- ko if:  type == 'details' -->
                                            <td>
                                                <div class="row-fluid">
                                                    <div class="span12">
                                                        <div data-bind="visible: $parent.dateCreated">
                                                            Submitted on: <span
                                                                data-bind="text: $parent.dateCreated.formattedDate"></span>
                                                        </div>
                                                        <div data-bind="visible: $parent.ownerName">
                                                            Recorded by: <span
                                                                data-bind="text: $parent.ownerName"></span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                        <!-- /ko -->
                                        <!-- ko if:  type == 'property' -->
                                        <td>
                                            <!-- ko if: dataType == 'date' -->
                                            <div data-bind="text: $parent.dateCreated"></div>
                                            <!-- /ko -->
                                            <!-- ko ifnot: dataType == 'date' -->
                                            <div data-bind="text: $parent.getPropertyValue($data)"></div>
                                            <!-- /ko -->
                                        </td>
                                        <!-- /ko -->
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

        activitiesViewModel = new ActivitiesAndRecordsViewModel('activities-placeholder', view, user, ${showSites}, false, ${doNotStoreFacetFilters?:false}, columnConfig, true);
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