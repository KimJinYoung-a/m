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
'# 그남자 그여자의 설렘 가이드북 - 코멘트이벤트
'# 2015-01-13 이종화 작성
'########################################################
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21439
Else
	eCode   =  58383
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

	iCPageSize = 5		'한 페이지의 보여지는 열의 수
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

	Dim rencolor
	
	randomize

	rencolor=int(Rnd*5)+1
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.mEvt58572 img {vertical-align:top;}
.mEvt58572 .movieArea {position:relative;}
.mEvt58572 .movieArea .movie {position:absolute; left:10%; top:0; width:80%; height:100%;}
.mEvt58572 .movie .vimeo {overflow:hidden; position:relative; height:100%; padding-bottom:56.25%; background:#000;}
.mEvt58572 .movie .vimeo iframe {position:absolute; top:0; left:0; width:100%; height:100%}
.mEvt58572 .present {position:relative;}
.mEvt58572 .present a {display:block; position:absolute; right:8%; top:3%; width:42.5%; height:42.5%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
.mEvt58572 .present .goPdt a {display:none; position:absolute; left:7%; top:45.5%; width:42.5%; height:42.5%;}

.concertApply {position:relative;}
.concertApply .cmtWrite {position:absolute; left:8%; top:0; width:84%;}
.concertApply .cmtWrite dl {overflow:hidden; text-align:left; padding-bottom:1%;}
.concertApply .cmtWrite dt {float:left; width:22%;}
.concertApply .cmtWrite dd {float:left; width:78%;}
.concertApply .cmtWrite dd input {vertical-align:top;}
.concertApply .cmtWrite .write01 {border:1px solid #ccc; color:#999; font-size:11px; width:100%; height:25px; padding:5px 5px 5px 7px; border-radius:0;}
.concertApply .cmtWrite .write02 {border:1px solid #ccc; color:#999; font-size:11px; width:100%; height:105px; padding:5px; border-radius:0;}
.concertApply .cmtWrite .btnSubmit {border:0; width:100%; margin-top:3px;}

.storyList ul {padding:13px 10px 0;}
.storyList li {margin-bottom:10px; background-position:left bottom; background-repeat:no-repeat; background-size:100% auto;}
.storyList li.s01 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58572/bg_cmt_cont01.gif);}
.storyList li.s02 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58572/bg_cmt_cont02.gif);}
.storyList li.s03 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58572/bg_cmt_cont03.gif);}
.storyList li.s04 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58572/bg_cmt_cont04.gif);}
.storyList li.s05 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58572/bg_cmt_cont05.gif);}
.storyList .storyContainer {position:relative; background-position:left top; background-repeat:no-repeat; background-size:100% auto;}
.storyList li.s01 .storyContainer {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58572/bg_cmt_top01.gif);}
.storyList li.s02 .storyContainer {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58572/bg_cmt_top02.gif);}
.storyList li.s03 .storyContainer {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58572/bg_cmt_top03.gif);}
.storyList li.s04 .storyContainer {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58572/bg_cmt_top04.gif);}
.storyList li.s05 .storyContainer {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58572/bg_cmt_top05.gif);}
.storyList li .storyInfo {padding:8px 0 0 10px;}
.storyList li .storyInfo .writer span {display:inline-block; font-weight:bold; font-size:11px; line-height:1; color:#fff; padding:2px 12px 1px; border-radius:10px;}
.storyList li.s01 .storyInfo .writer span {background:#ff6d3c; box-shadow:1px 1px 0 #993f26;}
.storyList li.s02 .storyInfo .writer span {background:#62a180; box-shadow:1px 1px 0 #53573b;}
.storyList li.s03 .storyInfo .writer span {background:#ffbc3c; box-shadow:1px 1px 0 #995926;}
.storyList li.s04 .storyInfo .writer span {background:#827dcb; box-shadow:1px 1px 0 #61444d;}
.storyList li.s05 .storyInfo .writer span {background:#6184b5; box-shadow:1px 1px 0 #524747;}
.storyList li .storyInfo .cInfo {position:absolute; right:8px; top:11px; color:#e3d5cf; font-size:10px; line-height:1;}
.storyList li .storyInfo .cInfo span {position:relative; display:inline-block; padding:0 5px; float:left;}
.storyList li .storyInfo .cInfo span.date:after {content:' '; display:inline-block; position:absolute; left:0; top:12%; width:1px; height:68%; line-height:1; background:#e3d5cf;}
.storyList li .storyCont {padding:28px 30px 25px; font-size:11px; line-height:1.3; color:#333; word-break:break-all;}
.storyList li .storyCont .partner {height:20px; line-height:1; font-weight:bold; color:#333; border-bottom:1px solid #d4d4d4;}
.storyList li .storyCont .partner img {width:9px; vertical-align:middle; margin:-2px 0 0 3px;}
.storyList li.s01 .storyCont .partner strong {color:#fc7142;}
.storyList li.s02 .storyCont .partner strong {color:#529271;}
.storyList li.s03 .storyCont .partner strong {color:#ee9d02;}
.storyList li.s04 .storyCont .partner strong {color:#726ccf;}
.storyList li.s05 .storyCont .partner strong {color:#6184b5;}
.storyList li .storyCont .txt {padding:5px 0;}
.storyList li .storyCont .del a {display:inline-block; font-size:11px; line-height:1; padding:4px 8px 3px; font-weight:bold; color:#666; border:1px solid #ccc; background:#f4f7f7; border-radius:3px;}

@media all and (min-width:480px){
	.concertApply .cmtWrite .write01 {font-size:17px; height:40px; padding:7px 7px 7px 11px;}
	.concertApply .cmtWrite .write02 {font-size:17px; height:160px; padding:7px;}
	.concertApply .cmtWrite .btnSubmit {margin-top:5px;}

	.storyList ul {padding:20px 15px 0;}
	.storyList li {margin-bottom:15px;}
	.storyList li .storyInfo {padding:15px 0 0 15px;}
	.storyList li .storyInfo .writer span {font-size:17px; padding:3px 18px 2px; border-radius:15px;}
	.storyList li .storyInfo .cInfo {right:12px; top:19px; font-size:15px;}
	.storyList li .storyInfo .cInfo span {padding:0 7px;}
	.storyList li .storyCont {padding:53px 45px 40px; font-size:17px;}
	.storyList li .storyCont .partner {height:30px;}
	.storyList li .storyCont .partner img {width:13px; margin:-3px 0 0 4px;}
	.storyList li .storyCont .txt {padding:7px 0;}
	.storyList li .storyCont .del a {font-size:17px; padding:6px 13px 4px; border-radius:4px;}

}
</style>
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

		if(!frm.qtext1.value||frm.qtext1.value=="8자 내외"){
			alert("공연을 함께 볼 사람을 입력 해주세요");
			frm.qtext1.value="";
			frm.qtext1.focus();
			return false;
		}

		if(GetByteLength(frm.qtext1.value)>17){
			alert('8자 까지 가능합니다.');
			frm.qtext1.focus();
			return false;
		}

		if(!frm.qtext2.value||frm.qtext2.value=="200자 내외로 적어주세요."){
			alert("사연을 적어주세요!");
			frm.qtext2.value="";
			frm.qtext2.focus();
			return false;
		}

		if(GetByteLength(frm.qtext2.value)>401){
			alert('200자 까지 가능합니다.');
			frm.qtext2.focus();
			return false;
		}
	   
	   var frm = document.frmcom;
	   frm.action = "doEventSubscript58572.asp";
	   frm.submit();
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
			if(document.frmcom.qtext1.value =="8자 내외"){
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
			if(document.frmcom.qtext2.value =="200자 내외로 적어주세요."){
				document.frmcom.qtext2.value="";
			}
			return true;
		} else {
			jsChklogin('<%=IsUserLoginOK%>');
		}

		return false;
	}

	function jsChkUnblur11()
	{
		if(document.frmcom.qtext1.value ==""){
			document.frmcom.qtext1.value="8자 내외";
		}
	}

	function jsChkUnblur22()
	{
		if(document.frmcom.qtext2.value ==""){
			document.frmcom.qtext2.value="200자 내외로 적어주세요.";
		}
	}
//-->
</script>
<script type="text/javascript">
$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$('a.ma').css('display','block');
	}else{
		$('a.mw').css('display','block');
	}
});
</script>
</head>
<body>
<!-- 2015발렌타인 - 그 남자 그 여자의 설렘 가이드북(M) -->
<div class="mEvt58572">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58572/tit_valentine.gif" alt="유랑 콘서트에 초대해요" /></h2>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58572/txt_tourist.gif" alt="투어리스트X텐바이텐 설레는 만남!" /></p>
	<div class="movieArea">
		<div class="movie">
			<div class="vimeo"><iframe src="//www.youtube.com/embed/xW-8sHhMZi8?autoplay=1" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58572/bg_movie.gif" alt="" /></p>
	</div>
	<div class="present">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58572/img_concert_gift.gif" alt="유랑 콘서트 오시는 분들께 선물을 드려요" /></p>
		<a href="http://www.lalasnap.com/xe/" target="_blank">랄라스냅 스튜디오 사진 촬영권</a>
		<span class="goPdt">
			<a href="/category/category_itemprd.asp?itemid=684665" class="mw" target="_blank">아이코닉 여권케이스</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('684665'); return false;" class="ma">아이코닉 여권케이스</a>
		</span>
	</div>
	<!-- 코멘트 작성 -->
	<h4><img src="http://webimage.10x10.co.kr/eventIMG/2015/58572/tit_comment_event.gif" alt="COMMENT EVENT" /></h4>
	<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
	<input type="hidden" name="eventid" value="<%=eCode%>">
	<input type="hidden" name="bidx" value="<%=bidx%>">
	<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
	<input type="hidden" name="iCTot" value="">
	<input type="hidden" name="mode" value="add">
	<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
	<input type="hidden" name="spoint" value="<%=rencolor%>">
	<div class="concertApply">
		<div class="cmtWrite">
			<dl>
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2015/58572/tit_partner.gif" alt="함께 볼 사람" /></dt>
				<dd>
					<input type="text" value="8자 내외" class="write01"  maxlength="8" name="qtext1" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur11();"/>
				</dd>
			</dl>
			<dl>
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2015/58572/tit_story.gif" alt="사연을 적어주세요" /></dt>
				<dd>
					<textarea class="write02" name="qtext2" onClick="jsChklogin22('<%=IsUserLoginOK%>');" onblur="jsChkUnblur22();">200자 내외로 적어주세요.</textarea>
					<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/58572/btn_submit.gif" alt="코멘트 남기기" class="btnSubmit" />
				</dd>
			</dl>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58572/bg_letter.gif" alt="" /></p>
	</div>
	</form>
	<form name="frmdelcom" method="post" action="doEventSubscript58572.asp" style="margin:0px;">
	<input type="hidden" name="eventid" value="<%=eCode%>">
	<input type="hidden" name="bidx" value="<%=bidx%>">
	<input type="hidden" name="Cidx" value="">
	<input type="hidden" name="mode" value="del">
	<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
	</form>
	<!--// 코멘트 작성 -->
	<% IF isArray(arrCList) THEN %>
	<!-- 코멘트 리스트 -->
	<div class="storyList">
		<ul>
			<% 
				Dim opt1 , opt2
				For intCLoop = 0 To UBound(arrCList,2)

				If arrCList(1,intCLoop) <> "" then
					opt1 = SplitValue(arrCList(1,intCLoop),"//",0)
					opt2 = SplitValue(arrCList(1,intCLoop),"//",1)
				End If 
			%>
			<li class="s0<%=arrCList(3,intCLoop)%>">
				<div class="storyContainer">
					<div class="storyInfo">
						<p class="writer"><span><%=printUserId(arrCList(2,intCLoop),2,"*")%></span></p>
						<div class="cInfo">
							<span>NO.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
							<span class="date"><%=formatdate(arrCList(4,intCLoop),"0000.00.00")%></span>
						</div>
					</div>
					<div class="storyCont">
						<p class="partner"><strong><%=opt1%></strong>과(와) 함께! <% If arrCList(8,intCLoop) = "M"  then%><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성" /><% End If %></p>
						<p class="txt"><%=opt2%></p>
						<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
						<p class="del"><a href="" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');return false;">삭제</a></p>
						<% end if %>
					</div>
				</div>
			</li>
			<% Next %>
		</ul>
		<div class="paging">
			<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
		</div>
	</div>
	<!-- 코멘트 리스트 -->
	<% End If %>
</div>
<!--// 2015발렌타인 - 그 남자 그 여자의 설렘 가이드북(M) -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->