<div id="siteBookingAdmin" class="well">
    <form inline="true" class="form-horizontal" id="formSiteBookingAdmin">
    <h4><g:message code="project.admin.siteBooking.clickOnMap"/></h4>
        <div class="control-group">
            <%-- This value will update the site object's field 'bookedBy'  --%>
            <label class="control-label"><g:message code="project.admin.siteBooking.bookFor"/></label>
            <div class="controls">
                <input class="input-xlarge validate[required]" id="bookedBy" placeholder="${message(code:'project.admin.siteBooking.placeholder')}" type="text"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label"><g:message code="project.admin.siteBooking.siteName"/></label>
            <div class="controls">
                <input id="siteName" class="input-xlarge" disabled />
                <g:hiddenField id="siteId" name="siteId"/>
            </div>
        </div>
        <div class="control-group">
            <div class="controls">
                <input type="submit" id="btnBookForVolunteer" class="btn btn-primary form-control" value="${message(code:'btn.book')}"/>
            </div>
        </div>
    </form> 
    <label id="bookedByLink"></label>
    <div id="messageSuccess1" class="hide alert alert-success">
        <button class="close" onclick="$('#messageSuccess1').fadeOut();" href="#">×</button>
        <span></span>
    </div>

    <div id="messageFail1" class="hide alert alert-danger">
        <button class="close" onclick="$('#messageFail1').fadeOut();" href="#">×</button>
        <span></span>
    </div>
</div>   


<script>

$('#formSiteBookingAdmin').on('submit', function(e){
    e.preventDefault();
    var data = {
        internalPersonId: $("#bookedBy").val(),
        siteId: $("#siteId").val(),
        bookOne: true
        };

    $.ajax({
        url: fcConfig.bookSiteUrl,
        type: 'POST',
        data: JSON.stringify(data),
        contentType: 'application/json',
        success: function (data) {
            if (data.resp.message[0] != ""){
                $("#messageSuccess1 span").html(data.resp.message[0]).parent().fadeIn();
            } else if (data.resp.message[1] != ""){
                $("#messageFail1 span").html(data.resp.message[1]).parent().fadeIn();
            }
        },
        error: function (data) {
            e.preventDefault();
            var errorMessage = data.responseText || 'There was a problem saving this site'
            bootbox.alert(errorMessage);
        }
    });
});
</script>


