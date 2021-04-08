dataAccessMethods = [
        "oasrdfs",
        "oaordfs",
        "lsrds",
        "ordfsvr",
        "oasrdes",
        "casrdes",
        "rdna",
        "odidpa",
        "na"
]

dataQualityAssuranceMethods = [
        "dataownercurated",
        "subjectexpertverification",
        "crowdsourcedverification",
        "recordannotation",
        "systemsupported",
        "nodqmethodsused",
        "na"
    ]

methodType = [
    'opportunistic',
    'systematic'
]

datapage.defaultColumns = [
        [
                type: "image",
                displayName: "Image",
                isSortable: false
        ],
        [
                type: "recordNameFacet",
                displayName: "Identification",
                isSortable: true,
                sort: false,
                order: 'asc',
                code: "recordNameFacet"
        ],
        [
                type: "symbols",
                displayName: "",
                isSortable: false
        ],
        [
                type: "details",
                displayName: "Details",
                isSortable: false
        ],
        [
                type: "property",
                propertyName: "lastUpdated",
                code: "lastUpdated",
                displayName: "Last updated",
                dataType: 'date',
                isSortable: true,
                sort: true,
                order: 'desc'
        ],
        [
                type: "action",
                displayName: "Action",
                isSortable: false
        ]
        ,
        [
                type: "checkbox",
                displayName: "Select item",
                isSortable: false
        ]
]

datapage.allColumns = datapage.defaultColumns + [
        [
                type: "property",
                propertyName: "surveyYearFacet",
                displayName: "Survey Year"
        ]
        ,
        [
                type: "property",
                propertyName: "surveyDate",
                displayName: "Survey Date"
        ]
        ,
        [
                type: "property",
                propertyName: "projectNameFacet",
                displayName: "Project name"
        ]
        ,
        [
                type: "property",
                propertyName: "projectActivityNameFacet",
                displayName: "Survey name"
        ]
        ,
        [
                type: "property",
                propertyName: "organisationNameFacet",
                displayName: "Organisation name"
        ]
        ,
        [
                type: "property",
                propertyName: "surveyMonthFacet",
                displayName: "Survey month"
        ],
        [
                type: "property",
                propertyName: "isDataManagementPolicyDocumented",
                displayName: ""
        ],
        [
                type: "property",
                propertyName: "dataQualityAssuranceMethods",
                displayName: ""
        ],
        [
                type: "property",
                propertyName: "nonTaxonomicAccuracy",
                displayName: ""
        ],
        [
                type: "property",
                propertyName: "temporalAccuracy",
                displayName: ""
        ],
        [
                type: "property",
                propertyName: "activityLastUpdatedMonthFacet",
                displayName: ""
        ],
        [
                type: "property",
                propertyName: "activityLastUpdatedYearFacet",
                displayName: ""
        ],
        [
                type: "property",
                propertyName: "associatedProgramFacet",
                displayName: ""
        ],
        [
                type: "property",
                propertyName: "siteNameFacet",
                displayName: ""
        ],
        [
                type: "property",
                propertyName: "spatialAccuracy",
                displayName: ""
        ],
        [
                type: "property",
                propertyName: "associatedSubProgramFacet",
                displayName: ""
        ],
        [
                type: "property",
                propertyName: "methodType",
                displayName: ""
        ],
        [
                type: "property",
                propertyName: "activityOwnerNameFacet",
                displayName: "Owner"
        ],
        [
                type: "property",
                propertyName: "verificationStatusFacet",
                displayName: "Verification status"
        ]
]


