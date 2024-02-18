<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 기승전 2차 매일 매일 한가위만 같아라
' History : 2014.08.29 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/etc/event54589Cls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

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

<!-- #include virtual="/lib/inc/head.asp" -->

<style type="text/css">
.mEvt54590 {border-bottom:2px solid #9e2020;}
.mEvt54590 img {vertical-align:top; width:100%;}
.mEvt54590 p {max-width:100%;}
.hangawi .section, .hangawi .section h3 {margin:0; padding:0;}
.hangawi .heading {position:relative;}
.hangawi .heading {padding:7% 0; background-color:#fff6e0; text-align:center;}
.hangawi .heading p {position:relative; z-index:10;}
.hangawi .heading p:nth-child(1) img {width:79.375%;}
.hangawi .heading p:nth-child(2) {margin-top:2%;}
.hangawi .heading p:nth-child(2) img {width:79.375%;}
.hangawi .heading p:nth-child(3) {margin-top:5%;}
.hangawi .heading p:nth-child(3) img {width:79.375%;}
.hangawi .heading .moon {position:absolute; top:20%; left:0; z-index:5; width:100%;}
.hangawi .slot {padding-bottom:6%; background-color:#ffe186;}
.hangawi .hangawi-gift {padding-bottom:8%; background-color:#fff1ce;}
.hangawi .hangawi-gift ul {overflow:hidden; padding:3% 5% 0;}
.hangawi .hangawi-gift ul li {position:relative; float:left; width:44%; margin:0 3% 5%;}
.hangawi .hangawi-gift ul li .close {display:none; position:absolute; left:0; top:0; width:100%;}
.hangawi .hangawi-gift ul li .today {position:absolute; left:34%; top:-1%; width:30%;}
.hangawi .hangawi-gift .btnApp {margin:0 25%;}
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
</head>
<body>

<!-- 기승전쇼핑! -->
<div class="mEvt54590">
	<div class="hangawi">
		<div class="section heading">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_continue.gif" alt="추석 연휴에도 텐바이텐의 즐거움은 계속되어야 한다!" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_hangawi.png" alt="매일 매일 한가위만 같아라!" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_event.png" alt="매일 텐바이텐에 방문하여 같은 종류의 가위 3개를 맞춰보세요. 매일 매일 한가위만 같으면, 행운의 선물을 드립니다. 이벤트 기간은 09월 02일부터 09월 09일까지며, 기프티콘은 9월 11일날 일괄발송됩니다." /></p>
			<span class="moon animated shake"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_moon_cloud.png" alt="" /></span>
		</div>

		<div class="section slot">
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/54590/img_wave.gif" alt="" />
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_slot.gif" alt="" />
		</div>

		<!-- 기프트 -->
		<div class="section hangawi-gift">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tit_gift.gif" alt="한가위 GIFT" /></h3>
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
					<%' for dev msg : 해당 일자가 되면 투데이 붙여주세요 %>
					<% if getnowdate="2014-09-03" then %>
						<span class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_today.png" alt="투데이" /></span>
					<% end if %>

					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_gift_02.png" alt="9월 3일 수요일 배스킨라빈스 싱글레귤러 200명" />

					<span class="close" <% if getnowdate>"2014-09-03" then %>style="display:block;"<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_close.png" alt="참여마감" /></span>
				</li>
				<li>
					<%' for dev msg : 해당 일자가 되면 투데이 붙여주세요 %>
					<% if getnowdate="2014-09-04" then %>
						<span class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_today.png" alt="투데이" /></span>
					<% end if %>

					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_gift_03.png" alt="9월 4일 목요일 KFC 스마트초이스 100명" />

					<span class="close" <% if getnowdate>"2014-09-04" then %>style="display:block;"<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_close.png" alt="참여마감" /></span>
				</li>
				<li>
					<%' for dev msg : 해당 일자가 되면 투데이 붙여주세요 %>
					<% if getnowdate="2014-09-05" then %>
						<span class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_today.png" alt="투데이" /></span>
					<% end if %>

					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_gift_04.png" alt="9월 5일 금요일 CGV 주말예매권 50명" />

					<span class="close" <% if getnowdate>"2014-09-05" then %>style="display:block;"<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_close.png" alt="참여마감" /></span>
				</li>
				<li>
					<%' for dev msg : 해당 일자가 되면 투데이 붙여주세요 %>
					<% if getnowdate="2014-09-06" then %>
						<span class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_today.png" alt="투데이" /></span>
					<% end if %>

					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_gift_05.png" alt="9월 6일 토요일 배스킨라빈스 파인트 50명" />

					<span class="close" <% if getnowdate>"2014-09-06" then %>style="display:block;"<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_close.png" alt="참여마감" /></span>
				</li>
				<li>
					<%' for dev msg : 해당 일자가 되면 투데이 붙여주세요 %>
					<% if getnowdate="2014-09-07" then %>
						<span class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_today.png" alt="투데이" /></span>
					<% end if %>

					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_gift_06.png" alt="9월 7일 일요일 콜드스톤 러브잇 100명" />

					<span class="close" <% if getnowdate>"2014-09-07" then %>style="display:block;"<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_close.png" alt="참여마감" /></span>
				</li>
				<li>
					<%' for dev msg : 해당 일자가 되면 투데이 붙여주세요 %>
					<% if getnowdate="2014-09-08" then %>
						<span class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_today.png" alt="투데이" /></span>
					<% end if %>

					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_gift_07.png" alt="9월 8일 월요일 롯데리아 한우불고기 콤보 100명" />
					
					<span class="close" <% if getnowdate>"2014-09-08" then %>style="display:block;"<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_close.png" alt="참여마감" /></span>
				</li>
				<li>
					<%' for dev msg : 해당 일자가 되면 투데이 붙여주세요 %>
					<% if getnowdate="2014-09-09" then %>
						<span class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/ico_tag_today.png" alt="투데이" /></span>
					<% end if %>

					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/img_gift_08.png" alt="9월 9일 화요일 텐바이텐 1만원 기프트카드 50명" />

					<span class="close" <% if getnowdate>"2014-09-09" then %>style="display:block;"<% end if %>><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_close.png" alt="참여마감" /></span>
				</li>
			</ul>
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/54590/img_line.gif" alt="" />

			<div class="btnApp"><a href="/apps/link/?920140826" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54590/btn_go_app.png" alt="" /></a></div>
		</div>

		<div class="section noti">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tit_noti.gif" alt="이벤트 유의사항" /></h3>
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
				<!-- #include virtual="/event/etc/iframe_54469_topmenu.asp" -->
			</ul>
		</div>
	</div>
</div>
<!-- //기승전쇼핑! -->

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->