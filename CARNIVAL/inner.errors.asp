<!--#include file = "includes/inc.first.asp"--><%

dim crn_errorCode, crn_id, crn_viaJs
crn_errorCode = request.QueryString("c")
crn_id = cleanLong(request.QueryString("id"))
if crn_id < 0 then crn_id = 0
crn_viaJs = true

%><!--#include file = "includes/gen.errors.asp"-->
	<div id="error" class="light">
		<div class="title"><%=crn_errTitle%></div>
		<div class="description"><%=crn_errDescription%></div>
		<div class="link"><%=crn_errLink%></div>
	</div>