activitypropertypath = [
        surveyYearFacet: ['surveyYear'],
        projectNameFacet: ['projectActivity', 'projectName'],
        projectActivityNameFacet: ['projectActivity', 'name'],
        organisationNameFacet: ['projectActivity', 'organisationName'],
        surveyMonthFacet: ['projectActivity', 'surveyMonth'],
        isDataManagementPolicyDocumented: ['projectActivity', 'isDataManagementPolicyDocumented'],
        dataQualityAssuranceMethods: ['projectActivity', 'dataQualityAssuranceMethods'],
        nonTaxonomicAccuracy: ['projectActivity', 'nonTaxonomicAccuracy'],
        temporalAccuracy: ['projectActivity', 'temporalAccuracy'],
        speciesIdentification: ['projectActivity', 'speciesIdentification'],
        activityLastUpdatedMonthFacet: ['projectActivity', 'lastUpdatedMonth'],
        activityLastUpdatedYearFacet: ['projectActivity', 'lastUpdatedYear'],
        associatedProgramFacet: ['associatedProgram'],
        siteNameFacet: ['sites', 'name'],
        associatedSubProgramFacet: ['projectActivity', 'associatedSubProgram'],
        spatialAccuracy: ['projectActivity', 'spatialAccuracy'],
        methodType: ['projectActivity', 'methodType'],
        activityOwnerNameFacet: ['projectActivity', 'activityOwnerName'],
        verificationStatusFacet: ['verificationStatus']
]


content.defaultOverriddenLabels = [
        [
                id: 1,
                showCustomText: false,
                page: 'Project finder',
                defaultText: 'Showing XXXX to YYYY of ZZZZ projects',
                customText:'',
                notes: 'This text is generated dynamically. XXXX, YYYY & ZZZZ are replaced with dynamically generated content.'
        ],
        [
                id: 2,
                showCustomText: false,
                page: 'Project > "About" tab',
                defaultText: 'About the project',
                customText:'',
                notes: 'Section heading on project\'s about tab.'
        ],
        [
                id: 3,
                showCustomText: false,
                page: 'Project > "About" tab',
                defaultText: 'Aim',
                customText:'',
                notes: 'Section heading on project\'s about tab.'
        ],
        [
                id: 4,
                showCustomText: false,
                page: 'Project > "About" tab',
                defaultText: 'Description',
                customText:'',
                notes: 'Section heading on project\'s about tab.'
        ],
        [
                id: 5,
                showCustomText: false,
                page: 'Project > "About" tab',
                defaultText: 'Project information',
                customText:'',
                notes: 'Section heading on project\'s about tab.'
        ],
        [
                id: 6,
                showCustomText: false,
                page: 'Project > "About" tab',
                defaultText: 'Program name',
                customText:'',
                notes: 'Section heading on project\'s about tab.'
        ],
        [
                id: 7,
                showCustomText: false,
                page: 'Project > "About" tab',
                defaultText: 'Subprogram name',
                customText:'',
                notes: 'Section heading on project\'s about tab.'
        ],
        [
                id: 8,
                showCustomText: false,
                page: 'Project > "About" tab',
                defaultText: 'Project Area',
                customText:'',
                notes: 'Section heading for Map.'
        ]
]

/*
 * Notes:
 * These are all approximately (but not exactly) the same. It is important that 'GetMap' requests include the 'SRS' (default is EPSG:3857).
 * EPSG:4283 GDA94
 * EPSG:4326 WGS 84
 * EPSG:3857 WGS 84 / Pseudo-Mercator
 */

// Bounds are in EPSG:4326.
def boundsSrs = "EPSG:4283"
def bounds = [:]
def defaultCqlFilter = ""
if (bounds.size()) {
        defaultCqlFilter = "BBOX(the_geom,${bounds.lngWestMin},${bounds.latSouthMin},${bounds.lngEastMax},${bounds.latNorthMax},'${boundsSrs}')"
}
if (!map.baseLayers) {
        map.baseLayers = [
                [
                        'code': 'minimal',
                        'displayText': 'Vägkarta',
                        'isSelected': false
                ],
                [
                        'code': 'worldimagery',
                        'displayText': 'Satellit',
                        'isSelected': false
                ],
                [
                        'code': 'detailed',
                        'displayText': 'Detaljerad',
                        'isSelected': false
                ],
                [
                        'code': 'topographic',
                        'displayText': 'Topografisk',
                        'isSelected': true
                ],
                [
                        'code': 'googlehybrid',
                        'displayText': 'Google hybrid',
                        'isSelected': false
                ],
                [
                        'code': 'googleroadmap',
                        'displayText': 'Google roadmap',
                        'isSelected': false
                ],
                [
                        'code': 'googleterrain',
                        'displayText': 'Google terrain',
                        'isSelected': false
                ],
                [
                        'code': 'landscape',
                        'displayText': 'Thunderforest landskap',
                        'isSelected': false
                ],
                [
                        'code': 'lantmateriettopo',
                        'displayText': 'Lantmateriet topografisk',
                        'isSelected': false
                ]
                // ,
                // [
                //         'code': 'lantmaterietortofoto',
                //         'displayText': 'Lantmateriet ortofoto',
                //         'isSelected': false
                // ]
        ]
}

