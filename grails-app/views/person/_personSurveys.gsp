<div id="persons-surveys-form">

<g:if test="${activityCount?.size() != 0}">
    <table class="table table-striped table-bordered table-hover" id="persons-surveys">
        <thead>
        <th><g:message code="site.details.surveyName"/></th>
        <th><g:message code="g.number"/></th>
        </thead>
        <g:each in="${activityCount}">
        <tr>
            <td>
            <a href="#activityList" onclick="return loadOutputs('${person.personId}', '${it.key}')">
            ${it.key}</a>
            </td>
            <td>${it.value}</td>
        </tr>
        </g:each>
    </table>
</g:if>
<g:else>
   <g:message code="project.admin.members.norecords"/>
</g:else>

    <div id="survey-list" hidden>
        <table class="table table-striped table-bordered table-hover" id="survey-list-table">
            <thead>
            <th><g:message code="g.date"/></th>
            <th><g:message code="site.details.siteName"/></th>
            <th><g:message code="site.details.siteName"/></th>
            </thead>
        </table>
    </div>

</div>

<asset:script>

    function reloadSurveys() {
        $('#survey-list-table').DataTable().ajax.reload();
    }

    var table;
    var loadOutputs = function(personId, type){
        var url = fcConfig.getActivitiesForPersonByTypeUrl + "&personId=" + personId + '&type=' + encodeURI(type);

        if (! $.fn.DataTable.isDataTable( '#survey-list-table' )){

            $('#survey-list').attr("hidden", false); 

            table = $('#survey-list-table').DataTable({
            "ajax": {"url": url, "dataSrc": ""},
            "bFilter": false,
            "processing": true,
            "serverSide": true,
            "paging": false,
            "columns": [
                {
                    data: 'dateCreated',
                    name: 'dateCreated',
                    render: function (data, type, row) {
                        return '<div>' + 
                        '<a class="margin-left-10" href="#">' 
                        + data +
                        '</a></div>';
                    }
                },
                {
                    data: 'siteName',
                    name: 'siteName',
                    bSortable: false
                },
                {
                    data: 'siteCode',
                    name: 'siteCode',
                    bSortable: false
                }
                ]
            });
        } else {        
            table.ajax.url(url).load()
        }

        $('#survey-list-table').on("click", "tr", function (e) {
            e.preventDefault();
            var rowData = table.row(this).data();
            var activityId = rowData['activityId'];
            viewBioActivity(activityId);
        });

        var viewBioActivity = function (activityId){
            document.location.href = fcConfig.viewActivityUrl + '/' + activityId; 
        }    
    }

</asset:script>
