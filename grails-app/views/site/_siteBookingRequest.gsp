 <%-- Start of site request form  --%>
<div id="siteBookingRequest" class="well">
    <form inline="true" class="form-horizontal" id="formSiteBookingRequest">
        <h4><g:message code="project.admin.siteBooking.clickOnMap"/></h4>
        <div class="control-group">
            <label class="control-label" for="siteName"><g:message code="project.admin.siteBooking.siteName"/></label>
            <div class="controls">
                <input class="input-xlarge" disabled id="siteName"/>
                <g:hiddenField name="siteId" id="siteId"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label"><g:message code='project.admin.siteBooking.requestMsg'/></label>
            <div class="controls">
                <textarea class="input-xlarge" type="text"></textarea>
            </div>
        </div>
        <div class="control-group">
            <div class="controls">
                <input type="submit" id="btnRequestBooking" style="visibility:hidden" class="btn btn-primary form-control" value="${message(code:'btn.book')}"/>
            </div>
        </div>
    </form> 
    <div id="messageSuccessfulRequest" class="hide alert alert-success">
        <button class="close" onclick="$('#messageSuccessfulRequest').fadeOut();" href="#">×</button>
        <span></span>
    </div>
</div>   
 <%-- End of site booking form --%>

<script>

$('#formSiteBookingRequest').on('submit', function(e){
    e.preventDefault();
    var data = {
        siteId: $("#siteId").val(),
        siteName:$("#siteName").val(),
        message: $("#message").val(),
        personEditUrl: fcConfig.personEditUrl,
        viewSiteUrl: fcConfig.viewSiteUrl,
        emailAddresses: ${project.alertConfig.emailAddresses}
    };
    $.ajax({
        url: fcConfig.submitBookingRequestUrl,
        type: 'POST',
        data:  JSON.stringify(data),
        contentType: 'application/json',
        success: function (data) {
            // bootbox.alert("Your request has been sent to the admin. When the site is booked it will show on your homepage and you will receive a confirmation to your email address.");
            $("#messageSuccessfulRequest span").html(data.message).parent().fadeIn();
        },
        error: function (data) {
            var errorMessage = data.responseText || 'There was a problem while requesting this site'
            bootbox.alert(errorMessage);
        }
    })
});

</script>