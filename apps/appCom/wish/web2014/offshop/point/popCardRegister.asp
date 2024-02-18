<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'##################################################
' Description : 오프라인샾 point1010 카드등록
' History : 2015-04-17 이종화 생성
'##################################################
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/offshop/lib/classes/offshopCls.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	If GetLoginUserID() = "" Then
		Response.write "<script>self.location='/login/login.asp?backpath=/offshop/point/popcardregister.asp';</script>"
		Response.End
	End If

	Dim arrPoint, intN, ClsOSPoint, vUserID, vRegdate, vRealNameChk, vUseYN, vGubun, vUserSeq, vHaveCardYN, vHaveTotalCardYN
	Dim vHaveOLDCardYN
	vHaveCardYN = "N"
    vHaveOLDCardYN = "N"

	set ClsOSPoint = new COffshopPoint1010
		arrPoint = ClsOSPoint.fnGetUserSilMyung
		vHaveTotalCardYN = ClsOSPoint.FHaveTotalCardYN
	set ClsOSPoint = nothing
    
	IF isArray(arrPoint) THEN
	    if (UBound(arrPoint,2)>0) then vHaveCardYN = "Y"
	    
	    For intN =0 To UBound(arrPoint,2)
			If Left(arrPoint(1,intN),4) <> "1010" Then
			    vHaveOLDCardYN = "Y"
			    Exit For
			end if
	    Next
	End If
%>
<script>
function TnJoin10x10(){
	var frm = document.myinfoForm;

	<% If vHaveTotalCardYN = "N" Then %>
//	if (frm.yak1.checked == false){
//		alert("POINT1010 이용 약관에 동의를 하셔야 합니다.");
//		return ;
//	}
	<% End If %>
	
	if (frm.txCard1.value == ""){
		alert("카드번호를 입력하세요.");
		frm.txCard1.focus();
		return ;
	}
	
	if (frm.txCard2.value == ""){
		alert("카드번호를 입력하세요.");
		frm.txCard2.focus();
		return ;
	}
	
	if (frm.txCard3.value == ""){
		alert("카드번호를 입력하세요.");
		frm.txCard3.focus();
		return ;
	}
	
	if (frm.txCard4.value == ""){
		alert("카드번호를 입력하세요.");
		frm.txCard4.focus();
		return ;
	}
	
	if (frm.cardnochk.value == "x"){
		alert("카드번호 확인을 하세요.");
		return ;
	}
	
	<% If vGubun = "1" Then %>
	if(!chkID){		
		alert("아이디를 확인해주세요");				
	   	DuplicateIDCheck(frm.txuserid);	   	
	   	return;
	}
	<% End If %>
    
	var ret = confirm('카드등록을 하시겠습니까?\n\n*POINT1010카드 재발급시 잔여포인트는 자동으로 이관됩니다.');
	if(ret){
		frm.target = "iframeDB1";
		frm.submit();
	}
}

function jsCardnocheck(){

	var frm = document.myinfoForm;
	
	if (frm.txCard1.value == ""){
		alert("카드번호를 입력하세요.");
		frm.txCard1.focus();
		return ;
	}
	
	if (frm.txCard2.value == ""){
		alert("카드번호를 입력하세요.");
		frm.txCard2.focus();
		return ;
	}
	
	if (frm.txCard3.value == ""){
		alert("카드번호를 입력하세요.");
		frm.txCard3.focus();
		return ;
	}
	
	if (frm.txCard4.value == ""){
		alert("카드번호를 입력하세요.");
		frm.txCard4.focus();
		return ;
	}
	
	var cardno = frm.txCard1.value + frm.txCard2.value + frm.txCard3.value + frm.txCard4.value;
	iframeDB1.location.href = "/offshop/point/iframe_card_check.asp?cardno="+cardno;
}

function TnTabNumber(thisform,target,num) {
   if (eval("document.myinfoForm." + thisform + ".value.length") == num) {
	  eval("document.myinfoForm." + target + ".focus()");
   }
}
</script>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
</head>
<body>
<div class="layerPopup">
	<div class="popWin">
		<div class="header">
			<h1>카드등록</h1>
			<p class="btnPopClose"><button class="pButton" onclick="fnCloseModal();">닫기</button></p>
		</div>
		<!-- content area -->
		<form name="myinfoForm" method="post" action="<%=wwwUrl%>/offshop/point/dojoin.asp" >
		<input type="hidden" name="cardnochk" value="x">
		<input type="hidden" name="txuserid" value="<%=vUserID%>">
		<input type="hidden" name="havetotalcardyn" value="<%=vHaveTotalCardYN%>">
		<input type="hidden" name="havecardyn" value="<%=vHaveCardYN%>">
		<input type="hidden" name="userseq" value="<%=vUserSeq%>">
		<input type="hidden" name="RealCardNo" value="">
		<div class="content cardRegister" id="layerScroll">
			<div id="scrollarea">
				<div class="inner10">
					<p class="tPad10 lh12 ct fs11 cGy2">10X10 STORE에서 발급 받은 카드를 등록하시면<br />모바일로 편리하게 포인트를 적립하실 수 있습니다.</p>
				<% If vHaveTotalCardYN = "N" Then %>
				<%'포인트 카드 없을경우 약관 추가 부분 %>
				<% End If %>
					<div class="enterNumber">
						<input type="tel" class="w20p ct" title="카드번호 첫번째자리 네자리 입력" name="txCard1" maxlength="4" onKeyUp="TnTabNumber('txCard1','txCard2','4');"/> -
						<input type="tel" class="w20p ct" title="카드번호 두번째자리 네자리 입력" name="txCard2" id="[on,off,1,4][카드번호2]" maxlength="4" onKeyUp="TnTabNumber('txCard2','txCard3','4');"/> -
						<input type="tel" class="w20p ct" title="카드번호 세번째자리 네자리 입력" name="txCard3" id="[on,off,1,4][카드번호3]" maxlength="4" onKeyUp="TnTabNumber('txCard3','txCard4','4');"/> -
						<input type="tel" class="w20p ct" title="카드번호 네번째자리 네자리 입력" name="txCard4" id="[on,off,1,4][카드번호4]" maxlength="4" />
						<p class="fs11 tPad10 cRd1">텐바이텐 카드번호 16자리를 입력해주세요.</p>
					</div>
					<p class="ct"><span class="button btB1 btRed cWh1 w70p"><a href="" onclick="jsCardnocheck();return false;">카드번호확인</a></span></p>				
					<ul class="cpNoti tMar20">
						<li><input type="checkbox" id="opt01" name="email_point1010" value="Y" /> <label for="opt01">POINT1010 이메일 서비스를 받아보시겠습니까? (옵션)</label></li>
						<li><input type="checkbox" id="opt02" name="smsok_point1010" value="Y" /> <label for="opt02">POINT1010 텐바이텐 가맹점의 SNS 문자서비스를 받아 보시겠습니까? (옵션)</label></li>
					</ul>
					<p class="tMar20 ct"><span class="button btB1 btRed cWh1 w70p"><a href="javascript:TnJoin10x10();">카드등록</a></span></p>
				</div>
			</div>
		</div>
		</form>
		<!-- //content area -->
	</div>
</div>
<iframe name="iframeDB1" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" onload="resizeIfr(this, 10)"></iframe>
</body>
</html>