<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : AGV 이름짓기
' History : 2020.05.13 정태훈 생성
'###########################################################
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
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<%
dim currenttime
	currenttime =  now()
'	currenttime = #11/10/2017 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  102164
Else
	eCode   =  102611
End If

dim userid, commentcount, i
	userid = GetEncLoginUserID()

if userId="ley330" or userId="greenteenz" or userId="rnldusgpfla" or userId="cjw0515" or userId="thensi7" or userId = "motions" or userId = "jj999a" or userId = "phsman1" or userId = "jjia94" or userId = "seojb1983" or userId = "kny9480" or userId = "bestksy0527" or userId = "mame234" or userid = "corpse2" then
	currenttime = #05/15/2020 09:00:00#
end if

commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, pagereload, page
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= getNumeric(requestCheckVar(Request("iCC"),10))	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),2)

	page	= getNumeric(requestCheckVar(Request("page"),10))	'헤이썸띵 메뉴용 페이지 번호

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
	iCPageSize = 5		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 5		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
end if
'iCPageSize = 1

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
<style>
.agv-contest {position:relative; overflow:hidden;}
.agv-contest button {background:none;}
.agv-contest .hid {position:absolute; font-size:0; color:transparent;}

.agv-contest .topic {position:relative;}
.agv-contest .topic .btn-more {bottom:15%; left:50%; width:25%; height:10%;}
.agv-contest .popup {display:none; position:absolute; top:55%; left:5%; z-index:5; width:90%;}
.agv-contest .popup .btn-close {top:0; right:0; width:20vw; height:20vw;}

