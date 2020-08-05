function reloadMembers() {
    $('#person-list').DataTable().ajax.reload();
}

var createPersonforProject = function() {
    window.location.href = fcConfig.createPersonUrl;
};
var editPerson = function(){
    window.location.href = fcConfig.updatePersonUrl;
} 

function PersonViewModel(savedPerson) {
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
        birthYear : ko.observable(),
        extra : ko.observable(),
        modTyp : ko.observable(),
        eProt : ko.observable(),
        projects : "e0a99b52-c9fb-4b81-ae39-4436d11050c6"
    })

    // TODO - should not be hard-coded

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
        personModel.birthYear(exists(person, "birthYear"));
        personModel.extra(exists(person, "extra"));
        personModel.modTyp(exists(person, "modTyp"));
        personModel.eProt(exists(person, "eProt"));
        // personModel.projects(exists(person, "projects"));
        

        console.log("personModel", personModel)
        console.log(typeof personModel);
    }
    self.loadPerson(savedPerson)

    self.save = function (){
        console.log("saving")
        // if ($('#validation-container').validationEngine('validate')) {

        var data = self.modelAsJSON(self.person());
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

    self.editPerson = function(){
        $.ajax({
            url: fcConfig.getPersonByIdUrl,
            type: 'GET',
            data: id,
            contentType: 'application/json',
            success: function (data) {
                if(data.status == 'created'){
                   console.log("got person")
                }  
            },
            error: function (data) {
                var errorMessage = data.responseText || 'There was a problem saving this person'
                bootbox.alert(errorMessage);
            }
        });
    }

    // self.loadPerson(person)

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
                    data: 'email', // can be null or undefined
                    name: 'email',
                    bSortable: false
                },
                {
                    data: 'registeredOnline', // can be null or undefined
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
            console.log("clicked", $(this));

            var row = this.parentElement;
            console.log("row", row);
            var data = table.row(row).data();
            console.log(this.parentElement);
            var personId = data.personId;
            console.log("personId ", personId);
            editPerson(personId);
        });
    
        // function updateStatusMessage2(msg) {
        //     $('#formStatus span').text(''); // clear previous message
        //     $('#formStatus span').text(msg).parent().fadeIn();
        // }
    
        // function removeUserRole(userId, role) {
        //     $.ajax({
        //         url: fcConfig.removeUserRoleUrl,
        //         data: {
        //             userId: userId,
        //             role: role,
        //             entityId: projectId
        //         }
        //     })
        //         .done(function (result) {
        //                 updateStatusMessage2("user was removed.");
        //             }
        //         )
        //         .fail(function (jqXHR, textStatus, errorThrown) {
        //                 alert(jqXHR.responseText);
        //             }
        //         )
        //         .always(function (result) {
        //             reloadMembers(); // reload table
        //         });
        // }
    }

    var editPerson = function (personId) {
        var url = fcConfig.updatePersonUrl + '/' + personId  // + '?returnTo=' + encodeURIComponent(fcConfig.returnTo);
        document.location.href = url;
    }

    self.listPersonsForProject();
}