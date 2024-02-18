<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAY NICE DREAM
' History : 2015.06.26 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->

<%
Dim eCode, eCodedisp
IF application("Svr_Info") = "Dev" THEN
	eCode   =  63803
	eCodedisp = 63803
Else
	eCode   =  64082
	eCodedisp = 64082
End If

dim currenttime
	currenttime =  now()
	'currenttime = #06/29/2015 09:00:00#

dim userid, i, vreload
	userid = getloginuserid()
	vreload	= requestCheckVar(Request("vreload"),10)

dim commentcount
commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)

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

<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.mLink {display:none;}
.mPlay20150629 {padding-bottom:30px; background:#fff;}
.brandStory {position:relative;}
.brandStory a {display:block; position:absolute; right:8%;bottom:15.5%; width:49%; height:14%; color:transparent;}
.goBuy {position:relative;}
.goBuy a {display:block; position:absolute; left:25.5%; top:0; width:49%; height:45%; color:transparent;}
.specialEvent {padding-bottom:5px; background:#fff6e6;}
.specialEvent .dreamCont {padding:0 10px;}
.specialEvent .step {margin:3px 0 15px; background:#fff; box-shadow:0 0 2px 1px rgba(0,0,0,.08);}
.specialEvent .selectShirt {overflow:hidden; padding:17px 8px;}
.specialEvent .selectShirt input[type=radio] {position:relative; margin-bottom:7px; width:15px; height:15px; border:1px solid #222; border-radius:50%;}
.specialEvent .selectShirt input[type=radio]:checked {background:none;}
.specialEvent .selectShirt input[type=radio]:checked:after {content:' '; display:inline-block; position:absolute; left:20%; top:20%; width:60%; height:60%; background:#222; border-radius:50%;}
.specialEvent .selectShirt div {float:left; width:33.33333%; text-align:center;}
.specialEvent .writeShirt .msg {width:75%; margin:0 auto; border-bottom:2px solid #3c3c3c;}
.specialEvent .writeShirt .msg input {width:100%; color:#3c3c3c; font-size:26px; text-align:center; border:0;}
.specialEvent .writeShirt .btnSubmit {width:58%; padding-top:17px; margin:0 auto;}
.specialEvent .writeShirt .btnSubmit input {width:100%;}
.shirtList {padding:25px 0 5px;}
.shirtList ul {overflow:hidden;}
.shirtList li {float:left; width:50%; margin-bottom:30px; text-align:center;}
.shirtList li .msg {position:relative; color:#fff; background-position:0 0; background-repeat:no-repeat; background-size:100% 100%;}
.shirtList li .msg span {display:block; position:absolute; left:0; top:25%; width:100%;font-size:14px; font-weight:bold; text-align:center;}
.shirtList li.shirt01 .msg {color:#3c3c3c; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150629/bg_cmt_shirt01.jpg);}
.shirtList li.shirt02 .msg {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150629/bg_cmt_shirt02.jpg);}
.shirtList li.shirt03 .msg { background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150629/bg_cmt_shirt03.jpg);}
.shirtList li .num {padding-top:5px; font-size:11px; color:#737373;}
.shirtList li .writer {position:relative; font-size:12px; color:#3c3c3c; font-weight:bold;}
.shirtList li .writer .button {position:absolute; left:50%; top:13px; margin-left:-20px;}
.shirtList li .writer .button a {padding:4px 7px 2px;}
@media all and (min-width:480px){
	.mPlay20150629 {padding-bottom:45px;}
	.specialEvent {padding-bottom:7px;}
	.specialEvent .dreamCont {padding:0 15px;}
	.specialEvent .step {margin:4px 0 23px;}
	.specialEvent .selectShirt {padding:26px 12px;}
	.specialEvent .selectShirt input[type=radio] {margin-bottom:11px; width:23px; height:23px;}
	.specialEvent .writeShirt .msg input {font-size:39px;}
	.specialEvent .writeShirt .btnSubmit {padding-top:26px;}
	.shirtList {padding:38px 0 7px;}
	.shirtList li {margin-bottom:45px;}
	.shirtList li .msg span {font-size:21px;}
	.shirtList li .num {padding-top:5px; font-size:17px;}
	.shirtList li .writer {font-size:18px;}
	.shirtList li .writer .button {top:20px; margin-left:-30px;}
	.shirtList li .writer .button a {padding:6px 11px 3px;}
}
</style>
<script type="text/javascript">
$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$(".ma").show();
		$(".mw").hide();
	}else{
		$(".mw").show();
		$(".ma").hide();
	}
	
	<% if vreload<>"" then %>
		setTimeout("pagedown()",500);
	<% end if %>
});

function pagedown(){
	window.parent.$('html,body').animate({scrollTop:$("#shirtList").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-06-29" and left(currenttime,10)<"2015-07-13" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>5 then %>
				alert("이벤트는 5회만 참여하실수 있습니다.");
				return false;
			<% else %>
				var tmpcolorgubun='';
				for (var i = 0; i < frm.colorgubun.length; i++){
					if (frm.colorgubun[i].checked){
						tmpcolorgubun = frm.colorgubun[i].value;
					}
				}
				if (tmpcolorgubun==''){
					alert('원하는 컬러를 선택해 주세요.');
					return false;
				}

				if (frm.txtcomm1.value == '여덟자까지 입력'){
					frm.txtcomm1.value = '';
				}
				//alert( frm.txtcomm1.value );
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 16 || frm.txtcomm1.value == '8자 이내로 입력해주세요'){
					alert("코맨트를 남겨주세요.\n8자 까지 작성 가능합니다.");
					frm.txtcomm1.focus();
					return false;
				}
				
				frm.txtcomm.value = tmpcolorgubun + '!@#' + frm.txtcomm1.value
				frm.action = "/play/groundcnt/doEventSubscript64082.asp";
				frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsevtlogin();
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
			parent.jsevtlogin();
			return false;
		<% end if %>
	}

	if (frmcom.txtcomm1.value == '여덟자까지 입력'){
		frmcom.txtcomm1.value = '';
	}
}

//내코멘트 보기
function fnMyComment() {
	document.frmcom.isMC.value="<%=chkIIF(isMyComm="Y","N","Y")%>";
	document.frmcom.iCC.value=1;
	document.frmcom.submit();
}

</script>
</head>
<body>

<!-- #4 NICE DREAM -->
<div class="mPlay20150629">
	<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150629/tit_nice_dream.jpg" alt="NOCE DREAM" /></h2>
	<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150629/txt_purpose.jpg" alt="더 좋은 꿈을+" /></div>
	<div>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150629/img_every01.jpg" alt="매일 밤 우리는" /></p>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150629/img_every02.jpg" alt="하루를 정리하고 이불 속으로 향하는 시간 이불 속으로 가는 것처럼 꿈을 향해서 조금 더 조금 더 조용하고 편안한 시간을 함께 해요." /></p>
	</div>
	<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150629/img_kit.jpg" alt="NICE DREAM KIT" /></div>
	<div class="goBuy">
		<% if isApp=1 then %>
			<a href="" onclick="fnAPPpopupProduct('1307015'); return false;" class="mLink ma">구매하러 가기</a>
		<% else %>
			<a href="/category/category_itemprd.asp?itemid=1307015" target="_blank" class="mLink mw">구매하러 가기</a>
		<% end if %>
		<img src="http://webimage.10x10.co.kr/playmo/ground/20150629/btn_go_buy.gif" alt="구매하러 가기" />
	</div>
	<div>
		<% if isApp=1 then %>
			<a href="" onclick="fnAPPpopupProduct('1307015'); return false;" class="mLink ma"><img src="http://webimage.10x10.co.kr/playmo/ground/20150629/img_night_clothes01.jpg" alt="잠옷 이미지" /></a>
		<% else %>
			<a href="/category/category_itemprd.asp?itemid=1307015" target="_blank" class="mLink mw"><img src="http://webimage.10x10.co.kr/playmo/ground/20150629/img_night_clothes01.jpg" alt="잠옷 이미지" /></a>
		<% end if %>
	</div>
	<div class="brandStory">
		<% if isApp=1 then %>
			<a href="" onclick="fnAPPpopupBrand('ithinkso'); return false;" class="mLink ma">브랜드 바로가기</a>
		<% else %>
			<a href="/street/street_brand.asp?makerid=ithinkso" target="_blank" class="mLink mw">브랜드 바로가기</a>
		<% end if %>

		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150629/txt_brand_story.gif" alt="ABOUT ithinkso" /></p>
	</div>
	<div>
		<% if isApp=1 then %>
			<a href="" onclick="fnAPPpopupProduct('1307015'); return false;" class="mLink ma"><img src="http://webimage.10x10.co.kr/playmo/ground/20150629/img_night_clothes02.jpg" alt="잠옷 이미지" /></a>
		<% else %>
			<a href="/category/category_itemprd.asp?itemid=1307015" target="_blank" class="mLink mw"><img src="http://webimage.10x10.co.kr/playmo/ground/20150629/img_night_clothes02.jpg" alt="잠옷 이미지" /></a>
		<% end if %>
	</div>
	<% '<!-- 문구 작성 --> %>
	<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
	<input type="hidden" name="mode" value="add">
	<input type="hidden" name="iCC" value="1">
	<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
	<input type="hidden" name="userid" value="<%= userid %>">
	<input type="hidden" name="eventid" value="<%= eCode %>">
	<input type="hidden" name="linkevt" value="<%= eCode %>">
	<input type="hidden" name="blnB" value="<%= blnBlogURL %>">
	<input type="hidden" name="vreload" value="ON">
	<input type="hidden" name="txtcomm">
	<div class="specialEvent">
		<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20150629/tit_special_event.gif" alt="SPECIAL EVENT - 당신의 Nice Dream을 만들어 드립니다." /></h3>
		<div class="dreamCont">
			<div class="step">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150629/txt_step01.gif" alt="STEP01 - 당신이 원하는 컬러를 선택하세요." /></p>
				<div class="selectShirt">
					<div>
						<input type="radio" name="colorgubun" value="1" id="s01" />
						<label for="s01"><img src="http://webimage.10x10.co.kr/playmo/ground/20150629/img_select_shirt01.gif" alt="흰색 잠옷" /></label>
					</div>
					<div>
						<input type="radio" name="colorgubun" value="2" id="s02" />
						<label for="s02"><img src="http://webimage.10x10.co.kr/playmo/ground/20150629/img_select_shirt02.gif" alt="분홍색 잠옷" /></label>
					</div>
					<div>
						<input type="radio" name="colorgubun" value="3" id="s03" />
						<label for="s03"><img src="http://webimage.10x10.co.kr/playmo/ground/20150629/img_select_shirt03.gif" alt="연두색 잠옷" /></label>
					</div>
				</div>
			</div>
			<div class="step">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150629/txt_step02.gif" alt="STEP02 - 당신이 원하는 문구를 입력하세요." /></p>
				<div class="writeShirt">
					<div class="msg"><input type="text" name="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> value="<%IF NOT IsUserLoginOK THEN%><% '로그인 후 글을 남길 수 있습니다. %><% else %>여덟자까지 입력<%END IF%>" /></div>
					<p class="btnSubmit"><input type="image" onclick="jsSubmitComment(frmcom); return false;" src="http://webimage.10x10.co.kr/playmo/ground/20150629/btn_enter.gif" alt="입력하기" /></p>
					<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150629/txt_noti.gif" alt="원하는 문구는 캘리로 변환하여 티셔츠에 작업됩니다./ 작성하신 문구는 자수로 작업됩니다./티셔츠 사이즈는 고르실 수 없으며, FREE 사이즈 하나로만 만들어 집니다" /></p>
				</div>
			</div>
		</div>
	</div>
	</form>
	<form name="frmdelcom" method="post" action="/play/groundcnt/doEventSubscript64082.asp" style="margin:0px;">
	<input type="hidden" name="eventid" value="<%=eCode%>">
	<input type="hidden" name="bidx" value="<%=bidx%>">
	<input type="hidden" name="Cidx" value="">
	<input type="hidden" name="mode" value="del">
	<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
	</form>
	<% '<!--// 문구 작성 --> %>
	
	<% IF isArray(arrCList) THEN %>
		<% '<!-- 티셔츠 리스트 --> %>
		<div class="shirtList" id="shirtList">
			<ul>
				<% '<!-- 티셔츠 선택에 따라 클래스 shirt01~03붙여주세요 / 리스트는 6개씩 노출됩니다. --> %>
				<%
				dim tmpcolorgubun , colorgubun, txtval
				dim rndNo : rndNo = 1
				
				For intCLoop = 0 To UBound(arrCList,2)
				
				randomize
				rndNo = Int((4 * Rnd) + 1)
				
				tmpcolorgubun = ""
				colorgubun = 1
				txtval=""
				tmpcolorgubun = split( arrCList(1,intCLoop) ,"!@#")
				if isarray(tmpcolorgubun) then
					colorgubun = tmpcolorgubun(0)

					if ubound(tmpcolorgubun) > 0 then
						txtval = tmpcolorgubun(1)
					end if
				end if
				'response.write arrCList(1,intCLoop)
				%>
				<li class="shirt0<%= colorgubun %>">
					<p class="msg">
						<span><%=ReplaceBracket(db2html( txtval ))%></span>
						<img src="http://webimage.10x10.co.kr/playmo/ground/20150629/bg_cmt.png" alt="" />
					</p>
					<p class="num">NO.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%></p>
					<p class="writer">
						<%=printUserId(arrCList(2,intCLoop),2,"*")%>
						
						<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
							 <span class="button btS2 btWht cBk1"><a href="" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');return false;">삭제</a></span>
						<% end if %>
					</p>
				</li>
				<%
				Next
				%>
			</ul>

			<% IF isArray(arrCList) THEN %>
				<div class="paging">
					<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
				</div>
			<% end if %>
		</div>
		<% '<!--// 티셔츠 리스트 --> %>
	<% end if %>
</div>
<!-- // #4 NICE DREAM -->

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->