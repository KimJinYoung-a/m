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
' Description : PLAYing 인스타그램 / 감성사진 찍는 방법
' History : 2018-04-12 이종화 생성
'#################################################################
%>
<%

dim oItem
dim currenttime
	currenttime =  now()
'	currenttime = #11/09/2016 09:00:00#

Dim eCode , userid , pagereload , vDIdx
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66277
Else
	eCode   =  85823
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
	iCPageSize = 5		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 5		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
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
.section {position:relative;}
.section1 {background-color:#e8ac99;}
.section2 {background-color:#f8e1a9;}
.section3 {background-color:#a5d1bd;}
.section4 {background-color:#9cd4e1;}
.slideTemplateV15 .pagination{position:absolute; bottom:.46rem; z-index:10; left:0;}
.slideTemplateV15 .pagination span {width:0.64rem; height:0.64rem; margin:0 0.21rem; border:0; background-color:#c1c1c1; box-shadow:none;}
.slideTemplateV15 .pagination span.swiper-active-switch {width:.64rem; margin:0 0.21rem; border-radius:50%; background-color:#3f85df;}
.cmt-evt {background:#d6cff3;}
.cmt-evt .search-input {position:relative;}
.cmt-evt .cmtWrite {display:table; position:absolute; left:6.7%; bottom:2.6%; width:86.6%;}
.cmt-evt .cmtWrite span {display:table-cell; width:70%; vertical-align:middle; text-align:center;}
.cmt-evt .cmtWrite span + span {width:30%;}
.cmt-evt .cmtWrite span input {width:80%; border:none; font-size:1.62rem;}
.cmt-evt .cmtWrite .submit {width:100%; font-size:1.28rem; color:#fff; font-weight:600; background:transparent;}
.cmt-evt .cmtList {padding:2.7rem 0 2.56rem; background:#d6cff3;}
.cmt-evt .cmtList ul {width:90%; margin:0 auto;}
.cmt-evt .cmtList li {position:relative; margin-bottom:1.28rem;}
.cmt-evt .cmtList li div {display:table; position:relative; width:100%; background-color:#f2f2f2; padding:1.96rem 1.49rem 1.36rem 1.96rem;}
.cmt-evt .cmtList li div span {display:table-cell; vertical-align:middle;}
.cmt-evt .cmtList .num {position:relative; top:-.08rem; width:15%; color:#333; font-weight:600; font-size:1rem;}
.cmt-evt .cmtList .question {color:#000; font-weight:600; font-size:1.45rem; line-height:1.2;}
.cmt-evt .cmtList .writer {position:relative; width:22%; top:-.3rem; color:#2157a6; font-weight:600; font-size:0.85rem; text-align:right;}
.cmt-evt .cmtList li .delete {position:absolute; right:-0.7rem; top:-0.7rem; width:1.66rem; height:1.66rem; background-color:transparent;}
.pagingV15a span {color:#fff;}
.pagingV15a .current {background-color:#fff; color:#2700ec; border-radius:50%;}
.pagingV15a .arrow a:after {background-position:-7.55rem -9.56rem;}
</style>
<script type="text/javascript">
$(function(){
	var position = $('.thingVol039').offset(); // 위치값
	$('html,body').animate({ scrollTop : position.top },300); // 이동

	slideTemplate = new Swiper('.section1 .swiper-container',{
		loop:true,
		autoplay:3000,
		autoplayDisableOnInteraction:false,
		speed:800,
		pagination:".section1 .pagination",
		paginationClickable:true,
		effect:'fade'
	});

	slideTemplate = new Swiper('.section2 .swiper-container',{
		loop:true,
		autoplay:3000,
		autoplayDisableOnInteraction:false,
		speed:800,
		pagination:".section2 .pagination",
		paginationClickable:true,
		effect:'fade'
	});

	slideTemplate = new Swiper('.section3 .swiper-container',{
		loop:true,
		autoplay:3000,
		autoplayDisableOnInteraction:false,
		speed:800,
		pagination:".section3 .pagination",
		paginationClickable:true,
		effect:'fade'
	});

	slideTemplate = new Swiper('.section4 .swiper-container',{
		loop:true,
		autoplay:3000,
		autoplayDisableOnInteraction:false,
		speed:800,
		pagination:".section4 .pagination",
		paginationClickable:true,
		effect:'fade'
	});

	<% if pagereload<>"" then %>
		setTimeout("pagedown()",200);
	<% end if %>
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$(".comment").offset().top}, 0);
}

function jsGoComPage(iP){
	location.replace('/playing/view.asp?didx=<%=vDIdx%>&iCC=' + iP);
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% if date() <= "2018-04-23" then %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if(!frm.txtcomm.value){
					alert("다음 주제, 무엇이 궁금하신가요?");
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

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
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
<div class="thingVol039">
	<div class="topic">
		<h2><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/tit_instagram.jpg" alt="인스타그램 감성사진 찍는방법" /></h2>
	</div>

	<div class="section section1">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/tit_insta_1.jpg" alt="#일상스타그램" /></p>
		<div class="slideTemplateV15">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/img_slide_1_1.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/img_slide_1_2.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/img_slide_1_3.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/img_slide_1_4.jpg" alt="" /></div>
				</div>
			</div>
			<div class="pagination"></div>
		</div>
		<div><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/txt_insta_1.jpg" alt="저는 침대, 벽, 커튼 등 깔끔한 곳을 배경으로 두고 사진을 찍곤 해요. 물건이 더 돋보이게 찍히죠 ! 거기에 조명, 빛을 이용하면 더 감성적이면서 느낌 있는 사진이 나와요~ 특히 저는 흰 배경을 많이 애용해요 :)" /></div>
		<a href="/event/eventmain.asp?eventid=85823&eGc=#group243265" onclick="jsMobAppUrlChange('85823','group243265');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/txt_more_item_1.jpg" alt="추천 소품 보러가기" /></a>
	</div>

	<div class="section section2">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/tit_insta_2.jpg" alt="#음식스타그램" /></p>
		<div class="slideTemplateV15">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/img_slide_2_1.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/img_slide_2_2.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/img_slide_2_3.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/img_slide_2_4.jpg" alt="" /></div>
				</div>
			</div>
			<div class="pagination"></div>
		</div>
		<div><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/txt_insta_2.jpg" alt="보통 피드에 올라오는 음식 사진들은 위에서 찍은 사진이 많을 거예요. 위에서 찍으면 음식 전체가 보여서 더 맛있게 보이거든요~ 또 재료를 화면에 꽉 차 보이게 찍고 채도나 온도를 조절하면 더욱 생동감을 느낄 수 있어요 :)" /></div>
		<a href="/event/eventmain.asp?eventid=85823&eGc=#group243266" onclick="jsMobAppUrlChange('85823','group243266');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/txt_more_item_2.jpg" alt="추천 소품 보러가기" /></a>

	</div>

	<div class="section section3">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/tit_insta_3.jpg" alt="#패션스타그램" /></p>
		<div class="slideTemplateV15">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/img_slide_3_1.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/img_slide_3_2.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/img_slide_3_3.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/img_slide_3_4.jpg" alt="" /></div>
				</div>
			</div>
			<div class="pagination"></div>
		</div>
		<div><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/txt_insta_3.jpg" alt="가방이나 작은 소품을 예쁜 천에 올려 찍는 편이에요. 여기서 중요한 건 여백의 미! 여백을 많이 두고 촬영한 후 나중에 정사각형으로 편집을 해요. 데일리룩은 얼굴 노출 없이, 착장 아이템에 주목할 수 있게 올리는 편이에요 :)" /></div>
		<a href="/event/eventmain.asp?eventid=85823&eGc=#group243267" onclick="jsMobAppUrlChange('85823','group243267');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/txt_more_item_3.jpg" alt="추천 소품 보러가기" /></a>

	</div>

	<div class="section section4">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/tit_insta_4.jpg?v=1.0" alt="#여행스타그램" /></p>
		<div class="slideTemplateV15">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/img_slide_4_1.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/img_slide_4_2.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/img_slide_4_3.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/img_slide_4_4.jpg" alt="" /></div>
				</div>
			</div>
			<div class="pagination"></div>
		</div>
		<div><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/txt_insta_4.jpg" alt="풍경 사진 중, 하늘과 바다를 많이 담는 편이에요. 제일 중요하게 생각하는 건 수평 수직을 꼭! 맞춰서 찍는다는 거예요. 일반 카메라의 그리드를 켜두고 촬영을 하죠. 이동할 때는 동영상으로 촬영해서 캡처 후 활용하기도 해요~" /></div>
		<a href="/event/eventmain.asp?eventid=85823&eGc=#group243273" onclick="jsMobAppUrlChange('85823','group243273');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/txt_more_item_4.jpg" alt="추천 소품 보러가기" /></a>
	</div>

	<div class="more-item">
		<a href="/event/eventmain.asp?eventid=85823" class="mWeb"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/txt_more_item.jpg" alt="인스타그램 감성 사진 찍는 방법과 소품을 통해 여러분의 피드를 더 느낌 있게 꾸미세요! 감성스타그램을 꾸며줄 소품 보기" /></a>
		<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85823" onclick="fnAPPpopupEvent('85823'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/txt_more_item.jpg" alt="인스타그램 감성 사진 찍는 방법과 소품을 통해 여러분의 피드를 더 느낌 있게 꾸미세요! 감성스타그램을 꾸며줄 소품 보기" /></a>
	</div>
	<!-- <a href="/event/eventmain.asp?eventid=85823" onclick="jsEventlinkURL(85823);return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/txt_more_item.jpg" alt="인스타그램 감성 사진 찍는 방법과 소품을 통해 여러분의 피드를 더 느낌 있게 꾸미세요! 감성스타그램을 꾸며줄 소품 보기" /></a> -->

	<div class="section cmt-evt comment">
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
		<div class="search-input">
			<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol039/m/txt_question.png" alt="여러분은 무엇이 궁금하시나요? 프로 고민자문위원단에게 궁금한 탐구 주제를 요청해주세요. 추첨을 통해 5분에게 기프트카드 5천원권 증정!" /></h3>
			<div class="cmtWrite">
				<span><input type="text" id="txtcomm" name="txtcomm" onClick="jsCheckLimit();" placeholder="10자 이내로 입력" /></span>
				<span><button class="submit" onclick="jsSubmitComment(document.frmcom);return false;">주제 요청</button></span>
			</div>
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
		<% If isArray(arrCList) Then %>
		<div class="cmtList">
			<ul>
				<% For intCLoop = 0 To UBound(arrCList,2) %>
				<li>
					<div>
						<span class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
						<span class="question"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></span>
						<span class="writer"><%=printUserId(arrCList(2,intCLoop),4,"*")%>님</span>
					</div>
					<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
					<button class="delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol037/m/btn_delete.png" alt="삭제" /></button>
					<% End If %>
				</li>
				<% Next %>
			</ul>
			<div class="paging pagingV15a">
				<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage")%>
			</div>
		</div>
		<% End If %>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->