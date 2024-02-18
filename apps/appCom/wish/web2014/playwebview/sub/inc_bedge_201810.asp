<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 띵 배지 10월 (수작업)
' History : 2018-10-04 최종원
'####################################################

dim oItem
dim currenttime
	currenttime =  now()
'	currenttime = #11/09/2016 09:00:00#
dim presentDay
presentDay = #10/14/2018 23:59:59#

Dim eCode , userid , pagereload , vPIdx
IF application("Svr_Info") = "Dev" THEN
	eCode   =  68520
Else
	eCode   =  89619
End If

dim commentcount, i
	userid = GetEncLoginUserID()

If userid <> "" then
	commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")
Else
	commentcount = 0
End If 

vPIdx = request("pidx")

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
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	if isMyComm="Y" then cEComment.FUserID = userid
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수
	
	if isMyComm="Y" then 
		cEComment.FUserID = userid 
		arrCList = cEComment.fnGetMyComment		'마이 코멘트 리스트 가져오기
	else
		arrCList = cEComment.fnGetComment		'리스트 가져오기
	end if	

	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
set cEComment = nothing

iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
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
	location.replace('<%=appUrlPath%>/playwebview/detail.asp?pidx=<%=vPIdx%>&pagereload=on&iCC=' + iP);
}

