package au.org.ala.biocollect.merit

class PersonService {

    def webService, grailsApplication
    PersonService personService

    def create(body){
        def result = webService.doPost(grailsApplication.config.ecodata.service.url + '/person/', body) 
        result
    }

    def get(String id){
        def result = webService.getJson(grailsApplication.config.ecodata.service.url + '/person/get/' + id)
    }

    def update(String id, Map body){
        def result = webService.doPost(grailsApplication.config.ecodata.service.url + "/person/update/${id}", body)
        result
    }

    def delete(String personId){
        def response = webService.doDelete(grailsApplication.config.ecodata.service.url + '/person/' + personId)
        // emailService.sendEmail(subject, emailBody, ["${grailsApplication.config.biocollect.support.email.address}"])
        response
    }

    def linkUserToPerson(Map body){
        def result = webService.doPost(grailsApplication.config.ecodata.service.url + "/person/linkUserToPerson/", body) 
        result
    }

    def searchPerson(String searchTerm){
        searchTerm = java.net.URLEncoder.encode(searchTerm, "UTF-8")
        def url = grailsApplication.config.ecodata.service.url + "/person/searchPerson/?search=" + searchTerm
        webService.getJson(url)
    }

    def getDataForPersonHomepage(String id){
        def url = grailsApplication.config.ecodata.service.url + "/person/getDataForPersonHomepage/${id}"
        webService.getJson(url)
    }
}