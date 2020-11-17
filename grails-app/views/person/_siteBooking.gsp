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
    <%-- <div class="row-fluid">
        <div class="form-actions span12">
            <button type="button" id="goBack" class="btn"><g:message code="btn.backToProject"/></button>
        </div>
    </div> --%>
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
        <th width="5%"><g:message code="person.siteBooking.cancelBooking"/></th>
        </thead>
        <tbody>
        </tbody>
    </table>
</div>

<asset:script>

    var table;
    var loadBookedSites = function(){
        $('#booked-sites-div').attr("hidden", false); 
        var url = fcConfig.getSiteNamesUrl;
        if (! $.fn.DataTable.isDataTable( '#survey-list-table' )){
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
        } 
    }

        // remove site booking from person's profile and from site     
        $('#booked-sites-table').on("click", "tbody td:nth-child(2) a", function (e) {
            e.preventDefault();
            var bookedSites = ${(person?.bookedSites) ? person?.bookedSites : false };

            console.log(bookedSites);
            var row = this.parentElement.parentElement,
             data = table.row(row).data(),
             siteId = data.siteId;

            if (bookedSites){
                bookedSites.splice(bookedSites.indexOf(siteId), 1);
            }
            var data = JSON.stringify({siteId: siteId, personId: "${person?.personId}", bookedSites: bookedSites});
             console.log(data);

            var message = "<span class='label label-important'>Important</span><p><b>If you proceed the booking will be removed.</b></p><p>Are you sure you want to remove it?</p>";
            
            bootbox.confirm(message, function (result) {
                if (result){
                    var url = fcConfig.removeBookingUrl + '/' + siteId;
                    $.ajax({
                        url: url, 
                        data: data,
                        type: "POST",
                        contentType: 'application/json',
                        success: function(data){
                        alert("Booking cancelled"); 
                        loadBookedSites();
                        },
                        error: function(error){
                            alert("Unfortunately the booking could not be cancelled.")
                        }
                    });
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

    function reloadTable() {
        $('#booked-sites-table').DataTable().ajax.reload();
    }
</asset:script>