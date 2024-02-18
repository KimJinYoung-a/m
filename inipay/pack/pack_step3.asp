<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	History	:  2015.11.09 한용민 생성
'	History	:  2016-04-08 이종화 디자인 리뉴얼
'	Description : 포장 서비스
'#######################################################
%>
<!-- #include virtual="/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->

<%
dim midx
	midx = getNumeric(requestcheckvar(request("midx"),10))

dim userid, guestSessionID, i, j, isBaguniUserLoginOK
If IsUserLoginOK() Then
	userid = getEncLoginUserID ''GetLoginUserID
	isBaguniUserLoginOK = true
Else
	userid = GetLoginUserID
	isBaguniUserLoginOK = false
End If
guestSessionID = GetGuestSessionKey

dim vShoppingBag_checkset
	vShoppingBag_checkset=0

vShoppingBag_checkset = getShoppingBag_checkset("TT")		'실제 장바구니 수량		TT:텐배

'if not(isBaguniUserLoginOK) then
'	response.write "<script type='text/javascript'>alert('회원전용 서비스 입니다. 로그인을 해주세요.');</script>"
'	dbget.close()	:	response.end
'end if

if midx="" then
	response.write "<script type='text/javascript'>alert('일렬번호가 없습니다.');</script>"
	dbget.close()	:	response.end
end if

'//선물포장 임시 패킹 리스트
dim opackmaster
set opackmaster = new Cpack
	opackmaster.FRectUserID = userid
	opackmaster.FRectSessionID = guestSessionID
	opackmaster.frectmidx = midx
	opackmaster.Getpojangtemp_master()

if opackmaster.FResultCount < 1 then
	response.write "<script type='text/javascript'>alert('해당 선물 포장 내역이 없습니다.');</script>"
	dbget.close()	:	response.end
end if
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">

function pojangcomplete(){
    self.close();
}

function gostep1(){
	pojangfrm.mode.value='reset_step1';
	pojangfrm.reload.value='ON';
	pojangfrm.action = "/inipay/pack/pack_step1.asp";
	pojangfrm.submit();
	return;
}

//마우스 오른쪽 클릭 막음		//2015.12.15 한용민 생성
window.document.oncontextmenu = new Function("return false");
//새창 띄우기 막음		//2015.12.15 한용민 생성
window.document.onkeydown = function(e){    	//Crtl + n 막음
    if(typeof(e) != "undefined"){
        if((e.ctrlKey) && (e.keyCode == 78)) return false;
    }else{
        if((event.ctrlKey) && (event.keyCode == 78)) return false;
    }
}
//드레그 막음		//2015.12.15 한용민 생성
window.document.ondragstart = new Function("return false");

</script>
</head>
<body>
<div class="heightGrid bgGry">
	<div class="container popWin pkgV16a04">
		<div class="header">
			<h1>선물포장</h1>
			<p class="btnPopClose"><button class="pButton" onclick="window.close();">닫기</button></p>
		</div>
		<div class="content" id="contentArea">
			<div class="pkgWrapV16a">
				<%' if vShoppingBag_checkset=1 then %>
				<% '<!-- for dev msg : 단품 포장일 경우 노출 안됩니다. --> %>
				<div class="pkgStepV16a">
					<ul>
						<li class="step1 "><p><span>상품선택</span></p></li>
						<li class="step2"><p><span>메시지입력</span></p></li>
						<li class="step3 current"><p><span>포장완료</span></p></li>
					</ul>
				</div>
				<%' end if %>

				<div class="popPkgFinishV16a">
					<% 'for dev msg : 단품 포장일 경우 아래 메세지 노출됩니다. %>
					<% if vShoppingBag_checkset=0 then %>
						<p><strong>선물포장</strong>이 완료되었습니다.</p>
					<% else %>
						<%' 복수 표기 요망 %>
						<p><strong><%= opackmaster.FItemList(0).Ftitle %></strong>의<br />포장이 완료되었습니다.</p>
					<% end if %>
				</div>
			</div>
		</div>

		<div class="packFloatBarV16a">
			<div class="btnAreaV16a">
				<% '<!-- for dev msg : 단품 포장일 경우 아래 버튼 하나만 노출됩니다. --> %>
				<% if vShoppingBag_checkset=0 then %>
					<p style="width:50%;"><button type="button" class="btnV16a btnRed2V16a" onclick="pojangcomplete(); return false;">포장 완료</button></p>
				<% else %>
					<p style="width:50%; padding-right:0.5rem;"><button type="button" class="btnV16a btnRed1V16a" onclick="gostep1(); return false;">선물포장 더 만들기</button></p>
					<p style="width:50%;"><button type="button" class="btnV16a btnRed2V16a" onclick="pojangcomplete(); return false;">포장 완료</button></p>
				<% end if %>
			</div>
		</div>
	</div>
</div>
<form name="pojangfrm" method="post" action="" style="margin:0px;">
<input type="hidden" name="mode">
<input type="hidden" name="reload">
</form>
</body>
</html>
<%
set opackmaster=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->