<%@ page import="grails.converters.JSON; au.org.ala.biocollect.merit.SettingPageType" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE HTML>
<html xmlns="http://www.w3.org/1999/html">
<head>
    <meta name="layout" content="${hubConfig.skin}"/>
    <title><g:message code="project.works.heading"/> | <g:message code="project.works.heading"/></title>
    <r:script disposition="head">
    var fcConfig = {
        baseUrl: "${grailsApplication.config.grails.serverURL}",
        spatialService: '${createLink(controller:'proxy',action:'feature')}',
        intersectService: "${createLink(controller: 'proxy', action: 'intersect')}",
        regionListUrl: "${createLink(controller: 'regions', action: 'regionsList')}",
        featuresService: "${createLink(controller: 'proxy', action: 'features')}",
        featureService: "${createLink(controller: 'proxy', action: 'feature')}",
        spatialWms: "${grailsApplication.config.spatial.geoserverUrl}",
        geocodeUrl: "${grailsApplication.config.google.geocode.url}",
        siteMetaDataUrl: "${createLink(controller:'site', action:'locationMetadataForPoint')}",
        spatialBaseUrl: "${grailsApplication.config.spatial.baseURL}",
        spatialWmsCacheUrl: "${grailsApplication.config.spatial.wms.cache.url}",
        spatialWmsUrl: "${grailsApplication.config.spatial.wms.url}",
        sldPolgonDefaultUrl: "${grailsApplication.config.sld.polgon.default.url}",
        sldPolgonHighlightUrl: "${grailsApplication.config.sld.polgon.highlight.url}",
        organisationLinkBaseUrl: "${createLink(controller: 'organisation', action: 'index')}",
        defaultSearchRadiusMetersForPoint: "${grailsApplication.config.defaultSearchRadiusMetersForPoint ?: "100km"}",
        imageLocation:"${resource(dir:'/images')}",
        logoLocation:"${resource(dir:'/images/filetypes')}",
        dashboardUrl: "${g.createLink(controller: 'report', action: 'dashboardReport', params: params)}",
        projectListUrl: "${createLink(controller: 'project', action: 'search', params:[initiator:'biocollect'])}",
        projectIndexBaseUrl : "${createLink(controller:'project',action:'index')}/",
        organisationBaseUrl : "${createLink(controller:'organisation',action:'index')}/",
        isCitizenScience: false,
        showAllProjects: false,
        meritProjectLogo:"${resource(dir:'/images', file:'merit_project_logo.jpg')}",
        associatedPrograms: ${associatedPrograms}
    }
        <g:if test = "${grailsApplication.config.merit.projectLogo}" >
            fcConfig.meritProjectLogo = fcConfig.imageLocation + "/" + "${grailsApplication.config.merit.projectLogo}";
        </g:if>
    </r:script>
    <script type="text/javascript" src="//www.google.com/jsapi"></script>
    <r:require modules="js_iso8601,knockout,jqueryValidationEngine,projects,projectFinder,map"/>
</head>
<body>
<div id="wrapper" class="content container-fluid">
    <g:render template="/shared/projectFinderQueryPanel" model="${[showSearch:false]}"/>
    <div class="row-fluid">
        <div class="span12 padding10-small-screen" id="heading">
            <h1 class="pull-left"><g:message code="project.works.heading"/></h1>
            <div class="pull-right">
                <a class="btn btn-info" href="${createLink(controller: 'home', action: 'gettingStarted')}"><i class="icon-info-sign icon-white"></i> Getting started</a>
                <a class="btn btn-info" href="${createLink(controller: 'home', action: 'whatIsThis')}"><i class="icon-question-sign icon-white"></i> What is this?</a>
            </div>
        </div>
    </div>

    <g:render template="/shared/projectFinderResultPanel"></g:render>


</div>
<r:script>
    $("#newPortal").on("click", function() {
        document.location.href = "${createLink(controller:'project',action:'create',params:[works:true])}";
    });

    var projectFinder = new ProjectFinder();

</r:script>
</body>
</html>