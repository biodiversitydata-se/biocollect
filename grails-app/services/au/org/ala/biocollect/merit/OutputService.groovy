package au.org.ala.biocollect.merit

class OutputService {

    def webService, grailsApplication
    DocumentService documentService

    def list() {
        def resp = webService.getJson(grailsApplication.config.ecodata.service.url + '/output/')
        resp.list
    }

    def get(id) {
        def record = webService.getJson(grailsApplication.config.ecodata.service.url + '/output/' + id)
        record
    }

    def update(id, body) {
        webService.doPost(grailsApplication.config.ecodata.service.url + '/output/' + id, body)
    }

    def delete(id) {
        webService.doDelete(grailsApplication.config.ecodata.service.url + '/output/' + id)
    }

    List getOutputForActivity(String activityId){
        webService.getJson(grailsApplication.config.ecodata.service.url + "/output?activityId=${activityId}")
    }

    /**
     * Get Output Species Identifier
     *
     * @return output species identifier.
     */
    def getOutputSpeciesId() {
        webService.getJson(grailsApplication.config.ecodata.service.url + "/output/getOutputSpeciesUUID")
    }

    def getOutputCountForPerson(id){
        webService.getJson(grailsApplication.config.ecodata.service.url + "/output/countAllForPerson/" + id)
    }

    def getOutputForPersonBySurveyName(id, params){
        def surveyName = java.net.URLEncoder.encode(params.name, "UTF-8")

        def urlParams = '?'
        urlParams += "surveyName=${surveyName}"
        def url = grailsApplication.config.ecodata.service.url + "/output/getAllForPersonBySurveyName/" + id + urlParams
        log.debug "url with survey name and person id " + url
        webService.getJson(url)
    }
}