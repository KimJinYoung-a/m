<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 선택 10x10, 투표를 합시다
' History : 2014.05.30 원승현
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->

<%
dim cEvent, ename, eCode, userid

dim realtest_url
IF application("Svr_Info") = "Dev" THEN
	realtest_url="test"
End If


function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-05-26"
	
	getnowdate = nowdate
end Function

function getkakaolink()
	dim kakaolink
	
	IF application("Svr_Info") = "Dev" THEN
		kakaolink   =  "http://bit.ly/1gmibv8"
	Else
		kakaolink   =  "http://bit.ly/1gUZ4sJ"
	End If
	
	getkakaolink = kakaolink
end function

IF application("Svr_Info") = "Dev" THEN
	eCode = "21190"
Else
	eCode = "52312"
End If


set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent
	
	eCode		= cEvent.FECode	
	ename		= cEvent.FEName
set cEvent = nothing
userid = getloginuserid()


'// 투표갯수 가져오기
Dim n1cnt, n2cnt, n3cnt, nTotalcnt, vsql, vSub_opt1, vSub_opt3, vVotechk, n1voteper, n2voteper, n3voteper
	'// 기호1 소니엔젤 투표갯수 가져오기
	vsql = " Select count(sub_idx) as n1cnt From db_event.dbo.tbl_event_subscript Where evt_code='"&eCode&"' And sub_opt1='1' "
	rsget.Open vsql,dbget
	IF not rsget.EOF THEN
		n1cnt = rsget(0)
	else
		n1cnt = 0
	END IF
	rsget.close

	'// 기호2 심슨 투표갯수 가져오기
	vsql = " Select count(sub_idx) as n2cnt From db_event.dbo.tbl_event_subscript Where evt_code='"&eCode&"' And sub_opt1='2' "
	rsget.Open vsql,dbget
	IF not rsget.EOF THEN
		n2cnt = rsget(0)
	else
		n2cnt = 0
	END IF
	rsget.close

	'// 기호3 아이언맨 투표갯수 가져오기
	vsql = " Select count(sub_idx) as n3cnt From db_event.dbo.tbl_event_subscript Where evt_code='"&eCode&"' And sub_opt1='3' "
	rsget.Open vsql,dbget
	IF not rsget.EOF THEN
		n3cnt = rsget(0)
	else
		n3cnt = 0
	END IF
	rsget.close

	'// 총 투표갯수 가져오기
	vsql = " Select count(sub_idx) as nTotalcnt From db_event.dbo.tbl_event_subscript Where evt_code='"&eCode&"' "
	rsget.Open vsql,dbget
	IF not rsget.EOF THEN
		nTotalcnt = rsget(0)
	else
		nTotalcnt = 0
	END IF
	rsget.close


	'// 투표율 계산
	If n1cnt <> 0 Then
		n1voteper = (n1cnt/nTotalcnt)*100
		n1voteper = FormatNumber(n1voteper, 1)
	Else
		n1voteper = 0
	End If

	If n2cnt <> 0 Then
		n2voteper = (n2cnt/nTotalcnt)*100
		n2voteper = FormatNumber(n2voteper, 1)
	Else
		n2voteper = 0
	End If

	If n3cnt <> 0 Then
		n3voteper = (n3cnt/nTotalcnt)*100
		n3voteper = FormatNumber(n3voteper, 1)
	Else
		n3voteper = 0
	End If