function jsSubmitComment(frm){		
	<% If IsUserLoginOK() Then %>	
		<% if date() >="2018-10-08" and date() < "2018-10-14" then %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능합니다.");
				return false;
			<% else %>
				if(!frm.txtcomm.value){
					alert("이름을 지어주세요.");
					document.frmcom.txtcomm.value="";
					frm.txtcomm.focus();
					return false;
				}

				if (GetByteLength(frm.txtcomm.value) > 20){
					alert("10자 이내로 지어주세요 : )");
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
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playwebview/detail.asp?pidx="&vPIdx&"")%>');
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
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playwebview/detail.asp?pidx="&vPIdx&"")%>');
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
	<% if now() <= presentDay then %>
		<div>
			<em class="month"><span>10월 THING</span></em>
			<h2>나에게 <b style="color:#ff7835;">이름</b>을<br> 지어주세요!</h2>
		</div>
	<% else %>	
		<div>
			<em class="month"><span>10월 THING</span></em>
			<p class="id">텐바이텐 X bib**** 고객님</p>
			<h2>내 이름은 <b style="color:#ff7835;">고스트게스트</b></h2>
		</div>					
	<% end if %>	
	</div>				
	<div class="badge-detail">
		<div id="thingRolling" class="swiperFull">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/play/badge/img_badge_201810_1.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/play/badge/img_badge_201810_2.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/play/badge/img_badge_201810_3.jpg" alt=""></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#ff7835;">
		<% if now() <= presentDay then %>
			<p>귀여운 유령 친구들이<br>호박 램프를 들고 어디를 가는 걸까요?<br>장난기 가득한 미소를 머금고<br>미끄러지듯 사라지는<br>꼬마유령의 이름을 지어주세요!</p>
		<% else %>
			<p>텐바이텐에서 디자인한 THING 배지는<br>매달 이름짓기 이벤트를 통해<br>한정수량 제작됩니다.<br>응모 기간 동안 재치있는 이름을<br>지어주신 여러분, 감사합니다 :)</p>
		<% end if %>
			<div class="btnGet">
				<a href="/category/category_itemPrd.asp?itemid=2093364" onclick="TnGotoProduct('2093364');return false;">배지 구매하러가기</a>
			</div>
		</div>

		<!-- for dev msg : 이벤트 시작 -->
		<div class="summary">
		<% if now() <= presentDay then %>					
			<div class="desc">
				<p class="msg" style="color:#ff7835;">
					<span>텐바이텐과 당신이 함께 만드는 친구!</span>지어주신 이름 중 하나를 뽑아<br>10월의 THING 배지가 한정 출시됩니다.<br>위트있는 이름을 지어주신 <br>작명가에게는 본 배지를 드립니다.<br>( 1명:5개 / 15명:1개 증정 )
				</p>							
				<p class="date">응모기간 : 10.8 ~ 10.14 <span>|</span> 발표 : 10.15</p>
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
				<input type="hidden" name="returnurl" value="<%= appUrlPath %>/playwebview/detail.asp?pidx=<%=vPIdx%>&pagereload=ON">
				<input type="hidden" name="isApp" value="<%= isApp %>">	
				<input type="hidden" name="spoint"/>						
					<fieldset>
					<legend class="hidden">어울리는 이름 짓기</legend>
						<input type="text" maxlength="12" id="txtcomm" onClick="jsCheckLimit();" name="txtcomm" title="이름 입력" placeholder="내 이름은" style="border-color:#ff7835;" />
						<input type="button" onclick="jsSubmitComment(document.frmcom);return false;" value="이름 지어주기" style="background-color:#ff7835; color:#fff; margin-top:0.75rem;" />
					</fieldset>								
				</form>		
				<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0;">
				<input type="hidden" name="mode" value="del">
				<input type="hidden" name="pagereload" value="ON">
				<input type="hidden" name="Cidx" value="">
				<input type="hidden" name="returnurl" value="<%= appUrlPath %>/playwebview/detail.asp?pidx=<%=vPIdx%>&pagereload=ON">
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
						<li>같은 이름 응모 시 선착순으로 당첨됩니다.</li>
						<li>THING배지는 텐바이텐에서 디자인하며 한정수량 제작됩니다.</li>
						<li>플레이 상품의 구매를 원하시면 텐바이텐 검색창에 '텐바이텐플레잉'을 검색해 주세요.</li>
					</ul>
					<button type="button" class="btnFold"><span>유의사항 접기</span></button>
				</div>
			</div>											
		<% else %>	
			<div class="other">
				<h3>그 외의 작명센스!</h3>
				<ul>
					<!-- for dev msg : 6개 당첨 이름 -->
					<li><span style="border-color:#ff7835; color:#ff7835;">호박방범대</span></li>
					<li><span style="border-color:#ff7835; color:#ff7835;">으시시와 으흐흐</span></li>
					<li><span style="border-color:#ff7835; color:#ff7835;">하양이즈</span></li>
					<li><span style="border-color:#ff7835; color:#ff7835;">찰떡궁합</span></li>
					<li><span style="border-color:#ff7835; color:#ff7835;">영혼의단짝</span></li>
					<li><span style="border-color:#ff7835; color:#ff7835;">0X0(령바이령)</span></li>
				</ul>
			</div>											
		<% end if %>						
		</div>

		<!-- comment list -->
		<div class="listComment" id="comment">
			<h3 class="hidden">코멘트 목록</h3>
			<div class="option">
				<div class="total"><span>TOTAL</span> <%=iCTotCnt%></div>							
				<% If IsUserLoginOK() Then %>
						<% If isMyComm = "Y" Then %>
							<a href="<%= appUrlPath %>/playwebview/detail.asp?pidx=<%=vPIdx%>&isMC=N&pagereload=ON">전체 코멘트 보기</a>
						<% Else %>
							<a href="<%= appUrlPath %>/playwebview/detail.asp?pidx=<%=vPIdx%>&isMC=Y&pagereload=ON">내 코멘트 보기</a>
						<% End If %>
				<% End If %>		
			</div>
			<% If isArray(arrCList) Then %>
			<ul>
				<!-- for dev msg : 한페이지당 10개씩 보여주세요 -->
				<% For intCLoop = 0 To UBound(arrCList,2) %>
				<li>
					<span>내이름은 <em style="color:#ff7835;"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></em>
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
		<% if now() >= presentDay then %>
			<div id="noti" class="noti">
				<h3><a href="#noticontents"><span>유의사항</span></a></h3>
				<div id="noticontents" class="noticontents">
					<ul>
						<li>당첨 발표는 공지게시판과 SMS를 통해 공지되며, 배지는 발표 이후 일괄 발송됩니다.</li>
						<li>같은 이름 응모 시 선착순으로 당첨됩니다.</li>
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