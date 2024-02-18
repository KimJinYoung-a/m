<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [tvN X 텐바이텐] 응답하라1988 공식 굿즈 
' History : 2015-12-18 이종화
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<%
Dim eCode , userid, i
Dim iCCurrpage , iCPageSize , iCTotCnt , iCTotalPage
Dim iCPerCnt , arrCList , intCLoop
dim cEComment , pagereload

	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	pagereload	= requestCheckVar(request("pagereload"),2)

dim currenttime
	currenttime =  now()

IF application("Svr_Info") = "Dev" THEN
	eCode   =  65988
Else
	eCode   =  68041
End If

userid = GetEncLoginUserID()

dim commentcount
commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 4		'보여지는 페이지 간격
iCPageSize = 5		'풀단이면 15개	

'데이터 가져오기
set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수
	
	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
set cEComment = nothing

iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg

dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode("[텐바이텐xTvN] 응답하라 1988 공식 굿즈 그랜드 오픈")
snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
snpPre = Server.URLEncode("10x10 이벤트")

'기본 태그
snpTag = Server.URLEncode("텐바이텐")
snpTag2 = Server.URLEncode("#10x10")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐 X 응답하라1988]\n\n텐바이텐이 함께 만든\n코믹가족극 <응답하라1988>\n공식굿즈 그랜드 오픈!\n\n명장면, 명대사 그리고 감동까지!\n굿즈를 통해 간직하세요.\n텐바이텐에서 가장 빠르게!\n\nm.10x10.co.kr"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2015/68041/m/bnr_kakao.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url
	If isapp = "1" Then '앱일경우
		kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
	Else '앱이 아닐경우
		kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
	end if

%>
<style type="text/css">
img {vertical-align:top;}
.mEvt68041 {}
.rolling {position:relative;}
.rolling .swiper {position:absolute;}
.rolling .swiper-container {position:relative;}
.rolling .swiper .pagination {position:absolute; bottom:-12%; left:0; width:100%; height:auto; z-index:100; padding-top:0; text-align:center;}
.rolling .swiper .pagination span {display:inline-block; width:8px; height:8px; margin:0 7px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/68041/m/btn_pagination.png) no-repeat 0 0; background-size:16px auto; cursor:pointer;}
.rolling .swiper .pagination .swiper-active-switch {background-position:100% 0;}
.rolling .swiper button {position:absolute; top:44%; z-index:150; width:6.5%; background:transparent;}
.rolling .swiper .prev {left:-13%;}
.rolling .swiper .next {right:-13%;}

.monthly .swiper {position:absolute; left:16%; top:12%; width:68%;}
.sticker .swiper {position:absolute; left:28.5%; top:11%; width:50.46%;}
.sticker .swiper button {top:48%; width:10%;}
.sticker .swiper .prev {left:-23%;}
.sticker .swiper .next {right:-23%;}

.item {position:relative;}
.item a {display:block; position:absolute; top:10%; width:45%; height:80%; text-indent:-9999px;}
.item a.pdt01 {left:5%;}
.item a.pdt02 {right:5%;}
.item2 .pdt02 {top:8%; right:10%; width:40%; height:30%; background-color:blue; opacity:0;}
.item2 .pdt03 {top:30%; left:65%; width:25%; height:30%; background-color:red; opacity:0;}

