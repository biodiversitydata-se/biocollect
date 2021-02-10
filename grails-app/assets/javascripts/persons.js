function PersonViewModel(savedPerson, create, hubProjectIds) {
    var self = this;
    self.person = ko.observable({
        personId : ko.observable(),
        internalPersonId: ko.observable(),
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
        bookedSites: ko.observableArray(),
        sitesToBook: ko.observableArray()
    });

    self.person().projects = hubProjectIds;
    self.splitSitesToBook = function () {
        if (typeof self.person().sitesToBook() == 'string'){
            var array = self.person().sitesToBook().split(",");
            var siteNames = array.map(function(name){ return name.trim() })
            self.person().sitesToBook(siteNames);
        }
        return self.person().sitesToBook();
    }

    self.loadPerson = function (person){
        var personModel = self.person();
        personModel.internalPersonId(exists(person, "internalPersonId"))
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
        personModel.bookedSites(exists(person, "bookedSites"));
        personModel.sitesToBook(exists(person, "sitesToBook"));
    }

    if (!create){
        self.loadPerson(savedPerson);
    }

    self.save = function (){

        if ($('#personal-details-form').validationEngine('validate')) {
        var id = self.person().personId(),
         data = self.modelAsJSON(self.person());
        if (create) {
            url = fcConfig.personSaveUrl; 
        } else {
            url = fcConfig.personUpdateUrl + '/' + id;
        }
        $.ajax({
            url: url,
            type: 'POST',
            data: data,
            contentType: 'application/json',
            success: function (data) {
                if (data.resp.status=='error'){
                    bootbox.alert(data.resp.error);
                } else {
                    bootbox.alert(data.resp.personName + " successfully saved");
                    document.location.href = fcConfig.returnTo;
                }
            },
            error: function (data) {
                var errorMessage = data.resp.error|| 'There was a problem saving this person'
                bootbox.alert(errorMessage);
                document.location.href = fcConfig.returnTo;
            }
        });
    
        }
    }

    self.deletePerson = function () {
        var message = "<span class='label label-important'>Important</span><p><b>This cannot be undone</b></p><p>Are you sure you want to delete this person?</p>";
        bootbox.confirm(message, function (result) {
            if (result) {
                $.ajax({
                    url: fcConfig.deletePersonUrl,
                    type: 'DELETE',
                    success: function (data) {
                        console.log(data);
                        alert("Successfully deleted. Indexing is in process, search result will be updated in few minutes. Redirecting to search page...", "alert-success");
                        window.location.href = fcConfig.returnTo;
                    },
                    error: function () {
                        console.log(data);

                        alert("Error deleting person")
                        document.location.href = fcConfig.returnTo;
                    }
                });
            }
        });
    };

     // save site booking
     self.bookSite = function(){
        if ($('#individualBookingForm').validationEngine('validate')) {
            var data = {
                siteNames: self.person().sitesToBook(),
                personId: self.person().personId(),
                bookMany: true
                };
                console.log(data);
            $.ajax({
                url: fcConfig.bookSiteUrl,
                type: 'POST',
                data: JSON.stringify(data),
                contentType: 'application/json',
                success: function (data) {
                    if (data.resp.message[0] != ""){
                        $("#messageSuccess span").html(data.resp.message[0]).parent().fadeIn();
                        // document.location.href = here;
                    }
                    if (data.resp.message[1] != ""){
                        $("#messageFail span").html(data.resp.message[1]).parent().fadeIn();
                    }
                    $("#bookedSitesInput").text("");
                },
                error: function (data) {
                    var errorMessage = data.responseText || 'There was a problem saving this site'
                    bootbox.alert(errorMessage);
                }
            });
        }
    }

    self.toJS = function() {
        var js = ko.toJS(self.person());
        return js;
    };

    self.modelAsJSON = function () {
        return JSON.stringify(self.toJS());
    };

}


/* This view model lists all observers registered for this project, 
 it displays links on each name so that person can be viewed in detail and edited  */
// function PersonsListViewModel(projectId){
//     var self = this;

//     // list persons for project
//     self.loadPersons = function(){

//         // START of temporary list 

//         var table = $('#person-list').DataTable({
//             "bFilter": false,
//             "processing": true,
//             "serverSide": true,
//             "paging": false,
//             "ajax": fcConfig.getPersonsForProjectIdPaginatedUrl + "/" + projectId,
//             "columns": [
//                 {
//                     data: 'personId',
//                     name: 'personId'
//                 },
//                 {
//                     data: 'firstName',
//                     name: 'firstName',
//                     bSortable: false
//                 },
//                 {
//                     data: 'lastName',
//                     name: 'lastName',
//                     bSortable: true
//                 },
//                 {
//                     data: 'email',
//                     name: 'email',
//                     bSortable: false
//                 },
//                 {
//                     data: 'town',
//                     name: 'town',
//                     bSortable: false
    
//                 },
//                 {
//                     render: function (data, type, row) {
//                         return '<div class="pull-right margin-right-20">' + 
//                         '<a class="margin-left-10" href="" title="edit this user and role combination"><i class="fa fa-edit"></i></a>' 
//                         + '</div>';
//                     },
//                     bSortable: false
//                 }
//             ]
//         });

//         $('#person-list').on("click", "tbody td:nth-child(1)", function (e) {
//             e.preventDefault();
//             var row = this.parentElement;
//             var data = table.row(row).data();
//             var personId = data.personId;
//             self.viewPerson(personId);
//         });

//         $('#person-list').on("click", "tbody td:nth-child(6)", function (e) {
//             e.preventDefault();
//             var row = this.parentElement;
//             var data = table.row(row).data();
//             var personId = data.personId;
//             console.log(personId)
//             self.editPerson(personId);
//         });
//         // END of temporary list

//     }

//     self.viewPerson = function (personId) {
//         document.location.href = fcConfig.personViewUrl + '&id=' + personId; 
//     }

//     self.editPerson = function(personId) {
//         document.location.href = fcConfig.personEditUrl + '&id=' + personId; 
//     }

//     self.loadPersons();
// }