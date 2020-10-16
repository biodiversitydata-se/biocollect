<%@ page import="grails.converters.JSON; org.grails.web.json.JSONArray" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>BioCollect</title>
  <meta name="layout" content="${hubConfig.skin}"/>
  <style type="text/css">
    legend {
        border: none;
        margin-bottom: 5px;
    }
    h1 input[type="text"] {
        color: #333a3f;
        font-size: 28px;
        /*line-height: 40px;*/
        font-weight: bold;
        font-family: Arial, Helvetica, sans-serif;
        height: 42px;
    }
    .no-border { border-top: none !important; }
  </style>
    <link rel="stylesheet" src="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400italic,600,700"/>
    <link rel="stylesheet" src="https://fonts.googleapis.com/css?family=Oswald:300"/>
</head>
<body>
<h2>Hej ${userName}!</h2>
<g:if test="${personStatus == 'ok'}">
    <h3>Mina projekt</h3>
    
    <div class="well">
        <div class="tiles">
            <g:each in="${projects}">
                <div class="row-fluid row-eq-height">
                    <div class='well tile span' id="${it.projectId}">
                        
                        <div class="span12 padding-left-5" style="min-width: 80px;">
                            <div test="${hubConfig?.content?.hideProjectFinderNoImagePlaceholderTile == true}">
                                <a href="${createLink(controller: 'project', action: 'index', id: it?.projectId)}">
                                    <img class="image-logo lazy" src="${asset.assetPath(src:'') + grailsApplication.config.merit.projectLogo}"/>
                                </a>
                            </div>
                        </div>
                        
                        <div class="tile-title">
                            <h2><a href="${createLink(controller: 'project', action: 'index', id: it?.projectId)}">${it?.name}</a></h2>
                        </div>
                    </div>
            </g:each>
        </div>       
    </div> 
        
    <h3>Vad vill du göra?</h3>
    <div class="accordion" id="homePageConfiguration">
        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseZero">
                    Mina platser
                </a>
            </div>
            <div id="collapseZero" class="accordion-body collapse">
                    <div class="accordion-inner">
                        <div class="control-group">
                            ${siteStatus}
                            <ul>
                            <g:each in="${sites}">
                                <li><a href="${createLink(controller: 'site', action:'index', id: it?.siteId)}">${it?.name}</a></li>
                            </g:each>
                            </ul>
                        </div>
                    </div>
            </div>
        </div>
        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseOne">
                    Rapportera inventeringsdata
                </a>
            </div>
            <div id="collapseOne" class="accordion-body collapse">
                    <div class="accordion-inner">
                        <div class="control-group">
                            <label>Du kan rapportera för:</label>
                            <ul>
                            <g:each in="${surveys}">
                                <g:each in="${it}">
                                    <li><a href="${createLink(controller: 'bioActivity', action: 'create', id: it?.projectActivityId)}">${it?.name}</a></li>
                                </g:each>
                            </g:each>
                            </ul>
                        </div>
                    </div>
            </div>
        </div>


        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseFour">
                Skapa en rutt</a>
            </div>
            <div id="collapseFour" class="accordion-body collapse">
            <div class="accordion-inner">
            <div class="control-group">
            <label>Du kan skapa en rutt för:</label>
                <ul>
                <g:each in="${surveys}">
                    <g:each in="${it}">
                    <g:if test="${it.allowPolygons || it.allowLine || it.allowPoints}">
                        <li><a href="${createLink(controller: 'site', action: 'createSystematic', 
                            params: [projectId:it?.projectId, pActivityId:it?.projectActivityId, personId: person?.personId])}">
                            ${it?.name}
                        </a></li>
                    </g:if>
                    </g:each>
                </g:each>
                </ul>
            </div>
            </div>
        </div>

        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" href="${createLink(controller: 'bioActivity', action: 'list')}">
                    Se mina tidigare data
                </a>
            </div>
        </div>
        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" data-parent="#accordion2" href="${createLink(action:'edit', id: person?.personId)}">
                    Uppdatera min profil
                </a>
            </div>
        </div>
    </div>

</g:if>
<g:else>
    ${personStatus}
</g:else>
</body>