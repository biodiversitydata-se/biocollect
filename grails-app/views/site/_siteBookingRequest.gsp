 <%-- Start of site request form  --%>
<div id="siteBookingRequest" class="well">
    <form inline="true" class="form-horizontal" id="formSiteBookingRequest">
        <h4><g:message code="project.admin.siteBooking.header"/></h4>
        <p><g:message code="project.admin.siteBooking.clickOnMap"/></p>
        <div class="control-group">
            <label class="control-label" for="siteName"><g:message code="project.admin.siteBooking.siteName"/></label>
            <div class="controls">
                <input class="input-xlarge" disabled id="siteName"/>
                <input type="button" id="btnAddToRequest" onclick="addSiteToRequest()" value="${message(code:'project.admin.siteBooking.addBtnLbl')}" class="btn btn-primary"/></button>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="requestedSitesList"><g:message code="project.admin.siteBooking.requestedSitesLbl"/></label>
            <div class="controls">
                <div>
                    <div class="table table-striped table-hover responsive-table-stacked no-footer" id="requestedSitesList" width="70%"></div>
                </div>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label"><g:message code='project.admin.siteBooking.requestMsgLbl'/></label>
            <div class="controls">
                <textarea class="input-xlarge" type="text"></textarea>
            </div>
        </div>
        <div class="control-group">
            <div class="controls">
                <input type="submit" id="btnRequestBooking" class="btn btn-primary form-control" value="${message(code:'g.submit')}"/>
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
var requestedSitesList = [];
var list = document.getElementById("requestedSitesList");

function addSiteToRequest(){
    var siteName = $("#siteName").val();
    if (!requestedSitesList.includes(siteName)){
        requestedSitesList.push(siteName);
        var row = document.createElement("tr");
        list.appendChild(row);
        var nameCell = document.createElement("td");
        nameCell.innerHTML = siteName;
        nameCell.value = siteName;
        row.appendChild(nameCell);
        var btnCell = document.createElement("td");
        row.appendChild(btnCell);
        var removeBtn = document.createElement("button");
        removeBtn.classList.add("btn", "btn-small");
        removeBtn.innerHTML = 'x';
        removeBtn.value = siteName
        btnCell.appendChild(removeBtn);
        removeBtn.addEventListener('click', removeSiteFromList)
    }
    return requestedSitesList;
}

function removeSiteFromList(){
    var cell = this.parentNode;
    cell.parentNode.remove();
    var currentSiteName = this.value;
    requestedSitesList = requestedSitesList.filter(function(item){
        return item != currentSiteName;
    })
}

$('#formSiteBookingRequest').on('submit', function(e){
    e.preventDefault();
    var data = {
        requestedSitesList: requestedSitesList.join(','),
        message: $("#message").val(),
        personEditUrl: fcConfig.personEditUrl,
        viewSiteUrl: fcConfig.viewSiteUrl,
        emailAddresses: ${project.alertConfig.emailAddresses}
    };

    if (data.requestedSitesList == ""){
        bootbox.alert("Du måste välja en rutt och klicka på knappen Lägg till");
    } else {
        $.ajax({
            url: fcConfig.submitBookingRequestUrl,
            type: 'POST',
            data:  JSON.stringify(data),
            contentType: 'application/json',
            success: function (data) {
                list.innerHTML = "";
                $("#siteName").val("");
                $('#btnAddToRequest').attr("disabled", "disabled");
                requestedSitesList = [];
                $("#messageSuccessfulRequest span").html(data.message).parent().fadeIn();
                $('#formSiteBookingRequest')[0].reset()
            },
            error: function (data) {
                var errorMessage = data.responseText || 'Tyvärr gick inte bokningsönskan att skicka'
                bootbox.alert(errorMessage);
            }
        })
    }
});

</script>