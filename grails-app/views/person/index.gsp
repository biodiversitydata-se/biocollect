<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta name="layout" content="${hubConfig.skin}"/>
    <title> ${person.firstName.encodeAsHTML() + ' ' + person.lastName}</title>
    <asset:script type="text/javascript">
    var fcConfig = {
        homePageUrl : "${createLink(controller: 'home', action: 'index')}",
        personEditUrl: "${createLink(action: 'edit', params: [id: person.personId, projectId: params.projectId])}",
        activityViewUrl: "${createLink(controller: 'bioActivity', action: 'index')}",
        returnToProjectUrl: "${createLink(controller: 'project', action:'index', params: [id: params.projectId])}",
        getOutputForPersonBySurveyNameUrl: "${createLink(controller: 'output', action:'getOutputForPersonBySurveyName')}"
        };
        here = window.location.href;
    </asset:script>

    <asset:javascript src="common.js"/>
    <asset:javascript src="persons.js"/>
    <asset:javascript src="datatables-manifest.js"/>

</head>
<body>
    <div class="container-fluid">
    <bs:form action="" inline="true">
            
    <ul class="nav nav-tabs" id="personDetailsTab">
        <li><a href="#personal" id="personal-tab" data-toggle="tab"><g:message code='person.info.heading'/></a></li>
        <li><a href="#surveys" id="surveys-tab" data-toggle="tab"><g:message code='project.tab.surveys'/></a></li>
    </ul>
    <div class="tab-content">
        <div class="tab-pane" id="personal">
        <div class="container-fluid">
            <div class="row-fluid">
                <h2><g:message code="project.admin.members.details"/></h2>
                <hr>
                <div class="col">
                    <div class="well span6">
                        <label><g:message code="person.personalInfo.id"/></label>
                        <p>${person.personId}</p>
                        <label><g:message code="person.personalInfo.internalId"/></label>
                        <p>${person.internalPersonId}</p>
                        <label><g:message code="person.personalInfo.first"/></label>
                        <p>${person.firstName}</p>
                        <label><g:message code="person.personalInfo.last"/></label>
                        <p>${person.lastName}</p>
                        <label><g:message code="person.personalInfo.email"/></label>
                        <p>${person.email}</p>
                        <label><g:message code="person.personalInfo.phone"/></label>
                        <p>${person.phoneNum}</p>
                        <label><g:message code="person.personalInfo.mobile"/></label>
                        <p>${person.mobileNum}</p>
                    </div>
                </div>
                <div class="span6">
                    <div class="well span12">
                        <label><g:message code="person.personalInfo.address"/> 1</label>
                        <p>${person.address1}</p>
                        <label><g:message code="person.personalInfo.address"/> 2</label>
                        <p>${person.address2}</p>
                        <label><g:message code="person.personalInfo.postcode"/></label>
                        <p>${person.postCode}</p>
                        <label><g:message code="person.personalInfo.town"/></label>
                        <p>${person.town}</p>
                        <label><g:message code="person.personalInfo.gender"/></label>
                        <p>${person.gender}</p>
                        <label><g:message code="person.personalInfo.dob"/></label>
                        <p>${person.birthDate}</p>
                        <label><g:message code="person.personalInfo.extra"/></label>
                        <p>${person.extra}</p>
                    </div>
                </div>
            </div>
            <div class="row-fluid">
            <div class="form-actions span12">
                <button class="btn btn-primary" id="edit"><g:message code='g.edit'/></button>
                <%-- <a id="cancel" class="btn" href="javascript:history.go(-1)">Cancel</a> --%>
                <button type="button" id="cancel" class="btn"><g:message code='g.cancel'/></button>
            </div>
        </div>
        </div>
    </div>
        <div class="tab-pane" id="surveys">
            <g:render template="personSurveys"></g:render>
        </div>
    </div>


    </bs:form>
    </div>

</body>
    <asset:script type="text/javascript">

    new RestoreTab('personDetailsTab', 'personal-tab');

    $('#delete').on("click", function (e) {
    var personId = "${personId}";
        var message = "<span class='label label-important'>Important</span><p><b>This cannot be undone</b></p><p>Are you sure you want to delete this person?</p>";
        bootbox.confirm(message, function (result) {
            if (result) {
                $.ajax({
                    url: fcConfig.deletePersonUrl,
                    type: 'DELETE',
                    success: function (data) {
                        alert("Successfully deleted. Indexing is in process, search result will be updated in few minutes. Redirecting to search page...", "alert-success");
                        window.location.href = fcConfig.returnToProjectUrl;
                    },
                    error: function () {
                        alert("Error deleting person")
                        document.location.href = fcConfig.returnToProjectUrl;
                    }
                });
            }
        });
    });

    $('#edit').on("click", function (){
        document.location.href = fcConfig.personEditUrl;
    })

    $('#cancel').on("click", function (){
        document.location.href = fcConfig.returnToProjectUrl;
    })
    </asset:script>
</html>
