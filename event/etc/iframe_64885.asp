<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 미니언즈가 텐바이텐에 떴다!
' History : 2015-07-13 원승현
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
'Dim prveCode
dim eCode, vUserID, userid, myuserLevel, vPageSize, vPage, sqlStr, vTotalCount, vTotalSum, eLinkCode, prvCount, prvTotalcount, tempNum
	vUserID = GetLoginUserID()
	myuserLevel = GetLoginUserLevel
	userid = vUserID

	Dim vQuery, vCount, commentcount

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64827"
	Else
		eCode = "64885"
	End If
%>

<style type="text/css">
img {vertical-align:top;}

.mEvt64885 button {background-color:transparent;}
.mEvt64885 .card {padding-bottom:8%; background-color:#ffdd00;}
.mEvt64885 .btnapp {width:89.84%; margin:0 auto;}

.movie {padding-bottom:9%; background-color:#50c8e8;}
.movie .youtubewrap {width:91.2%; padding:1.4%; margin:0 auto; background:#fff;}
.movie .youtube {overflow:hidden; position:relative; height:0; padding-bottom:56.25%;}
.movie .youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%;}

.noti {position:relative; padding:5% 7.8% 0;}
.noti h3 {color:#000; font-size:14px;}
.noti h3 strong {padding-bottom:2px; border-bottom:2px solid #000;}
.noti ul {margin-top:20px}
.noti ul li {position:relative; margin-top:2px; padding-left:7px; color:#464646; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:3px; left:0; width:0; height:0; border-top:4px solid transparent; border-bottom:4px solid transparent; border-left:4px solid #d60000;}

.item {background-color:#ffdd00;}
.item ul {padding:0 7.3%;}
.item ul li {position:relative; margin-top:7%; padding:8% 1.83% 5%; border-bottom:5px dotted #c1a700;}
.item ul li:first-child {margin-top:0;}
.item ul li:last-child {margin-top:5%; border-bottom:none;}
.item ul li .soldout {position:absolute; top:1%; left:0; width:100%;}
.item ul li:nth-child(2) {margin-top:2%;}
.item ul li:nth-child(2) .soldout {top:6%;}
.item ul li:last-child .soldout {top:5%;}

@media all and (min-width:480px){
	.noti h3 {font-size:17px;}
	.noti ul {margin-top:30px;}
	.noti ul li {margin-top:4px; padding-left:12px; font-size:13px;}
	.noti ul li:after {top:5px;}
}

@media all and (min-width:600px){
	.noti h3 {font-size:20px;}
	.noti ul li {margin-top:6px; padding-left:20px; font-size:16px;}
	.noti ul li:after {top:5px; border-top:6px solid transparent; border-bottom:6px solid transparent; border-left:6px solid #d60000;}
}
</style>


<%' 이벤트 배너 등록 영역 %>
<div class="evtCont">

	<!-- [M] 미니언즈 -->
	<div class="mEvt64885">
		<div class="card">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/tit_minions.png" alt="텐바이텐X미니언즈 총 천명에게 선물을 쏜다!" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64885/m/txt_meet.png" alt="텐바이텐 앱에서 카드를 고르고 당신의 미니언즈를 만나보세요. 총 1,000명에게는 미니언즈 선물의 행운까지!" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64885/m/img_gift.jpg" alt="총 백명에게는 미니언즈 선물이! 피규어, 쇼퍼백, 우산, 영화 전용 예매권까지 다양한 선물이 준비되어 있어요!" /></p>
			<%' for dev msg : 앱 %>
			<div class="btnapp"><a href="http://m.10x10.co.kr/apps/link/?7720150713" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64885/m/btn_app.png" alt="텐바이텐에서 참여하기" /></a></div>
		</div>

		<div class="movie">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/64885/m/tit_preview.png" alt="미니언즈 예고편" /></h3>
			<div class="youtubewrap">
				<div class="youtube">
					<iframe src="https://www.youtube.com/embed/Fjr2-f5ZfSo?list=PLFatQWnQA_1oEkeVXYQN3gZK3bUAQ_uRI" frameborder="0" title="미니언즈 예고편" allowfullscreen></iframe>
				</div>
			</div>
		</div>

		<div class="noti">
			<h3><strong>유 의 사 항</strong></h3>
			<ul>
				<li>텐바이텐 고객 대상 이벤트 입니다.</li>
				<li>한 ID 당 하루 한 번 참여하실 수 있습니다.</li>
				<li>경품 배송지는 2015년 7월 22일 수요일부터 3일간 확인해주세요.</li>
				<li>경품은 배송지 입력 후 1주일 안에 출고됩니다.</li>
				<li>당첨 경품은 내부 사정에 의해 변경될 수 있습니다.</li>
			</ul>
		</div>

		<div class="item">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/tit_item.png" alt="취향저격 귀여움폭발 미니언즈 굿즈도 둘러 보세요!" /></h3>
			<ul>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=1316654">
						<figure><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/img_item_04.jpg" alt="미니언 플레이세트 나는 핫도그 미니언 &amp; 스쿠터 탈출 미니언" /></figure>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=1316653">
						<figure><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/img_item_03.jpg" alt="미니언 무비팩 눈싸움 하는 미니언 &amp; 엉뚱한 tv와 노는 미니언" /></figure>
						<strong class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/txt_soldout.png" alt="솔드아웃" /></strong>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=1316651">
						<figure><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/img_item_01.jpg" alt="미니언 미스테리팩 2 12가지 영화 속 테마로 연출된 미니언 블록 피규어!" /></figure>
						<strong class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/txt_soldout.png" alt="솔드아웃" /></strong>
					</a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=1316652">
						<figure><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/img_item_02.jpg" alt="미니언 미스테리팩 3 미리 겨울을 준비하는 패셔니스타 미니언즈 피규어!" /></figure>
						<strong class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/txt_soldout.png" alt="솔드아웃" /></strong>
					</a>
				</li>
			</ul>
		</div>

	</div>
	
</div>
<%'// 이벤트 배너 등록 영역 %>

<!-- #include virtual="/lib/db/dbclose.asp" -->