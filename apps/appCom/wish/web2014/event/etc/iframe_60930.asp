<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
'### 셋콤달콤-지니편
'### 2015-04-08 유태욱
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	Dim eCode, vDisp, sqlstr, mycouponkey, mygienee, totalcnt
	Dim userid
	dim nowdate

	nowdate = date()
'	nowdate = "2015-04-14"

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  60743
	Else
		eCode   =  60930
	End If

	dim LoginUserid
	LoginUserid = getLoginUserid()

	''지니 당첨 이력 있는지 체크
	sqlstr = "select count(userid) as cnt "
	sqlstr = sqlstr & " from db_temp.dbo.tbl_3comdalcom_coupon_2015"
	sqlstr = sqlstr & " where userid='"& LoginUserid &"' and isusing='Y' and gubun='1'"
	rsget.Open sqlstr, dbget, 1

	If Not rsget.Eof Then
		mygienee = rsget(0)
	End IF
	rsget.close

	''내 지니쿠폰번호
	sqlstr = "select top 1 couponkey "
	sqlstr = sqlstr & " from db_temp.dbo.tbl_3comdalcom_coupon_2015"
	sqlstr = sqlstr & " where userid='"& LoginUserid &"' and isusing='Y' and gubun='1'"
	rsget.Open sqlstr, dbget, 1

	If Not rsget.Eof Then
		mycouponkey = rsget(0)
	End IF
	rsget.close

	sqlStr = "Select count(idx) " &_
			" From db_temp.dbo.tbl_3comdalcom_coupon_2015 " &_
			" WHERE convert(varchar(10),regdate,120) = '"& nowdate &"' and isnull(userid,'')<>'' "
	rsget.Open sqlStr,dbget,1
	totalcnt = rsget(0)
	rsget.Close

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<style type="text/css">
.threeSweets {position:relative;}
.threeSweets img {vertical-align:top;}
.threeSweets .todaygift {position:relative;}
.threeSweets .todaygift .soldout {position:absolute; left:0; top:-0.5%; width:100%; height:100.5%; background:rgba(0,0,0,.75); z-index:20;}
.threeSweets .todaygift .soldout p {padding-top:65%;}
.threeSweets .todaygift .date {position:absolute; left:0; top:0; width:100%; z-index:15;}
.threeSweets .applyEvt {padding-bottom:28px; background:#f4f7f7;}
.threeSweets .applyEvt .selectLamp {overflow:hidden; padding:0 4% 20px;}
.threeSweets .applyEvt .selectLamp li {float:left; width:33.33333%; padding:0 1%; text-align:center;}
.threeSweets .applyEvt .selectLamp li input {margin-top:8px;}
.threeSweets .applyEvt .applyBtn {width:80%; margin:0 auto;}
.threeSweets .applyEvt .viewNum {padding-top:25px;}
.threeSweets .evtNoti {padding:30px 10px;}
.threeSweets .evtNoti dt {color:#444; margin-bottom:15px;}
.threeSweets .evtNoti dt span {padding:0 10px; font-size:13px; line-height:1; font-weight:bold; border-left:2px solid #33e4b9; border-right:2px solid #33e4b9; vertical-align:top;}
.threeSweets .evtNoti li {position:relative; color:#444; font-size:11px; line-height:1.3; padding-left:13px; margin-top:4px;}
.threeSweets .evtNoti li:first-child {margin-top:0;}
.threeSweets .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:3px; width:2px; height:2px; border:2px solid #ffc101; border-radius:50%;}
.threeSweets .sweetTab {position:absolute; left:0; top:-15.5%; width:100%; padding:0 0 1% 3%;}
.threeSweets .sweetTab:after {content:' '; display:inline-block; position:absolute; left:0; top:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/60930/bg_tab_box.png) left top no-repeat; background-size:100% auto; z-index:10;}
.threeSweets .sweetTab ul {overflow:hidden; width:100%;}
.threeSweets .sweetTab li {position:relative; float:left; width:32.6%; z-index:40; z-index:40;}
.threeSweets .sweetTab li span {display:block; position:absolute; left:0; top:0; width:100%;}

/* 레이어팝업 */
.threeSweets .layerPopup {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.6); z-index:50;}
.threeSweets .layerCont {padding-top:12%;}
.threeSweets .layerPopup .btnClose {position:absolute; right:0.5%; top:1.5%; width:15%; cursor:pointer; z-index:45;}
.threeSweets .layerCont > div {position:relative;}
.threeSweets .layerCont .btnClose02 {position:absolute; left:20%; bottom:7%; width:60%; height:9%; color:transparent; cursor:pointer;}
.threeSweets .layerCont .genieMusic {position:relative;}
.threeSweets .layerCont .genieMusic span {display:inline-block; position:absolute; left:5%; bottom:26%; width:90%; color:#fff; font-size:24px; font-weight:bold; text-align:center; letter-spacing:-0.05em;}
.threeSweets .layerCont .genieMusic span strong {display:inline-block; padding:0 15px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/60930/blt_mark01.png), url(http://webimage.10x10.co.kr/eventIMG/2015/60930/blt_mark02.png); background-position:left top, right top; background-repeat:no-repeat; background-size:10px auto;}
.threeSweets .layerCont .genieMusic .btnClose02 {bottom:6%;}
.threeSweets .layerCont .freeDelivery {position:relative;}
.threeSweets .layerCont .freeDelivery a {display:inline-block; position:absolute; left:20%; bottom:14%; width:60%; height:10%; color:transparent;}

@media all and (min-width:480px){
	.threeSweets .applyEvt {padding-bottom:42px;}
	.threeSweets .applyEvt .selectLamp {padding:0 4% 30px;}
	.threeSweets .applyEvt .selectLamp li input {margin-top:12px;}
	.threeSweets .applyEvt .viewNum {padding-top:38px;}
	.threeSweets .evtNoti {padding:45px 20px;}
	.threeSweets .evtNoti dt {margin-bottom:23px;}
	.threeSweets .evtNoti dt span {padding:0 15px; font-size:20px; border-left:3px solid #33e4b9; border-right:3px solid #33e4b9;}
	.threeSweets .evtNoti li {font-size:17px; padding-left:20px; margin-top:6px;}
	.threeSweets .evtNoti li:after {top:5px; width:3px; height:3px; border:3px solid #ffc101;}

	.threeSweets .layerCont .genieMusic span {font-size:36px;}
	.threeSweets .layerCont .genieMusic span strong {padding:0 20px; background-size:10px auto;}
}
</style>
<script type="text/javascript">
$(function(){
	$(".closeLayer").click(function(){
		$(".layerPopup").hide();
	});
});

function go3comdalcom(){

	<% If IsUserLoginOK Then %>
		<% If nowdate >="2015-04-13" and nowdate <"2015-04-17" Then %>
			var tmpgubun='';
			for (var i=0; i < frmcom.rampbtn.length ; i++){
				if (frmcom.rampbtn[i].checked){
					tmpgubun=frmcom.rampbtn[i].value;
				}
			}
			if (tmpgubun==''){
				alert('램프를 선택 해주세요');
				return false;
			}

			var rstStr = $.ajax({
				type: "POST",
				url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript60930.asp",
				data: "mode=add",
				dataType: "text",
				async: false
			}).responseText;

			if (rstStr.substring(0,8) == "SUCCESS1"){
				var couponkey;
				couponkey = rstStr.substring(11,30);
				$("#viewResult").show();
				$("#viewResult .georgia").hide();
				$("#viewResult .iriver").hide();
				$("#viewResult .drdre").hide();
				$("#viewResult .freeDelivery").hide();
				$("#gieneecouponkey").html(couponkey);
				$("#viewResult .genieMusic").show();
				window.parent.$('html,body').animate({scrollTop:0}, 300);
				return false;
			}else if (rstStr == "SUCCESS2"){
				$("#viewResult").show();
				$("#viewResult .georgia").show();
				$("#viewResult .iriver").hide();
				$("#viewResult .drdre").hide();
				$("#viewResult .freeDelivery").hide();
				$("#viewResult .genieMusic").hide();
				window.parent.$('html,body').animate({scrollTop:0}, 300);
				return false;
			}else if (rstStr == "SUCCESS3"){
				$("#viewResult").show();
				$("#viewResult .georgia").hide();
				$("#viewResult .iriver").show();
				$("#viewResult .drdre").hide();
				$("#viewResult .freeDelivery").hide();
				$("#viewResult .genieMusic").hide();
				window.parent.$('html,body').animate({scrollTop:0}, 300);
				return false;
			}else if (rstStr == "SUCCESS4"){
				$("#viewResult").show();
				$("#viewResult .georgia").hide();
				$("#viewResult .iriver").hide();
				$("#viewResult .drdre").show();
				$("#viewResult .freeDelivery").hide();
				$("#viewResult .genieMusic").hide();
				window.parent.$('html,body').animate({scrollTop:0}, 300);
				return false;
			}else if (rstStr == "COUPON"){
				$("#viewResult").show();
				$("#viewResult .georgia").hide();
				$("#viewResult .iriver").hide();
				$("#viewResult .drdre").hide();
				$("#viewResult .freeDelivery").show();
				$("#viewResult .genieMusic").hide();
				window.parent.$('html,body').animate({scrollTop:0}, 300);
				return false;
			}else if (rstStr == "END"){
				alert('더이상 응모할 수 없습니다');
				return false;
			}else if (rstStr == "KAKAO"){
				alert('친구에게 이벤트 내용을 알려주면, 한 번 더! 응모 기회가 생겨요!');
				return false;
			}
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		parent.calllogin();
		return false;
	<% end if %>
}

//카카오 친구 초대
function kakaosendcall(){
	<% If IsUserLoginOK Then %>
		<% If nowdate >="2015-04-13" and nowdate <"2015-04-17" Then %>
			var rstStr = $.ajax({
				type: "POST",
				url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript60930.asp",
				data: "mode=kakao",
				dataType: "text",
				async: false
			}).responseText;
			if (rstStr == "SUCCESS"){
				// success
				parent.parent_kakaolink('[텐바이텐] 셋콤 달콤!\n4월에 꿀맛 제대로 느껴보세요!\n\n-지니 30일 무제한 감상권!\n-요기요 7,000원 식권!\n-메가박스 영화 예매권!\n\n텐바이텐 APP에서 당신의 손으로 직접 당첨을 확인하세요!' , 'http://webimage.10x10.co.kr/eventIMG/2015/60930/60930kakao.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>' );
				return false;
			}else if (rstStr == "FAIL"){
				// fail
				alert('카카오톡 실패 관리자에게 문의 하세요');
				return false;
			}else if (rstStr == "END"){
				alert('오늘은 모두 참여 하셨습니다.');
				return false;
			}else if (rstStr == "NOT1"){
				alert('이벤트에 응모후 눌러 주세요');
				return false;
			}else if (rstStr == "NOT2"){
				alert('더이상 참여할 수 없습니다.');
				return false;
			}
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		parent.calllogin();
		return;
	<% End If %>
}

//쿠폰Process
function get_coupon(){

	<% If IsUserLoginOK Then %>
		<% If nowdate >="2015-04-13" and nowdate <"2015-04-17" Then %>
			var rstStr = $.ajax({
				type: "POST",
				url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript60930.asp",
				data: "mode=coupon",
				dataType: "text",
				async: false
			}).responseText;
			if (rstStr == "SUCCESS"){
				alert('쿠폰이 발급되었습니다.');
				return false;
			}else{
				alert('관리자에게 문의');
				return false;
			}
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		parent.calllogin();
		return;
	<% End If %>
}

function mygienee(mykey){
	<% If IsUserLoginOK Then %>
		alert('지니 당첨번호\n'+mykey);
	<% Else %>
		parent.calllogin();
		return;
	<% End If %>
}
</script>
</head>
<body>
<div class="evtCont">
	<!--사월의 꿀맛 : 셋콤달콤-지니뮤직(APP) -->
	<div class="threeSweets">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tit_three_sweets.gif" alt="셋콤달콤" /></h2>
		<div class="todaygift">
		<% If nowdate < "2015-04-17" then %>
			<% if totalcnt >= 3496 then %>
			<div class="soldout">
				<p>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/txt_soldout_10am.png" alt="SOLD OUT 내일 오전 10시, 달콤한 행운이 돌아옵니다!" />
				</p>
			</div>
			<% end if %>
		<% else %>
			<div class="soldout">
				<p>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/txt_soldout.png" alt="SOLD OUT 이벤트 기간이 끝났습니다" />
				</p>
			</div>
		<% end if %>
			<div class="sweetTab">
				<ul>
					<li class="genie">
						<a href="">
							<% If nowdate < "2015-04-17" then %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tab_genie_on.png" alt="지니뮤직" />
							<% else %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tab_genie_off.png" alt="지니뮤직 - 기간종료" />
							<% end if %>
						</a>
					</li>
					<li class="yogiyo">
						<a href="" onclick="fnAPPpopupEvent('60931');return false;" target="_top">
							<% If nowdate < "2015-04-16" then %>
								<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tag_open_day17.png" alt="17일 OPEN!" /></span>
							<% elseif nowdate = "2015-04-16" then %>
								<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tag_open_tomorrow.png" alt="내일 OPEN!" /></span>
							<% end if %>

							<% if nowdate < "2015-04-21" then %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tab_yogiyo.png" alt="요기요" />
							<% else %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tab_yogiyo_off.png" alt="요기요 - 기간종료" />
							<% end if %>
						</a>
					</li>
					<li class="megabox">
						<a href="" onclick="fnAPPpopupEvent('60932');return false;" target="_top">
							<% If nowdate < "2015-04-20" then %>
								<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tag_open_day21.png" alt="21일 OPEN!" /></span>
							<% elseif nowdate = "2015-04-20" then %>
								<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tag_open_tomorrow.png" alt="내일 OPEN!" /></span>
							<% end if %>

							<% if nowdate < "2015-04-25" then %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tab_megabox.png" alt="메가박스" />
							<% else %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tab_megabox_off.png" alt="메가박스 - 기간종료" />
							<% end if %>
						</a>
					</li>
				</ul>
			</div>
			<% If hour(now()) < 10 Then %>
			<% else %>
				<p class="date">
					<% If nowdate < "2015-04-16" then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/txt_date01.png" alt="이벤트 기간:04.13~04.16" />
					<% else %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/txt_date02.png" alt="이벤트 기간:04.13~오늘까지" />
					<% end if %>
				</p>
			<% end if %>
			<div>
				<% If hour(now()) < 10 Then %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/img_gift_genie_soon_today.jpg" alt="지니뮤직" />
				<% else %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/img_gift_genie.jpg" alt="지니뮤직" />
				<% end if %>
			</div>
		</div>
	<form name="frmcom" method="post" style="margin:0px;">
		<div class="applyEvt">

		<% if totalcnt >= 3496 or hour(now()) < 10 then %>
		<% else %>
			<!--<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/txt_select_lamp.jpg" alt="셋콤달콤" /></p>
			<ul class="selectLamp">
				<li>
					<label for="s01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/img_lamp01.png" alt="램프1" /></label>
					<input type="radio" name="rampbtn" id="s01" value="1" />
				</li>
				<li class="tPad15">
					<label for="s02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/img_lamp02.png" alt="램프2" /></label>
					<input type="radio" name="rampbtn" id="s02" value="2" />
				</li>
				<li>
					<label for="s03"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/img_lamp03.png" alt="램프3" /></label>
					<input type="radio" name="rampbtn" id="s03" value="3" />
				</li>
			</ul>
			<p class="applyBtn"><a href="" onclick="go3comdalcom();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/btn_apply.gif" alt="" /></a></p>
		-->
		<% end if %>

			<% IF mygienee > 0 then %>
				<p class="viewNum"><a href="" onclick="mygienee('<%= mycouponkey %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/btn_view_number.jpg" alt="지니 당첨번호 다시 보기" /></a></p>
			<% end if %>
		</div>
	</form>
	<!--
		<p><a href="" onclick="kakaosendcall();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/btn_noti_kakao.gif" alt="또 하고 싶을 땐, 친구찬스!" /></a></p>
	-->
		<dl class="evtNoti">
			<dt><span>이벤트 유의사항</span></dt>
			<dd>
				<ul>
					<li>본 이벤트는 텐바이텐 app에서만 참여 가능합니다.</li>
					<li>본 이벤트는 ID당 1회만 응모가능하며, 친구 초대 시 한 번 더 응모기회가 주어집니다.</li>
					<li>지니 &lt;스마트 음악감상&gt;은 지니 어플리케이션에서 사용 가능하며, 등록 가능 기간은 8월31일까지입니다.</li>
					<li><strong>쿠폰 등록 시 보관함으로 등록이 되며 등록 이후에 사용할 수 있습니다.</strong></li>
					<li>쿠폰은 등록일 기준으로 30일 동안 사용이 가능합니다.</li>
					<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
					<li>무료배송쿠폰은 ID당 하루에 최대 2회까지 발행되며, 발급 당일 자정 기준으로 자동 소멸됩니다. (1만원 이상 구매 시, 텐바이텐 배송상품만 사용 가능)</li>
					<li>당첨 된 상품은 익일 발송됩니다! 마이텐바이텐에서 당첨안내를 확인해주세요.</li>
					<li>당첨 된 기프티콘은 익일 오후 1시에 발송됩니다! 마이텐바이텐에서 연락처를 확인해주세요.</li>
					<li>지니쿠폰 등록은 지니 유선 사이트 (www.genie.co.kr)와 안드로이드 지니 어플리케이션에서 가능하며 ios는 애플 정책상 유선에서 등록하여 사용 하시면 됩니다.</li>
					<li>지니에서 재생되는 일부 음원은 권리사의 요청에 따라 제공되지 않을 수 있습니다.</li>
				</ul>
			</dd>
		</dl>
		<p><a href="" onclick="fnAPPpopupEvent('61491'); return false;" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/bnr_get_item.gif" alt="쫄깃한 득템 브랜드 이벤트 가기" /></a></p>


		<!-- 레이어팝업 (당첨여부) -->
		<div id="viewResult" class="layerPopup">
			<div class="layerCont">
				<p class="closeLayer btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/btn_layer_close.png" alt="닫기" /></p>
				<!-- 당첨선물 -->
				<div class="genieMusic" style="display:none">
					<span><strong id="gieneecouponkey"></strong></span>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/img_genie_win01.gif" alt="스마트 음악감상 30일 당첨" />
					<p class="closeLayer btnClose02">확인</p>
				</div>

				<div class="drdre" style="display:none">
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/img_genie_win02.gif" alt="소니 헤드폰 당첨" />
					<p class="closeLayer btnClose02">확인</p>
				</div>

				<div class="iriver" style="display:none">
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/img_genie_win03.gif" alt="아이리버 스피커 당첨" />
					<p class="closeLayer btnClose02">확인</p>
				</div>

				<div class="georgia" style="display:none">
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/img_genie_win04.gif" alt="조지아 오리지널 당첨" />
					<p class="closeLayer btnClose02">확인</p>
				</div>

				<div class="freeDelivery" style="display:none">
					<a href="" onclick="get_coupon(); return false;">쿠폰 다운 받기</a>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/img_free_delivery.gif" alt="헉, 아쉬워요! 무료배송 쿠폰 받기" />
				</div>
				<!--// 당첨선물 -->
			</div>
		</div>
		<!--// 레이어팝업 (당첨여부) -->
	</div>
	<!--// 사월의 꿀맛 : 셋콤달콤-지니뮤직(APP) -->
</body>
<form name="sbagfrm" method="post" action="" style="margin:0px;">
<input type="hidden" name="mode" value="add" />
<input type="hidden" name="userid" value="<%= getloginuserid() %>" />
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->