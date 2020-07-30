package au.org.ala.biocollect

class PersonService {

    def webService, grailsApplication
    PersonService PersonService

    def create(body){
        webService.doPost(grailsApplication.config.ecodata.baseURL + '/person/', body)
    }

}