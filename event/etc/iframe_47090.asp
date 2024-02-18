<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<%
	dim eCode , sqlStr , sDate , eDate , i
	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21024"
	Else
		eCode 		= "47090"
	End If


	// 이벤트 기간 확인 //
	sqlStr = "Select evt_startdate, evt_enddate " &_
			" From db_event.dbo.tbl_event " &_
			" WHERE evt_code='" & eCode & "'"
	rsget.Open sqlStr,dbget,1
	if rsget.EOF or rsget.BOF then
		Response.Write	"<script>" &_
						"alert('존재하지 않는 이벤트입니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	elseif date<rsget("evt_startdate") or date>rsget("evt_enddate") then
		Response.Write	"<script>" &_
						"alert('죄송합니다. 이벤트 기간이 아닙니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	Else
		sDate =  rsget("evt_startdate")
		eDate =  rsget("evt_enddate")
	end If
	rsget.Close

	'response.write  eDate

	Dim dfDate : dfDate = #09/11/2013 12:0:0#  ''티저 종료 시간 유동적으로 처리 요

	dim com_egCode, bidx
	Dim cEComment
	Dim iCTotCnt, arrCList,intCLoop, iSelTotCnt
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt

	'파라미터값 받기 & 기본 변수 값 세팅
	iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	com_egCode = requestCheckVar(Request("eGC"),1)	'그룹 번호(엣지1, 초식2, 연하3)

	IF iCCurrpage = "" THEN iCCurrpage = 1
	IF iCTotCnt = "" THEN iCTotCnt = -1

	'// 그룹번호 랜덤으로 지정

	iCPageSize = 4		'한 페이지의 보여지는 열의 수
	iCPerCnt = 4		'보여지는 페이지 간격

	'선택범위 리플개수 접수
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iSelTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	'코멘트 데이터 가져오기
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	'cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
%>
<!doctype html>
<html lang="ko">
<head>
	<title>생활감성채널, 텐바이텐 > 이벤트 > 생활감정채널 - EPISODE 04</title>
	<style type="text/css">
	.mEvt47090 {}
	.mEvt47090 p {max-width:100%;}
	.mEvt47090 img {vertical-align:top; display:inline;}
	.mEvt47090 .myWishGift ol {margin:33px 0 40px;}
	.mEvt47090 .myWishGift li {position:relative; margin-bottom:10px;}
	.mEvt47090 .myWishGift li:last-child {margin-bottom:0;}
	.mEvt47090 .myWishGift li .face {position:absolute; left:0; top:0; width:20%; height:100%; background-position:left top; background-repeat:no-repeat; background-size:100% 100%;}
	.mEvt47090 .myWishGift li.f01 .face {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/47090/47090_img_face01.png);}
	.mEvt47090 .myWishGift li.f02 .face {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/47090/47090_img_face02.png);}
	.mEvt47090 .myWishGift li.f03 .face {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/47090/47090_img_face03.png);}
	.mEvt47090 .myWishGift li.f04 .face {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/47090/47090_img_face04.png);}
	.mEvt47090 .myWishGift .txtInfo {position:absolute; left:23%; top:8%; width:72%; font-size:11px; line-height:14px; font-weight:bold; color:#fff; overflow:hidden;}
	.mEvt47090 .myWishGift .txtInfo .writer {float:left;}
	.mEvt47090 .myWishGift .txtInfo .writer img {margin-right:3px; margin-top:2px;}
	.mEvt47090 .myWishGift .txtInfo .num {float:right;}
	.mEvt47090 .myWishGift .txt {position:absolute; left:23%; top:28%; width:63%; padding:0 5%; font-size:12px; color:#777;}
	.mEvt47090 .myWishGift .txt strong {display:block; color:#000; line-height:16px; padding:7px 0 5px;}
	.mEvt47090 .myWishGift .delete {position:absolute; right:7%; bottom:26%;}
	.mEvt47090 .myWishGift .date {position:absolute; bottom:6%; left:23%; padding:3px 10px; font-size:11px; color:#9babbd; border-radius:18px; background:rgba(0,0,0,.3);}

	.mWebtoonNav {overflow:hidden;}
	.mWebtoonNav li {float:left; width:25%;}
</style>
<script src="/event/etc/45090.js"></script>
<script src="/lib/js/kakao.Link.js"></script>
<script>
<!--

	var yr = "<%=Year(sDate)%>";
	var mo = "<%=TwoNumber(Month(sDate))%>";
	var da = "<%=TwoNumber(Day(sDate))%>";
	var tmp_hh = "99";
	var tmp_mm = "99";
	var tmp_ss = "99";
	var minus_second = 0;
	var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
	var today=new Date(<%=Year(now())%>, <%=Month(now())-1%>, <%=Day(now())%>, <%=Hour(now())%>, <%=Minute(now())%>, <%=Second(now())%>);

	function jsGoComPage(iP){
		document.frmcom.iCC.value = iP;
		document.frmcom.iCTot.value = "<%=iCTotCnt%>";
		document.frmcom.submit();
	}

	function checkform() {
	<% if datediff("d",date(),eDate)>=0 then %>
		<% If IsUserLoginOK Then %>
		var frm = document.frmcom;

		if (frm.kakaomsg.value == "" || frm.kakaomsg.value == "100자 이내로 작성해 주세요." )
		{
			alert("메시지를 작성해 주세요");
		}else{
			var msg = document.getElementById('kakaomsg').value;
			$.ajax({
				url: "doEventSubscript_47090.asp?eventid="+<%=eCode%>+"&kakaomsg="+escape(msg),
				cache: false,
				success: function(message)
				{
					$("#tempdiv").empty().append(message);
					var suc = $("div#suc").attr("value");

					if (suc == "Y")//값이 있을때만 레이어 호출
					{
						kakaosend(); //카카오 메시지
					}
				}
			});
		}
		<% Else %>
			alert('로그인후에 이용가능 합니다.');
			return;
		<% End If %>
	<% else %>
			alert('이벤트가 종료되었습니다.');
			return;
	<% end if %>
	}

	function jsChklogin11(blnLogin)
	{
		if (blnLogin == "True"){
			if($("#kakaomsg").attr("value") =="100자 이내로 작성해 주세요."){
				$("#kakaomsg").text("");
			}
			return;
		} else {
			jsChklogin('<%=IsUserLoginOK%>');
		}

		return false;
	}

	function jsChkUnblur()
	{
		if($("#kakaomsg").attr("value") == ""){
			$("#kakaomsg").text("100자 이내로 작성해 주세요.");
		}
	}

	function trim(txt) {
		return txt.replace(/(^\s*)|(\s*$)/g, "");
	}

	function kakaosend(){

		var msg = document.getElementById('kakaomsg').value;
		var url =  "이벤트참여: http://bit.ly/invite_10x10";

		if(trim(msg) == ''){
			alert('메세지를 작성하세요');
			document.getElementById('kakaomsg').value="";
			document.getElementById('kakaomsg').focus();
			return;
		}

		kakao.link("talk").send({
			msg : "친구초대하고 유니버설발레단<호두까기 인형> 보러 가자!\n\n\n[친구의 초대 메시지]\n"+msg+"\n\n지금 텐바이텐 이벤트에 참여하시면 추첨을 통해 <호두까기인형> 관람 티켓을 선물로 드립니다.\n",
			url : url,
			appid : "m.10x10.co.kr",
			appver : "2.0",
			appname : "텐바이텐 이벤트",
			type : "link"
		});
	}
	function textCounter(field, countfield, maxlimit) {
		if (field.value.length > maxlimit){
			field.blur();
			field.value = field.value.substring(0, maxlimit);
			alert("최대 100자 까지 적으실수 있습니다.");
			field.focus();
		}
	}

	function jshcommit(frm){
	<% if datediff("d",date(),eDate)>=0 then %>
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>
	   frm.action = "/event/etc/kakao_invite/doEventSubscript_47090.asp";
	   return true;
	 <% else %>
	 	alert('이벤트가 종료되었습니다.');
			return;
	 <% end if %>
	}
//-->
</script>
</head>
<body>

			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="mEvt47090">

					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47090/47090_head.png" alt="생활감정채널" style="width:100%;" /></div>
					<ul class="mWebtoonNav">
						<!-- for dev msg : nav02부터 해당 날짜가 되면 이미지명이 _off.png로 바뀌게 해주세요 -->
						<li class="nav01"><a href="/event/eventmain.asp?eventid=47087" target="_top"><img src="http://fiximage.10x10.co.kr/m/2013/event/series/webtoon_nav01_off.png" alt="EPISODE 1" style="width:100%;" /></a></li>
						<li class="nav02"><a href="/event/eventmain.asp?eventid=47088" target="_top"><img src="http://fiximage.10x10.co.kr/m/2013/event/series/webtoon_nav02_off.png" alt="EPISODE 2" style="width:100%;" /></a></li>
						<li class="nav03"><a href="/event/eventmain.asp?eventid=47089" target="_top"><img src="http://fiximage.10x10.co.kr/m/2013/event/series/webtoon_nav03_off.png" alt="EPISODE 3" style="width:100%;" /></a></li>
						<li class="nav04"><a href="/event/eventmain.asp?eventid=47090" target="_top"><img src="http://fiximage.10x10.co.kr/m/2013/event/series/webtoon_nav04_on.png" alt="EPISODE 4" style="width:100%;" /></a></li>
					</ul>
					<dl>
						<dt><img src="http://webimage.10x10.co.kr/eventIMG/2013/47090/47090_img01.png" alt="응답하라 2013" style="width:100%;" /></dt>
						<dd><img src="http://webimage.10x10.co.kr/eventIMG/2013/47090/47090_img02.png" alt="" style="width:100%;" /></dd>
						<dd><img src="http://webimage.10x10.co.kr/eventIMG/2013/47090/47090_img03.png" alt="" style="width:100%;" /></dd>
						<dd><img src="http://webimage.10x10.co.kr/eventIMG/2013/47090/47090_img04.png" alt="" style="width:100%;" /></dd>
						<dd><img src="http://webimage.10x10.co.kr/eventIMG/2013/47090/47090_img05.png" alt="" style="width:100%;" /></dd>
					</dl>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47090/47090_img06.png" alt="COMMENT EVENT" style="width:100%;" /></div>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47090/47090_img07.png" alt="호두까기인형 이미지" style="width:100%;" /></div>
					<p><a href="/culturestation/index.asp?evt_code=2135" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47090/47090_btn_play.png" alt="유니버설 발레단 호두까기인형 공연내용 확인하러 가기" style="width:100%;" /></a></p>

					<form name="frmcom" method="post" style="margin:0px;">
					<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
					<input type="hidden" name="iCTot" value="">
					<input type="hidden" name="eventid" value="<%=eCode%>">
					<input type="hidden" name="userid" value="<%=GetLoginUserID%>">

					<div class="writeMsg">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47090/47090_img08.png" alt="친구야 호두까기인형 보러 가자!" style="width:100%;" /></p>
						<div class="txtBox"><textarea name="kakaomsg" id="kakaomsg" cols="30" rows="3" onKeyDown="textCounter(this.form.kakaomsg,this.form.remLen,100);" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');textCounter(this.form.kakaomsg,this.form.remLen,100);" onblur="jsChkUnblur()" autocomplete="off" onclick="jsChklogin11('<%=IsUserLoginOK%>')">100자 이내로 작성해 주세요.</textarea></div>
						<p class="send"><a href="javascript:checkform();"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47090/47090_btn_send.png" style="width:100%;" alt="카카오톡 메시지 보내기" /></a></p>
					</div>
					</form>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47090/47090_img09.png" alt="통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며,이벤트 참여에 제한을 받을 수 있습니다." style="width:100%;" /></p>

					<style>
					.writeMsg {position:relative;}
					.writeMsg .txtBox {position:absolute; left:10%; top:46%; overflow:hidden; width:80%; height:24%; border:3px solid #ffd161; background:#fff;}
					.writeMsg .txtBox textarea {width:92%; font-size:11px; color:#000; padding:3%; border:0;}
					.writeMsg .send {position:absolute; left:10%; top:76%; width:82%;}
					.writeMsg .send input {-webkit-border-radius:0; -webkit-appearance:none;}

					.replyFriend {font-size:11px; margin-top:20px;}
					.replyFriend .total { color:#444; margin-left:4%; padding-bottom:4px;}
					.replyFriend ol {margin-bottom:30px;}
					.replyFriend li {position:relative; overflow:hidden; margin-bottom:9px;}
					.replyFriend li:last-child {margin-bottom:0;}
					.replyFriend li .bg {}
					.replyFriend li .txt {position:absolute; left:4%; top:12%; width:64%; height:68%; border-radius:6px; background:#fff;}
					.replyFriend li .txt p {padding:10px; line-height:13px; color:#744b32; word-break:break-all;}
					.replyFriend li .writer {position:absolute; left:4%; bottom:5%; font-weight:bold; color:#fff;}
					.replyFriend li.friend01 {background-color:#ffc843;}
					.replyFriend li.friend02 {background-color:#de5439;}
					.replyFriend li.friend03 {background-color:#73b8ce;}
					.replyFriend li.friend04 {background-color:#b18be4;}
					.replyFriend li.friend01 .txt {border:2px solid #f9a41e;}
					.replyFriend li.friend02 .txt {border:2px solid #aa3720;}
					.replyFriend li.friend03 .txt {border:2px solid #448498;}
					.replyFriend li.friend04 .txt {border:2px solid #865cbf;}
					</style>
					<% IF isArray(arrCList) THEN %>
					<div class="replyFriend">
						<p class="total">Total <%=iCTotCnt%></p>
						<ol>
							<% For intCLoop = 0 To UBound(arrCList,2)%>
							<li class="friend0<%= arrCList(3,intCLoop) %>">
								<div class="txt">
									<p><%=nl2br(arrCList(1,intCLoop))%></p>
								</div>
								<p class="writer"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47090/47090_txt_from.png" alt="" style="width:47px;" /> <%=printUserId(arrCList(2,intCLoop),2,"*")%></p>
								<p class="bg"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47090/47090_bg_cmt.png" alt="" style="width:100%;" /></p>
							</li>
							<% Next %>
						</ol>
						<div class="paging">
							<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
						</div>
					</div>
					<% End If %>
				</div>
			</div>
			<!-- //content area -->
<div id="tempdiv" style="display:none;"></div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
