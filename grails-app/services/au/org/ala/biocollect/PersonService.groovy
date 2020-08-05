package au.org.ala.biocollect

class PersonService {

    def webService, grailsApplication
    PersonService personService

    def create(body){
        webService.doPost(grailsApplication.config.ecodata.service.url + '/person/', body) 
    }

    def get(String id){
        webService.getJson(grailsApplication.config.ecodata.service.url + '/person/' + id)
    }

    def update(String id){
        log.debug params
    }

    def getPersonsForProjectPerPage(String projectId){
        def url = grailsApplication.config.ecodata.service.url + "/person/list/${projectId}"
        def result = webService.getJson(url)
        return result
    }

    def delete(String personId){
        log.debug "delete person - serv"
        def response = webService.doDelete(grailsApplication.config.ecodata.service.url + '/person/' + personId)

        // TODO should someone be notified when a person is deleted?
        // String personName = get(id, "brief")?.lastName
        // String subject = "Pesron wtith last name ${personName ?: id} was deleted by ${userService.currentUserDisplayName}"
        // String emailBody = "User ${userService.currentUserId} (${userService.currentUserDisplayName}) has deleted project ${personName ?: id}"
        // emailService.sendEmail(subject, emailBody, ["${grailsApplication.config.biocollect.support.email.address}"])
        response
    }
}