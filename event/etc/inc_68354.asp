<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 고객님, 질문 있어요
' History : 2015.12.21 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, userid, currenttime
	IF application("Svr_Info") = "Dev" THEN
		eCode = "65997"
	Else
		eCode = "68354"
	End If

	currenttime = now()
	'currenttime = #01/08/2016 10:06:00#

	userid = GetEncLoginUserID()

dim subscriptcount, subscriptcountcurrentdate, subscriptcountend
subscriptcount=0
subscriptcountcurrentdate=0
subscriptcountend=0

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "1", "")
	subscriptcountcurrentdate = getevent_subscriptexistscount(eCode, userid, left(currenttime,10), "1", "")
	subscriptcountend = getevent_subscriptexistscount(eCode, userid, "", "2", "")
end if

dim datelimit
	datelimit=0

if left(currenttime,10) < "2016-01-05" then
	datelimit = 1
elseif left(currenttime,10) = "2016-01-05" then
	datelimit = 2
elseif left(currenttime,10) = "2016-01-06" then
	datelimit = 3
elseif left(currenttime,10) = "2016-01-07" then
	datelimit = 4
elseif left(currenttime,10) = "2016-01-08" then
	datelimit = 5		
end if

dim sqlstr, tot1datecnt, tot2datecnt, tot1cnt, tot2cnt
tot1datecnt = 0
tot2datecnt = 0
tot1cnt = 0
tot2cnt = 0

if GetLoginUserID="greenteenz" or GetLoginUserID="cogusdk" or GetLoginUserID="djjung" or GetLoginUserID="helele223" or GetLoginUserID="tozzinet" then
	sqlstr = "select count(*) as cnt"
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript] sc"
	sqlstr = sqlstr & " where sc.evt_code="& eCode &""
	sqlstr = sqlstr & " and isnull(sc.sub_opt2,'') = '1'"
	sqlstr = sqlstr & " and convert(varchar(10),sc.regdate,121) = '"& left(currenttime,10) &"'"
	
	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tot1datecnt = rsget("cnt")
	END IF
	rsget.close
	sqlstr = "select count(*) as cnt"
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript] sc"
	sqlstr = sqlstr & " where sc.evt_code="& eCode &""
	sqlstr = sqlstr & " and isnull(sc.sub_opt2,'') = '2'"
	sqlstr = sqlstr & " and convert(varchar(10),sc.regdate,121) = '"& left(currenttime,10) &"'"
	
	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tot2datecnt = rsget("cnt")
	END IF
	rsget.close
	sqlstr = "select count(*) as cnt"
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript] sc"
	sqlstr = sqlstr & " where sc.evt_code="& eCode &""
	sqlstr = sqlstr & " and isnull(sc.sub_opt2,'') = '1'"

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tot1cnt = rsget("cnt")
	END IF
	rsget.close
	sqlstr = "select count(*) as cnt"
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript] sc"
	sqlstr = sqlstr & " where sc.evt_code="& eCode &""
	sqlstr = sqlstr & " and isnull(sc.sub_opt2,'') = '2'"

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tot2cnt = rsget("cnt")
	END IF
	rsget.close
	response.write "오늘 답변 참여자수 : " & tot1datecnt & "<br>"
	response.write "오늘 응모수 : " & tot2datecnt & "<br>"
	response.write "누적 답변 참여자수 : " & tot1cnt & "<br>"
	response.write "누적 응모수 : " & tot2cnt & "<br>"
end if
%>

<% '<!-- #include virtual="/lib/inc/head.asp" --> %>

<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}

.mEvt68354 .hidden {visibility:hidden; width:0; height:0;}
.mEvt68354 button {background-color:transparent;}

.topic {position:relative;}
.topic .person {position:absolute; bottom:-9.5%; left:2%; z-index:20; width:19.21%;}

.shake {
	-webkit-animation-name:shake; -webkit-animation-iteration-count:5; -webkit-animation-duration:1s;
	-moz-animation-name:shake; -moz-animation-iteration-count:5; -moz-animation-duration:1s;
	animation-name:shake; animation-iteration-count:5; animation-duration:1s;
}
@-webkit-keyframes shake {
	from, to{margin-left:10px; -webkit-animation-timing-function:ease;}
	50% {margin-left:0px; -webkit-animation-timing-function:ease;}
}
@keyframes shake {
	from, to{margin-left:10px; animation-timing-function:ease;}
	50% {margin-left:0px; animation-timing-function:ease;}
}

