<%@ page import="grails.converters.JSON; org.grails.web.json.JSONArray" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta name="layout" content="${hubConfig.skin}"/>
  <%-- <title> ${create ? 'New' : ('Edit | ' + site?.name?.encodeAsHTML())} | Users </title>
    <g:if test="${project}">
        <meta name="breadcrumb" content="Create new user for ${project?.name?.encodeAsHTML()}"/>
    </g:if>
    <g:elseif test="${create}">
        <meta name="breadcrumb" content="Create"/>
    </g:elseif>
    <g:else>
        <meta name="breadcrumbParent3"
              content="${createLink(controller: 'site', action: 'index')}/${site?.siteId},${site?.name?.encodeAsHTML()}"/>
        <meta name="breadcrumb" content="Edit"/>
    </g:else> --%>

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
        ajaxCreateUrl: "${createLink(action: 'ajaxCreate')}"
        }
        here = window.location.href;

    </asset:script>

    <asset:javascript src="common.js"/>
</head>
<body>
    <%-- <div class="container-fluid validationEngineContainer" id="validation-container"> --%>
    <div class="container-fluid validationEngineContainer">
        <bs:form action="update" inline="true">
            
            <g:render template="userDetails" model="${[showLine: true]}"/>

            <div class="row-fluid">
                <div class="form-actions span12">
                    <button type="button" id="save" class="btn btn-primary">Save changes</button>
                    <button type="button" id="cancel" class="btn">Cancel</button>
                </div>
            </div>
        </bs:form>
    </div>
    <%-- <g:if env="development">
    <div class="container-fluid">
        <div class="expandable-debug">
            <hr />
            <h3>Debug</h3>
            <div>
                <h4>KO model</h4>
                <pre data-bind="text:ko.toJSON($root,null,2)"></pre>
                <h4>Activities</h4>
                <pre>${site?.activities?.encodeAsHTML()}</pre>
                <h4>Site</h4>
                <pre>${site?.encodeAsHTML()}</pre>
                <h4>Projects</h4>
                <pre>${projects?.encodeAsHTML()}</pre>
                <h4>Features</h4>
                <pre>${mapFeatures}</pre>
            </div>
        </div>
    </div>
    </g:if> --%>

<asset:script type="text/javascript">
    $(function(){

        <%-- $('#validation-container').validationEngine('attach', {scroll: false});

        $('.helphover').popover({animation: true, trigger:'hover'}); --%>

        <%-- var personViewModel = initPersonViewModel(true, ${!userCanEdit}); --%>

        $('#cancel').click(function () {
            <%-- if(siteViewModel.saved()){
                document.location.href = fcConfig.sitePageUrl;
            } if(fcConfig.projectUrl){
                document.location.href = fcConfig.projectUrl;
            }else {
                document.location.href = fcConfig.homePageUrl;
            } --%>
        });

        $('#save').click(function () {
            <%-- if ($('#validation-container').validationEngine('validate')) { --%>
                <%-- var json = personViewModel.toJS(); --%>
                var firstName = document.getElementById("firstName").value,
                lastName = document.getElementById("lastName").value,
                personCode = document.getElementById("personCode").value

<%-- This works to get values from front-end, using test data now  --%>
                <%-- var data = {
firstName: firstName, lastName: lastName, personCode: personCode, projects: ["e0a99b52-c9fb-4b81-ae39-4436d11050c6"]
                } --%>
                var data = {
firstName: "Jane", lastName: "Doe", personCode: "shadjh", projects: ["e0a99b52-c9fb-4b81-ae39-4436d11050c6"], personId: "7489237894"
                }

                $.ajax({
                    url: fcConfig.ajaxCreateUrl,
                    type: 'POST',
                    data: JSON.stringify(data),
                    contentType: 'application/json',
                    success: function (data) {
                        if(data.status == 'created'){
                           console.log("person created")
                        }
                        
                    },
                    error: function (data) {
                        var errorMessage = data.responseText || 'There was a problem saving this person'
                        bootbox.alert(errorMessage);
                    }
                });
            <%-- } --%>
        });
    });
</asset:script>

</body>
</html>
