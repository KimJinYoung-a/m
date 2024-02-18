<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  play box
' History : 2015.05.08 한용민 생성
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
	'currenttime = #05/11/2015 09:00:00#

dim eCode, eCodedisp
IF application("Svr_Info") = "Dev" THEN
	eCode   =  61784
	eCodedisp = 61784
Else
	eCode   =  62113
	eCodedisp = 62113
End If

dim userid, i
	userid = getloginuserid()

dim commentcount
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
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {width:100%; vertical-align:top;}
.commentEvt {padding:7% 4.5%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/62113/62113_bg1.png) no-repeat 0 0; background-size:100%; text-align:center;}
.commentEvt time {text-align:center; font-size:24px; color:#000; font-family:verdana, tahoma, sans-serif; text-decoration:underline; line-height:1.25em; letter-spacing:-2px;}
.commentEvt legend {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
.recommendWrap {overflow:hidden;}
.recommendWrap .label {float:left; width:30%; text-align:left;}
.recommendWrap .label img {width:80%;}
.recommendWrap .itext {float:left; width:70%;}
.recommendWrap .itext input[type=text] {width:100%; font-size:18px; height:33px; margin-bottom:4%; border-radius:0; -webkit-border-radius:0; border:0;}
.field {padding-top:5%;}
.field input[type=image] {width:100%; }
.commentList {background:url(http://webimage.10x10.co.kr/eventIMG/2015/62113/62113_bg2.png) repeat-y 0 0; background-size:100%; padding-bottom:30px;}
.commentList ul {overflow:hidden; padding:30px 10px 0;}
.commentList ul li {float:left; position:relative; width:50%; min-height:235px; margin-top:10px; padding:0 20px; text-align:center;}
.commentList ul li span, .commentList ul li strong, .commentList ul li em {display:block;}
.commentList ul li .song, .commentList ul li .date {line-height:1.25em;}
.commentList ul li .now {margin-top:17px; color:#29a57e; font-size:13px; line-height:1.25em;}
.commentList ul li .now, .commentList ul li .song {overflow:hidden; width:90%; margin:0 auto; text-overflow:ellipsis; white-space:nowrap;}
.commentList ul li .now {margin-top:17px;}
.commentList ul li .song, .commentList ul li .singer {margin-top:2px; color:#333; font-size:13px;}
.commentList ul li .date {margin-top:5px; color:#888; font-size:12px;}
.commentList ul li .date img {width:9px; margin-right:5px; vertical-align:middle;}
.commentList ul li .btnDel {position:absolute; right:20%; top:0; width:27px; height:27px; background:url(http://webimage.10x10.co.kr/playmo/ground/20141110/btn_del.png) no-repeat 0 0; background-size:27px 27px; text-indent:-999em;}
.commentList .paging {margin-top:20px;}
.mEvt62113 .evtNoti {padding:20px 10px; background:#f4f7f7;}
.mEvt62113 .evtNoti dt {display:inline-block; font-size:14px; font-weight:bold; color:#222; padding-bottom:1px; margin-bottom:13px; border-bottom:2px solid #222;}
.mEvt62113 .evtNoti li {position:relative; color:#444; font-size:11px; line-height:1.4; padding-left:11px; letter-spacing:-0.035em;}
.mEvt62113 .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:5px; width:4px; height:4px; border-radius:50%; -webkit-border-radius:50%; background-color:#4fc1be;}
@media all and (min-width:360px){.recommendWrap .label img {width:70%;}}
@media all and (min-width:480px){
	.commentEvt time {font-size:36px;}
	.recommendWrap .label img {width:59%;}
	.recommendWrap .itext input[type=text] {font-size:27px; height:44px; margin-bottom:3.5%;}
	.commentList {padding-bottom:45px;}
	.commentList ul li {min-height:410px; margin-top:25px; padding:0 30px;}
	.commentList ul li .now {font-size:20px;}
	.commentList ul li .song, .commentList ul li .singer {margin-top:3px; font-size:20px;}
	.commentList ul li .now {margin-top:25px;}
	.commentList ul li .date {margin-top:8px; font-size:18px;}
	.commentList ul li .btnDel {width:40px; height:40px; background-size:40px 40px;}
	.commentList .paging {margin-top:30px;}
	.mEvt62113 .evtNoti {padding:30px 20px;}
	.mEvt62113 .evtNoti dt {font-size:21px; margin-bottom:20px; border-bottom:3px solid #222;}
	.mEvt62113 .evtNoti li {font-size:17px; padding-left:17px;}
	.mEvt62113 .evtNoti li:after {top:7px; width:5px; height:5px;}
}
@media all and (min-width:766px){.recommendWrap .label img {width:47%;}}
</style>
<script type='text/javascript'>

var minus_second = 0;
var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
var today=new Date(<%=Year(now)%>, <%=Month(now)-1%>, <%=Day(now)%>, <%=Hour(now)%>, <%=Minute(now)%>, <%=Second(now)%>);

function countdown(){
	today = new Date(Date.parse(today) + (1000+minus_second));	//서버시간에 1초씩 증가
	var todayy=today.getYear()

	if(todayy < 1000)
		todayy+=1900
		

		var todaym=today.getMonth()
		var todayd=today.getDate()
		var todayh=today.getHours()
		var todaymin=today.getMinutes()
		var todaysec=today.getSeconds()
		var todaystring=montharray[todaym]+" "+todayd+", "+todayy+" "+todayh+":"+todaymin+":"+todaysec
		var apname = "";

		if(todayh < 0)
		{
			$("#lyrCounter").hide();
			return;
		}

		//am pm 설정
		if(todayh > 12 && todayh < 24 ) {
			apname = " pm"
			todayh = todayh - 12;
		}else{
			apname = " am"
		}

		if(todayh < 10) {
			todayh = "0" + todayh;
		}

		if(todaymin < 10) {
			todaymin = "0" + todaymin;
		}
		if(todaysec < 10) {
			todaysec = "0" + todaysec;
		}

		$("#lyrCounter").html(todayh + ' : ' + todaymin + ' : ' + todaysec + apname);

		minus_second = minus_second + 1;

	setTimeout("countdown()",1000)
}

$(function(){
	countdown();
});

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	if (frmcom.txtcomm1.value == '잠이 안 오는 이 순간'){
		frmcom.txtcomm1.value = '';
	}
	if (frmcom.txtcomm2.value == '브로콜리너마저'){
		frmcom.txtcomm2.value = '';
	}
	if (frmcom.txtcomm3.value == '보편적인 노래'){
		frmcom.txtcomm3.value = '';
	}	

	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-05-11" and left(currenttime,10)<"2015-05-21" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>5 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>

				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 50 || frm.txtcomm1.value == '50자 이내로 입력해주세요'){
					alert("코맨트를 남겨주세요.\n50자 까지 작성 가능합니다.");
					frm.txtcomm1.focus();
					return false;
				}
				if (frm.txtcomm2.value == '' || GetByteLength(frm.txtcomm2.value) > 50 || frm.txtcomm2.value == '50자 이내로 입력해주세요'){
					alert("코맨트를 남겨주세요.\n50자 까지 작성 가능합니다.");
					frm.txtcomm2.focus();
					return false;
				}
				if (frm.txtcomm3.value == '' || GetByteLength(frm.txtcomm3.value) > 50 || frm.txtcomm3.value == '50자 이내로 입력해주세요'){
					alert("코맨트를 남겨주세요.\n50자 까지 작성 가능합니다.");
					frm.txtcomm3.focus();
					return false;
				}

			   frm.txtcomm.value = frm.txtcomm1.value + "|!/" + frm.txtcomm2.value + "|!/" + frm.txtcomm3.value
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

	if (frmcom.txtcomm1.value == '잠이 안 오는 이 순간'){
		frmcom.txtcomm1.value = '';
	}
	if (frmcom.txtcomm2.value == '브로콜리너마저'){
		frmcom.txtcomm2.value = '';
	}
	if (frmcom.txtcomm3.value == '보편적인 노래'){
		frmcom.txtcomm3.value = '';
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

<div class="mEvt62113">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/62113/62113_tit.png" alt="PLAY BOX - 당신이 듣고 있는 노래를 추천해 주세요!" /></h2>

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
	<!-- comment event -->
	<div class="commentEvt">
		<time id="lyrCounter"></time><!-- 05 : 31 : 27 am -->
		<div class="field">
			<form action="">
				<fieldset>
					<legend>지금 이 순간 함께 듣고 싶은 노래 추천하기</legend>
					<div class="recommendWrap">
						<div class="label"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62113/62113_txt.png" alt="" /></div>
						<div class="itext">
							<input type="text" name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> title="나 지금" value="잠이 안 오는 이 순간" />
							<input type="text" name="txtcomm2" id="txtcomm2" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> title="이 가수" value="브로콜리너마저" />
							<input type="text" name="txtcomm3" id="txtcomm3" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> title="이 노래" value="보편적인 노래" />
							<div class="btnSubmit">
								<input type="image" onclick="jsSubmitComment(frmcom); return false;" src="http://webimage.10x10.co.kr/eventIMG/2015/62113/62113_btn.png" alt="추천해요" />
							</div>
						</div>
					</div>
				</fieldset>
			</form>
		</div>
	</div>
	</form>
	<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
	<input type="hidden" name="mode" value="del">
	<input type="hidden" name="Cidx" value="">
	<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCodedisp %>">
	<input type="hidden" name="userid" value="<%= userid %>">
	<input type="hidden" name="eventid" value="<%= eCodedisp %>">
	<input type="hidden" name="linkevt" value="<%= eCode %>">
	</form>

	<!-- comment list -->
	<div class="commentList">
		<ul>
			<%
			IF isArray(arrCList) THEN
				dim rndNo : rndNo = 1
				
				For intCLoop = 0 To UBound(arrCList,2)
				
				randomize
				rndNo = Int((12 * Rnd) + 1)
			%>
				<% '<!-- for dev msg : 한줄에 2개씩 한 페이지당 3줄 보여주세요 / 62113_album01.png부터 62113_album12.png까지 랜덤으로 보여주세요 --> %>
				<li>
					<span class="thumb"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62113/62113_album<%= Format00(2,rndNo) %>.png" alt="" /></span>
					<strong class="now">
						<% if isarray(split(arrCList(1,intCLoop),"|!/")) then %>
							<%=ReplaceBracket(db2html( split(arrCList(1,intCLoop),"|!/")(0) ))%>
						<% end if %>
					</strong>
					<em class="singer">
						<% if isarray(split(arrCList(1,intCLoop),"|!/")) then %>
							<% if ubound(split(arrCList(1,intCLoop),"|!/")) > 0 then %>
								<%=ReplaceBracket(db2html( split(arrCList(1,intCLoop),"|!/")(1) ))%>
							<% end if %>
						<% end if %>
					</em>
					<em class="song">
						<% if isarray(split(arrCList(1,intCLoop),"|!/")) then %>
							<% if ubound(split(arrCList(1,intCLoop),"|!/")) > 1 then %>
								<%=ReplaceBracket(db2html( split(arrCList(1,intCLoop),"|!/")(2) ))%>
							<% end if %>
						<% end if %>
					</em>
					<span class="date">
						<% If arrCList(8,i) <> "W" Then %>
							<img src="http://webimage.10x10.co.kr/playmo/ground/20141110/ico_mobile.gif" alt="모바일에서 작성된 글" /> 
						<% end if %>
						<%=printUserId(arrCList(2,intCLoop),2,"*")%> / <%=formatdate(arrCList(4,intCLoop),"00:00")%>
					</span>
					
					<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
						<button type="button" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');return false;" class="btnDel">삭제</button>
					<% end if %>
				</li>
			<%
				Next
			end if
			%>
		</ul>
	
		<% IF isArray(arrCList) THEN %>
			<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
		<% end if %>
	</div>

	<% if isApp=1 then %>
		<p>
			<a href="" onclick="parent.fnAPPpopupExternalBrowser('https://126908.api-04.com/serve?action=click&publisher_id=126908&site_id=83446&my_campaign=gru&my_keyword=10X10&site_id_ios=88148'); return false;">
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/62113/62113_bnr.png" alt="텐바이텐 플레이박스가 궁금하세요?! - 비트로 이동하기" /></a>
		</p>
	<% else %>
		<p>
			<a href="https://126908.api-04.com/serve?action=click&publisher_id=126908&site_id=83446&my_campaign=gru&my_keyword=10X10&site_id_ios=88148" target="_blank" >
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/62113/62113_bnr.png" alt="텐바이텐 플레이박스가 궁금하세요?! - 비트로 이동하기" /></a>
		</p>
	<% end if %>

	<dl class="evtNoti">
		<dt>이벤트 유의사항</dt>
		<dd>
			<ul>
				<li>당첨 된 추천곡은 5월 15일 오후 1시에 비트에서 확인 할 수 있습니다.</li>
				<li>이벤트 당첨 된 상품은 당첨자 확인 후 발송됩니다! 당첨자 확인 문자 이후 마이텐바이텐&gt;당첨안내&gt;배송지입력 부탁드립니다.</li>
				<li>당첨된 상품의 컬러는 랜덤으로 발송되며, 선택이 불가능합니다.</li>
			</ul>
		</dd>
	</dl>
</div>

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->