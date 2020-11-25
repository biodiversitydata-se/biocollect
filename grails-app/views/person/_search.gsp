<div class="pill-pane">
<div class="control-group">
    <button class="btn btn-primary" data-bind="click: createPersonForProject"><g:message code="project.admin.members.addNew" /></button>
</div>
    <form class="form-horizontal input-append">
        <div class="well">
            <label><g:message code="project.admin.members.searchLabel"/></label>
            <input class="input input-append pull-left" type="text" class="span6" id="searchTerm"/>
            <button class="btn btn-primary form-control" id="searchPersonBtn">
                <i class="icon-search icon-white"></i> <g:message code="g.search" />
            </button>       
        </div>
    </form>

    <div class="well well-small" id="person-search" hidden>
        <table class="table table-striped table-bordered table-hover" id="person-search-table">
            <thead>
            <th><g:message code="site.metadata.name"/></th>
            <th><g:message code="person.personalInfo.id"/></th>
            <th><g:message code="person.personalInfo.town"/></th>
            <th width="3%"><g:message code="g.edit"/></th>
            </thead>
        </table>
    </div>
</div>
<asset:script type="text/javascript">

$(document).ready(function () {

    var viewPerson = function (personId) {
        document.location.href = fcConfig.personViewUrl + '&id=' + personId; 
    }
    var editPerson = function(personId) {
        document.location.href = fcConfig.personEditUrl + '&id=' + personId; 
    }
    
    var tableSearchResults;
    $('#searchPersonBtn').click(function(e){
        e.preventDefault();
        var searchTerm = document.getElementById("searchTerm").value;
        var url = fcConfig.personSearchUrl + "&searchTerm=" + searchTerm;

            if (! $.fn.DataTable.isDataTable( '#person-search-table' )){
    
            $('#person-search').attr("hidden", false); 

            tableSearchResults = $('#person-search-table').DataTable({
                "ajax": {url: url, dataSrc: ''},
                "bFilter": false,
                "info": "",
                "infoEmpty": "",
                "infoFiltered": "",
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
                        data: 'internalPersonId',
                        name: 'internalPersonId'
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
    
            $('#person-search-table').on("click", "tbody td:nth-child(1)", function (e) {
                e.preventDefault();
                var row = this.parentElement,
                 data = tableSearchResults.row(row).data(),
                 personId = data.personId;
                viewPerson(personId);
            });

            $('#person-search-table').on("click", "tbody td:nth-child(4)", function (e) {
                e.preventDefault();
                var row = this.parentElement,
                 data = tableSearchResults.row(row).data(),
                 personId = data.personId;
                editPerson(personId);
            });
    });
});

</asset:script>