<div class="pill-pane">

<%-- TODO Pass a value of create:true to edit view --%>
<button class="btn btn-primary btn-small" data-bind="click: createPersonForProject">Add a person</button>

<asset:javascript src="persons.js"/>

    <%-- <g:render template="/shared/pagination"/> --%>
    <div class="row well well-small" id="project-person-list">
        <table style="width: 95%;margin:30px" class="table table-striped table-bordered table-hover" id="person-list">
            <thead>
            <th id="personId">Volunteer code</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Email</th>
            <th>Registered online</th>
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