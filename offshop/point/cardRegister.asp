<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'##################################################
' Description : 오프라인샾 point1010 카드등록
' History : 2015-04-17 이종화 생성
'			2019-01-15 최종원 - 리뉴얼
'##################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/offshop/lib/classes/offshopCls.asp" -->
<%
'해더 타이틀
strHeadTitleName = "멤버쉽 카드등록"

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
<!-- #include virtual="/lib/inc/head.asp" -->
<script>
function TnJoin10x10(){
	var frm = document.myinfoForm;

	<% If vHaveTotalCardYN = "N" Then %>
	if (frm.yak1.checked == false){
		alert("POINT1010 이용 약관에 동의를 하셔야 합니다.");
		return ;
	}
	<% End If %>
	
	if (frm.txCard1.value == ""){
		alert("12자리의 카드번호를 입력해주세요.");
		frm.txCard1.focus();
		return ;
	}
	
	if (frm.txCard2.value == ""){
		alert("12자리의 카드번호를 입력해주세요.");
		frm.txCard2.focus();
		return ;
	}
	
	if (frm.txCard3.value == ""){
		alert("12자리의 카드번호를 입력해주세요.");
		frm.txCard3.focus();
		return ;
	}
	
	if (frm.txCard4.value == ""){
		alert("12자리의 카드번호를 입력해주세요.");
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
function tabNumber(inputEle) {	
	if(inputEle.value.length == inputEle.maxLength){
		inputEle.nextElementSibling.focus();
	}	
}
function TnTabNumber(thisform,target,num) {
   if (eval("document.myinfoForm." + thisform + ".value.length") == num) {
	  eval("document.myinfoForm." + target + ".focus()");
   }
}
</script>
</head>
<body class="default-font body-popup">
	<header class="tenten-header header-popup">
		<div class="title-wrap">
			<h1>마일리지 전환</h1>			
			<button type="button" class="btn-close" onclick="history.back()">닫기</button>
		</div>
	</header>

	<!-- contents -->
	<div id="content" class="content regist-membercard">
	<form name="myinfoForm" method="post" action="<%=M_SSLUrl%>/offshop/point/dojoin.asp" >
	<input type="hidden" name="cardnochk" value="x">
	<input type="hidden" name="txuserid" value="<%=vUserID%>">
	<input type="hidden" name="havetotalcardyn" value="<%=vHaveTotalCardYN%>">
	<input type="hidden" name="havecardyn" value="<%=vHaveCardYN%>">
	<input type="hidden" name="userseq" value="<%=vUserSeq%>">
	<input type="hidden" name="RealCardNo" value="">		
        <h2>매장에서<br/>직접 발급 받은<br/><em>멤버십카드가 있다면?</em></h2>
        <div class="notify">카드에 표기된 12자리 코드를 입력 후 등록해주세요. 적립된 마일리지가 멤버십 앱카드에 자동 합산됩니다.</div>
        <div class="benefit">
            <p>매장 발급 카드<span>10P</span></p>
            <p>멤버십 앱카드<span>10P</span></p>
            <p>멤버십 앱카드<span>20P</span></p>
        </div>
        <div class="regist-member-card">
			<div class="enter-number">
				<input type="tel" placeholder="1234" title="카드번호 첫번째자리 네자리 입력" name="txCard1" maxlength="4" onKeyUp="tabNumber(this);"/> -
				<input type="tel" placeholder="1234" title="카드번호 두번째자리 네자리 입력" name="txCard2" id="[on,off,1,4][카드번호2]" maxlength="4" onKeyUp="tabNumber(this);"/> -
				<input type="tel" placeholder="1234" title="카드번호 세번째자리 네자리 입력" name="txCard3" id="[on,off,1,4][카드번호3]" maxlength="4" onKeyUp="tabNumber(this);"/> -
				<input type="tel" placeholder="1234" title="카드번호 네번째자리 네자리 입력" name="txCard4" id="[on,off,1,4][카드번호4]" maxlength="4"/>
			</div>
		</div>
		<button class="btn btn-submit" type="button" onclick="javascript:TnJoin10x10();return false;">등록하기</button>				
	</form>		
	<iframe name="iframeDB1" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" onload="resizeIfr(this, 10)"></iframe>
	</div>
	<!-- //contents -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->