<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 가정의달 , 코멘트
' History : 2017-04-13 이종화 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim currenttime
	currenttime =  now()
	'currenttime = #10/07/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66308
Else
	eCode   =  77442
End If

dim userid, commentcount, i
	userid = GetEncLoginUserID()

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

iCPerCnt = 4		'보여지는 페이지 간격
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
<style type="text/css">
.evtHeadV15 {display:none;}
.familyMonth {position:relative; background-color:#b8dce5;}
.familyMonth .navigator {position:absolute; top:0; width:100%; z-index:10000; -webkit-transform:translateZ(0); -webkit-transition:all .5s ease;}
.familyMonth .navigator ul {overflow:hidden; position:absolute; top:0; left:0; width:100%; height:80%;}
.familyMonth .navigator ul li {float:left; width:25%; height:100%;}
.familyMonth .navigator ul li a {display:block;width:100%; height:100%; color:transparent; font-size:12px; line-height:12px; text-align:center;}
.familyMonth .stickyTab.navigator {position:fixed;}
.familyMonth .myStory {position:relative; padding-bottom:3.1rem;}
.familyMonth .myStory .swiper-slide {width:88.75%;}
.familyMonth .myStory .pagination {width:100%; height:0.8rem; margin-top:2rem; padding-top:0; text-align:center;}
.familyMonth .myStory .pagination span {width:0.8rem; height:0.8rem; margin:0 0.5rem; background-color:#fff; vertical-align:top;}
.familyMonth .myStory .pagination span.swiper-active-switch {background-color:#518b9a;}
.familyMonth .myStory .deco {position:absolute; left:0; bottom:-3.3%; z-index:40; width:32.65%;}
.commentEvent {padding-bottom:4rem; background-color:#fff;}
.commentEvent .form legend {visibility:hidden; width:0; height:0;}
.commentEvent .form .choice {overflow:hidden; width:93%; margin:0 auto;}
.commentEvent .form .choice li {float:left; width:20%;}
.commentEvent .form .choice li button {position:relative; display:block; width:100%;}
.commentEvent .form .choice li button.on:after {content:''; display:inline-block; position:absolute; left:0; top:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2017/77442/m/ico_select.png) no-repeat 0 0; background-size:100%;}
.commentEvent .field {position:relative; margin:2.8rem 6.25% 1rem; padding-right:55px;}
.commentEvent .field textarea {width:100%; height:5.5rem;  color:#333; font-size:1.2rem; border:0; border-radius:0; background-color:#f4f4f4;vertical-align:top;}
.commentEvent .field input {position:absolute; top:0; right:0; width:5.5rem; height:5.5rem; background-color:#333; color:#fff; font-size:1rem;}
.commentEvent .commentlist ul {margin:0 6.25%; border-top:1px solid #ddd;}
.commentEvent .commentlist ul li {position:relative; min-height:6.85rem; padding:2rem 0 2rem 7.5rem; border-bottom:1px solid #ddd; color:#777; font-size:1.1rem; line-height:1.375em;}
.commentEvent .commentlist ul li strong {position:absolute; top:50%; left:1%; width:5.95rem; height:6.85rem; margin-top:-3.6rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/77442/m/ico_01.png) no-repeat 0 0; background-size:100%; text-indent:-999em;}
.commentEvent .commentlist ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/77442/m/ico_02.png);}
.commentEvent .commentlist ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/77442/m/ico_03.png);}
.commentEvent .commentlist ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/77442/m/ico_04.png);}
.commentEvent .commentlist ul li .ico5 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/77442/m/ico_05_v3.png);}
.commentEvent .commentlist ul li .date {margin-top:0.7rem;}
.commentEvent .commentlist ul li .button {margin-top:0.5rem;}
.commentEvent .commentlist ul li .mob img {width:9px;}
</style>
<script type='text/javascript'>

$(function(){
	<% if pagereload<>"" then %>
		//pagedown();
		setTimeout("pagedown()",500);
	<% else %>
		setTimeout("pagup()",500);
	<% end if %>
});

