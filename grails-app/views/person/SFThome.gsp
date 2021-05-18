<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>BioCollect</title>
    <meta name="layout" content="${hubConfig.skin}"/>
</head>
<body>

<g:if test="${personStatus == 'ok'}">
<h2>Välkommen ${person?.firstName.encodeAsHTML() + ' ' + person?.lastName.encodeAsHTML()}!</h2>
    <h3>Vad vill du göra?</h3>
    <div class="accordion" id="homePageConfiguration">
        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapse0">
                    Se mina rutter/ rutor/ sektorer (personliga eller bokade)
                </a>
            </div>
            <div id="collapse0" class="accordion-body collapse">
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
                <a class="accordion-toggle" data-toggle="collapse" href="#collapse1">
                Skapa en rutt</a>
            </div>
            <div id="collapse1" class="accordion-body collapse">
                <div class="accordion-inner">
                    <div class="control-group">
                        <ul>
                            <g:each in="${surveys}">
                                <g:if test="${it?.surveySiteOption == 'sitecreatesystematic'}">
                                    <li><a href="${createLink(controller: 'site', action: 'createSystematic', 
                                            params: [projectId:it?.projectId, pActivityId:it?.projectActivityId])}">
                                            ${it?.name}
                                            </a>(se <a href="${it?.methodUrl}">metoder</a>) 
                                    </li>
                                </g:if>
                            </g:each>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapse2">
                Boka en rutt/ ruta/ sektor</a>
            </div>
            <div id="collapse2" class="accordion-body collapse">
                <div class="accordion-inner">
                    <div class="control-group">
                        <ul>
                            <g:each in="${projects}">
                                <g:if test="${it.alertConfig?.ctx.contains('siteBooking')}">
                                    <li><a href="${createLink(controller: 'project', action: 'index', id: it?.projectId, params: [defaultTab: 'sites', personId: person.personId])}">${it?.name}</a></li>
                                </g:if>
                            </g:each>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapse3">
                    Rapportera resultat
                </a>
            </div>
            <div id="collapse3" class="accordion-body collapse">
                    <div class="accordion-inner">
                        <div class="control-group">
                            <label>Jag vill rapportera en:</label>
                            <ul>
                                <g:each in="${surveys}">
                                    <li><a href="${createLink(controller: 'bioActivity', action: 'create', id: it?.projectActivityId)}">${it?.name}</a>
                                    </li>
                                </g:each>
                            </ul>
                            Notera att inventeringen måste vara från en bokad eller nyligen skapad rutt, alternativt från en egen punktrutt du gjort tidigare
                        </div>
                    </div>
            </div>
        </div>
        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapse4">
                    Fortsätt arbeta med dina utkast
                </a>
            </div>
            <div id="collapse4" class="accordion-body collapse">
                    <div class="accordion-inner">
                        <div class="control-group">
                        <g:if test="${!drafts}">
                            Du har inga sparade utkast.
                        </g:if>
                        <g:else>
                            <ul>
                                <g:each in="${drafts}">
                                    <li><a href="${createLink(controller: 'bioActivity', action: 'edit', id: it?.activityId)}">${it?.type} created on ${it?.dateCreated[0..9]}</a>
                                    </li>
                                </g:each>
                            </ul>
                        </g:else>
                        </div>
                    </div>
            </div>
        </div>
        <div class="accordion-group">
            <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapse5">
                Läsa om de olika delprogrammen</a>
            </div>
            <div id="collapse5" class="accordion-body collapse">
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
                <a class="accordion-toggle" href="${createLink(action:'edit', id: person?.personId, params:[defaultTab:'contact'])}&returnTo=${createLink(controller:'person', action:'home')}">
                    Uppdatera min profil
                </a>
            </div>
        </div>
        <div class="accordion-group">
            <div class="accordion-heading">
            <%-- Note this is a workaround - volunteer management happens on the hub level 
            volunteers belong to a hub rather than a project but the members tab is inside a project
            since SFT volunteers are added to all projects on default, it doesn't matter which one we open here --%>
                <a class="accordion-toggle" href="${createLink(controller: 'project', action: 'index', id: projects[0].projectId, params: [defaultTab: 'admin'])}">
                    Hitta en person
                </a>
            </div>
        </div>
        <g:if test="${userIsAlaOrFcAdmin}">
            <div class="accordion-group">
                <div class="accordion-heading">
                    <a class="accordion-toggle" href="${createLink(controller: 'project', action: 'create', params: [systematicMonitoring: true])}">
                        Lägg till nytt projekt
                    </a>
                </div>
            </div>
        </g:if>
    </div>

</g:if>
<g:else>
    ${personStatus}
</g:else>
</body>
</html>