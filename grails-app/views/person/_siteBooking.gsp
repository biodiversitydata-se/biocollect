<bs:form inline="true" class="form-horizontal">
    <div id="bookingMessage" class="offset2 span7 hide alert alert-danger pull-left" >
        <ul></ul>
    </div>
    <div class="site-input input-append pull-left">
        <label for=""><g:message code="project.admin.members.batchBookSites"/></label>
        <input data-bind="value: person().bookedSites, event: { change: splitBookedSitesStr }"  type="text" class="span12"/>
        <button class="btn btn-primary" data-bind="click: bookSite"><g:message code="btn.book"/></button>
        <g:img uri="${asset.assetPath(src:'spinner.gif')}" id="spinner5" class="hide spinner" alt="spinner icon"/>
    </div>
    <div class="row-fluid">
    <div class="form-actions span12">
        <button type="button" id="goBack" class="btn"><g:message code="btn.backToProject"/></button>
    </div>
    </div>
</bs:form>
