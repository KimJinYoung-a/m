<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 띵 배지 6월 (수작업)
' History : 2019-05-09 최종원
'####################################################
dim oItem
dim currenttime, eventStartDate, evnetEndDate
	currenttime = now()
'	currenttime = #11/09/2016 09:00:00#
dim presentDay
dim title, thingMonth, themeColor, mainCopy, introText, CommentPlaceHolder, badgeItemCode, badgeImg1, badgeImg2, badgeImg3
 
eventStartDate = Cdate("2019-06-10")
evnetEndDate = Cdate("2019-06-17")
presentDay = Cdate("2019-06-18")

title = "좋아하는 과일을<br>얘기해주세요"
thingMonth = 6
themeColor = "#47c860"
mainCopy = "<p>망고의 밀도 높은 달달한 맛에 반해<br>반려견 이름을 망고로 지었어요.<br>상상만 해도 입에 침이 고이는<br>나의 최애 과일을 얘기해주세요.</p>"
badgeItemCode = "2367265"
introText = "좋아하는 과일을<br>적어주신 분 중 30분에게<br>6월의 THING배지.레몬을 드립니다.<br>(12자 이내로 적어주세요!)"
CommentPlaceHolder = "예) 레몬"
badgeImg1 = "img_badge_201906_1.jpg"
badgeImg2 = "img_badge_201906_2.jpg"
badgeImg3 = "img_badge_201906_3.jpg"

Dim eCode , userid , pagereload , vPIdx
IF application("Svr_Info") = "Dev" THEN
	eCode	=	68520
Else
	eCode	=	95005
End If

dim commentcount, i
	userid = GetEncLoginUserID()

If userid <> "" then
	commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")
Else
	commentcount = 0
End If 

'gnb 구분자
dim gnbFlag
dim nowUrl, returnUrl

nowUrl = request.servervariables("HTTP_url")

vPIdx = request("pidx")

if InStr(nowUrl,"/apps/appcom/wish/web2014/playwebview/detail.asp") > 0 then
	returnUrl = appUrlPath & "/playwebview/detail.asp?pidx=" & vPIdx & "&pagereload=ON"
else 
	returnUrl = appUrlPath & "/play/detail.asp?pidx="& vPIdx &"&pagereload=ON"
end if

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
	iCPageSize = 5		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 5		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
end if

'데이터 가져오기
set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx		= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	if isMyComm="Y" then cEComment.FUserID = userid
	cEComment.FTotCnt 		= iCTotCnt	'전체 레코드 수
	
	if isMyComm="Y" then 
		cEComment.FUserID = userid 
		arrCList = cEComment.fnGetMyComment		'마이 코멘트 리스트 가져오기
	else
		arrCList = cEComment.fnGetComment		'리스트 가져오기
	end if	

	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
set cEComment = nothing

iCTotalPage 	=	Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

%>
<script type="text/javascript">
$(function(){
	var position = $('.thingvol041').offset(); // 위치값
	<% if pagereload<>"" then %>
		setTimeout("pagedown()",200);
	<% end if %>
	checkWidth();
	function checkWidth() {
		var boxWidth = $(".thingthing .hgroup").width();
		$(".thingthing .hgroup").css({"width":boxWidth, margin:"0 0 0"+"-"+($(".thingthing .hgroup").width() / 2)+"px"});
	}
	$(window).resize(function() {
		checkWidth();
	});
	var swiper1 = new Swiper("#thingRolling .swiper-container", {
		pagination:"#thingRolling .paginationDot",
		paginationClickable:true,
		loop:true,
		speed:800
	});

	/* noti */
	$("#noti .noticontents").hide();
	$("#noti h3 a").click(function(){
		$("#noti .noticontents").slideDown();
		$("#noti h3").hide();
		return false;
	});

	$("#noti .btnFold").click(function(){
		$("#noti .noticontents").slideUp();
		$("#noti h3").show();
	});
});
function pagedown(){
	window.$('html,body').animate({scrollTop:$("#comment").offset().top}, 0);
}

function jsGoComPage(iP){
	location.replace('<%=returnUrl%>&iCC=' + iP);
}

