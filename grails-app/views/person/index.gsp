<%@ page import="grails.converters.JSON; org.grails.web.json.JSONArray" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta name="layout" content="${hubConfig.skin}"/>
    <title> ${firstName.encodeAsHTML() + ' ' + lastName}</title>

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
    <asset:script type="text/javascript">
    var fcConfig = {
        homePageUrl : "${createLink(controller: 'home', action: 'index')}",
        personSaveUrl: "${createLink(action: 'save')}",
        updatePersonUrl: "${createLink(action: 'update')}",
        deletePersonUrl: "${createLink(action:'delete')}",
        returnToProjectUrl: "${createLink(controller: 'project', action:'index')}"
        };
        here = window.location.href;

    </asset:script>

    <asset:javascript src="common.js"/>
    <asset:javascript src="persons.js"/>

</head>
<body>
    <%-- <div class="container-fluid validationEngineContainer" id="validation-container"> --%>
    <div class="container-fluid validationEngineContainer">
        <div id="person">
         <g:link action="edit" id="${personId}" class="btn btn-small"><i
                    class="icon-edit"></i> Edit person</g:link>
        <bs:form action="update" inline="true">
            
    <ul class="nav nav-tabs" id="personDetailsTab">
        <li><a href="#personal" id="personal-tab" data-toggle="tab">Personal info</a></li>
        <li><a href="#sites" id="sites-tab" data-toggle="tab">Sites</a></li>
    </ul>
    <div class="tab-content">
        <div class="tab-pane" id="personal">
            <div class="row-fluid">
        <h2><g:message code=""/>Person details</h2>

        <div class="span6">
            <label for=""><g:message code=""/>Personal code<g:message code=""/></label>
            <p>${personId}</p>
           <%-- <input data-bind="value: '${personId}'" id="personId" type="text" class="span12"/> --%>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>First name<g:message code=""/></label>
                        <p>${firstName}</p>
           <%-- <input data-bind="text: firstName" id="firstName" type="text" class="span12"/> --%>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Last name<g:message code=""/></label>
                        <p>${lastName}</p>

           <%-- <input data-bind="text: lastName" id="lastName" type="text" class="span12"/> --%>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Email address<g:message code=""/></label>
            <p>${email}</p>
           <%-- <input data-bind="text: email" id="email" type="text" class="span12"/> --%>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Address 1<g:message code=""/></label>
            <p>${address1}</p>
           <%-- <input data-bind="text: address1"  type="text" class="span12"/> --%>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Address 2<g:message code=""/></label>
            <p>${address2}</p>
           <%-- <input data-bind="text: address2"  type="text" class="span12"/> --%>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Postcode<g:message code=""/></label>
            <p>${postCode}</p>
           <%-- <input data-bind="text: postCode"  type="text" class="span12"/> --%>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Town<g:message code=""/></label>
            <p>${town}</p>
           <%-- <input data-bind="text: town"  type="text" class="span12"/> --%>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Phone number<g:message code=""/></label>
            <p>${phoneNum}</p>
           <%-- <input data-bind="text: phoneNum"  type="text" class="span12"/> --%>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Mobile number<g:message code=""/></label>
            <p>${mobileNum}</p>
           <%-- <input data-bind="text: mobileNum"  type="text" class="span12"/> --%>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Gender<g:message code=""/></label>
            <p>${gender}</p>
           <%-- <input data-bind="text: gender"  type="text" class="span12"/> --%>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Year of birth<g:message code=""/></label>
            <p>${birthDate}</p>
           <%-- <input data-bind="text: birthDate"  type="text" class="span12"/> --%>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>Additional info<g:message code=""/></label>
            <p>${extra}</p>
           <%-- <input data-bind="text: extra"  type="text" class="span12"/> --%>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>modTyp<g:message code=""/></label>
            <p>${modTyp}</p>
           <%-- <input data-bind="text: modTyp"  type="text" class="span12"/> --%>
        </div>
        <div class="span6">
            <label for=""><g:message code=""/>eProt<g:message code=""/></label>
            <p>${eProt}</p>
           <%-- <input data-bind="text: eProt"  type="text" class="span12"/> --%>
        </div>
</div>

        </div>
        <div class="tab-pane" id="sites">
            <g:render template="sitesSurveyed"></g:render>
        </div>
    </div>

            <div class="row-fluid">
                <div class="form-actions span12">
                    <button type="button" id="cancel" class="btn">Cancel</button>
                    <button type="button" id="delete" class="btn btn-danger" data-bind="">Delete person</button> 
                </div>
            </div>
        </bs:form>
        </div>
    </div>

</body>
    <asset:script type="text/javascript">

        new RestoreTab('personDetailsTab', 'personal-tab');

    $('#delete').on("click", function (e) {
    console.log("delete ", ${personId})
    var personId = "${personId}";
        var message = "<span class='label label-important'>Important</span><p><b>This cannot be undone</b></p><p>Are you sure you want to delete this person?</p>";
        bootbox.confirm(message, function (result) {
            if (result) {
                $.ajax({
                    url: fcConfig.deletePersonUrl + '/' + personId,
                    type: 'DELETE',
                    success: function (data) {
                        console.log(data);
                        alert("Successfully deleted. Indexing is in process, search result will be updated in few minutes. Redirecting to search page...", "alert-success");
                        window.location.href = fcConfig.returnToProjectUrl + '/' + "dab767a5-929e-4733-b8eb-c9113194201f"
                    },
                    error: function () {
                        console.log(data);

                        alert("Error deleting person")
                        document.location.href = fcConfig.returnToProjectUrl + '/' + "dab767a5-929e-4733-b8eb-c9113194201f";
                    }
                });
            }
        });
    });

    $('#cancel').on("click", function (){
        console.log("go to project")
        document.location.href = fcConfig.returnToProjectUrl + '/' + "dab767a5-929e-4733-b8eb-c9113194201f";

    })
    </asset:script>
</html>
