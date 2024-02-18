<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  BML 에서 만나요!
' History : 2015.04.21 한용민 생성
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
dim currenttime
	currenttime =  now()
	'currenttime = #04/22/2015 09:00:00#

dim eCode, eCodedisp
IF application("Svr_Info") = "Dev" THEN
	eCode   =  61758
	eCodedisp = 61759
Else
	eCode   =  61601
	eCodedisp = 61602
End If

dim userid, commentcount, i
	userid = getloginuserid()

commentcount = getcommentexistscount(userid, eCode, "", "", "", "")

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
.mEvt61602 {padding-bottom:8%; background-color:#fff;}
.mEvt61602 .topic p {visibility:hidden; width:0; height:0;}
.item1 {padding:5.5% 2.8% 7%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/61602/bg_pattern.png) repeat-y 50% 0; background-size:100% auto;}
.item1 ul {overflow:hidden; margin-bottom:3%;}
.item1 ul li {float:left; width:50%; margin-bottom:1.3%;}
.item1 ul li:first-child {float:none; width:100%;}
.item1 ul li:nth-child(2) a {display:block; margin-right:1.2%;}
.item1 ul li:nth-child(3) a {display:block; margin-left:1.2%;}
.commentevt {padding-bottom:7%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/61602/bg_paper.png) repeat-y 50% 0; background-size:100% auto;}
.commentevt ul {overflow:hidden; padding:5% 2.5% 0;}
.commentevt ul li {float:left; position:relative; width:50%; padding:0 0.5%;}
.commentevt ul li input {position:absolute; top:-18%; left:50%; margin-left:-10px; border-radius:50%;}
.commentevt ul li input:checked {background:#fff url(http://webimage.10x10.co.kr/eventIMG/2015/61602/bg_radio.png) no-repeat 50% 50%; background-size:10px 10px;}

.commentevt .texarea {overflow:hidden; display:block; position:relative; height:0; margin:2% 3% 0; padding-bottom:21.75%;}
.commentevt .texarea textarea {position:absolute; top:0; left:0; width:100%; height:100%; border:0; background:url(http://webimage.10x10.co.kr/eventIMG/2015/61602/bg_box.png) no-repeat 50% 0; background-size:100% auto;}
.commentevt .btnsubmit {margin:1.8% 3% 0;}

.commentlist {overflow:hidden; padding:3% 2% 1%;}
.commentlist .col {overflow:hidden; float:left; position:relative; width:48%; height:0;  margin:1% 1% 0; padding-bottom:53%; text-align:center;}
.commentlist .col .bg {position:absolute; top:0; left:0; width:100%; height:100%; background-repeat:no-repeat; background-size:100% auto;}
.commentlist .col1 .bg {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/61602/bg_comment_box_01.png); color:#4da788;}
.commentlist .col2 .bg {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/61602/bg_comment_box_02.png); color:#ed7f63;}
.commentlist .col .inner {overflow:auto; height:52%; margin-top:28%; margin-right:3%;  padding:0 10%; -webkit-overflow-scrolling:touch;}
.commentlist .col .writer {margin-top:5%; font-size:11px; line-height:1.375em;}
.commentlist .col .writer img {width:7px; margin-left:5px; vertical-align:middle;}
.commentlist .col .no {display:block; font-size:11px;}
.commentlist .col .msg {margin-top:7%; font-size:11px; line-height:1.5em;}
.commentlist .col .btndel {width:14px; height:14px; margin-left:5px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/60281/btn_del.png) no-repeat 50% 0; background-size:100% auto; text-indent:-999em; vertical-align:middle;}

@media all and (min-width:480px){
	.commentevt ul li input:checked {background-size:15px 15px;}
	.commentlist .col .msg {font-size:16px;}
	.commentlist .col .no {font-size:16px;}
	.commentlist .col .writer {font-size:16px;}
	.commentlist .col .writer img {width:9px;}
	.commentlist .col .btndel {width:18px; height:18px;}
}
</style>
<script type="text/javascript">

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-04-22" and left(currenttime,10)<"2015-04-28" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>0 then %>
				alert("이벤트는 1회만 응모하실수 있습니다.\n4월30일(목) 당첨자 발표를 기다려 주세요!");
				return false;
			<% else %>
				var tmpdateval='';
				for (var i=0; i < frm.dateval.length; i++){
					if (frm.dateval[i].checked){
						tmpdateval = frm.dateval[i].value;
					}
				}
				if (tmpdateval==''){
					alert('관람을원하는 날짜를 선택해 주세요.');
					return false;
				}
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 600 || frm.txtcomm1.value == '600자 이내로 입력해주세요'){
					alert("BML2015에 대한 기대평을 남겨주세요.\n600자 까지 작성 가능합니다.");
					frm.txtcomm1.focus();
					return false;
				}

			   frm.txtcomm.value = tmpdateval + "|!/" +frm.txtcomm1.value
			   frm.action = "/event/lib/doEventComment.asp";
			   frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCodedisp)%>');
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
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCodedisp)%>');
			return false;
		<% end if %>
		return false;
	}

	if (frmcom.txtcomm1.value == '600자 이내로 입력해주세요'){
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

<!-- iframe -->
<div class="mEvt61602">
	<div class="topic">
		<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/61602/tit_bml.png" alt="BML 2015 공식 MD 텐바이텐 BML에서 만나요!" /></h1>
		<p>예약판매 기간은 4월 22일부터 4월 27일까지며, 사전 예약판매 10% 상품배송은 2015년 4월 28일(월)부터 결제완료 기준으로 순차 배송됩니다.</p>
	</div>

	<div class="item1">
		<ul>
			<% if isApp=1 then %>
				<li><a href="" onclick="parent.fnAPPpopupProduct('1255572'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61602/img_item_01.png" alt="자수 티셔츠" /></a></li>
				<li><a href="" onclick="parent.fnAPPpopupProduct('1255573'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61602/img_item_02.png" alt="기타피크 세트" /></a></li>
				<li><a href="" onclick="parent.fnAPPpopupProduct('1255574'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61602/img_item_03.png" alt="핀 버튼" /></a></li>
			<% else %>
				<li><a href="/category/category_itemPrd.asp?itemid=1255572" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61602/img_item_01.png" alt="자수 티셔츠" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1255573" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61602/img_item_02.png" alt="기타피크 세트" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1255574" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61602/img_item_03.png" alt="핀 버튼" /></a></li>
			<% end if %>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61602/txt_gift.png" alt="BML 2015 상품으로 20,000원 이상 구매하신 고객님에게는 GMF2014 기타피크 세트를 선물로 드립니다. 100개 한정이며 선착순으로 증정합니다." /></p>
	</div>

	<div class="item2">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/61602/tit_lucky_bag.png" alt="럭키 텐바이텐 백" /></h2>
		<ul>
			<% if isApp=1 then %>
				<li><a href="" onclick="parent.fnAPPpopupProduct('1255576'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61602/img_item_04_v1.jpg" alt="2만원의 행복 에코백 + 마나퍄투 + 손수건 + 핀버튼" /></a></li>
				<li><a href="" onclick="parent.fnAPPpopupProduct('1255575'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61602/img_item_05.jpg" alt="1만원의 기쁨 파우치 + 기타피크 세트 + 미니거울" /></a></li>
			<% else %>
				<li><a href="/category/category_itemPrd.asp?itemid=1255576" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61602/img_item_04_v1.jpg" alt="2만원의 행복 에코백 + 마나퍄투 + 손수건 + 핀버튼" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1255575" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61602/img_item_05.jpg" alt="1만원의 기쁨 파우치 + 기타피크 세트 + 미니거울" /></a></li>
			<% end if %>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61602/txt_bml_2015.png" alt="BML 2015 뷰티풀 민트 라이프는 민트페이퍼가 개최하는 봄날의 음악 페스티벌입니다. 봄에는 뷰티풀 민트 라이프, 가을에는 그랜드 민트 페스티벌이 열리고 있습니다. 다양한 아티스트들과 팬들이 만나 음악을 나누고, 소통하는 페스티벌로 거듭나고 있습니다." /></p>
	</div>

	<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
	<input type="hidden" name="mode" value="add">
	<input type="hidden" name="iCC" value="1">
	<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
	<input type="hidden" name="userid" value="<%= userid %>">
	<input type="hidden" name="eventid" value="<%= eCodedisp %>">
	<input type="hidden" name="linkevt" value="<%= eCode %>">
	<input type="hidden" name="blnB" value="<%= blnBlogURL %>">
	<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCodedisp %>">
	<input type="hidden" name="txtcomm">
	<!-- comment write -->
	<div class="commentevt">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61602/txt_comment_event.png" alt="봄날의 축제 BML2015! 가고 싶은 날짜와 함께 기대평을 남겨주세요. 추첨을 통해 2분에게는 원하는 날짜의 BML2015티켓 1일권 2매를 선물로 드립니다. 코멘트 작성기간은 2015년 4월 22일부터 27일까지며 당첨자 발표는 4월 27일 화요일 입니다." /></p>
		<ul>
			<li>
				<label for="selectDate01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61602/txt_label_date_01.png" alt="2015년 5월 2일 토요일" /></label>
				<input type="radio" name="dateval" value="1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" id="selectDate01" />
			</li>
			<li>
				<label for="selectDate02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61602/txt_label_date_02.png" alt="2015년 5월 3일 일요일" /></label>
				<input type="radio" name="dateval" value="2" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" id="selectDate02" name="" />
			</li>
		</ul>
		<div class="texarea">
			<textarea name="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> cols="60" rows="5" title="BML2015 가장 기대되는 아티스트와 함께 기대평 쓰기"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>600자 이내로 입력해주세요<%END IF%></textarea>
		</div>
		<div class="btnsubmit"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61602/btn_submit.png" onclick="jsSubmitComment(frmcom); return false;" alt="기대평 남기기" /></div>
	</div>
	</form>

	<!-- comment list -->
	<div class="commentlist">
		<%
		IF isArray(arrCList) THEN
			dim rndNo : rndNo = 1
			
			For intCLoop = 0 To UBound(arrCList,2)
			
			randomize
			rndNo = Int((2 * Rnd) + 1)
		%>
		<% '<!-- for dev msg : <div class="col">...</div>이 한 묶음입니다. col1 ~ col2 랜덤으로 클래스명 뿌려주세요 --> %>
		<% '<!-- for dev msg : 한페이지당 6개 --> %>
		<div class="col col<%=rndNo%>">
			<div class="bg">
				<div class="inner">
					<strong class="no">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%></strong>
					<p class="msg">
						<% if isarray(split(arrCList(1,intCLoop),"|!/")) then %>
							<% if ubound(split(arrCList(1,intCLoop),"|!/")) > 0 then %>
								<%=ReplaceBracket(db2html( split(arrCList(1,intCLoop),"|!/")(1) ))%>
							<% end if %>
						<% end if %>						
					</p>
				</div>
				<div class="writer">
					<span class="id"><%=printUserId(arrCList(2,intCLoop),2,"*")%></span>
					
					<% If arrCList(8,i) <> "W" Then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/60280/ico_mobile.png" alt="모바일에서 작성" width="7" />
					<% end if %>
					
					<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
						<button type="button" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');return false;" class="btndel">삭제</button>
					<% end if %>
				</div>
			</div>
		</div>
		<%
			Next
		end if
		%>
	</div>

	<% IF isArray(arrCList) THEN %>
		<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
	<% end if %>
	<!-- paging -->
	<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
	<input type="hidden" name="mode" value="del">
	<input type="hidden" name="Cidx" value="">
	<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCodedisp %>">
	<input type="hidden" name="userid" value="<%= userid %>">
	<input type="hidden" name="eventid" value="<%= eCodedisp %>">
	<input type="hidden" name="linkevt" value="<%= eCode %>">
	</form>
</div>

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->