.question {position:relative;}
.question .coming {position:absolute; top:0; left:0; z-index:15; width:100%;}
.question .navigator {overflow:hidden; position:absolute; top:8%; left:0; z-index:10; width:100%; padding:0 14%;}
.question .navigator li {float:left; width:20%;}
.question .navigator li a {overflow:hidden; display:block; position:relative; height:0; margin:0 6%; padding-bottom:82.25%; color:transparent; font-size:1.1rem; line-height:11em; text-align:center;}
.question .navigator li span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}
.question legend {visibility:hidden; width:0; height:0;}
.question .tabcont {position:relative;}
.question .field {position:absolute; top:35%; left:0; width:100%; height:60%;}
.question .field .itext {overflow:hidden; display:block; position:relative; z-index:10; width:53%; height:0; margin-top:16.8%; margin-left:16.1%; padding-bottom:11.3%;}
.question .field .itext input, .question .field .itext textarea {position:absolute; top:0; left:0; width:100%; height:100%; border:0; border-radius:0; background-color:transparent; color:#1c7a66; font-size:1.4rem; font-weight:bold; line-height:1.3rem; text-align:left;}
.question .field .itext textarea {padding:8%;}
.question .open {position:absolute; top:5.5%; left:16%; width:10.78%;}

#tabcont2 .itext {margin-top:12.5%; margin-left:26.8%;}
#tabcont2 .open {left:32%;}
#tabcont3 ul {margin-top:4.5%;}
#tabcont3 ul li {overflow:hidden; margin-top:2%; margin-left:20%;}
#tabcont3 ul li:nth-child(1), #tabcont3 ul li:nth-child(2) {margin-top:1%;}
#tabcont3 ul li:nth-child(4) {margin-top:1%;}
#tabcont3 ul li label {overflow:hidden; float:left; position:relative; z-index:10; width:93%; height:0; padding-bottom:5.5%; color:transparent; font-size:1.2rem; line-height:0; vertical-align:top;}
#tabcont3 ul li label span {position:absolute; top:0; left:0; width:100%; height:100%; border:0; border-radius:0; background-color:transparent;}
#tabcont3 .itext {float:left; width:7%; margin:0; padding-bottom:6%;}
#tabcont3 .itext input:checked {background:transparent url(http://webimage.10x10.co.kr/eventIMG/2015/68354/m/bg_checkbox_on.png) no-repeat 95% 0; background-size:90% 90%;}
#tabcont3 .open {left:46%;}
#tabcont4 .itext {margin-top:22.8%; margin-left:16.5%;}
#tabcont4 .open {left:60%;}
#tabcont5 .field .itext {width:80%; padding-bottom:33%; margin-top:5%; margin-left:10%;}
#tabcont5 .open {left:75%;}

.question .btnsubmit {position:absolute; bottom:8%; left:50%; width:52%; margin-left:-26%;}
.question .btnsubmit input {width:100%;}
.question .all {position:relative;}
.question .all .btnEnter {position:absolute; top:33%; left:50%; z-index:20; width:84.375%; margin-left:-42.1875%;}

.lyDone {display:none; position:absolute; top:27%; left:50%; z-index:60; width:86%; margin-left:-43%; padding-top:10%;}
.lyDone .btnClose {position:absolute; bottom:10.5%; left:50%; z-index:5; width:62%; margin-left:-31%; padding-bottom:12.25%; color:transparent;}
.lyDone .btnClose span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:rgba(0,0,0,0);}

#mask {display:none; position:absolute; top:0; left:0; z-index:55; width:100%; height:100%; background:rgba(0,0,0,.6);}

.gift {position:relative;}
.gift .giftcard {position:absolute; top:28%; left:10%; width:85.15%;}
.giftcard {transition:2s ease-in-out; transform-origin:60% 0%; transform:rotateX(200deg); opacity:0;
	-webkit-transition:2s ease-in-out; -webkit-transform-origin:60% 0%; -webkit-transform:rotateX(200deg);
}
.giftcard.rotate {transform:rotateX(360deg); -webkit-transform:rotateX(360deg); opacity:1;}

