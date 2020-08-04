/**
 * Render project members and their roles, support pagination.
 */
function initialisePersonsTable(projectId) {

    var table = $('#person-list').DataTable({
        "bFilter": false,
        "processing": true,
        "serverSide": true,
        "ajax": fcConfig.getPersonsForProjectIdPaginatedUrl + "/" + projectId,
        "columns": [
            {
                data: 'personId',
                name: 'personId',
                bSortable: false
            },
            {
                data: 'firstName',
                name: 'firstName',
                bSortable: false
            },
            {
                data: 'lastName',
                name: 'lastName',
                bSortable: false
            },
            {
                data: null, // can be null or undefined
                defaultContent: "<i>02764</i>",
                bSortable: false
            },
            {
                data: null, // can be null or undefined
                defaultContent: "<i>Yes</i>",
                bSortable: false

            }
            ,
            {
                render: function (data, type, row) {
                    // cannot delete the last admin
                    if (table.ajax.json().totalNbrOfAdmins == 1 && row.role == "admin") {
                        return '';
                    } else {
                        return '<div class="pull-right margin-right-20">' + '<a class="margin-left-10" href="" title="view this user\'s details"><i class="fa fa-eye"></i></a>' +
                        '<a class="margin-left-10" href="" title="edit this user and role combination"><i class="fa fa-edit"></i></a>' +
                        '<a class="margin-left-10" href=""  title="remove this user and role combination"><i class="fa fa-remove"></i></a></div>';
                    }
                },
                bSortable: false
            }
        ]
    });
}

function reloadMembers() {
    $('#person-list').DataTable().ajax.reload();
}

var createPersonforProject = function() {
    window.location.href = fcConfig.createPersonUrl;
}; 

function PersonViewModel() {
    var self = this;

    self.personId = ko.observable();
    self.firstName = ko.observable();
    self.lastName = ko.observable();
    self.email = ko.observable();
    self.address1 = ko.observable();
    self.address2 = ko.observable();
    self.postCode = ko.observable();
    self.town = ko.observable();
    self.phoneNum = ko.observable();
    self.mobileNum = ko.observable();
    self.gender = ko.observable();
    self.birthYear = ko.observable();
    self.extra = ko.observable();
    self.modTyp = ko.observable();
    self.eProt = ko.observable();

    // TODO - should not be hard-coded
    self.projects = ["e0a99b52-c9fb-4b81-ae39-4436d11050c6"]

    self.loadPerson = function (person){
        var personModel = null;
    }

    self.save = function (){
        console.log("saving")
        // if ($('#validation-container').validationEngine('validate')) {

        var data = self.modelAsJSON(self);
        console.log(data);

            // TODO remove temp values for testing
            // var data = {
            //     firstName: "John", lastName: "Doe", projects: ["e0a99b52-c9fb-4b81-ae39-4436d11050c6"], personId: "7489237894"
            // };

            $.ajax({
                url: fcConfig.ajaxCreateUrl,
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

    self.cancel = function (){
        console.log("cancel")
    }

    self.deletePerson = function () {
        console.log("delete func");
        var message = "<span class='label label-important'>Important</span><p><b>This cannot be undone</b></p><p>Are you sure you want to delete this person?</p>";
        bootbox.confirm(message, function (result) {
            if (result) {
                $.ajax({
                    url: fcConfig.deletePersonUrl,
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
        var js = ko.toJS(self);
        return js;
    };

    self.modelAsJSON = function () {
        return JSON.stringify(self.toJS());
    };

}

function PersonsListViewModel(){

    // get persons for project
    self.listAll = function(){

    }
}