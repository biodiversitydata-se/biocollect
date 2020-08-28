<%@ page import="grails.converters.JSON; org.grails.web.json.JSONArray" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta name="layout" content="${hubConfig.skin}"/>
    <title> ${create ? 'New' : ('Edit | ' + person?.firstName + ' ' + person?.lastName)}</title>
    <meta name="breadcrumbParent1" content="${createLink(controller: 'project', action: 'homePage')},Home"/>
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
        personUpdateUrl: "${createLink(action: 'update')}",
        deletePersonUrl: "${createLink(action:'delete')}",
        bookSiteForPersonUrl: "${createLink(controller: 'site', action:'bookSites')}",
        returnToProjectUrl: "${createLink(controller: 'project', action:'index', params:[id: params.projectId])}"
        };
        here = window.location.href;

    </asset:script>

    <asset:javascript src="common.js"/>
    <asset:javascript src="persons.js"/>

</head>
<body>
    <div id="personDefinition" class="container-fluid validationEngineContainer">
        <div id="person">
        <bs:form action="" inline="true">
            <g:render template="personDefinition"/>
        </bs:form>
        </div>
    </div>

<asset:script type="text/javascript">

    $('#personal-details-form').validationEngine();

    function initPersonViewModel() {
        var savedPersonDetails = {
            personId: "${person?.personId}",
            personCode: "${person?.personCode}",
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
            projects: "${person?.projects}",
            bookedSites: ${person?.bookedSites ?: []}
        }

        var personViewModel = new PersonViewModel(savedPersonDetails, ${create}, "${projectId}");
        return personViewModel;
    }
    $(function(){
        var personViewModel = initPersonViewModel();
        ko.applyBindings(personViewModel, document.getElementById('person'));
     }); 

     $("#cancel").click(function (){
         document.location.href = fcConfig.returnToProjectUrl;
     });
    
    $('#goBack').on("click", function (){
        document.location.href = fcConfig.returnToProjectUrl;
    })

</asset:script>

</body>
</html>
