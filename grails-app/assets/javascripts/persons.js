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
        sitesToBook: ko.observable()
    });
    self.transients = {};
    self.transients.genderOptions = ["annat", "kvinna", "man"];

    self.person().projects = hubProjectIds;

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
                bookBySiteId: false
                };
            // clear the input field with site names    
            self.person().sitesToBook("")
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
                    $("#bookedSitesInput").html("");
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

function PersonsListViewModel(){
    var self = this;
    self.searchTerm = ko.observable();
    self.persons = ko.observableArray();
    self.displayTable = ko.observable(false);

           /**
     * creates an object what will be sent as parameters
     * @param tOffset
     * @returns {{max: *, offset: *, query: *, fq: *}}
     */
    self.constructQueryParams = function(){
        var params = {
            max: 50,
            offset: 0,
            query: self.searchTerm(),
            fq: $.map('', ''),
            sort: '_score'
        }
        return params;
    }
    
    self.loadPersons = function(){
        $.ajax({
            url: fcConfig.personSearchUrl + "/?searchTerm=" + self.searchTerm(), 
            data: self.constructQueryParams(),
            traditional:true,
            success: function(data){
                self.persons(data.persons);
                if (data.persons.length !== 0){
                    $('#personNotFound').hide();
                    self.displayTable(true);
                } else {
                    self.displayTable(false);
                    $('#personNotFound').show();
                    $('#personNotFound span').text(''); // clear previous message
                    $('#personNotFound span').text('No person matched this search').parent().fadeIn();
                }
            }, 
            error: function(){
                alert("error")
            }
        });
    }

    self.editPerson = function() {
        document.location.href = fcConfig.personEditUrl + '/' + this.personId + '/?returnTo=' + fcConfig.returnTo;
    }
}

