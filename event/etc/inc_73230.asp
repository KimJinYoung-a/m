<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'########################################################
' 그랜드 민트 페스티벌 2016 공식MDx텐바이텐 사전판매
' 2016-10-04 원승현 작성
'########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim currenttime
	currenttime =  now()
	'currenttime = #04/22/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66211
Else
	eCode   =  73230
End If

dim userid, commentcount, i
	userid = getEncloginuserid()

commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop
dim iCPageSize, iCCurrpage, isMyComm, ename, emimg, blnitempriceyn, ecc
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	ecc	= requestCheckVar(Request("ecc"),10)	

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
	iCPageSize = 8		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 8		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
end If

'// 이벤트 정보 가져옴

dim cEvent
	set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent
	
	eCode		= cEvent.FECode	
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
	blnitempriceyn = cEvent.FItempriceYN	


	set cEvent = Nothing


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
img {vertical-align:top;}
.mEvt73230 {overflow:hidden; position:relative; background-color:#ffd545;}
.ribbon {position:absolute; left:0; top:1.5%;}
.item .noti {visibility:hidden; width:0; height:0;}
.item {position:relative;}
.item ul {overflow:hidden; position:absolute; top:3%; left:50%; width:90%; margin-left:-45%;}
.item ul li {float:left; width:50%;}
.item ul li a {overflow:hidden; display:block; position:relative; height:100%; padding-bottom:130.25%; text-indent:-999em;}
.about {position:relative; background-color:#2ea05a;}
.about .btnLineup {position:absolute; bottom:10%; left:50%; width:38.28125%; margin-left:-19.140625%;}

.drop {-webkit-animation-name:drop; -webkit-animation-duration:0.4s; -webkit-animation-timing-function:ease-in-out; -webkit-animation-delay:0;-webkit-animation-iteration-count:1; animation-name:drop; animation-duration:0.4s; animation-timing-function:ease-in-out; animation-delay:0; animation-iteration-count:1;}
@-webkit-keyframes drop {
	0% {margin-top:-20%; opacity:0;}
	100%{margin-top:0; opacity:1;}
}
@keyframes drop {
	0%{margin-top:-20%; opacity:0;}
	100%{margin-top:0; opacity:1;}
}
.leaf {animation:leaf 4s ease-in-out 0s infinite; transform-origin:0% 40%; -webkit-animation:leaf 4s ease-in-out 0s infinite; -webkit-transform-origin:0% 40%;}
@-webkit-keyframes leaf {
	0% {-webkit-transform:rotate(0);}
	50% {-webkit-transform:rotate(-5deg);}
	100% {-webkit-transform:rotate(0);}
}
@keyframes leaf {
	0% {transform:rotate(0);}
	50% {transform:rotate(-5deg);}
	100% {transform:rotate(0);}
}

.cmtArea {position:relative;}
.cmtArea .cmtInput {overflow:hidden; position:absolute; left:0; top:55.5%; width:100%; height:17.5%; padding:0 5%;}
.cmtArea .cmtInput legend {visibility:hidden; width:0; height:0;}
.cmtArea .cmtInput fieldset {height:100%;}
.cmtArea .cmtInput .inputBox {float:left; width:70%; height:100%; padding:1em; border-radius:0; border-top-left-radius:1.3rem; border-bottom-left-radius:1.3rem; background-color:#fff;}
.cmtArea .cmtInput textarea {width:100%; height:100%; padding:0; border:0; color:#4d4d4d; font-size:1.2rem;}
.cmtArea .cmtInput button {float:right; width:30%; height:100%; background:#2ea05a url(http://webimage.10x10.co.kr/eventIMG/2016/73230/m/btn_gmf_cmt_deco.png) no-repeat 100% 100%; background-size:75%; color:#fff; font-size:1.6rem; letter-spacing:0.5rem; line-height:1.3; font-weight:bold; border:0; border-radius:0; border-top-right-radius:1.3rem; border-bottom-right-radius:1.3rem; text-align:center;}
.cmtArea ul {visibility:hidden; width:0; height:0;}
.commentlistwrap {padding:10% 0;}
.commentlist .col {position:relative; width:91%; margin:0 auto 2.8rem; padding:1.7rem 1.5rem; border-radius:1rem;}
.commentlist .col:after {display:block; position:absolute; right:1.5rem; top:99.9%; width:1.5rem; height:1.3rem; content:''; background:url(http://webimage.10x10.co.kr/eventIMG/2016/73230/m/btn_gmf_cmt_box_pointer.png) no-repeat 50% 50%; background-size:100%;}
.commentlist .col1 {background-color:#30ae60;}
.commentlist .col2 {background-color:#ffa200;}
.commentlist .col .info {position:relative; font-size:1.1rem; font-weight:bold;}
.commentlist .col .info .no {display:inline-block; padding-top:0.3rem; color:#fff;}
.commentlist .col .info .no i {display:inline-block; margin-top:0.1rem; font-size:0.9rem; color:#fff; opacity:0.5; filter:alpha(opacity=50); vertical-align:top; -webkit-appearance:none;}
.commentlist .col .info .btndel {display:inline-block; position:relative; padding:0.4rem 0.75rem 0.35rem 0.75rem; margin:0 0 -0.3rem 0.5rem; border-radius:2rem; background-color:#747474; color:#fff; font-size:0.9rem; line-height:1; text-align:center; vertical-align:top;}
.commentlist .col .info .id {position:absolute; top:0.3rem; right:0; color:#3e2b21;}
.commentlist .col .msg {margin-top:1.5rem; color:#fff; font-size:1.05rem; line-height:1.4;}
.commentlist .col1:after {background-color:#30ae60;}
.commentlist .col2:after {background-color:#ffa200;}
.commentlist .col1 .info .id span {color:#0e5328;}
.commentlist .col2 .info .id span {color:#7b5e00;}
.paging span.arrow {border:1px solid #a68b2d; background-color:#a68b2d;}
.paging span {border:1px solid #a68b2d;}
.paging span a {color:#a0862b;}
.paging span.current {background-color:transparent;}
</style>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<script type="text/javascript">
<% if Request("iCC") <> "" or request("ecc") <> "" then %>
	$(function(){
		var val = $('.commentlistwrap').offset();
		window.$('html,body').animate({scrollTop:$(".commentlistwrap").offset().top-100}, 10);
	});
<% end if %>

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}


function jsSubmitComment(frm){      //코멘트 입력
	<% If IsUserLoginOK() Then %>
		<% If Now() > #10/12/2016 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If left(now(), 10)>="2016-10-04" and left(now(), 10) < "2016-10-13" Then %>
				<% if commentcount >= 5 then %>
					alert("이벤트는 총 5회까지만 응모하실 수 있습니다.\n10월 14일(금) 당첨자 발표를 기다려 주세요!");
					return;				
				<% else %>
					if (frm.txtcomm.value == '' || GetByteLength(frm.txtcomm.value) > 600 || frm.txtcomm.value == 'GMF2016의 열 번째 생일을 축하해주세요!'){
						alert("GMF2016의 열 번째 생일을 축하해주세요!\n600자 까지 작성 가능합니다.");
						frm.txtcomm.focus();
						return false;
					}
				   frm.action = "/event/lib/doEventComment.asp";
				   frm.submit();
				<% end if %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>				
		<% End If %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
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
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	}

	if (frmcom.txtcomm.value == 'GMF2016의 열 번째 생일을 축하해주세요!'){
		frmcom.txtcomm.value = '';
	}
}


//내코멘트 보기
function fnMyComment() {
	document.frmcom.isMC.value="<%=chkIIF(isMyComm="Y","N","Y")%>";
	document.frmcom.iCC.value=1;
	document.frmcom.submit();
}

<%
	dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
	snpTitle = Server.URLEncode(ename)
	snpLink = Server.URLEncode("http://www.10x10.co.kr/event/" & ecode)
	snpPre = Server.URLEncode("텐바이텐 이벤트")
	snpTag = Server.URLEncode("텐바이텐 " & Replace(ename," ",""))
	snpTag2 = Server.URLEncode("#10x10")
%>

// sns카운팅
function getsnscnt(snsno) {
	var str = $.ajax({
		type: "GET",
		url: "/event/etc/doEventSubscript66367.asp",
		data: "mode=snscnt&snsno="+snsno,
		dataType: "text",
		async: false
	}).responseText;
	if(str=="tw") {
		popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
	}else if(str=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}

</script>
<%' GMF %>
<div class="mEvt73230">
	<div class="ribbon drop">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/73230/m/tit_gmf_ribbon.png" alt="텐바이텐 x 그랜드 민트 페스티벌 2016" /></p>
	</div>
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/73230/m/tit_gmf_v2.png" alt="빛나는 가을날 모두의 축제 GRAND MINT FESTIVAL - GMF 공식 굿즈 온라인 사전 판매 기념 10% SALE(기간:2016.10.05~10.12 / 한정수량)" /></h2>

	<%' item %>
	<div class="item">
		<ul class="mWeb">
			<li><a href="/category/category_itemPrd.asp?itemid=1560449&amp;pEtr=71230">공식 티셔츠</a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1560450&amp;pEtr=71230">공식 블랑켓 + 핀버튼</a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1560448&amp;pEtr=71230">공식 보틀 + 스티커</a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1560447&amp;pEtr=71230">공식 스티커</a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1560451&amp;pEtr=71230">공식 핀버튼</a></li>
		</ul>
		<ul class="mApp">
			<li><a href="/category/category_itemPrd.asp?itemid=1560449" onclick="fnAPPpopupProduct('1560449&amp;pEtr=71230');return false;">공식 티셔츠</a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1560450" onclick="fnAPPpopupProduct('1560450&amp;pEtr=71230');return false;">공식 블랑켓 + 핀버튼</a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1560448" onclick="fnAPPpopupProduct('1560448&amp;pEtr=71230');return false;">공식 보틀 + 스티커</a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1560447" onclick="fnAPPpopupProduct('1560447&amp;pEtr=71230');return false;">공식 스티커</a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1560451" onclick="fnAPPpopupProduct('1560451&amp;pEtr=71230');return false;">공식 핀버튼</a></li>
		</ul>
		<p class="noti">온라인에서는 판매가 중단되어도 페스티벌 현장에서 정가로 판매될 예정입니다.</p>
		<img src="http://webimage.10x10.co.kr/eventIMG/2016/73230/m/img_gmf_item.jpg" alt="" />
	</div>

	<div class="about">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/73230/m/txt_gmf.png" alt="해로 10회를 맞이하는 그랜드 민트 페스티벌! 열 살을 맞이한 GMF2016의 테마는 ‘감사’입니다. 민트페이퍼의 1년 결산이자 대잔치. 기분 좋은 증후군이자 추억을 불러오는 데자뷔. 그랜드 민트 페스티벌 시즌이 돌아왔습니다. 열 번째 생일을 만들어준 모두에게 감사함을 표합니다." /></p>
		<% If isApp="1" Then %>
			<a href="" onclick="fnAPPpopupExternalBrowser('https://www.mintpaper.co.kr/gmf2016/lineup'); return false;" class="btnLineup leaf mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73230/m/btn_gmf_lineup.png" alt="GMF2016 라인업 보기" /></a>
		<% Else %>
			<a href="https://www.mintpaper.co.kr/gmf2016/lineup" target="_blank" class="btnLineup leaf mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73230/m/btn_gmf_lineup.png" alt="GMF2016 라인업 보기" /></a>
		<% End If %>
	</div>

	<div class="cmtArea">
		<img src="http://webimage.10x10.co.kr/eventIMG/2016/73230/m/txt_gmf_cmt.png" alt="열 살을 맞이한 가을날의 축제 GMF 2016! GMF2016의 열 번째 생일을 축하해주세요! 정성껏 코멘트를 남겨주신 5분을 추첨하여 10월 22일 토요일 티켓(1인 2매)을 선물로 드립니다!" />
		<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
		<input type="hidden" name="mode" value="add">
		<input type="hidden" name="pagereload" value="ON">
		<input type="hidden" name="iCC" value="1">
		<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
		<input type="hidden" name="userid" value="<%= userid %>">
		<input type="hidden" name="eventid" value="<%= eCode %>">
		<input type="hidden" name="linkevt" value="<%= eCode %>">
		<input type="hidden" name="blnB" value="<%= blnBlogURL %>">
		<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&ecc=1">
			<div class="cmtInput">
				<fieldset>
					<legend>그랜드 민트 페스티벌 기대평 남기고 티켓 응모하기</legend>
					<p class="inputBox"><textarea title="기대평 쓰기" name="txtcomm" id="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%>><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>GMF2016의 열 번째 생일을 축하해주세요!<%END IF%></textarea></p>
					<button type="button" onclick="jsSubmitComment(frmcom); return false;">응모<br />하기</button>
				</fieldset>
			</div>
		</form>
		<ul>
			<li>비방성 댓글 및 타인의 댓글을 그대로 옮겨 쓴 댓글은 통보없이 자동 삭제 됩니다.</li>
			<li>당첨자 1명에게는 2매의 티켓이 제공되며, 발표 후, 개인정보를 요청하게 될 수 있습니다.</li>
			<li>초대권의 양도 및 재판매는 불가하며, 확인 시 취소조치 됩니다.</li>
		</ul>
	</div>

	<%' comment list %>
	<% IF isArray(arrCList) THEN %>
	<div class="commentlistwrap">
		<div class="commentlist">
			<%' for dev msg : 한페이지당 8개 %>
			<%
				dim rndNo : rndNo = 1
			
				For intCLoop = 0 To UBound(arrCList,2)

'				if isarray(split(arrCList(1,intCLoop),"|!/")) Then
'					if ubound(split(arrCList(1,intCLoop),"|!/")) > 0 then
'						rndNo = ReplaceBracket(db2html( split(arrCList(1,intCLoop),"|!/")(0) ))
'					End If
'				End If

			%>
			<div class="col col<%=rndNo%>">
				<div class="info">
					<strong class="no"><i>◆</i> <%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%>번째 축하</strong> 						<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %><button type="button" class="btndel" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');return false;">삭제 X</button><% End If %>
					<span class="id"><%=printUserId(arrCList(2,intCLoop),2,"*")%> <span><%=Mid(arrCList(4,intCLoop), 6, 2)&"."&Mid(arrCList(4,intCLoop), 9, 2)%></span></span>
				</div>
				<p class="msg"><%=db2html(arrCList(1,intCLoop))%></p>
			</div>
			<%
				If rndNo < 2 Then
					rndNo = rndNo + 1
				Else
					rndNo = 1
				End If
			%>
			<% next %>				
		</div>

		<!-- paging -->
		<div class="paging">
			<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
		</div>
	</div>
	<% End If %>

</div>
<!-- //GMF -->
	<form name="frmdelcom" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
	<input type="hidden" name="mode" value="del">
	<input type="hidden" name="pagereload" value="ON">
	<input type="hidden" name="Cidx" value="">
	<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&ecc=1">
	<input type="hidden" name="userid" value="<%= userid %>">
	<input type="hidden" name="eventid" value="<%= eCode %>">
	<input type="hidden" name="linkevt" value="<%= eCode %>">
	</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->