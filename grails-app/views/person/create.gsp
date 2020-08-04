<%@ page import="grails.converters.JSON; org.grails.web.json.JSONArray" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta name="layout" content="${hubConfig.skin}"/>
  <title> ${create ? 'New' : ('Edit | ' + person?.firstName?.encodeAsHTML() + person?.lastName?.encodeAsHTML())} | Users </title>
    <g:if test="${project}">
        <meta name="breadcrumb" content="Create new user for ${project?.name?.encodeAsHTML()}"/>
    </g:if>
    <g:elseif test="${create}">
        <meta name="breadcrumb" content="Create"/>
    </g:elseif>
    <g:else>
        <meta name="breadcrumbParent3"
              content="${createLink(controller: 'site', action: 'index')}/${person?.personId}"/>
        <meta name="breadcrumb" content="Edit"/>
    </g:else>

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
        ajaxCreateUrl: "${createLink(action: 'ajaxCreate')}",
        <%-- createPersonUrl: "${createLink(action: 'create')}", --%>
        deletePersonUrl: "${createLink(action:'delete', id: "teststring")}"
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
        <bs:form action="update" inline="true">
            
            <g:render template="personDetails" model="${[showLine: true]}"/>

            <div class="row-fluid">
                <div class="form-actions span12">
                    <button type="button" id="save" class="btn btn-primary" data-bind="click: save">Save changes</button>
                    <button type="button" id="cancel" class="btn">Cancel</button>
                    <button type="button" id="delete" class="btn btn-danger" data-bind="click: deletePerson">Delete person</button>
                </div>
            </div>
        </bs:form>
        </div>
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
        var personViewModel = new PersonViewModel();
        ko.applyBindings(personViewModel, document.getElementById('person'));
     }); 
</asset:script>

</body>
</html>
