<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>BioCollect</title>
    <meta name="layout" content="${hubConfig.skin}"/>
    <asset:javascript src="common.js"/>
    <asset:javascript src="persons.js"/>
</head>
<body>
<script>
var fcConfig = {
    requestMembershipUrl : "${createLink(action: 'sendMemembershipRequest')}",
    personSaveUrl: "${createLink(action: 'save')}",
    returnTo: window.location.href
    }
</script>
<h2>Välkommen ${userName}!</h2>
<g:if test="${personStatus == 'registeredVolunteer'}">
<div class="well">
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
        <g:if test="${userIsAlaOrFcAdmin}">
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
            <div class="accordion-group">
                <div class="accordion-heading">
                    <a class="accordion-toggle" href="${createLink(controller: 'project', action: 'create', params: [systematicMonitoring: true])}">
                        Lägg till nytt projekt
                    </a>
                </div>
            </div>
        </g:if>
    </div>
</div>

</g:if>


<g:elseif test="${personStatus == 'existingPerson'}">
    <%-- if the user registered on CAS and the email address exists in the database but isn't added to any projects --%>
    <div class="well">
        <h4>Din e-post finns i vår databas. Klicka på "Skicka" så länkar vi dig till systemet.</h4>
        <button class="btn btn-primary form-control" id="btnRequestMembership"><g:message code="g.submit"/></button>
    </div>
</g:elseif>

<g:elseif test="${personStatus == 'notMember'}">
<div class="well">
    <h4>Något stämmer inte. Vänligen maila oss på fageltaxering@biol.lu.se för att bli inlagd i systemet.</h4>
</div>
</g:elseif>

<g:else>
    <%-- if the user registered on CAS but isn't added to any projects --%>
    <div class="well">
        <div id="personalDetailsForm">
            <h4>Din e-post finns inte i vårt system. Om du tror eller vet att du varit med i Svensk Fågeltaxering förut 
            (har du kanske en ny e-post adress?), vänligen maila till oss på fageltaxering@biol.lu.se och berätta. 
            Då kan vi länka dig till systemet. 
            <br>Om du är helt ny, vänligen fyll i formuläret nedan och skicka.</h4>
            <g:render template="/person/personalData"/>
        </div>
    </div>
    <script>
    $(function(){
        var personViewModel = new PersonViewModel(null, true);
        ko.applyBindings(personViewModel, document.getElementById('personal-details-form'));
    }); 
    </script>
</g:else>
<%-- <h4> Undrar du över hur man använder BioCollect? Läs våra instruktioner <a href="#">här.</a></h4> --%>

<asset:script type="text/javascript">

$("#btnRequestMembership").click(function(){
    var url = fcConfig.requestMembershipUrl;
    var data = {
        internalPersonId: "${person?.internalPersonId}",
        hub: "${hub.toString()}",
        userId: "${userId}",
        email: "${person?.email}",
        displayName: "${userName}"
    }

    $.ajax({
        url: url,
        type: 'POST',
        data: JSON.stringify(data),
        contentType: 'application/json',
        success: function (data) {
            bootbox.alert('Tack, din förfrågan har nu skickats. Vi kommer höra av oss i ett mail och bekräfta din registrering.');

        },
        error: function (data) {
            var errorMessage = data.responseText || 'Något stämmer inte. Vänligen maila oss på fageltaxering@biol.lu.se för att bli inlagd i systemet.'
            bootbox.alert(errorMessage);
        }
    });
})
</asset:script>

</body>
</html>