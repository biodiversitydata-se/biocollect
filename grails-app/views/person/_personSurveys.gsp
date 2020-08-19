<div id="persons-surveys-form">
    <table class="table table-striped table-bordered table-hover" id="persons-surveys">
        <thead>
        <th>Survey name</th>
        <th>Number</th>
        </thead>
        <g:each in="${outputs}">
        <tr>
            <td>
            <%-- <a href="${createLink(controller: "output", action: "getOutputsForPerson")}' + '/' + person.personId}">TODO</a> --%>
            ${it.key}</td>
            <td>${it.value}</td>
        </tr>
        </g:each>
    </table>
</div>

