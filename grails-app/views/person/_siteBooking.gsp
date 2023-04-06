<div class="container-fluid">
    <h2><g:message code="g.sites"/></h2>
    <hr>
        <div class="well span12">
            <div id="messageSuccess" class="hide alert alert-success">
                <button class="close" onclick="$('#messageSuccess').fadeOut();" href="#">×</button>
                <span></span>
            </div>
            <div id="messageFail" class="hide alert alert-danger">
                <button class="close" onclick="$('#messageFail').fadeOut();" href="#">×</button>
                <span></span>
            </div>
            <div class="input-append">
                <label><g:message code="project.admin.members.batchBookSites"/></label>
                <input id="bookedSitesInput" data-bind="value: person().sitesToBook"  type="text" class="span10"/>
                <button class="btn btn-primary form-control" data-bind="click: bookSite"><g:message code="btn.book"/></button>
            </div>
        </div>
    
    <div class="well span12">
        <g:if test="${person?.bookedSites}">
            <h4><a href="#" onclick="return loadBookedSites()"><g:message code="person.siteBooking.showBooked"/></a></h4>
        </g:if>
        <g:else>
            <h4><g:message code="person.siteBooking.noSites"/></h4>
        </g:else>

        <div id="booked-sites-div" hidden>
            <table style="width: 95%;margin:30px" class="table table-striped table-bordered table-hover" id="booked-sites-table">
                <thead>
                <th><g:message code="site.details.siteName"/></th>
                <th width="10%"><g:message code="person.siteBooking.cancelBooking"/></th>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>

    <div class="well span12">
        <g:if test="${person?.ownedSites}">
            <h4><a href="#" onclick="return loadOwnedSites()"><g:message code="person.siteBooking.showCreated"/></a></h4>
        </g:if>
        <g:else>
            <h4><g:message code="person.siteBooking.noSites"/></h4>
        </g:else>

        <div id="owned-sites-div" hidden>
            <table style="width: 95%;margin:30px" class="table table-striped table-bordered table-hover" id="owned-sites-table">
                <thead>
                    <th><g:message code="site.details.siteName"/></th>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
</div>

<asset:script>
    var tableBookedSites,
        tableOwnedSites,
        url = fcConfig.getBookedSiteNamesUrl;

    function reloadSites() {
        location.reload();
    }

    function cancelBooking(params){
        $.ajax({
            url: fcConfig.removeBookingUrl + '/' + params.siteId, 
            type: "POST",
            contentType: 'application/json',
            data: JSON.stringify(params)
        })
        .done(function(result){
            alert("Booking cancelled successfully."); 
        })
        .fail(function(jqXHR, textStatus, errorThrown){
            alert("Unfortunately, the booking could not be cancelled.")
        })
        .always(function(result){
            reloadSites();
        })
    }

    function loadBookedSites(){
        $('#booked-sites-div').attr("hidden", false); 

        if (! $.fn.DataTable.isDataTable( '#booked-sites-table' )){
         tableBookedSites = $('#booked-sites-table').DataTable({ 
            "ajax": {"url": url, "dataSrc": ""},
            "bFilter": false,
            "info": "",
            "infoEmpty": "",
            "infoFiltered": "",
            "processing": true,
            "serverSide": true,
            "paging": false,
            "columns": [
                {
                    data: 'name',
                    name: 'name',
                    render: function (data, type, row) {
                        return '<a class="margin-left-10" href="#" title="See site details">' 
                        + data + '</a>';
                    }
                },
                {
                    data: 'siteId',
                    name: 'siteId',
                    render: function (data, type, row) {

                        return '<a class="btn btn-small tooltips" href="" title="Remove booking"><i class="icon-remove"></i></a>';
                    },
                    bSortable: false
                }
            ]
            });  
        } else {
            tableBookedSites.ajax.url(url).load()
        }
    }

    // remove site booking from person's profile and from site     
    $('#booked-sites-table').on("click", "tbody td:nth-child(2) a", function (e) {
        e.preventDefault();
        var bookedSites = ${(person?.bookedSites) ? person?.bookedSites : false };

        var row = this.parentElement.parentElement,
            data = tableBookedSites.row(row).data(),
            siteId = data.siteId;

        if (bookedSites){
            bookedSites.splice(bookedSites.indexOf(siteId), 1);
        }
        var params = {siteId: siteId, personId: "${person?.personId}", bookedSites: bookedSites};

        var message = "<span class='label label-important'>Important</span><p><b>If you proceed the booking will be removed.</b></p><p>Are you sure you want to remove it?</p>";
        
        bootbox.confirm(message, function (result) {
            if (result){
                cancelBooking(params);
            }
        });
    });

    function loadOwnedSites(){
        var url = fcConfig.getOwnedSiteNamesUrl;
        $('#owned-sites-div').attr("hidden", false); 

        if (! $.fn.DataTable.isDataTable( '#owned-sites-table' )){
         tableOwnedSites = $('#owned-sites-table').DataTable({ 
            "ajax": {"url": url, "dataSrc": ""},
            "bFilter": false,
            "info": "",
            "infoEmpty": "",
            "infoFiltered": "",
            "processing": true,
            "serverSide": true,
            "paging": false,
            "columns": [
                {
                    data: 'name',
                    name: 'name',
                    render: function (data, type, row) {
                        return '<a class="margin-left-10" href="#" title="See site details">' 
                        + data + '</a>';
                    }
                }
            ]
            });  
        } else {
            tableOwnedSites.ajax.url(url).load()
        }
    }

    // if site name is clicked display site index page
    $('#booked-sites-table').on("click", "tbody td:nth-child(1) a", function (e) {
        e.preventDefault();
        var row = this.parentElement.parentElement,
            data = tableBookedSites.row(row).data();
        document.location.href = fcConfig.viewSiteUrl + '/' + data.siteId; 
    });

        $('#owned-sites-table').on("click", "tbody td:nth-child(1) a", function (e) {
        e.preventDefault();
        var row = this.parentElement.parentElement,
            data = tableOwnedSites.row(row).data();
        document.location.href = fcConfig.viewSiteUrl + '/' + data.siteId; 
    });

</asset:script>