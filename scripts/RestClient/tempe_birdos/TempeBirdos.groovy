// Groovy Rest Client.
// > cd /Users/sat01a/All/sat01a_git/merged/biocollect-3/scripts/RestClient/gonna_watch
// > export PATH=$PATH:/Users/sat01a/All/j2ee/groovy-2.4.11/bin
// > groovy RestClient.groovy
// To get the example post data, enable debugger at this.save and print the variable or right click and store as global variable.
// variable json string data will be printed in the console
// Use http://jsonformatter.org/ to format the data. (make sure to remove the " " around the string...)
// User must have a auth token [ ozatlasproxy.ala.org.au]
// Generating UUID on the device: python -c 'import uuid; print str(uuid.uuid1())'
// https://biocollect.ala.org.au/search/searchSpecies/58df20ef-0f2b-47d5-a632-b1fa84ffe376?limit=10&hub=ala&dataFieldName=species&output=Bird%20Survey%20-%20Western%20Sydney&q=

@Grapes([
        @Grab('org.codehaus.groovy.modules.http-builder:http-builder:0.7'),
        @Grab('org.apache.httpcomponents:httpmime:4.5.1'),
        @Grab('org.apache.poi:poi:3.10.1'),
        @Grab(group = 'commons-codec', module = 'commons-codec', version = '1.9'),
        @Grab('org.apache.poi:poi-ooxml:3.10.1')]
)
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import static org.apache.poi.ss.usermodel.Cell.*
import java.nio.file.Paths
import static java.util.UUID.randomUUID
import groovy.json.JsonSlurper

import groovyx.net.http.HTTPBuilder
import org.apache.http.entity.mime.MultipartEntityBuilder
import org.apache.http.entity.mime.content.FileBody
import groovyx.net.http.Method
import groovyx.net.http.ContentType

// IMPORTANT CONFIGURATION
def DEBUG_AND_VALIDATE = true;
def USERNAME = ""
def AUTH_KEY = ""
def xlsx = "data_october_26.xlsx"

def DATA_TEMPLATE_FILE = "data_template.json"
def SITE_TEMPLATE_FILE = "site_template.json"

def SERVER_URL = "https://biocollect.ala.org.au"
def ADD_NEW_ACTIVITY_URL = "/ws/bioactivity/save?pActivityId="
def IMAGE_UPLOAD_URL = 'https://biocollect.ala.org.au/ws/attachment/upload'
def SITE_CREATION_URL = '/site/ajaxUpdate'
def PROJECT_ACTIVITY_ID = "58df20ef-0f2b-47d5-a632-b1fa84ffe376"
def SPECIES_URL = "/search/searchSpecies/${PROJECT_ACTIVITY_ID}?limit=1&hub=ecoscience"

