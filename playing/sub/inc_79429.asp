<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : Playing Thing Vol.20 튜브 향초
' History : 2017-07-20 유태욱 생성
'####################################################
Dim eCode , userid, vDIdx, commentcount, pagereload
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66400
Else
	eCode   =  79429
End If

vDIdx = request("didx")
userid	= getencLoginUserid()

If userid <> "" then
	commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")
Else
	commentcount = 0
End If 

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),2)

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
	iCPageSize = 4		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 4		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
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
<style type="text/css">
.thingVol020 {overflow:hidden; text-align:center;}

.tubeMain {position:relative; background-color:#ffe243;}
.tubeMain h2 span{display:inline-block; width:60.62%;}
.tubeMain h2 span.t2{width:84.21%; padding-top:1rem;}
.tubeMain .subcp2 {padding-bottom:2.1rem;}

.infoTube {position:relative;}
.infoTube .txtRanking {position:absolute; top:0; left:0; z-index:50;}
.infoTube div {position:absolute; top:0%; left:0%; z-index:0; width:100%; opacity:0;}
.infoTube div.rankig3 {z-index:5;}
.infoTube div.deco {z-index:10;}
.introTube {background:#343434 url(http://webimage.10x10.co.kr/playing/thing/vol020/m/bg_black.jpg) no-repeat 0 0; background-size:100%;}
.introTube p{width:66.25%; margin:0 auto;}
.introTube .t1 {padding:5.7rem 0 2rem;}
.introTube .t2{width:64.53%; padding-bottom:6.2rem; opacity:0;}

.whatOrder {padding-bottom:1.71rem; background-color:#f0f0f0;}
.whatOrder .cmtEvt .enter {position:relative;}
.whatOrder .cmtEvt .enter input {position:absolute; top:22.38%; left:0; width:100%; height:17.95%; padding:7% 12%; background-color:transparent; font-size:1.3rem; line-height:1.3rem; font-weight:bold; color:#000; text-align:center; border:none;}
.whatOrder .cmtEvt .enter input::-input-placeholder {color:#f8f4f4;}
.whatOrder .cmtEvt .enter input::-webkit-input-placeholder {color:#f8f4f4;}
.whatOrder .cmtEvt .enter input::-moz-placeholder {color:#f8f4f4;}
.whatOrder .cmtEvt .enter input:-ms-input-placeholder {color:#f8f4f4;}
.whatOrder .cmtEvt .enter input:-moz-placeholder {color:#f8f4f4;}
.whatOrder .cmtEvt .enter .btnEnter {width:100%;}
.whatOrder .cmtEvt ul {padding:4.1rem 1.75rem .3rem; background-color:#d9d9d9;}
.whatOrder .cmtEvt ul li {position:relative; width:100%; height:9rem; margin-bottom:2rem; padding:1.5rem 1.4rem;background-color:#fff;}
.whatOrder .cmtEvt ul li .close {display:inline-block; position:absolute; top:0; right:0;}
.whatOrder .cmtEvt ul li p {width:100%; text-align:left; font-size:1rem; font-weight:bold;}
.whatOrder .cmtEvt ul li p span {display:inline-block;}
.whatOrder .cmtEvt ul li p .userId{margin-left:.3rem; color:#888888;}
.whatOrder .cmtEvt ul li .conts {margin-top:.8rem; text-align:left; font-size:1.5rem; line-height:2.2rem; color:#555555;}
.whatOrder .cmtEvt ul li .conts strong {width:15rem; color:#000;}
.pagingV15a .current {color:#000;}
.pagingV15a .arrow a:after {background-position:-5.8rem -9.56rem;}
/*.whatOrder .pageWrapV15 {position:relative; width:100%; height:5.3%; padding-bottom:4rem; background-color:#d9d9d9;}
.whatOrder .pageWrapV15 .paging {height:100%; margin:0;}
.whatOrder .pageWrapV15 .paging span {color:#000;}
.whatOrder .pageWrapV15 .paging span a {color:#000;}
.whatOrder .pageWrapV15 .paging span.arrow {display:inline-block; width:2.5%; background-color:transparent; border:none;}
.whatOrder .pageWrapV15 .paging span {width:3.2rem; height:3.2rem; margin:0 .6rem; border:none; color:#000; font-weight:bold; font-size:1.2rem; line-height:3.5rem;}
.whatOrder .pageWrapV15 .paging span.prevBtn {left:8.2%; background-image:url(http://webimage.10x10.co.kr/playing/thing/vol020/m/btn_prev.png);}
.whatOrder .pageWrapV15 .paging span.nextBtn {right:8.2%; background-image:url(http://webimage.10x10.co.kr/playing/thing/vol020/m/btn_next.png);}
.whatOrder .pageWrapV15 .paging span.current {background-color:#ffe953; border-radius:50%;}*/
.blink1 {animation:blink 1.5s 2;}
.blink2 {animation:blink 1s 2;}
@keyframes blink {
	from, to {opacity:0;}
	50% {opacity:1;}
}
</style>
<script style="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$("#tV020").offset().top}, 0);
});

$(function(){
	$(window.parent).scroll(function(){
		var scrollTop = $(window.parent).scrollTop();
		var chart = $(".tubeMain").offset().top;
		var intro = $(".rankingList").offset().top - 100;
		if (scrollTop > chart) {
			tubeAni();
		}
		if (scrollTop > intro) {
			$(".introTube .t2").addClass("blink1").animate({"opacity":"1"},100);
		}
	});
	titleAnimation();
	$("h2 .t1").css({"margin-left":"-4rem","opacity":"0"});
	$("h2 .t1 span").css({"width":"0","opacity":"0"});
	$("h2 .t2").css({"margin-left":"20px","opacity":"0"});
	function titleAnimation() {
		$("h2 .t1").delay(300).animate({"margin-left":"-2.2rem","opacity":"1"},600);
		$("h2 .t1 span").delay(500).animate({"width":"215px","opacity":"1"},600);
		$("h2 .t2").delay(350).animate({"margin-left":"0","opacity":"1"},600);
	}
	$(".infoTube div").css({"opacity":"0"});
	function tubeAni() {
		$(".infoTube div.colorTube").delay(100).animate({"opacity":"1"},500);
		$(".infoTube div.txtRanking").delay(700).animate({"opacity":"1"},500);
		$(".infoTube div.rankig3").delay(1200).animate({"opacity":"1"},500);
		setTimeout(function(){$(".infoTube div.deco").addClass("blink2").animate({"opacity":"1"},500); }, 1500);
	}

	<% if pagereload<>"" then %>
		//pagedown();
		setTimeout("pagedown()",500);
	<% end if %>
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$("#commentList").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% if date() >="2017-07-20" and date() < "2017-08-07" then %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if(!frm.txtcomm.value){
					alert("내용을 적어주세요!");
					document.frmcom.txtcomm.value="";
					frm.txtcomm.focus();
					return false;
				}

				if (GetByteLength(frm.txtcomm.value) > 20){
					alert("제한길이를 초과하였습니다. 10자 까지 작성 가능합니다.");
					frm.txtcomm.focus();
					return false;
				}

				frm.action = "/event/lib/doEventComment.asp";
				frm.submit();
			<% end if %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% end if %>
	<% Else %>
		<% If isApp="1" or isApp="2" Then %>
		calllogin();
		return false;
		<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
		<% end if %>			
	<% End IF %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmactNew.Cidx.value = cidx;
   		document.frmactNew.submit();
	}
}

function jsChklogin22(blnLogin)
{
	if (blnLogin == "True"){
		return true;
	} else {
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
			return false;
		<% end if %>			
	}
	return false;
}

function maxLengthCheck(object){
	if ("<%=IsUserLoginOK%>"=="False") {
		if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
			<% If isApp="1" or isApp="2" Then %>
				calllogin();
				return false;
			<% else %>
				jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
				return false;
			<% end if %>	
		}
		return false;
	}
	if (object.value.length > object.maxLength)
	  object.value = object.value.slice(0, object.maxLength)
}
</script>

	<div class="thingVol020 whyTube" id="tV020">
		<div class="section tubeMain">
			<p class="subcp1"><img src="http://webimage.10x10.co.kr/playing/thing/vol020/m/txt_subcp_1.jpg" alt="장바구니 궁금증 _ 튜브편" /></p>
			<h2>
				<span class="t1"><img src="http://webimage.10x10.co.kr/playing/thing/vol020/m/tit_tube_1.png" alt="튜브를 사는" /></span>
				<span class="t2"><img src="http://webimage.10x10.co.kr/playing/thing/vol020/m/tit_tube_2.png" alt="사람들은 왜 그럴까?" /></span>
			</h2>
			<p class="subcp2"><img src="http://webimage.10x10.co.kr/playing/thing/vol020/m/txt_subcp_2.jpg" alt="튜브를 샀던 사람들의 장바구니에 가장 많이 담겨있던 물건은 뭘까?" /></p>
			<div class="infoTube">
				<img src="http://webimage.10x10.co.kr/playing/thing/vol020/m/img_tube.png" alt="" />
				<div class="colorTube"><img src="http://webimage.10x10.co.kr/playing/thing/vol020/m/img_color_tube.png" alt="" /></div>
				<div class="txtRanking"><img src="http://webimage.10x10.co.kr/playing/thing/vol020/m/txt_ranking.png" alt="1위 에어펌프 2위 비치타올 4위 방수팩 5위 물놀이용 파우치 6위 기타" /></div>
				<div class="rankig3"><img src="http://webimage.10x10.co.kr/playing/thing/vol020/m/img_ranking_3_v2.png" alt="3위 향초" /></div>
				<div class="deco"><img src="http://webimage.10x10.co.kr/playing/thing/vol020/m/img_lines.png" alt="" /></div>
			</div>
			<div class="rankingList"><img src="http://webimage.10x10.co.kr/playing/thing/vol020/m/txt_ranking.jpg" alt="1위 에어펌프 2위 비치타올 3위 향초 4위 방수팩 5위 물놀이용 파우치 6위 기타" /> </div>
		</div>

		<div class="section introTube">
				<p class="t1"><img src="http://webimage.10x10.co.kr/playing/thing/vol020/m/txt_intro1.png" alt="어라? 에어펌프, 비치타올, 방수팩, 물놀이용 파우치! 다 함께 주문할 것 같은 아이템들인데" /></p>
				<p class="t2"><img src="http://webimage.10x10.co.kr/playing/thing/vol020/m/txt_intro2.png" alt="그중 하나 3위에 속한 향초는 왜?" /></p>
		</div>

		<div class="section whyCandle">
			<div><img src="http://webimage.10x10.co.kr/playing/thing/vol020/m/txt_why_candle.jpg" alt="왜 튜브를 산 사람들이 향초를 함께 주문했을까? SNS를 좋아해서 여행 갔을 때, 낮엔 튜브와 함께 찍고 저녁엔 분위기 있게 향초를 피우려고 인증샷을 남기려는 건 아닐까요? 습한 곳으로 여행 가는 사람들이 튜브와 함께 사지 않았을까요? 튜브로 열심히 수영하고, 지친 몸을 팩과 함께 향초를 피우며 힐링 하려고 함께 사지 않았을까요? 그렇다면 물놀이 여행 가는 많은 사람들이 튜브와 향초를 애용한다는 것 아닐까요? " /></div>
			<a href="/event/eventmain.asp?eventid=79429" class="mWeb"><img src="http://webimage.10x10.co.kr/playing/thing/vol020/m/btn_rcm_item.jpg" alt="의견을 모아본 결과, 습한 여행지에서 함께 주문할 것이라는 의견이 많았습니다 튜브와 향초를 함께 주문하는 그들의 의외지만 현명한 선택, 물놀이 여행에서 함께 주문해보자!향초&튜브 추천 아이템 보기" /></a>
			<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=79429" onclick="fnAPPpopupEvent('79429'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/playing/thing/vol020/m/btn_rcm_item.jpg" alt="의견을 모아본 결과, 습한 여행지에서 함께 주문할 것이라는 의견이 많았습니다 튜브와 향초를 함께 주문하는 그들의 의외지만 현명한 선택, 물놀이 여행에서 함께 주문해보자!향초&튜브 추천 아이템 보기" /></a>
		</div>

		<div class="section whatOrder">
			<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol020/m/tit_cmt_evt.jpg" alt="튜브는 향초와 함께, 그렇다면 향초는 무엇과 함께 주문하시나요? 응모기간은  2017년 07월 24일 부터 2017년 08월 06일 까지 입니다.사은품은 튜브컵 홀더 증정합니다. 추첨인원수는 20명입니다." /></h3>
			<div class="cmtEvt">
			<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
			<input type="hidden" name="mode" value="add">
			<input type="hidden" name="pagereload" value="ON">
			<input type="hidden" name="iCC" value="1">
			<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
			<input type="hidden" name="eventid" value="<%= eCode %>">
			<input type="hidden" name="linkevt" value="<%= eCode %>">
			<input type="hidden" name="blnB" value="">
			<input type="hidden" name="returnurl" value="<%= appUrlPath %>/playing/view.asp?didx=<%=vDIdx%>&pagereload=ON">
			<input type="hidden" name="isApp" value="<%= isApp %>">	
			<input type="hidden" name="spoint"/>
				<div class="enter">
					<img src="http://webimage.10x10.co.kr/playing/thing/vol020/m/txt_cmt_box.jpg" alt="나는 향초 살 때, *** 과(와) 함께 사요!" />
					<input type="text" class="inpTeam" placeholder="10자이내로 입력해주세요." id="txtcomm" name="txtcomm"  onclick="maxLengthCheck(this)" maxlength="10"/> <!-- for dev msg 10자로 제한 -->
					<button class="btnEnter" onclick="jsSubmitComment(document.frmcom); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol020/m/btn_enter.jpg" alt="응모하기" /></button>
				</div>
			</form>

			<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
			<input type="hidden" name="mode" value="del">
			<input type="hidden" name="pagereload" value="ON">
			<input type="hidden" name="Cidx" value="">
			<input type="hidden" name="returnurl" value="<%= appUrlPath %>/playing/view.asp?didx=<%=vDIdx%>&pagereload=ON">
			<input type="hidden" name="eventid" value="<%= eCode %>">
			<input type="hidden" name="linkevt" value="<%= eCode %>">
			<input type="hidden" name="isApp" value="<%= isApp %>">
			</form>

			<% IF isArray(arrCList) THEN %>
				<ul id="commentList"><!-- for dev msg 4개씩 노출 -->
					<% For intCLoop = 0 To UBound(arrCList,2) %>
						<li>
							<p>
								<span class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
								<span class="userId"><em><%=printUserId(arrCList(2,intCLoop),4,"*")%></em>님</span>
							</p>
							<div class="conts">
								<span>나는 향초 살 때</span><br/ >
								<strong><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></strong>
								<span>과(와) 함께 사요.</span>
							</div>
							<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
								<button class="close" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol020/m/btn_close.png" alt="닫기" /></button>
							<% End If %>
						</li>
					<% Next %>
				</ul>
				<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
			<% End If %>
			</div>
		</div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->