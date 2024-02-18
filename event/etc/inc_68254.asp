<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 박스테이프 공모전
' History : 2015-12-22 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim oItem, pagereload, classboxcol, cmtYN
dim currenttime
	currenttime =  now()
	'currenttime = #10/07/2015 09:00:00#
	cmtYN = "N"
dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  65991
Else
	eCode   =  68254
End If

dim userid, commentcount, i
	userid = GetEncLoginUserID()

commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, ecc
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),10)

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
@font-face {font-family:'SDGdGulim';
src: url('http://m.10x10.co.kr/webfont/SDGdGulim.eot');
src: url('http://m.10x10.co.kr/webfont/SDGdGulim.eot?#iefix') format('embedded-opentype'), url('http://m.10x10.co.kr/webfont/SDGdGulim.woff') format('woff'), url('http://m.10x10.co.kr/webfont/SDGdGulim.ttf') format('truetype'); font-style:normal; font-weight:normal;}

html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}
.mEvt68254 {background-color:#fff;}
.boxTabCont {position:relative;}
.boxTabCont ul {overflow:hidden; position:absolute; left:50%; top:0; width:84%; height:36%; margin-left:-42%;}
.boxTabCont ul li {overflow:hidden; float:left; width:25%; height:100%;}
.boxTabCont ul li a {display:block; width:100%; height:100%; text-indent:-999em;}
.tapeTxtInput {position:relative;}
.tapeTxtInput fieldset {display:block;}
.tapeTxtInput input {position:absolute; left:50%; top:35%; width:92%; height:4rem; margin-left:-46%; border:none; background-color:#e8d2bf; font-size:1.2rem; font-family:'SDGdGulim', 'gulim', sans-serif; color:#4a4442; z-index:10;}
.tapeTxtInput input::-webkit-input-placeholder {font-size:1.2rem; color:#4a4442; font-family:'SDGdGulim', 'gulim', sans-serif;}
.tapeTxtInput input:-moz-placeholder {font-size:1.2rem; color:#4a4442; font-family:'SDGdGulim', 'gulim', sans-serif;}
.tapeTxtInput input::-moz-placeholder {font-size:1.2rem; color:#4a4442; font-family:'SDGdGulim', 'gulim', sans-serif;}
.tapeTxtInput input:-ms-input-placeholder {font-size:1.2rem; color:#4a4442; font-family:'SDGdGulim', 'gulim', sans-serif;}
.tapeTxtInput button {overflow:hidden; position:absolute; right:0; bottom:15%; width:33%; height:25%; text-indent:-999em; background-color:transparent;}
#boxTab04 {position:relative;}
#boxTab04 a {display:block; position:absolute; bottom:9%; height:15%; text-indent:-999em;}
#boxTab04 a.link1 {width:50%; left:5%;}
#boxTab04 a.link2 {width:40%; right:5%;}
.mEvt68254 .tapeAtclWrap {overflow:hidden; padding:2rem 1.75rem; margin:0 auto;}
.mEvt68254 .tapeAtclList {overflow:hidden;}
.mEvt68254 .tapeAtclList li {position:relative; float:left; width:50%; padding:0.75rem;}
.mEvt68254 .tapeAtclList li .atclBox {position:relative; display:table; width:100%; height:10rem; background-color:#ba1e24; color:#fff; text-align:center; vertical-align:middle;}
.mEvt68254 .tapeAtclList li .atclBox span {position:absolute; left:0.7rem; top:0.7rem; height:1.1rem; padding:0 0.5rem; border-radius:0.6rem 0.6rem; background-color:#fff; text-align:center; font-size:0.8rem; line-height:1.2rem; font-weight:bold; color:#ba1e24;}
.mEvt68254 .tapeAtclList li .atclBox p {position:absolute; right:0.7rem; bottom:0.7rem; font-size:0.9rem; text-decoration:underline; font-weight:bold;}
.mEvt68254 .tapeAtclList li .atclTxt {display:table-cell; text-align:center; width:52%; font-size:1.2rem; line-height:1.3; vertical-align:middle; font-family:'SDGdGulim', 'gulim', sans-serif;}
.mEvt68254 .tapeAtclList li .btnDel {position:absolute; right:0.8rem; top:0.75rem; width:1.85rem; height:1.85rem;}

.mEvt68254 .tapeAtclList li.rdBox .atclBox {background-color:#ba1e24;}
.mEvt68254 .tapeAtclList li.rdBox .atclBox span {color:#ba1e24;}
.mEvt68254 .tapeAtclList li.ywBox .atclBox {background-color:#b48763;}
.mEvt68254 .tapeAtclList li.ywBox .atclBox span {color:#9a6e4b;}
</style>
<script type="text/javascript">

$(function(){
	<% if pagereload<>"" then %>
		//pagedown();
		setTimeout("pagedown()",300);
	<% else %>
		setTimeout("pagup()",300);
	<% end if %>
});

function pagup(){
	window.$('html,body').animate({scrollTop:$(".mEvt68254").offset().top}, 0);
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
		<% If not( left(currenttime,10)>="2015-12-23" and left(currenttime,10)<"2016-01-11" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>4 then %>
				alert("한 ID당 최대 5번까지 참여할 수 있습니다.");
				return false;
			<% else %>
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 36){
					alert("띄어쓰기 포함\n최대 한글 18자 이내로 적어주세요.");
					frm.txtcomm1.focus();
					return false;
				}
				frm.txtcomm.value = frm.txtcomm1.value
				frm.action = "/event/lib/doEventComment.asp";
				frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
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
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	}
}
</script>
	<!-- 널-리 박스테이프를 이롭게 하다 -->
	<div class="mEvt68254">
		<article>
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/68254/m/boxtape_tit.png" alt="널-리 박스테이프를 이롭게 하다" /></h2>
			<div class="boxTabCont">
				<ul>
					<li><a href="" onClick="javascript:boxTab('boxTab01'); return false;">주제</a></li>
					<li><a href="" onClick="javascript:boxTab('boxTab02'); return false;">일정</a></li>
					<li><a href="" onClick="javascript:boxTab('boxTab03'); return false;">시상</a></li>
					<li><a href="" onClick="javascript:boxTab('boxTab04'); return false;">SandOll</a></li>
				</ul>
				<p id="boxTab01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68254/m/boxtape_tab1.png" alt="주제" /></p>
				<p id="boxTab02" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68254/m/boxtape_tab2.png" alt="일정" /></p>
				<p id="boxTab03" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68254/m/boxtape_tab3.png" alt="시상" /></p>
				<p id="boxTab04" style="display:none;">
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/68254/m/boxtape_tab4.png" alt="SandOll" />
					<a href="http://www.sandoll.co.kr/?viba_portfolio=gyeokdonggothic" target="_blank" class="link1">[산돌 격동굴림] 더 자세히 보기 ▶</a>
					<a href="http://www.sandoll.co.kr/sandollcloud/" target="_blank" class="link2">[산돌 구름] 만나러 가기 ▶</a>
				</p>
			</div>
			<div class="tapeTxtInput">
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
					<input type="text" name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" placeholder="<%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>띄어쓰기 포함 최대 18자 이내로 적어주세요<%END IF%>" />
					<button onclick="jsSubmitComment(document.frmcom); return false;">응모</button>
				</fieldset>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/68254/m/boxtape_input.png" alt="우리는 모두 박스테이프 크리에이터!" />
			</form>
			<form name="frmdelcom" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
			<input type="hidden" name="mode" value="del">
			<input type="hidden" name="pagereload" value="ON">
			<input type="hidden" name="Cidx" value="">
			<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
			<input type="hidden" name="eventid" value="<%= eCode %>">
			<input type="hidden" name="linkevt" value="<%= eCode %>">
			<input type="hidden" name="isApp" value="<%= isApp %>">
			</form>
			</div>

		<% if cmtYN = "Y" then %>
			<% IF isArray(arrCList) THEN %>
			<div class="tapeAtclWrap"  id="commentevt">
				<ul class="tapeAtclList">
				<% For intCLoop = 0 To UBound(arrCList,2) %>
				<% if intCLoop = 0 or intCLoop = 3 or intCLoop = 4 or intCLoop = 7 then classboxcol="rdBox" else classboxcol="ywBox" end if %>
					<li class="<%= classboxcol %>"><!-- for dev msg : 처음 li 하나만 rdbox 클래스 이고 두번째부터는 두개씩 ywBox / rdBox 차례로 클래스 붙여주세요-->
						<div class="atclBox">
							<span>NO.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%></span>
							<div class="atclTxt"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></div>
							<p><%=printUserId(arrCList(2,intCLoop),2,"*")%></p>
						</div>
						<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
							<a href="" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;" class="btnDel"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68254/m/boxtape_cmt_del.png" alt="삭제" /></a>
						<% end if %>
					</li>
				<% next %>
				</ul>
				<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
			</div>
			<% end if %>
		<% end if %>
		</article>
	</div>
	<!-- //널-리 박스테이프를 이롭게 하다 -->
<script>
function boxTab(flag){
	if (flag == "boxTab01") {
		document.getElementById("boxTab01").style.display ="block";
		document.getElementById("boxTab02").style.display ="none";
		document.getElementById("boxTab03").style.display ="none";
		document.getElementById("boxTab04").style.display ="none";
	} else if (flag == "boxTab02") {
		document.getElementById("boxTab01").style.display ="none";
		document.getElementById("boxTab02").style.display ="block";
		document.getElementById("boxTab03").style.display ="none";
		document.getElementById("boxTab04").style.display ="none";
	} else if (flag == "boxTab03") {
		document.getElementById("boxTab01").style.display ="none";
		document.getElementById("boxTab02").style.display ="none";
		document.getElementById("boxTab03").style.display ="block";
		document.getElementById("boxTab04").style.display ="none";
	} else if (flag == "boxTab04") {
		document.getElementById("boxTab01").style.display ="none";
		document.getElementById("boxTab02").style.display ="none";
		document.getElementById("boxTab03").style.display ="none";
		document.getElementById("boxTab04").style.display ="block";
	}
}
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->