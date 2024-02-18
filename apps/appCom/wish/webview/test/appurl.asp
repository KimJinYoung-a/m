<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'##################################################################	
' appurl ,카테고리 ,브랜드 랜딩 페이지
' 2014-08-21 이종화
'##################################################################
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<%
	Dim param1 , param2

		param1 = request("param1")
		param2 = request("param2")

%>
<body>
<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
<script>
	window.onload = function() {
		<% if param1 ="3" then %>
			$.ajax({
				url: '/apps/appCom/wish/webview/lib/act_getBrandUrl.asp?<%=param2%>',
				cache: false,
				success: function(message) {
					if(message!="") {
						top.window.location.href = "custom://brandproduct.custom?" + message;
					}
				}
			});
		<% end if %>
		<% if param1 ="4" then %>
			top.window.location.href = "custom://opencategory.custom?<%=param2%>";
		<% end if %>
	}
</script>
</body>
</html>