package au.org.ala.biocollect.merit

import au.org.ala.biocollect.merit.PersonService
import au.org.ala.biocollect.merit.UserService
import au.org.ala.biocollect.merit.ProjectService
import au.org.ala.biocollect.merit.OutputService

import grails.converters.JSON

class PersonController {

    PersonService personService 
    UserService userService
    ProjectService projectService
    OutputService outputService

    def index(String id) {
        def person = personService.get(id)
        def outputs = outputService.getOutputCountForPerson(id)
        log.debug "outputs" + outputs
        
        def result = [person: person,
            outputs: outputs]

        if (params.format == 'json')
            render result as JSON
        else
            result
    }
    
    def create(){
        log.debug "params.id is project id? " + params.id
        render view: 'edit', model:[create:true, projectId: params.id]  
    }
    
    def edit(String id) {
        log.debug "params.id" + params.id
        def person = personService.get(id)
        render view: 'edit', model:[create:false, person: person]
    }

    // @PreAuthorise(accessLevel = 'admin')
    def update(String id){
        log.debug "updating person ${id}"
        def values = request.JSON
        // TODO check if user is admin
        log.debug "values to send: " + values
        def resp = personService.update(id, values)  
        if (resp.error) {
            resp.status = 500
        } else {
            render resp
        }
    }

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
    def delete(String id) {
        def resp = personService.delete(id)
    }

    def linkUserToPerson(String id){
        String userId = params.userId
        String personId = params.personId
        Map values = [userId : userId, personId: personId]
        log.debug "values: " + values
        log.debug "assigning user id to person " + personId
        if (personId) {
            render personService.linkUserToPerson(personId, values)
        } else {
            render status:400, text: 'Required param not provided: person ID'
        }

    }

    def asJson(json) {
        render(contentType: 'application/json', text: json as JSON)
    }

}