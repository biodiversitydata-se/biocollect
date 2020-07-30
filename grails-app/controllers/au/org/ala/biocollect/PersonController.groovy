package au.org.ala.biocollect

import au.org.ala.biocollect.merit.PreAuthorise
import au.org.ala.biocollect.merit.UserService
import au.org.ala.biocollect.PersonService
import grails.converters.JSON
import org.apache.http.HttpStatus

class PersonController {

    UserService userService
    PersonService personService

    def ajaxCreate(String id) {
        log.debug "ajax update person"

        def values = request.JSON
        log.debug "values: " + (values as JSON).toString()

        Map result = personService.create(values)
        log.debug "result" + result

        if (result.error) {
            response.status = 500
        } else {
            log.debug "no result.error"
            render result as JSON
        }
    }

    def create() {
        render view: 'create', model: [create:true]

    }
    def list() {
        render view: 'create', model: [create:true]

    }

    // def edit(String id) {
    // }

    // def delete(String id) {
    // }

    // def listSites(){

    // }


    // Throw-away
    // def create() {
    //     respond new Person(params)
    // }

    // def save(Person person) {
    //     if (person == null) {
    //         notFound()
    //         return
    //     }

    //     try {
    //         personService.save(person)
    //     } catch (ValidationException e) {
    //         respond person.errors, view:'create'
    //         return
    //     }

    //     request.withFormat {
    //         form multipartForm {
    //             flash.message = message(code: 'default.created.message', args: [message(code: 'person.label', default: 'Person'), person.id])
    //             redirect person
    //         }
    //         '*' { respond person, [status: CREATED] }
    //     }
    // } 
}