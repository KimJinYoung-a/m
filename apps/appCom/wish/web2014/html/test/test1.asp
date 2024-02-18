<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'##################################################
' Description : test
' History : 2015-06-16 이종화 생성
'##################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/offshop/lib/classes/offshopCls.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script>
function testjstest(){
	var frm = document.myinfoForm;

	frm.target = "iframeDB1";
	frm.submit();

}

function js_gotest(){
fnAPPopenerJsCallClose('aaaa ');

alert(2);

//aaaa();
//	fnAPPopenerJsCallClose('jsgotest99(\'\')');
//	fnAPPpopupBrowserURL('마일리지 내역','<%=wwwUrl%>/apps/appCom/wish/web2014/offshop/point/mileagelist.asp');
//	fnAPPopenerJsCallClose('jsgotest99(\'\')');
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- content area -->
			<div class="content" id="contentArea">
				<form name="myinfoForm" method="post" action="<%=wwwUrl%>/apps/appcom/wish/web2014/html/test/test2.asp" >
					<p class="tMar20 ct"><span class="button btB1 btRed cWh1 w70p"><a href="" onclick="javascript:testjstest();return false;">테스트버튼</a></span></p>
				</div>
				</form>
				<%=now()%>
				<%=getLoginuserid%>
				<p class="tMar20 ct"><span class="button btB1 btRed cWh1 w70p"><a href="#" onclick="javascript:js_gotest();return false;">테스트버튼2</a></span></p>
				
				<p class="tMar20 ct"><span class="button btB1 btRed cWh1 w70p" onclick="javascript:js_gotest();return false;">테스트버튼3</span></p>
				
			</div>
			<!-- //content area -->
		</div>
	</div>
</div>
<iframe name="iframeDB1" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no"></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->