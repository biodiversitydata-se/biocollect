<div id="persons-surveys-form">
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

    <div id="survey-list" hidden>
        <table class="table table-striped table-bordered table-hover" id="survey-list-table">
            <thead>
            <th>Date</th>
            <th>Status</th>
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
            "pagination": false,
            "columns": [
                {
                    data: 'dateCreated',
                    name: 'dateCreated'
                },
                {
                    data: 'status',
                    name: 'status',
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
            console.log(activityId)
            viewBioActivity(activityId);
        });

        var viewBioActivity = function (activityId){
            document.location.href = fcConfig.activityViewUrl + '/' + activityId; 
        }
        
    }

</asset:script>
