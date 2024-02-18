<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#########################################################
' Description :  2015 텐바이텐X 그랜드 민트 페스티벌 2015
' History : 2015.09.22 원승현 생성
'#########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim currenttime
	currenttime =  now()
	'currenttime = #04/22/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  64895
Else
	eCode   =  66367
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
.mEvt66367 {background:#97f2e6 url(http://webimage.10x10.co.kr/eventIMG/2015/66367/m/bg_pattern.png) repeat-y 50% 0; background-size:100% auto;}
.topic p {visibility:hidden; width:0; height:0;}

.item .noti {visibility:hidden; width:0; height:0;}
.item {position:relative;}
.item ul {overflow:hidden; position:absolute; top:3%; left:50%; width:90%; margin-left:-45%;}
.item ul li {float:left; width:50%; margin-bottom:4.3%; padding:0 3%;}
.item ul li a {overflow:hidden; display:block; position:relative; height:0; padding-bottom:130.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.item ul li span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}

.about {position:relative;}
.about .btnLineup {position:absolute; bottom:10%; left:50%; width:75%; margin-left:-37.5%;}

.form legend {visibility:hidden; width:0; height:0;}
.form .field ul {overflow:hidden; padding:0 11%;}
.form .field ul li {float:left; width:50%; padding:0 6%; text-align:center;}
.form .field ul li label {display:block; margin-bottom:3%;}
.form .field ul li input {width:18px; height:18px; border-radius:50%;}
.form .field ul li input[type=radio]:checked {background:#fff url(http://webimage.10x10.co.kr/eventIMG/2015/66367/m/bg_element_radio.png) no-repeat 50% 50%; background-size:8px 8px;}
.form .itext {position:relative; margin:7% 4.218% 5%; padding-right:81px; }
.form .itext textarea {width:100%; height:87px; padding:15px; border:0; border-radius:0; border-top-left-radius:8px; border-bottom-left-radius:8px; color:#0039a1; font-size:12px;}
.form .itext .btnsubmit {position:absolute; top:0; right:0; width:76px;}

.form .desc {width:90.625%; margin:0 auto;}
.form .desc .shareSns {position:relative;}
.form .desc .shareSns ul {overflow:hidden; position:absolute; top:20%; right:2%; width:33%;}
.form .desc .shareSns ul li {float:left; width:33.333%;}
.form .desc .shareSns ul li a {overflow:hidden; display:block; position:relative; height:0; margin:0 3%; padding-bottom:110.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.form .desc .shareSns ul li a span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}
.form .desc .noti {padding:6% 0 7%;}
.form .desc .noti ul li {visibility:hidden; width:0; height:0;}

.commentlistwrap {padding:5% 0 10%;}
.commentlist .col {width:91.09%; margin:0 auto 15px; padding:15px 12px; border-radius:8px;}
.commentlist .col1 {background-color:#28c6ee;}
.commentlist .col2 {background-color:#47ce41;}
.commentlist .col .info {position:relative; font-size:11px; font-weight:bold;}
.commentlist .col .info .no {display:inline-block; width:92px; height:22px; padding-top:1px; border-radius:20px; line-height:22px; text-align:center;}
.commentlist .col .info .btndel {display:inline-block; position:relative; width:48px; height:22px; padding-top:1px; padding-right:10px; border-radius:20px; background-color:#747474; color:#fff; font-size:11px; line-height:22px; text-align:center; vertical-align:top;}
.commentlist .col .info .btndel span {position:absolute; top:6px; right:10px; width:1px; height:10px; background-color:#fff; transform:rotate(45deg); -webkit-transform:rotate(45deg);}
.commentlist .col .info .btndel span i {position:absolute; top:0; right:0; width:1px; height:10px; background-color:#fff; transform:rotate(90deg); -webkit-transform:rotate(90deg);}

.commentlist .col .info .id {position:absolute; top:0; right:0; color:#004b15;}
.commentlist .col .msg {margin-top:7px; color:#000; font-size:12px; line-height:1.5em;}
.commentlist .col1 .info .no {background-color:#0e79bd; color:#fff;}
.commentlist .col1 .info .id span {color:#0e79bd;}
.commentlist .col2 .info .no {background-color:#007120; color:#a3f44d;}
.commentlist .col2 .info .id span {color:#007f24;}

.paging span.arrow {border:1px solid #81d2c7; background-color:#81d2c7;}
.paging span {border:1px solid #81d2c7;}

@media all and (min-width:480px){
	.form .itext {padding-right:120px;}
	.form .itext textarea {height:132px; padding:25px; font-size:18px;}
	.form .itext .btnsubmit {width:114px;}

	.commentlist .col {margin-bottom:22px; padding:22px 18px;}
	.commentlist .col .info {font-size:16px;}
	.commentlist .col .info .no {width:138px; height:33px; line-height:33px;}
	.commentlist .col .info .btndel {width:72px; height:33px; font-size:16px; line-height:33px;}
	.commentlist .col .info .btndel span {top:9px; right:15px; height:16px;}
	.commentlist .col .info .btndel span i {height:16px;}
	.commentlist .col .msg {margin-top:12px; font-size:18px;}
}
</style>
<script type='text/javascript'>

$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$(".ma").show();
		$(".mw").hide();
	}else{
		$(".ma").hide();
		$(".mw").show();
	}

	<% if Request("iCC") <> "" or request("ecc") <> "" then %>
		$(function(){
			var val = $('.commentlistwrap').offset();
			window.$('html,body').animate({scrollTop:$(".commentlistwrap").offset().top-100}, 10);
		});
	<% end if %>
});

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}


function jsSubmitComment(frm){      //코멘트 입력
	<% If IsUserLoginOK() Then %>
		<% If Now() > #10/07/2015 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If left(now(), 10)>="2015-09-22" and left(now(), 10) < "2015-10-08" Then %>
				<% if commentcount >= 5 then %>
					alert("이벤트는 총 5회까지만 응모하실 수 있습니다.\n10월 8일(목) 당첨자 발표를 기다려 주세요!");
					return;				
				<% else %>
					var tmpdateval='';
					for (var i=0; i < frm.dateval.length; i++){
						if (frm.dateval[i].checked){
							tmpdateval = frm.dateval[i].value;
						}
					}
					if (tmpdateval==''){
						alert('원하시는 관람날짜를 선택해 주세요.');
						return false;
					}
					if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 600 || frm.txtcomm1.value == '가장 기대되는 아티스트와 페스티벌에 대한 기대평을 남겨주세요.'){
						alert("가장 기대되는 아티스트와 페스티벌에 대한\n기대평을 남겨주세요. 600자 까지 작성 가능합니다.");
						frm.txtcomm1.focus();
						return false;
					}
				   frm.txtcomm.value = tmpdateval + "|!/" +frm.txtcomm1.value
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

	if (frmcom.txtcomm1.value == '가장 기대되는 아티스트와 페스티벌에 대한 기대평을 남겨주세요.'){
		frmcom.txtcomm1.value = '';
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
	snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=" & ecode)
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
	}else if(str=="ka"){
		<% if isApp="1" then %>
			parent_kakaolink('[텐바이텐] 텐바이텐x그랜드 민트 페스티벌 2015\n가을날 음악 피크닉, 반가운 우리들의 만남!' , 'http://webimage.10x10.co.kr/eventIMG/2015/66367/m/img_kakao.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=66367' );
		<% else %>
			parent_kakaolink('[텐바이텐] 텐바이텐x그랜드 민트 페스티벌 2015\n가을날 음악 피크닉, 반가운 우리들의 만남!' , 'http://webimage.10x10.co.kr/eventIMG/2015/66367/m/img_kakao.jpg' , '200' , '200' , 'http://m.10x10.co.kr/event/eventmain.asp?eventid=66367' );
		<% end if %>
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}


</script>

<%' GMF %>
<div class="mEvt66367">
	<div class="topic">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/66367/m/tit_gmf.png" alt="가을날 음악 피크닉 반가운 우리들의 만남" /></h2>
		<p>공식 굿즈 온라인 사전 판매 : 09. 23 ~ 10. 11 한정수량으로 조기소진 될 수 있습니다.</p>
	</div>

	<%' item %>
	<div class="item">
		<ul>
			<li>
				<% If isApp="1" Then %>
					<a href="" onclick="fnAPPpopupProduct('1339101');return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1339101" target="_blank">
				<% End If %>
				<span></span>피크닉 매트</a>
			</li>
			<li>
				<% If isApp="1" Then %>
					<a href="" onclick="fnAPPpopupProduct('1339100');return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1339100" target="_blank">
				<% End If %>
				<span></span>반팔 티셔츠</a>
			</li>
			<li>
				<% If isApp="1" Then %>
					<a href="" onclick="fnAPPpopupProduct('1339102');return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1339102" target="_blank">
				<% End If %>
				<span></span>에코백</a>
			</li>
			<li>
				<% If isApp="1" Then %>
					<a href="" onclick="fnAPPpopupProduct('1339103');return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1339103" target="_blank">
				<% End If %>
				<span></span>미니 사이드 백</a>
			</li>
			<li>
				<% If isApp="1" Then %>
					<a href="" onclick="fnAPPpopupProduct('1339107');return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1339107" target="_blank">
				<% End If %>
				<span></span>핀버튼</a>
			</li>
			<li>
				<% If isApp="1" Then %>
					<a href="" onclick="fnAPPpopupProduct('1339106');return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1339106" target="_blank">
				<% End If %>
				<span></span>타투 스티커</a>
			</li>
			<li>
				<% If isApp="1" Then %>
					<a href="" onclick="fnAPPpopupProduct('1339104');return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1339104" target="_blank">
				<% End If %>
				<span></span>투명 텀블러</a>
			</li>
			<li>
				<% If isApp="1" Then %>
					<a href="" onclick="fnAPPpopupProduct('1339105');return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1339105" target="_blank">
				<% End If %>
				<span></span>패브릭 팔찌</a>
			</li>
		</ul>
		<ul class="noti">
			<li>* 공식 굿즈는 한정수량이므로 조기소진될 수 있습니다.</li>
			<li>* 온라인에서 판매가 중단되더라도 페스티벌 현장에서 소량 판매가 됩니다.</li>
			<li>* 판매가격은 각 상품별 1개에 해당하는 금액입니다. (옵션 선택)</li>
		</ul>
		<img src="http://webimage.10x10.co.kr/eventIMG/2015/66367/m/img_item_01.jpg" alt="" />
		<img src="http://webimage.10x10.co.kr/eventIMG/2015/66367/m/img_item_02.jpg" alt="" />
	</div>

	<div class="about">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66367/m/txt_about.png" alt="올해로 아홉 번째 해를 맞는 그랜드 민트 페스티벌! GMF2015의 키워드는 익숙함과 새로움 사이의 도전과 확장입니다. 도시적인 세련됨과 청량함의 여유, 가을에 만나는 음악 피크닉, 환경과 사람 사이의 조화, 아티스트에 대한 존중, 비슷한 주파수의 취향들, 그리고 민트 페이퍼의 1년 결산이자 대잔치 계절의 남은 온기와 색깔까지 배경이 되는 이틀간의 현상, 그랜드 민트 페스티벌 2015" /></p>
		<a href="https://www.mintpaper.co.kr/2015/09/hotline-gmf2015-lineup-final/" target="_blank" class="btnLineup"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66367/m/btn_line_up.png" alt="GMF2015 라인업 보기" /></a>
	</div>

	<%' form %>
	<div class="commentevt">
		<%' for dev msg : 폼 %>
		<div class="form">
			<div class="field">
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
				<input type="hidden" name="txtcomm">
					<fieldset>
					<legend>그랜드 민트 페스티벌 기대평 남기고 티켓 응모하기</legend>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66367/m/txt_comment.png" alt="텐바이텐의 오랜 친구, 그랜드 민트 페스티벌! 이번 GMF2015에서 가장 기대되는 아티스트와 페스티벌에 대한 기대평을 남겨주세요. 정성껏 코멘트를 남겨주신 20분을 추첨을 통해 페스티벌 1일권 티켓 1인 1매를 선물로 드립니다." /></p>
						<ul>
							<li>
								<label for="date01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66367/m/txt_label_date_01.png" alt="2015년 10월 17일 토요일" /></label>
								<input type="radio" id="date01" name="dateval" value="1" />
							</li>
							<li>
								<label for="date02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66367/m/txt_label_date_02.png" alt="2015년 10월 18일 일요일" /></label>
								<input type="radio" id="date02" name="dateval" value="2" />
							</li>
						</ul>
						<div class="itext">
							<textarea title="가장 기대되는 아티스트와 페스티벌에 대한 기대평을 남겨주세요." cols="60" rows="5" name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%>><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>가장 기대되는 아티스트와 페스티벌에 대한 기대평을 남겨주세요.<%END IF%></textarea>
							<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/66367/m/btn_submit.png" alt="응모하기" class="btnsubmit" onclick="jsSubmitComment(frmcom); return false;" />
						</div>
					</fieldset>
				</form>
			</div>

			<div class="desc">
				<div class="shareSns">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66367/m/txt_sns.png" alt="친구에게도 텐바이텐과 GMF2015의 만남을 알려주세요! 당첨 확률이 UP! UP!" /></p>
					<%' for dev msg : sns %>
					<ul>
						<li><a href="" onclick="getsnscnt('fb'); return false;"><span></span>페이스북</a></li>
						<li><a href="" onclick="getsnscnt('tw'); return false;"><span></span>트위터</a></li>
						<li><a href="" onclick="getsnscnt('ka'); return false;" ><span></span>카카오톡</a></li>
					</ul>
				</div>
				<div class="noti">
					<ul>
						<li>* 코멘트 이벤트는 2015년 10월 7일 수요일에 종료, 10월 8일 목요일에 당첨자를 발표합니다.</li>
						<li>* 비방성 댓글 및 타인의 댓글을 그대로 옮겨쓴 댓글은 통보없이 자동삭제 됩니다.</li>
						<li>* 당첨자 1명에게는 1매의 티켓이 제공되며, 발표 후 개인정보를 요청하게 될 수 있습니다.</li>
						<li>* 초대권의 양도 및 재판매는 불가하며, 확인 시 취소조치됩니다.</li>
					</ul>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/66367/m/txt_noti.png" alt="" />
				</div>
			</div>
		</div>
	</div>

	<%' comment list %>
	<% IF isArray(arrCList) THEN %>
	<div class="commentlistwrap">
		<div class="commentlist">
			<%' for dev msg : <div class="col">...</div>이 한 묶음입니다. 토요일, 일요일 선택에 따라 배경 넣어주세요 col1 ~ col2 %>
			<%' for dev msg : 한페이지당 8개 %>
			<%
				dim rndNo : rndNo = 1
				
				For intCLoop = 0 To UBound(arrCList,2)

				
				if isarray(split(arrCList(1,intCLoop),"|!/")) Then
					if ubound(split(arrCList(1,intCLoop),"|!/")) > 0 then
						rndNo = ReplaceBracket(db2html( split(arrCList(1,intCLoop),"|!/")(0) ))
					End If
				End If

			%>
				<div class="col col<%=rndNo%>">
					<div class="info">
						<strong class="no"><%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%>번째 설렘</strong><% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %> <button type="button" class="btndel" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');return false;">삭제<span><i></i></span></button><% End If %>
						<span class="id"><%=printUserId(arrCList(2,intCLoop),2,"*")%> <span><%=Mid(arrCList(4,intCLoop), 6, 2)&"."&Mid(arrCList(4,intCLoop), 9, 2)%></span></span>
					</div>
					<p class="msg">
						<% if isarray(split(arrCList(1,intCLoop),"|!/")) then %>
							<% if ubound(split(arrCList(1,intCLoop),"|!/")) > 0 then %>
								<%=ReplaceBracket(db2html( split(arrCList(1,intCLoop),"|!/")(1) ))%>
							<% end if %>
						<% end if %>
					</p>
				</div>
			<% next %>
		</div>

		<%' paging %>
		<div class="paging">
			<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
		</div>
	</div>
	<% End If %>
	<form name="frmdelcom" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
	<input type="hidden" name="mode" value="del">
	<input type="hidden" name="pagereload" value="ON">
	<input type="hidden" name="Cidx" value="">
	<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&ecc=1">
	<input type="hidden" name="userid" value="<%= userid %>">
	<input type="hidden" name="eventid" value="<%= eCode %>">
	<input type="hidden" name="linkevt" value="<%= eCode %>">
	</form>
</div>
<!-- //GMF -->

<!-- #include virtual="/lib/db/dbclose.asp" -->