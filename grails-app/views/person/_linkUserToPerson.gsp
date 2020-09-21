<form class="form-horizontal" id="userToPersonForm">
    <div class="control-group">
        <label class="control-label" for="linkingPersonId">Existing person ID to link</label>
        <div class="controls">
            <input class="input-xlarge validate[required]" id="linkingPersonId" type="text"/>
            <input class="input-xlarge" id="linkingUserId" disabled type="text"/>
        </div>
    </div>
    <div class="control-group">
        <div class="controls">
            <button id="linkUserToPersonBtn" class="btn btn-primary btn-small">Link</button>
            <g:img uri="${asset.assetPath(src:'spinner.gif')}" id="spinner2" class="hide spinner" alt="spinner icon"/>
        </div>
        <div class="controls">
        <div id="linkingStatus" class="offset2 span7 hide alert">
            <button class="close" onclick="$('.alert').fadeOut();" href="#">×</button>
            <span></span>
        </div>
        </div>
    </div>
</form>
<asset:script type="text/javascript">
        $(document).ready(function() {
        // combobox plugin enhanced select
        $(".combobox").combobox();

        // Click event on "add" button to link new user to person
        $('#linkUserToPersonBtn').click(function(e) {
            e.preventDefault();
            var personId = $('#linkingPersonId').val();
            var userId = $('#linkingUserId').val();
            var data = { "userId": userId };
            var url = "${updatePersonUrl}" + '/' + personId;

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
                        } else if (result.resp.status == 'error') {
                            $('#linkingStatus').removeClass("alert-success").addClass("alert-warning");
                            updateLinkingStatusMessage(result.resp.error);
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