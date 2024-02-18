<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/orderCls/clsMyAddress.asp" -->
<%
Dim openerYN	: openerYN	= req("openerYN","")

Dim conListURL	: conListURL = "popMyAddressList.asp"
Dim conProcURL	: conProcURL = "popAddressProc.asp"

Dim i

Dim page		: page			= req("page",1)
Dim countryCode	: countryCode	= "KR"

Dim qString
qString = "openerYN=" & openerYN & "&countryCode=" & countryCode
conProcURL = conProcURL & "?" & qString & "&page=" & page
conListURL = conListURL & "?" & qString & "&page=" & page
    
Dim obj	: Set obj = new clsMyAddress

obj.GetData req("idx","")

Dim zip, zip1, zip2
zip = obj.Item.reqZipcode
'If UBound(zip) >= 1 Then
'	zip1 = zip(0)
'	zip2 = zip(1)
'End If 

Dim tel, tel1, tel2, tel3, tel4
tel = Split(obj.Item.reqPhone,"-")
If UBound(tel) >= 2 Then
	tel1 = tel(0)
	tel2 = tel(1)
	tel3 = tel(2)
End If 

Dim hp, hp1, hp2, hp3
hp = Split(obj.Item.reqHp,"-")
If UBound(hp) >= 2 Then
	hp1 = hp(0)
	hp2 = hp(1)
	hp3 = hp(2)
End If 

Dim fiximgPath
'이미지 경로 지정(SSL 처리)
if request.ServerVariables("SERVER_PORT_SECURE")<>1 then
	fiximgPath = "http://fiximage.10x10.co.kr"
else
	fiximgPath = "/fiximage"
end if

' 화면표시정보
Dim pageInfo1
If req("idx","") = "" Then 
	pageInfo1 = "INS"
Else
	pageInfo1 = "UPD"
End If 

strPageTitle = "생활감성채널, 텐바이텐 > 나의 주소록 등록:국내 주소록"
%>
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">
<script type="text/javascript">
	// 등록,수정,삭제 처리
	function jsaddrSubmit(mode)
	{
		var f = document.frmWrite;
		if (!mode)
			if (f.idx.value=="")
				f.mode.value = "INS";
			else
				f.mode.value = "UPD";
		else
			f.mode.value = mode;

		if (!validField(f.countryCode, "국가를"))	return ;
		if (!validField(f.reqName, "수령인명을"))		return ;

			if (!validField(f.hp1, "휴대폰번호를"))	return ;
			if (!validField(f.hp2, "휴대폰번호를"))	return ;
			if (!validField(f.hp3, "휴대폰번호를"))	return ;

		//if (!validField(f.tel1, "전화번호를"))	return ;
		//if (!validField(f.tel2, "전화번호를"))	return ;
		//if (!validField(f.tel3, "전화번호를"))	return ;
		if (!validField(f.zip, "우편번호를"))	return ;
		if (!validField(f.reqAddress, "상세주소를"))	return ;

		f.submit();

	}

	//주소찾기
	function searchzipBuyer(tmpurl){
		jsOpenModal(tmpurl);
	}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<!-- content area -->
		<form name="frmWrite" method="post" action="<%=conProcURL%>" onSubmit="return false;">
		<input type="hidden" name="mode">
		<input type="hidden" name="idx" value="<%=obj.Item.idx%>">
		<input type="hidden" name="countryCode" value="<%=countryCode%>" title="국가코드">
		<div class="content" id="contentArea">
			<div class="inner10 addressWt">
				<h2 class="hide">주소록 등록 및 수정</h2>
				<table class="writeTbl01 tMar10">
					<colgroup>
						<col width="19%" />
						<col width="" />
					</colgroup>
					<tbody>
						<tr>
							<th>배송지명</th>
							<td>
								<input type="text" name="reqPlace" id="addressTitle" class="w100p" maxlength="32" value="<%=doubleQuote(obj.Item.reqPlace)%>">
							</td>
						</tr>
						<tr>
							<th>수령인명</th>
							<td>
								<input type="text" name="reqName" id="addressName" class="w100p" value="<%=doubleQuote(obj.Item.reqName)%>">
							</td>
						</tr>
						<tr>
							<th>전화번호</th>
							<td>
								<input type="tel" id="phone1" class="w30p" name="tel1" maxlength="3" value="<%=tel1%>"> - 
								<input type="tel" id="phone2" class="w30p lMar05" name="tel2" maxlength="4" value="<%=tel2%>"> - 
								<input type="tel" id="phone3" class="w30p lMar05" name="tel3" maxlength="4" value="<%=tel3%>">
							</td>
						</tr>
						<tr>
							<th>휴대전화</th>
							<td>
								<input type="tel" id="hp1" class="w30p" name="hp1" maxlength="3" value="<%=hp1%>"> - 
								<input type="tel" id="hp2" class="w30p lMar05" name="hp2" maxlength="4" value="<%=hp2%>"> - 
								<input type="tel" id="hp3" class="w30p lMar05" name="hp3" maxlength="4" value="<%=hp3%>">
							</td>
						</tr>
						<tr>
							<th>주소</th>
							<td>
								<p>
									<input type="text" id="zipcode" class="w25p" name="zip" value="<%=zip%>" readOnly>
									<span class="button btB2 btGry cBk1 lMar05"><a href="" onclick="TnFindZipNew('frmWrite',''); return false;">우편번호 검색</a></span>
								</p>
								<p class="tPad05">
									<input type="text" id="memAddress03" class="w100p" readOnly name="reqZipaddr" value="<%=doubleQuote(obj.Item.reqZipaddr)%>">
								</p>
								<p class="tPad05">
									<input type="text" id="memAddress04" class="w100p" name="reqAddress" value="<%=doubleQuote(obj.Item.reqAddress)%>">
								</p>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="btnWrap tMar25">
					<div class="ftLt w50p"><span class="button btB1 btGry2 cWh1 w100p"><a href="" onclick="history.back(0);return false;">취소</a></span></div>
					<div class="ftRt w50p"><span class="button btB1 btRed cWh1 w100p"><a href="" onclick="jsaddrSubmit('<%=pageInfo1%>');return false;">등록</a></span></div>
				</div>
			</div>
		</div>
		</form>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</div>
</body>
</html>
<%
Set obj = Nothing 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->