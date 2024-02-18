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
' History : 2018-02-09 이종화 생성
'#################################################################
%>
<%

dim oItem , classboxcol
dim currenttime
	currenttime =  now()
'	currenttime = #11/09/2016 09:00:00#

Dim eCode , userid , pagereload , vDIdx
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66277
Else
	eCode   =  84429
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
@font-face {font-family:'SDCinemaTheater';
src:url('http://m.10x10.co.kr/webfont/SDCinemaTheater.woff') format('woff'), url('http://m.10x10.co.kr/webfont/SDCinemaTheater.woff2') format('woff2'); font-style:normal; font-weight:normal;}

.mEvt84429 {background-color:#bc8450;}
.contestInfo {position:relative;}
.contestInfo .tabNav {overflow:hidden; position:absolute; left:6.66%; top:3.41rem; width:86.34%; height:15%;}
.contestInfo .tabNav li {float:left; width:33.33333%; height:100%; text-indent:-999em; cursor:pointer;}
.box-font {position:relative;}
.box-font ul {position:absolute; left:10%; bottom:3.93rem; width:80%; height:7.42rem;}
.box-font li {height:50%;}
.box-font li a {display:inline-block; width:100%; height:100%; text-indent:-999em;}

.rolling .swiper {position:relative; background:#916b4c;}
.rolling .swiper .pagination {position:absolute; bottom:10.69%; left:50%; z-index:30; width:27.33%; height:auto; margin-left:-13.37%; padding:0.5rem 0; text-align:center;}
.rolling .swiper .pagination span {display:inline-block; width:0.73rem; height:0.73rem; margin:0 0.5rem; border:0.15rem solid #fff; border-radius:0; background-color:transparent; transition:all 0.4s ease; box-shadow:0;}
.rolling .swiper .pagination .swiper-active-switch {width:0.73rem; border-radius:10px; background-color:#fff; border:0.15rem solid #fff; border-radius:0;}
.rolling .btnNav {position:absolute; bottom:11%; z-index:30; width:2.4%; background-color:transparent;}
.rolling .btnPrev {left:36.13%;}
.rolling .btnNext {right:36.13%;}

.writeCopy .writeCont {position:relative; width:100%;}
.writeCopy .writeCont p {position:absolute; left:8.5%; top:3.5rem; width:50.66%;  background:#fff;}
.writeCopy .writeCont p input {width:100%; height:2rem; border:0; color:#460000; font-size:1.25rem; font-weight:bold;}
.writeCopy .writeCont p input::placeholder{color:#460000; font-weight:bold;}
.writeCopy .writeCont .btnApply {position:absolute; top:1.07rem; right:8.5%; width:32.3%;}

.copyListwrap {overflow:hidden; padding:0 5.01%; margin:0 auto; background:url(http://webimage.10x10.co.kr/eventIMG/2018/84429/m/bg_cmt_list.jpg) 0 0; background-size:100% auto;}
.copyList {overflow:hidden;}
.copyList li {position:relative; float:left; width:50%; padding:0 0.77rem 1.41rem;}
.copyList li .inner {position:relative; width:100%; height:10.45rem; padding:1.28rem; background-color:#ba1e24; color:#fff; vertical-align:middle; text-align:left;}
.copyList li .num {display:inline-block; margin-bottom:1rem; font-size:.9rem; line-height:1; color:#ffe87f;}
.copyList li .copy {width:100%; font-size:1.3rem; line-height:1.3; font-family:'SDCinemaTheater'; word-break:break-all;}
.copyList li .writer {position:absolute; right:1.28rem; bottom:1.28rem; font-size:0.9rem;}
.copyList li .btnDel {position:absolute; right:.75rem; top:0; width:1.85rem; height:1.85rem;}
.copyList li.rdBox .inner {background-color:#f44e38;}
.copyList li.ywBox .inner {background-color:#ec914f;}

.mEvt84429 .pageWrapV15 {padding:1.9rem 0 4.43rem; background:url(http://webimage.10x10.co.kr/eventIMG/2018/84429/m/bg_cmt_list.jpg) 0 0; background-size:100% auto;}
.mEvt84429 .pagingV15a {position:relative; height:100%; margin:0;}
.mEvt84429 .pagingV15a span {display:inline-block; height:2.6rem; margin:0; padding:0 1.01rem; border:0; color:#f33f27; font-weight:bold; font-size:1.2rem; line-height:2.6rem; border:1px red;}
.mEvt84429 .pagingV15a span.arrow {display:inline-block; position:absolute; top:0; min-width:1.32rem; height:2.31rem; padding:0;}
.mEvt84429 .pagingV15a span.arrow.prevBtn {left:10.4%;}
.mEvt84429 .pagingV15a span.arrow.nextBtn {right:10.4%;}
.mEvt84429 .pagingV15a span.arrow a {width:100%; background-size:100% 100%;}
.mEvt84429 .pagingV15a span.arrow a:after {display:none;}
.mEvt84429 .pagingV15a span.arrow.prevBtn a{background-image:url(http://webimage.10x10.co.kr/eventIMG/2018/84429/m/btn_prev.png);}
.mEvt84429 .pagingV15a span.arrow.nextBtn a{background-image:url(http://webimage.10x10.co.kr/eventIMG/2018/84429/m/btn_next.png);}

.mEvt84429 .pagingV15a .current {background-color:#f33f27; color:#fff; border-radius:.34rem;}
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
		<% if date() >="2018-02-09" and date() <= "2018-02-25" then %>
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
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
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
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
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


function chkword(obj, maxByte) {
 	var strValue = obj.value;
	var strLen = strValue.length;
	var totalByte = 0;
	var len = 0;
	var oneChar = "";
	var str2 = "";

	for (var i = 0; i < strLen; i++) {
		oneChar = strValue.charAt(i);
		if (escape(oneChar).length > 4) {
			totalByte += 2;
		} else {
			totalByte++;
		}

		// 입력한 문자 길이보다 넘치면 잘라내기 위해 저장
		if (totalByte <= maxByte) {
			len = i + 1;
		}
	}

	// 넘어가는 글자는 자른다.
	if (totalByte > maxByte) {
		alert(maxByte + "자를 초과 입력 할 수 없습니다.");
		str2 = strValue.substr(0, len);
		obj.value = str2;
		chkword(obj, 4000);
	}
}
</script>

<div class="mEvt84429">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/84429/m/tit_tape_copy.jpg" alt="어디까지 써봤니? 박스테이프 카피" /></h2>
	<div class="contestInfo">
		<ul class="tabNav">
			<li name="info1">주제 & 규정</li>
			<li name="info2">일정</li>
			<li name="info3">시상</li>
		</ul>
		<div class="tabContainer">
			<div id="info1" class="tabContent"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84429/m/txt_tab_cont_1.jpg" alt="주제 & 규정 ‘택배 받는 순간을 즐겁게!’ 만들 수 있는 카피를 응모해주세요" /></div>
			<div id="info2" class="tabContent"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84429/m/txt_tab_cont_2.jpg" alt="일정 카피 응모 02월 12일 (월) - 25일 (일) 카피 응모 02월 12일 (월) - 25일 (일) 최종 발표 03월 14월 (수) *4월부터 실제 박스 적용 부착" /></div>
			<div id="info3" class="tabContent"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84429/m/txt_tab_cont_3.jpg" alt="시상 1등3(5명) 텐바이텐 Gift 카드 50,000원 + 산돌구름 플러스 1년 이용권 2등(10명) 텐바이텐 Gift 카드 30,000원 + 산돌구름 베이직 1년 이용권 3등(30명) 텐바이텐 Gift 카드 10,000원" /></div>
		</div>
	</div>
	<div class="box-font">
		<img src="http://webimage.10x10.co.kr/eventIMG/2018/84429/m/txt_font_style.jpg" alt="2018년 박스테이프 글꼴은? 텐바이텐의 좋은 친구 Sandoll의 ‘시네마극장’ 시네마극장은 1960~1670년대 영화 포스터와 극장 간판에서 주로 볼 수 있는 복고풍의 글자 형태에서 착안된 글꼴" />
		<ul class="mWeb">
			<li>
				<a href="http://www.sandoll.co.kr/?viba_portfolio=cinema" target="_blank">[산돌 시네마] 더 자세히 보기</a>
			</li>
			<li>
				<a href="http://www.sandoll.co.kr/sandollcloud/" target="_blank">[산돌 구름] 만나러가기</a>
			</li>
		</ul>
		<ul class="mApp">
			<li>
				<a href="http://www.sandoll.co.kr/?viba_portfolio=cinema" onclick="fnAPPpopupExternalBrowser('http://www.sandoll.co.kr/?viba_portfolio=cinema'); return false;">[산돌 시네마] 더 자세히 보기</a>
			</li>
			<li>
				<a href="http://www.sandoll.co.kr/sandollcloud/" onclick="fnAPPpopupExternalBrowser('http://www.sandoll.co.kr/sandollcloud/'); return false;">[산돌 구름] 만나러가기</a>
			</li>
		</ul>
	</div>
	<div class="rolling">
		<div class="swiper">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84429/m/img_slide_1.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84429/m/img_slide_2.jpg" alt="" /></div>
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
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/84429/m/txt_copywriter.jpg" alt="택배 받는 순간을 즐겁게 해줄 카피를 적어주세요!" /></h3>
		<div class="writeCont">
			<img src="http://webimage.10x10.co.kr/eventIMG/2018/84429/m/txt_box.png" alt="" />
			<p><input type="text" placeholder="띄어쓰기 포함 18자 이내" id="txtcomm" name="txtcomm" onClick="jsCheckLimit();" onkeyup="chkword(this,36);"/></p>
			<button class="btnApply" onclick="jsSubmitComment(document.frmcom);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84429/m/btn_apply.png" alt="응모하기" /></button>
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
			<% if intCLoop = 0 or intCLoop = 3 or intCLoop = 4 or intCLoop = 7 then classboxcol="rdBox" else classboxcol="ywBox" end if %>
			<li class="<%=classboxcol%>">
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
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->