.agv-contest .info {background:#fff3e8;}
.agv-contest .info .swiper-container {padding:15% 4.5% 7%;}
.agv-contest .info .swiper-slide {width:84%; margin:0 1.5%;}
.agv-contest .info .pagination {height:auto; padding-top:5.5%;}
.agv-contest .swiper-pagination-switch {width:8px; height:8px; margin:0 5px; background:#d2c2b4;}
.agv-contest .swiper-active-switch {background:#f1464a;}
.agv-contest .info .vod-wrap {position:relative; padding:9% 0; background:#000;}
.agv-contest .info .btn-play {top:0; left:0; width:100%; height:100%; z-index:5; background:#000 url(//webimage.10x10.co.kr/fixevent/event/2020/102611/m/img_vod.jpg) no-repeat; background-position:50% 48%; background-size:100%;}

.agv-contest .cmt-section {position:relative; background:#f73a3e;}
.agv-contest .input-wrap {position:absolute; left:0; top:128vw; width:100%; padding:0 10%;}
.agv-contest .input-wrap input[type=text] {width:100%; height:9vw; padding:0 10%; text-align:center; font-size:4.5vw; border:0; background:none;}
.agv-contest .input-wrap input[type=text]::-webkit-input-placeholder {color:#d4d4d4;}
.agv-contest .input-wrap input[type=text]:-ms-input-placeholder {color:#d4d4d4;}
.agv-contest .input-wrap input[type=text]::placeholder {color:#d4d4d4;}
.agv-contest .input-wrap .btn-submit {position:relative; width:100%; padding-top:25%; margin-top:10%;}

.agv-contest .cmt-list ul {padding:0 7%;}
.agv-contest .cmt-list li {position:relative; margin:4.5% 0; padding-top:26.5%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102611/m/bg_name.png) center no-repeat; background-size:contain;}
.agv-contest .cmt-list li .num {position:absolute; left:7%; top:25%; font-family:'CoreSansCMedium', sans-serif; font-size:3.3vw; color:#da9292;}
.agv-contest .cmt-list li .name {position:absolute; left:7%; top:50%; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold', sans-serif; font-size:5.2vw; color:#222;}
.agv-contest .cmt-list li .writer {position:absolute; right:7%; bottom:31%; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular'; font-size:3.2vw; color:#aeaeae;}
.agv-contest .cmt-list li .btn-del {top:0; right:0; width:10vw; height:10vw; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102611/m/btn_del.png) 20% 75% no-repeat; background-size:30%;}

.pagingV15a {padding:5% 0 9%; margin:0;}
.pagingV15a span {color:#ffb2b4;}
.pagingV15a .current {position:relative; color:#fff;}
.pagingV15a .current:before {content:' '; position:absolute; top:-5px; left:50%; width:4px; height:4px; margin-left:-2px; background:#fff; border-radius:2px;}
.pagingV15a .arrow a:after {width:1rem; height:1rem; margin:-0.5rem 0 0 -0.5rem; background-position:-13.6rem -5.8rem;}
</style>
<script>
$(function(){
	$('.agv-contest .btn-more').on('click', function(){
		$(this).next('.popup').show();
	});
	$('.agv-contest .popup .btn-close').on('click', function(){
		$(this).closest('.popup').hide();
	});
	var infoSwiper = new Swiper('.info .swiper-container', {
		speed: 700,
		slidesPerView: 'auto',
		pagination: '.pagination'
	});
	$('.agv-contest .info .btn-play').on('click', function(){
		$(this).fadeOut(400);
		$(this).siblings('.vod').find('iframe')[0].contentWindow.postMessage('{"event":"command","func":"' + 'playVideo' + '","args":""}', '*');
	});
});
</script>
<script type="text/javascript">
$(function(){ 
	<% if pagereload<>"" then %>
		//pagedown();
		setTimeout("pagedown()",500);
	<% end if %>
});

function pagedown(){
	//document.getElementById('commentlist').scrollIntoView();
	window.$('html,body').animate({scrollTop:$("#comment-evt").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10) >= "2020-05-15" and left(currenttime,10) < "2020-05-20" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 10){
					alert("이름은 5글자 이내로 지어주세요.");
					frm.txtcomm1.focus();
					return false;
				}
				frm.txtcomm.value = frm.txtcomm1.value
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
			<div class="mEvt102661 agv-contest">
				<div class="topic">
					<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/102611/m/tit_agv.jpg" alt="AGV 이름 짓기 대회"></h2>
					<button type="button" class="hid btn-more" title="AGV란?">AGV란?</button>
					<div class="popup">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/102611/m/popup.png" alt="AGV 무인운반로봇 설명">
						<button type="button" class="hid btn-close" title="닫기">닫기</button>
					</div>
				</div>
				<div class="info">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102611/m/img_info_01.png" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102611/m/img_info_02.png" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102611/m/img_info_03.png" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102611/m/img_info_04.png" alt=""></div>
						</div>
						<div class="pagination"></div>
					</div>
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102611/m/txt_vod_01.png" alt=""></p>
					<div class="vod-wrap shape-rtgl">
						<div class="vod">
							<iframe src="https://www.youtube.com/embed/KLR84_a3m_E?enablejsapi=1&rel=0&playsinline=1" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
						</div>
						<button type="button" class="hid btn-play">재생</button>
					</div>
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102611/m/txt_vod_02.png" alt=""></p>
				</div>
				<div class="cmt-section">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102611/m/txt_contest.jpg" alt=""></p>
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
                    <input type="hidden" name="isApp" value="<%= isApp %>">	
					<div class="input-wrap">
						<input type="text" maxlength="5" placeholder="이름은 5글자 이내로 지어주세요" name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%>>
						<button type="button" class="hid btn-submit" onclick="jsSubmitComment(document.frmcom); return false;">응모하기</button>
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
                    <% IF isArray(arrCList) THEN %>
					<div class="cmt-list" id="comment-evt">
						<ul>
                            <% For intCLoop = 0 To UBound(arrCList,2) %>
							<li>
								<!-- for dev msg : 내 글 삭제 -->
								<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %><button type="button" class="hid btn-del" title="삭제" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;">삭제</button><% end if %>
								<span class="num">NO.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%></span>
								<span class="name"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></span>
								<span class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%> 님</span>
							</li>
                            <% next %>
						</ul>
					</div>
                    <% end if %>
					<div class="pageWrapV15">
					<% IF isArray(arrCList) THEN %>
						<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
					<% end if %>
					</div>
				</div>
				<div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102611/m/txt_noti.jpg" alt="유의사항"></div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->