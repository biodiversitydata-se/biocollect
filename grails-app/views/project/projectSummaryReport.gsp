<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="${hubConfig.skin}"/>
    <title>Project Summary | Project | MERIT</title>
    <script type="text/javascript" src="//www.google.com/jsapi"></script>
    <r:require modules="projects"/>
</head>

<body>
<div class="container">

    <h1>Project Summary</h1>


    <div class="overview">
        <div class="row-fluid">
            <div class="span3 title">Project Name</div>

            <div class="span9">${project.name}</div>
        </div>

        <div class="row-fluid">
            <div class="span3 title">Recipient</div>

            <div class="span9">${project.organisationName}</div>
        </div>

        <div class="row-fluid">
            <div class="span3 title">Project start</div>

            <div class="span9"><g:formatDate format="dd MMM yyyy"
                                             date="${au.org.ala.biocollect.DateUtils.parse(project.plannedStartDate).toDate()}"/></div>
        </div>

        <g:if test="${project.plannedEndDate}">
            <div class="row-fluid">
                <div class="span3 title">Project finish</div>

                <div class="span9"><g:formatDate format="dd MMM yyyy"
                                                 date="${au.org.ala.biocollect.DateUtils.parse(project.plannedEndDate).toDate()}"/></div>
            </div>
        </g:if>
    </div>

    <h3>Project Overview</h3>

    <p>${project.description}</p>

    <h3>Activity status summary</h3>

    <g:if test="${project.activities}">
        <div class="project-dashboard">
            <table class="table-striped">
                <thead>
                <tr>
                    <th>From</th>
                    <th>To</th>
                    <th>Description</th>
                    <th>Activity</th>
                    <th>Site</th>
                    <th>Status</th>
                </tr>
                </thead>
                <tbody>
                <g:each in="${project.activities}" var="activity">
                    <tr>
                        <td>${au.org.ala.biocollect.DateUtils.isoToDisplayFormat(activity.plannedStartDate)}</td>
                        <td>${au.org.ala.biocollect.DateUtils.isoToDisplayFormat(activity.plannedStartDate)}</td>
                        <td>${activity.description ?: ''}</td>
                        <td>${activity.type}</td>
                        <td>${activity.siteName}</td>
                        <td>${activity.progress}</td>
                    </tr>
                </g:each>

                </tbody>
            </table>
        </div>
    </g:if>
    <g:else>
        No activities have been defined for this project.
    </g:else>

    <g:render template="dashboard"/>

</div>

<r:script>
var project = <fc:modelAsJavascript model="${project}"/>;
ko.applyBindings(project.custom);

</r:script>
</body>
</html>