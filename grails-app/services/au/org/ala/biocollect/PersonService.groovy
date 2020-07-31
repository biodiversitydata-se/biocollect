package au.org.ala.biocollect

class PersonService {

    def webService, grailsApplication
    PersonService PersonService

    def create(body){
        webService.doPost(grailsApplication.config.ecodata.baseURL + '/person/', body)
    }

    def getPersonsForProjectPerPage(String projectId){
        def url = grailsApplication.config.ecodata.baseURL + "/person/get/${projectId}"
        def result = webService.getJson(url)
        return result
    }
}