'// 일자별 투표 체크(투표를 했다면 당선율을 표시해줌, 1일 1투표)
	vsql = " Select top 1 sub_opt1, sub_opt3, userid From db_event.dbo.tbl_event_subscript Where evt_code='"&eCode&"' And userid='"&userid&"' And convert(varchar(10), regdate, 120) = '"&Left(Now(), 10)&"' "
	rsget.Open vsql,dbget
	IF not rsget.EOF THEN
		vSub_opt1 = rsget("sub_opt1")
		vSub_opt3 = rsget("sub_opt3")
		vVotechk = True
	else
		vVotechk = False
	END IF
	rsget.close


	Public Function URLEncodeUTF8(byVal szSource)
		Dim szChar, WideChar, nLength, i, result
		nLength = Len(szSource)
	
		For i = 1 To nLength
			szChar = Mid(szSource, i, 1)
	
			If Asc(szChar) < 0 Then
				WideChar = CLng(AscB(MidB(szChar, 2, 1))) * 256 + AscB(MidB(szChar, 1, 1))
	
				If (WideChar And &HFF80) = 0 Then
					result = result & "%" & Hex(WideChar)
				ElseIf (WideChar And &HF000) = 0 Then
					result = result & _
						"%" & Hex(CInt((WideChar And &HFFC0) / 64) Or &HC0) & _
						"%" & Hex(WideChar And &H3F Or &H80)
				Else
					result = result & _
						"%" & Hex(CInt((WideChar And &HF000) / 4096) Or &HE0) & _
						"%" & Hex(CInt((WideChar And &HFFC0) / 64) And &H3F Or &H80) & _
						"%" & Hex(WideChar And &H3F Or &H80)
				End If
			Else
				if (Asc(szChar)>=48 and Asc(szChar)<=57) or (Asc(szChar)>=65 and Asc(szChar)<=90) or (Asc(szChar)>=97 and Asc(szChar)<=122) then
					result = result + szChar
				else
					if Asc(szChar)=32 then
						result = result & "+"
					else
						result = result & "%" & Hex(AscB(MidB(szChar, 1, 1)))
					end if
				end if
			End If
		Next
		URLEncodeUTF8 = result
	End Function


%>

<head>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<style type="text/css">
.mEvt52312 {}
.mEvt52312 img {vertical-align:top; width:100%;}
.mEvt52312 p {max-width:100%;}
.mEvt52312 .candidate li {position:relative;}
.mEvt52312 .candidate li .vote {position:absolute; left:0; bottom:0; width:100%; padding:18px 0 25px; text-align:center; font-weight:bold;}
.mEvt52312 .candidate li .vote input {width:46%; vertical-align:middle; }
.mEvt52312 .candidate li .vote span {display:inline-block; vertical-align:middle; width:57%; height:32px; line-height:32px; border:2px solid #000; background:#fff;}
.mEvt52312 .candidate li .vote span em {display:inline-block; padding-left:28px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52312/img_vote.png) left center no-repeat #fff; background-size:23px 23px;}
.mEvt52312 .candidate li a {position:absolute; display:inline-block; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52312/blank.png) left top repeat;}
.mEvt52312 .candidate li .link01 {width:47.5%; height:64%; left:3%; top:7%;}
.mEvt52312 .candidate li .link02 {width:43%; height:24%; right:3%; top:14%;}
.mEvt52312 .shareSns {position:relative;}
.mEvt52312 .shareSns ul {position:absolute; left:29%; top:48%; overflow:hidden; width:60%;}
.mEvt52312 .shareSns li {float:left; width:33%;}
.mEvt52312 .shareSns li a {display:block; margin:0 5px;}
</style>
<script src="/lib/js/kakao.Link.js"></script>
<script type="text/javascript">
	
function jsgoVote(vNb){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #06/03/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% if vVotechk then %>
				alert("1일 1회만 투표가능합니다.");
				return;
			<% else %>
				evtFrm1.mode.value="vote";
				evtFrm1.votevalue.value=""+vNb+"";
				evtFrm1.submit();
			<% end if %>
		<% End If %>
	<% Else %>
		//alert('로그인을 하셔야 참여가 가능 합니다');
		calllogin();
		//return;
	<% End IF %>
}


function kakaosendcall(){
	kakaosend52312();
}

function kakaosend52312(){
	var url =  'http://bit.ly/1hi7haq';
	kakao.link("talk").send({
		msg : "대국민 선택!\n키덜트 대표를 뽑아주세요.",
		url : url,
		appid : "m.10x10.co.kr",
		appver : "2.0",
		appname : "선택 10x10, 투표를 합시다!",
		type : "link"
	});
}
</script>

</head>
<body>

