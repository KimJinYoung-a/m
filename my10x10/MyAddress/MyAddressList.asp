<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 마이텐바이텐 - 나의 주소록 - 국내
' History : 2014-09-01 이종화 생성
' History : 2015-04-29 유태욱 생성
'####################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/orderCls/clsMyAddress.asp" -->
<%
Dim openerYN	: openerYN	= req("openerYN","")

Dim tabListURL	: tabListURL = "popOldAddressList.asp"
Dim conListURL	: conListURL = "popMyAddressList.asp"
Dim conSaveURL	: conSaveURL = "popMyAddressSave.asp"
Dim conProcURL	: conProcURL = "popAddressProc.asp"

Dim i

Dim page		: page			= req("page",1)

Dim qString
qString = "openerYN=" & openerYN & "&countryCode=KR"
conProcURL = conProcURL & "?" & qString & "&page=" & page
conSaveURL = conSaveURL & "?" & qString & "&page=" & page
conListURL = conListURL & "?" & qString
tabListURL = tabListURL & "?" & qString

Dim obj	: Set obj = new clsMyAddress

obj.CurrPage	= page

obj.GetList "KR", "", getEncLoginUserID

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">
	function jsDelete(idx) {
		if (confirm("이 주소를 삭제하시겠습니까?")) {
			location.replace("<%=conProcURL%>&mode=DEL&openerYN=N&idx=" + idx);
		}
	}

	function jsAddAddr() {
		location.href="<%=conSaveURL%>&openerYN=N";
	}

	function jsModiAddr(idx) {
		location.href="<%=conSaveURL%>&openerYN=N&idx="+idx;
	}

	// 상품목록 페이지 이동
	function goPage(pg){
		var frm = document.frmsearch;
		frm.page.value=pg;
		frm.submit();
	}
</script>
</head>
<body>
<div class="heightGrid my-address-list">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
			<form name="frmsearch" method="post" action="MyAddressList.asp">
			<input type="hidden" name="page" value="1">
			</form>
				<div class="myTenNoti">
					<h2 class="tit01">나의 주소록</h2>
					<ul>
						<li>자주 사용하시는 배송지를 주소록에 등록해두면 편리합니다.</li>
						<li>10개까지 주소록을 등록하실 수 있습니다.</li>
					</ul>
				</div>
				<div class="inner10">
					<div class="tab02 tMar10">
						<ul class="tabNav tNum2 noMove">
							<li class="current"><a href="MyAddressList.asp">국내 주소록</a></li>
							<li><a href="SeaAddressList.asp">해외 주소록</a></li>
						</ul>
					</div>
					<ul class="boxList myAddress">
					<% If UBound(obj.Items) = 0 Then %>
						<li class="noData"><p>등록하신 주소록이 없습니다.</p></li>
					<% End If %>
					<% For i = 1 To UBound(obj.Items) %>
						<li>
							<div class="gryBar">
								<p><%=obj.Items(i).reqPlace%></p>
							</div>
							<div class="boxCont">
								<p><%=obj.Items(i).reqName%></p>
								<p><%=obj.Items(i).reqPhone%>&nbsp;&nbsp;<%=obj.Items(i).reqHp%></p>
								<p class="bPad10"><%=obj.Items(i).reqZipaddr%> <%=obj.Items(i).reqAddress%></p>
								<span class="button btS1 btWht cBk1"><a href="" onclick="jsModiAddr(<%=obj.Items(i).idx%>);return false;">수정</a></span>
								<span class="button btS1 btWht cBk1"><a href="" onclick="jsDelete(<%=obj.Items(i).idx%>);return false;">삭제</a></span>
							</div>
						</li>
					<% Next %>
					</ul>
					<%=fnDisplayPaging_New(obj.CurrPage,obj.TotalCount,obj.PageSize,4,"goPage")%>
				</div>
			</div>
			<div class="floatingBar">
				<div class="btnWrap">
					<div class="ftBtn"><span class="button btB1 btRed cWh1 w100p"><a href="" onclick="jsAddAddr(); return false;">국내주소록 신규등록</a></span></div>
				</div>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<%
Set obj = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
