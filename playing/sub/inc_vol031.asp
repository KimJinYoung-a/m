<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAYing 연말정산
' History : 2017-12-21 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<%
Dim eCode , userid , pagereload , vDIdx
dim arrList

IF application("Svr_Info") = "Dev" THEN
	eCode   =  67495
Else
	eCode   =  82743
End If

vDIdx = request("didx")
userid = GetEncLoginUserID()

Dim totalresultCnt, sqlStr, sub_opt1, sub_opt2, sub_opt3, sub_opt4

'2. 전체 참여자 카운트
sqlStr = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "'"
rsget.Open sqlStr,dbget,1
If not rsget.EOF Then
	totalresultCnt = rsget(0)
End If
rsget.close

sqlStr = "SELECT sub_opt1,sub_opt2,sub_opt3 FROM [db_event].[dbo].[tbl_event_subscript] WHERE  evt_code = '"& eCode &"' and userid= '"&Cstr(userid)&"'"
rsget.Open sqlStr, dbget, 1
If not rsget.EOF Then
	sub_opt1 = rsget("sub_opt1")
	sub_opt2 = rsget("sub_opt2")
	sub_opt3 = rsget("sub_opt3")
	If sub_opt2="0" Then
		sub_opt4=1
	Else
		sub_opt4=sub_opt2
	End If
Else
	sub_opt1 = 0
	sub_opt2 = 0
	sub_opt3 = 0
End If
rsget.close


dim commentcount, i

If userid <> "" then
	commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")
Else
	commentcount = 0
End If 

vDIdx = request("didx")

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

