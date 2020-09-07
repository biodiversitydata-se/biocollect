    // TODO - this should contain projectId that will be saved in person.projects - 
// projectId is available in personlistview - move this function there
var createPersonForProject = function() {
    window.location.href = fcConfig.personCreateUrl;
};

function PersonViewModel(savedPerson, create, projectId) {
    var self = this;

    self.person = ko.observable({
        personId : ko.observable(),
        personCode: ko.observable(),
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
        projects : ko.observable(),
        bookedSites: ko.observableArray()
    });
    

    self.splitBookedSitesStr = function () {
        if (typeof self.person().bookedSites() == 'string'){
            var array = self.person().bookedSites().split(",");
            var siteNames = array.map(function(name){ return name.trim() })
            // TODO push names so that saved names aren't errased 
            self.person().bookedSites(siteNames);
        }
        console.log(self.person().bookedSites());
        return self.person().bookedSites();
    }

    self.loadPerson = function (person){
        var personModel = self.person();
        personModel.personCode(exists(person, "personCode"))
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
        personModel.projects(exists(person, "projects"));
        personModel.bookedSites(exists(person, "bookedSites"));
    }

    if (!create){
        self.loadPerson(savedPerson);
    }

    self.save = function (){

        if ($('#personal-details-form').validationEngine('validate')) {
        var id = self.person().personId();

        // var data = {};
        // for (const [key, value] of Object.entries(self.person())){
        //     if (value != '' && value != null){
        //         data.key = value;
        //     }
        // }
        // data = self.modelAsJSON(data);
        var data = self.modelAsJSON(self.person());
        
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
                    if(data.statusCode == 200){
                        bootbox.alert(data.resp.personName + " successfully saved");
                        document.location.href = fcConfig.returnToProjectUrl;
                    }    
                    else {
                        bootbox.alert("Person saved", data);
                        document.location.href = fcConfig.returnToProjectUrl;
                    }              
                },
                error: function (data) {
                    var errorMessage = data.resp.error|| 'There was a problem saving this person'
                    bootbox.alert(errorMessage);
                    document.location.href = fcConfig.returnToProjectUrl;
                }
            });
    
        }
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
                        window.location.href = fcConfig.returnToProjectUrl;
                    },
                    error: function () {
                        console.log(data);

                        alert("Error deleting person")
                        document.location.href = fcConfig.returnToProjectUrl;
                    }
                });
            }
        });
    };

     // save site booking
     self.bookSite = function(){

        var data = {
            siteNames: self.person().bookedSites(),
            personId: self.person().personId(),
            };
            console.log(data);
        $.ajax({
            url: fcConfig.bookSiteForPersonUrl,
            type: 'POST',
            data: JSON.stringify(data),
            contentType: 'application/json',
            success: function (data) {
                bootbox.alert(data.resp.message);
                $("#bookingMessage ul").html(data.resp.message).parent().fadeIn()
            },
            error: function (data) {
                var errorMessage = data.responseText || 'There was a problem saving this site'
                bootbox.alert(errorMessage);
            }
        });
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
function PersonsListViewModel(projectId){
    var self = this;

    // list persons for project
    self.loadPersons = function(){

        // START of temporary list 

        var table = $('#person-list').DataTable({
            "bFilter": false,
            "processing": true,
            "serverSide": true,
            "paging": false,
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
            console.log(personId)
            self.editPerson(personId);
        });
        // END of temporary list

    }

    self.viewPerson = function (personId) {
        document.location.href = fcConfig.personViewUrl + '&id=' + personId; 
    }

    self.editPerson = function(personId) {
        document.location.href = fcConfig.personEditUrl + '&id=' + personId; 
    }

    self.loadPersons();
}