<ul class="nav nav-pills" id="members-tab">
    <li><a href="#user-permissions" id="user-permissions-tab" data-toggle="tab"><g:message code="project.admin.users"/></a></li>
    <li><a href="#persons" id="persons-tab" data-toggle="tab"><g:message code="project.admin.persons"/></a></li>
</ul>

 <div class="tab-content">
    <div class="tab-pane" id="user-permissions">
        <div class="row-fluid">
            <g:render template="/admin/addPermissions" model="[addUserUrl:g.createLink(controller:'user', action:'addUserAsRoleToProject'), entityId:projectId]"/>
        </div>
        <div class="row-fluid">
            <g:render template="/person/linkUserToPerson" model="[updatePersonUrl:g.createLink(controller:'person', action:'update')]"/>
        </div>
        <div class="row-fluid">
            <g:render template="/admin/permissionTablePaginated"/>
        </div>
    </div>
    <div class="tab-pane" id="persons">
        <g:render template="/person/tablePaginated" model="[projectId: projectId]"/>
    </div>
</div>