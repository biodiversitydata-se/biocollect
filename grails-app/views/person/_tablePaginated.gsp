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
                <th>Name</th>
                <th>Personal code</th>
                <th>Town</th>
                <th width="3%">Edit</th>
                </thead>
            </table>
        </div>
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
    <%-- var personsListViewModel = new PersonsListViewModel("${project.projectId}"); --%>
    <%-- ko.applyBindings(personsListViewModel, document.getElementById("project-person-list")) --%>


    var viewPerson = function (personId) {
        document.location.href = fcConfig.personViewUrl + '&id=' + personId; 
    }
    var editPerson = function(personId) {
        document.location.href = fcConfig.personEditUrl + '&id=' + personId; 
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
                    mData: function (data, type, row) {
                        return '<div>' + 
                        '<a class="margin-left-10" href="#" title="Edit personal details or book sites">' 
                        + data.firstName + ' ' + data.lastName +
                        '</a></div>'; 
                        },
                    bSortable: false
                    },
                    {
                        data: 'personId',
                        name: 'personId'
                    },
                    {
                        data: 'town',
                        name: 'town',
                        bSortable: false
                    },
                    {
                    render: function (data, type, row) {
                        return '<div class="pull-right margin-right-20">' + 
                        '<a class="margin-left-10" href="" title="Edit personal details or book sites"><i class="fa fa-edit"></i></a>' 
                        + '</div>';
                        },
                    bSortable: false
                    }
                    ]
                });
            } else {        
                tableSearchResults.ajax.url(url).load()
            } 
    
            $('#person-search-table').on("click", "tbody td:nth-child(-n+2)", function (e) {
                e.preventDefault();
                var row = this.parentElement;
                var data = tableSearchResults.row(row).data();
                var personId = data.personId;
                viewPerson(personId);
            });

            $('#person-search-table').on("click", "tbody td:nth-child(4)", function (e) {
                e.preventDefault();
                var row = this.parentElement;
                var data = tableSearchResults.row(row).data();
                var personId = data.personId;
                editPerson(personId);
            });
    });
});

</asset:script>