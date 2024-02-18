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
' History : 2020-03-10 이종화
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
	eCode   =  100916
Else
	eCode   =  101230
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
	iCPageSize = 6		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 6		'메뉴가 있으면 10개		'/수기이벤트 둘다 강제 12고정
end if

'데이터 가져오기
set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	if isMyComm="Y" then cEComment.FUserID = userid
	cEComment.FTotCnt 		= iCTotCnt      '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt            '리스트 총 갯수
set cEComment = nothing

iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
%>
<style type="text/css">
@font-face {font-family:'10x10'; src:url('//fiximage.10x10.co.kr/webfont/10x10.woff') format('woff'), url('//fiximage.10x10.co.kr/webfont/10x10.woff2') format('woff2'); font-style:normal; font-weight:normal;}
.box-tape {background-color:#f2d6bf;}
.box-tape button {background-color:transparent;}
.box-tape .box-font {position:relative;}
.box-tape .box-font a {display:block; position:absolute; top:0; left:0; width:100%; height:100%; text-indent:-999em;}
.box-tape .contest {position:relative;}
.box-tape .contest .tab-nav {overflow:hidden; position:absolute; left:6.66%; top:9.26%; width:86.34%; height:16.67%;}
.box-tape .contest .tab-nav li {float:left; width:33.33333%; height:100%; text-indent:-999em; cursor:pointer;}
.box-tape .cmt-section .input-wrap {position:relative;}
.box-tape .cmt-section .input-wrap input {position:absolute; top:0; left:0; width:100%; height:100%; padding:0 41.33% 0 12%; font-size:1.28rem; background-color:transparent; border-color:transparent;}
.box-tape .cmt-section .input-wrap input::placeholder {color:#b6b6b6;}
.box-tape .cmt-section .input-wrap .btn-submit {position:absolute; top:0; right:8.53%; width:28.8%; height:100%;}
.box-tape .cmt-section .cmt-wrap {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/101230/m/bg_cmt.jpg); background-size:100%;}
.box-tape .cmt-section .cmt-list {padding:0 8%;}
.box-tape .cmt-section .cmt-list li {position:relative; margin-bottom:1.45rem; padding:1.28rem 1.92rem; background-color:#d66500;}
.box-tape .cmt-section .cmt-list li:nth-child(even) {background-color:#e19262;}
.box-tape .cmt-section .cmt-list .info {display:flex; justify-content:space-between; color:#ffe87f; font-size:.64rem;}
.box-tape .cmt-section .cmt-list .info .writer {color:#ffe2cd;}
.box-tape .cmt-section .cmt-list .copy {margin-top:1.02rem; color:#fff; font-size:1.28rem; font-family:'10x10';}
.box-tape .cmt-section .cmt-list .btn-delete {position:absolute; top:0; right:0; width:1.58rem; height:1.58rem; background-image:url(//webimage.10x10.co.kr/eventIMG/2015/68254/m/boxtape_cmt_del.png); background-size:100%; text-indent:-999em;}
.box-tape .pageWrapV15 {padding:1.2rem 0 2.65rem;}
.box-tape .pagingV15a {position:relative; height:100%; margin:0;}
.box-tape .pagingV15a span {display:inline-block; height:2.6rem; margin:0; padding:0 1.01rem; border:0; color:#f33f27; font-weight:bold; font-size:1.2rem; line-height:2.6rem; border:1px red;}
.box-tape .pagingV15a span.arrow {display:inline-block; position:absolute; top:0; min-width:1.32rem; height:2.31rem; padding:0;}
.box-tape .pagingV15a span.arrow.prevBtn {left:10.4%;}
.box-tape .pagingV15a span.arrow.nextBtn {right:10.4%;}
.box-tape .pagingV15a span.arrow a {width:100%; background-size:100% 100%;}
.box-tape .pagingV15a span.arrow a:after {display:none;}
.box-tape .pagingV15a span.arrow.prevBtn a{background-image:url(http://webimage.10x10.co.kr/eventIMG/2018/84429/m/btn_prev.png);}
.box-tape .pagingV15a span.arrow.nextBtn a{background-image:url(http://webimage.10x10.co.kr/eventIMG/2018/84429/m/btn_next.png);}
.box-tape .pagingV15a .current {background-color:#f33f27; color:#fff; border-radius:50%;}
.box-tape .rolling {position:relative; background:#f4e5d5;}
.box-tape .rolling .pagination {position:absolute; bottom:8.18%; z-index:30; width:100%; height:1rem; padding:0; text-align:center;}
.box-tape .rolling .pagination span {display:inline-block; width:0.75rem; height:0.75rem; margin:0 0.43rem; border:0.128rem solid #b70000; background-color:transparent; transition:all 0.4s ease;}
.box-tape .rolling .pagination .swiper-active-switch {width:0.75rem; height:0.75rem; border:0.128rem solid #b70000; background-color:#b70000;}
</style>
<script type="text/javascript">
$(function(){
	swiper = new Swiper(".rolling .swiper-container",{
		loop:true,
		autoplay:false,
		speed:600,
		pagination:".rolling .pagination",
		effect:"fade"
	});
	$(".contest .tab-content").hide();
	$(".contest .tab-container").find(".tab-content:first").show();
	$(".contest .tab-nav li").click(function() {
		$(this).siblings("li").removeClass("current"); 
		$(this).addClass("current");
		$(this).closest(".contest .tab-nav").nextAll(".contest .tab-container:first").find(".tab-content").hide();
		var activeTab = $(this).attr("name");
		$(".tab-content[id|='"+ activeTab +"']").show();
	});

	<% if pagereload<>"" then %>
		setTimeout("pagedown()",200);
	<% end if %>
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$(".cmt-section").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% if date() >="2020-03-13" and date() <= "2020-03-29" then %>
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

<div class="mEvt101230 box-tape">
	<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/101230/m/tit_boxtape.jpg" alt="텐바이텐 박스테이프 카피 공모전" /></h2>
	<div class="contest">
		<ul class="tab-nav">
			<li name="info1">주제</li>
			<li name="info2">일정</li>
			<li name="info3">시상</li>
		</ul>
		<div class="tab-container">
			<div id="info1" class="tab-content"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101230/m/txt_tab1.jpg" alt="‘택배 받는 순간을 재미있게’ 해줄 수 있는 카피를 응모해주세요" /></div>
			<div id="info2" class="tab-content"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101230/m/txt_tab2.jpg" alt="응모 기간 : 03. 16(월) - 03. 29(일)" /></div>
			<div id="info3" class="tab-content"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101230/m/txt_tab3.jpg?v=1.01" alt="1등(1명) 텐바이텐 Gift 카드 100,000원 2등(5명) 텐바이텐 Gift 카드 50,000원 3등(10명) 텐바이텐 Gift 카드 10,000원" /></div>
		</div>
	</div>
	<div class="cmt-section">
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
		<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/101230/m/tit_cmt.jpg" alt="택배 받는 순간을 재미있게 해줄 카피를 응모해주세요!" /></h3>
		<div class="input-wrap">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/101230/m/bg_input.jpg" alt="">
			<input type="text" placeholder="띄어쓰기 포함18자 이내" id="txtcomm" name="txtcomm" onClick="jsCheckLimit();" maxlength="18">
			<button class="btn-submit" onclick="jsSubmitComment(document.frmcom);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101230/m/btn_submit.png" alt="응모하기"></button>
		</div>
		<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101230/m/txt_noti1.jpg" alt="욕설 및 비속어는 삭제되며 한 ID 당 5번까지 참여 가능합니다 카피 미리보기는 크롬 브라우저에서만 적용됩니다" /></p>
		</form>

		<% If isArray(arrCList) Then %>
		<div class="cmt-wrap">
			<div class="cmt-list">
				<ul>
					<% For intCLoop = 0 To UBound(arrCList,2) %>
					<li>
						<div class="info">
							<span class="num">NO.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%></span>
							<span class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%></span>
						</div>
						<div class="copy"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></div>
						<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
						<button class="btn-delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');"></button>
						<% end if %>
					</li>
					<% Next %>
				</ul>
			</div>
			<div class="pageWrapV15">
				<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage")%>
			</div>
		</div>
		<% End If %>
	</div>
	<div class="box-font">
		<img src="//webimage.10x10.co.kr/fixevent/event/2020/101230/m/txt_font.jpg" alt="제5회 박스테이프 글꼴은?" />
		<a href="http://company.10x10.co.kr/" class="mWeb" target="_blank">텐바이텐의 ‘10x10’폰트</a>
		<a href="http://company.10x10.co.kr/" class="mApp" onclick="fnAPPpopupExternalBrowser('http://company.10x10.co.kr/'); return false;">텐바이텐의 ‘10x10’폰트</a>
	</div>
	<div class="rolling">
		<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101230/m/tit_history.jpg" alt="지금까지 텐바이텐 박스테이프는?" /></p>
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101230/m/img_slide1.jpg" alt="제1회 박스테이프 카피" /></div>
				<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101230/m/img_slide2.jpg" alt="제2회 박스테이프 카피" /></div>
				<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101230/m/img_slide3.jpg" alt="제3회 박스테이프 카피" /></div>
				<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101230/m/img_slide4.jpg" alt="제4회 박스테이프 카피" /></div>
			</div>
		</div>
		<div class="pagination"></div>
	</div>
	<div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101230/m/txt_noti2.jpg" alt="이벤트유의사항" /></div>
</div>
<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
	<input type="hidden" name="mode" value="del">
	<input type="hidden" name="pagereload" value="ON">
	<input type="hidden" name="Cidx" value="">
	<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
	<input type="hidden" name="eventid" value="<%= eCode %>">
	<input type="hidden" name="linkevt" value="<%= eCode %>">
	<input type="hidden" name="isApp" value="<%= isApp %>">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->