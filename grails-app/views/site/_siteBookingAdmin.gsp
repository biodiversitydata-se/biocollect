<div id="siteBookingAdmin" class="well validationEngineContainer">
    <form inline="true" class="form-horizontal" id="formSiteBookingAdmin">

        <h4><g:message code="project.admin.siteBooking.header"/></h4>
        <p><g:message code="project.admin.siteBooking.clickOnMap"/></p>
        <div class="control-group">
            <label class="control-label"><g:message code="project.admin.siteBooking.bookFor"/></label>
            <div class="controls">
                <input class="input-xlarge validate[required]" id="bookedBy" placeholder="${message(code:'project.admin.siteBooking.placeholder')}" type="text"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="siteName"><g:message code="project.admin.siteBooking.siteName"/></label>
            <div class="controls">
                <input class="input-xlarge" disabled id="siteName"/>
                <g:hiddenField id="siteId" name="siteId"/>
                <input type="button" id="btnAddToBooking" onclick="addSiteToBooking()" disabled value="${message(code:'project.admin.siteBooking.addBtnLbl')}" class="btn btn-primary"/></button>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="listOfSitesToBook"><g:message code="project.admin.siteBooking.requestedSitesLbl"/></label>
            <div class="controls">
                <div>
                    <div class="table table-hover responsive-table-stacked no-footer" id="listOfSitesToBook" width="70%"></div>
                </div>
            </div>
        </div>
        <div class="control-group">
            <div class="controls">
                <input type="submit" id="btnSubmitBooking" style="visibility:hidden" class="btn btn-primary form-control" value="${message(code:'btn.book')}"/>
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
var listOfSitesToBook = [];
var list = document.getElementById("listOfSitesToBook");

function addSiteToBooking(){
    var siteName = $("#siteName").val(),
     siteId = $("#siteId").val(); 
    if (!listOfSitesToBook.includes(siteId)){
        listOfSitesToBook.push(siteId);
        var row = document.createElement("tr");
        list.appendChild(row);
        var nameCell = document.createElement("td");
        nameCell.innerHTML = siteName;
        nameCell.value = siteId;
        row.appendChild(nameCell);
        var btnCell = document.createElement("td");
        row.appendChild(btnCell);
        var removeBtn = document.createElement("button");
        removeBtn.classList.add("btn", "btn-small");
        removeBtn.innerHTML = 'x';
        removeBtn.value = siteId;
        btnCell.appendChild(removeBtn);
        removeBtn.addEventListener('click', removeSiteFromList)
    }
    listOfSitesToBook.length != 0 ? $('#btnSubmitBooking').css("visibility", "visible") : $('#btnSubmitBooking').css("visibility", "hidden");
    return listOfSitesToBook;
}

function removeSiteFromList(){
    var cell = this.parentNode;
    cell.parentNode.remove();
    var currentSiteId = this.value;
    listOfSitesToBook = listOfSitesToBook.filter(function(item){
        return item != currentSiteId;
    });
    listOfSitesToBook.length != 0 ? $('#btnSubmitBooking').css("visibility", "visible") : $('#btnSubmitBooking').css("visibility", "hidden");
}

$('#formSiteBookingAdmin').on('submit', function(e){
    e.preventDefault();
    if ($('#siteBookingAdmin').validationEngine()){
        var data = {
            internalPersonId: $("#bookedBy").val(),
            bookBySiteId: true,
            siteIds: listOfSitesToBook.join(',')
            };

        $.ajax({
            url: fcConfig.bookSiteUrl,
            type: 'POST',
            data: JSON.stringify(data),
            contentType: 'application/json',
            success: function (data) {
                if (data.resp.message[0] != ""){
                    $("#messageSuccess1 span").html(data.resp.message[0]).parent().fadeIn();
                    list.childNodes.forEach(function (child){
                        list.removeChild(child);
                    })
                    listOfSitesToBook = [];
                } else if (data.resp.message[1] != ""){
                    $("#messageFail1 span").html(data.resp.message[1]).parent().fadeIn();
                }
                $('#formSiteBookingAdmin')[0].reset();
            },
            error: function (data) {
                var errorMessage = data.responseText || 'There was a problem saving this site'
                bootbox.alert(errorMessage);
            }
        });
    }
});
</script>


