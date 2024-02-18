<%@ Language=VBScript %>
<HTML>
<HEAD>

	<script type="text/javascript">
	
		function setLGDResult() {
			if( parent.LGD_window_type == "iframe" ){
				parent.setLGDResult();
			} else {
				opener.setLGDResult();
				window.close();
			}
		}
		
	</script>

</HEAD>

<body onload="setLGDResult()">

<%
	For Each i In Request.Form
        Response.Write "<input type=hidden id=" & i & " " & "value='" & Request.Form(i)  & "' >"
  	Next
%>

</BODY>
</HTML>
