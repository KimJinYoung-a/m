<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  play 동방불펜
' History : 2015.01.23 한용민 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/play/groundcnt/event58990Cls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->

<%
dim eCode, tmponload
	eCode   =  getevt_code()
	tmponload	= requestCheckVar(request("upin"),2)
	
dim commentexistscount, userid, i
commentexistscount=0
userid = getloginuserid()

if userid<>"" then
	commentexistscount=getcommentexistscount(userid, eCode, "", "", "", "Y")
end if

dim com_egCode, bidx, isMyComm
	Dim cEComment
	Dim iCTotCnt, arrCList,intCLoop
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt

	'파라미터값 받기 & 기본 변수 값 세팅
	iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	com_egCode = requestCheckVar(Request("eGC"),1)	
	isMyComm	= requestCheckVar(request("isMC"),1)
	
	IF iCCurrpage = "" THEN iCCurrpage = 1
	IF iCTotCnt = "" THEN iCTotCnt = -1

	'// 그룹번호 랜덤으로 지정

	iCPageSize = 10		'한 페이지의 보여지는 열의 수
	iCPerCnt = 4		'보여지는 페이지 간격

	'코멘트 데이터 가져오기
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	'cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수
	if isMyComm="Y" then cEComment.FUserID = GetLoginUserID

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

%>

