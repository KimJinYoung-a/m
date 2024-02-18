<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'#################################################################
' Description : 박스테이프 공모전
' History : 2018-06-25 최종원 생성
'#################################################################
%>
<%

dim oItem , classboxcol
Dim className
className = "rdBox"

dim currenttime
	currenttime =  now()
'	currenttime = #11/09/2016 09:00:00#

Dim eCode , userid , pagereload , vDIdx
IF application("Svr_Info") = "Dev" THEN
	eCode   =  68523
Else
	eCode   =  87452
End If

dim commentcount, i
	userid = GetEncLoginUserID()

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

iCPerCnt = 6		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 8		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 8		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
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
@font-face {font-family:'10x10';
src:url('http://m.10x10.co.kr/webfont/10x10.woff') format('woff'), url('http://m.10x10.co.kr/webfont/10x10.woff2') format('woff2'); font-style:normal; font-weight:normal;}
.box-tape {background-color:#f2d6bf;}
.box-tape .contestInfo {position:relative;}
.box-tape .contestInfo .tabNav {overflow:hidden; position:absolute; left:6.66%; top:3.41rem; width:86.34%; height:15%;}
.box-tape .contestInfo .tabNav li {float:left; width:33.33333%; height:100%; text-indent:-999em; cursor:pointer;}
.box-tape .box-font {position:relative;}
.box-font a {display:block; position:absolute; top:0; left:0; width:100%; height:100%; text-indent:-999em;}
.box-tape .rolling .swiper {position:relative; background:#916b4c;}
.box-tape .rolling .swiper .pagination {position:absolute; bottom:9.2%; z-index:30; width:100%; height:auto; padding:0; text-align:center;}
.box-tape .rolling .swiper .pagination span {display:inline-block; width:0.73rem; height:0.73rem; margin:0 0.5rem; border:0.085rem solid #fff; border-radius:0; background-color:transparent; transition:all 0.4s ease; box-shadow:0;}
.box-tape .rolling .swiper .pagination .swiper-active-switch {width:0.73rem; height:0.73rem; border:0.085rem solid #fff; background-color:#fff; border-radius:0;}
.box-tape .rolling .btnNav {position:absolute; bottom:8.5%; z-index:30; width:2.4%; background-color:transparent;}
.box-tape .rolling .btnPrev {left:36.13%;}
.box-tape .rolling .btnNext {right:36.13%;}
.box-tape .writeCopy .writeCont {position:relative; width:100%;}
.box-tape .writeCopy .writeCont p {position:absolute; left:8.5%; top:39.2%; width:50.66%;  background:#fff;}
.box-tape .writeCopy .writeCont p input {width:100%; height:2rem; border:0; color:#460000; font-size:1.25rem; font-weight:bold;}
.box-tape .writeCopy .writeCont p input::placeholder{color:#460000; font-weight:bold;}
.box-tape .writeCopy .writeCont .btnApply {position:absolute; top:12.2%; right:8.5%; width:32.3%;}
.box-tape .copyListwrap {overflow:hidden; padding:0 5.01%; margin:0 auto; background:#6b2e25 url(http://webimage.10x10.co.kr/eventIMG/2018/84429/m/bg_cmt_list.jpg) 0 0; background-size:100% auto;}
.box-tape .copyList {overflow:hidden;}
.box-tape .copyList li {position:relative; float:left; width:50%; padding:0 0.77rem 1.41rem;}
.box-tape .copyList li .inner {position:relative; width:100%; height:10.62em; padding:1.11rem; background-color:#ba1e24; color:#fff; vertical-align:middle; text-align:left;}
.box-tape .copyList li .num {display:inline-block; margin-bottom:.64rem; font-size:.9rem; line-height:1; color:#ffe87f;}
.box-tape .copyList li .copy {width:100%; font-size:1.37rem; line-height:1.44; font-family:'10x10'; word-break:break-all;}
.box-tape .copyList li .writer {position:absolute; right:1.19rem; bottom:1.28rem; font-size:0.9rem;}
.box-tape .copyList li .btnDel {position:absolute; right:.75rem; top:0; width:1.85rem; height:1.85rem;}
.box-tape .copyList li.rdBox .inner {background-color:#f44e38;}
.box-tape .copyList li.ywBox .inner {background-color:#ec914f;}
.box-tape .pageWrapV15 {padding:1.9rem 0 4.43rem; background:url(http://webimage.10x10.co.kr/eventIMG/2018/84429/m/bg_cmt_list.jpg) 0 0; background-size:100% auto;}
.box-tape .pagingV15a {position:relative; height:100%; margin:0;}
.box-tape .pagingV15a span {display:inline-block; height:2.6rem; margin:0; padding:0 1.01rem; border:0; color:#f33f27; font-weight:bold; font-size:1.2rem; line-height:2.6rem; border:1px red;}
.box-tape .pagingV15a span.arrow {display:inline-block; position:absolute; top:0; min-width:1.32rem; height:2.31rem; padding:0;}
.box-tape .pagingV15a span.arrow.prevBtn {left:10.4%;}
.box-tape .pagingV15a span.arrow.nextBtn {right:10.4%;}
.box-tape .pagingV15a span.arrow a {width:100%; background-size:100% 100%;}
.box-tape .pagingV15a span.arrow a:after {display:none;}
.box-tape .pagingV15a span.arrow.prevBtn a{background-image:url(http://webimage.10x10.co.kr/eventIMG/2018/84429/m/btn_prev.png);}
.box-tape .pagingV15a span.arrow.nextBtn a{background-image:url(http://webimage.10x10.co.kr/eventIMG/2018/84429/m/btn_next.png);}
.box-tape .pagingV15a .current {background-color:#f33f27; color:#fff; border-radius:.34rem;}
.box-tape .noti {background-color:#eec8ac;}
.box-tape .noti ul {padding:0 8.4% 4.26rem;}
.box-tape .noti ul li {margin-left:.64rem; color:#3b1a02; font-size:1.1rem; line-height:1.77; font-weight:600; text-indent:-.64rem;}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper(".rolling .swiper-container",{
		loop:true,
		autoplay:false,
		speed:600,
		pagination:".rolling .pagination",
		prevButton:'.rolling .btnPrev',
		nextButton:'.rolling .btnNext',
		effect:"fade"
	});

	$(".contestInfo .tabContent").hide();
	$(".contestInfo .tabContainer").find(".tabContent:first").show();
	$(".contestInfo .tabNav li").click(function() {
		$(this).siblings("li").removeClass("current");
		$(this).addClass("current");
		$(this).closest(".contestInfo .tabNav").nextAll(".contestInfo .tabContainer:first").find(".tabContent").hide();
		var activeTab = $(this).attr("name");
		$(".tabContent[id|='"+ activeTab +"']").show();
	});

});

$(function(){
	<% if pagereload<>"" then %>
		setTimeout("pagedown()",200);
	<% end if %>
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$(".copyListwrap").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% if date() >="2018-06-27" and date() <= "2018-07-03" then %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if(!frm.txtcomm.value){
					alert("택배 받는 순간을 즐겁게 해줄 카피를 적어주세요!");
					document.frmcom.txtcomm.value="";
					frm.txtcomm.focus();
					return false;
				}

				if (GetByteLength(frm.txtcomm.value) > 36){
					alert("제한길이를 초과하였습니다. 18자 까지 작성 가능합니다.");
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
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	}
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmactNew.Cidx.value = cidx;
   		document.frmactNew.submit();
	}
}

</script>
<!-- // 박스테이프 카피공모전 -->
<div class="mEvt87452 box-tape">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/87452/m/tit_tape_copy.jpg" alt="텐바이텐 박스테이프 카피 공모전" /></h2>
	<div class="contestInfo">
		<ul class="tabNav">
			<li name="info1">주제 & 규정</li>
			<li name="info2">일정</li>
			<li name="info3">시상</li>
		</ul>
		<div class="tabContainer">
			<div id="info1" class="tabContent"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87452/m/txt_tab_cont_1.jpg" alt="주제 규정 택배 받는 순간을 시원하게 해줄 수 있는 카피를 응모해주세요" /></div>
			<div id="info2" class="tabContent"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87452/m/txt_tab_cont_2.jpg" alt="일정 카피 응모 06월 27일 (수) - 07월03일 (화) 카피 당선 발표 07월 06일 (금)" /></div>
			<div id="info3" class="tabContent"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87452/m/txt_tab_cont_3.jpg" alt="시상 1등(5명) 텐바이텐 Gift 카드 100,000원 2등(5명) 텐바이텐 Gift 카드 50,000원 3등(10명) 텐바이텐 Gift 카드 10,000원" /></div>
		</div>
	</div>
	<div class="box-font">
		<img src="http://webimage.10x10.co.kr/eventIMG/2018/87452/m/txt_font_style.jpg" alt="제4회 박스테이프 글꼴은?" />
		<% If isApp="1" or isApp="2" Then %>
			<a href="#" class="mApp" onclick="fnAPPpopupExternalBrowser('http://company.10x10.co.kr/'); return false;">텐바이텐의 ‘10x10’폰트</a>
		<% else %>			
			<a href="http://company.10x10.co.kr/" class="mWeb" target="_blank">텐바이텐의 ‘10x10’폰트</a>		
		<% end if %>	
	</div>
	<div class="rolling">
		<div class="swiper">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87452/m/img_slide_3.jpg" alt="제3회 박스테이프 카피" /></div>					
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87452/m/img_slide_2.jpg" alt="제2회 박스테이프 카피" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87452/m/img_slide_1.jpg" alt="제1회 박스테이프 카피" /></div>
				</div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="btnNav btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84429/m/btn_prev_wht.png" alt="이전" /></button>
			<button type="button" class="btnNav btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84429/m/btn_next_wht.png" alt="다음" /></button>
		</div>
	</div>
	<!-- 이벤트 응모 -->
	<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
	<input type="hidden" name="mode" value="add">
	<input type="hidden" name="pagereload" value="ON">
	<input type="hidden" name="iCC" value="1">
	<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
	<input type="hidden" name="eventid" value="<%= eCode %>">
	<input type="hidden" name="linkevt" value="<%= eCode %>">
	<input type="hidden" name="blnB" value="">
	<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
	<input type="hidden" name="isApp" value="<%= isApp %>">
	<input type="hidden" name="spoint"/>
	<div class="writeCopy">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/87452/m/txt_copywriter.jpg" alt="택배 받는 순간을 즐겁게 해줄 카피를 적어주세요!" /></h3>
		<div class="writeCont">
			<img src="http://webimage.10x10.co.kr/eventIMG/2018/84429/m/txt_box.png" alt="" />
			<p><input type="text" placeholder="띄어쓰기 포함 18자 이내" id="txtcomm" name="txtcomm" onClick="jsCheckLimit();" maxlength="18"/></p>
			<button class="btnApply" onclick="jsSubmitComment(document.frmcom);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87452/m/btn_apply.png" alt="응모하기" /></button>
		</div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84429/m/txt_caution.png" alt="욕설 및 비속어는 삭제되며 한 ID 당 5번까지 참여 가능합니다 카피 미리보기는 크롬 브라우저에서만 적용됩니다" /></div>
	</div>
	</form>
	<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
	<input type="hidden" name="mode" value="del">
	<input type="hidden" name="pagereload" value="ON">
	<input type="hidden" name="Cidx" value="">
	<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
	<input type="hidden" name="eventid" value="<%= eCode %>">
	<input type="hidden" name="linkevt" value="<%= eCode %>">
	<input type="hidden" name="isApp" value="<%= isApp %>">
	</form>
	<!--// 이벤트 응모 -->

	<% If isArray(arrCList) Then %>
	<!-- 응모 리스트 -->
	<div class="copyListwrap">
		<ul class="copyList">
			<% For intCLoop = 0 To UBound(arrCList,2) %>
			<%
			if intCLoop MOD 8 = 0 or intCLoop MOD 8 = 3 or intCLoop MOD 8 = 4 or intCLoop MOD 8 = 7 then 				
				className="rdBox" 
			else
				className="ywBox"		
			end if 
			%>			
			<% if intCLoop = 0 or intCLoop = 3 or intCLoop = 4 or intCLoop = 7 then classboxcol="rdBox" else classboxcol="ywBox" end if %>			
			<li class="<%=className%>"><!-- for dev msg : (68254이벤트참고) 처음 li 하나만 rdbox 클래스 이고 두번째부터는 두개씩 ywBox / rdBox 차례로 클래스 붙여주세요-->
				<div class="inner">
					<span class="num">NO.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%></span>
					<div class="copy"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></div>
					<p class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%></p>
				</div>				
				<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
				<a href="" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;" class="btnDel"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68254/m/boxtape_cmt_del.png" alt="삭제" /></a>
				<% end if %>				
			</li>		
			<% Next %>
		</ul>
	</div>
	<!--// 응모 리스트 -->

	<!-- pagination -->
	<div class="pageWrapV15">
		<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage")%>
	</div>
	<% End If %>

	<div class="noti">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/87452/m/tit_noti.png" alt="이벤트 유의사항" /></h3>
		<ul>
			<li>- 박스테이프 카피 등록은 한 ID 당 5번 참여 가능합니다.</li>
			<li>- 욕설 및 비속어는 자동으로 삭제됩니다.</li>
			<li>- 모든 응모작의 저작권을 포함한 일체 권리는 ㈜텐바이텐에 귀속됩니다.</li>
			<li>- 박스테이프 제작 시 일부분 수정될 가능성이 있습니다.</li>
			<li>- 최종 발표는 07월 06일 금요일 텐바이텐 공지사항에 기재되며, 새로운 박스테이프는 7월 말부터 만나볼 수 있습니다.</li>
			<li>- 당첨자에게는 세무신고에 필요한 개인정보를 요청할 수 있으며, 제세공과금은 텐바이텐 부담입니다.</li>
			<li>- 비슷한 응모작이 있을 경우, 최초 응모작이 인정됩니다.</li>
		</ul>
	</div>
</div>
<!-- // 박스테이프 카피공모전 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->