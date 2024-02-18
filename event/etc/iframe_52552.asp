<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%

'###########################################################
' Description : 텐바이텐 이니스프리 이벤트
' History : 2014.06.17 원승현
'###########################################################

dim eCode, cnt, sqlStr, couponkey, regdate, gubun, arrList, i, totalsum, linkeCode, returnURL
	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21209"
		linkeCode = "21210"
	Else
		eCode 		= "52551"
		linkeCode = "52552"
	End If

If IsUserLoginOK Then
	sqlstr = "Select count(sub_idx) as totcnt" &_
			"  ,count(case when convert(varchar(10),regdate,120) = '" & Left(now(),10) & "' then sub_idx end) as daycnt" &_
			" From db_event.dbo.tbl_event_subscript" &_
			" WHERE evt_code='" & eCode & "' and userid='" & GetLoginUserID() & "'"
			'response.write sqlstr
	rsget.Open sqlStr,dbget,1
		totalsum = rsget(0)
		cnt = rsget(1)
	rsget.Close


	sqlstr= "select (select couponkey from db_temp.dbo.tbl_innisfree_coupon_2014 as c where c.userid = s.userid and c.idx = s.sub_opt1) as couponkey, s.regdate, s.sub_opt2, s.userid  " &_
		" FROM db_event.dbo.tbl_event_subscript as s " &_
		" where s.evt_code='" & eCode &"' and s.userid='" & GetLoginUserID()  & "'"
		'response.write sqlstr
	rsget.Open sqlStr,dbget
	IF Not rsget.EOF THEN
		arrList = rsget.getRows()
	END IF
	rsget.Close
End If

