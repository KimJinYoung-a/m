<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description : ##What's your 미니언즈?
' History : 2015-07-13 원승현 생성
'####################################################
	Dim vUserID, eCode, cMil, vMileValue, vMileArr
	Dim couponidx
	Dim totalbonuscouponcount, vNowDate

	'// 로그인 한 유저 아이디 긁어옴
	vUserID = GetLoginUserID

	'// 현재일자값
	vNowDate = Left(Now(), 10)

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64826"
	Else
		eCode = "64805"
	End If

	Dim strSql , totcnt
	'// 일자별 응모여부(일자별로 1회만 참여가능)
	strSql = "select count(*) from db_event.dbo.tbl_event_subscript where userid = '"& vUserID &"' and evt_code = '"& ecode &"' And convert(varchar(10), regdate, 120) = '"&vNowDate&"' " 
	rsget.Open strSql,dbget,adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		totcnt = rsget(0)
	End IF
	rsget.close()


%>
<style type="text/css">
img {vertical-align:top;}

.mEvt64805 button {background-color:transparent;}
.mEvt64805 .card {background-color:#ffdd00;}
.mEvt64805 .card .hidden {visibility:hidden; width:0; height:0;}

.card {overflow:hidden; padding-bottom:8%;}
.cardSelect {position:relative; margin:0 8%; padding:37% 0 20%;}
.cardSelect li {position:absolute; width:30%; transition:all 0.5s ease-in-out; -webkit-transition:all 0.5s ease-in-out;}
.cardSelect li button {width:100%; outline:none; cursor:pointer;}
.cardSelect li.card1, .cardSelect li.card3, .cardSelect li.card5 {background:url(http://webimage.10x10.co.kr/eventIMG/2015/64805/img_card_grey.png) no-repeat 50%; background-size:100% auto;}
.cardSelect li.card2, .cardSelect li.card4 {background:url(http://webimage.10x10.co.kr/eventIMG/2015/64805/img_card_grey.png) no-repeat 50%; background-size:100% auto;}
.cardSelect li.grey {background:url(http://webimage.10x10.co.kr/eventIMG/2015/64805/img_card_grey.png) no-repeat 50%; background-size:100% auto;}
.cardSelect li.card1.on,
.cardSelect li.card3.on,
.cardSelect li.card5.on {background:url(http://webimage.10x10.co.kr/eventIMG/2015/64805/img_card_sky.png) no-repeat 50%; background-size:100% auto;}
.cardSelect li.card2.on,
.cardSelect li.card4.on {background:url(http://webimage.10x10.co.kr/eventIMG/2015/64805/img_card_blue.png) no-repeat 50%; background-size:100% auto;}

.cardSelect li.card1 {top:27%; left:1%; z-index:3; transform: rotate(-20deg); -webkit-transform: rotate(-20deg);}
.cardSelect li.card2 {top:10%; left:18%; z-index:2; transform: rotate(-10deg); -webkit-transform: rotate(-10deg);}
.cardSelect li.card3 {top:15%; left:50%; z-index:3; margin-left:-12.5%; transform: rotate(5deg); -webkit-transform: rotate(5deg);}
.cardSelect li.card4 {top:10%; right:13%; z-index:2; transform: rotate(15deg); -webkit-transform: rotate(15deg);}
.cardSelect li.card5 {top:25%; right:1%; z-index:1; transform: rotate(20deg); -webkit-transform: rotate(20deg);}
.cardSelect li:active, .cardSelect li:hover {z-index:4;}
.cardSelect li.card1:active, .card li.card1:hover {transform:rotate(-25deg) scale(1.1); -webkit-transform:rotate(-25deg) scale(1.1);}
.cardSelect li.card2:active, .card li.card2:hover {transform:rotate(-8deg) scale(1.1); -webkit-transform:rotate(-8deg) scale(1.1);}
.cardSelect li.card3:active, .card li.card3:hover {transform:rotate(5deg) scale(1.1); -webkit-transform:rotate(5deg) scale(1.1);}
.cardSelect li.card4:active, .card li.card4:hover {transform:rotate(-8deg) scale(1.1); -webkit-transform:rotate(8deg) scale(1.1);}
.cardSelect li.card5:active, .card li.card5:hover {transform:rotate(25deg) scale(1.1); -webkit-transform:rotate(25deg) scale(1.1);}
.card .btncard {display:block; width:54.5%; margin:0 auto;}

/* layer */
.layer {display:none; position:absolute; top:2%; left:50%; z-index:250; width:93.4%; margin-left:-46.7%;}
.layer .inner {position:relative; padding-top:1.5%;}
.layer .btnclose {position:absolute; bottom:3.8%; left:50%; width:41.3%; margin-left:-20.65%;}
.mask {display:none; position:absolute; top:0; left:0; z-index:200; width:100%; height:100%; background:rgba(0,0,0,.5);}

.movie {padding-bottom:9%; background-color:#ffdd00;}
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
<script type="text/javascript">


function fnClosemask()
{
	$('.mask').hide();
	$("#rtp").empty();
	document.location.reload();
}


function checkform(){

	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			parent.calllogin();
			return false;
		}
	<% End If %>

	<% If vUserID <> "" Then %>
		<% If totcnt >= 1 then %>
			alert("이미 참여하셨습니다..\n내일 다시 참여해주세요.");
			document.location.reload();
			return false;
		<% Else %>
			if ( $(".cardSelect li").hasClass("on")) {
				$.ajax({
					type:"GET",
					url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript64805.asp",
					dataType: "text",
					async:false,
					cache:true,
					success : function(Data, textStatus, jqXHR){
						if (jqXHR.readyState == 4) {
							if (jqXHR.status == 200) {
								if(Data!="") {
									var str;
									for(var i in Data)
									{
										 if(Data.hasOwnProperty(i))
										{
											str += Data[i];
										}
									}
									str = str.replace("undefined","");
									res = str.split("|");
									if (res[0]=="OK")
									{
										$("#rtp").empty().html(res[1]);
										$(".mask").show();
										$("#rtp").show();
										$('html,body').animate({scrollTop:120}, 800);
									}
									else
									{
										errorMsg = res[1].replace(">?n", "\n");
										alert(errorMsg );
										$(".mask").hide();
										document.location.reload();
										return false;
									}
								} else {
									alert("잘못된 접근 입니다.");
									document.location.reload();
									return false;
								}
							}
						}
					},
					error:function(jqXHR, textStatus, errorThrown){
						alert("잘못된 접근 입니다.");
						//var str;
						//for(var i in jqXHR)
						//{
						//	 if(jqXHR.hasOwnProperty(i))
						//	{
						//		str += jqXHR[i];
						//	}
						//}
						//alert(str);
						document.location.reload();
						return false;
					}
				});
			}
			else
			{
				alert("카드를 선택해 주세요.");
				return;
			}
		 <% End If %>
	<% End If %>
}
</script>

<%' 이벤트 배너 등록 영역 %>
<div class="evtCont">

	<%' [APP] %>
	<div class="mEvt64805">
		<div class="card">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/tit_minions.png" alt="텐바이텐X미니언즈 총 천명에게 선물을 쏜다!" /></p>
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/tit_select.png" alt="한 장의 카드를 선택해주세요!" /></h3>
			<p class="hidden">당신의 미니언즈를 확인하고 선물도 받을 수 있어요. 하루 1회 응모 하실 수 있습니다</p>
			<ul class="cardSelect">
				<li class="card1"><button type="button"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/img_card_area.png" alt="" /></button><li>
				<li class="card2"><button type="button"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/img_card_area.png" alt="" /></button><li>
				<li class="card3"><button type="button"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/img_card_area.png" alt="" /></button><li>
				<li class="card4"><button type="button"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/img_card_area.png" alt="" /></button><li>
				<li class="card5"><button type="button"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/img_card_area.png" alt="" /></button><li>
			</ul>
			<button type="button" class="btncard" onclick="checkform();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_confirm.png" alt="결과 확인하기" /></button>
		</div>

		<%' for dev msg : layer %>
		<div id="rtp" class="layer"></div>

		<div class="gift">
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/img_gift.jpg" alt="" />
		</div>

		<div class="movie">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/tit_preview.png" alt="미니언즈 예고편" /></h3>
			<div class="youtubewrap">
				<div class="youtube">
					<iframe width="560" height="315" src="https://www.youtube.com/embed/Fjr2-f5ZfSo?list=PLFatQWnQA_1oEkeVXYQN3gZK3bUAQ_uRI" frameborder="0" allowfullscreen></iframe>
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
					<a href="" onclick="fnAPPpopupProduct('1316654'); return false;">
						<figure><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/img_item_04.jpg" alt="미니언 플레이세트 나는 핫도그 미니언 &amp; 스쿠터 탈출 미니언" /></figure>
					</a>
				</li>
				<li>
					<a href="" onclick="fnAPPpopupProduct('1316653'); return false;">
						<figure><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/img_item_03.jpg" alt="미니언 무비팩 눈싸움 하는 미니언 &amp; 엉뚱한 tv와 노는 미니언" /></figure>
						<strong class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/txt_soldout.png" alt="솔드아웃" /></strong>
					</a>
				</li>
				<li>
					<a href="" onclick="fnAPPpopupProduct('1316651'); return false;">
						<figure><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/img_item_01.jpg" alt="미니언 미스테리팩 2 12가지 영화 속 테마로 연출된 미니언 블록 피규어!" /></figure>
						<strong class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/txt_soldout.png" alt="솔드아웃" /></strong>
					</a>
				</li>
				<li>
					<a href="" onclick="fnAPPpopupProduct('1316652'); return false;">
						<figure><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/img_item_02.jpg" alt="미니언 미스테리팩 3 미리 겨울을 준비하는 패셔니스타 미니언즈 피규어!" /></figure>
						<strong class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64805/txt_soldout.png" alt="솔드아웃" /></strong>
					</a>
				</li>
			</ul>
		</div>

		<div class="mask"></div>
	</div>
	
</div>
<!--// 이벤트 배너 등록 영역 -->
<script type="text/javascript">
$(function(){
	
	$(".cardSelect li button").click(function(){
		if ( $(this).parent().hasClass("on")) {
			$(".cardSelect li").removeClass("on");
			$(this).parent().addClass("on");
		} else {
			$(".cardSelect li").removeClass("on");
			$(this).parent().addClass("on");
		}
	});

});
</script>

<!-- #include virtual="/lib/db/dbclose.asp" -->