<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.mPlay20150126 {}
.goBuy {position:relative;}
.goBuy a {display:none; position:absolute; left:15%; bottom:11.5%; width:70%; height:11%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
.penSwiper {position:relative; width:320px; margin:0 auto;}
.penSwiper .swiper-container {overflow:hidden; width:100%;}
.penSwiper .swiper .swiper-slide {float:left;}
.penSwiper .penPagination {position:absolute; left:0; bottom:15px; width:100%; text-align:center; z-index:50;}
.penSwiper .penPagination span {display:inline-block; width:28px; height:3px; margin:0 3px; background-color:#fff;}
.penSwiper .penPagination .swiper-active-switch {background-color:#a93232;}
.dbWriteWrap { padding:30px 0; background:url(http://webimage.10x10.co.kr/playmo/ground/20150126/bg_write.gif) left top repeat-y; background-size:100% auto;}
.dbWrite p {position:relative;}
.dbWrite .inpLetter {position:absolute; left:23%; top:9.5%;width:35%; height:80%; border:0; border-radius:0; text-align:center; color:#333; font-weight:400; font-size:17px; vertical-align:middle;}
.dbWrite .apply {display:block; width:50%; margin:20px auto 0;}
.dbCmtList ul {overflow:hidden; padding:40px 10px 10px; background:url(http://webimage.10x10.co.kr/playmo/ground/20150126/bg_cmt_cont.gif) left top repeat-y; background-size:100% auto; border-bottom:1px solid #973838;}
.dbCmtList li {position:relative; float:left; width:50%; padding:0 10px 15px; font-size:12px; line-height:1; font-weight:500; color:#973838;}
.dbCmtList li .num {}
.dbCmtList li .delete {display:inline-block; position:absolute; right:24px; top:3px; z-index:50; width:20px; height:20px; text-align:center; color:#fff; font-size:14px; line-height:22px; font-weight:bold; background:#973838; border-radius:50%;}
.dbCmtList li .word {position:relative; background-position:left top; background-repeat:no-repeat; background-size:100% 100%;}
.dbCmtList li .word span {display:block; position:absolute; left:50%; top:23%; width:20px; height:52%; text-align:center; margin-left:-10px; font-size:17px; line-height:1.3; color:#111;}
.dbCmtList li .word span em {}
.dbCmtList li.c01 .word {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150126/bg_cmt01.gif);}
.dbCmtList li.c02 .word {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150126/bg_cmt02.gif);}
.dbCmtList li.c03 .word {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150126/bg_cmt03.gif);}
.dbCmtList li .writer {text-align:right; padding-top:2px;}
.dbCmtList li .writer .mob {width:6px; margin-right:4px;}
@media all and (min-width:375px){
	.penSwiper {width:375px;}
}
@media all and (min-width:480px){
	.penSwiper {width:480px;}
	.penSwiper .penPagination {bottom:23px;}
	.penSwiper .penPagination span {width:42px; height:4px; margin:0 4px;}
	.dbWrite .inpLetter {font-size:26px;}
	.dbCmtList ul {padding:60px 15px 15px;}
	.dbCmtList li {padding:0 15px 23px; font-size:18px;}
	.dbCmtList li .delete {right:36px; top:4px; width:30px; height:30px; font-size:21px; line-height:33px;}
	.dbCmtList li .word span {width:30px; margin-left:-15px; font-size:26px;}
	.dbCmtList li .writer {padding-top:3px;}
	.dbCmtList li .writer .mob {width:9px; margin-right:6px;}
}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.penPagination',
		paginationClickable:true,
		speed:1000,
		autoplay:5000,
		autoplayDisableOnInteraction: true,
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$('a.ma').css('display','block');
	}else{
		$('a.mw').css('display','block');
	}
});

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		jsChklogin('<%=IsUserLoginOK%>');
	}

	//if(frmcom.txtcomm.value =="코멘트 입력 (50자 이내)"){
	//	frmcom.txtcomm.value ="";
	//}
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}
											
function jsSubmitComment(){
	<% If IsUserLoginOK() Then %>
		<% If not( getnowdate>="2015-01-26" and getnowdate<"2015-02-04") Then %>
			alert('이벤트 응모 기간이 아닙니다.');
			return;
		<% end if %>
		<% if commentexistscount>=5 then %>
			alert('한아이디당 5회 까지만 참여가 가능 합니다.');
			return;
		<% end if %>

		//if(frmcom.txtcomm.value =="코멘트 입력 (50자 이내)"){
		//	frmcom.txtcomm.value ="";
		//}
		if(!frmcom.txtcomm.value){
			alert("코멘트를 입력해주세요");
			frmcom.txtcomm.focus();
			return false;
		}

		//if (GetByteLength(frmcom.txtcomm.value) > 50){
		//	alert("코맨트가 제한길이를 초과하였습니다. 50자 까지 작성 가능합니다.");
		//	frmcom.txtcomm.focus();
		//	return;
		//}

		frmcom.action='/play/groundcnt/doEventSubscript58990.asp';
		frmcom.submit();
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/play/playGround.asp")%>');
			return false;
		<% end if %>
	<% End IF %>
}

function jsDelComment(cidx)	{
	<% If IsUserLoginOK() Then %>
		if (cidx==""){
			alert('정상적인 경로가 아닙니다');
			return;
		}
		
		if(confirm("삭제하시겠습니까?")){
			document.frmdelcom.Cidx.value = cidx;
			document.frmdelcom.action='/play/groundcnt/doEventSubscript58990.asp';
	   		document.frmdelcom.submit();
		}
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/play/playGround.asp")%>');
			return false;
		<% end if %>
	<% End IF %>
}


<% if tmponload="ON" then %>
	$(function(){
		window.parent.$('html,body').animate({scrollTop:$("#sectiontemp").offset().top}, 500);
		//window.parent.$('html,body').animate({scrollTop:5600}, 500);
		//document.getElementById('sectiontemp').scrollIntoView();
	});
<% end if %>

</script>
</head>
<body>

<!-- GROUND#4 동방불펜 -->
<div class="mPlay20150126">
	<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150126/tit_dongbang.gif" alt="동방불펜" /></h2>
	<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150126/txt_meaning.gif" alt="동쪽에서 해가 뜨는 한 절대 지지 않는다!" /></p>
	<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150126/img_scene01.jpg" alt="때로는 세상에 졌다는 생각이 들거나" /></div>
	<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150126/img_scene02.jpg" alt="자신과의 싸움에서 졌다는 생각이 드는 순간" /></div>
	<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150126/txt_pen_info01.gif" alt="당신에게 소소한 재미와 당당한 자신감을 불어 넣어 줄 단 하나의 펜!" /></p>
	<div>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150126/txt_pen_info02.gif" alt="동방불펜" /></p>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150126/img_move_pen.gif" alt="펜 이미지" /></p>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150126/txt_pen_info03.gif" alt="손에 알맞게 들어와 쥐락펴락 할 수 있는 안락한 블랙무광터치마이바디" /></p>
	</div>
	<div class="goBuy">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150126/img_package.gif" alt="동방불펜 불패엽서 세트" /></p>
		
		<% if isApp=1 then %>
			<a href="#" onclick="parent.fnAPPpopupProduct('1204400'); return false;" class="ma">동방불펜 구매하러 가기</a>
		<% else %>
			<a href="/category/category_itemprd.asp?itemid=1204400" class="mw" target="_top">동방불펜 구매하러 가기</a>
		<% end if %>
	</div>
	<div class="penSwiper">
		<div class="swiper-container swiper1">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150126/img_slide01.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150126/img_slide02.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150126/img_slide03.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150126/img_slide04.jpg" alt="" /></div>
			</div>
		</div>
		<div class="penPagination"></div>
	</div>

	<!-- 코멘트 이벤트-->
	<div class="dbCmt">
		<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20150126/tit_comment_v1.jpg" alt="동방불펜 출시 기념 이벤트 -  나 살면서 이런 부분에서만큼은 지고 싶지 않다 하는 순간이 있으신가요?" /></h3>

		<form name="frmcom" method="post" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="bidx" value="<%=bidx%>">
		<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
		<input type="hidden" name="iCTot" value="">
		<input type="hidden" name="mode" value="add">
		<input type="hidden" name="spoint" value="0">
		<input type="hidden" name="isMC" value="<%=isMyComm%>">
		<!-- 다섯자 작성 -->
		<div class="dbWriteWrap"  id="sectiontemp">
			<div class="dbWrite">
				<p>
					<span><img src="http://webimage.10x10.co.kr/playmo/ground/20150126/txt_lose.gif" alt="나는 지지 않는다" /></span>
					<input type="text" name="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> maxlength=5 class="inpLetter" /><% 'IF NOT IsUserLoginOK THEN%><!--로그인 후 글을 남길 수 있습니다.--><% ' else %><!--코멘트 입력 (50자 이내)--><% 'END IF%>
				</p>
				<input type="image" onclick="jsSubmitComment(); return false;" src="http://webimage.10x10.co.kr/playmo/ground/20150126/btn_apply.gif" alt="응모하기" class="apply" />
			</div>
		</div>
		<!--// 다섯자 작성 -->
		</form>
		<form name="frmdelcom" method="post" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="bidx" value="<%=bidx%>">
		<input type="hidden" name="Cidx" value="">
		<input type="hidden" name="mode" value="del">
		</form>

		<% IF isArray(arrCList) THEN %>
			<!-- 코멘트 리스트 -->
			<div class="dbCmtList">
				<ul>
					<%' <!-- for dev msg : li에 랜덤으로 클래스 c01~03 넣어주세요 / 리스트는 8개씩 노출됩니다 --> %>
					<%
					dim rndNo
						rndNo=1
					randomize
					rndNo = Int((3 * Rnd) + 1)
					
					For i = 0 To UBound(arrCList,2)
					%>
					<li class="c0<%= rndNo %>">
						<p class="num">no.<%=iCTotCnt-i-(iCPageSize*(iCCurrpage-1))%></p>
						
						<% if ((GetLoginUserID = arrCList(2,i)) or (GetLoginUserID = "10x10")) and ( arrCList(2,i)<>"") then %>
							<a href="" onclick="jsDelComment('<% = arrCList(0,i) %>'); return false;" class="delete">X</a>
						<% end if %>

						<p class="word">
							<span><em><%= ReplaceBracket(db2html(arrCList(1,i))) %></em></span>
							<img src="http://webimage.10x10.co.kr/playmo/ground/20150126/bg_cmt_blank.png" alt="" />
						</p>
						<p class="writer">
							<% If arrCList(8,i) <> "W" Then %>
								<img src="http://webimage.10x10.co.kr/playmo/ground/20150126/ico_mobile.gif" alt="모바일에서 작성" class="mob" />
							<% end if %>
							<%=printUserId(arrCList(2,i),2,"*")%>
						</p>
					</li>
					<% next %>
				</ul>
	
				<div class="paging">
					<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
				</div>
			</div>
			<!--// 코멘트 리스트 -->
		<% end if %>
	</div>
	<!--// 코멘트 이벤트-->
</div>
<!--// GROUND#4 동방불펜 -->

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->