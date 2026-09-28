package au.org.ala.biocollect.merit

import au.org.ala.biocollect.merit.ActivityService
// import grails.test.mixin.TestFor // remove for grails 5
import grails.testing.services.ServiceUnitTest
import spock.lang.Specification

/**
 * Tests for the ActivityService
 */
/* @TestFor(ActivityService) // remove for grails 5
public class ActivityServiceSpec extends Specification {*/
class ActivityServiceSpec extends Specification implements ServiceUnitTest<ActivityService> {
    def "progress can be compared correctly"() {

        expect:
        ['started', 'finished', 'planned'].max(service.PROGRESS_COMPARATOR) == 'finished'
        ['started', 'finished', 'planned'].min(service.PROGRESS_COMPARATOR) == 'planned'

    }
}
