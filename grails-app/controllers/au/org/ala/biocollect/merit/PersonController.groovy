package au.org.ala.biocollect.merit

import au.org.ala.biocollect.merit.hub.HubSettings
import au.org.ala.biocollect.merit.PersonService
import au.org.ala.biocollect.merit.UserService
import au.org.ala.biocollect.merit.ProjectService
import au.org.ala.biocollect.merit.OutputService
import au.org.ala.biocollect.merit.SiteService

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

    /*
     * Show actions specific to the logged in person 
     * can be set in hub settings
     *
     */
    def home(){
        HubSettings hubConfig = SettingService.hubConfig
        def userName = userService.currentUserDisplayName
        String userId = userService.currentUserId
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
                person: data?.person,
                sites: data?.sites, 
                siteStatus: data?.siteStatus, 
                projects: data?.projects,
                surveys: data?.surveys
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
        log.debug "params " + params
        render view: 'edit', model: [create:true, projectId: params.projectId]  
    }

    // TODO - what access level should dictate this? 
    def edit(String id) {
        def person = personService.get(id)
        render view: 'edit', model:[create:false, person: person?.person, activityCount: person?.activityCount, returnTo: params?.returnTo, defaultTab: params?.defaultTab, siteName: params?.siteName]
    }

    // TODO - what access level should dictate this? 
    def update(String id){
        log.debug "updating person ${id}"
        def values = request.JSON
        // TODO check if user is admin
        log.debug "values to send: " + values
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
        log.debug "result" + result                                                                                                                                                                                                                                                                                                                 
        render result as JSON
    }

    // def getPersonsForProjectIdPaginated() {
    //     String projectId = params.id
    //     log.debug "Project ID " + projectId
    //     def adminUserId = userService.getCurrentUserId()

    //     if (projectId && adminUserId) {
    //         if (projectService.isUserAdminForProject(adminUserId, projectId) || projectService.isUserCaseManagerForProject(adminUserId, projectId)) {
    //             def results = personService.getPersonsForProjectPerPage(projectId)
                
    //             asJson results
    //         } else {
    //             response.sendError(SC_FORBIDDEN, 'Permission denied')
    //         }
    //     } else if (adminUserId) {
    //         response.sendError(SC_BAD_REQUEST, 'Required params not provided: id')
    //     } else if (projectId) {
    //         response.sendError(SC_FORBIDDEN, 'User not logged-in or does not have permission')
    //     } else {
    //         response.sendError(SC_INTERNAL_SERVER_ERROR, 'Unexpected error')
    //     }
    // }

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

}