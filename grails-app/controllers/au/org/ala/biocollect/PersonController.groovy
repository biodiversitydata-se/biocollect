package au.org.ala.biocollect

import au.org.ala.biocollect.PersonService
import au.org.ala.biocollect.merit.UserService
import au.org.ala.biocollect.merit.ProjectService

import grails.converters.JSON

class PersonController {

    PersonService personService 
    UserService userService
    ProjectService projectService

    def create() {
        render view: 'create', model: [create:true]
    }

    def ajaxCreate() {

        def values = request.JSON
        Map result = personService.create(values)
        log.debug "result of person service call " + result

        if (result.error) {
            response.status = 500
        } else {
            render result as JSON
        }
    }

    def getPersonsForProjectIdPaginated() {
        String projectId = params.id
        log.debug "Project ID " + projectId
        def adminUserId = userService.getCurrentUserId()

        if (projectId && adminUserId) {
            if (projectService.isUserAdminForProject(adminUserId, projectId) || projectService.isUserCaseManagerForProject(adminUserId, projectId)) {
                def results = personService.getPersonsForProjectPerPage(projectId)
                
                asJson results
            } else {
                response.sendError(SC_FORBIDDEN, 'Permission denied')
            }
        } else if (adminUserId) {
            response.sendError(SC_BAD_REQUEST, 'Required params not provided: id')
        } else if (projectId) {
            response.sendError(SC_FORBIDDEN, 'User not logged-in or does not have permission')
        } else {
            response.sendError(SC_INTERNAL_SERVER_ERROR, 'Unexpected error')
        }
    }

    // @PreAuthorise(accessLevel = 'admin')
    def update(String id){
        log.debug "updating person ${id}"
        
        // check if user is admin


        def resp = personService.update(id, params)    
    }


    // @PreAuthorise(accessLevel = 'admin')
    def delete(String id) {
        def resp = personService.delete(id)
        // if(resp == HttpStatus.SC_OK){
        //     flash.message = 'Successfully deleted'
        //     render status:resp, text: flash.message
        // } else {
        //     response.status = resp
        //     flash.errorMessage = 'Error deleting the person, please try again later.'
        //     render status:resp, error: flash.errorMessage
        // }
    }

    def list() {
        log.debug "list in person service"
    }

    def asJson(json) {
        render(contentType: 'application/json', text: json as JSON)
    }
    // def edit(String id) {
    // }

    // def delete(String id) {
    // }

    // def listSites(){

    // }

}