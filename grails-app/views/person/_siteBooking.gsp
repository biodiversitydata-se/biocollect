<bs:form inline="true" class="form-horizontal">
    <div id="bookingStatus"></div>
    <div class="site-input input-append pull-left">
        <label for=""><g:message code=""/>Enter the names of the sites<g:message code=""/></label>
        <input data-bind="value: person().bookedSites, event: { change: splitBookedSitesStr }"  type="text" class="span12"/>
        <button class="btn btn-primary" data-bind="click: bookSite">Book</button>
        <g:img uri="${asset.assetPath(src:'spinner.gif')}" id="spinner5" class="hide spinner" alt="spinner icon"/>
    </div>
</bs:form>