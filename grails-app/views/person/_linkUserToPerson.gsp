<form class="form-horizontal" id="userToPersonForm">
    <div class="control-group">
        <label class="control-label" for="linkingPersonId">Existing person ID to link</label>
        <div class="controls">
            <input class="input-xlarge" id="linkingPersonId" placeholder="enter person ID" type="text"/>
            <input class="input-xlarge" id="linkingUserId" disabled type="text"/>
        </div>
    </div>
    <div class="control-group">
        <div class="controls">
            <button id="linkUserToPersonBtn" class="btn btn-primary btn-small">Link</button>
            <g:img uri="${asset.assetPath(src:'spinner.gif')}" id="spinner2" class="hide spinner" alt="spinner icon"/>
        </div>
    </div>
</form>
<asset:script type="text/javascript">
        $(document).ready(function() {
        // combobox plugin enhanced select
        $(".combobox").combobox();
        console.log();

        // Click event on "add" button to add new user to project
        $('#linkUserToPersonBtn').click(function(e) {
            e.preventDefault();
            var personId = $('#linkingPersonId').val();
            var userId = $('#linkingUserId').val();
            console.log("person" , personId)
            console.log("user", userId);

            $("#spinner2").show();
            var data = { "userId": userId };
            <%-- console.log(data); --%>

            if (userId) {
                console.log( JSON.stringify(data))
            $.ajax({
                url: '${linkUserToPersonUrl}',
                <%-- contentType: 'application/json', --%>
                data: { userId: userId , personId: personId }
            })
            .done(function(result) { updateStatusMessage("person was added"); })
            .fail(function(jqXHR, textStatus, errorThrown) { alert(jqXHR.responseText); })
            .always(function(result) { resetAddForm(); });
        } else {
            alert("Required fields are: userId and role.");
            $('.spinner').hide();
        }

        });
    }); // end document ready

    function updateStatusMessage(msg) {
        $('#status span').text(''); // clear previous message
        $('#status span').text(msg).parent().fadeIn();
    }

</asset:script>