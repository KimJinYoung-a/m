<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 2017 박스테이프 공모전
' History : 2017-02-10 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim oItem, pagereload, classboxcol, cmtYN
dim currenttime
	currenttime =  now()
	'currenttime = #10/07/2015 09:00:00#
	cmtYN = "Y"
dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66276
Else
	eCode   =  76169
End If

dim userid, commentcount, i
	userid = GetEncLoginUserID()

if userid="baboytw" or userid="ksy92630" or userid="bjh2546" THEN
	currenttime = #02/13/2017 09:00:00#
end if

commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, ecc
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),10)

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
.rolling .swiper {position:relative; background:#e0bf9f;}
.rolling .swiper .pagination {position:absolute; bottom:9%; left:50%; z-index:30; width:7rem; height:auto; margin-left:-3.5rem; padding:0.5rem 0; text-align:center; background:#b2724a; border-radius:1rem;}
.rolling .swiper .pagination span {display:inline-block; width:0.6rem; height:0.6rem; margin:0 0.4rem; border:0.15rem solid #ffedde; background-color:transparent; transition:all 0.4s ease; box-shadow:0 0 5px rgba(184,124,88.8);}
.rolling .swiper .pagination .swiper-active-switch {width:0.6rem; border-radius:10px; background-color:#ffedde;}
.rolling .btnNav {position:absolute; top:35%; z-index:30; width:7.8125%; background-color:transparent;}
.rolling .btnPrev {left:0;}
.rolling .btnNext {right:0;}
.contestInfo {position:relative;}
.contestInfo .tabNav {overflow:hidden; position:absolute; left:2%; top:0; width:96%; height:10%;}
.contestInfo .tabNav li {float:left; width:33.33333%; height:100%; text-indent:-999em; cursor:pointer;}
.contestInfo .tabContent a {position:absolute; left:20%; width:60%; height:9%; text-indent:-999em;}
.contestInfo .tabContent a.link1 {top:59.5%;}
.contestInfo .tabContent a.link2 {top:69%;}
.evtNoti {padding:1.3rem 0 3rem; text-align:center; background:#804e3a;}
.evtNoti h3 {padding-bottom:1rem; font-size:1.4rem; line-height:1; font-weight:bold; color:#ff9c85;}
.evtNoti li {color:#ffeddf; font-size:1rem; padding-top:0.4rem;}
.writeCopy {padding-bottom:3.3rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/76169/m/bg_paper.png) 0 0 repeat-y; background-size:100% auto;}
.writeCopy .writeCont {position:relative; overflow:hidden; width:90%; margin:0 auto;}
.writeCopy .writeCont p {position:absolute; left:0; top:0; width:70%; height:100%; padding:5% 3%; color:#717171; font-size:1.2rem; background:#fff;}
.writeCopy .writeCont p input {width:100%; border:0;}
.writeCopy .writeCont .btnApply {float:right; width:30%;}
.copyList {padding:2rem 6.25% 4rem; font-size:1.1rem;  font-weight:600;background:#fff;}
.copyList li {color:#919191;}
.copyList li .overHidden {padding-top:2rem;}
.copyList li .ftRt {color:#544037;}
.copyList li .copy {height:4.65rem; margin-top:0.6rem; text-align:center; font-size:1.2rem; line-height:4.8rem; color:#fff; background:#cf2526 url(http://webimage.10x10.co.kr/eventIMG/2017/76169/m/bg_tape.png) 100% 0 repeat-y; background-size:0.5rem 100%;}
.copyList li:nth-child(even) .copy {background-color:#ef8665;}
.copyList li .btnDelete {display:inline-block; position:relative; top:-0.2rem; height:1.5rem; margin-left:0.5rem; padding:0 0.5rem; color:#fff; font-size:0.9rem; line-height:1.55rem; background-color:#5a5a5a; border-radius:0.5rem;}
.copyList .pagingV15a {margin-top:3.2rem;}
.pagingV15a span.prevBtn {margin-left:0;}
.pagingV15a span.nextBtn {margin-right:0;}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper(".rolling .swiper-container",{
		loop:true,
		autoplay:2000,
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
		//pagedown();
		setTimeout("pagedown()",300);
	<% else %>
		setTimeout("pagup()",500);
	<% end if %>
});

function pagup(){
	window.$('html,body').animate({scrollTop:$(".mEvt76169").offset().top}, 0);
}

function pagedown(){
	//document.getElementById('commentlist').scrollIntoView();
	window.$('html,body').animate({scrollTop:$("#commentevt").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2017-02-13" and left(currenttime,10)<"2017-02-25" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>4 then %>
				alert("ID당 5번까지 응모가 가능합니다.\n당첨자 발표일을 기다려주세요!");
				return false;
			<% else %>
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 36){
					alert("띄어쓰기 포함\n최대 한글 18자 이내로 적어주세요.");
					frm.txtcomm1.focus();
					return false;
				}
				frm.txtcomm.value = frm.txtcomm1.value
				frm.action = "/event/lib/doEventComment.asp";
				frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	<% End IF %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmdelcom.Cidx.value = cidx;
   		document.frmdelcom.submit();
	}
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	}
}
</script>
	<!-- 박스테이프 카피공모전 -->
	<div class="mEvt76169">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/76169/m/tit_tape_copy.png" alt="박스테이프 카피공모전" /></h2>
			<div class="contestInfo">
				<ul class="tabNav">
					<li name="info1">시상</li>
					<li name="info2">주제</li>
					<li name="info3">산돌</li>
				</ul>
			<div class="tabContainer">
				<div id="info1" class="tabContent"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76169/m/txt_award.png" alt="01.시상" /></div>
				<div id="info2" class="tabContent"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76169/m/txt_subject.png" alt="02.주제" /></div>
				<div id="info3" class="tabContent">
					<div class="mWeb">
						<a href="http://www.sandollcloud.com/portfolio_page/gyeokdong-gothic" target="_blank" class="link1">[산돌 격동고딕] 더 자세히 보기</a>
						<a href="http://www.sandollcloud.com/" target="_blank" class="link2">[산돌 구름] 만나러 가기</a>
					</div>
					<div class="mApp">
						<a href="http://www.sandollcloud.com/portfolio_page/gyeokdong-gothic" onclick="fnAPPpopupExternalBrowser('http://www.sandollcloud.com/portfolio_page/gyeokdong-gothic'); return false;" class="link1"></a>
						<a href="http://www.sandollcloud.com/" onclick="fnAPPpopupExternalBrowser('http://www.sandollcloud.com/'); return false;" class="link2"></a>
					</div>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/76169/m/txt_sandoll.png" alt="03.산돌" /></div>
				</div>
			</div>
		</div>
		<div class="evtNoti">
			<h3>유·의·사·항</h3>
			<ul>
				<li>- 모든 응모작의 저작권을 포함한 일체 권리는 ㈜텐바이텐에 귀속됩니다.</li>
				<li>- 상품 제작 시 상품 판매 기준에 맞게 일부분 수정될 가능성이 있습니다.</li>
			</ul>
		</div>
		<div class="rolling">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/76169/m/txt_now.png" alt="지금 텐바이텐 박스테이프는?" /></h3>
			<div class="swiper">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76169/m/img_slide_01.png" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76169/m/img_slide_02.png" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76169/m/img_slide_03.png" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76169/m/img_slide_04.png" alt="" /></div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="btnNav btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76169/m/btn_prev.png" alt="이전" /></button>
				<button type="button" class="btnNav btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76169/m/btn_next.png" alt="다음" /></button>
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
		<input type="hidden" name="blnB" value="<%= blnBlogURL %>">
		<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
		<input type="hidden" name="txtcomm">
		<input type="hidden" name="gubunval">
		<input type="hidden" name="isApp" value="<%= isApp %>">	
		<div class="writeCopy">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/76169/m/txt_copywriter.png" alt="오늘부터 나도 카피라이터!" /></h3>
			<div class="writeCont">
				<p><input type="text" name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" placeholder="<%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>띄어쓰기 포함 최대 18자 입니다.<%END IF%>" /></p>
				<button onclick="jsSubmitComment(document.frmcom); return false;" class="btnApply"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76169/m/btn_apply.png" alt="응모하기" /></button>
			</div>
		</div>
		</form>
		<form name="frmdelcom" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
		<input type="hidden" name="mode" value="del">
		<input type="hidden" name="pagereload" value="ON">
		<input type="hidden" name="Cidx" value="">
		<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
		<input type="hidden" name="eventid" value="<%= eCode %>">
		<input type="hidden" name="linkevt" value="<%= eCode %>">
		<input type="hidden" name="isApp" value="<%= isApp %>">
		</form>
		<!--// 이벤트 응모 -->

		<!-- 응모 리스트 -->
		<% if cmtYN = "Y" then %>
			<% IF isArray(arrCList) THEN %>
				<div class="copyList" id="commentevt">
					<ul>
						<% For intCLoop = 0 To UBound(arrCList,2) %>
							<li>
								<div class="overHidden">
									<p class="ftLt">NO.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%><% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %> <a href="" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;" class="btnDelete">삭제 X</a><% end if %></p>
									<p class="ftRt"><%=printUserId(arrCList(2,intCLoop),2,"*")%></p>
								</div>
								<p class="copy"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
							</li>
						<% next %>
					</ul>
					<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
				</div>
			<% end if %>
		<% end if %>
		<!--// 응모 리스트 -->
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->