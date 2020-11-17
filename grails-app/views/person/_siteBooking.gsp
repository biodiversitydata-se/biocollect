<div class="form-horizontal">
<bs:form inline="true" class="form-horizontal">
    <div id="messageSuccess" class="hide alert alert-success">
        <button class="close" onclick="$('#messageSuccess').fadeOut();" href="#">×</button>
        <span></span>
    </div>

    <div id="messageFail" class="hide alert alert-danger">
        <button class="close" onclick="$('#messageFail').fadeOut();" href="#">×</button>
        <span></span>
    </div>
    <form class="site-input input-append pull-left">
        <label><g:message code="project.admin.members.batchBookSites"/></label>
        <input id="bookedSitesInput" data-bind="value: person().sitesToBook, event: { change: splitSitesToBook }"  type="text" class="span12"/>
        <button class="btn btn-primary form-control" data-bind="click: bookSite"><g:message code="btn.book"/></button>
        <g:img uri="${asset.assetPath(src:'spinner.gif')}" id="spinner5" class="hide spinner" alt="spinner icon"/>
    </form>

</bs:form>
</div>

<%-- TABLE showing what sites the person has booked and what they own  --%>
<div class="span5">
<g:if test="${person?.bookedSites}">
    <a href="#" onclick="return loadBookedSites()"><g:message code="person.siteBooking.showBooked"/></a>
</g:if>
<g:else>
    <p><g:message code="person.siteBooking.noSites"/></p>
</g:else>
</div>

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

<asset:script>
    var table,
        url = fcConfig.getSiteNamesUrl;

    function reloadSites() {
        $('#booked-sites-table').DataTable().ajax.reload();
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
         table = $('#booked-sites-table').DataTable({ 
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
            table.ajax.url(url).load()
        }
    }

    // remove site booking from person's profile and from site     
    $('#booked-sites-table').on("click", "tbody td:nth-child(2) a", function (e) {
        e.preventDefault();
        var bookedSites = ${(person?.bookedSites) ? person?.bookedSites : false };

        var row = this.parentElement.parentElement,
            data = table.row(row).data(),
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

    // if site name is clicked display site index page
    $('#booked-sites-table').on("click", "tbody td:nth-child(1) a", function (e) {
        e.preventDefault();
        var row = this.parentElement.parentElement,
            data = table.row(row).data();
        document.location.href = fcConfig.viewSiteUrl + '/' + data.siteId; 
    });

</asset:script>