.noti {padding:2.2rem 0 2.5rem; background:#a1a1a0 url(http://webimage.10x10.co.kr/eventIMG/2015/68354/m/bg_grey.png) repeat-y 50% 0;}
.noti ul {margin-top:1.5rem; padding:0 1.5rem;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#f1f1f1; font-size:1rem; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:0.6rem; left:0; width:0.5rem; height:0.1rem; background-color:#f1f1f1;}
</style>
<script type="text/javascript">

function jseventSubmit(frm,cntval){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-01-04" and left(currenttime,10)<"2016-01-09" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcountend>0 then %>
				alert("이미 응모 하셨습니다.");
				return;
			<% else %>
				<% 'if Hour(currenttime) < 10 then %>
					//alert("쿠폰은 오전 10시부터 다운 받으실수 있습니다.");
					//return;
				<% 'else %>
					if (cntval==''){
						alert('구분자가 지정되지 않았습니다.');
						return false;
					}else if (cntval=='1' || cntval=='2' || cntval=='4'){
						if (frm.comment.value==''){
							alert('답변을 입력해 주세요.');
							frm.comment.focus();
							return false;
						}
					}else if (cntval=='3'){
						var selectedtype="";
						var selectedtypecnt="";
						for (var i=0; i < frm.commenttype.length; i++){
							if (frm.commenttype[i].checked){
								selectedtype = frm.commenttype[i].value;
								selectedtypecnt = parseInt(selectedtypecnt+ 1) ;
							}
						}
						if (selectedtype==''){
							alert('답변을 선택해 주세요.');
							frm.comment.focus();
							return false;
						}
						if (selectedtypecnt>1){
							alert('답변은 하나만 선택 하실수 있습니다.');
							frm.comment.focus();
							return false;
						}
						frm.comment.value = selectedtype;
					}else if (cntval=='5'){
						if (frm.comment.value==''){
							alert('답변을 입력해 주세요.');
							frm.comment.focus();
							return false;
						}
					}else{
						alert('정상적인 구분자가 아닙니다.');
						return;
					}

					frm.action="/event/etc/doeventsubscript/doEventSubscript68354.asp";
					frm.target="evtFrmProc";
					frm.mode.value='cnt';
					frm.cntval.value=cntval;
					frm.submit();
				<% 'end if %>
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}

function jseventend(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-01-04" and left(currenttime,10)<"2016-01-09" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcountend>0 then %>
				alert("이미 응모 하셨습니다.");
				return;
			<% else %>
				<% 'if Hour(currenttime) < 10 then %>
					//alert("쿠폰은 오전 10시부터 다운 받으실수 있습니다.");
					//return;
				<% 'else %>
					var str = $.ajax({
						type: "POST",
						url: "/event/etc/doeventsubscript/doEventSubscript68354.asp",
						data: "mode=end&isapp=<%= isapp %>",
						dataType: "text",
						async: false
					}).responseText;
					//alert(str);
					var str1 = str.split("||")
					//alert(str1[0]);
					if (str1[0] == "05"){
						/* layer */
						$("#lyDone").show();
						$("#mask").show();
						var val = $("#lyDone").offset();
						$("html,body").animate({scrollTop:val.top},200);
						return false;
					}else if (str1[0] == "04"){
						alert('다섯가지 답변을 모두 해주셔야 응모가 가능 합니다.');
						return false;
					}else if (str1[0] == "03"){
						alert('이미 응모 하셨습니다.');
						return false;
					}else if (str1[0] == "02"){
						alert('이벤트 응모 기간이 아닙니다.');
						return false;
					}else if (str1[0] == "01"){
						alert('로그인을 해주세요.');
						return false;
					}else{
						alert('오류가 발생했습니다.');
						return false;
					}
				<% 'end if %>
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}

</script>
</head>
<body>

<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
<input type="hidden" name="mode">
<input type="hidden" name="cntval">
<input type="hidden" name="isapp" value="<%= isApp %>">
<!-- [M/A] 68354 고객님, 질문있어요! -->
<div class="mEvt68354">
	<article>
		<div class="topic">
			<h2 class="hidden">고객님, 질문있어요!</h2>
			<!--for dev msg : 20150106 이미지 교체 -->
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/txt_have_a_question_v1.png" alt="2016년에는 달라질게요 매일매일 질문에 답해주신 분들 중 추첨을 통해 선물을 드려요!" /></p>
			<span class="person shake"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/img_person.png" alt="" /></span>
		</div>

		<section id="question" class="question">
			<h3 class="hidden">다섯가지 질문</h3>
			<% '<!--for dev msg : 해당 일자에 질문에 답변하면 보여주세요 txt_coming_soon_0105 ~ txt_coming_soon_0108 --> %>
			<%
			'/응모횟수
			if subscriptcount>0 then
				'/응모 완료
				if subscriptcountend>0 then
			%>
					<% '<!--for dev msg : 20150106 5번 질문 답변하고 저장하면 아래 레이어로 보여주세요 --> %>
					<p class="coming thanku">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/txt_thank_u.png" alt="감사합니다! 1월 12일 당첨자 발표를 확인하세요!" />
					</p>
				<% else %>
					<%
					if subscriptcount >= datelimit then
					%>
					<%
						'/오늘응모여부
						if subscriptcountcurrentdate>0 then
					%>
					<%
							if subscriptcount<5 then
	
					%>
								<p class="coming">
									<% if subscriptcount>0 then %>
										<img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/txt_coming_soon.png" alt="COMING SOON 내일 또 응모해주세요!" />
									<% elseif subscriptcount>1 then %>
										<img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/txt_coming_soon.png" alt="COMING SOON 내일 또 응모해주세요!" />
									<% elseif subscriptcount>2 then %>
										<img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/txt_coming_soon.png" alt="COMING SOON 내일 또 응모해주세요!" />
									<% elseif subscriptcount>3 then %>
										<img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/txt_coming_soon.png" alt="COMING SOON 내일 또 응모해주세요!" />
									<% end if %>
								</p>
							<% elseif subscriptcount>=5 then %>
								<% '<!--for dev msg : 20150106 5번 질문 답변하고 저장하면 아래 레이어로 보여주세요 --> %>
								<p class="coming thanku">
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/txt_thank_u.png" alt="감사합니다! 1월 12일 당첨자 발표를 확인하세요!" />
								</p>
							<% end if %>
						<% else %>
							<% if subscriptcount>=5 then %>
								<% '<!--for dev msg : 20150106 5번 질문 답변하고 저장하면 아래 레이어로 보여주세요 --> %>
								<p class="coming thanku">
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/txt_thank_u.png" alt="감사합니다! 1월 12일 당첨자 발표를 확인하세요!" />
								</p>
							<% end if %>
						<% end if %>
					<% end if %>
				<% end if %>
			<% end if %>

			<div id="tabcontainer" class="tabcontainer">
				<% if subscriptcount=0 then %>
					<% '<!--Q1 --> %>
					<div id="tabcont1" class="tabcont">
						<fieldset>
						<legend>텐바이텐은 무엇을 파는 곳</legend>
							<span class="open"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/ico_open.png" alt="오픈" /></span>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/txt_question_01.png" alt="텐바이텐은 무엇을 파는 곳인가요? 텐바이텐은 을(를) 파는 곳이에요" /></p>
							<div class="field">
								<div class="itext"><input type="text" name="comment" maxlength="15" title="답변쓰기" /></div>
								<div class="btnsubmit" onclick="jseventSubmit(evtFrm1,'1'); return false;"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/btn_submit.png" alt="답변 저장하기" /></div>
							</div>
						</fieldset>
					</div>
				<% elseif subscriptcount=1 then %>
					<% '<!--Q2 --> %>
					<div id="tabcont2" class="tabcont">
						<fieldset>
						<legend>텐바이텐이 선물을 준다면</legend>
							<span class="open"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/ico_open.png" alt="오픈" /></span>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/txt_question_02.png" alt="텐바이텐이 선물을 준다면 무엇을 받고 싶나요? 저는 가 갖고 싶어요!" /></p>
							<div class="field">
								<div class="itext"><input type="text" name="comment" maxlength="15" title="답변쓰기" /></div>
								<div class="btnsubmit" onclick="jseventSubmit(evtFrm1,'2'); return false;"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/btn_submit.png" alt="답변 저장하기" /></div>
							</div>
						</fieldset>
					</div>
				<% elseif subscriptcount=2 then %>
					<% '<!--Q3 --> %>
					<input type="hidden" name="comment">
					<div id="tabcont3" class="tabcont">
						<fieldset>
						<legend>텐바이텐하면 생각나는 단어</legend>
							<span class="open"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/ico_open.png" alt="오픈" /></span>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/txt_question_03_v1.png" alt="텐바이텐은 어떤 장르의 영화가 어울릴까요?" /></p>
							<div class="field">
								<ul>
									<li><span class="itext"><input type="checkbox" name="commenttype" value="배꼽아 나 살려라 코미디" id="genre01" /></span><label for="genre01"><span></span>배꼽아 나 살려라 코미디</label></li>
									<li><span class="itext"><input type="checkbox" name="commenttype" value="예측불가 스릴러" id="genre02" /></span><label for="genre02"><span></span>예측불가 스릴러</label></li>
									<li><span class="itext"><input type="checkbox" name="commenttype" value="감성실화 휴먼 다큐" id="genre03" /></span><label for="genre03"><span></span>감성실화 휴먼 다큐</label></li>
									<li><span class="itext"><input type="checkbox" name="commenttype" value="알콩달콩 로맨스" id="genre04" /></span><label for="genre04"><span></span>알콩달콩 로맨스</label></li>
									<li><span class="itext"><input type="checkbox" name="commenttype" value="만화보다는 애니메이션" id="genre05" /></span><label for="genre05"><span></span>만화보다는 애니메이션</label></li>
									<li><span class="itext"><input type="checkbox" name="commenttype" value="윙가르디움 판타지" id="genre06" /></span><label for="genre06"><span></span>윙가르디움 판타지</label></li>
								</ul>
								<div class="btnsubmit" onclick="jseventSubmit(evtFrm1,'3'); return false;"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/btn_submit.png" alt="답변 저장하기" /></div>
							</div>
						</fieldset>
					</div>
				<% elseif subscriptcount=3 then %>
					<% '<!--Q4 --> %>
					<div id="tabcont4" class="tabcont">
						<fieldset>
						<legend>텐바이텐하면 생각나는 단어</legend>
							<span class="open"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/ico_open.png" alt="오픈" /></span>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/txt_question_04.png" alt="텐바이텐하면 생각나는 단어는? 텐바이텐은 이지!" /></p>
							<div class="field">
								<div class="itext"><input type="text" name="comment" maxlength="15" title="답변쓰기" /></div>
								<div class="btnsubmit" onclick="jseventSubmit(evtFrm1,'4'); return false;"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/btn_submit.png" alt="답변 저장하기" /></div>
							</div>
						</fieldset>
					</div>
				<% elseif subscriptcount>3 then %>
					<% '<!--Q5 --> %>
					<div id="tabcont5" class="tabcont">
						<fieldset>
						<legend>텐바이텐하면 생각나는 단어</legend>
							<span class="open"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/ico_open.png" alt="오픈" /></span>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/txt_question_05.png" alt="2016년, 텐바이텐에 바라는 한가지!" /></p>
							<div class="field">
								<div class="itext"><textarea name="comment" maxlength="100" cols="60" rows="5" title="텐바이텐에 바라는 한가지 쓰기"></textarea></div>
								<div class="btnsubmit" onclick="jseventSubmit(evtFrm1,'5'); return false;"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/btn_submit.png" alt="답변 저장하기" /></div>
							</div>
						</fieldset>
					</div>
				<% end if %>
			</div>

			<div class="all">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/txt_all.png" alt="* 모든 질문에 답해주신 분들께 응모하기 버튼이 활성화 됩니다." /></p>

				<%
				'/응모횟수
				if subscriptcount>4 then
				%>
					<% '<!--  모든 질문 답변 후 --> %>
					<button type="button" onclick="jseventend(); return false;" id="btnEnter" class="btnEnter">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/btn_enter_after.png" alt="응모하기" />
					</button>
				<% else %>
					<% '<!--  모든 질문 답변 전 --> %>
					<button type="button" class="btnEnter" style="cursor:default; outline:none;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/btn_enter_before.png" alt="응모하기" />
					</button>
				<% end if %>
			</div>
		</section>

		<% '<!-- for dev msg : 응모하기 버튼 클릭시 나오는 팝업 --> %>
		<div id="lyDone" class="lyDone">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/txt_done.png" alt="고객님의 소중한 의견 감사합니다" /></p>
			<button type="button" class="btnClose"><span></span>확인</button>
		</div>

		<section class="gift">
			<h3 class="hidden">멋진 답변을 해주신 당신에게 드리는 선물</h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/txt_gift.png" alt="* 당첨자 발표는 1월 12일 공지사항을 참고해주세요" /></p>
			<p id="animation" class="giftcard"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/img_giftcard.png" alt="16명을 추천해 텐바이텐 기프트카드 5만원을 드립니다." /></p>
		</section>

		<section class="noti">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/68354/m/tit_noti_v1.png" alt="이벤트 유의사항" /></h3>
			<ul>
				<li>본 이벤트는 텐바이텐에서만 참여 가능합니다.</li>
				<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
			</ul>
		</section>

		<div id="mask"></div>
	</article>
</div>
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>

<script type="text/javascript">
$(function(){

	$("#lyDone .btnClose, #mask").click(function(){
		$("#lyDone").hide();
		$("#mask").slideUp();
		location.reload();
	});

	/* animation */
	setInterval(function(){
		animation();
	},1000);

	function animation() {
		$("#animation").delay(50).addClass("rotate");
	}
});
</script>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->