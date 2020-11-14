<bs:form inline="true" class="form-horizontal">
    <div id="messageSuccess" class="hide alert alert-success">
        <button class="close" onclick="$('#messageSuccess').fadeOut();" href="#">×</button>
        <span></span>
    </div>

    <div id="messageFail" class="hide alert alert-danger">
        <button class="close" onclick="$('#messageFail').fadeOut();" href="#">×</button>
        <span></span>
    </div>
    <form class="site-input input-append pull-left">
        <label><g:message code="project.admin.members.batchBookSites"/></label>
        <input id="bookedSitesInput" data-bind="value: person().sitesToBook, event: { change: splitSitesToBook }"  type="text" class="span12"/>
        <button class="btn btn-primary form-control" data-bind="click: bookSite"><g:message code="btn.book"/></button>
        <g:img uri="${asset.assetPath(src:'spinner.gif')}" id="spinner5" class="hide spinner" alt="spinner icon"/>
    </form>
    <%-- <div class="row-fluid">
        <div class="form-actions span12">
            <button type="button" id="goBack" class="btn"><g:message code="btn.backToProject"/></button>
        </div>
    </div> --%>
</bs:form>

<%-- TABLE showing what sites the person has booked and what they own  --%>

