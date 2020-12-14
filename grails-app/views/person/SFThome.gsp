<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>BioCollect</title>
    <meta name="layout" content="${hubConfig.skin}"/>
</head>
<body>

<g:if test="${personStatus == 'ok'}">
<h2>Välkommen ${person.firstName + ' ' + person.lastName}!</h2>
    <h3>Vad vill du göra?</h3>
    <div class="accordion" id="homePageConfiguration">
        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapseZero">
                    Se mina rutter/ rutor/ sektorer (personliga eller bokade)
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
                <a class="accordion-toggle" data-toggle="collapse" href="#collapseOne">
                    Rapportera resultat
                </a>
            </div>
            <div id="collapseOne" class="accordion-body collapse">
                    <div class="accordion-inner">
                        <div class="control-group">
                            <label>Du kan rapportera för:</label>
                            <ul>
                                <li><a href="${createLink(controller: 'bioActivity', action: 'create', id: 'a14cf615-a26b-48a7-87fd-00360f3d03d6', params: [personId: person.personId])}">Standardrutt</a></li>
                                <li><a href="${createLink(controller: 'bioActivity', action: 'create', id: 'eb7e3708-f1ff-4114-b1c3-84ed93ec7a8d', params: [personId: person.personId])}">Nattrutt</a></li>
                                <li><a href="${createLink(controller: 'bioActivity', action: 'create', id: 'ccace44f-c37a-44de-a586-7880128046d3', params: [personId: person.personId])}">Vinterrutt</a></li>
                                <li><a href="${createLink(controller: 'bioActivity', action: 'create', id: 'd47b0d4e-6353-4bb8-94cb-400a5f07f21d', params: [personId: person.personId])}">Kustfågelrutor</a></li>
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
                                params: [projectId:'b7eee643-d5fe-465e-af38-36b217440bd2', pActivityId:'ccace44f-c37a-44de-a586-7880128046d3', personId: person?.personId, allowDetails: 'no'])}">
                            Vinterrutt</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapseThree">
                Boka en rutt/ ruta/ sektor</a>
            </div>
            <div id="collapseThree" class="accordion-body collapse">
                <div class="accordion-inner">
                    <div class="control-group">
                        <ul>
                            <li><a href="${createLink(controller: 'project', action: 'index', params: [id: '89383d0f-9735-4fe7-8eb4-8b2e9e9b7b5c', sitesTabDefault: true, personId: person.personId])}">Standardrutt</a></li>
                            <li><a href="${createLink(controller: 'project', action: 'index', params: [id: 'd0b2f329-c394-464b-b5ab-e1e205585a7c', sitesTabDefault: true, personId: person.personId])}">Nattrutt</a></li>
                            <li><a href="${createLink(controller: 'project', action: 'index', params: [id: '49f55dc1-a63a-4ebf-962b-4d486db0ab16', sitesTabDefault: true, personId: person.personId])}">Kustfågelrutor</a></li>
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
                            <a href="${createLink(controller: 'project', action: 'index', id: it?.projectId, params: [personId: person.personId])}">${it?.name}</a>
                            <br/>
                        </g:each>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" href="${createLink(action: 'edit', id: person?.personId, params:[defaultTab:'surveys'])}">
                    Se vad jag rapporterat tidigare
                </a>
            </div>
        </div>
        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" href="${createLink(action:'edit', id: person?.personId, params:[defaultTab:'contact'])}">
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