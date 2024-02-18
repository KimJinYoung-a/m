<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 기승전 2차 매일 매일 한가위만 같아라
' History : 2014.08.29 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/event54591Cls.asp" -->

<%
dim eCode, userid, subscriptcount, i
	eCode=getevt_code
	userid = getloginuserid()

dim totalwinnersubscriptcount, totalmysubscriptcount, myisusingsubscriptcount, mysubscriptarr, mysubscriptresultval
	totalwinnersubscriptcount=0
	totalmysubscriptcount=0
	myisusingsubscriptcount=0
	mysubscriptarr=""
	mysubscriptresultval=""

'//총응모자 중에 당첨된 사람수
totalwinnersubscriptcount = getevent_subscripttotalcount(eCode, getnowdate, "1", "")

If IsUserLoginOK() Then
	'//본인 응모수
	totalmysubscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate, "", "")
	'//템프값		'//카카오톡 친구초대시 1회에 한해서 하루에 한번더 참여가능. 체크를 위해 템프값을 넣어놓음
	myisusingsubscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate, "3", "")
	'//템프값이 0이 아닐경우 응모수에서 템프값을 뺌
	if myisusingsubscriptcount<>0 then
		totalmysubscriptcount=totalmysubscriptcount-myisusingsubscriptcount
	end if

	'//최근응모 1개
	mysubscriptresultval = get54589event_subscriptresultval(eCode, userid, getnowdate)
	'//전체응모내역
	mysubscriptarr = get54589event_subscriptarr(eCode, userid)
end if

'response.write totalmysubscriptcount & "<br>"
'response.write totalwinnersubscriptcount & "<br>"
%>

<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->