iCPerCnt = 5		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 3		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 3		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
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
.topic {position:relative;}
.topic h2 {position:absolute; left:50%; top:15.58%; width:50.6%; margin-left:-25.3%;}
.topic p {position:absolute; left:50%; top:47.6%; width:52.5%; margin-left:-26.25%;}
.event {padding-bottom:4.3rem; background-color:#444e98;}
.event .section {position:relative; padding:2.3rem 0;}
.event .section h4 {position:absolute; left:2.2rem; top:4.5rem; color:#fff; font-size:1.4rem; line-height:1.4;}
.event .section .rolling {padding-left:8.8rem;}
.event .section1, .event .section3 {background-color:#384394;}
.event .swiper-slide {width:10rem; padding-right:1.2rem; text-align:center;}
.event .swiper-slide input {visibility:hidden; position:absolute; left:0; top:0; width:0; height:0; border:0;}
.event .swiper-slide label {display:block; position:relative; cursor:pointer; color:#fff; font-size:1rem; font-weight:600; letter-spacing:-0.03rem; white-space:nowrap;}
.event .swiper-slide label img {display:block; padding-bottom:0.8rem;}
.event .swiper-slide input[type=radio]:checked + label:before {display:block; content:''; position:absolute; left:0; top:0; width:8.8rem; height:8.8rem; background:rgba(0,0,0,.7); border-radius:50%;}
.event .swiper-slide input[type=radio]:checked + label:after {display:block; content:''; position:absolute; left:50%; top:3.3rem; width:3rem; height:2.05rem; margin-left:-1.5rem; background:url(http://webimage.10x10.co.kr/playing/thing/vol031/m/ico_check.png) 0 0 no-repeat; background-size:97% auto; animation:bounce1 .3s;}
.event .btn-vote {display:block; width:63.5%; height:5rem; color:#fff; font-size:1.5rem; font-weight:bold; margin:2.5rem auto 1rem; background-color:#fc5c35;}
.event .btn-vote.finish {background-color:#909090;}
.event .total {color:#a4afff; font-size:1.1rem; font-weight:bold; text-align:center;}
.comment {padding-bottom:4rem; background-color:#f2f2f2;}
.comment-write {padding:0 5.3125%;}
.comment-write textarea {display:block; width:100%; height:15rem; border:0; font-size:1.2rem; color:#252525;}
.comment-write .btn-submit {display:block; width:100%; height:5rem; color:#fff; font-size:1.5rem; font-weight:bold; background-color:#fc5c35;}
.comment-list ul {padding:0 5.3125%;}
.comment-list li {margin-top:2.4rem; padding:1.3rem;  font-size:1.1rem; line-height:1.5; color:#555; background-color:#fff;}
.comment-list .num {position:relative; padding-bottom:1rem; color:#000; font-size:1rem; font-weight:600; line-height:1;}
.comment-list .num .writer {position:absolute; right:0; top:0; color:#888;}
.comment-list .btn-delete {display:inline-block; margin-top:0.5rem;  padding:0 0.8rem; color:#fff; font-size:1.1rem; line-height:1.85; background-color:#000;}
@keyframes bounce1{
	from,to {transform:translateY(0);}
	50% {transform:translateY(5px);}
}
</style>
<script type="text/javascript"> 
$(function() {
	var position = $('.thingVol031').offset(); // 위치값
	$('html,body').animate({ scrollTop : position.top }, 100); // 이동

	titleAnimation();
	$(".topic h2").css({"opacity":"0","margin-top":"10px"});
	$(".topic p").css({"opacity":"0","margin-top":"10px"});
	function titleAnimation() {
		$(".topic h2").delay(300).animate({"margin-top":"0", "opacity":"1"},500);
		$(".topic p").delay(800).animate({"margin-top":"-10px", "opacity":"1"},400).animate({"margin-top":"0"},400);
	}

	var itemSwiper1 = new Swiper('.section1 .swiper-container',{
		loop:false,
		slidesPerView:'auto',
		speed:600
	});
	var itemSwiper2 = new Swiper('.section2 .swiper-container',{
		loop:false,
		slidesPerView:'auto',
		speed:600
	});
	var itemSwiper3 = new Swiper('.section3 .swiper-container',{
		loop:false,
		slidesPerView:'auto',
		speed:600
	});
});

$(function(){
	<% if pagereload<>"" then %>
		setTimeout("pagedown()",500);
	<% end if %>
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$(".comment").offset().top}, 0);
}


function jsGoComPage(iP){
	location.replace('/playing/view.asp?didx=<%=vDIdx%>&iCC=' + iP + '#card_list');
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
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

			if (GetByteLength(frm.txtcomm.value) > 1000){
				alert("제한길이를 초과하였습니다. 500자 까지 작성 가능합니다.");
				frm.txtcomm.focus();
				return false;
			}

			frm.action = "/playing/sub/doEventComvol031.asp";
			frm.submit();
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
		document.frmdelcom.Cidx.value = cidx;
   		document.frmdelcom.submit();
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
//		if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
			<% If isApp="1" or isApp="2" Then %>
				calllogin();
				return false;
			<% else %>
				jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
				return false;
			<% end if %>	
//		}
//		return false;
	}
	if (object.value.length > object.maxLength)
	  object.value = object.value.slice(0, object.maxLength)
}

function fnVotePlaying(){
<% If IsUserLoginOK() Then %>
	<% if date() >="2017-12-25" and date() <= "2018-01-07" then %>
		if($("input[name='idea']:checked").length<1){
			alert('아이디어 제작상품 컨텐츠를 선택해주세요.');
			return false;
		}

		if($("input[name='badge']:checked").length<1){
			alert('Thing 뱃지 컨텐츠를 선택해주세요.');
			return false;
		}

		if($("input[name='cart']:checked").length<1){
			alert('장바구니 탐구생활 컨텐츠를 선택해주세요.');
			return false;
		}
		$("#ideavalue").val($("input[name='idea']:checked").val());
		$("#badgevalue").val($("input[name='badge']:checked").val());
		$("#cartvalue").val($("input[name='cart']:checked").val());
		str = $.ajax({
			type: "POST",
			url: "/playing/sub/doEventSubscriptvol031.asp",
			data: $("#sfrm").serialize(),
			dataType: "text",
			async: false
		}).responseText;
		console.log(str);
		var str1 = str.split("|")
		console.log(str);

		if (str1[0] == "05"){
			alert('응모가 완료 되었습니다!');
			$("#tcnt").html("<%=FormatNumber(totalresultCnt+1,0)%>"); 
			$("#vbtn").empty().html("<button type='submit' class='btn-vote finish'>투표완료</button>"); 
		}else if(str1[0] == "03"){
			alert('이미 응모하였습니다.');
		} else {
			errorMsg = str1[1].replace(">?n", "\n");
			alert(errorMsg);
		}
		return false;
	<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
	<% End If %>
<% Else %>
	<% If isApp="1" or isApp="2" Then %>
		calllogin();
		return false;
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
	<% end if %>
<% End If %>
}
</script>
					<div class="thingVol031 playing-calc">
						<div class="topic">
							<div class="topic">
								<h2><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/tit_playing.png" alt="플레잉 연말정산" /></h2>
								<p><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/txt_purpose.png" alt="안녕하세요. 2017년이 얼마 남지 않았네요. 여러분은 한 해를 어떻게 보내셨나요? 2017년 한 해의 여러분의 모습을 정산해보시는 건 어떨까요? 플레잉에서는 2017년의 한 해를 차근차근 정산해보았습니다" /></p>
								<div><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/bg_topic.jpg" alt="" /></div>
							</div>
						</div>
						<!-- count -->
						<div class="count">
							<div class="total"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/txt_total.png?v=1" alt="플레잉 고객 평균 연령 25세/플레잉과 만난 횟수 188회/플레잉 이벤트 개수 73개/한정 제작 상품 28개" /></div>
							<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/tit_best.png" alt="가장 기억에 남는 제작 상품은?" /></h3>
							<ul class="best">
								<li><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/txt_rank_1.png" alt="1위 마음씨약국" /></li>
								<li><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/txt_rank_2.png" alt="2위 윷마블" /></li>
								<li><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/txt_rank_3.png" alt="3위 교토뱃지" /></li>
							</ul>
						</div>
						<!-- award -->
						<div class="award">
							<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/tit_award.png" alt="2017년 깜짝 플레잉 어워드! (총 참여자 수 25,879명)" /></h3>
							<ul>
								<li><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/txt_member_1.png" alt="플레잉을 가장 많이 응모한  플레잉 고수 10" /></li>
								<li><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/txt_member_2.png" alt="플레잉에 가장 많이 당첨된 럭키 플레이어 5" /></li>
								<li><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/txt_member_3.png" alt="플레잉 상품을 가장 많이 구매한 리미티드 Picker 5" /></li>
							</ul>
							<p><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/txt_next.png" alt="총 20분께는 한정 스페셜 플레잉er 뱃지와 상장을 수여해드립니다. 앞으로도 플레잉과 함께 해주세요. 다음 스페셜 플레잉er는 나야 나!" /></p>
						</div>
						<!-- event -->
						<div class="event">
							<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/tit_event.png" alt="여러분에게 가장 좋았던 플레잉 컨텐츠를 투표해주세요!" /></h3>
							<a href="/playing/list.asp?cate=thing" class="mWeb" target="_blank"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/btn_go.png" alt="PLAYing 둘러보고 오기" /></a>
							<a href="" onclick="fnAPPpopupPlay_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/playing/list.asp?cate=thing');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/btn_go.png" alt="PLAYing 둘러보고 오기" /></a>
							<!-- 아이디어 제작상품 -->
							<div class="section section1">
								<h4>01<br />아이디어<br />제작상품</h4>
								<div class="rolling">
									<div class="swiper-container">
										<div class="swiper-wrapper">
											<div class="swiper-slide"><input type="radio" id="prd1" name="idea" value="1"<% If sub_opt1="1" Then Response.write " checked" %> /><label for="prd1"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_prod_1.png" alt="" />감KIT</label></div>
											<div class="swiper-slide"><input type="radio" id="prd2" name="idea" value="2"<% If sub_opt1="2" Then Response.write " checked" %> /><label for="prd2"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_prod_2.png" alt="" />박싱데이KIT</label></div>
											<div class="swiper-slide"><input type="radio" id="prd3" name="idea" value="3"<% If sub_opt1="3" Then Response.write " checked" %> /><label for="prd3"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_prod_3.png" alt="" />윷마블 Farm Map</label></div>
											<div class="swiper-slide"><input type="radio" id="prd4" name="idea" value="4"<% If sub_opt1="4" Then Response.write " checked" %> /><label for="prd4"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_prod_4.png" alt="" />백문이불여일수 KIT</label></div>
											<div class="swiper-slide"><input type="radio" id="prd5" name="idea" value="5"<% If sub_opt1="5" Then Response.write " checked" %> /><label for="prd5"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_prod_5.png" alt="" />마음씨약국 KIT</label></div>
											<div class="swiper-slide"><input type="radio" id="prd6" name="idea" value="6"<% If sub_opt1="6" Then Response.write " checked" %> /><label for="prd6"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_prod_6.png" alt="" />벚꽃 KIT</label></div>
											<div class="swiper-slide"><input type="radio" id="prd7" name="idea" value="7"<% If sub_opt1="7" Then Response.write " checked" %> /><label for="prd7"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_prod_7.png" alt="" />Fly, Play 종이비행기</label></div>
											<div class="swiper-slide"><input type="radio" id="prd8" name="idea" value="8"<% If sub_opt1="8" Then Response.write " checked" %> /><label for="prd8"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_prod_8.png" alt="" />운세자판기 책가방</label></div>
											<div class="swiper-slide"><input type="radio" id="prd9" name="idea" value="9"<% If sub_opt1="9" Then Response.write " checked" %> /><label for="prd9"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_prod_9.png" alt="" />일주일병 커피 세트</label></div>
											<div class="swiper-slide"><input type="radio" id="prd10" name="idea" value="10"<% If sub_opt1="10" Then Response.write " checked" %> /><label for="prd10"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_prod_10.png" alt="" />띵스프렌즈 스티커</label></div>
											<div class="swiper-slide"><input type="radio" id="prd11" name="idea" value="11"<% If sub_opt1="11" Then Response.write " checked" %> /><label for="prd11"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_prod_11.png" alt="" />윷마블 Travel Map</label></div>
											<div class="swiper-slide"><input type="radio" id="prd12" name="idea" value="12"<% If sub_opt1="12" Then Response.write " checked" %> /><label for="prd12"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_prod_12.png" alt="" />포장의 발견</label></div>
											<div class="swiper-slide"><input type="radio" id="prd13" name="idea" value="13"<% If sub_opt1="13" Then Response.write " checked" %> /><label for="prd13"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_prod_13.png" alt="" />진심명함카드</label></div>
											<div class="swiper-slide"><input type="radio" id="prd14" name="idea" value="14"<% If sub_opt1="14" Then Response.write " checked" %> /><label for="prd14"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_prod_14.png" alt="" />비누 한 모</label></div>
										</div>
									</div>
								</div>
							</div>
							<!-- 뱃지 컨텐츠 -->
							<div class="section section2">
								<h4>02<br/ >THING.<br/ >뱃지</h4>
								<div class="rolling">
									<div class="swiper-container">
										<div class="swiper-wrapper">
											<div class="swiper-slide"><input type="radio" id="badge1" name="badge" value="1"<% If sub_opt2="1" Then Response.write " checked" %> /><label for="badge1"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_badge_1.png" alt="" />포구미</label></div>
											<div class="swiper-slide"><input type="radio" id="badge2" name="badge" value="2"<% If sub_opt2="2" Then Response.write " checked" %> /><label for="badge2"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_badge_2.png" alt="" />말양말양</label></div>
											<div class="swiper-slide"><input type="radio" id="badge3" name="badge" value="3"<% If sub_opt2="3" Then Response.write " checked" %> /><label for="badge3"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_badge_3.png" alt="" />둥근해가떠썬</label></div>
											<div class="swiper-slide"><input type="radio" id="badge4" name="badge" value="4"<% If sub_opt2="4" Then Response.write " checked" %> /><label for="badge4"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_badge_4.png" alt="" />띵띵빵빵</label></div>
											<div class="swiper-slide"><input type="radio" id="badge5" name="badge" value="5"<% If sub_opt2="5" Then Response.write " checked" %> /><label for="badge5"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_badge_5.png" alt="" />봄달새</label></div>
											<div class="swiper-slide"><input type="radio" id="badge6" name="badge" value="6"<% If sub_opt2="6" Then Response.write " checked" %> /><label for="badge6"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_badge_6.png" alt="" />봄빨간화분이</label></div>
											<div class="swiper-slide"><input type="radio" id="badge7" name="badge" value="7"<% If sub_opt2="7" Then Response.write " checked" %> /><label for="badge7"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_badge_7.png" alt="" />달릴레옹</label></div>
											<div class="swiper-slide"><input type="radio" id="badge8" name="badge" value="8"<% If sub_opt2="8" Then Response.write " checked" %> /><label for="badge8"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_badge_8.png" alt="" />행보캡</label></div>
											<div class="swiper-slide"><input type="radio" id="badge9" name="badge" value="9"<% If sub_opt2="9" Then Response.write " checked" %> /><label for="badge9"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_badge_9.png" alt="" />날아갈꺼에어</label></div>
											<div class="swiper-slide"><input type="radio" id="badge10" name="badge" value="10"<% If sub_opt2="10" Then Response.write " checked" %> /><label for="badge10"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_badge_10.png" alt="" />교토뱃지</label></div>
											<div class="swiper-slide"><input type="radio" id="badge11" name="badge" value="11"<% If sub_opt2="11" Then Response.write " checked" %> /><label for="badge11"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_badge_11.png" alt="" />달군</label></div>
											<div class="swiper-slide"><input type="radio" id="badge12" name="badge" value="12"<% If sub_opt2="12" Then Response.write " checked" %> /><label for="badge12"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_badge_12.png" alt="" />우주라이크</label></div>
											<div class="swiper-slide"><input type="radio" id="badge13" name="badge" value="13"<% If sub_opt2="13" Then Response.write " checked" %> /><label for="badge13"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_badge_13.png" alt="" />아임오케익</label></div>
											<div class="swiper-slide"><input type="radio" id="badge14" name="badge" value="14"<% If sub_opt2="14" Then Response.write " checked" %> /><label for="badge14"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_badge_14.png" alt="" />사랑의뱃토리</label></div>
											<div class="swiper-slide"><input type="radio" id="badge15" name="badge" value="15"<% If sub_opt2="15" Then Response.write " checked" %> /><label for="badge15"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_badge_15.png" alt="" />눈송송트리팡</label></div>
										</div>
									</div>
								</div>
							</div>
							<!-- 탐구생활 컨텐츠 -->
							<div class="section section3">
								<h4>03<br />탐구생활<br />컨텐츠</h4>
								<div class="rolling">
									<div class="swiper-container">
										<div class="swiper-wrapper">
											<div class="swiper-slide"><input type="radio" id="cart1" name="cart" value="1"<% If sub_opt3="1" Then Response.write " checked" %> /><label for="cart1"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_cart_1.png" alt="" />모자탐구생활</label></div>
											<div class="swiper-slide"><input type="radio" id="cart2" name="cart" value="2"<% If sub_opt3="2" Then Response.write " checked" %> /><label for="cart2"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_cart_2.png" alt="" />따뜻한 마음, 따뜻한 장갑</label></div>
											<div class="swiper-slide"><input type="radio" id="cart3" name="cart" value="3"<% If sub_opt3="3" Then Response.write " checked" %> /><label for="cart3"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_cart_3.png" alt="" />상상 한 스푼</label></div>
											<div class="swiper-slide"><input type="radio" id="cart4" name="cart" value="4"<% If sub_opt3="4" Then Response.write " checked" %> /><label for="cart4"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_cart_4.png" alt="" />금전감각 Test</label></div>
											<div class="swiper-slide"><input type="radio" id="cart5" name="cart" value="5"<% If sub_opt3="5" Then Response.write " checked" %> /><label for="cart5"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_cart_5.png" alt="" />나만그래? Test</label></div>
											<div class="swiper-slide"><input type="radio" id="cart6" name="cart" value="6"<% If sub_opt3="6" Then Response.write " checked" %> /><label for="cart6"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_cart_6.png" alt="" />컵에 일상을 담는 방법</label></div>
											<div class="swiper-slide"><input type="radio" id="cart7" name="cart" value="7"<% If sub_opt3="7" Then Response.write " checked" %> /><label for="cart7"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_cart_7.png" alt="" />패턴연구소</label></div>
											<div class="swiper-slide"><input type="radio" id="cart8" name="cart" value="8"<% If sub_opt3="8" Then Response.write " checked" %> /><label for="cart8"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_cart_8.png" alt="" />반짝이는 생각의 재료</label></div>
											<div class="swiper-slide"><input type="radio" id="cart9" name="cart" value="9"<% If sub_opt3="9" Then Response.write " checked" %> /><label for="cart9"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_cart_9.png" alt="" />슬기로운생활</label></div>
											<div class="swiper-slide"><input type="radio" id="cart10" name="cart" value="10"<% If sub_opt3="10" Then Response.write " checked" %> /><label for="cart10"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_cart_10.png" alt="" />탐구생활_튜브</label></div>
											<div class="swiper-slide"><input type="radio" id="cart11" name="cart" value="11"<% If sub_opt3="11" Then Response.write " checked" %> /><label for="cart11"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_cart_11.png" alt="" />탐구생활_향초</label></div>
											<div class="swiper-slide"><input type="radio" id="cart12" name="cart" value="12"<% If sub_opt3="12" Then Response.write " checked" %> /><label for="cart12"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_cart_12.png" alt="" />연애 유형 테스트</label></div>
											<div class="swiper-slide"><input type="radio" id="cart13" name="cart" value="13"<% If sub_opt3="13" Then Response.write " checked" %> /><label for="cart13"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_cart_13.png" alt="" />탐구생활_매니큐어</label></div>
											<div class="swiper-slide"><input type="radio" id="cart14" name="cart" value="14"<% If sub_opt3="14" Then Response.write " checked" %> /><label for="cart14"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_cart_14.png" alt="" />탐구생활_다이어리</label></div>
											<div class="swiper-slide"><input type="radio" id="cart15" name="cart" value="15"<% If sub_opt3="15" Then Response.write " checked" %> /><label for="cart15"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_cart_15.png" alt="" />탐구생활_이별</label></div>
											<div class="swiper-slide"><input type="radio" id="cart16" name="cart" value="16"<% If sub_opt3="16" Then Response.write " checked" %> /><label for="cart16"><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/img_cart_16.png" alt="" />연애 능력 테스트</label></div>
										</div>
									</div>
								</div>
							</div>
							<span id="vbtn">
							<% If sub_opt4>0 Then %>
							<button type="submit" class="btn-vote finish">투표완료</button>
							<% Else %>
							<button type="submit" class="btn-vote" onclick="fnVotePlaying();return false;">투표하기</button>
							<% End If %>
							</span>
							<p class="total"><span id="tcnt"><%=FormatNumber(totalresultCnt,0)%></span>명이 참여하였습니다.</p>
						</div>
						<form name="sfrm" id="sfrm" method="post">
						<input type="hidden" name="mode" value="add">
						<input type="hidden" name="ideavalue" id="ideavalue">
						<input type="hidden" name="badgevalue" id="badgevalue">
						<input type="hidden" name="cartvalue" id="cartvalue">
						</form>
						<!-- comment -->
						<div class="comment">
							<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol031/m/tit_comment.png" alt="플레잉에 하고 싶은 이야기가 있나요? 여러분의 이야기에 귀기울이겠습니다. 플레잉에 바라는 점이나 하고 싶은 이야기가 있다면 간단하게 적어주세요!" /></h3>
							<!-- 코멘트 작성 -->
							<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
							<input type="hidden" name="eventid" value="<%=eCode%>">
							<input type="hidden" name="com_egC" value="<%=com_egCode%>">
							<input type="hidden" name="bidx" value="<%=bidx%>">
							<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
							<input type="hidden" name="iCTot" value="">
							<input type="hidden" name="mode" value="add">
							<input type="hidden" name="spoint">
							<input type="hidden" name="isMC" value="<%=isMyComm%>">
							<input type="hidden" name="pagereload" value="ON">
							<input type="hidden" name="gubunval">
							<div class="comment-write">
								<textarea cols="30" rows="5" placeholder="500자 이내로 입력" name="txtcomm" onclick="maxLengthCheck(this); return false" maxlength="500"></textarea>
								<button class="btn-submit" onclick="jsSubmitComment(document.frmcom);return false;">입력하기</button>
							</div>
							</form>
							<form name="frmdelcom" method="post" action = "/playing/sub/doEventComvol031.asp" style="margin:0px;">
								<input type="hidden" name="eventid" value="<%=eCode%>">
								<input type="hidden" name="com_egC" value="<%=com_egCode%>">
								<input type="hidden" name="bidx" value="<%=bidx%>">
								<input type="hidden" name="Cidx" value="">
								<input type="hidden" name="mode" value="del">
								<input type="hidden" name="pagereload" value="ON">
							</form>
							<!-- 코멘트 목록(7개씩 노출) -->
							<% If isArray(arrCList) Then %>
							<div class="comment-list" id="card_list">
								<ul>
									<% For intCLoop = 0 To UBound(arrCList,2) %>
									<li>
										<div class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %> <span class="writer"><%=printUserId(arrCList(2,intCLoop),4,"*")%>님</span></div>
										<p><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
										<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
										<a href="" class="btn-delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;">삭제</a>
										<% End If %>
									</li>
									<% Next %>
								</ul>
								<div class="pagingV15a">
									<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage")%>
								</div>
							</div>
							<% End If %>
						</div>
					</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->