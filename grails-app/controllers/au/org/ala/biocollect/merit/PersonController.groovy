package au.org.ala.biocollect.merit

import au.org.ala.biocollect.merit.hub.HubSettings
import au.org.ala.biocollect.merit.PersonService
import au.org.ala.biocollect.merit.UserService
import au.org.ala.biocollect.merit.ProjectService
import au.org.ala.biocollect.merit.OutputService
import au.org.ala.biocollect.merit.SiteService
import grails.web.servlet.mvc.GrailsParameterMap
import org.apache.http.HttpStatus

import grails.converters.JSON

/**
 * Controller to deal with admin tasks related to managing volunteer data
 */

class PersonController {

    PersonService personService 
    UserService userService
    ProjectService projectService
    ActivityService activityService
    SiteService siteService
    SettingService settingService
    CommonService commonService
    SearchService searchService

    /*
     * Show actions specific to the logged in person 
     * can be set in hub settings
     *
     */
    def home(){
        HubSettings hubConfig = SettingService.hubConfig
        def userName = userService.currentUserDisplayName
        String userId = userService.currentUserId
        Boolean userIsAlaOrFcAdmin = userService.userIsAlaOrFcAdmin()
        def data = personService.getDataForPersonHomepage(userId)
        def view
        if (data.statusCode == 500){
            render view: 'SFThome', model: [
                personStatus: "This user is not linked to a person. Ask the admin to link user ID to person ID"
                ]
        } else {
            if (hubConfig?.defaultFacetQuery.contains('isSft:true')){
                view = 'SFThome'
            } else if (hubConfig?.defaultFacetQuery.contains('isSebms:true')) {
                view = 'SEBMShome'
            } else {
                view = 'home'
            }
            render view: view, model: [
                personStatus: data?.personStatus,
                userName: userName,
                userIsAlaOrFcAdmin: userIsAlaOrFcAdmin, 
                person: data?.person,
                sites: data?.sites, 
                siteStatus: data?.siteStatus, 
                projects: data?.projects,
                surveys: data?.surveys,
                drafts: data?.drafts
                ]
        }
    }

    /*
     * View for admin - show person and the outputs they contributed
     * 
     * @param id - the person to view
     * @return result - personal details
     */
    def index(String id) {
        def person = personService.get(id)
        render view: 'index', model: [person: person?.person, activityCount: person?.activityCount]
    }
    
    @PreAuthorise(accessLevel = 'admin', projectIdParam = "projectId")
    def create(){
        def userIsAlaOrFcAdmin = userService.userIsAlaOrFcAdmin()
        render view: 'edit', model: [create:true, relatedProjectIds: params?.relatedProjectIds, userIsAlaOrFcAdmin: userIsAlaOrFcAdmin]  
    }

    // TODO - what access level should dictate this? 
    def edit(String id) {
        def person = personService.get(id)
        def userIsAlaOrFcAdmin = userService.userIsAlaOrFcAdmin()
        // TODO - check if person is owner of profile (now anyone with a link could change it)
        String userId = userService.currentUserId
        Boolean userIsOwnerOfProfile = (person?.person?.userId == userId) ?: false
        if (userIsAlaOrFcAdmin || userIsOwnerOfProfile) {
            Map model = [
                create:false, 
                person: person?.person, 
                activityCount: person?.activityCount, 
                returnTo: params?.returnTo, 
                defaultTab: params?.defaultTab, 
                requestedSitesList: params?.requestedSitesList,
                userIsAlaOrFcAdmin: userIsAlaOrFcAdmin
            ]
            render view: 'edit', model: model
        } else {
            flash.message = "Error: access denied: User does not have <b>editor</b> permission to edit this person's profile."
            response.status = 401
            result = [status:401, error: flash.message]
        }
    }

    // TODO - what access level should dictate this? 
    def update(String id){
        def values = request.JSON
        // TODO check if user is admin
        def resp = personService.update(id, values)  
        if (resp.error) {
            resp.status = 500
        } else {
            render resp as JSON
        }
    }

    def linkUserToPerson(){
        def values = request.JSON
        def resp = personService.linkUserToPerson(values)  
        if (resp.error) {
            resp.status = 500
        } else {
            render resp as JSON
        }
    }

    @PreAuthorise(accessLevel = 'admin', projectIdParam = "projectId")
    def save() {
        def values = request.JSON
        Map result = personService.create(values)
        log.debug "result of person service call " + result

        if (result.error) {
            response.status = 500
        } else {
            render result as JSON
        }
    }

    /*
     * Admin only - search for person by email and name 
     * 
     * @param params - contains search term which can be a mix of name and/ or email address
     * @return result - a list of persons who match the search criteria
     */
    def searchPerson(){
        def searchTerm = params.searchTerm
        def result = personService.searchPerson(searchTerm)
        render result as JSON
    }


    @PreAuthorise(accessLevel = 'admin', projectIdParam = "projectId")
    def delete(String id) {
        def resp = personService.delete(id)
    }

    def removeBooking(){
        def values = request.JSON
        def resultSites = siteService.update(values.siteId, [bookedBy: ""])
        def resultPerson = personService.update(values?.personId, [bookedSites: values?.bookedSites])
        if (resultSites.error || resultPerson.error){
            log.debug "error"
        } else {
            [status: 200] as JSON
        }
    }

    def asJson(json) {
        render(contentType: 'application/json', text: json as JSON)
    }
    
    /**
     * This function does an elastic search for persons. All elastic search parameters are supported like fq, max etc.
     * used in project's Admin tab
     * @return
     */
    @PreAuthorise(accessLevel = 'admin', projectIdParam = "projectId")
    def elasticsearch() {
        log.debug "elasticsearch params " + params
        log.debug "request " + request.JSON
        
    try {
        List query = ['className:au.org.ala.ecodata.Person']
        String userId = userService.getCurrentUserId()
        GrailsParameterMap queryParams = commonService.constructDefaultSearchParams(params, request, userId)

        if (queryParams.fq && (queryParams.fq instanceof String)) {
            queryParams.fq = [queryParams.fq]
        } else if (queryParams.fq instanceof String[]) {
            queryParams.fq = queryParams.fq as List
        } else if (!queryParams.fq) {
            queryParams.fq = []
        }

        queryParams.remove('hub')
        queryParams.remove('hubFq')
        Map searchResult = searchService.searchForSites(queryParams)
        List persons = searchResult?.hits?.hits
        log.debug "persons " + persons

        persons = persons?.collect {
            Map doc = it._source
            [
                name : doc?.firstName + " " + doc?.lastName,
                town: doc?.town,
                mobileNum: doc?.mobileNum,
                email : doc?.email,
                internalPersonId : doc?.internalPersonId,
                personId : doc?.personId 
            ]
        }

            render([persons: persons, total: searchResult.hits?.total ?: 0] as JSON)
        } catch (SocketTimeoutException sTimeout) {
            render(text: sTimeout.message, status: HttpStatus.SC_REQUEST_TIMEOUT);
        } catch (Exception e) {
            render(text: e.message, status: HttpStatus.SC_INTERNAL_SERVER_ERROR);
        }
    }
}