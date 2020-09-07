<div id="persons-surveys-form">

<g:if test="${outputs.size() != 0}">
    <table class="table table-striped table-bordered table-hover" id="persons-surveys">
        <thead>
        <th>Survey name</th>
        <th>Number</th>
        </thead>
        <g:each in="${outputs}">
        <tr>
            <td>
            <a href="#outputList" onclick="return loadOutputs('${person.personId}', '${it.key}')">
            ${it.key}</a>
            </td>
            <td>${it.value}</td>
        </tr>
        </g:each>
    </table>
</g:if>
<g:else>
   This person has not submitted any records.
</g:else>

    <div id="survey-list" hidden>
        <table class="table table-striped table-bordered table-hover" id="survey-list-table">
            <thead>
            <th>Date</th>
            <th>Site name</th>
            <th>Site code</th>
            <th>Period</th>
            </thead>

        </table>
    </div>

</div>

<asset:script>

    function reloadSurveys() {
        $('#survey-list-table').DataTable().ajax.reload();
    }

    var table;
    var loadOutputs = function(id, name){
        var url = fcConfig.getOutputForPersonBySurveyNameUrl + "/?id=" + id + '&name=' + encodeURI(name);

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
                        '<a class="margin-left-10" href="#" title="See full form">' 
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
                },
                {
                    data: 'period',
                    name: 'period',
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
            console.log(rowData)
            var activityId = rowData['activityId'];
            viewBioActivity(activityId);
        });

        var viewBioActivity = function (activityId){
            document.location.href = fcConfig.activityViewUrl + '/' + activityId; 
        }    
    }

</asset:script>
