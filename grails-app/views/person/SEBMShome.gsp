<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>BioCollect</title>
    <meta name="layout" content="${hubConfig.skin}"/>
</head>
<body>

<g:if test="${personStatus == 'ok'}">
<h2>Välkommen ${person.firstName.encodeAsHTML() + ' ' + person.lastName.encodeAsHTML()}!</h2>
    <h3>Vad vill du göra?</h3>
    <div class="accordion" id="homePageConfiguration">
        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapseZero">
                    Se mina rutter/ rutor/ sektorer
                </a>
            </div>
            <div id="collapseZero" class="accordion-body collapse">
                    <div class="accordion-inner">
                        <div class="control-group">
                            ${siteStatus}
                            <ul>
                            <g:each in="${sites}">
                                <li><a href="${createLink(controller: 'site', action:'index', id: it?.siteId)}">${it?.name.encodeAsHTML()}</a></li>
                            </g:each>
                            </ul>
                        </div>
                    </div>
            </div>
        </div>
        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapseOne">
                    Rapportera resultat
                </a>
            </div>
            <div id="collapseOne" class="accordion-body collapse">
                    <div class="accordion-inner">
                        <div class="control-group">
                            <label>Du kan rapportera för:</label>
                            <ul>
                                <li><a href="${createLink(controller: 'bioActivity', action: 'create', id: '642ee449-88c1-4e76-9350-85f66cb6ad8e', params: [personId: person.personId])}">Punklokal</a></li>
                                <li><a href="${createLink(controller: 'bioActivity', action: 'create', id: '3a024566-7a65-41c8-b740-aed47d42e8d4', params: [personId: person.personId])}">Slinga</a></li>
                            </ul>
                        </div>
                    </div>
            </div>
        </div>
        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapseTwo">
                Skapa en rutt/ sektor</a>
            </div>
            <div id="collapseTwo" class="accordion-body collapse">
                <div class="accordion-inner">
                    <div class="control-group">
                        <ul>
                        <li><a href="${createLink(controller: 'site', action: 'createSystematic', 
                                params: [projectId:'1fb10915-e6c0-451e-b575-b7e715d5d32f', pActivityId:'642ee449-88c1-4e76-9350-85f66cb6ad8e', personId: person?.personId, allowDetails: 'yes'])}">
                            Punktlokal</a>
                        </li>
                        <li><a href="${createLink(controller: 'site', action: 'createSystematic', 
                                params: [projectId:'30634be4-7aac-4ffb-8e5f-5e100ed2a4ea', pActivityId:'3a024566-7a65-41c8-b740-aed47d42e8d4', personId: person?.personId, allowDetails: 'yes'])}">
                            Slinga</a>
                        </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapseFour">
                Läs om de olika delprogrammen</a>
            </div>
            <div id="collapseFour" class="accordion-body collapse">
                <div class="accordion-inner">
                    <div class="control-group">
                        <ul>
                        <g:each in="${projects}">
                            <a href="${createLink(controller: 'project', action: 'index', id: it?.projectId)}">${it?.name.encodeAsHTML()}</a>
                            <br/>
                        </g:each>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" href="${createLink(controller: 'bioActivity', action: 'list')}">
                    Se vad jag rapporterat tidigare
                </a>
            </div>
        </div>
        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" href="${createLink(action:'edit', id: person?.personId)}">
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