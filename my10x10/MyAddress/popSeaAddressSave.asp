<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 마이텐바이텐 - 나의 주소록 - 해외등록
' History : 2014-09-01 이종화 생성
'####################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/orderCls/clsMyAddress.asp" -->
<!-- #include virtual="/lib/classes/ordercls/emscls.asp" -->
<%
Dim openerYN	: openerYN	= req("openerYN","")

Dim conListURL	: conListURL = "popSeaAddressList.asp"
Dim conProcURL	: conProcURL = "popAddressProc.asp"

Dim i

Dim page		: page			= req("page",1)

Dim qString
qString = "openerYN=" & openerYN
conProcURL = conProcURL & "?" & qString & "&page=" & page
conListURL = conListURL & "?" & qString & "&page=" & page
    
Dim obj	: Set obj = new clsMyAddress

obj.PageBlock = "3"
obj.PageSize = "5"
obj.GetData req("idx","")

Dim tel, tel1, tel2, tel3, tel4
tel = Split(obj.Item.reqPhone,"-")
If UBound(tel) >= 3 Then
	tel1 = tel(0)
	tel2 = tel(1)
	tel3 = tel(2)
	tel4 = tel(3)
End If 


''EMS 관련
Dim oems : SET oems = New CEms

oems.FRectCurrPage = 1
oems.FRectPageSize = 100
oems.FRectisUsing  = "Y"
oems.GetServiceAreaList

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
<!doctype html>
<html lang="ko">
<head>
	<!-- #include virtual="/lib/inc/head.asp" -->
	<link rel="stylesheet" type="text/css" href="/lib/css/mytenten2013.css">
	<title>10x10: 나의 주소록 등록:해외 주소록</title>
	<script>
	// 등록,수정,삭제 처리
	function jsSubmit(mode)
	{
		var f = document.frmWrite;
		if (!mode)
			if (f.idx.value=="")
				f.mode.value = "INS";
			else
				f.mode.value = "UPD";
		else
			f.mode.value = mode;

		if (!validField(f.reqName, "수령인명을"))		return ;

		if (f.reqEmail.value)
			if (!validEmail(f.reqEmail))	return ;

		if (!validField(f.countryCode, "국가를"))	return ;

		if (!validField(f.tel3, "전화번호를"))	return ;
		if (!validField(f.tel4, "전화번호를"))	return ;
		if (!validField(f.reqZipcode, "우편번호를"))	return ;
		if (!validField(f.reqZipaddr, "도시 및 주 (City/State)를"))	return ;
		if (!validField(f.reqAddress, "상세주소 (Address)를"))	return ;

		if (!checkAsc(f.reqName.value))
		{
			alert("영문이나 숫자 부호만 입력하실 수 있습니다.");
			f.reqName.focus();
			return;
		}
		if (!checkAsc(f.reqZipcode.value))
		{
			alert("영문이나 숫자 부호만 입력하실 수 있습니다.");
			f.reqZipcode.focus();
			return;
		}
		if (!checkAsc(f.reqZipaddr.value))
		{
			alert("영문이나 숫자 부호만 입력하실 수 있습니다.");
			f.reqZipaddr.focus();
			return;
		}
		if (!checkAsc(f.reqAddress.value))
		{
			alert("영문이나 숫자 부호만 입력하실 수 있습니다.");
			f.reqAddress.focus();
			return;
		}
		f.submit();

	}

	function emsBoxChange(comp)
	{
		var f = document.frmWrite;    
		if (comp.value==''){
			f.countryCode.value = '';
			f.emsAreaCode.value = '';
		}else{
			f.countryCode.value = comp.value;
			f.emsAreaCode.value = comp[comp.selectedIndex].getAttribute("iAreaCode");
		}
	}
	</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="prevPage">
					<a href="" onclick="goBack('<%=conListURL%>'); return false;"><em class="elmBg">이전으로</em></a>
				</div>
				<!--마이텐바이텐-->
				<div id="my2">
					<div id="my2Tit">
						<h2>나의 주소록 등록</h2>
						<p class="tMar10"><span class="addtxtRed">해외 배송지 관련 모든 정보는 반드시 영문으로 작성하여주시기 바랍니다. (배송지명은 한글 가능)</span></p>
					</div>
					<form name="frmWrite" method="post" action="<%=conProcURL%>">
					<input type="hidden" name="mode">
					<input type="hidden" name="idx" value="<%=obj.Item.idx%>">		
					<div id="addsave">
						<div id="myshipInfo">
							<dl>
								<dt>배송지명</dt>
								<dd><input name="reqPlace" type="text" class="text" style="width:50%" value="<%=doubleQuote(obj.Item.reqPlace)%>"></dd>
								<dt>수령인명</dt>
								<dd><input name="reqName" type="text" class="text" style="width:50%" onkeyup="onlyAsc(this);" value="<%=doubleQuote(obj.Item.reqName)%>"></dd>
								<dt>수령인 E-mail</dt>
								<dd><input name="reqEmail" type="text" class="text" style="width:90%" value="<%=doubleQuote(obj.Item.reqEmail)%>"></dd>
							</dl>
							<dl>
								<dt class="cc91314">Country</dt>
								<dd>
									<select name="emsCountry" style="width:90px;" onChange="emsBoxChange(this);">
										<option value="">국가선택</option>
										<% for i=0 to oems.FREsultCount-1 %>
										<option value="<%= oems.FItemList(i).FcountryCode %>" iAreaCode="<%= oems.FItemList(i).FemsAreaCode %>" <%If oems.FItemList(i).FcountryCode = obj.Item.countryCode Then response.write "selected" %>><%= oems.FItemList(i).FcountryNameKr %>(<%= oems.FItemList(i).FcountryNameEn %>)</option>
										<% Next %>
									</select>
									<input name="countryCode" type="text" class="text gray" style="width:45px;" value="<%=obj.Item.countryCode%>" maxlength="2" readOnly /> <input name="emsAreaCode" type="text" class="text gray" style="width:39px;" value="<%=obj.Item.emsAreaCode%>" maxlength="1" readOnly/>
								</dd>
								<dt class="cc91314">Tel. No<br />(전화번호)</dt>
								<dd>
									<input name="tel1" maxlength="4" type="tel" class="text" style="width:30px;" value="<%=tel1%>" onkeydown="onlyNumber(this,event);"> - 
									<input name="tel2" maxlength="4" type="tel" class="text" style="width:35px;" value="<%=tel2%>" onkeydown="onlyNumber(this,event);"> - 
									<input name="tel3" maxlength="4" type="tel" class="text" style="width:40px;" value="<%=tel3%>" onkeydown="onlyNumber(this,event);"> - 
									<input name="tel4" maxlength="4" type="tel" class="text" style="width:40px;" value="<%=tel4%>" onkeydown="onlyNumber(this,event);">
									<p class="teltxt">국가번호 - 지역번호 - 국번 - 전화번호</p>
								</dd>
								<dt class="cc91314">Zip code<br />(우편번호)</dt>
								<dd><input name="reqZipcode" type="tel" class="text" style="width:90%" maxlength="20" value="<%=obj.Item.reqZipcode%>" onkeyup="onlyAsc(this);"></dd>
								<dt class="cc91314">Address<br />(주소)</dt>
								<dd><input name="reqAddress" type="text" class="text" style="width:90%" value="<%=doubleQuote(obj.Item.reqAddress)%>" onkeyup="onlyAsc(this);"></dd>
								<dt class="cc91314">City/State<br />(도시/주)</dt>
								<dd><input name="reqZipaddr" type="text" class="text" style="width:90%" value="<%=doubleQuote(obj.Item.reqZipaddr)%>" onkeyup="onlyAsc(this);"></dd>
							</dl>
						</div>
						<div class="btnArea fs16">
							<span class="btn btn1 redB w90B"><a href="" onclick="jsSubmit('<%=pageInfo1%>');return false;">확인</a></span>
							<span class="btn btn1 gryB w90B"><a href="" onclick="goBack('<%=conListURL%>'); return false;">취소</a></span>
						</div>
					</div>
					</form>
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
Set oems = Nothing 
Set obj = Nothing 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->