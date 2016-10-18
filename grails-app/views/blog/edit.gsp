<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="${hubConfig.skin}"/>
    <title>Edit | Blog Entry | Field Capture</title>
    <script type="text/javascript" src="${grailsApplication.config.google.maps.url}"></script>
    <r:script disposition="head">
        var fcConfig = {
            serverUrl: "${grailsApplication.config.grails.serverURL}",
            blogUpdateUrl: "${grailsApplication.config.grails.serverURL}/blog/update?id=${blogEntry.blogEntryId}",
            blogViewUrl: "${grailsApplication.config.grails.serverURL}/blog/index",
            documentUpdateUrl: "${grailsApplication.config.grails.serverURL}/document/documentUpdate",
            returnTo: "${params.returnTo}"
            };
    </r:script>
    <r:require modules="knockout,jqueryValidationEngine,datepicker,jQueryFileUpload,amplify,wmd"/>

</head>
<body>
<div class="${containerType}">
    <ul class="breadcrumb">
        <li>
            <g:link controller="home">Home</g:link> <span class="divider">/</span>
        </li>
        <g:if test="${params.projectId}">
            <g:link controller="project" id="${params.projectId}">Project </g:link>  <span class="divider"> / </span></li>
        </g:if>
        <li class="active">Edit blog entry</li>
    </ul>

    <g:render template="editBlogEntry"/>

    <div class="form-actions">
        <button type="button" id="save" data-bind="click:save" class="btn btn-primary">Save</button>
        <button type="button" id="cancel" data-bind="click:cancel" class="btn">Cancel</button>
    </div>
</div>

<r:script>

var EditableBlogEntryViewModel = function(blogEntry, options) {

    var defaults = {
        validationElementSelector:'.validationEngineContainer',
        types:['News and Events', 'Project Stories'],
        returnTo:fcConfig.returnTo,
        blogUpdateUrl:fcConfig.blogUpdateUrl
    };

    var config = $.extend(defaults, options);
    var self = this;
    var now = convertToSimpleDate(new Date());
    self.blogEntryId = ko.observable(blogEntry.blogEntryId);
    self.projectId = ko.observable(blogEntry.projectId || undefined);
    self.title = ko.observable(blogEntry.title || '');
    self.date = ko.observable(blogEntry.date || now).extend({simpleDate:false});
    self.content = ko.observable(blogEntry.content);
    self.stockIcon = ko.observable(blogEntry.stockImageName);
    self.documents = ko.observableArray();
    self.image = ko.observable();
    self.type = ko.observable(blogEntry.type);
    self.viewMoreUrl = ko.observable(blogEntry.viewMoreUrl).extend({url:true});

    self.imageUrl = ko.computed(function() {
        if (self.image()) {
            return self.image().url;
        }
    });
    self.imageId = ko.computed(function() {
        if (self.image()) {
           return self.image().documentId;
        }
    });
    self.documents.subscribe(function() {
        if (self.documents()[0]) {
           self.image(new DocumentViewModel(self.documents()[0]));
        }
        else {
            self.image(undefined);
        }
    });
    self.removeBlogImage = function() {
        self.documents([]);
    };

    self.modelAsJSON = function() {
        var js = ko.mapping.toJS(self, {ignore:['transients', 'documents', 'image', 'imageUrl']});
        if (self.image()) {
            js.image = self.image().modelForSaving();
        }
        return JSON.stringify(js);
    };

    self.editContent = function() {
        editWithMarkdown('Blog content', self.content);
    };

    self.save = function() {
        if ($(config.validationElementSelector).validationEngine('validate')) {
            self.saveWithErrorDetection(
                function() {document.location.href = config.returnTo},
                function(data) {bootbox.alert("Error: "+data.responseText);}
            );
        }
    };

    self.cancel = function() {
        document.location.href = config.returnTo;
    };

    self.transients = {};
    self.transients.blogEntryTypes = config.types;

    if (blogEntry.documents && blogEntry.documents[0]) {
        self.documents.push(blogEntry.documents[0]);
    }
    $(config.validationElementSelector).validationEngine();
    autoSaveModel(self, config.blogUpdateUrl, {blockUIOnSave:true});
};

    $(function () {
        var blogEntry = <fc:modelAsJavascript model="${blogEntry}" default="{}"/>;
        var blogEntryViewModel = new EditableBlogEntryViewModel(blogEntry, '.validationEngineContainer');

        ko.applyBindings(blogEntryViewModel);

        $('.helphover').popover({animation: true, trigger:'hover'});
    });



</r:script>

</body>


</html>