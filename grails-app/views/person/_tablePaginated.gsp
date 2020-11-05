<div class="pill-pane">
<div class="control-group">
    <button class="btn btn-primary btn-small" data-bind="click: createPersonForProject"><g:message code="project.admin.members.addNew" /></button>
</div>
    <%-- <g:render template="/shared/pagination"/> --%>
    <form class="form-horizontal">
        <div class="control-group">
            <label class="control-label pull-left" for="searchTerm"><g:message code="project.admin.members.searchLabel"/></label>
            <div class="controls">
                <input class="input-xlarge" type="text" id="searchTerm"/>
            </div>
            <div class="controls">
                <button class="btn btn-primary form-control" id="searchPersonBtn"><g:message code="g.search" /></button>       
            </div>
        </div>
    </form>

    <div id="person-search" hidden>
        <table class="table table-striped table-bordered table-hover" id="person-search-table">
            <thead>
            <th><g:message code="site.metadata.name"/></th>
            <th><g:message code="project.admin.members.code"/></th>
            <th><g:message code="project.admin.members.town"/></th>
            <th width="3%"><g:message code="g.edit"/></th>
            </thead>
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
    
            $('#person-search-table').on("click", "tbody td:nth-child(1)", function (e) {
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