def header = []
def values = []

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
    def activities = values
    println("Total activities to upload = ${activities?.size()}")

    // Load default activity template file
    println("Loading data_template file")
    String jsonStr = new File(DATA_TEMPLATE_FILE).text

    // Loop through the activities
    activities?.eachWithIndex { activityRow, activityIndex ->

        //if ((activityIndex >= 0 && activityIndex < activities?.size())) { // 183
          if ((activityIndex >= 0 && activityIndex <= 1)) { // 183
            record = activityRow
            def jsonSlurper = new groovy.json.JsonSlurper()
            def activity = jsonSlurper.parseText(jsonStr)

            // Reset sightings photo.
            activity.outputs[0].data.sightingPhoto = []
            activity.projectId = record."BioCollect Project ID"

            println("-----START----")

            //Convert Date to UTC date.
            TimeZone tz = TimeZone.getTimeZone("UTC");
            java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
            // Quoted "Z" to indicate UTC, no timezone offset
            df.setTimeZone(tz);
            java.text.DateFormat time = new java.text.SimpleDateFormat("hh:mm a");
            String isoDate = ""
            String isoStartTime = ""
            String isoEndTime = ""
            try {
                if(record."surveyStartDate") {
                    isoDate = df.format(record."surveyStartDate");
                    record."surveyStartDate" = isoDate
                }
                if(record."surveyFinishDate") {
                    isoDate = df.format(record."surveyFinishDate");
                    record."surveyFinishDate" = isoDate
                }
                if(record."Time") {
                    activity.outputs[0].data.surveyStartTime = df.format(record."Time");
                }
                if(record."End Time") {
                    activity.outputs[0].data.surveyFinishDate = df.format(record."End Time");
                }
            } catch (Exception ex) {
                println("Date format error >>  >> ${ex}")
            }

            // Upload photos to the staging area.
            def sightingPhotos = []
            String address = ""
            for (i = 0; i < 4; i++) {
                switch(i) {
                    case 0:
                        address = record."sightingPhoto";
                        break;
                    case 1:
                        address = record."sightingPhoto1";
                        break;
                    case 2:
                        address = record."sightingPhoto2";
                        break;
                    case 3:
                        address = record."sightingPhoto3";
                        break;
                }

                if (address) {
                    println("Attaching image: ${address}")
                    def decoded = java.net.URLDecoder.decode(address, "UTF-8");
                    def fileNameToken = decoded?.split("&fileName=")
                    String fileName = ""
                    if(fileNameToken?.size() > 0 && fileNameToken[fileNameToken.size() - 1] &&
                            fileNameToken[fileNameToken.size() - 1] != "false") {
                        fileName = fileNameToken[fileNameToken.size() - 1]
                    }

                    if(fileName) {
                        fileName = activityIndex + "_" + i + "_" + fileName.replace(" ", "_")
                        List fileExtensionList = fileName?.tokenize(".")
                        String mimeType = fileExtensionList?.size() > 0 ? fileExtensionList[fileExtensionList.size() - 1] : ""
                        mimeType = mimeType?.toLowerCase()
                        switch (mimeType) {
                            case ".jpg":
                            case "jpg":
                            case ".jpeg":
                            case "jpeg":
                                mimeType = "image/jpeg"
                                break
                            case ".png":
                            case "png":
                                mimeType = "image/png"
                                break
                            default:
                                println("MIME type not supported. - ${fileName} >> " + mimeType)
                        }
                        println("Downloading image file...")
                        println("File name "+ IMAGES_PATH+fileName)
                        if (!DEBUG_AND_VALIDATE) {
                            try{
                                URL url = new URL(address)
                                File newFile = new File(IMAGES_PATH+fileName) << url.openStream()
                                def http = new HTTPBuilder(IMAGE_UPLOAD_URL)
                                println("Uploading image...")


                                http.request(Method.POST, ContentType.BINARY) { req ->
                                    requestContentType: "multipart/form-data"
                                    headers.userName = USERNAME
                                    headers.authKey = AUTH_KEY
                                    MultipartEntityBuilder multipartRequestEntity = new MultipartEntityBuilder()
                                    multipartRequestEntity.addPart('files', new FileBody(newFile, mimeType))
                                    req.entity = multipartRequestEntity.build()

                                    response.success = { resp, data ->
                                        // Convert to map
                                        def documents = data?.getText()
                                        if(documents) {
                                            def documentsMap = new JsonSlurper().parseText(documents)
                                            sightingPhotos << documentsMap?.files?.get(0)
                                            println("Image upload successful. - ${i}")
                                        } else {
                                            println("Image upload unsuccessful. - ${i}")
                                        }
                                    }
                                }
                            } catch(Exception e) {
                                println("Error downloading image" + e)
                            }

                        }
                    }

                } else {
                    println("No image to attach")
                }
            }

            // Load default activity template file
            println("Loading site data template file")
            String siteStr = new File(SITE_TEMPLATE_FILE).text
            def siteJsonSlurper = new groovy.json.JsonSlurper()
            def siteObject = siteJsonSlurper.parseText(siteStr)
            siteObject.pActivityId = record."Survey ID"
            siteObject.site.projects = []
            siteObject.site.projects << record."BioCollect Project ID"
            siteObject.site.extent.geometry.centre = [] // Long and latitudide. (example: long 136.)
            siteObject.site.extent.geometry.centre << record."locationLongitude"
            siteObject.site.extent.geometry.centre << record."locationLatitude"
            siteObject.site.extent.geometry.coordinates = [] // Long and latitudide. (example: long 136.)
            siteObject.site.extent.geometry.coordinates << record."locationLongitude"
            siteObject.site.extent.geometry.coordinates << record."locationLatitude"


            def siteConnection = new URL("${SERVER_URL}${SITE_CREATION_URL}").openConnection() as HttpURLConnection
            siteConnection.setRequestProperty('userName', "${USERNAME}")
            siteConnection.setRequestProperty('authKey', "${AUTH_KEY}")
            siteConnection.setRequestProperty('Content-Type', 'application/json;charset=utf-8')
            siteConnection.setRequestMethod("POST")
            siteConnection.setDoOutput(true)
            def siteId = "";
            if (!DEBUG_AND_VALIDATE) {
                java.io.OutputStreamWriter wr = new java.io.OutputStreamWriter(siteConnection.getOutputStream(), 'utf-8')
                wr.write(new groovy.json.JsonBuilder(siteObject).toString())
                wr.flush()
                wr.close()
                def statusCode = siteConnection.responseCode
                if (statusCode == 200 ){
                    def result = siteConnection.inputStream.text;
                    def site_obj = new JsonSlurper().parseText(result)
                    siteId = site_obj.id
                    println(result);
                } else {
                    def error = siteConnection.getErrorStream().text
                    println(siteConnection.responseCode + " : " + error)
                    def result = new JsonSlurper().parseText(error)
                    if (result.status == "created")
                        siteId = result.id
                }
                println("siteId: ${siteId}");
            }

            // Time

            activity.outputs[0].data.recordedBy = record."recordedBy" instanceof String ? (record."recordedBy")?.trim() : ''
            activity.outputs[0].data.surveyType = record."surveyType" instanceof String ? (record."surveyType")?.trim() : ''
            activity.outputs[0].data.notes = record."notes" instanceof String ? (record."notes")?.trim() : ''
            activity.outputs[0].data.abundanceCode = record."notes" instanceof String ? (record."notes")?.trim() : ''

            activity.outputs[0].data.breedingStatus = record."Breeding" instanceof String ? (record."Breeding")?.trim() : ''
            activity.outputs[0].data.habitatCode = record."Habitat Code" instanceof String ? (record."Habitat Code")?.trim() : ''
            activity.outputs[0].data.sightingComments = record."sightingComments" instanceof String ? (record."sightingComments")?.trim() : ''


            // Site information.
            activity.outputs[0].data.location = siteId
            activity.siteId = siteId

            // Get Unique Species Id
            def uniqueIdResponse = new URL(SERVER_URL + "/ws/species/uniqueId")?.text
            def jsonResponse = new groovy.json.JsonSlurper()
            def outputSpeciesId = jsonResponse.parseText(uniqueIdResponse)?.outputSpeciesId

            // Get species name
            def species = [name: '', guid: '', scientificName: '', commonName: '', outputSpeciesId: outputSpeciesId, listId: "dr7900"]
            def rows = []
            def speciesResponse = new URL(SERVER_URL + SPECIES_URL + "&q=${record.'species'}").text
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
                    species.listId = "dr7900"
                }
            }
            def speciesSightings = []
            def speciesMap = {}
            speciesMap.species = species
            speciesMap.individualCount = record."individualCount" instanceof String ? (record."individualCount")?.trim() : ''
            speciesMap.sightingPhoto = []
            speciesSightings << speciesMap

            for (i = 0; i < sightingPhotos.size(); i++) {
                activity.outputs[0].data.sightingPhoto << sightingPhotos.get(i)
            }

            // Do data validation.
            if (!DEBUG_AND_VALIDATE) {
                println(new groovy.json.JsonBuilder( activity ).toString())
            }
            //println(new groovy.json.JsonBuilder( activity ).toString())
            println("-----END----")

            if(siteId) {
                def connection = new URL("${SERVER_URL}${ADD_NEW_ACTIVITY_URL}"+record."Survey ID").openConnection() as HttpURLConnection
                // set some headers
                connection.setRequestProperty('userName', "${USERNAME}")
                connection.setRequestProperty('authKey', "${AUTH_KEY}")
                connection.setRequestProperty('Content-Type', 'application/json;charset=utf-8')
                connection.setRequestMethod("POST")
                connection.setDoOutput(true)

                if (!DEBUG_AND_VALIDATE) {
                    java.io.OutputStreamWriter wr = new java.io.OutputStreamWriter(connection.getOutputStream(), 'utf-8')
                    wr.write(new groovy.json.JsonBuilder(activity).toString())
                    wr.flush()
                    wr.close()
                    // get the response code - automatically sends the request
                    println connection.responseCode + ": " + connection.inputStream.text
                }
            } else {
                println("Error: (${activityIndex}) activity creation skipped due to missing siteId")
            }
        }
    }

    println("Completed..")
}