<style type="text/css">
.mEvt54591 {border-bottom:2px solid #9e2020;}
.mEvt54591 img {vertical-align:top; width:100%;}
.mEvt54591 p {max-width:100%;}
.hangawi .heading {position:relative;}
.hangawi .heading {padding:7% 0; background-color:#fff6e0; text-align:center;}
.hangawi .heading p {position:relative; z-index:10;}
.hangawi .heading p:nth-child(1) img {width:79.375%;}
.hangawi .heading p:nth-child(2) {margin-top:2%;}
.hangawi .heading p:nth-child(2) img {width:79.375%;}
.hangawi .heading p:nth-child(3) {margin-top:5%;}
.hangawi .heading p:nth-child(3) img {width:79.375%;}
.hangawi .heading .moon {position:absolute; top:20%; left:0; z-index:5; width:100%;}
.hangawi .game {background-color:#ffe186;}
.hangawi .game .tab-attend {position:relative; padding-bottom:10%;}
.hangawi .game .tab-attend ul {overflow:hidden; position:absolute; top:11.5%; left:0; width:100%; padding:0 12.5%; box-sizing:border-box; -webkit-box-sizing:border-box; -moz-box-sizing:border-box;}
.hangawi .game .tab-attend ul li {float:left; position:relative; width:22%; margin:0 1.5%; padding-bottom:22.5%;}
.hangawi .game .tab-attend ul li:nth-child(5) {clear:left;}
.hangawi .game .tab-attend ul li .win {position:absolute; left:28%; top:29%; width:42%;}
.hangawi .game .slot {position:relative;}
.hangawi .game .slot .result {position:absolute; top:0; left:0; width:100%;}
.hangawi .game .slot .btnPush {margin:5% 26.5% 0;}
.hangawi .hangawi-gift {padding-bottom:5%; background-color:#fff1ce;}
.hangawi .hangawi-gift ul {overflow:hidden; padding:3% 5% 0;}
.hangawi .hangawi-gift ul li {position:relative; float:left; width:44%; margin:0 3% 5%;}
.hangawi .hangawi-gift ul li .close {display:none; position:absolute; left:0; top:0; width:100%;}
.hangawi .hangawi-gift ul li .today {position:absolute; left:34%; top:-1%; width:30%;}
.hangawi .kakao {position:relative;}
.hangawi .kakao .btnKakao {position:absolute; top:10%; right:5%; width:31.875%;}
.hangawi .noti {background-color:#fff5dd; text-align:left;}
.hangawi .noti ul {padding:0 5.41666% 8%;}
.hangawi .noti ul li {margin-top:7px; padding-left:15px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54591/blt_hypen.gif); background-repeat:no-repeat; background-position:0 10px; background-size:9px auto; color:#444 font-size:16px; line-height:1.5em;}
.hangawi .noti ul li em {color:#d50c0c; font-style:normal;}
@media all and (max-width:480px){
	.hangawi .noti ul li {margin-top:2px; padding-left:10px; font-size:11px; background-position:0 6px; background-size:6px auto;}
}
.hangawi .tab-area {position:relative; padding:15% 0 4%; border-bottom:1px solid #f05a5a; background-color:#d50c0c;}
.hangawi .tab-area strong {display:block; position:absolute; top:8%; left:0; width:100%;}
.hangawi .tab-area .tab-nav {overflow:hidden; padding:5% 1.5% 0;}
.hangawi .tab-area .tab-nav li {float:left; width:25%; padding:0 0.625%; box-sizing:border-box; -webkit-box-sizing:border-box; -moz-box-sizing:border-box;}
.animated {-webkit-animation-duration:5s; animation-duration:5s; -webkit-animation-fill-mode:both; animation-fill-mode:both;}
/* Shake animation */
@-webkit-keyframes shake {
	0%, 100% {-webkit-transform: translateX(0);}
	10%, 30%, 50%, 70%, 90% {-webkit-transform: translateX(5px);}
	20%, 40%, 60%, 80% {-webkit-transform: translateX(-5px);}
}
@keyframes shake {
	0%, 100% {transform: translateX(0);}
	10%, 30%, 50%, 70%, 90% {transform: translateX(5px);}
	20%, 40%, 60%, 80% {transform: translateX(-5px);}
}
.shake {-webkit-animation-name: shake; animation-name: shake; -webkit-animation-duration:10s; animation-duration:10s;}
/* Flash animation */
@-webkit-keyframes flash {
	0%, 50%, 100% {opacity: 1;}
	25%, 75% {opacity:0.8;}
}
@keyframes flash {
	0%, 50%, 100% {opacity: 1;}
	25%, 75% {opacity:0.8;}
}
.flash {-webkit-animation-name:flash; animation-name:flash; -webkit-animation-duration:3s; animation-duration:3s; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
/* Bounce animation */
@-webkit-keyframes bounce {
	0%, 20%, 50%, 80%, 100% {-webkit-transform: translateY(0);}
	40% {-webkit-transform: translateY(-7px);}
	60% {-webkit-transform: translateY(-4px);}
}
@keyframes bounce {
	0%, 20%, 50%, 80%, 100% {transform: translateY(0);}
	40% {transform: translateY(-7px);}
	60% {transform: translateY(-4px);}
}
.bounce {-webkit-animation-name:bounce; animation-name:bounce; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">

function Left(str, n){
if (n <= 0)
    return "";
else if (n > String(str).length)
    return str;
else
    return String(str).substring(0,n);
}

function Right(str, n){
    if (n <= 0)
       return "";
    else if (n > String(str).length)
       return str;
    else {
       var iLen = String(str).length;
       return String(str).substring(iLen, iLen - n);
    }
}

	function sendval() {
		<% If IsUserLoginOK Then %>
			<% If getnowdate>="2014-09-02" and getnowdate<"2014-09-10" Then %>
				<% if totalmysubscriptcount < 2 then %>
					<% if myisusingsubscriptcount = 0 then %>
				   		//evtfrm.mode.value="eventreg";
						//evtfrm.action="/apps/appcom/wish/webview/event/etc/doEventSubscript54591.asp";
						//evtfrm.target="evtFrmProc";
						//evtfrm.submit();

						var str = $.ajax({
							type: "GET",
							url: "/apps/appcom/wish/webview/event/etc/doEventSubscript54591.asp",
							data: "mode=eventreg",
							dataType: "text",
							async: false
						}).responseText;
						if (str==''){
							alert('정상적인 경로가 아닙니다');
							return;
						}else{
							if (String(str).length=='3'){
								//당첨
								if (Right(str,1)=='O'){
									$("#resultval").attr("src","http://webimage.10x10.co.kr/eventIMG/2014/54591/img_cissors_"+ Left(str,2) +".gif");
									setTimeout("alert('당첨!! 참여해 주셔서 감사합니다.'); top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid=<%= getevt_codepage %>'",500) 
								//꽝
								}else{
									$("#resultval").attr("src","http://webimage.10x10.co.kr/eventIMG/2014/54591/img_lose_"+ Left(str,2) +".gif");
									setTimeout("alert('꽝!! 다음기회에 도전해 주세요.'); top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid=<%= getevt_codepage %>'",500) 
								}
							}else{
								alert('정상적인 값이 아닙니다');
								return;
							}								
						}
						
					<% else %>
						alert("이미 응모 하셨습니다. 카카오톡 친구초대시 한번더 응모 하실수 있습니다.");
						return;
					<% end if %>
				<% else %>
					alert("하루에 두번까지만 참여가 가능합니다.");
					return;
				<% end if %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>
		<% Else %>
			calllogin();
			return;
		<% End If %>
    }

	Kakao.init('c967f6e67b0492478080bcf386390fdd');
	
	function kakaosendcall(){
		<% If IsUserLoginOK Then %>
			<% If getnowdate>="2014-09-02" and getnowdate<"2014-09-10" Then %>
				<% if totalmysubscriptcount < 2 then %>
					<% if totalmysubscriptcount > 0 then %>
						<% if myisusingsubscriptcount > 0 then %>
					   		evtfrm.mode.value="kakaoreg";
							evtfrm.action="/apps/appcom/wish/webview/event/etc/doEventSubscript54591.asp";
							evtfrm.target="evtFrmProc";
							evtfrm.submit();
						<% else %>
							alert("카카오톡 친구 참여는 1회만 가능 합니다.");
							return;
						<% end if %>
					<% else %>
						alert("응모를 먼저 해주세요.");
						return;
					<% end if %>
				<% else %>
					alert("하루에 두번까지만 참여가 가능합니다.");
					return;
				<% end if %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>
		<% Else %>
			calllogin();
			return;
		<% End If %>
	
		kakaosend54471();
	}
	
	function kakaosend54471(){
		  Kakao.Link.sendTalkLink({
			  label: '[텐바이텐 EVENT]친구야 매일 매일 한가위만 같아라!\n지금 이벤트에 참여하시면 행운의 선물이 가득!',
			  image: {
				src: 'http://imgstatic.10x10.co.kr/offshop/temp/2014/201408/121.jpg',
				width: '200',
				height: '200'
			  },
			 appButton: {
				text: '10X10 앱으로 이동',
				execParams :{
				<% IF application("Svr_Info") = "Dev" THEN %>
					android: { url: encodeURIComponent('http://testm.10x10.co.kr:8080/apps/appCom/wish/webview/event/eventmain.asp?eventid=<%= getevt_codepage %>')},
					iphone: { url: 'http://testm.10x10.co.kr:8080/apps/appCom/wish/webview/event/eventmain.asp?eventid=<%= getevt_codepage %>'}
				<% Else %>
					android: { url: encodeURIComponent('http://m.10x10.co.kr/apps/appCom/wish/webview/event/eventmain.asp?eventid=<%= getevt_codepage %>')},
					iphone: { url: 'http://m.10x10.co.kr/apps/appCom/wish/webview/event/eventmain.asp?eventid=<%= getevt_codepage %>'}
				<% End If %>
				}
			  },
			  installTalk : Boolean
		  });
	}
	
</script>
</head>
<body class="event">

<!--기승전쇼핑! -->
<div class="mEvt54591">
	<div class="hangawi">
		<div class="section heading">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_continue.gif" alt="추석 연휴에도 텐바이텐의 즐거움은 계속되어야 한다!" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_hangawi.png" alt="매일 매일 한가위만 같아라!" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_event.png" alt="매일 텐바이텐에 방문하여 같은 종류의 가위 3개를 맞춰보세요. 매일 매일 한가위만 같으면, 행운의 선물을 드립니다. 이벤트 기간은 09월 02일부터 09월 09일까지며, 기프티콘은 9월 11일날 일괄발송됩니다." /></p>
			<span class="moon animated shake"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_moon_cloud.png" alt="" /></span>
		</div>

		<!-- 출석체크 -->
		<div class="section game">
			<!-- 탭 -->
			<div class="tab-attend">
				<ul>
					<li>
						<% ' for dev msg : 해당일자는 _on.png이며, 해당일자가 지나면 _off.png로 바꿔주세요.  %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_date_01<% if getnowdate="2014-09-02" then %>_on<% else %>_off<% end if %>.png" alt="9월 2일" />

						<%' for dev msg : 당첨여부 %>
						<% if isarray(mysubscriptarr) then %>
							<div class="win">
								<% for i = 0 to ubound(mysubscriptarr,2) %>
									<% if mysubscriptarr(0,i)="2014-09-02" then %>
										<% if mysubscriptarr(1,i)="1" then %>
											<em><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_win.png" alt="당첨" /></em>
										<% else %>
											<em><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_lose.png" alt="꽝!" /></em>
										<% end if %>
									<% end if %>
								<% next %>
							</div>
						<% end if %>
					</li>
					<li>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_date_02<% if getnowdate="2014-09-03" then %>_on<% else %>_off<% end if %>.png" alt="9월 3일" />

						<% if isarray(mysubscriptarr) then %>
							<div class="win">
								<% for i = 0 to ubound(mysubscriptarr,2) %>
									<% if mysubscriptarr(0,i)="2014-09-03" then %>
										<% if mysubscriptarr(1,i)="1" then %>
											<em><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_win.png" alt="당첨" /></em>
										<% else %>
											<em><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_lose.png" alt="꽝!" /></em>
										<% end if %>
									<% end if %>
								<% next %>
							</div>
						<% end if %>
					</li>
					<li>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_date_03<% if getnowdate="2014-09-04" then %>_on<% else %>_off<% end if %>.png" alt="9월 4일" />

						<% if isarray(mysubscriptarr) then %>
							<div class="win">
								<% for i = 0 to ubound(mysubscriptarr,2) %>
									<% if mysubscriptarr(0,i)="2014-09-04" then %>
										<% if mysubscriptarr(1,i)="1" then %>
											<em><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_win.png" alt="당첨" /></em>
										<% else %>
											<em><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_lose.png" alt="꽝!" /></em>
										<% end if %>
									<% end if %>
								<% next %>
							</div>
						<% end if %>
					</li>
					<li>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_date_04<% if getnowdate="2014-09-05" then %>_on<% else %>_off<% end if %>.png" alt="9월 5일" />

						<% if isarray(mysubscriptarr) then %>
							<div class="win">
								<% for i = 0 to ubound(mysubscriptarr,2) %>
									<% if mysubscriptarr(0,i)="2014-09-05" then %>
										<% if mysubscriptarr(1,i)="1" then %>
											<em><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_win.png" alt="당첨" /></em>
										<% else %>
											<em><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_lose.png" alt="꽝!" /></em>
										<% end if %>
									<% end if %>
								<% next %>
							</div>
						<% end if %>
					</li>
					<li>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_date_05<% if getnowdate="2014-09-06" then %>_on<% else %>_off<% end if %>.png" alt="9월 6일" />

						<% if isarray(mysubscriptarr) then %>
							<div class="win">
								<% for i = 0 to ubound(mysubscriptarr,2) %>
									<% if mysubscriptarr(0,i)="2014-09-06" then %>
										<% if mysubscriptarr(1,i)="1" then %>
											<em><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_win.png" alt="당첨" /></em>
										<% else %>
											<em><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_lose.png" alt="꽝!" /></em>
										<% end if %>
									<% end if %>
								<% next %>
							</div>
						<% end if %>
					</li>
					<li>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_date_06<% if getnowdate="2014-09-07" then %>_on<% else %>_off<% end if %>.png" alt="9월 7일" />

						<% if isarray(mysubscriptarr) then %>
							<div class="win">
								<% for i = 0 to ubound(mysubscriptarr,2) %>
									<% if mysubscriptarr(0,i)="2014-09-07" then %>
										<% if mysubscriptarr(1,i)="1" then %>
											<em><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_win.png" alt="당첨" /></em>
										<% else %>
											<em><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_lose.png" alt="꽝!" /></em>
										<% end if %>
									<% end if %>
								<% next %>
							</div>
						<% end if %>
					</li>
					<li>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_date_07<% if getnowdate="2014-09-08" then %>_on<% else %>_off<% end if %>.png" alt="9월 8일" />

						<% if isarray(mysubscriptarr) then %>
							<div class="win">
								<% for i = 0 to ubound(mysubscriptarr,2) %>
									<% if mysubscriptarr(0,i)="2014-09-08" then %>
										<% if mysubscriptarr(1,i)="1" then %>
											<em><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_win.png" alt="당첨" /></em>
										<% else %>
											<em><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_lose.png" alt="꽝!" /></em>
										<% end if %>
									<% end if %>
								<% next %>
							</div>
						<% end if %>
					</li>
					<li>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tab_date_08<% if getnowdate="2014-09-09" then %>_on<% else %>_off<% end if %>.png" alt="9월 9일" />

						<% if isarray(mysubscriptarr) then %>
							<div class="win">
								<% for i = 0 to ubound(mysubscriptarr,2) %>
									<% if mysubscriptarr(0,i)="2014-09-09" then %>
										<% if mysubscriptarr(1,i)="1" then %>
											<em><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_win.png" alt="당첨" /></em>
										<% else %>
											<em><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_lose.png" alt="꽝!" /></em>
										<% end if %>
									<% end if %>
								<% next %>
							</div>
						<% end if %>
					</li>
				</ul>
				<div class="line"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_line.gif" alt="" /></div>
			</div>

			<!-- 슬롯머신 -->
			<div class="slot">
				<div class="ani"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_slot.gif" alt="" /></div>
				<%' for dev msg : 당첨이미지 랜딩으로 보이게 해주세요 %>
				<div class="result">
					<% if isarray(mysubscriptresultval) then %>
						<% for i = 0 to ubound(mysubscriptresultval,2) %>
							<%
							'//카카오톡 응모시 리셋처리
							if myisusingsubscriptcount>0 then
							%>
								<% if mysubscriptresultval(1,i)="1" then %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_cissors_<%= mysubscriptresultval(2,i) %>.gif" id="resultval" alt="당첨되었습니다." />
								<% else %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_lose_<%= mysubscriptresultval(2,i) %>.gif" id="resultval" alt="다음기회에." />
								<% end if %>
							<% else %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_slot.gif" id="resultval" alt="" />								
							<% end if %>
						<% next %>
					<% else %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_slot.gif" id="resultval" alt="" />
					<% end if %>
				</div>
				<div class="btnPush"><a href="" onclick="sendval(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/btn_push.png" alt="한가위만 같아라!" /></a></div>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_check_phone_num.gif" alt="※ 잠깐! 고객님 휴대전화번호를 올바르게 설정해주세요." /></p>
			</div>
		</div>

		<!-- 기프트 -->
		<div class="section hangawi-gift">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tit_gift.gif" alt="한가위 GIFT" /></h2>
			<ul>
				<li>
					<%' for dev msg : 해당 일자가 되면 투데이 붙여주세요 %>
					<% if getnowdate="2014-09-02" then %>
						<span class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_today.png" alt="투데이" /></span>
					<% end if %>

					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_gift_01.png" alt="9월 2일 화요일 스타벅스 아이스 아메리카노 150명" />
					
					<%' for dev msg : 참여일자가 지나면 style="display:block;" 붙여주세요 %>
					<span class="close" <% if getnowdate>"2014-09-02" then %>style="display:block;"<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_close.png" alt="참여마감" /></span>
				</li>
				<li>
					<% if getnowdate="2014-09-03" then %>
						<span class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_today.png" alt="투데이" /></span>
					<% end if %>

					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_gift_02.png" alt="9월 3일 수요일 배스킨라빈스 싱글레귤러 200명" />
					<span class="close" <% if getnowdate>"2014-09-03" then %>style="display:block;"<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_close.png" alt="참여마감" /></span>
				</li>
				<li>
					<% if getnowdate="2014-09-04" then %>
						<span class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_today.png" alt="투데이" /></span>
					<% end if %>

					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_gift_03.png" alt="9월 4일 목요일 KFC 스마트초이스 100명" />
					<span class="close" <% if getnowdate>"2014-09-04" then %>style="display:block;"<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_close.png" alt="참여마감" /></span>
				</li>
				<li>
					<% if getnowdate="2014-09-05" then %>
						<span class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_today.png" alt="투데이" /></span>
					<% end if %>
				
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_gift_04.png" alt="9월 5일 금요일 CGV 주말예매권 50명" />
					<span class="close" <% if getnowdate>"2014-09-05" then %>style="display:block;"<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_close.png" alt="참여마감" /></span>
				</li>
				<li>
					<% if getnowdate="2014-09-06" then %>
						<span class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_today.png" alt="투데이" /></span>
					<% end if %>
				
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_gift_05.png" alt="9월 6일 토요일 배스킨라빈스 파인트 50명" />
					<span class="close" <% if getnowdate>"2014-09-06" then %>style="display:block;"<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_close.png" alt="참여마감" /></span>
				</li>
				<li>
					<% if getnowdate="2014-09-07" then %>
						<span class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_today.png" alt="투데이" /></span>
					<% end if %>

					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_gift_06.png" alt="9월 7일 일요일 콜드스톤 러브잇 100명" />
					<span class="close" <% if getnowdate>"2014-09-07" then %>style="display:block;"<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_close.png" alt="참여마감" /></span>
				</li>
				<li>
					<% if getnowdate="2014-09-08" then %>
						<span class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_today.png" alt="투데이" /></span>
					<% end if %>

					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_gift_07.png" alt="9월 8일 월요일 롯데리아 한우불고기 콤보 100명" />
					<span class="close" <% if getnowdate>"2014-09-08" then %>style="display:block;"<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_close.png" alt="참여마감" /></span>
				</li>
				<li>
					<% if getnowdate="2014-09-09" then %>
						<span class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_today.png" alt="투데이" /></span>
					<% end if %>

					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_gift_08.png" alt="9월 9일 화요일 텐바이텐 1만원 기프트카드 50명" />
					<span class="close" <% if getnowdate>"2014-09-09" then %>style="display:block;"<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_close.png" alt="참여마감" /></span>
				</li>
			</ul>
		</div>

		<!-- 카카오톡 -->
		<div class="section kakao">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tit_kakao.gif" alt="한가위를 못 맞추셨나요? 실망하지 마세요!" /></h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_kakao.gif" alt="친구에게 카카오톡으로 이벤트를 알려주시면 한번의 기회를 더 얻을 수 있습니다. ※ 1일 1회 추가 기회가 주어집니다." /></p>
			<div class="btnKakao animated flash"><a href="" onclick="kakaosendcall(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/btn_kakao.png" alt="친구에게 카카오톡 보내기" /></a></div>
		</div>

		<div class="section noti">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tit_noti.gif" alt="이벤트 유의사항" /></h2>
			<ul>
				<li>텐바이텐에서 로그인 후 이벤트 참여가 가능합니다.</li>
				<li>이벤트 참여는 텐바이텐 APP을 통해 1일 1회 가능합니다.</li>
				<li>응모전 본인 휴대전화번호를 올바르게 수정해주세요. (개인정보&gt;휴대전화 기준으로 발송)</li>
				<li>카카오톡으로 친구에게 메시지를 보내면 1일 1회 추가기회가 주어집니다.</li>
				<li>기프티콘 발행은 9월 11일 (목) 일괄발송 됩니다.</li>
				<li>사은품 발송을 위해 개인정보를 요청할 수 있습니다.</li>
			</ul>
		</div>

		<div class="section tab-area">
			<strong class="animated bounce"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_wellorganized_shopping.png" alt="아침 드라마보다 더 극적인 기승전 쇼핑" /></strong>
			<ul class="tab-nav">
				<!-- #include virtual="/apps/appCom/wish/webview/event/etc/iframe_54471_topmenu.asp" -->
			</ul>
		</div>
	</div>
</div>
<!-- //기승전쇼핑 -->
<form name="evtfrm" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->