<!-- 선택 10x10, 투표를 합시다 -->
<div class="mEvt52312">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/52312/tit_vote_10x10.png" alt="선택 10x10, 투표를 합시다" /></h2>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52312/txt_event_info.png" alt="여러분이 생각하는 키덜트 대표는 누구인가요? 가장 많은 선택을 받은 키덜트를 선택하신 분 중 추첨을 통해 선물을 드립니다. 이벤트 기간동안 1일 1회 투표 가능합니다.(투표는 WISH APP에서만 가능합니다.) / 이벤트 기간 2014년 5월 31일~6월 3일, 당첨자발표 : 6월 5일" /></p>
	<ul class="candidate">
		<li>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/52312/img_candidate01.png" alt="기호 1번 - 깨끗하게 투명하게! 전부 보여드리겠습니다!" /></div>
			<a href="/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=877509" class="link01" target="parent"></a>
			<a href="/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=897990" class="link02" target="parent"></a>
			<p class="vote">
			<% If vVotechk Then %>
				<span><em>현재 당선율 <%=n1voteper%>%</em></span>
			<% Else %>
				<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/52312/btn_vote.png" alt="투표하기" onclick="jsgoVote('1');"/>
			<% End If %>
			</p>
		</li>
		<li>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/52312/img_candidate02.png" alt="기호 2번 - 세상의 대부분은 평범한 키덜트입니다. 평범한 키덜트의 대표" /></div>
			<a href="/apps/appcom/wish/webview/event/eventmain.asp?eventid=51803" class="link01" target="_parent"></a>
			<a href="/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=1030043" class="link02" target="parent"></a>
			<p class="vote">
			<% If vVotechk Then %>
				<span><em>현재 당선율 <%=n2voteper%>%</em></span>
			<% Else %>
				<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/52312/btn_vote.png" alt="투표하기" onclick="jsgoVote('2');"/>
			<% End If %>
			</p>
		</li>
		<li>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/52312/img_candidate03.png" alt="기호 3번 - 이 시대는 영웅이 필요합니다. 세상은 내가 지키으리" /></div>
			<a href="/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=891931" class="link01" target="parent"></a>
			<a href="/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=944301" class="link02" target="parent"></a>
			<p class="vote">
			<% If vVotechk Then %>
				<span><em>현재 당선율 <%=n3voteper%>%</em></span>
			<% Else %>
				<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/52312/btn_vote.png" alt="투표하기" onclick="jsgoVote('3');"/>
			<% End If %>
			</p>
		</li>
	</ul>
	<div class="shareSns">
		<img src="http://webimage.10x10.co.kr/eventIMG/2014/52312/img_share.png" alt="친구야, 투표하러 가자! - sns로 이벤트 공유하기" />
		<%
			'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
			dim snpTitle, strTitle2, snpLink, snpLink2, snpPre, snpPre2, snpTag, snpTag2, snpImg
			snpTitle = URLEncodeUTF8(ename)
			strTitle2 = Server.URLEncode(ename)
			snpLink = URLEncodeUTF8("http://m.10x10.co.kr/event/eventmain.asp?eventid=52311")
			snpLink2 = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=52311")
			snpPre = URLEncodeUTF8("텐바이텐 이벤트")
			snpPre2 = Server.URLEncode("텐바이텐 이벤트")
			snpTag = URLEncodeUTF8("텐바이텐 " & Replace(ename," ",""))
			snpTag2 = URLEncodeUTF8("#10x10")
		%>
		<ul>
			<li><a href="#" onclick="popSNSPost('tw','<%=strTitle2%>','<%=snpLink2%>','<%=snpPre2%>','<%=snpTag2%>');return false;" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52312/btn_sns_twitter.png" alt="twitter" /></a></li>
			<li><a href="#" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52312/btn_sns_facebook.png" alt="face book" /></a></li>
			<li><a href="#" onclick="kakaosendcall(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52312/btn_sns_kakaotalk.png" alt="kakao talk" /></a></li>
		</ul>
	</div>
</div>
<!-- //선택 10x10, 투표를 합시다 -->

<form name="evtFrm1" action="/apps/appcom/wish/webview/event/etc/doEventSubscript52312.asp" method="post" target="evtFrmProc" style="margin:0px;">
<form name="evtFrm1" action="/apps/appcom/wish/webview/event/etc/doEventSubscript52312.asp" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
	<input type="hidden" name="votevalue">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->