<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 2
' History : 2015.09.15 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->

<%
dim currenttime
	currenttime =  now()
	'currenttime = #09/16/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  64885
Else
	eCode   =  66233
End If

dim userid, i
	userid = GetEncLoginUserID()

dim commentcount
commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, pagereload
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),2)
	isApp	= requestCheckVar(request("isApp"),1)

if isApp="" then isApp=0
IF blnFull = "" THEN blnFull = True
IF blnBlogURL = "" THEN blnBlogURL = False

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 4		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 5		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 5		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
end if

'데이터 가져오기
set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	if isMyComm="Y" then cEComment.FUserID = userid
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수
	
	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
set cEComment = nothing

iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
	
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}

.designFingers .form {padding:0 6.25%;}
.designFingers .form legend {visibility:hidden; width:0; height:0;}
.designFingers .form .choice {position:relative; z-index:5; margin-top:-5px;}
.designFingers .form .choice:after {content:' '; display:block; clear:both;}
.designFingers .form .choice li {float:left; width:58px; height:58px; margin:5px 4px;}
.designFingers .form .choice li button {width:58px; height:58px; background:transparent url(http://webimage.10x10.co.kr/eventIMG/2015/66233/m/bg_ico.png) no-repeat 0 0; background-size:348px auto; font-size:11px; text-indent:-999em;}
.designFingers .form .choice li.ico1 button.on {background-position:0 100%;}
.designFingers .form .choice li.ico2 button {background-position:-58px 0;}
.designFingers .form .choice li.ico2 button.on {background-position:-58px 100%;}
.designFingers .form .choice li.ico3 button {background-position:-116px 0;}
.designFingers .form .choice li.ico3 button.on {background-position:-116px 100%;}
.designFingers .form .choice li.ico4 button {background-position:-174px 0;}
.designFingers .form .choice li.ico4 {clear:left;}
.designFingers .form .choice li.ico4 button.on {background-position:-174px 100%;}
.designFingers .form .choice li.ico5 button {background-position:-232px 0;}
.designFingers .form .choice li.ico5 button.on {background-position:-232px 100%;}
.designFingers .form .choice li.ico6 button {background-position:100% 0;}
.designFingers .form .choice li.ico6 button.on {background-position:100% 100%;}

.field {position:relative; margin-top:5px; padding-right:55px;}
.field textarea {width:100%; height:55px; border:0; border-radius:0; background-color:#f4f4f4; color:#333; font-size:12px;}
.field input {position:absolute; top:0; right:0; width:55px; height:55px; background-color:#333; color:#fff; font-size:10px;}

.commentlist {padding:0 6.25%;}
.commentlist .total {margin-top:5%; color:#999; font-size:11px; text-align:right;}
.commentlist ul {margin-top:10px; border-top:1px solid #ddd;}
.commentlist ul li {position:relative; min-height:58px; padding:15px 0 15px 78px; border-bottom:1px solid #ddd; color:#777; font-size:10px; line-height:1.375em;}
.commentlist ul li strong {position:absolute; top:50%; left:0; width:58px; height:58px; margin-top:-29px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/66233/m/bg_ico.png) no-repeat 0 0;background-size:348px auto; font-size:11px; text-indent:-999em;}
.commentlist ul li .ico2 {background-position:-58px 0;}
.commentlist ul li .ico3 {background-position:-116px 0;}
.commentlist ul li .ico4 {background-position:-174px 0;}
.commentlist ul li .ico5 {background-position:-232px 0;}
.commentlist ul li .ico6 {background-position:100% 0;}
.commentlist ul li .date {margin-top:7px;}
.commentlist ul li .button {margin-top:5px;}
.commentlist ul li .mob img {width:9px;}
.commentlist .btnmore {margin-top:2%;}

@media all and (min-width:360px){
	.field {position:relative; margin-top:15px;}

	.commentlist ul li {font-size:11px;}
}

@media all and (min-width:480px){
	.designFingers .form .choice li {float:left; width:116px; height:116px; margin:7px 6px;}
	.designFingers .form .choice li button {width:116px; height:116px; background-size:696px auto;}
	.designFingers .form .choice li.ico2 button {background-position:-116px 0;}
	.designFingers .form .choice li.ico2 button.on {background-position:-116px 100%;}
	.designFingers .form .choice li.ico3 button {background-position:-232px 0;}
	.designFingers .form .choice li.ico3 button.on {background-position:-232px 100%;}
	.designFingers .form .choice li.ico4 button {background-position:-348px 0;}
	.designFingers .form .choice li.ico4 button.on {background-position:-348px 100%;}
	.designFingers .form .choice li.ico5 button {background-position:-464px 0;}
	.designFingers .form .choice li.ico5 button.on {background-position:-464px 100%;}
	.designFingers .form .choice li.ico6 button {background-position:100% 0;}
	.designFingers .form .choice li.ico6 button.on {background-position:100% 100%;}

	.field {margin-top:25px; padding-right:75px;}
	.field textarea {height:75px;}
	.field input {width:75px; height:75px; font-size:16px;}

	.commentlist .total {font-size:16px;}
	.commentlist ul li {min-height:116px; padding:22px 0 22px 135px; font-size:16px;}
	.commentlist ul li strong {width:116px; height:116px; margin-top:-58px; background-size:696px auto;}
	.commentlist ul li .ico2 {background-position:-116px 0;}
	.commentlist ul li .ico3 {background-position:-232px 0;}
	.commentlist ul li .ico4 {background-position:-348px 0;}
	.commentlist ul li .ico5 {background-position:-464px 0;}
	.commentlist ul li .ico6 {background-position:100% 0;}
	.commentlist ul li .date {margin-top:10px;}
	.commentlist ul li .mob img {width:13px;}
}

<% if isApp=1 then %>
.popWin .content {padding-top:0;}
<% end if %>

</style>
<script type='text/javascript'>

$(function(){
	<% if pagereload<>"" then %>
		//pagedown();
		//setTimeout("pagedown()",500);
	<% end if %>
});

function pagedown(){
	//document.getElementById('commentlist').scrollIntoView();
	window.$('html,body').animate({scrollTop:$("#commentlist").offset().top}, 0);
}

function pageup(){
	//document.getElementById('commentlist').scrollIntoView();
	window.$('html,body').animate({scrollTop:$("#itemlist").offset().top+600}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-09-16" and left(currenttime,10)<"2015-10-07" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>5 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if (frm.gubunval.value == ''){
					alert('원하는 것을 선택해 주세요.');
					return false;
				}
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 400){
					alert("코맨트는 400자 까지만 작성이 가능합니다. 코맨트를 남겨주세요.");
					frm.txtcomm1.focus();
					return false;
				}

				frm.txtcomm.value = frm.gubunval.value + '!@#' + frm.txtcomm1.value
				frm.action = "/event/lib/doEventComment.asp";
				frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	<% End IF %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmactNew.Cidx.value = cidx;
   		document.frmactNew.submit();
	}
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	}

	//if (frmcom.txtcomm.value == ''){
	//	frmcom.txtcomm.value = '';
	//}	
}

//내코멘트 보기
function fnMyComment() {
	document.frmcom.isMC.value="<%=chkIIF(isMyComm="Y","N","Y")%>";
	document.frmcom.iCC.value=1;
	document.frmcom.submit();
}

</script>
</head>
<body class="">
<div class="heightGrid">
	<div class="container popWin">
		<% if isApp=1 then %>
		<% else %>
			<div class="header">
				<h1>코멘트</h1>
				<% if isApp=1 then %>
					<p class="btnPopClose"><button onclick="fnAPPclosePopup(); return false;" class="pButton">닫기</button></p>
				<% else %>
					<p class="btnPopClose"><button onclick="self.close(); return false;" class="pButton">닫기</button></p>
				<% end if %>
			</div>
		<% end if %>

		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="designFingers">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66233/m/txt_comment.png" alt="정성껏 코멘트를 남겨주신 1분을 추첨하여 베로니카포런던의 VWMS-STANDING을 선물로 드립니다. 코멘트 작성시 희망하는 사이즈, 발볼 단계, 컬러는 꼭 기재해주세요. 기간은 2015년 9월 16일부터 10월 6일까지며, 발표는 10월 8일 입니다." /></p>
				<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
				<input type="hidden" name="mode" value="add">
				<input type="hidden" name="pagereload" value="ON">
				<input type="hidden" name="iCC" value="1">
				<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
				<input type="hidden" name="eventid" value="<%= eCode %>">
				<input type="hidden" name="linkevt" value="<%= eCode %>">
				<input type="hidden" name="blnB" value="<%= blnBlogURL %>">
				<input type="hidden" name="returnurl" value="/event/etc/inc_66233_comment.asp?isApp=<%=isApp %>">
				<input type="hidden" name="txtcomm">
				<input type="hidden" name="gubunval">
				<input type="hidden" name="isApp" value="<%= isApp %>">	
				<!-- for dev msg : form -->
				<div class="form">
					<fieldset>
					<legend>갖고 싶은 활용도 선택하고 코멘트 쓰기</legend>
						<ul class="choice">
							<li class="ico1"><button type="button" value="1">Love</button></li>
							<li class="ico2"><button type="button" value="2">Well</button></li>
							<li class="ico3"><button type="button" value="3">Active</button></li>
							<li class="ico4"><button type="button" value="4">Relax</button></li>
							<li class="ico5"><button type="button" value="5">Together</button></li>
							<li class="ico6"><button type="button" value="6"">Present</button></li>
						</ul>
						<div class="field">
							<textarea name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> title="" cols="60" rows="5"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %><%END IF%></textarea>
							<input type="submit" onclick="jsSubmitComment(document.frmcom); return false;" value="응모하기" class="btnsubmit" />
						</div>
					</fieldset>
				</div>
				</form>
				<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
				<input type="hidden" name="mode" value="del">
				<input type="hidden" name="pagereload" value="ON">
				<input type="hidden" name="Cidx" value="">
				<input type="hidden" name="returnurl" value="/event/etc/inc_66233_comment.asp?isApp=<%=isApp %>">
				<input type="hidden" name="eventid" value="<%= eCode %>">
				<input type="hidden" name="linkevt" value="<%= eCode %>">
				<input type="hidden" name="isApp" value="<%= isApp %>">
				</form>

				<!-- for dev msg : comment list -->
				<div class="commentlist" id="commentlist">
					<div class="total">total <%= iCTotCnt %></div>
					
					<% IF isArray(arrCList) THEN %>
						<ul>
							<% For intCLoop = 0 To UBound(arrCList,2) %>
							<li>
								<% if isarray(split(arrCList(1,intCLoop),"!@#")) then %>
									<strong class="ico<%= split(arrCList(1,intCLoop),"!@#")(0) %>">
										<% if split(arrCList(1,intCLoop),"!@#")(0)="1" then %>
											채우기
										<% elseif split(arrCList(1,intCLoop),"!@#")(0)="2" then %>
											담기
										<% elseif split(arrCList(1,intCLoop),"!@#")(0)="3" then %>
											여유갖기
										<% elseif split(arrCList(1,intCLoop),"!@#")(0)="4" then %>
											쉬어가기
										<% elseif split(arrCList(1,intCLoop),"!@#")(0)="5" then %>
											비우기
										<% elseif split(arrCList(1,intCLoop),"!@#")(0)="6" then %>
											다가가기
										<% elseif split(arrCList(1,intCLoop),"!@#")(0)="7" then %>
											시간보내기
										<% end if %>																																																					
									</strong>
								<% end if %>

								<div class="letter">
									<p>
										<% if isarray(split(arrCList(1,intCLoop),"!@#")) then %>
											<% if ubound(split(arrCList(1,intCLoop),"!@#")) > 0 then %>
												<%=ReplaceBracket(db2html( split(arrCList(1,intCLoop),"!@#")(1) ))%>
											<% end if %>
										<% end if %>
									</p>

									<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
										<span class="button btS1 btWht cBk1"><button onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');return false;" type="button">삭제</button></span>
									<% end if %>
								</div>
								<div class="date">
									<span><%=printUserId(arrCList(2,intCLoop),2,"*")%></span> / <span><%= FormatDate(arrCList(4,intCLoop),"0000.00.00") %></span>

									<% If arrCList(8,i) <> "W" Then %>
										 <span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성"></span>
									<% end if %>
								</div>
							</li>
							<% Next %>
						</ul>

						<% IF isArray(arrCList) THEN %>
							<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
						<% end if %>

					<% end if %>
				</div>
			</div>

		</div>
		<!-- //content area -->
	</div>
</div>
<script type="text/javascript">
$(function(){
	$(".form .choice li button").click(function(){
		//alert( $(this).val() );
		frmcom.gubunval.value = $(this).val()
		$(".form .choice li button").removeClass("on");
		if ( $(this).hasClass("on")) {
			$(this).removeClass("on");
		} else {
			$(this).addClass("on");
		}
	});
});
</script>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->