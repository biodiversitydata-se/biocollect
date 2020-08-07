<%@ page import="grails.converters.JSON; org.grails.web.json.JSONArray" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta name="layout" content="${hubConfig.skin}"/>
    <title> ${person?.firstName.encodeAsHTML() + ' ' + person?.lastName.encodeAsHTML())}</title>

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
        saveNewPersonUrl: "${createLink(action: 'save')}",
        updatePersonUrl: "${createLink(action: 'update')}",
        deletePersonUrl: "${createLink(action:'delete')}",
        returnToUrl: "${createLink(controller: 'project', action:'index')}"
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
         <g:link action="edit" id="${person.personId}" class="btn btn-small"><i
                    class="icon-edit"></i> Edit person</g:link>
        <bs:form action="update" inline="true">
            
            <g:render template="personDefinition"/>

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

<asset:script type="text/javascript">

    function initPersonViewModel() {
        var savedPersonDetails = {
            personId: "${person?.personId}",
            firstName: "${person?.firstName}",
            lastName:  "${person?.lastName}",
            email:"${person?.email}",
            address1: "${person?.address1}",
            address2: "${person?.address2}",
            postCode: "${person?.postCode}",
            town: "${person?.town}",
            phoneNum: "${person?.phoneNum}",
            mobileNum: "${person?.mobileNum}",
            gender: "${person?.gender}",
            birthDate: "${person?.birthDate}",
            extra: "${person?.extra}",
            modTyp: "${person?.modTyp}",
            eProt: "${person?.eProt}",
            projects: ${person?.projects ?: '[]'}
        }
        console.log(savedPersonDetails);

        var personViewModel = new PersonViewModel(savedPersonDetails, ${create}, "${projectId}");
        return personViewModel;
    }
    $(function(){
        var personViewModel = initPersonViewModel();
        ko.applyBindings(personViewModel, document.getElementById('person'));
     }); 

</asset:script>

</body>
</html>
