<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 듣기 능력 평가
' History : 2015-09-30 이종화
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim eCode, userid, myuserLevel, vTotalCount, vTotalSum
Dim cnt1 ,  cnt2 , cnt3 , cnt4 , totcnt , dcnt
	userid = GetEncLoginUserID()

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64902"
	Else
		eCode = "66480"
	End If

Dim vQuery, vCount

	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "' and datediff(day,regdate,getdate()) = 0 "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly

	IF Not rsget.Eof Then
		vCount = rsget(0)
	End IF
	rsget.close

	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly

	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End IF
	rsget.close

'//sns
dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode("듣기 능력 평가")
snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=" & ecode)
snpPre = Server.URLEncode("텐바이텐 이벤트")
snpTag = Server.URLEncode("텐바이텐 듣기 능력 평가")
snpTag2 = Server.URLEncode("#10x10")
%>
<style type="text/css">
img {vertical-align:top;}
.mEvt66480 {position:relative;}
.hearing {position:relative; width:100%;}
.prehear {position:absolute; top:33.4207%; left:50%; width:79.84375%; margin-left:-39.921875%; padding-bottom:38.7%;}
.prehear iframe {position:absolute; top:0; left:50%; width:100%; height:100%; margin-left:-50%;}
.inputArea {position:relative;}
.inputArea div, .inputArea p {position:absolute; left:0; width:100%; text-align:center;}
.inputArea div {top:32.5%;}
.inputArea div input {width:80%; text-align:center; background:transparent; border:none; color:#000;}
.inputArea button {overflow:hidden; width:70%; height:100%; margin:0 auto; text-indent:-999em; background-color:transparent;}
.inputArea .btnSubmit {top:43%; height:12%;}
.inputArea .btnGiftView {top:64.5%; height:9%;}
.inputArea .total {position:absolute; left:0; top:59%; color:#fff; font-size:15px; font-weight:bold;}
.inputArea .total strong {display:inline-block; position:relative; top:-1px; border-bottom:1px solid #ff3c3c; color:#ff3c3c; line-height:14px; margin:0 3px 0 5px;}
.result {position:relative; padding:0 9% 9.6%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/66480/m/bg_black.gif) repeat-y 0 0; background-size:100% auto;}
.result dl {text-align:center; border:3px solid #282828;}
.result dl dt {color:#ffed9c; font-size:13px; padding:3.2% 0; font-weight:bold; background:#1d1d1d;}
.result dl dd {overflow:hidden; position:relative; color:#fff; padding:16px 7%; background:#000;}
.result dl dd:after {content:' '; display:inline-block; position:absolute; left:9%; bottom:0; width:82%; height:1px; background:rgba(255,255,255,.7);}
.result dl dd:last-child:after {display:none;}
.result dl dd .inputTxt {font-size:15px;}
.result dl dd .date {font-size:11px; padding-top:2.2%;}
.result dl dd .date span {padding:0 2%; font-weight:bold;}
.snsShare {position:relative;}
.snsShare ul {overflow:hidden; position:absolute; left:0; top:62.77%; width:100%; height:23%; text-align:center;}
.snsShare ul li {display:inline-block; width:17%; height:100%;}
.snsShare ul li a {overflow:hidden; display:block; width:100%; height:100%; text-indent:-999em;}
.evtNoti {padding:6.5% 5.2%; text-align:left; background:#3b3b3b;}
.evtNoti h3 {display:inline-block; font-size:15px; font-weight:bold; padding-bottom:1px; color:#fbd75c; border-bottom:2px solid #fbd75c; margin-bottom:12px;}
.evtNoti li {position:relative; font-size:11px; line-height:1.4; padding:0 0 3px 8px; color:#fefefe;}
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:4px; width:3px; height:3px; background:#fff593; border-radius:50%;}
.evtNoti li span {color:#fef7b6;}
/* 레이어팝업 */
.layerPopup {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.75);}
.layerPopup .btnLyrClose {position:absolute; display:block; background-color:transparent; color:transparent; font-size:0; line-height:0;}
.layerCont {position:absolute; left:11.5%; top:80px; width:77%;}
.finishLayer .layerCont {}
.finishLayer .btnLyrClose {width:60%; height:19%; left:20%; bottom:12%;}
.giftLayer .btnLyrClose {right:3%; top:3%; width:20px; height:20px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/66480/m/lyr_close.png) no-repeat 0 0; background-size:100% 100%;}
@media (min-width: 480px) {
	.inputArea .total {font-size:23px;}
	.inputArea .total strong {line-height:22px; margin:0 5px 0 7px;}
	.result dl dd .inputTxt {font-size:23px;}
	.result dl dd .date {font-size:17px;}
	.evtNoti h3 {font-size:23px; margin-bottom:18px;}
	.evtNoti li {font-size:17px; padding:0 0 4px 12px;}
	.evtNoti li:after {top:7px; width:4px; height:4px; }
}
</style>
<script>
function jsComment(){
	var frm = document.frmGubun2;
	<% If Now() > #10/09/2015 23:59:59# Then %>
		alert("이벤트가 종료되었습니다.");
		return;
	<% Elseif Now() < #10/01/2015 00:00:00# Then %>
		alert("이벤트 기간이 아닙니다.");
		return;
	<% else %>
		<% If IsUserLoginOK() Then %>
			<% if vCount < 2 then %>
			if (frm.hiddentext.value == ""){
				alert('받아쓰기를 적어주세요');
				frm.hiddentext.focus();
				return;
			}else{
				frm.action = "/event/etc/doeventsubscript/doEventSubscript66480.asp";
				//frm.target = "_blank";
				frm.submit();
			}
			<% else %>
				alert("이미 응모 하셨습니다.");
				return;
			<% End If %>
		<% else %>
			<% If isapp="1" Then %>
				calllogin();
				return;
			<% else %>
				jsevtlogin();
				return;
			<% End If %>
		<% End If %>
	<% End if %>
}

function returnlayer(){
	$('.finishLayer').show();
	window.parent.$('html,body').animate({scrollTop:100}, 300);
}

$(function(){
	$('.btnGiftView').click(function(){
		$('.giftLayer').show();
		window.parent.$('html,body').animate({scrollTop:100}, 300);
	});
	$('.btnLyrClose').click(function(){ //'닫기버튼
		$('.layerPopup').hide();
		location.reload();
	});

	$('input[name=hiddentext]').attr("autocomplete","off");
});

//'sns 체크후 액션
function snschk(snsnum) {
	var str = $.ajax({
		type: "GET",
		url: "/event/etc/doeventsubscript/doEventSubscript66480.asp",
		data: "mode=snschk&snsnum="+snsnum,
		dataType: "text",
		async: false
	}).responseText;
	if(str=="tw") {
		popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
	}else if(str=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
	}else if(str=="ka"){
		<% if isApp="1" then %>
			parent_kakaolink('[텐바이텐] 블라인드 테스트\n\n곧 찾아오는 10월 9일 한글날을\n맞이하여 특별한 이벤트를 준비했습니다!\n\n받아쓰기 어디까지 써보셨나요?\n\n어둠 속에서 이루어지는\n특별한 블라인드 테스트\n\n지금 도전하세요!' , 'http://webimage.10x10.co.kr/eventIMG/2015/66480/66480_kakao.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=66480' );
		<% else %>
			parent_kakaolink('[텐바이텐] 블라인드 테스트\n\n곧 찾아오는 10월 9일 한글날을\n맞이하여 특별한 이벤트를 준비했습니다!\n\n받아쓰기 어디까지 써보셨나요?\n\n어둠 속에서 이루어지는\n특별한 블라인드 테스트\n\n지금 도전하세요!' , 'http://webimage.10x10.co.kr/eventIMG/2015/66480/66480_kakao.jpg' , '200' , '200' , 'http://m.10x10.co.kr/event/eventmain.asp?eventid=66480' );
		<% end if %>
	}else if(str=="ln"){
		popSNSPost('ln','<%=snpTitle%>','<%=snpLink%>','','');
	}else if(str=="none"){
		alert('참여 이력이 없습니다.\n응모후 이용 하세요');
		return false;
	}else if(str=="end"){
		alert('오늘의 나누기를 모두 하셨습니다.');
		return false;
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}
</script>
<% If userid = "greenteenz" Or userid = "motions" And isapp <> "1" Then %>
<style type="text/css">
.table {width:900px; margin:0 auto; font-family:'malgun gothic'; border-collapse:collapse;}
.table th {padding:12px 0; font-size:13px; font-weight:bold;  color:#fff; background:#444;}
.table td {padding:12px 3px; font-size:12px; border:1px solid #ddd; border-bottom:2px solid #ddd;}
.table td.lt {text-align:left; padding:12px 10px;}
.tBtn {display:inline-block; border:1px solid #2b90b6; background:#03a0db; padding:0 10px 2px; line-height:26px; height:26px; font-weight:bold; border-radius:5px; color:#fff !important;}
.tBtn:hover {text-decoration:none;}
.table td input {border:1px solid #ddd; height:30px; padding:0 3px; font-size:14px; color:#ec0d02; text-align:right;}
</style>
<table class="table" style="width:90%;">
	<colgroup>
		<col width="20%" />
		<col width="*" />
		<col width="*" />
		<col width="*" />
		<col width="*" />
		<col width="*" />
	</colgroup>
	<tr align="center" bgcolor="#E6E6E6">
		<th><strong>일자</strong></th>
		<th><strong>트위터</strong></th>
		<th><strong>페북</strong></th>
		<th><strong>카카오</strong></th>
		<th><strong>라인</strong></th>
		<th><strong>전체</strong></th>
	</tr>
	<%
		vQuery = "SELECT sum(case when sub_opt3 = 'tw' then 1 else 0 end) as twcnt "
		vQuery = vQuery & " , sum(case when sub_opt3 = 'fb' then 1 else 0 end) as fbcnt "
		vQuery = vQuery & " , sum(case when sub_opt3 = 'ka' then 1 else 0 end) as kacnt "
		vQuery = vQuery & " , sum(case when sub_opt3 = 'ln' then 1 else 0 end) as lncnt "
		vQuery = vQuery & " , count(*) as totcnt "
		vQuery = vQuery & " , convert(varchar(10),regdate,120) as dcnt "
		vQuery = vQuery & " FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' and sub_opt2 = 1 group by convert(varchar(10),regdate,120) order by convert(varchar(10),regdate,120) "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly

		if Not(rsget.EOF or rsget.BOF) Then
			Do Until rsget.eof
	%>
	<tr>
		<td style="text-align:center;"><%=rsget("dcnt")%></td>
		<td style="text-align:center;"><%=rsget("twcnt")%></td>
		<td style="text-align:center;"><%=rsget("fbcnt")%></td>
		<td style="text-align:center;"><%=rsget("kacnt")%></td>
		<td style="text-align:center;"><%=rsget("lncnt")%></td>
		<td style="text-align:center;"><%=rsget("totcnt")%></td>
	</tr>
	<%
			rsget.movenext
			Loop
		End If
		rsget.close		
	%>
</table>
<% End If %>
<div class="mEvt66480">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/66480/m/blind_tit.png" alt="한글날 맞이 - 듣기 능력평가" /></h2>
	<div class="hearing">
		<div class="prehear">
			<% If Date() = "2015-09-30" Or Date() = "2015-10-01" Then %>
			<iframe src="https://www.youtube.com/embed/iARFuSVsnM4?rel=0" frameborder="0" allowfullscreen></iframe>
			<% End If %>
			<% If Date() = "2015-10-02" Then %>
			<iframe src="https://www.youtube.com/embed/4zMsccgFO-g?rel=0" frameborder="0" allowfullscreen></iframe>			
			<% End If %>
			<% If Date() = "2015-10-03" Then %>
			<iframe src="https://www.youtube.com/embed/tyi0rxcmN-Y?rel=0" frameborder="0" allowfullscreen></iframe>			
			<% End If %>
			<% If Date() = "2015-10-04" Then %>
			<iframe src="https://www.youtube.com/embed/se2O9ekUysc?rel=0" frameborder="0" allowfullscreen></iframe>			
			<% End If %>
			<% If Date() = "2015-10-05" Then %>
			<iframe src="https://www.youtube.com/embed/2zPUG11_6cU?rel=0" frameborder="0" allowfullscreen></iframe>			
			<% End If %>
			<% If Date() = "2015-10-06" Then %>
			<iframe src="https://www.youtube.com/embed/A3dCLYOr_mU?rel=0" frameborder="0" allowfullscreen></iframe>			
			<% End If %>
			<% If Date() = "2015-10-07" Then %>
			<iframe src="https://www.youtube.com/embed/kcqWhuZq6oE?rel=0" frameborder="0" allowfullscreen></iframe>
			<% End If %>
			<% If Date() = "2015-10-08" Then %>
			<iframe src="https://www.youtube.com/embed/oi3Mgya220E?rel=0" frameborder="0" allowfullscreen></iframe>
			<% End If %>
			<% If Date() = "2015-10-09" Then %>
			<iframe src="https://www.youtube.com/embed/qtKz91xj2Wk?rel=0" frameborder="0" allowfullscreen></iframe>
			<% End If %>
		</div>
		<img src="http://webimage.10x10.co.kr/eventIMG/2015/66480/m/blind_step01.png" alt="STEP.01 귀 귀울어 듣기" />
	</div>
	<form name="frmGubun2" method="post" style="margin:0px;" target="prociframe">
	<input type="hidden" name="mode" value="add" />
	<div class="inputArea">
		<div><input type="text" name="hiddentext" value="" maxlength="15" /></div>
		<p class="btnSubmit"><button onclick="jsComment();return false;">응모하기</button></p>
		<p class="btnGiftView"><button>오늘의 선물 보기</button></p>
		<img src="http://webimage.10x10.co.kr/eventIMG/2015/66480/m/blind_step02_v2.png" alt="STEP.02 어둠 속에서 받아쓰기" />
		<p class="total">현재 <strong><%=FormatNumber(vTotalCount,0)%></strong>명이 응모하셨습니다.</p>
	</div>
	</form>
	<% If vCount > 0 And IsUserLoginOK() Then %>
	<div class="result">
		<dl>
			<dt>내가 오늘 쓴 글 확인하기</dt>
			<%
				vQuery = "SELECT top 2 * FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "' and datediff(day,regdate,getdate()) = 0 "
				rsget.Open vQuery,dbget,1
				if Not(rsget.EOF or rsget.BOF) Then
					Do Until rsget.eof
			%>
			<dd>
				<p class="inputTxt"><%=rsget("sub_opt1")%></p>
				<p class="date"><%=formatdate(rsget("regdate"),"0000.00.00 00:00:00")%> <span>l</span> <%=rsget("userid")%></p>
			</dd>
			<%
					rsget.movenext
					Loop
				End If
				rsget.close
			%>
		</dl>
	</div>
	<% End If %>
	<div class="snsShare">
		<ul>
			<li><a href="" onclick="snschk('tw');return false;">트위터 공유</a></li>
			<li><a href="" onclick="snschk('fb');return false;">페이스북 공유</a></li>
			<li><a href="" onclick="snschk('ka');return false;">카카오톡 공유</a></li>
			<li><a href="" onclick="snschk('ln');return false;">라인 공유</a></li>
		</ul>
		<img src="http://webimage.10x10.co.kr/eventIMG/2015/66480/m/blind_step03.png" alt="STEP.03 나누기" />
	</div>
	<div class="evtNoti">
		<h3>이벤트 유의사항</h3>
		<ul>
			<li><span>일별 ID당 1회만 응모가능하며, 친구 초대 시 한 번 더 응모기회가 주어집니다.</span></li>
			<li>매일 다른 메시지로 새롭게 구성 됩니다.</li>
			<li><span>당첨 결과에 띄어쓰기는 영향을 미치지 않습니다.</span></li>
			<li>당첨자는 익일 추첨을 통해 발표합니다. 공지사항을 확인해 주세요.</li>
			<li><span>금, 토, 일에 당첨된 고객께는 10월 5일 월요일에 당첨안내 문자가 전송될 예정입니다.</span></li>
		</ul>
	</div>
	<% If Date() >= "2015-10-08" Then  %>
		<% If isapp = "1" Then %>
		<a href="" onclick="fnAPPpopupEvent('66698');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66480/m/bnr_marauders.png" alt="습격자들 바로가기" /></a>
		<% Else %>
		<a href="/event/eventmain.asp?eventid=66698"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66480/m/bnr_marauders.png" alt="습격자들 바로가기" /></a>
		<% End If %>
	<% End If %>
	<% '응모 완료 레이어팝업 %>
	<div class="finishLayer layerPopup">
		<div class="layerCont">
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/66480/m/lyr_confirm.png" alt="응모가 완료되었습니다. 혹시.. 틀린 글씨는 없는지 다시 체크해보세요!" /></div>
			<button class="btnLyrClose">확인</button>
		</div>
	</div>
	<% '오늘의 선물 보기 레이어팝업 %>
	<div class="giftLayer layerPopup">
		<div class="layerCont">
			<div>
				<% If Date() = "2015-09-30" Or Date() = "2015-10-01" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/66480/m/lyr_gift_1001.png" alt="10월1일-CGV 영화 예매권" />
				<% End If %>
				<% If Date() = "2015-10-02" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/66480/m/lyr_gift_1002.png" alt="10월2일-기프트카드" />
				<% End If %>
				<% If Date() = "2015-10-03" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/66480/m/lyr_gift_1003.png" alt="10월3일-파인트 아이스크림" />
				<% End If %>
				<% If Date() = "2015-10-04" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/66480/m/lyr_gift_1004.png" alt="10월4일-스타벅스 아메리카노 TALL" />
				<% End If %>
				<% If Date() = "2015-10-05" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/66480/m/lyr_gift_1005.png" alt="10월5일-CGV 영화 예매권" />
				<% End If %>
				<% If Date() = "2015-10-06" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/66480/m/lyr_gift_1006.png" alt="10월6일-기프트카드" />
				<% End If %>
				<% If Date() = "2015-10-07" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/66480/m/lyr_gift_1007.png" alt="10월7일-파인트 아이스크림" />
				<% End If %>
				<% If Date() = "2015-10-08" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/66480/m/lyr_gift_1008.png" alt="10월8일-스타벅스 아메리카노 TALL" />
				<% End If %>
				<% If Date() = "2015-10-09" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/66480/m/lyr_gift_1009.png" alt="10월9일-기프트카드" />
				<% End If %>				
			</div>
			<button class="btnLyrClose">닫기</button>
		</div>
	</div>
	<iframe name="prociframe" id="prociframe" frameborder="0" width="0px" height="0px"></iframe>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->