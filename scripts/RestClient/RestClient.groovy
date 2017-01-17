// Groovy Rest Client.
// > export PATH=$PATH:/Users/sat01a/All/j2ee/groovy-2.4.7/bin
// > cd /Users/sat01a/All/sat01a_git/merged/biocollect-3/scripts/RestClient
// > groovy RestClient.groovy
// To get the example post data, enable debugger at this.save and print the variable or right click and store as global variable.
// variable json string data will be printed in the console
// Use http://jsonformatter.org/ to format the data. (make sure to remove the " " around the string...)
// User must have a auth token [ ozatlasproxy.ala.org.au]

@Grapes([
        @Grab('org.apache.poi:poi:3.10.1'),
        @Grab(group = 'commons-codec', module = 'commons-codec', version = '1.9'),
        @Grab('org.apache.poi:poi-ooxml:3.10.1')]
)
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import static org.apache.poi.ss.usermodel.Cell.*
import java.nio.file.Paths
import static java.util.UUID.randomUUID

// Import Configuration
def PROJECT_ID = "0d37298f-f7a0-40e3-9a5c-5ff0b1caaeff"
def PROJECT_ACTIVITY_ID = "9bf45b75-d7c6-4607-8c65-847fb0eb56bb"
def USERNAME = "reece.pedler@sa.gov.au" // "ecologicaldirections@live.com.au"
def AUTH_KEY = ""

def SERVER_URL = "https://biocollect.ala.org.au"
def SPECIES_URL = "/search/searchSpecies/${PROJECT_ACTIVITY_ID}?limit=1&hub=ecoscience"
def ADD_NEW_ACTIVITY_URL = "/ws/bioactivity/save?pActivityId=${PROJECT_ACTIVITY_ID}&hub=ecoscience"

def header = []
def values = []
def xlsx = "2ha/2ha_first_batch.xlsx"

