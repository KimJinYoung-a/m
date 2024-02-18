<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 장바구니탐구생활_컬러편
' History : 2018-07-19 최종원
'####################################################


dim oItem
dim currenttime
	currenttime =  now()
'	currenttime = #11/09/2016 09:00:00#

Dim eCode , userid , pagereload , vPIdx
IF application("Svr_Info") = "Dev" THEN
	eCode   =  68520
Else
	eCode   =  88096
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
	iCPageSize = 6		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 6		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
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
<style>
.head-title {position:relative;}
.head-title i {position:absolute; left:50%; bottom:5%; width:10%; margin-left:-5%; animation:bounce .8s 50;}
.card-list {overflow:hidden; width:100%;}
.card-list li {position:relative; float:left; width:50%; border-bottom:1px solid #ccc;}
.card-list li:after {display:none; position:absolute; left:0; top:0; width:100%; height:100%; content:''; background-position:0 0; background-repeat:no-repeat; background-size:100% auto; z-index:5;}
.card-list li.selected:after {display:block;}
.card-list .card01:after {background-image:url(http://webimage.10x10.co.kr/play/life/vol001/m/box_card1_select.png);}
.card-list .card02:after {background-image:url(http://webimage.10x10.co.kr/play/life/vol001/m/box_card2_select.png);}
.card-list .card03:after {background-image:url(http://webimage.10x10.co.kr/play/life/vol001/m/box_card3_select.png);}
.card-list .card04:after {background-image:url(http://webimage.10x10.co.kr/play/life/vol001/m/box_card4_select.png);}
.card-result li {position:relative;}
.card-result li a {display:block; position:absolute; left:50%; bottom:8%; width:76%; margin-left:-38%;}
.card-result li:first-child a {bottom:10%;}
.comment-head {position:relative;}
.comment-write {position:absolute; left:5%; bottom:3.4rem; width:90%;}
.comment-write div {overflow:hidden; position:relative; width:100%; height:4.69rem; margin:0 auto; padding:0 9.5rem 0 1rem; background:#fff; border-radius:2.13rem;}
.comment-write input {width:100%; height:4.69rem; font-size:1.62rem; font-weight:600; text-align:center; color:#666; border:0;}
.comment-write .btn-recommend {position:absolute; right:0; top:0; width:8.49rem; height:4.69rem; vertical-align:top;}
.comment-list {padding:3.4rem 0 2.47rem; background:url(http://webimage.10x10.co.kr/play/life/vol001/m/bg_comment_v3.png) 0 0 repeat; background-size:100% auto;}
.comment-list ul {padding:0 6.66%;}
.comment-list li {position:relative; height:4.18rem; margin-top:1.28rem; padding:0 1.7rem; font-size:0.9rem; line-height:4.18rem; letter-spacing:-0.03rem; background:#d3d6f3;}
.comment-list li:first-child {margin-top:0;}
.comment-list li .btn-delete {position:absolute; right:-3.5rem; top:-3.5rem; width:7.66rem; padding:3rem;}
.comment-list li p {display:inline-block; float:left;}
.comment-list li .num {width:4.2rem;}
.comment-list li .txt {font-size:1.45rem; font-weight:600;}
.comment-list li .writer {float:right; color:#02a2d3;}
.comment-list .pagingV15a {margin-top:2.65rem;}
.comment-list .pagingV15a span {width:2.77rem; height:2.77rem; margin:0 0.34rem; color:#333; font-size:1.28rem; line-height:2.8rem; font-weight:600;}
.comment-list .pagingV15a a {padding-top:0;}
.comment-list .pagingV15a .current {color:#ffef85; background:#333; border-radius:50%;}
.comment-list .pagingV15a .arrow a:after {left:0; top:0; width:2.77rem; height:2.77rem; margin:0; background:url(http://webimage.10x10.co.kr/play/life/btn_paging_next.png) 0 0 no-repeat; background-size:100% 100%;}
@keyframes bounce {
	from, to {transform:translateY(-8px); animation-timing-function:ease-out;}
	50% {transform:translateY(0); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">

$(function(){
	var position = $('.thingvol041').offset(); // 위치값
	//$('html,body').animate({ scrollTop : position.top },300); // 이동

	$(".topic").addClass("animation");

	$(".hash-link a").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},800);
	});

	<% if pagereload<>"" then %>
		setTimeout("pagedown()",200);
	<% end if %>

	$(".card-list li a").click(function(event){ 
		$(".card-list li").removeClass('selected');
		$(this).parent().addClass('selected');
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},1000);
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
		<% if date() >="2018-07-20" and date() <= "2018-08-05" then %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if(!frm.txtcomm.value){
					alert("다음 주제를 입력해주세요.");
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
<body class="default-font body-sub playV18 detail-play">
	<%'<!-- contents -->%>
	<div id="content" class="content">
		<div class="detail-cont">
			<%'<!-- 컨텐츠 영역 -->%>
			<div class="life-vol001">
				<div class="head-title">
					<h2><img src="http://webimage.10x10.co.kr/play/life/vol001/m/tit_color.png" alt="내 마음을 읽어봐 - 색 조합으로 알아보는 나의 마음은?" /></h2>
					<i><img src="http://webimage.10x10.co.kr/play/life/vol001/m/ico_arrow.png" alt="" /></i>
				</div>
				<div class="question">
					<h3><img src="http://webimage.10x10.co.kr/play/life/vol001/m/txt_question.png" alt="현재 어떤 이미지가 눈에 들어오나요?" /></h3>
					<ul class="card-list">
						<li class="card01"><a href="#card01-result"><img src="http://webimage.10x10.co.kr/play/life/vol001/m/img_card1.jpg" alt="SKY BLUE" /></a></li>
						<li class="card02"><a href="#card02-result"><img src="http://webimage.10x10.co.kr/play/life/vol001/m/img_card2.jpg" alt="PINK" /></a></li>
						<li class="card03"><a href="#card03-result"><img src="http://webimage.10x10.co.kr/play/life/vol001/m/img_card3.jpg" alt="GREEN" /></a></li>
						<li class="card04"><a href="#card04-result"><img src="http://webimage.10x10.co.kr/play/life/vol001/m/img_card4.jpg" alt="RAINBOW" /></a></li>
					</ul>
					<ul class="card-result">
						<li id="card01-result">
							<img src="http://webimage.10x10.co.kr/play/life/vol001/m/img_result1.jpg" alt="SKY BLUE - 기분전환이 필요해 보이네요." />
<!-- 							<a href="/event/eventmain.asp?eventid=88096&eGC=253512" class="mWeb"><img src="http://webimage.10x10.co.kr/play/life/vol001/m/btn_itemview1.png" alt="SKY BLUE 상품보러가기" /></a> -->
							<a href="" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88096#group253512');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/play/life/vol001/m/btn_itemview1.png" alt="SKY BLUE 상품보러가기" /></a>
						</li>
						<li id="card02-result">
							<img src="http://webimage.10x10.co.kr/play/life/vol001/m/img_result2.jpg" alt="PINK - 설레고, 기분 좋은 상상으로 행복한 일이 생길 것 같은가요?" />
<!-- 							<a href="/event/eventmain.asp?eventid=88096&eGC=253513" class="mWeb"><img src="http://webimage.10x10.co.kr/play/life/vol001/m/btn_itemview2.png" alt="PINK 상품보러가기" /></a> -->
							<a href="" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88096#group253513');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/play/life/vol001/m/btn_itemview2.png" alt="PINK 상품보러가기" /></a>
						</li>
						<li id="card03-result">
							<img src="http://webimage.10x10.co.kr/play/life/vol001/m/img_result3.jpg" alt="GREEN - 어떤 새로운 시작을 생각하나요?" />
<!-- 							<a href="/event/eventmain.asp?eventid=88096&eGC=253514" class="mWeb"><img src="http://webimage.10x10.co.kr/play/life/vol001/m/btn_itemview3.png" alt="GREEN 상품보러가기" /></a> -->
							<a href="" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88096#group253514');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/play/life/vol001/m/btn_itemview3.png" alt="GREEN 상품보러가기" /></a>
						</li>
						<li id="card04-result">
							<img src="http://webimage.10x10.co.kr/play/life/vol001/m/img_result4.jpg" alt="RAINBOW - 뭘 해도 지루한 요즘인가요?" />
<!-- 							<a href="/event/eventmain.asp?eventid=88096&eGC=253515" class="mWeb"><img src="http://webimage.10x10.co.kr/play/life/vol001/m/btn_itemview4.png" alt="RAINBOW 상품보러가기" /></a> -->
							<a href="" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88096#group253515');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/play/life/vol001/m/btn_itemview4.png" alt="RAINBOW 상품보러가기" /></a>
						</li>
					</ul>
				</div>			
				<%'//코멘트%>
				<div class="comment">
					<div class="comment-head">
						<h3><img src="http://webimage.10x10.co.kr/play/life/vol001/m/tit_comment_v2.png" alt="다음 주제는 무엇이 궁금하나요?" /></h3>
						<%'<!-- 코멘트 작성 -->%>
						<div class="comment-write">
							<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
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
							<div>
								<input type="text" id="txtcomm" name="txtcomm" maxlength="10" onClick="jsCheckLimit();" placeholder="10자 이내로 입력" />
								<button type="button" class="btn-recommend" onclick="jsSubmitComment(document.frmcom);return false;"><img src="http://webimage.10x10.co.kr/play/life/vol001/m/btn_recommend.png" alt="추천" /></button>
							</div>
							</form>
							<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
							<input type="hidden" name="mode" value="del">
							<input type="hidden" name="pagereload" value="ON">
							<input type="hidden" name="Cidx" value="">
							<input type="hidden" name="returnurl" value="<%= appUrlPath %>/playwebview/detail.asp?pidx=<%=vPIdx%>&pagereload=ON">
							<input type="hidden" name="eventid" value="<%= eCode %>">
							<input type="hidden" name="linkevt" value="<%= eCode %>">
							<input type="hidden" name="isApp" value="<%= isApp %>">
							</form>							
						</div>
					</div>
					<%'<!-- 코멘트 목록(6개씩 노출) -->%>
					<div class="comment-list" id="comment">
						<% If isArray(arrCList) Then %>
						<ul>
							<% For intCLoop = 0 To UBound(arrCList,2) %>
							<li>
								<p class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
								<p class="txt"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
								<p class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%> 님</p>
								<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
								<button type="button" class="btn-delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol042/m/btn_delete.png" alt="코멘트 삭제" /></button>
								<% End If %>
							</li>
							<% Next %>
						</ul>
						<% End If %>					
						<% If isArray(arrCList) Then %>
						<div class="paging pagingV15a">
							<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage")%>
						</div>
						<% end if %>
					</div>
				</div>
				<%'//코멘트%>
			</div>
			<%'<!--// 컨텐츠 영역 -->%>				
		</div>
	</div>
	<%'<!-- //contents -->%>