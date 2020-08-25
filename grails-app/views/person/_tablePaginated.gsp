<div class="pill-pane">

<%-- TODO Pass a value of create:true to edit view --%>
<button class="btn btn-primary btn-small" data-bind="click: createPersonForProject">Add a person</button>

<asset:javascript src="persons.js"/>

    <%-- <g:render template="/shared/pagination"/> --%>
    <div style="padding:40px" class="row well well-small" id="project-person-list">

        <%-- <form class="form-horizontal" id=""> --%>
            <div class="control-group">
                <label class="control-label" for="emailSearchFld">Search for a person by email address</label>
                <div class="controls">
                    <input class="input-xlarge" id="searchTerm"/>
                </div>
            </div>
            <div class="control-group">
                <div class="controls">
                    <button class="btn btn-primary btn-small" id="searchPersonBtn"><g:message code="g.search" /></button>
                    <%-- <g:img uri="${asset.assetPath(src:'spinner.gif')}" id="spinner2" class="hide spinner" alt="spinner icon"/>  --%>
                </div>
            </div>
        <%-- </form> --%>

        <div id="person-search" hidden>
            <table class="table table-striped table-bordered table-hover" id="person-search-table">
                <thead>
                <th>Personal code</th>
                <th>First name</th>
                <th>Last name</th>
                <th>Town</th>
                </thead>
            </table>
        </div>

        <table style="width: 95%;margin:30px" class="table table-striped table-bordered table-hover" id="person-list">
            <thead>
            <th id="personId">Volunteer code</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Email</th>
            <th>Town</th>
            <th width="5%"></th>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
    <div class="span5">
        <div id="formStatus" class="hide alert alert-success">
            <button class="close" onclick="$('.alert').fadeOut();" href="#">×</button>
            <span></span>
        </div>
    </div>
</div>
<asset:script type="text/javascript">

$(document).ready(function () {
    var personsListViewModel = new PersonsListViewModel("${project.projectId}");
    ko.applyBindings(personsListViewModel, document.getElementById("project-person-list"))


    self.viewPerson = function (personId) {
        document.location.href = fcConfig.personViewUrl + '/' + personId; 
    }
    
    var tableSearchResults;
    $('#searchPersonBtn').click(function(){
        var searchTerm = document.getElementById("searchTerm").value;
        console.log(searchTerm);
        var url = fcConfig.personSearchUrl + "&searchTerm=" + searchTerm;
        console.log(url)

            if (! $.fn.DataTable.isDataTable( '#person-search-table' )){
    
            $('#person-search').attr("hidden", false); 

            tableSearchResults = $('#person-search-table').DataTable({
                "ajax": {url: url, dataSrc: ''},
                "bFilter": false,
                "processing": true,
                "serverSide": true,
                "paging": false,
                "columns": [
                    {
                        data: 'personId',
                        name: 'personId'
                    },
                    {
                        data: 'firstName',
                        name: 'firstName'
                    },
                    {
                        data: 'lastName',
                        name: 'lastName',
                        bSortable: false
                    },
                    {
                        data: 'town',
                        name: 'town',
                        bSortable: false
                    }
                    ]
                });
            } else {        
                tableSearchResults.ajax.url(url).load()
            } 
    
            $('#person-search-table').on("click", "tr", function (e) {
                e.preventDefault();
                var rowData = tableSearchResults.row(this).data();
                console.log(rowData)
                var personId = rowData['personId'];
                console.log(personId)
                viewPerson(personId);
            });


    });
});

</asset:script>