if(!map.overlays) {
        map.overlays = [
                [
                        alaId       : 'cl22',
                        alaName     : 'aus1',
                        layerName   : 'aust_states_territories',
                        title         : '#',
                        defaultSelected: false,
                        boundaryColour  : '#fdb863',
                        showPropertyName: false,
                        fillColour      : '',
                        textColour      : '',
                        userAccessRestriction: 'anyUser',
                        inLayerShapeList     : true,
                        opacity: 0.5,
                        
                        display     : [
                                cqlFilter     : defaultCqlFilter,
                                propertyName  : 'NAME_1'
                        ],
                        style       : [:],
                        bounds      : bounds,
                        restrictions: [:]
                ],
                [
                        alaId       : 'Indexrutor_25',
                        alaName     : 'Indexrutor_25',
                        layerName   : 'Indexrutor_25',
                        title         : '#Grid RT90',
                        defaultSelected: false,
                        boundaryColour  : '#fdb863',
                        showPropertyName: false,
                        fillColour      : '',
                        textColour      : '',
                        userAccessRestriction: 'anyUser',
                        inLayerShapeList     : true,
                        opacity: 0.5,
                        
                        display     : [
                                cqlFilter     : defaultCqlFilter,
                                propertyName  : 'NAME_1'
                        ]
                ]
        ]
}

if (!map.wms.maxFeatures) {
        map.wms.maxFeatures = 100000
}

map.data.displays = [
        [
                value: "Point",
                key: "point_circle",
                showLoggedOut: true,
                showLoggedIn: true,
                showProjectMembers: true,
                isDefault: "heatmap",
                size: 4
        ],
        [
                value: "Polygon",
                key: "polygon_sites",
                showLoggedOut: true,
                showLoggedIn: true,
                showProjectMembers: true,
                isDefault: "heatmap",
                size: 1
        ],
        [
                value: "Line",
                key: "line_sites",
                showLoggedOut: true,
                showLoggedIn: true,
                showProjectMembers: true,
                isDefault: "heatmap",
                size: 1
        ],
        [
                value: "Heatmap",
                key: "heatmap",
                showLoggedOut: true,
                showLoggedIn: true,
                showProjectMembers: true,
                isDefault: "heatmap"
        ]
//        TODO: fix clustering on GeoServer before enabling.
//        ,
//        [
//                value: "Cluster",
//                key: "cluster",
//                showLoggedOut: true,
//                showLoggedIn: true,
//                showProjectMembers: true,
//                isDefault: "heatmap"
//        ]
]

map.projectfinder.displays = [
        [
                value: "Point",
                key: "point_circle_project",
                showLoggedOut: true,
                showLoggedIn: true,
                showProjectMembers: true,
                isDefault: "point_circle_project",
                size: 9
        ],
        [
                value: "Polygon",
                key: "polygon_sites_project",
                showLoggedOut: true,
                showLoggedIn: true,
                showProjectMembers: true,
                isDefault: "point_circle_project",
                size: 1
        ],
        [
                value: "Heatmap",
                key: "heatmap",
                showLoggedOut: true,
                showLoggedIn: true,
                showProjectMembers: true,
                isDefault: "point_circle_project"
        ]
//        Cluster view is not working in GeoServer. Disabling it for the moment.
//        TODO: fix clustering of projects on GeoServer.
//        ,
//        [
//                value: "Cluster",
//                key: "cluster_project",
//                showLoggedOut: true,
//                showLoggedIn: true,
//                showProjectMembers: true,
//                isDefault: "polygon_sites_project"
//        ]
]

settings.surveyMethods="fielddata.survey.methods"

geoServer.readTimeout = 600000