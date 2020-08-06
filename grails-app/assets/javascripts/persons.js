function reloadMembers() {
    $('#person-list').DataTable().ajax.reload();
}

    // TODO - this should contain projectId that will be saved in person.projects - 
// projectId is available in personlistview - move this function there
var createPersonForProject = function() {
    window.location.href = fcConfig.createPersonUrl;
};

function PersonViewModel(savedPerson, create, projectId) {
    var self = this;
    console.log("create is ", create)

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
        personModel.projects(person.projects, []);
        }

    if (!create){
        console.log("loading person");
        self.loadPerson(savedPerson);
    }

    // TODO depending on create or edit - update person
    self.save = function (){
        console.log("saving create is ", create)
        // if ($('#validation-container').validationEngine('validate')) {
        var personId = self.person().personId();

        var data = self.modelAsJSON(self.person());
        var url = fcConfig.ajaxCreateUrl; 
        
        if (create) {
            url = fcConfig.saveNewPersonUrl; 
        } else {
            url = fcConfig.updatePersonUrl + '/' + personId;
        }
            $.ajax({
                url: url,
                type: 'POST',
                data: data,
                contentType: 'application/json',
                success: function (data) {
                    if(data.status == 'created'){
                       console.log("person created")
                    }                  
                },
                error: function (data) {
                    var errorMessage = data.responseText || 'There was a problem saving this person'
                    bootbox.alert(errorMessage);
                }
            });
    
    // }
    }


    // self.loadPerson(person)

    self.cancel = function (){
        console.log("cancel")
    }

    self.deletePerson = function () {
        var personId = self.person().personId();
        console.log("delete ", personId);
        var message = "<span class='label label-important'>Important</span><p><b>This cannot be undone</b></p><p>Are you sure you want to delete this person?</p>";
        bootbox.confirm(message, function (result) {
            if (result) {
                $.ajax({
                    url: fcConfig.deletePersonUrl + '/' + personId,
                    type: 'DELETE',
                    success: function (data) {
                        if (data.error) {
                            alert(data.error)
                            // showAlert(data.error, "alert-error", self.transients.resultsHolder);
                        } else {
                            alert("succesfully deleted")
                            // showAlert("Successfully deleted. Indexing is in process, search result will be updated in few minutes. Redirecting to search page...", "alert-success", self.transients.resultsHolder);
                            // setTimeout(function () {
                            //     window.location.href = fcConfig.homePagePath;
                            // }, 3000);
                        }
                    },
                    error: function (data) {
                        alert("another error")
                        // showAlert("Error: Unhandled error", "alert-error", self.transients.resultsHolder);
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

    // list persons for project
    self.listPersonsForProject = function(){
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
                    data: 'registeredOnline',
                    name: 'registeredOnline',
                    bSortable: false
    
                },
                {
                    render: function (data, type, row) {
                        return '<div class="pull-right margin-right-20">' + '<a class="margin-left-10" href="" title="view this user\'s details"><i class="fa fa-eye"></i></a>' +
                        '<a class="margin-left-10" href="" title="edit this user and role combination"><i class="fa fa-edit"></i></a>' +
                        '<a class="margin-left-10" href=""  title="remove this user and role combination"><i class="fa fa-remove"></i></a></div>';
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
            self.getPerson(personId);
        });
    }

    self.getPerson = function (personId) {
        document.location.href = fcConfig.getPersonUrl + '/' + personId; 
    }

    self.listPersonsForProject();
}