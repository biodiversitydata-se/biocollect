package au.org.ala.biocollect

class PersonService {

    def webService, grailsApplication
    PersonService PersonService

    def create(body){
        log.debug "person service"
        webService.doPost(grailsApplication.config.ecodata.baseURL + '/person/', body)
    }

    def getPersonsForProjectPerPage(String projectId){
        log.debug "getPersonsForProjectPerPage"
        def url = grailsApplication.config.ecodata.baseURL + "/person/get/${projectId}"
        webService.getJson(url)
    }
}