.preview .movieWrap {padding:0 13.6%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/68041/m/bg_tv_mid.png) no-repeat 0 0; background-size:100% 100%;}
.preview .movieWrap .movie {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; background:#000;}
.preview .movieWrap .movie  iframe {position:absolute; top:0; left:0; width:100%; height:100%}

.shareSns {position:relative;}
.shareSns ul {overflow:hidden; position:absolute; left:6%; top:47%; width:88%;}
.shareSns li {float:left; width:33.33333%; padding:0 2.5%;}

.commentWrite .writeCont {padding:0 7.8% 10%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/68041/m/bg_yellow.png) repeat-y 0 0; background-size:100% auto;}
.commentWrite textarea {width:100%; height:100px; padding:10px; margin-bottom:10px; border-radius:0; border:1px solid #ebb129;}
.commentWrite .btnSubmit {display:block; width:100.5%;}
.commentList {padding:30px 0 50px; background:#fff;}
.commentList ul {padding:0 4%;}
.commentList li {padding:18px 20px 15px; margin-bottom:15px; color:#fff; font-size:11px; border-radius:12px;}
.commentList li .txt {line-height:1.4;}
.commentList li .mob {display:inline-block; width:5px; vertical-align:middle;}
.commentList li p {line-height:1; padding-top:15px; font-weight:bold;}
.commentList li .writer {padding:0 4px 0 15px;}
.commentList li .delete {display:inline-block; width:16px; padding:2px; vertical-align:middle;}
.commentList li.type01 {border:5px solid #6746a8; background:#ba4b25;}
.commentList li.type02 {border:5px solid #ba5827; background:#27706f;}
.commentList li.type03 {border:5px solid #ebc244; background:#3c4a74;}
.commentList li.type04 {border:5px solid #a11c49; background:#6b6532;}

@media all and (min-width:480px){
	.rolling .swiper .pagination span {width:12px; height:12px; margin:0 11px; background-size:24px auto;}
	.commentWrite textarea {height:150px; padding:15px; margin-bottom:15px;}
	.commentList {padding:45px 0 75px;}
	.commentList li {padding:24px 30px 23px; margin-bottom:23px; font-size:17px; border-radius:18px;}
	.commentList li .mob {width:7px;}
	.commentList li p {padding-top:23px;}
	.commentList li .writer {padding:0 6px 0 23px;}
	.commentList li .delete {display:inline-block; width:24px; padding:3px;}
}
</style>
<script>
<% if pagereload<>"" then %>
	setTimeout("pagedown()",500);
<% else %>
	setTimeout("pagup()",500);
<% end if %>

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-12-18" and left(currenttime,10)<="2016-01-10" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if (frm.txtcomm.value == '' || GetByteLength(frm.txtcomm.value) > 400){
					alert("코맨트는 400자 까지만 작성이 가능합니다. 코맨트를 남겨주세요.");
					frm.txtcomm.focus();
					return false;
				}
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
}

function pagup(){
	window.$('html,body').animate({scrollTop:$(".mEvt67157").offset().top}, 0);
}

function pagedown(){
	window.$('html,body').animate({scrollTop:$("#commentevt").offset().top}, 0);
}
</script>
<div class="mEvt68041">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/tit_reply_1988.jpg" alt="응답하라 1988 공식 굿즈 그랜드오픈" /></h2>
	<div class="monthly rolling">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/txt_monthly_calendar_v1.png" alt="2016 탁상달력" /></p>
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><% If isapp="1" Then %><a href="" onclick="fnAPPpopupProduct('1401873&amp;pEtr=68041'); return false;"><% Else %><a href="/category/category_itemPrd.asp?itemid=1401873&amp;pEtr=68041"><% End If %><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/img_monthly_01.jpg" alt="" /></a></div>
					<div class="swiper-slide"><% If isapp="1" Then %><a href="" onclick="fnAPPpopupProduct('1401873&amp;pEtr=68041'); return false;"><% Else %><a href="/category/category_itemPrd.asp?itemid=1401873&amp;pEtr=68041"><% End If %><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/img_monthly_02.jpg" alt="" /></a></div>
					<div class="swiper-slide"><% If isapp="1" Then %><a href="" onclick="fnAPPpopupProduct('1401873&amp;pEtr=68041'); return false;"><% Else %><a href="/category/category_itemPrd.asp?itemid=1401873&amp;pEtr=68041"><% End If %><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/img_monthly_03.jpg" alt="" /></a></div>
					<div class="swiper-slide"><% If isapp="1" Then %><a href="" onclick="fnAPPpopupProduct('1401873&amp;pEtr=68041'); return false;"><% Else %><a href="/category/category_itemPrd.asp?itemid=1401873&amp;pEtr=68041"><% End If %><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/img_monthly_04.jpg" alt="" /></a></div>
				</div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/btn_prev.png" alt="이전" /></button>
			<button type="button" class="next"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/btn_next.png" alt="다음" /></button>
		</div>
	</div>
	<div class="sticker rolling">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/txt_sticker.png" alt="딱지 스티커" /></p>
		<div class="swiper">
			<div class="swiper-container swiper2">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><% If isapp="1" Then %><a href="" onclick="fnAPPpopupProduct('1401875&amp;pEtr=68041'); return false;"><% Else %><a href="/category/category_itemPrd.asp?itemid=1401875&amp;pEtr=68041"><% End If %><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/img_sticker_01.png" alt="" /></a></div>
					<div class="swiper-slide"><% If isapp="1" Then %><a href="" onclick="fnAPPpopupProduct('1401875&amp;pEtr=68041'); return false;"><% Else %><a href="/category/category_itemPrd.asp?itemid=1401875&amp;pEtr=68041"><% End If %><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/img_sticker_02.png" alt="" /></a></div>
					<div class="swiper-slide"><% If isapp="1" Then %><a href="" onclick="fnAPPpopupProduct('1401875&amp;pEtr=68041'); return false;"><% Else %><a href="/category/category_itemPrd.asp?itemid=1401875&amp;pEtr=68041"><% End If %><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/img_sticker_03.png" alt="" /></a></div>
				</div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/btn_prev.png" alt="이전" /></button>
			<button type="button" class="next"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/btn_next.png" alt="다음" /></button>
		</div>
	</div>
	<div class="item item1">
		<% If isapp="1" Then %>
		<a href="" onclick="fnAPPpopupProduct('1401877&amp;pEtr=68041'); return false;" class="pdt01">
		<% Else %>
		<a href="/category/category_itemPrd.asp?itemid=1401877&amp;pEtr=68041" class="pdt01">
		<% End If %>청춘시대 노트</a>
		<% If isapp="1" Then %>
		<a href="" onclick="fnAPPpopupProduct('1401881&amp;pEtr=68041'); return false;" class="pdt02">
		<% Else %>
		<a href="/category/category_itemPrd.asp?itemid=1401881&amp;pEtr=68041" class="pdt02">
		<% End If %>영원우표</a>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/img_item_01_v1.jpg" alt="" /></div>
	</div>
	<div class="item item2">
		<% If isapp="1" Then %>
		<a href="" onclick="fnAPPpopupProduct('1401879&amp;pEtr=6825'); return false;" class="pdt01">
		<% Else %>
		<a href="/category/category_itemPrd.asp?itemid=1401879&amp;pEtr=68041" class="pdt01">
		<% End If %>포토 엽서 세트</a>
		<% If isapp="1" Then %>
		<a href="" onclick="fnAPPpopupProduct('1401882&amp;pEtr=68041'); return false;" class="pdt02">
		<% Else %>
		<a href="/category/category_itemPrd.asp?itemid=1401882&amp;pEtr=68041" class="pdt02">
		<% End If %>티머니 버스카드 카드형</a>
		<% If isapp="1" Then %>
		<a href="" onclick="fnAPPpopupProduct('1401883&amp;pEtr=68041'); return false;" class="pdt03">
		<% Else %>
		<a href="/category/category_itemPrd.asp?itemid=1401883&amp;pEtr=68041" class="pdt03">
		<% End If %>>티머니 버스카드 회수권형</a>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/img_item_02_v1.jpg" alt="" /></div>
	</div>
	<div class="item item3">
		<% If isapp="1" Then %>
		<a href="" onclick="fnAPPpopupProduct('1401880&amp;pEtr=68041'); return false;" class="pdt01">
		<% Else %>
		<a href="/category/category_itemPrd.asp?itemid=1401880&amp;pEtr=68041" class="pdt01">
		<% End If %>퍼즐 엽서</a>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/img_item_03_v1.jpg" alt="" /></div>
	</div>
	<div class="preview">
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/bg_tv_top.png" alt="" /></div>
		<div class="movieWrap">
			<div class="movie">
				<div class="movie">
					<iframe src="https://www.youtube.com/embed/wjZEql74IcM" frameborder="0" title="응답하라 1988 하이 아이템 탄생" webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen=""></iframe>
				</div>
			</div>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/txt_donate.png" alt="원가 및 유통 마진을 제외한 tvN 수익금은 사회공헌 분야에 기부됩니다." /></p>
	</div>

	<div class="shareSns">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/txt_noti.png" alt="응팔앓이 친구들에게도 얼른 이 소식을 알려주세요!" /></p>
		<ul>
			<li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/btn_facebook.png" alt="페이스북" /></a></li>
			<li><a href="" onclick="popSNSPost('ln','<%=snpTitle%>','<%=snpLink%>','','');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/btn_line.png" alt="라인" /></a></li>
			<li><a href="" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/btn_kakaotalk.png" alt="카카오톡" /></a></li>
		</ul>
	</div>
<!--
	<div class="replyComment" id="commentevt">
		<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
		<input type="hidden" name="mode" value="add">
		<input type="hidden" name="pagereload" value="ON">
		<input type="hidden" name="iCC" value="1">
		<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
		<input type="hidden" name="eventid" value="<%= eCode %>">
		<input type="hidden" name="linkevt" value="<%= eCode %>">
		<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
		<input type="hidden" name="gubunval">
		<input type="hidden" name="isApp" value="<%= isApp %>">	
		<div class="commentWrite">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/txt_comment_event_v2.png" alt="응답하라 기대평! 코멘트 이벤트" /></h3>
			<div class="writeCont">
				<textarea cols="80" rows="5" id="txtcomm" name="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> title="" cols="60" rows="5"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %><%END IF%></textarea>
				<input type="image" onclick="jsSubmitComment(document.frmcom); return false;" src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/btn_submit.png" alt="기대평 남기기" class="btnSubmit" />
			</div>
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

		<div class="commentList">
			<% IF isArray(arrCList) THEN %>
			<ul>
				<% For intCLoop = 0 To UBound(arrCList,2) %>
				<li>
					<div class="txt">
						<%=db2html(arrCList(1,intCLoop))%>
					</div>
					<p>
						<span class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
						<span class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%></span>
						<% If arrCList(8,i) <> "W" Then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/ico_mobile.png" alt="모바일에서 작성" class="mob" />
						<% End If %>
						<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
						<a href="" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;" class="delete"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68041/m/btn_delete.png" alt="삭제" /></a>
						<% end if %>
					</p>
				</li>
				<% Next %>
			</ul>
			<% end if %>
			<% IF isArray(arrCList) THEN %>
				<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
			<% end if %>
		</div>
	</div>
//-->
</div>
<script type="text/javascript">
$(function(){
	mySwiper1 = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		speed:500,
		pagination:".monthly .pagination",
		paginationClickable:true,
		autoplayDisableOnInteraction:false,
		nextButton:'.monthly .next',
		prevButton:'.monthly .prev'
	});
	$('.monthly .prev').on('click', function(e){
		e.preventDefault()
		mySwiper1.swipePrev()
	});
	$('.monthly .next').on('click', function(e){
		e.preventDefault()
		mySwiper1.swipeNext()
	});

	mySwiper2 = new Swiper('.swiper2',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		speed:500,
		pagination:".sticker .pagination",
		paginationClickable:true,
		autoplayDisableOnInteraction:false,
		nextButton:'.sticker .next',
		prevButton:'.sticker .prev'
	});
	$('.sticker .prev').on('click', function(e){
		e.preventDefault()
		mySwiper2.swipePrev()
	});
	$('.sticker .next').on('click', function(e){
		e.preventDefault()
		mySwiper2.swipeNext()
	});

	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper1.reInit();
			mySwiper2.reInit();
				clearInterval(oTm);
		}, 500);
	});

	var classes = ["type01", "type02", "type03", "type04"];
	$(".commentList li").each(function(){
		$(this).addClass(classes[~~(Math.random()*classes.length)]);
	});
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->