%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > LET'S PLAY!</title>
<style type="text/css">
.mEvt52552 {}
.mEvt52552 img {vertical-align:top; width:100%;}
.mEvt52552 p {max-width:100%;}
.mEvt52552 .viewPackage {padding-bottom:45px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52552/bg_pattern_line01.png) left top repeat-y; background-size:100% 8px;}
.mEvt52552 .swiperWrap {width:480px; height:340px; margin:5px auto 0; border:1px solid #eee;}
.mEvt52552 .swiper {position:relative; width:470px; height:330px; border:5px solid #fff; box-shadow:0 0 5px #c8c8c8;}
.mEvt52552 .swiper .swiper-container {overflow:hidden; height:330px;}
.mEvt52552 .swiper .swiper-slide {float:left;}
.mEvt52552 .swiper .swiper-slide a {display:block; width:100%;}
.mEvt52552 .swiper .swiper-slide img {width:100%; vertical-align:top;}
.mEvt52552 .swiper .btnArrow {display:block; position:absolute; bottom:-40px; z-index:10; width:19px; height:24px; text-indent:-9999px; background-repeat:no-repeat; background-position:left top; background-size:100% auto;}
.mEvt52552 .swiper .arrow-left {left:12px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52552/btn_prev.png);}
.mEvt52552 .swiper .arrow-right {right:12px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52552/btn_next.png);}
.mEvt52552 .swiper .pagination {position:absolute; left:0; bottom:-38px; width:100%; text-align:center;}
.mEvt52552 .swiper .pagination span {position:relative; display:inline-block; width:12px; height:12px; margin:0 7px; cursor:pointer; border-radius:12px; background:#d3d9c5;}
.mEvt52552 .swiper .pagination .swiper-active-switch {background:#36921f;}
.mEvt52552 .evtNoti {overflow:hidden; padding:24px 20px 25px 8px; background:#afdddd;}
.mEvt52552 .evtNoti dl {text-align:left;}
.mEvt52552 .evtNoti dt {padding:0 0 12px 12px;}
.mEvt52552 .evtNoti li {color:#444; font-size:11px; line-height:14px; padding:0 0 2px 12px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52552/blt_drop.png) left 3px no-repeat; background-size:6px 8px;}
.mEvt52552 .evtNoti li strong {color:#d50c0c;}
.mEvt52552 .composition li {position:relative;}
.mEvt52552 .composition li a {position:absolute; top:4%; width:43%; height:90%; text-indent:-9999px;}
.mEvt52552 .composition li a.link01 {left:8%;}
.mEvt52552 .composition li a.link02 {right:8%;}
.mEvt52552 .applyPlay {position:relative;}
.mEvt52552 .applyPlay input {display:block; position:absolute; left:14%; top:16%; width:72%;}
.mEvt52552 .winList {background:url(http://webimage.10x10.co.kr/eventIMG/2014/52552/bg_pattern_line02.png) left top repeat-y; background-size:100% 8px;}
.mEvt52552 .winList h4 {padding:42px 0 16px;}
.mEvt52552 .winList .part {width:98%; margin: 0 auto 17px; background-color:#fff;}
.mEvt52552 .winList .part table {width:100%; text-align:center; font-size:11px;}
.mEvt52552 .winList .part table th {font-weight:bold; padding:12px 0 12px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52552/bg_th_bar.png) left center no-repeat #a9be54; background-size:1px 9px;}
.mEvt52552 .winList .part table th:first-child {background-image:none;}
.mEvt52552 .winList .part table td {padding:12px 0 11px; border-top:1px solid #ddd; color:#777;}
.mEvt52552 .goBtn {display:inline-block; font-size:11px; line-height:1; font-weight:normal; padding:5px 8px 6px;}
.mEvt52552 .myTenten {color:#127286; border:1px solid #127286; margin-top:10px;}
.mEvt52552 .useCoupon {color:#fff; border:1px solid #388b5e; background:#429d5c;}
.mEvt52552 .msg {font-size:11px; line-height:14px; font-weight:bold; color:#4b9b96;}
.mEvt52552 .msg em {color:#127286;}
.mEvt52552 .process {position:relative;}
.mEvt52552 .process .pBtn {position:absolute; left:0; bottom:12%; width:100%;}
@media all and (max-width:480px){
	.mEvt52552 .swiperWrap {width:320px; height:226px;}
	.mEvt52552 .swiper {width:310px; height:216px;}
	.mEvt52552 .swiper .swiper-container {height:216px;}
}
</style>
<script src="/lib/js/swiper-1.8.min.js"></script>
<script type="text/javascript">

function checkform(frm) {
<% if datediff("d",date(),"2014-06-29")>=0 then %>
	<% If IsUserLoginOK Then %>
		<% if cnt >= 1 then %>
		alert('하루 1회만 응모 가능합니다.\n내일 다시 응모해주세요. :)');
		return;
		<% else %>
			frm.action = "doEventSubscript52552.asp?evt_code=<%=eCode%>";
			frm.submit();
		<% end if %>
	<% Else %>
		alert('로그인 후에 응모하실 수 있습니다.');
//		var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');winLogin.focus();
		return;
	<% End If %>
<% else %>
		alert('이벤트가 종료되었습니다.');
		return;
<% end if %>
}


$(function(){
	var mySwiper = new Swiper('.swiper-container',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.pagination',
		paginationClickable:true,
		speed:180
	})
	$('.swiper .arrow-left').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.swiper .arrow-right').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
	var oTm = setInterval(function () {
		mySwiper.reInit();
			clearInterval(oTm);
		}, 1);
	});
});


function clipboard(str){
	window.clipboardData.setData('Text',str);
	alert("클립보드에 복사되었습니다.");
}
</script>
</head>
<body>
<form name="frm" method="POST" style="margin:0px;">
<input type="hidden" name="eventid" value="<%=eCode%>">
<input type="hidden" name="linkeventid" value="<%=linkeCode%>">
<input type="hidden" name="userid" value="<%=GetLoginUserID%>">

<div class="evtView" style="padding:0;">
	<!-- LET'S PLAY! -->
	<div class="mEvt52552">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/52552/tit_lets_play.png" alt="LET'S PLAY!" /></h3>
		<div class="viewPackage">
			<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/52552/tit_package.png" alt="GIFT01 : LET'S PLAY 여행 패키지" /></h4>
			<div class="swiperWrap">
				<div class="swiper">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52552/img_travel_package01.png" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52552/img_travel_package02.png" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52552/img_travel_package03.png" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52552/img_travel_package04.png" alt="" /></div>
						</div>
						<div class="pagination"></div>
					</div>
					<a class="btnArrow arrow-left" href="">Previous</a>
					<a class="btnArrow arrow-right" href="">Next</a>
				</div>
			</div>
		</div>
		<div class="composition">
			<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/52552/tit_composition.png" alt="LET'S PLAY 패키지 구성" /></h4>
			<ul>
				<li>
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/52552/img_package01.png" alt="" />
					<!--
					<span class="link01">여행용 파우치</span>
					<span class="link02">캐리어 태그</span>
					-->
				</li>
				<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/52552/img_package02_new.png" alt="" /></li>
				<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/52552/img_package03_new.png" alt="" /></li>
			</ul>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52552/img_coupon.png" alt="GIFT02 : LET'S PLAY 이니스프리 할인쿠폰" /></p>
		<!-- 응모하기 -->
		<div class="applyPlay">
			<input type="image" onclick="checkform(this.form);" src="http://webimage.10x10.co.kr/eventIMG/2014/52552/btn_apply.png" alt="LET'S PLAY 응모하기" />
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/52552/bg_cloud.png" alt="" />
		</div>
		<!--// 응모하기 -->

		<!-- 당첨내역 -->
		<div class="winList">
			<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/52552/tit_win.png" alt="당첨 내역 확인하기" style="width:103px" /></h4>
			<div class="part">
				<table>
					<colgroup>
						<col width="16%" />
						<col width="46%" />
						<col width="*" />
					</colgroup>
					<thead>
					<tr>
						<th scope="col">응모일시</th>
						<th scope="col">당첨내역</th>
						<th scope="col">쿠폰번호</th>
					</tr>
					</thead>
					<tbody>
						<% If totalsum=0 Then %>
							<tr>
								<td colspan="3" rowspan="3" align="center">당첨내역이 없습니다.</td>
							</tr>
						<% Else %>
							<% For i = 0 To totalsum-1 %>
								<tr>
									<td><%=mid(arrLIst(1,i),6,2)%>.<%=mid(arrLIst(1,i),9,2)%></td>
									<td><% If arrLIst(2,i)="1" Then response.write "4,000원 할인 쿠폰" Else  response.write "LET'S PLAY 여행 패키지" End If %></td>
									<td><% If arrLIst(2,i)="1" Then response.write arrLIst(0,i)  else response.write "6월 30일 (월) 게시판 별도 공지됩니다." end If  %></td>
								</tr>
							<% next %>
						<% End If %>
					</tbody>
				</table>
			</div>
			<% If getLoginUserEmail()<>"" Then %>
				<div class="msg">
					<p>당첨되신 쿠폰은 개인정보에 있는<br />[<em><%=getLoginUserEmail()%></em>]로 전송됩니다.<br />개인정보를 다시 확인해주세요.</p>
					<a href="/my10x10/userinfo/confirmuser.asp" class="goBtn myTenten" target="top">마이텐바이텐 바로가기 ▶</a>
				</div>
			<% End If %>
			<div class="process">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52552/img_use_process.png" alt="이니스프리 온라인 쿠폰 사용방법" /></p>
				<p class="pBtn"><a href="http://m.innisfree.co.kr/mMypageCouponList.do" class="goBtn useCoupon" target="_blank">쿠폰 번호 입력하여 발급 ▶</a></p>
			</div>
		</div>
		<!--// 당첨내역 -->
		<div class="evtNoti">
			<dl>
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/52552/tit_noti.png" alt="이벤트 유의사항" style="width:75px;" /></dt>
				<dd>
					<ul>
						<li>텐바이텐 로그인 후 이벤트에 응모하실 수 있습니다.</li>
						<li>한 ID 당 매일 1회 참여 가능합니다.</li>
						<li>Let’s PLAY 여행 패키지는 이벤트 종료 후 주소확인을 거쳐 배송됩니다.</li>
						<li>Let’s PLAY 여행 패키지 속 파우치와 태그의 옵션은 2종이며, 랜덤으로 발송됩니다.</li>
					</ul>
				</dd>
			</dl>
		</div>
	</div>
	<!-- //LET'S PLAY! -->
</div>
</form>
</body>
</html>