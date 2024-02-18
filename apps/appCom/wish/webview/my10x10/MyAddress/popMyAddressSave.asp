<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checklogin.asp" -->
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
zip = Split(obj.Item.reqZipcode,"-")
If UBound(zip) >= 1 Then
	zip1 = zip(0)
	zip2 = zip(1)
End If 

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

strPageTitle = "생활감성채널, 텐바이텐 > 나의 주소록 등록:국내 주소록"
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
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
		if (!validField(f.zip1, "우편번호를"))	return ;
		if (!validField(f.reqAddress, "상세주소를"))	return ;

		f.submit();

	}

	//주소찾기
	function searchzipBuyer(tmpurl){
		jsOpenModal(tmpurl);
	}
</script>
</head>
<body class="mypage">
    <!-- wrapper -->
    <div class="wrapper myinfo">
        <!-- #content -->
        <div id="content">
            <div class="inner">
                <div class="diff"></div>
                <div class="main-title">
                    <h1 class="title"><span class="label">나의 국내  주소록  등록</span></h1>
                </div>
            </div>      
            <div class="diff"></div>
            <form name="frmWrite" method="post" action="<%=conProcURL%>" onSubmit="return false;">
			<input type="hidden" name="mode">
			<input type="hidden" name="idx" value="<%=obj.Item.idx%>">
			<input type="hidden" name="countryCode" value="<%=countryCode%>" title="국가코드">
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
                    <label for="phone" class="input-label">전화번호</label>
                    <div class="input-controls phone">
                        <div><input type="tel" id="phone1" class="form" name="tel1" maxlength="3" value="<%=tel1%>"></div>
                        <div><input type="tel" id="phone2" class="form" name="tel2" maxlength="4" value="<%=tel2%>"></div>
                        <div><input type="tel" id="phone3" class="form" name="tel3" maxlength="4" value="<%=tel3%>"></div>
                    </div>
                </div>
				<div class="input-block">
                    <label for="hp" class="input-label">휴대폰</label>
                    <div class="input-controls phone">
                        <div><input type="tel" id="hp1" class="form" name="hp1" maxlength="3" value="<%=hp1%>"></div>
                        <div><input type="tel" id="hp2" class="form" name="hp2" maxlength="4" value="<%=hp2%>"></div>
                        <div><input type="tel" id="hp3" class="form" name="hp3" maxlength="4" value="<%=hp3%>"></div>
                    </div>
                </div>
				<div class="input-block">
                    <label for="zipcode" class="input-label">수령인 주소</label>
                    <div class="input-controls zipcode">
                        <div><input type="text" id="zipcode1" class="form full-size" name="zip1" value="<%=zip1%>" readOnly></div>
                        <div><input type="text" id="zipcode2" class="form full-size" name="zip2" value="<%=zip2%>" readOnly></div>
                        <a href="#" class="btn type-c btn-findzipcode side-btn" onclick="searchzipBuyer('/apps/appcom/wish/webview/lib/layer_searchzipNew.asp?strMode=MyAddress&target=frmWrite');return false;">우편번호검색</a>
                    </div>
                </div>
                <div class="input-block no-label">
                    <label for="memAddress03" class="input-label">주소2</label>
                    <div class="input-controls">
                        <input type="text" id="memAddress03" class="form full-size" readOnly name="reqZipaddr" value="<%=doubleQuote(obj.Item.reqZipaddr)%>">
                    </div>
                </div>
                <div class="input-block no-label">
                    <label for="memAddress04" class="input-label">주소3</label>
                    <div class="input-controls">
                        <input type="text" id="memAddress04" class="form full-size"  name="reqAddress" value="<%=doubleQuote(obj.Item.reqAddress)%>">
                    </div>
                </div>
            </div>   
            <div class="form-actions highlight">
                <div class="two-btns">
                    <div class="col"><a href="#" class="btn type-b" onclick="jsaddrSubmit('<%=pageInfo1%>');return false;">등록</a></div>
                    <div class="col"><a href="#" class="btn type-c" onclick="history.back(0);return false;">취소</a></div>
                </div>
                <div class="clear"></div>
            </div>
            </form>         
        </div><!-- #content -->

        <!-- #footer -->
        <footer id="footer">
            
        </footer><!-- #footer -->
        
    </div><!-- wrapper -->
	<!-- modal layer -->
	<div id="modalCont" style="display:none;"></div>
	
	<!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>
<%
Set obj = Nothing 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->