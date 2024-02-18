<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'########################################################
' 3rd AROUND CAMPING FESTIVAL - for apps
' 2014-09-03 이종화 작성
'########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<%
	Dim eCode

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21291
	Else
		eCode   =  54805
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

	iCPageSize = 4		'한 페이지의 보여지는 열의 수
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

	rencolor=int(Rnd*4)+1

	'// 쇼셜서비스로 글보내기
	dim snpTitle, snpLink, snpPre, snpTag, snpTag2 , ename
	ename = "3rd AROUND CAMPING FESTIVAL"
	snpTitle = Server.URLEncode(ename)
	snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=" & ecode)
	snpPre = Server.URLEncode("텐바이텐 이벤트")
	snpTag = Server.URLEncode("텐바이텐 " & Replace(ename," ",""))
	snpTag2 = Server.URLEncode("#10x10")

%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > AROUND CAMPING FESTIVAL</title>
<style type="text/css">
.mEvt54806 {}
.mEvt54806 img {vertical-align:top; width:100%;}
.mEvt54806 p {max-width:100%;}
.vedioCont {background:#72402e;}
.vedioCont .video {overflow:hidden; position:relative; height:0; padding-bottom:56.25%;}
.vedioCont .video iframe {position:absolute; top:0; left:8%; width:86%; height:100%;}
.vedioCont .goAround {padding:6% 0;}
.vedioCont .goAround a {display:block; width:64%; margin:0 auto;}
.shareAround {position:relative; text-align:center;}
.shareAround .btnShare {position:absolute; left:0; bottom:18%; width:100%;}
.shareAround .btnShare a {display:inline-block; width:31%; margin:0 5px;}
.applyCamping {position:relative; text-align:left;}
.applyCamping .cmtField {position:absolute; left:0; top:0; width:100%; }
.applyCamping .cmtField ul {overflow:hidden; padding:0 7%;}
.applyCamping .cmtField ul li {float:left; width:46%; padding:0 2%; text-align:center;}
.applyCamping .cmtField ul li input {margin-top:5px;}
.applyCamping .cmtField .btnSubmit {width:58%; margin:0 auto;}
.applyCamping .cmtField .btnSubmit input {width:100%;}
.applyCamping .cmtField .writeCmt {width:86%; margin:20px auto 15px; padding:5px; border:1px solid #fff; background:#efefef; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
.applyCamping .cmtField textarea {display:block; width:100%; height:70px; padding:0; border:0; font-size:11px; color:#666; background:#efefef;}
.evtNoti {text-align:left; padding:12px 20px; margin-bottom:30px; background:#0e725a;}
.evtNoti li {font-size:11px; line-height:1.3; color:#fff; padding-left:10px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/54806/blt_arrow.png) left 3px no-repeat; background-size:3px 6px;}
.tentList li {position:relative; overflow:hidden; margin-bottom:7px;}
.tentList li .tentImg {float:left; width:35%;}
.tentList li .num {position:absolute; left:7px; top:12px; font-weight:bold; color:#7e7e7e; font-size:10px; }
.tentList li .applyDate {position:absolute; left:0; bottom:10%; width:34%; font-size:10px; line-height:1.3; font-weight:bold; text-align:center; letter-spacing:-0.053em; color:#9e6639;}
.tentList li .cmtCont {position:absolute; left:35%; top:12%; width:60%; height:76%; color:#888; text-align:left; background:#fff;  -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
.tentList li .cmtCont .txt {font-size:11px; line-height:14px; padding:10px 20px;}
.tentList li .cmtCont .writer {position:absolute; right:17px; bottom:10px; text-align:right; font-size:10px; font-weight:bold; color:#b0b0b0;}
.tentList li .cmtCont .writer strong {color:#9b9b9b;}
.tentList li .cmtCont .btn {margin-top:5px;}
.tentList li .icoMobile {position:absolute; left:7px; top:13px;}
.tentList .bg01 {background-color:#ffcba3;}
.tentList .bg02 {background-color:#bee8f5;}
.tentList .bg03 {background-color:#f6e584;}
.tentList .bg04 {background-color:#5e7597;}
.tentList .bg04 .num {color:#fff;}
.tentList .bg04 .applyDate {color:#efd0b8;}

.btn {display:inline-block; vertical-align:middle;}
.btn a {display:block; text-align:center; line-height:1; text-decoration:none; color:#fff !important;}
.btn5 a {padding:5px 0; font-size:10px; font-weight:normal;}
.gryB {border:1px solid #aaa; background-color:#bbb; color:#fff !important;}
.w40B {width:36px;}
.paging {width:100%; text-align:center;}
.paging a {display:inline-block; width:38px; height:38px; border:1px solid #ddd; background-color:#fff; font-size:13px; margin:0 3px; font-weight:bold;}
.paging a span {display:table-cell; width:38px; height:38px; vertical-align:middle; color:#888;}
.paging a.arrow {background-color:#ccc; border:1px solid #ccc;}
.paging a.current span {background-color:#f0f0f0; color:#444;}
.paging a span.elmBg {text-indent:-9999px; overflow:hidden;}
.paging a span.prev {background-position:-281px -154px;}
.paging a span.next {background-position:-229px -154px;}

@media all and (min-width:480px){
	.evtNoti {padding:24px 40px;}
	.evtNoti li {font-size:16px; padding-left:15px; background-size:5px 8px; background-position:left 5px;}
	.applyCamping .cmtField .writeCmt {margin:40px auto 32px;}
	.applyCamping .cmtField textarea {height:130px; font-size:16px;}
	.tentList li {margin-bottom:12px;}
	.tentList li .num {font-size:15px;}
	.tentList li .applyDate {font-size:16px; }
	.tentList li .cmtCont .txt {font-size:16px; line-height:20px; padding:15px 25px;}
	.tentList li .icoMobile {left:10px; top:18px;}
	.tentList li .cmtCont .writer {font-size:15px;}
}
</style>
<script type="text/javascript">
$(function(){
	$('.tentList .bg01 .tentImg').append('<img src="http://webimage.10x10.co.kr/eventIMG/2014/50842/cmt_tent01.png" alt="" />');
	$('.tentList .bg02 .tentImg').append('<img src="http://webimage.10x10.co.kr/eventIMG/2014/50842/cmt_tent02.png" alt="" />');
	$('.tentList .bg03 .tentImg').append('<img src="http://webimage.10x10.co.kr/eventIMG/2014/50842/cmt_tent03.png" alt="" />');
	$('.tentList .bg04 .tentImg').append('<img src="http://webimage.10x10.co.kr/eventIMG/2014/50842/cmt_tent04.png" alt="" />');
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
			parent.calllogin();
			return false;
		<% end if %>

	   
	   if(!(frm.spoint[0].checked||frm.spoint[1].checked)){
	    alert("날짜를 선택 해주세요");
	    return false;
	   }

	    if(!frm.txtcomm.value || frm.txtcomm.value == "100자 이내로 입력해주세요."){
	    alert("100자 이내로 입력해주세요.");
		document.frmcom.txtcomm.value="";
	    frm.txtcomm.focus();
	    return false;
	   }

	   	if(GetByteLength(frm.txtcomm.value)>201){
			alert('100자 까지 가능합니다.');
	    frm.txtcomm.focus();
	    return false;
		}

	   frm.action = "doEventSubscript54807.asp";
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
			if(document.frmcom.txtcomm.value == "100자 이내로 입력해주세요." ){
				document.frmcom.txtcomm.value="";
			}
			return true;
		} else {
			parent.calllogin();
			return false;
		}

		return false;
	}

	function jsChkUnblur()
	{
		if(document.frmcom.txtcomm.value ==""){
			document.frmcom.txtcomm.value = "100자 이내로 입력해주세요."
		}
	}

	function Limit(obj)
	{
	   var maxLength = parseInt(obj.getAttribute("maxlength"));
	   if ( obj.value.length > maxLength ) {
		alert("글자수는 100자 이내로 제한됩니다.");
		obj.value = obj.value.substring(0,maxLength); //100자 이하 튕기기
		}
	}

//-->
</script>
</head>
<body>
<div class="mEvt54806">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/54806/tit_around_camping.png" alt="" /></h2>
	<div class="vedioCont">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54806/tit_festival.png" alt="" /></h3>
		<div class="video">
			<iframe src="//player.vimeo.com/video/96452868" frameborder="0" webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen="" title="어라운드 캠핑 페스티발 동영상"></iframe>
			<p class="bg"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54806/bg_movie.png" alt="" /></p>
		</div>
		<div class="goAround"><a href=""><img src="http://webimage.10x10.co.kr/eventIMG/2014/54806/btn_go_around.png" alt="" /></a></div>
	</div>
	<!-- sns 공유 -->
	<div class="shareAround">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54806/txt_share_sns.png" alt="어라운드 캠핑 페스티벌 소식 전하기!" /></p>
		<div class="btnShare">
			<a href="javascript:popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','')"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54806/btn_facebook.png" alt="페이스북" /></a>
			<a href="javascript:popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>')"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54806/btn_twitter.png" alt="트위터" /></a>
		</div>
	</div>
	<!--// sns 공유 -->

	<!-- 코멘트 작성 -->
	<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
	<input type="hidden" name="eventid" value="<%=eCode%>"/>
	<input type="hidden" name="bidx" value="<%=bidx%>"/>
	<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
	<input type="hidden" name="iCTot" value=""/>
	<input type="hidden" name="mode" value="add"/>
	<input type="hidden" name="userid" value="<%=GetLoginUserID%>"/>
	<input type="hidden" name="txtcommURL" value="<%=rencolor%>"/>
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54806/txt_comment_event.png" alt="COMMENT EVENT - 원하는 일정을 선택하고 코멘트를 남겨주세요!" /></h3>
	<div class="applyCamping">
		<div class="cmtField">
			<ul>
				<li>
					<label for="selectDate01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54806/txt_date01.png" alt="첫째 날 , 1박 2일" /></label>
					<input type="radio" id="selectDate01" name="spoint" value="1"/>
				</li>
				<li>
					<label for="selectDate02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54806/txt_date02.png" alt="둘째 날 , 1박 2일" /></label>
					<input type="radio" id="selectDate02" name="spoint" value="2"/>
				</li>
			</ul>
			<div class="writeCmt">
				<textarea title="코멘트 작성" cols="60" rows="5" id="writearea" name="txtcomm" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur()" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');return Limit(this);" <%IF NOT IsUserLoginOK THEN%>readonly<%END IF%> autocomplete="off" maxlength="200">100자 이내로 입력해주세요.</textarea>
			</div>
			<div class="btnSubmit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/54806/btn_submit.png" alt="감성캠핑 응모하기" /></div>
		</div>
		<p class="bg"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54806/bg_comment.png" alt="" /></p>
	</div>
	<ul class="evtNoti">
		<li>통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며 이벤트 참여에 제한을 받을 수 있습니다.</li>
	</ul>
	</form>
	<form name="frmdelcom" method="post" action="/event/lib/comment_process.asp" style="margin:0px;">
	<input type="hidden" name="eventid" value="<%=eCode%>">
	<input type="hidden" name="bidx" value="<%=bidx%>">
	<input type="hidden" name="Cidx" value="">
	<input type="hidden" name="mode" value="del">
	<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
	</form>
	<!--// 코멘트 작성 -->

	<% IF isArray(arrCList) THEN %>
	<!-- 코멘트 리스트 -->
	<ul class="tentList">
		<% For intCLoop = 0 To UBound(arrCList,2) %>
		<li class="bg0<%=arrCList(7,intCLoop)%>">
			<p class="num"><%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
			<p class="applyDate"><%=chkiif(arrCList(3,intCLoop) = "1","첫째 날 <br/>09.26 ~ 27 , 1박 2일 응모","둘째 날 <br/> 09.27 ~ 28 , 1박 2일 응모")%></p>
			<p class="tentImg"></p>
			<div class="cmtCont">
				<% If arrCList(8,intCLoop) = "M"  then%>
				<span class="icoMobile"><img src="http://fiximage.10x10.co.kr/m/2013/common/ico_mobile.png" alt="모바일에서 작성" style="width:9px;" /></span>
				<% End If %>
				<div class="txt">
					<p><%=nl2br(arrCList(1,intCLoop))%></p>
					<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
					<span class="btn btn5 gryB w40B"><a href="javascript:jsDelComment('<% = arrCList(0,intCLoop) %>');">삭제</a></span>
					<% end if %>
				</div>
				<p class="writer"><strong><%=printUserId(arrCList(2,intCLoop),2,"*")%></strong> | <%=formatdate(arrCList(4,intCLoop),"0000.00.00")%></p>
			</div>
		</li>
		<% Next %>
	</ul>
	<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
	<% End If %>
	<!--// 코멘트 리스트 -->
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->