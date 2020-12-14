<%@ page import="grails.converters.JSON; org.grails.web.json.JSONArray" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta name="layout" content="${hubConfig.skin}"/>
    <title> ${create ? 'New' : ('Edit | ' + person?.firstName + ' ' + person?.lastName)}</title>
    <meta name="breadcrumbParent1" content="${createLink(controller: 'project', action: 'homePage')},${message(code: "g.home")}"/>

    <asset:script type="text/javascript">
    var fcConfig = {
        homePageUrl : "${createLink(controller: 'home', action: 'index')}",
        personSaveUrl: "${createLink(action: 'save', params:[projectId: params?.projectId])}",
        personUpdateUrl: "${createLink(action: 'update')}",
        deletePersonUrl: "${createLink(action:'delete', params:[projectId: params?.projectId])}",
        bookSiteUrl: "${createLink(controller: 'site', action:'bookSites')}",
        removeBookingUrl: "${createLink(controller: 'person', action:'removeBooking')}",
        viewSiteUrl: "${createLink(controller: 'site', action:'index')}",
        viewActivityUrl: "${createLink(controller: 'bioActivity', action: 'index')}",
        getSiteNamesUrl: "${createLink(controller: 'site', action:'getSiteNames', params: [siteIds: person?.bookedSites])}",
        getActivitiesForPersonByTypeUrl: "${createLink(controller: 'activity', action:'getActivitiesForPersonByType')}",
        returnToProjectUrl: "${createLink(controller: 'project', action:'index', params:[id: params?.projectId])}"
        };
        here = window.location.href;
    </asset:script>

    <asset:javascript src="common.js"/>
    <asset:javascript src="persons.js"/>
    <asset:javascript src="datatables-manifest.js"/>

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

    if ("${defaultTab}" == 'surveys'){
        $('#surveys-tab').tab('show');
    } else if ("${defaultTab}" == 'sites'){
        $('#booking-tab').tab('show');
    } else {
        $('#personal-tab').tab('show');
    }
    $('#personal-details-form').validationEngine();

    function initPersonViewModel() {
        var savedPersonDetails = {
            personId: "${person?.personId}",
            internalPersonId: "${person?.internalPersonId}",
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
            projects: ${person?.projects ?: []},
            bookedSites: ${person?.bookedSites ?: []},
            sitesToBook: ["${siteName}"]
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
