<form class="form-horizontal" id="userToPersonForm">
    <div class="control-group">
        <label class="control-label" for="linkingPersonId"><g:message code="project.admin.members.internalIdLbl"/></label>
        <div class="controls">
            <input class="input-xlarge validate[required]" id="linkingPersonId" type="text"/>
            <input class="input-xlarge" id="linkingUserId" disabled type="text"/>
        </div>
    </div>
    <div class="control-group">
        <div class="controls">
            <button id="linkUserToPersonBtn" class="btn btn-primary btn-small"><g:message code="project.admin.members.link"/></button>
        </div>
    </div>
        <div id="linkingStatus" class="offset2 span7 hide alert">
            <button class="close" onclick="$('.alert').fadeOut();" href="#">×</button>
            <span></span>
        </div>

</form>
<asset:script type="text/javascript">
        $(document).ready(function() {
        // combobox plugin enhanced select
        $(".combobox").combobox();

        // Click event on "add" button to link new user to person
        $('#linkUserToPersonBtn').click(function(e) {
            e.preventDefault();
            var internalPersonId = $('#linkingPersonId').val(),
            userId = $('#linkingUserId').val(),
            data = { "userId": userId,  "internalPersonId": internalPersonId },
            url = "${linkUserToPersonUrl}";

            if ($('#userToPersonForm').validationEngine('validate')) {

            if (userId) {
                $.ajax({
                    url: url,
                    type: 'POST',
                    data: JSON.stringify(data),
                    contentType: 'application/json',
                    success: function(result) {
                        if(result.resp.status == 'ok'){
                            $('#linkingStatus').removeClass("alert-warning").addClass("alert-success");
                            updateLinkingStatusMessage(result.resp.personName + " has been linked to user ID");
                            resetLinkForm();
                        } else if (result.resp.status == 'notFound') {
                            $('#linkingStatus').removeClass("alert-success").addClass("alert-warning");
                            updateLinkingStatusMessage("Failed to link person - no such internal id:" + result.resp.internalPersonId);
                        } else if (result.resp.status == 'foundMany') {
                            $('#linkingStatus').removeClass("alert-success").addClass("alert-warning");
                            updateLinkingStatusMessage("There are multiple users with the same internal ID " + result.resp.internalPersonId);
                        }
                    }, 
                    error: function(result) { 
                        console.log(result);
                        $('#linkingStatus').addClass("alert-warning");
                        updateLinkingStatusMessage("Something went wrong.", result.statusCode);
                     }
                })
            } else {
                $('#linkingStatus').addClass("alert-warning");
                updateLinkingStatusMessage("You have to set this user's permissions first.")
            }
            }

        });
    }); 

    function resetLinkForm(){
        $('#linkingPersonId').val("");
        $('#linkingUserId').val("");
    }

    function updateLinkingStatusMessage(msg) {
        $('#linkingStatus span').text(''); // clear previous message
        $('#linkingStatus span').text(msg).parent().fadeIn();
    }

</asset:script>