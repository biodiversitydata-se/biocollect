<div class="pill-pane">

<%-- TODO Pass a value of create:true to edit view --%>
<button class="btn btn-primary btn-small" data-bind="click: createPersonForProject">Add a person</button>

<asset:javascript src="persons.js"/>

    <%-- <g:render template="/shared/pagination"/> --%>
    <div style="padding:40px" class="row well well-small" id="project-person-list">

        <form class="form-horizontal" id="personSearch">
        <div class="control-group">
            <label class="control-label" for="emailSearchFld">Search by name or code</label>
            <div class="controls">
                <input class="input-xlarge" id="emailSearchFld" placeholder="search for a person" type="text"/>
            </div>
        </div>
        <div class="control-group">
            <div class="controls">
                <button id="searchPerson" class="btn btn-primary btn-small"><g:message code="g.search" /></button>
                <g:img uri="${asset.assetPath(src:'spinner.gif')}" id="spinner1" class="hide spinner" alt="spinner icon"/>
            </div>
        </div>
        </form>
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
            <%-- TODO when clicked on a name, pass a value of create:false to edit view 
            --%>

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
    })

</asset:script>