println("Reading ${xlsx} file")
Paths.get(xlsx).withInputStream { input ->
    def workbook = new XSSFWorkbook(input)
    def sheet = workbook.getSheetAt(0)

    for (cell in sheet.getRow(0).cellIterator()) {
        header << cell.stringCellValue
    }

    def headerFlag = true

    for (row in sheet.rowIterator()) {
        if (headerFlag) {
            headerFlag = false
            continue
        }
        def rowData = [:]
        for (cell in row.cellIterator()) {
            def value = ''

            switch (cell.cellType) {
                case CELL_TYPE_STRING:
                    value = cell.stringCellValue
                    break
                case CELL_TYPE_NUMERIC:
                    if (org.apache.poi.hssf.usermodel.HSSFDateUtil.isCellDateFormatted(cell)) {
                        value = cell.getDateCellValue()
                    } else {
                        value = cell.numericCellValue as String
                    }

                    break
                case CELL_TYPE_BLANK:
                    value = ""
                case CELL_TYPE_BOOLEAN:
                    value = cell.booleanCellValue
                    break
                default:
                    println("Error: Cell type not supported..")
                    value = ''
            }

            rowData << [("${header[cell.columnIndex]}".toString()): value]
        }
        rowData << ["uniqueId": randomUUID() as String]
        values << rowData
    }

    println("Successfully loaded ${xlsx} file");
    // Group same elements in to an array.
    def nestedActivities = []
    def processedIds = []

    println("Combining records");
    values?.each { entry ->
        def alreadyProcessed = processedIds.findAll { entry."uniqueId" == it }
        if (!alreadyProcessed) {
            def combinedRecords = values?.findAll {
                it."observer_name" == entry."observer_name" &&
                        it."survey_date" == entry."survey_date" &&
                        it."plot_id" == entry."plot_id" &&
                        it."survey_start_time" == entry."survey_start_time"
            }

            combinedRecords?.each {
                processedIds << it."uniqueId"
            }
            nestedActivities << combinedRecords
        }
    }

    println("Records nested under activities");
    println("Total activities = ${nestedActivities?.size()}")

    // Load default activity template file
    String jsonStr = new File('2ha/2ha_post_template_prod.json').text

    // Loop through the activities
    nestedActivities?.eachWithIndex { activityRow, activityIndex ->

         if (activityIndex == 0) {

            def jsonSlurper = new groovy.json.JsonSlurper()
            def activity = jsonSlurper.parseText(jsonStr)
            println("Building activity: ${activityIndex}")

            activity.projectId = PROJECT_ID
            activityRow?.eachWithIndex { record, idx ->
                TimeZone tz = TimeZone.getTimeZone("UTC");
                java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'"); // Quoted "Z" to indicate UTC, no timezone offset
                df.setTimeZone(tz);
                String isoDate = df.format(record."surveyDate");

                java.text.DateFormat time = new java.text.SimpleDateFormat("hh:mm a");
                String isoDateTime = time.format(record."surveyStartTime")
                String isoDateFinishTime = time.format(record."surveyFinishTime")

                // Map generic fields
                if (idx == 0) {
                    activity.outputs[0].data.recordedBy = (record."recordedBy")?.trim()
                    activity.outputs[0].data.collectedBy = (record."collectedBy")?.trim()
                    activity.outputs[0].data.surveyDate = isoDate
                    activity.outputs[0].data.plotId = (record."plotId")?.trim()
                    activity.outputs[0].data.surveyStartTime = isoDateTime
                    activity.outputs[0].data.surveyFinishTime = isoDateFinishTime
                    activity.outputs[0].data.sampleType = (record."sampleType") && (record."sampleType")?.trim() == 'Targeted' ? "Targeted (for particular species)" :  (record."sampleType")
                    activity.outputs[0].data.sampleSequence = (record."sampleSequence")?.trim()
                    activity.outputs[0].data.eventRemarks = (record."eventRemarks")?.trim()
                    activity.outputs[0].data.zone = (record."zone")?.trim()
                    activity.outputs[0].data.easting = (record."easting") ?: ''
                    activity.outputs[0].data.northing = (record."northing") ?: ''
                    activity.outputs[0].data.relativeLocation = (record."relativeLocation") ?: ''
                    activity.outputs[0].data.distanceFromWater = (record."distanceFromWater") ?: ''
                    activity.outputs[0].data.distanceFromRoad = (record."distanceFromRoad") ?: ''
                    activity.outputs[0].data.habitatType = record."habitatType"
                    activity.outputs[0].data.habitatTypeOther = (record."habitatTypeOther") ?: ''
                    activity.outputs[0].data.ephemeralVegPresent = (record."ephemeralVegPresent") ?: ''
                    activity.outputs[0].data.timeSinceWeatherEvent = (record."timeSinceWeatherEvent") ?: ''
                    activity.outputs[0].data.timeSinceFire = (record."timeSinceFire") ?: ''
                    activity.outputs[0].data.visibility = (record."visibility") ?: ''
                    activity.outputs[0].data.shadowLength = (record."shadowLength") ?: ''
                    activity.outputs[0].data.trackingSurface = (record."trackingSurface") ?: ''
                    activity.outputs[0].data.trackingSurfaceSuitability = (record."trackingSurfaceSuitability") ?: ''
                    activity.outputs[0].data.trackingSurfaceContinuity = (record."trackingSurfaceContinuity") ?: ''
                    activity.outputs[0].data.locationLatitude = (record."locationLatitude")
                    activity.outputs[0].data.locationLongitude = (record."locationLongitude")
                    activity.outputs[0].data.locationSitesArray = [] // For polygon


                    activity.outputs[0].data.trackingSurfaceSuitabilityTable = []
                    activity.outputs[0].data.trackingSurfaceSuitabilityTable << [trackingSurfaceSuitabilityCategory:"Category 1 - could distinguish tracks of category 2 & 3 animals, plus hopping mice, rodents, small birds, insects etc",
                                                                                 percentOfPlotSuitable: record."percentOfPlotSuitable_1"]
                    activity.outputs[0].data.trackingSurfaceSuitabilityTable << [trackingSurfaceSuitabilityCategory:"Category 2 - could distinguish tracks of category 3 animals, plus fox, cat, rabbit, echidna, goannas",
                                                                                 percentOfPlotSuitable: record."percentOfPlotSuitable_2"]
                    activity.outputs[0].data.trackingSurfaceSuitabilityTable << [trackingSurfaceSuitabilityCategory:"Category 3 - could distinguish tracks of camel, dingo, human, emu or kangaroo",
                                                                                 percentOfPlotSuitable: record."percentOfPlotSuitable_3"]
                    activity.outputs[0].data.trackingSurfaceSuitabilityTable << [trackingSurfaceSuitabilityCategory:"Category 4 - no tracks of any animals could be distinguished",
                                                                                 percentOfPlotSuitable: record."percentOfPlotSuitable_4"]

                    //TODO; check percentCover
                    activity.outputs[0].data.vegTypeTableOverstorey = []
                    activity.outputs[0].data.vegTypeTableOverstorey << [vegTypeOverstorey: "Main vegetation overstorey", vegDescriptionOverstorey: record."vegDescriptionOverstorey", percentCover: record."per_cover"]
                    activity.outputs[0].data.vegTypeTableUnderstorey = []
                    activity.outputs[0].data.vegTypeTableUnderstorey << [vegTypeUnderstorey: "Main vegetation understorey", vegDescriptionUnderstorey: record."vegDescriptionUnderstorey", percentCover: record."undestorey_per_cover"]

                    // Map species multi rows
                    activity.outputs[0].data.sightingEvidenceTable = []
                }

                // Get Unique Species Id
                def uniqueIdResponse = new URL(SERVER_URL + "/ws/species/uniqueId")?.text
                def jsonResponse = new groovy.json.JsonSlurper()
                def outputSpeciesId = jsonResponse.parseText(uniqueIdResponse)?.outputSpeciesId

                // Get species name
                def species = [name: '', guid: '', scientificName: '', commonName: '', outputSpeciesId: outputSpeciesId]
                def rows = []
                def speciesResponse = new URL(SERVER_URL + SPECIES_URL + "&q=${record.'species_name'}").text
                def speciesJSON = new groovy.json.JsonSlurper()
                def autoCompleteList = speciesJSON.parseText(speciesResponse)?.autoCompleteList

                if (!autoCompleteList) {
                    species.name = record.'species'
                }

                autoCompleteList?.eachWithIndex { item, index ->
                    if (index == 0) {
                        species.name = item.name
                        species.guid = item.guid
                        species.scientificName = item.scientificName
                        species.commonName = item.commonName
                    }
                }

                rows << [species         : species,
                         tracksOnPlot    : record.'tracksOnPlot',
                         tracksAdjacent  : record.'tracksAdjacent',
                         animalObserved  : record.'animalObserved',
                         diggingsObserved: record.'diggingsObserved',
                         scatsObserved   : record.'scatsObserved',
                         abundanceClass  : record.'abundanceClass',
                         evidenceAgeClass: record.'evidenceAgeClass',
                         comments        : record.'comments']

                rows?.each { row ->
                    activity.outputs[0].data.sightingEvidenceTable << row
                }

                // post data via web service.
            }

            def connection = new URL("${SERVER_URL}${ADD_NEW_ACTIVITY_URL}").openConnection() as HttpURLConnection

            // set some headers
            connection.setRequestProperty( 'userName', "${USERNAME}" )
            connection.setRequestProperty( 'authKey', "${AUTH_KEY}" )
            connection.setRequestProperty( 'Content-Type', 'application/json;charset=utf-8' )
            connection.setRequestMethod("POST")
            connection.setDoOutput(true)

            //java.io.OutputStreamWriter wr = new java.io.OutputStreamWriter(connection.getOutputStream(), 'utf-8')
            //wr.write(new groovy.json.JsonBuilder( activity ).toString())
            //wr.flush()
            //wr.close()

            // get the response code - automatically sends the request
            // println connection.responseCode + ": " + connection.inputStream.text

             println(new groovy.json.JsonBuilder( activity ).toString())
         }
    }

    println("Completed..")
}