function jsSubmitComment(frm){		
	<% If IsUserLoginOK() Then %>	
		<% if date() >= eventStartDate and date() <= evnetEndDate then %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능합니다.");
				return false;
			<% else %>
				if(!frm.txtcomm.value){
					alert("좋아하는 과일을 적어주세요.");
					document.frmcom.txtcomm.value="";
					frm.txtcomm.focus();
					return false;
				}

				if (GetByteLength(frm.txtcomm.value) > 24){
					alert("12자 이내로 적어주세요 : )");
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
			jsChklogin_mobile('','<%=returnUrl%>');
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
			jsChklogin_mobile('','<%=returnUrl%>');
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
<!-- 컨텐츠 영역 -->
<article class="playDetailV16 thingthing">
	<div class="hgroup">
		<div>
			<em class="month"><span><%=thingMonth%>월 THING</span></em>
			<h2 style="margin-bottom:0.3rem;"><%=title%></h2>
		</div>
	</div>			
	<div class="badge-detail">
		<div id="thingRolling" class="swiperFull">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=<%=badgeItemCode%>" onclick="TnGotoProduct('<%=badgeItemCode%>');return false;"><img src="//webimage.10x10.co.kr/fixevent/play/badge/<%=badgeImg1%>" alt=""></a></div>
					<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=<%=badgeItemCode%>" onclick="TnGotoProduct('<%=badgeItemCode%>');return false;"></a><img src="//webimage.10x10.co.kr/fixevent/play/badge/<%=badgeImg2%>" alt=""></a></div>
					<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=<%=badgeItemCode%>" onclick="TnGotoProduct('<%=badgeItemCode%>');return false;"></a><img src="//webimage.10x10.co.kr/fixevent/play/badge/<%=badgeImg3%>" alt=""></a></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>		
		<div class="itemDesc" style="background-color:<%=themeColor%>;">
		<% if date() < presentDay then %>
			<%=mainCopy%>
		<% else %>
			<p>좋아하는 과일을<br>공유해 주셔서 감사합니다.<br>7월에도 재미있는 주제로 함께<br>이야기하고 띵배지도 받으세요!</p>
		<% end if %>
			<div class="btnGet">
				<a href="/category/category_itemPrd.asp?itemid=<%=badgeItemCode%>" onclick="TnGotoProduct('<%=badgeItemCode%>');return false;">배지 구매하러가기</a>
			</div>
		</div>

		<!-- for dev msg : 이벤트 시작 -->
		<% if date() < presentDay then %>
		<div class="summary">
			<div class="desc">
				<p class="msg" style="color:<%=themeColor%>;"><%=introText%></p>
				<p class="date">응모기간 : <%=FormatDate(eventStartDate, "0000.00.00")%> ~ <%=FormatDate(evnetEndDate, "00.00")%> <span>|</span> 발표 : <%=FormatDate(presentDay, "00.00")%></p>
			</div>
			<div class="form">
				<form name="frmcom" method="post" onSubmit="return false;" style="margin:0;">
				<input type="hidden" name="mode" value="add">
				<input type="hidden" name="pagereload" value="ON">
				<input type="hidden" name="iCC" value="1">
				<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
				<input type="hidden" name="eventid" value="<%= eCode %>">
				<input type="hidden" name="linkevt" value="<%= eCode %>">
				<input type="hidden" name="blnB" value="">
				<input type="hidden" name="returnurl" value="<%=returnUrl%>">
				<input type="hidden" name="isApp" value="<%= isApp %>">	
				<input type="hidden" name="spoint">
				<fieldset>
					<legend class="hidden">코멘트 등록</legend>
					<input type="text" maxlength="12" id="txtcomm" onClick="jsCheckLimit();" name="txtcomm" title="코멘트 등록" placeholder="<%=CommentPlaceHolder%>" style="border-color:<%=themeColor%>;" />
					<input type="button" onclick="jsSubmitComment(document.frmcom);return false;" value="등록하기" style="background-color:<%=themeColor%>; color:#fff; margin-top:0.75rem;" />
				</fieldset>
				</form>
				<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0;">
				<input type="hidden" name="mode" value="del">
				<input type="hidden" name="pagereload" value="ON">
				<input type="hidden" name="Cidx" value="">
				<input type="hidden" name="returnurl" value="<%=returnUrl%>">
				<input type="hidden" name="eventid" value="<%= eCode %>">
				<input type="hidden" name="linkevt" value="<%= eCode %>">
				<input type="hidden" name="isApp" value="<%= isApp %>">
				</form>
			</div>		
			<div id="noti" class="noti">
				<h3><a href="#noticontents"><span>유의사항</span></a></h3>
				<div id="noticontents" class="noticontents">
					<ul>
						<li>당첨 발표는 공지게시판과 SMS를 통해 공지되며, 배지는 발표 이후 일괄 발송됩니다.</li>
						<li>1인당 5회 등록 가능합니다.</li>
						<li>THING배지는 텐바이텐에서 디자인하며 한정수량 제작됩니다.</li>
						<li>플레이 상품의 구매를 원하시면 텐바이텐 검색창에 '텐바이텐플레잉'을 검색해 주세요.</li>
					</ul>
					<button type="button" class="btnFold"><span>유의사항 접기</span></button>
				</div>
			</div>
		</div>
		<% end if %>

		<!-- comment list -->
		<div class="listComment" id="comment">
			<h3 class="hidden">코멘트 목록</h3>
			<div class="option">
				<div class="total">
					<span>Total</span> 
					<span><%=iCTotCnt%></span>
				</div>							
				<% If IsUserLoginOK() Then %>
					<% if isApp then %>
						<% If isMyComm = "Y" Then %>
							<a href="<%= appUrlPath %>/playwebview/detail.asp?pidx=<%=vPIdx%>&isMC=N&pagereload=ON">전체 코멘트 보기</a>
						<% Else %>
							<a href="<%= appUrlPath %>/playwebview/detail.asp?pidx=<%=vPIdx%>&isMC=Y&pagereload=ON">내 코멘트 보기</a>
						<% End If %>							
					<% else %>
						<% If isMyComm = "Y" Then %>
							<a href="<%= appUrlPath %>/play/detail.asp?pidx=<%=vPIdx%>&isMC=N&pagereload=ON">전체 코멘트 보기</a>
						<% Else %>
							<a href="<%= appUrlPath %>/play/detail.asp?pidx=<%=vPIdx%>&isMC=Y&pagereload=ON">내 코멘트 보기</a>
						<% End If %>
					<% end if %>

				<% End If %>		
			</div>
			<% If isArray(arrCList) Then %>
			<ul>
				<!-- for dev msg : 한페이지당 10개씩 보여주세요 -->
				<% For intCLoop = 0 To UBound(arrCList,2) %>
				<li>
					<span><em style="color:<%=themeColor%>;"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></em>
					<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
					<button type="button" class="btnDel" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;">삭제</button>
					<% End If %>
					</span>
					<span class="id">By. <%=printUserId(arrCList(2,intCLoop),2,"*")%></span>
				</li>
				<% Next %>
			</ul>
			<% End If %>
			<!-- pagination -->
			<% If isArray(arrCList) Then %>
			<div class="paging pagingV15a">
				<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage")%>
			</div>
			<% end if %>
		</div>
		<% if now() > presentDay then %>
			<div id="noti" class="noti">
				<h3><a href="#noticontents"><span>유의사항</span></a></h3>
				<div id="noticontents" class="noticontents">
					<ul>
						<li>당첨 발표는 공지게시판과 SMS를 통해 공지되며, 배지는 발표 이후 일괄 발송됩니다.</li>
						<li>1인당 5회 등록 가능합니다.</li>
						<li>THING배지는 텐바이텐에서 디자인하며 한정수량 제작됩니다.</li>
						<li>플레이 상품의 구매를 원하시면 텐바이텐 검색창에 '텐바이텐플레잉'을 검색해 주세요.</li>
					</ul>
					<button type="button" class="btnFold"><span>유의사항 접기</span></button>
				</div>
			</div>
		<% end if %>
	</div>
</article>
<!--// 컨텐츠 영역 -->