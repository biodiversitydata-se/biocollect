
<style type="text/css" >
#surveyLink a {
    color:white;
    background:green;
    padding:10px
}

</style>
<div class="row-fluid" data-bind="visible:mainImageUrl">
    <div class="span12 banner-image-container">
        <img src="" data-bind="attr: {src: mainImageUrl}" class="banner-image"/>
        <div data-bind="visible:urlWeb" class="banner-image-caption"><strong><g:message code="g.visitUsAt" /> <a data-bind="attr:{href:urlWeb}"><span data-bind="text:urlWeb"></span></a></strong></div>
    </div>
</div>

<div id="weburl" data-bind="visible:!mainImageUrl()">
    <div data-bind="visible:urlWeb"><strong><g:message code="g.visitUsAt" /> <a data-bind="attr:{href:urlWeb}"><span data-bind="text:urlWeb"></span></a></strong></div>
</div>

<div class="container-fluid">
    <hr/>

    <div class="row-fluid" data-bind="">
        <div class="span6" id="column1">
            <div class="well span12">

                <div class="well-title">${hubConfig.getTextForAboutTheProject(grailsApplication.config.content.defaultOverriddenLabels)}</div>
                <div data-bind="if:isBushfire()" class="margin-top-1 margin-bottom-1">
                    <div class="alert alert-success">
                        <span class="fa fa-fire"></span> <g:message code="project.bushfireInfo"/>
                    </div>
                </div>

                <div data-bind="visible:aim">
                    <div class="text-small-heading">${hubConfig.getTextForAim(grailsApplication.config.content.defaultOverriddenLabels)}</div>
                    <span data-bind="text:aim"></span>

                </div>

                <div data-bind="visible:description">
                    <div class="text-small-heading">${hubConfig.getTextForDescription(grailsApplication.config.content.defaultOverriddenLabels)}</div>
                    <span data-bind="html:description.markdownToHtml()"></span>
                </div>
                <g:if test="${hubConfig?.content?.hideProjectAboutOriginallyRegistered != true}">
                <div data-bind="visible: origin">
                    <div class="text-small-heading"><g:message code="project.display.origin" /></div>
                    <span data-bind="text:origin"></span>
                    <p/>
                </div>
                </g:if>


                <g:if test="${hubConfig?.content?.hideProjectAboutContributing != true}">
                    <div data-bind="visible:!isExternal()" class="margin-top-1 margin-bottom-1">
                        <img src="${asset.assetPath(src: "ala-logo-small.png")}" class="logo-icon" alt="Atlas of Living Australia logo"><g:message code="project.contributingToALA"/>
                    </div>
                </g:if>

            </div>
        </div>
        <div class="span6" id="column2">
            <div class="well">
                <div class="well-title" data-bind="visible:projectType() == 'survey'"><g:message code="project.display.involved" /></div>
                <div class="well-title" data-bind="visible:projectType() != 'survey'">${hubConfig.getTextForProjectInformation(grailsApplication.config.content.defaultOverriddenLabels)}</div>
                <div data-bind="visible:getInvolved">
                    <div data-bind="html:getInvolved.markdownToHtml()"></div>
                    <p/>
                </div>
                <div class="row-fluid">
                    <div class="span6">
                        %{-- TODO: swap fields. check issue - biocollect#667 --}%
                        <div data-bind="visible:managerEmail">
                            <div class="text-small-heading"><g:message code="project.display.contact.name" /></div>
                            <span data-bind="text:managerEmail"></span>
                            <p/>
                        </div>
                        <div data-bind="visible:manager">
                            <div class="text-small-heading"><g:message code="project.display.contact.email" /></div>
                            <a data-bind="attr:{href:'mailto:' + manager()}"><span data-bind="text:manager"></span></a>
                            <p/>
                        </div>
                        %{-- TODO END--}%
                    </div>
                </div>
                <hr id="hrGetStartedMobileAppTag" data-bind="visible: transients.checkVisibility('#contentGetStartedMobileAppTag', '#hrGetStartedMobileAppTag')" />
                <div id="contentGetStartedMobileAppTag">
                    <div class="row-fluid">
                        <g:if test="${!mobile}">
                        <div id="surveyLink" class="span4 pull-right" data-bind="visible:transients.daysRemaining() != 0 && (!isExternal() || urlWeb()) && projectType() == 'survey' ">
                            <a class="btn pull-right" data-bind="showTabOrRedirect: { url: isExternal() ? urlWeb() : '', tabId: '#activities-tab'}"><g:message code="project.display.join" /></a>
                            <p class="clearfix"/>
                        </div>
                        </g:if>
                    </div>
                    <g:render template="/shared/listDocumentLinks"
                              model="${[transients:transients,imageUrl:asset.assetPath(src:'filetypes')]}"/>
                    <p/>
                    <div style="line-height:2.2em">
                        <g:render template="tags" />
                    </div>

                </div>
            </div>
        </div>
    </div>

    <div class="image-attribution-panel" data-bind="visible: logoAttributionText() || mainImageAttributionText()">
        <strong>Image credits</strong>: <span data-bind="visible: logoAttributionText()">Logo: <span data-bind="text: logoAttributionText()"></span>;&nbsp;</span>
        <span data-bind="visible: mainImageAttributionText()">Feature image: <span data-bind="text: mainImageAttributionText()"></span></span>
    </div>
</div>
<asset:script type="text/javascript">


</asset:script>