function pagup(){
	window.$('html,body').animate({scrollTop:$("#toparticle").offset().top}, 0);
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
		<% If not( left(currenttime,10)>="2017-04-19" and left(currenttime,10)<"2017-05-04" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if (frm.gubunval.value == ''){
					alert('원하는 아이콘을 선택해 주세요.');
					return false;
				}
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 400){
					alert("코맨트를 남겨주세요.\n400자 까지 작성 가능합니다.");
					frm.txtcomm1.focus();
					return false;
				}

				frm.txtcomm.value = frm.gubunval.value + '!@#' + frm.txtcomm1.value
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

//내코멘트 보기
function fnMyComment() {
	document.frmcom.isMC.value="<%=chkIIF(isMyComm="Y","N","Y")%>";
	document.frmcom.iCC.value=1;
	document.frmcom.submit();
}
</script>
<!-- 가정의달 기획전3 : Thanks Bucket List -->
<div class="mEvt77442 familyMonth">
	<div class="navigator">
		<img src="http://webimage.10x10.co.kr/eventIMG/2017/77442/m/txt_tab.png" alt="" />
		<ul>
			<li><a href="eventmain.asp?eventid=77438">카네이션</a></li>
			<li><a href="eventmain.asp?eventid=77441">기프트 50</a></li>
			<li><a href="eventmain.asp?eventid=77442">버킷리스트</a></li>
			<li><a href="eventmain.asp?eventid=77443">메세지</a></li>
		</ul>
	</div>
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/77442/m/tit_bucket.jpg" alt="thanks bucket list" /></h2>
	<div class="myStory">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77442/m/img_story_01.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77442/m/img_story_02_v2.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77442/m/img_story_03_v2.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77442/m/img_story_04.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77442/m/img_story_05.png" alt="" /></div>
			</div>
			<div class="pagination"></div>
		</div>
		<div class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77442/m/img_flower_bag.png" alt="" /></div>
	</div>
	<%' comment event %>
	<div id="commentevt" class="commentEvent">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/77442/m/txt_comment_v2.jpg" alt="COMMENT EVNET - 당신의 버킷리스트는 무엇인가요?" /></p>
		<div class="form">
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
				<fieldset>
					<legend>코멘트 쓰기</legend>
					<ul class="choice">
						<li class="ico1">
							<button type="button" value="1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77442/m/ico_01.png" alt="케이크 만들기" /></button>
						</li>
						<li class="ico2">
							<button type="button" value="2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77442/m/ico_02.png" alt="추억 남기기" /></button>
						</li>
						<li class="ico3">
							<button type="button" value="3"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77442/m/ico_03.png" alt="꽃송이 만들기" /></button>
						</li>
						<li class="ico4">
							<button type="button" value="4"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77442/m/ico_04.png" alt="여행 떠나기" /></button>
						</li>
						<li class="ico5">
							<button type="button" value="5"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77442/m/ico_05_v3.png" alt="책 선물" /></button>
						</li>
					</ul>
					<div class="field">
						<textarea name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> title="코멘트 작성" cols="60" rows="5"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %><%END IF%></textarea>
						<input type="submit" onclick="jsSubmitComment(document.frmcom); return false;" value="응모하기" class="btnsubmit" />
					</div>
				</fieldset>
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
		</div>

		<%' for dev msg : comment list %>
		<div class="commentlist">
			<% IF isArray(arrCList) THEN %>
			<ul>
				<% For intCLoop = 0 To UBound(arrCList,2) %>
				<li>
					<% If isarray(split(arrCList(1,intCLoop),"!@#")) Then %>
					<strong class="ico<%= split(arrCList(1,intCLoop),"!@#")(0) %>">
						<% If split(arrCList(1,intCLoop),"!@#")(0)="1" Then %>
							케이크 만들기
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
							추억 남기기
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
							꽃송이 만들기
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="4" Then %>
							여행 떠나기
						<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="5" Then %>
							책 선물
						<% Else %>
							케이크 만들기
						<% End if %>	
					</strong>
					<% End If %>
					<div class="letter">
						<p>
						<% if isarray(split(arrCList(1,intCLoop),"!@#")) then %>
							<% if ubound(split(arrCList(1,intCLoop),"!@#")) > 0 then %>
								<%=ReplaceBracket(db2html( split(arrCList(1,intCLoop),"!@#")(1) ))%>
							<% end if %>
						<% end if %>
						</p>
						<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
							<span class="button btS1 btGry2 cWh1"><button type="button" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;">삭제</button></span>
						<% end if %>
					</div>
					<div class="date"><span><%=printUserId(arrCList(2,intCLoop),2,"*")%></span> / <span><%= FormatDate(arrCList(4,intCLoop),"0000.00.00") %></span>
					<% If arrCList(8,intCLoop) <> "W" Then %>
						<span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성"></span>
					<% end if %>
					</div>
				</li>
				<% next %>
			</ul>
				<% IF isArray(arrCList) THEN %>
					<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
				<% end if %>
			<% end if %>
		</div>
	</div>
	<%' comment event %>
</div>
<script type="text/javascript">
$(function(){
	$(".choice li:first-child button").addClass("on");
	frmcom.gubunval.value = '1';
	$(".choice li button").click(function(){
		frmcom.gubunval.value = $(this).val();
		$(".choice li button").removeClass("on");
		if ( $(this).hasClass("on")) {
			$(this).removeClass("on");
		} else {
			$(this).addClass("on");
		}
	});
	mySwiper = new Swiper('.myStory .swiper-container',{
		slidesPerView: 'auto',
		centeredSlides: true,
		pagination:'.myStory .pagination',
		paginationClickable: true
	});

	var lastScrollTop = 0, delta = 5;
	$(window).scroll(function(){
			 var nowScrollTop = $(this).scrollTop();
			 if(Math.abs(lastScrollTop - nowScrollTop) >= delta){
					if (nowScrollTop > lastScrollTop){
							// SCROLLING DOWN 
							$(".navigator").removeClass("stickyTab");
					} else {
							// SCROLLING UP 
							$(".navigator").addClass("stickyTab");
					}
					lastScrollTop = nowScrollTop;
			}
	});
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->