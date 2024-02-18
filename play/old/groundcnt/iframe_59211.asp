<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<%
'########################################################
' PLAY #17 SHOES
' 2015-01-30 이종화 작성
'########################################################
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21457
Else
	eCode   =  59211
End If

dim com_egCode, bidx
	Dim cEComment
	Dim iCTotCnt, arrCList,intCLoop, iSelTotCnt
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt

	'파라미터값 받기 & 기본 변수 값 세팅
	iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	com_egCode = requestCheckVar(Request("eGC"),1)	

	IF iCCurrpage = "" THEN iCCurrpage = 1
	IF iCTotCnt = "" THEN iCTotCnt = -1

	'// 그룹번호 랜덤으로 지정

	iCPageSize = 6		'한 페이지의 보여지는 열의 수
	iCPerCnt = 4		'보여지는 페이지 간격

	'선택범위 리플개수 접수
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iSelTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	'코멘트 데이터 가져오기
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	'cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.mPlay20150202 {}
.goApply {position:relative;}
.goApply a {display:block; position:absolute; left:4.5%; bottom:39%; width:61%; height:9%; color:transparent;}
.videoWrap {background:url(http://webimage.10x10.co.kr/playmo/ground/20150202/bg_video.gif) left top no-repeat; background-size:100% 100%;}
.videoWrap .video {padding:0 15px;}
.videoWrap .video .vimeo {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; background:#000;}
.videoWrap .video .vimeo iframe {position:absolute; top:0; left:0; width:100%; height:100%}
.aboutEirene {position:relative;}
.aboutEirene a {display:block; position:absolute; left:17%; bottom:6.5%; width:66%; height:8%; color:transparent;}
.dearFather {position:relative;}
.dearFather .writeForm {position:absolute; left:12%; top:0; width:76%;}
.dearFather label {display:inline-block; vertical-align:middle;}
.dearFather p input {width:60%; height:22px; border-radius:0; color:#555; font-size:12px; border:1px solid #c5c5c5; text-align:center; vertical-align:middle;}
.dearFather .wMsgWrap {height:130px; padding:10px; margin:12px 0; background:#eee;}
.dearFather .wMsg {height:108px; background:url(http://webimage.10x10.co.kr/playmo/ground/20150202/bg_line.gif) left top repeat; background-size:100% 22px;}
.dearFather .wMsg textarea {overflow:auto; width:100%; height:108px; font-size:12px; line-height:1.9; border:0; padding:0; margin-top:2px; color:#222; background:none; vertical-align:middle;}
.dearFather .btnSubmit {display:block; width:88%; margin:0 auto;}
.dearFather .dear label {width:54px;}
.dearFather .from {text-align:right;}
.dearFather .from label {width:57px;}
.shoesCmtList ul {padding:35px 14px 0;}
.shoesCmtList li {position:relative; font-size:11px; margin-bottom:24px;}
.shoesCmtList li.c01 {background:url(http://webimage.10x10.co.kr/playmo/ground/20150202/bg_cmt01.png) left top no-repeat; background-size:100% 100%;}
.shoesCmtList li.c02 {background:url(http://webimage.10x10.co.kr/playmo/ground/20150202/bg_cmt02.png) left top no-repeat; background-size:100% 100%;}
.shoesCmtList li .cInfo {position:absolute; width:80%; left:5%; top:7%; line-height:1.2; color:#806545;}
.shoesCmtList li .cInfo .writer {position:relative; padding-left:9px; margin-left:5px;}
.shoesCmtList li .cInfo .writer:after {content:' '; display:inline-block; position:absolute; left:0; top:18%; height:54%; width:1px; background:#262626;}
.shoesCmtList li .cInfo .writer img {width:8px; vertical-align:top; margin:-2px 6px 0 0;}
.shoesCmtList .message {position:absolute; left:5%; top:23%; width:90%; height:67%;}
.shoesCmtList .message span {display:inline-block; width:100%; color:#111; font-weight:600; line-height:1.3;}
.shoesCmtList .message span em {display:inline-block; width:34px; height:11px; margin-right:5px; color:transparent;}
.shoesCmtList .message .from {text-align:right;}
.shoesCmtList .message .dear em {background:url(http://webimage.10x10.co.kr/playmo/ground/20150202/txt_cmt_dear.png) left top no-repeat; background-size:100% 100%;}
.shoesCmtList .message .from em {background:url(http://webimage.10x10.co.kr/playmo/ground/20150202/txt_cmt_from.png) left top no-repeat; background-size:100% 100%;}
.shoesCmtList .message .txt {height:68%; line-height:1.2; padding:8px 10px; margin:5px 0; border:1px solid #b5a99b; color:#575757; background:#fff;}
.shoesCmtList li .del {position:absolute; right:0.5%; top:0.5%; width:5.5%;}
@media all and (min-width:480px){
	.videoWrap .video {padding:0 23px;}
	.dearFather p input {height:33px; font-size:18px; }
	.dearFather .wMsgWrap {height:195px; padding:15px; margin:18px 0;}
	.dearFather .wMsg {height:162px; background-size:100% 33px;}
	.dearFather .wMsg textarea {height:162px; font-size:18px; margin-top:3px;}
	.dearFather .dear label {width:81px;}
	.dearFather .from label {width:86px;}
	.shoesCmtList ul {padding:53px 21px 0;}
	.shoesCmtList li {font-size:17px; margin-bottom:36px;}
	.shoesCmtList li .cInfo .writer {padding-left:12px; margin-left:7px;}
	.shoesCmtList li .cInfo .writer img {width:12px; margin:-3px 9px 0 0;}
	.shoesCmtList .message span em {width:51px; height:17px; margin-right:7px;}
	.shoesCmtList .message .txt {padding:12px 15px; margin:7px 0;}
}
</style>
<script type="text/javascript">
$(function(){
	$('.shoesCmtList li:nth-child(odd)').addClass('c01');
	$('.shoesCmtList li:nth-child(even)').addClass('c02');

	$(".goApply a").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 800);
	});
});
</script>
<script type="text/javascript">
<!--
 	function jsGoComPage(iP){
		document.frmcom.iCC.value = iP;
		document.frmcom.iCTot.value = "<%=iCTotCnt%>";
		document.frmcom.submit();
	}

	function jsSubmitComment(frm){
		<% if Not(IsUserLoginOK) then %>
			<% If isApp="1" or isApp="2" Then %>
			parent.calllogin();
			return false;
			<% else %>
			parent.jsevtlogin();
			return;
			<% end if %>			
		<% end if %>

	   
	    if(!frm.qtext1.value || frm.qtext1.value == "10자 이내" ){
	    alert("Dear 입력해주세요");
		document.frmcom.qtext1.value="";
	    frm.qtext1.focus();
	    return false;
	   }

	   if(!frm.qtext2.value || frm.qtext2.value == "최대 120자 작성 가능"){
	    alert("내용을 입력해주세요");
		document.frmcom.qtext2.value="";
	    frm.qtext2.focus();
	    return false;
	   }

		if (GetByteLength(frm.qtext2.value) > 241){
			alert("제한길이를 초과하였습니다. 120자 까지 작성 가능합니다.");
			frm.qtext2.focus();
			return;
		}

	   if(!frm.qtext3.value || frm.qtext3.value == "10자 이내" ){
	    alert("From 입력해주세요");
		document.frmcom.qtext3.value="";
	    frm.qtext3.focus();
	    return false;
	   }

	   frm.action = "doEventSubscript59211.asp";
	   return true;
	}

	function jsDelComment(cidx)	{
		if(confirm("삭제하시겠습니까?")){
			document.frmdelcom.Cidx.value = cidx;
	   		document.frmdelcom.submit();
		}
	}

	function jsChklogin11(blnLogin)
	{
		if (blnLogin == "True"){
			if(document.frmcom.qtext1.value =="10자 이내"){
				document.frmcom.qtext1.value="";
			}
			return true;
		} else {
			jsChklogin('<%=IsUserLoginOK%>');
		}

		return false;
	}

	function jsChklogin22(blnLogin)
	{
		if (blnLogin == "True"){
			if(document.frmcom.qtext2.value =="최대 120자 작성 가능"){
				document.frmcom.qtext2.value="";
			}
			return true;
		} else {
			jsChklogin('<%=IsUserLoginOK%>');
		}

		return false;
	}

	function jsChklogin33(blnLogin)
	{
		if (blnLogin == "True"){
			if(document.frmcom.qtext3.value =="10자 이내"){
				document.frmcom.qtext3.value="";
			}
			return true;
		} else {
			jsChklogin('<%=IsUserLoginOK%>');
		}

		return false;
	}
//-->
</script>
</head>
<body>
<div class="mPlay20150202">
	<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150202/tit_shoes.jpg" alt="나와 아버지의 구두" /></h2>
	<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150202/img_pic01.jpg" alt="좋은 신발은 당신을 좋은 곳으로 데려다 줍니다." /></p>
	<div class="goApply">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150202/txt_make_shoes.jpg" alt="" /></p>
		<a href="#shoesCmtWrite">수제화 신청하러 가기</a>
	</div>
	<div class="makingFilm">
		<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20150202/tit_making_film.gif" alt="MAKING FILM" /></h3>
		<div class="videoWrap">
			<div class="video">
				<div class="vimeo"><iframe src="//player.vimeo.com/video/117561207" frameborder="0" allowfullscreen></iframe></div>
			</div>
		</div>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150202/txt_10x10_eirene.gif" alt="텐바이텐X에이레네" /></p>
	</div>
	<div class="aboutEirene">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150202/txt_about_eirene.jpg" alt="ABOUT EIRENE" /></p>
		<a href="/street/street_brand.asp?makerid=eirene" target="_top">에이레네 사이트 바로가기</a>
	</div>

	<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
	<input type="hidden" name="eventid" value="<%=eCode%>"/>
	<input type="hidden" name="bidx" value="<%=bidx%>"/>
	<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
	<input type="hidden" name="iCTot" value=""/>
	<input type="hidden" name="mode" value="add"/>
	<input type="hidden" name="userid" value="<%=GetLoginUserID%>"/>
	<!-- 코멘트 작성-->
	<div class="shoesCmtWrite" id="shoesCmtWrite">
		<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20150202/tit_comment_event.jpg" alt="COMMENT EVENT" /></h3>
		<h4><img src="http://webimage.10x10.co.kr/playmo/ground/20150202/txt_message.jpg" alt="사랑하는 당신의 아버지에게 메세지를 남겨주세요" /></h4>
		<div class="dearFather">
			<div class="writeForm">
				<p class="dear">
					<label for="msgDear"><img src="http://webimage.10x10.co.kr/playmo/ground/20150202/txt_dear.gif" alt="Dear" /></label>
					<input type="text" id="msgDear" value="10자 이내" placeholder="10자 이내" name="qtext1" onClick="jsChklogin11('<%=IsUserLoginOK%>');" maxlength="10" />
				</p>
				<div class="wMsgWrap">
					<div class="wMsg"><textarea cols="20" rows="10" placeholder="최대 120자 작성 가능" name="qtext2" onClick="jsChklogin22('<%=IsUserLoginOK%>');">최대 120자 작성 가능</textarea></div>
				</div>
				<p class="from">
					<label for="msgFrom"><img src="http://webimage.10x10.co.kr/playmo/ground/20150202/txt_from.gif" alt="From" /></label>
					<input type="text" id="msgFrom" value="10자 이내" placeholder="10자 이내" name="qtext3" onClick="jsChklogin33('<%=IsUserLoginOK%>');" maxlength="10" />
					<span><img src="http://webimage.10x10.co.kr/playmo/ground/20150202/txt_ex02.gif" alt="ex) 자랑스러운 큰 아들, 귀염둥이 막내 등" /></span>
				</p>
				<input type="image" src="http://webimage.10x10.co.kr/playmo/ground/20150202/btn_submit.gif" alt="등록하기" class="btnSubmit" />
			</div>
			<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150202/bg_paper.jpg" alt="" /></div>
		</div>
	</div>
	<!--// 코멘트 작성 -->
	</form>
	<form name="frmdelcom" method="post" action="/event/lib/comment_process.asp" style="margin:0px;">
	<input type="hidden" name="eventid" value="<%=eCode%>">
	<input type="hidden" name="bidx" value="<%=bidx%>">
	<input type="hidden" name="Cidx" value="">
	<input type="hidden" name="mode" value="del">
	<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
	</form>

	<% IF isArray(arrCList) THEN %>
	<!-- 코멘트 리스트-->
	<div class="shoesCmtList">
		<!-- for dev msg : 리스트는 4개씩 노출됩니다 -->
		<ul>
			<% For intCLoop = 0 To UBound(arrCList,2) %>
			<% 
					Dim opt1 , opt2 , opt3
					If arrCList(1,intCLoop) <> "" then
						opt1 = SplitValue(arrCList(1,intCLoop),"//",0)
						opt2 = SplitValue(arrCList(1,intCLoop),"//",1)
						opt3 = SplitValue(arrCList(1,intCLoop),"//",2)
					End If 
			%>
			<li>
				<div class="cInfo">
					<span class="num">no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
					<span class="writer"><% If arrCList(8,intCLoop) = "M"  then%><img src="http://webimage.10x10.co.kr/playmo/ground/20150202/ico_mob.png" alt="모바일에서 작성" /><% End If %><%=printUserId(arrCList(2,intCLoop),2,"*")%></span>
				</div>
				<div class="message">
					<span class="dear"><em>Dear</em><%=opt1%></span>
					<p class="txt"><%=opt2%></p>
					<span class="from"><em>From</em><%=opt3%></span>
				</div>
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150202/bg_cmt.png" alt="" /></p>
				<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
				<p class="del"><a href="javascript:jsDelComment('<% = arrCList(0,intCLoop) %>');"><img src="http://webimage.10x10.co.kr/playmo/ground/20150202/btn_delete.png" alt="삭제" /></a></p>
				<% end if %>
			</li>
			<% Next %>
		</ul>
		<div class="paging">
			<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
		</div>
	</div>
	<!--// 코멘트 리스트-- -->
	<% End If %>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->