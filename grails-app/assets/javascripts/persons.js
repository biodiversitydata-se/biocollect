function reloadMembers() {
    $('#person-list').DataTable().ajax.reload();
}

    // TODO - this should contain projectId that will be saved in person.projects - 
// projectId is available in personlistview - move this function there
var createPersonForProject = function() {
    window.location.href = fcConfig.personCreateUrl;
};

function PersonViewModel(savedPerson, create, projectId) {
    var self = this;

    self.person = ko.observable({
        personId : ko.observable(),
        firstName : ko.observable(),
        lastName : ko.observable(),
        email : ko.observable(),
        address1 : ko.observable(),
        address2 : ko.observable(),
        postCode : ko.observable(),
        town : ko.observable(),
        phoneNum : ko.observable(),
        mobileNum : ko.observable(),
        gender : ko.observable(),
        birthDate : ko.observable(),
        extra : ko.observable(),
        modTyp : ko.observable(),
        eProt : ko.observable(),
        projects : ko.observableArray([projectId])
    })

    self.loadPerson = function (person){
        var personModel = self.person();

        personModel.firstName(exists(person, "firstName"));
        personModel.lastName(exists(person, "lastName"));
        personModel.email(exists(person, "email"));
        personModel.personId(exists(person, "personId"));
        personModel.address1(exists(person, "address1"));
        personModel.address2(exists(person, "address2"));
        personModel.postCode(exists(person, "postCode"));
        personModel.town(exists(person, "town"));
        personModel.phoneNum(exists(person, "phoneNum"));
        personModel.mobileNum(exists(person, "mobileNum"));
        personModel.gender(exists(person, "gender"));
        personModel.birthDate(exists(person, "birthDate"));
        personModel.extra(exists(person, "extra"));
        personModel.modTyp(exists(person, "modTyp"));
        personModel.eProt(exists(person, "eProt"));
        personModel.projects(person.projects || []);
        }

    if (!create){
        self.loadPerson(savedPerson);
    }

    self.returnToProjectUrl = fcConfig.returnToProjectUrl +'/' + projectId;
    // TODO depending on create or edit - update person
    self.save = function (){

        // if ($('#validation-container').validationEngine('validate')) {
        var personId = self.person().personId();

        var data = self.modelAsJSON(self.person());
        
        if (create) {
            url = fcConfig.personSaveUrl; 
        } else {
            url = fcConfig.personUpdateUrl + '/' + personId;
        }
            $.ajax({
                url: url,
                type: 'POST',
                data: data,
                contentType: 'application/json',
                success: function (data) {
                    if(data.status == 'created'){
                        alert("Person updated success!");
                       document.location.href = self.returnToProjectUrl;
                    }    
                    else {
                        alert("Person updated ok");
                        document.location.href = self.returnToProjectUrl;
                    }              
                },
                error: function (data) {
                    var errorMessage = data.responseText || 'There was a problem saving this person'
                    bootbox.alert(errorMessage);
                    document.location.href = self.returnToProjectUrl;
                }
            });
    
    // }
    }


    // self.loadPerson(person)

    self.cancel = function (){
        console.log("cancel")
        document.location.href = self.returnToProjectUrl;
    }

    self.deletePerson = function () {
        var personId = self.person().personId();
        var message = "<span class='label label-important'>Important</span><p><b>This cannot be undone</b></p><p>Are you sure you want to delete this person?</p>";
        bootbox.confirm(message, function (result) {
            if (result) {
                $.ajax({
                    url: fcConfig.deletePersonUrl + '/' + personId,
                    type: 'DELETE',
                    success: function (data) {
                        console.log(data);
                        alert("Successfully deleted. Indexing is in process, search result will be updated in few minutes. Redirecting to search page...", "alert-success");
                        window.location.href = self.returnToProjectUrl;
                    },
                    error: function () {
                        console.log(data);

                        alert("Error deleting person")
                        document.location.href = self.returnToProjectUrl;
                    }
                });
            }
        });
    };

    self.toJS = function() {
        var js = ko.toJS(self.person());
        return js;
    };

    self.modelAsJSON = function () {
        return JSON.stringify(self.toJS());
    };

}


// * This view model lists all observers registered for this project, it displays links on each name so that person can be viewed in detail and edited  *//
function PersonsListViewModel(projectId){
    var self = this;
    self.searchTerm = ko.observable('');

    // /**
    //  * creates an object what will be sent as parameters
    //  * @param tOffset
    //  * @returns {{max: *, offset: *, query: *, fq: *}}
    //  */
    // self.constructQueryParams = function(tOffset){
    //     var offset

    //     if(tOffset != undefined || tOffset != null){
    //         offset = tOffset
    //     } else {
    //         offset = self.pagination.calculatePageOffset(self.pagination.currentPage()+1);
    //     }

    //     var params = {
    //         max: self.pagination.resultsPerPage(),
    //         offset: offset,
    //         query: self.searchTerm(),
    //         fq: $.map(self.selectedFacets(), function(fq){
    //             return fq.getQueryText();
    //         }),
    //         myFavourites:fcConfig.myFavourites
    //     }
    //     return params;
    // }

    // list persons for project
    self.loadPersons = function(){

         // TODO elasticsearch search 
        // var params = self.constructQueryParams(5);
        // console.log("params",params);
        // $.ajax({
        //     url: fcConfig.personSearchUrl,
        //     data: params,
        //     traditional:true,
        //     success: function (data) {
        //         if(data){
        //         console.log("person found")
        //         }

        //     },
        //     error: function (xhr) {
        //         self.error(xhr.responseText);
        //         self.sitesLoaded(true);
        //     }
        // })


        // START of temporary list 

        var table = $('#person-list').DataTable({
            "bFilter": false,
            "processing": true,
            "serverSide": true,
            "ajax": fcConfig.getPersonsForProjectIdPaginatedUrl + "/" + projectId,
            "columns": [
                {
                    data: 'personId',
                    name: 'personId'
                },
                {
                    data: 'firstName',
                    name: 'firstName',
                    bSortable: false
                },
                {
                    data: 'lastName',
                    name: 'lastName',
                    bSortable: true
                },
                {
                    data: 'email',
                    name: 'email',
                    bSortable: false
                },
                {
                    data: 'town',
                    name: 'town',
                    bSortable: false
    
                },
                {
                    render: function (data, type, row) {
                        return '<div class="pull-right margin-right-20">' + 
                        '<a class="margin-left-10" href="" title="edit this user and role combination"><i class="fa fa-edit"></i></a>' 
                        + '</div>';
                    },
                    bSortable: false
                }
            ]
        });

        $('#person-list').on("click", "tbody td:nth-child(1)", function (e) {
            e.preventDefault();
            var row = this.parentElement;
            var data = table.row(row).data();
            var personId = data.personId;
            self.viewPerson(personId);
        });

        $('#person-list').on("click", "tbody td:nth-child(6)", function (e) {
            e.preventDefault();
            var row = this.parentElement;
            var data = table.row(row).data();
            var personId = data.personId;
            self.editPerson(personId);
        });
        // END of temporary list

    }

    self.viewPerson = function (personId) {
        document.location.href = fcConfig.personViewUrl + '/' + personId; 
    }

    self.editPerson = function(personId) {
        document.location.href = fcConfig.personEditUrl + '/' + personId; 
    }

    self.loadPersons();
}