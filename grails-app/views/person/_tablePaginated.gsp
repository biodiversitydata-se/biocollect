<div class="pill-pane">
<button class="btn btn-primary btn-small" data-bind="click: createPerson">Add a user</button>
<asset:javascript src="persons.js"/>
    <div class="row well well-small" id="project-person-list">
        <table style="width: 95%;" class="table table-striped table-bordered table-hover" id="person-list">
            <thead>
            <th>Volunteer code</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Sites</th>
            <th>Registered online</th>
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
    $(window).load(function () {
        initialisePersonsTable("${project.projectId}");
     })
</asset:script>