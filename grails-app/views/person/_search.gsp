<div class="pill-pane">
    <div class="control-group">
        <button class="btn btn-primary" onclick="addPerson()"><g:message code="project.admin.members.addNew" /></button>
    </div>
    <!-- ko stopBinding: true-->
        <div id="person-search-div">
            <form class="form-horizontal input-append">
                <div class="well">
                    <label><g:message code="project.admin.members.searchLabel"/></label>
                    <input class="input input-append pull-left" type="text" class="span6" data-bind="value: searchTerm"/>
                    <button class="btn btn-primary form-control" data-bind="click: loadPersons">
                        <i class="icon-search icon-white"></i> <g:message code="g.search" />
                    </button>
                </div>
            </form>
            </br>
            <div id="personNotFound" class="offset2 span7 hide alert">
                <button class="close" onclick="$('.alert').fadeOut();" href="#">×</button><span></span>
            </div>
            <div class="well well-small" data-bind="visible: displayTable">
                <table class="table table-striped table-bordered table-hover" id="person-search-table">
                    <thead>
                        <th><g:message code="site.metadata.name"/></th>
                        <th><g:message code="person.personalInfo.town"/></th>
                        <th><g:message code="person.personalInfo.email"/></th>
                        <th><g:message code="person.personalInfo.mobile"/></th>
                        <th>ID</th>
                        <th><g:message code="person.personalInfo.internalId"/></th>            
                        <th width="3%"><g:message code="g.edit"/></th>
                    </thead>
                    <tbody data-bind="foreach: persons">
                        <tr>
                            <td><a href="#" data-bind="click: $parent.editPerson"><span data-bind="text: name"></a></td>
                            <td data-bind="text: town"></td>
                            <td data-bind="text: email"></td>
                            <td data-bind="text: mobileNum"></td>
                            <td data-bind="text: internalPersonId"></td>
                            <td data-bind="text: personId"></td>
                            <td><a href="#" data-bind="click: $parent.editPerson"><i class="fa fa-pencil"></i></a></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    <!-- /ko -->
</div>
<asset:javascript src="persons.js"/>
<asset:script type="text/javascript">
$(document).ready(function () {
    var personsListVM = new PersonsListViewModel;
    ko.applyBindings(personsListVM, document.getElementById("person-search-div"));

    function addPerson(){
        document.location.href = fcConfig.personCreateUrl + '&returnTo=' + fcConfig.returnTo; 
    }
});
</asset:script>