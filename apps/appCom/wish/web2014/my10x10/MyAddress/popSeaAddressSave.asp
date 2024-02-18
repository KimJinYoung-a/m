<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
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
Else
	pageInfo1 = "UPD"
End If 

strPageTitle = "생활감성채널, 텐바이텐 > 나의 주소록 등록:해외 주소록"
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">
<script>
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
			alert("수령인명은 영문이나 숫자 부호만 입력하실 수 있습니다.");
			f.reqName.focus();
			return;
		}
		if (!checkAsc(f.reqZipcode.value))
		{
			alert("우편번호는 영문이나 숫자 부호만 입력하실 수 있습니다.");
			f.reqZipcode.focus();
			return;
		}
		if (!checkAsc(f.reqAddress.value))
		{
			alert("상세주소는 영문이나 숫자 부호만 입력하실 수 있습니다.");
			f.reqAddress.focus();
			return;
		}
		if (!checkAsc(f.reqZipaddr.value))
		{
			alert("도시 및 주는 영문이나 숫자 부호만 입력하실 수 있습니다.");
			f.reqZipaddr.focus();
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
	<div class="container">
		<!-- content area -->
		<div class="content mypage" id="contentArea">
			<!-- #content -->
			<div id="content">
				<div class="well type-b">
				<ul class="txt-list">
					<li><strong class="red">해외 배송지의 모든 정보는 꼭 영문 작성이 필요합니다.<br />(배송지명은 한글 가능) </strong></li>
				</ul>
			</div>
				<div class="inner">
					<div class="diff"></div>
					<div class="main-title">
						<h1 class="title"><span class="label">나의 해외 주소록  등록</span></h1>
					</div>
				</div>
				<form name="frmWrite" method="post" action="<%=conProcURL%>" onSubmit="return false;">
				<input type="hidden" name="mode">
				<input type="hidden" name="idx" value="<%=obj.Item.idx%>">
				<div class="diff"></div>
				<div class="inner">
					<div class="input-block">
						<label for="addressTitle" class="input-label">배송지명</label>
						<div class="input-controls">
							<input type="text" name="reqPlace" id="addressTitle" class="form full-size" value="<%=doubleQuote(obj.Item.reqPlace)%>">
						</div>
					</div>
					<div class="input-block">
						<label for="addressName" class="input-label">수령인명</label>
						<div class="input-controls">
							<input type="text" name="reqName" id="addressName" class="form full-size" value="<%=doubleQuote(obj.Item.reqName)%>">
						</div>
					</div>
					<div class="input-block">
						<label for="email" class="input-label">이메일</label>
						<div class="input-controls">
							<input type="email" id="email" name="reqEmail" class="form full-size" value="<%=doubleQuote(obj.Item.reqEmail)%>">
						</div>
					</div>

					<div class="input-block">
						<label for="country" class="input-label red">Country</label>
						<div class="input-controls country">
							<div>
								<select name="country" id="country1" class="form full-size" onchange="emsBoxChange(this);">
									<option value="">국가선택</option>
	                               <% for i=0 to oems.FREsultCount-1 %>
									<option value="<%= oems.FItemList(i).FcountryCode %>" iAreaCode="<%= oems.FItemList(i).FemsAreaCode %>" <%If oems.FItemList(i).FcountryCode = obj.Item.countryCode Then response.write "selected" %>><%= oems.FItemList(i).FcountryNameKr %>(<%= oems.FItemList(i).FcountryNameEn %>)</option>
									<% Next %>
								</select>
							</div>
							<div><input type="text" id="country2" name="countryCode" class="form full-size" value="<%=obj.Item.countryCode%>" maxlength="2" readOnly></div>
							<div><input type="text" id="country3" name="emsAreaCode" class="form full-size" value="<%=obj.Item.emsAreaCode%>" maxlength="1" readOnly></div>
							
						</div>
					</div>
					<div class="input-block">
						<label for="telNo" class="input-label red">Tel.No</label>
						<div class="input-controls telno">
							<div><input type="tel" id="phone1" class="form full-size" name="tel1" value="<%=tel1%>"></div>
							<div><input type="tel" id="phone2" class="form full-size" name="tel2" value="<%=tel2%>"></div>
							<div><input type="tel" id="phone3" class="form full-size" name="tel3" value="<%=tel3%>"></div>
							<div><input type="tel" id="phone4" class="form full-size" name="tel4" value="<%=tel4%>"></div>
						</div>
					</div>
					<em class="em">* 국가번호 – 지역번호 – 국번 - 전화번호</em>
					<div class="input-block">
						<label for="zipcode" class="input-label red">Zip code</label>
						<div class="input-controls">
							<input type="tel" class="form full-size" id="zipcode" name="reqZipcode" maxlength="20" value="<%=obj.Item.reqZipcode%>">
						</div>
					</div>
					<div class="input-block">
						<label for="addresds" class="input-label red">Address</label>
						<div class="input-controls">
							<input type="text" class="form full-size" id="addresds" name="reqAddress" value="<%=doubleQuote(obj.Item.reqAddress)%>">
						</div>
					</div>
					<div class="input-block">
						<label for="city" class="input-label red">City / State</label>
						<div class="input-controls">
							<input type="text" class="form full-size" id="city" name="reqZipaddr" value="<%=doubleQuote(obj.Item.reqZipaddr)%>">
						</div>
					</div>
				</div>
				<div class="form-actions highlight tMar20">
					<div class="two-btns">
						<div class="col"><button class="btn type-b full-size" onclick="jsaddrSubmit('<%=pageInfo1%>');return false;">등록</button></div>
						<div class="col"><button class="btn type-c full-size" onclick="history.back(0);return false;">취소</button></div>
					</div>
					<div class="clear"></div>
				</div>
				</form>
			</div><!-- #content -->
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</div>
</body>
</html>
<%
Set oems = Nothing 
Set obj = Nothing 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->