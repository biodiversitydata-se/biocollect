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

    def ajaxList(String id) {
//         if(params.entityType == "projectActivity") {
            def pActivity = projectActivityService.get(id, 'all')
    //    def sites = siteService.getSitesFromIdList(pActivity.sites, BRIEF)
//             if (!pActivity) {
//                 response.sendError(404, "Couldn't find project activity $id")
//                 return
//             }
//             log.info("sites for activity" + pActivity.sites.toString())
//             render pActivity.sites as JSON

//         } else if (params.entityType == "project") {
//             def project = projectService.get(id, "all")
//             if (!project) {
//                 response.sendError(404, "Couldn't find project $id")
//                 return
//             }

//             render project?.sites  as JSON
//         }

    }

    def getPersonsForProjectIdPaginated() {
        String projectId = params.id
        log.debug "Project ID " + projectId
        def adminUserId = userService.getCurrentUserId()

        if (projectId && adminUserId) {
            if (projectService.isUserAdminForProject(adminUserId, projectId) || projectService.isUserCaseManagerForProject(adminUserId, projectId)) {
                def results = personService.getPersonsForProjectPerPage(projectId)
                
                asJson results
                log.debug "results " + results
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