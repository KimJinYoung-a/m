<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 마이텐바이텐 - 나의 주소록 - 국내등록
' History : 2014-09-01 이종화 생성
' History : 2015-04-29 유태욱 생성
'####################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
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
'zip = Split(obj.Item.reqZipcode,"-")
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
Dim pageInfo1, pageInfo2, pageInfo3
If req("idx","") = "" Then 
	pageInfo1 = "INS"
	pageInfo2 = "<img src='" & fiximgPath & "/web2009/order/myadd_title_addnew.gif'>"
	pageInfo3 = "<img src='" & fiximgPath & "/web2009/order/btn_write02.gif'>"
Else
	pageInfo1 = "UPD"
	pageInfo2 = "<img src='" & fiximgPath & "/web2009/order/myadd_title_addmodify.gif'>"
	pageInfo3 = "<img src='" & fiximgPath & "/web2009/order/btn_modiry02.gif'>"
End If 
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">
// 등록,수정,삭제 처리
function jsSubmit(mode) {
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
	//if (!validField(f.reqAddress, "상세주소를"))	return ;

	f.submit();

}

function searchZipcode(frmName) {
	fnOpenModal('/lib/pop_searchzipnew.asp?target='+frmName);
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<form name="frmWrite" method="post" action="<%=conProcURL%>">
			<input type="hidden" name="mode">
			<input type="hidden" name="idx" value="<%=obj.Item.idx%>">
			<input type="hidden" name="countryCode" value="<%=countryCode%>" title="국가코드">
			<div class="content" id="contentArea">
				<div class="inner10 addressWt">
					<h2 class="tit01 tMar20">주소록 등록 및 수정</h2>
					<table class="writeTbl01 tMar10">
						<colgroup>
							<col width="19%" />
							<col width="" />
						</colgroup>
						<tbody>
							<tr>
								<th>배송지명</th>
								<td><input name="reqPlace" type="text" class="w100p" maxlength="32" value="<%=doubleQuote(obj.Item.reqPlace)%>"></td>
									
							</tr>
							<tr>
								<th>수령인명</th>
								<td><input name="reqName" type="text" class="w100p" maxlength="32" value="<%=doubleQuote(obj.Item.reqName)%>"></td>
									
							</tr>
							<tr>
								<th>전화번호</th>
								<td>
									<input name="tel1" type="tel" class="w30p" maxlength="3" value="<%=tel1%>" onkeydown="onlyNumber(this,event);"> - 
									<input name="tel2" type="tel" class="w30p lMar05" maxlength="4" value="<%=tel2%>" onkeydown="onlyNumber(this,event);"> - 
									<input name="tel3" type="tel" class="w30p lMar05" maxlength="4" value="<%=tel3%>" onkeydown="onlyNumber(this,event);">
								</td>
							</tr>
							<tr>
								<th>휴대전화</th>
								<td>
									<input name="hp1" type="tel" class="w30p" maxlength="3" value="<%=hp1%>" onkeydown="onlyNumber(this,event);"> - 
									<input name="hp2" type="tel" class="w30p lMar05" maxlength="4" value="<%=hp2%>" onkeydown="onlyNumber(this,event);"> - 
									<input name="hp3" type="tel" class="w30p lMar05" maxlength="4" value="<%=hp3%>" onkeydown="onlyNumber(this,event);">
								</td>
							</tr>
							<tr>
								<th>주소</th>
								<td>
									<p>
										<input type="text" id="zip" class="w25p" title="우편번호" name="zip" value="<%=zip%>" readOnly/> 
										<span class="button btB2 btGry cBk1 lMar05"><a href="" onclick="searchZipKakao('searchZipWrap','frmWrite'); return false;">우편번호 검색</a></span>
									</p>
									<p id="searchZipWrap" style="display:none;border:1px solid;width:100%;height:300px;margin:5px 0;position:relative">
										<img src="//fiximage.10x10.co.kr/m/2019/common/btn_delete.png" id="btnFoldWrap" style="cursor:pointer;position:absolute;right:0px;top:-36px;z-index:1;width:35px;height:35px;" onclick="foldDaumPostcode('searchZipWrap')" alt="접기 버튼">
									</p>									
									<style>
										.inp-box {display:block; padding:0.4rem 0.6rem; font-size:13px; color:#888; border-radius:0.2rem; border:1px solid #cbcbcb; width:100%;}
									</style>										
									<p class="tPad05">
										<textarea name="reqZipaddr" id="memAddress03" title="주소" ReadOnly class="inp-box" ><%=doubleQuote(obj.Item.reqZipaddr)%></textarea>
									</p>

									<p class="tPad05">
										<input name="reqAddress" type="text" id="memAddress04" value="<%=doubleQuote(obj.Item.reqAddress)%>" class="w100p" title="자세한 주소를 입력해주세요" />
									</p>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="btnWrap tMar25">
						<div class="ftLt w50p"><span class="button btB1 btGry2 cWh1 w100p"><a href="" onclick="goBack('<%=conListURL%>'); return false;">취소</a></span></div>
						<div class="ftRt w50p"><span class="button btB1 btRed cWh1 w100p"><a href="" onclick="jsSubmit('<%=pageInfo1%>');return false;">등록</a></span></div>
					</div>
				</div>
			</div>
			</form>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
<form name="tranFrmApi" id="tranFrmApi" method="post">
	<input type="hidden" name="tzip" id="tzip">
	<input type="hidden" name="taddr1" id="taddr1">
	<input type="hidden" name="taddr2" id="taddr2">
	<input type="hidden" name="extraAddr" id="extraAddr">
</form>
</body>
</html>
<%
Set obj = Nothing 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->