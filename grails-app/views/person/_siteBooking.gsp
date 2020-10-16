<bs:form inline="true" class="form-horizontal">
    <div id="messageSuccess" class="span7 hide alert alert-success" >
        <ul></ul>
    </div>
    <div id="messageFail" class="span7 hide alert alert-danger">
        <ul></ul>
    </div>
    <form class="site-input input-append pull-left">
        <label for=""><g:message code="project.admin.members.batchBookSites"/></label>
        <input id="bookedSitesInput" data-bind="value: person().bookedSites, event: { change: splitBookedSitesStr }"  type="text" class="span12"/>
        <button class="btn btn-primary form-control" data-bind="click: bookSite"><g:message code="btn.book"/></button>
        <g:img uri="${asset.assetPath(src:'spinner.gif')}" id="spinner5" class="hide spinner" alt="spinner icon"/>
    </form>
    <div class="row-fluid">
    <div class="form-actions span12">
        <button type="button" id="goBack" class="btn"><g:message code="btn.backToProject"/></button>
    </div>
    </div>
</bs:form>
