<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  더블 마일리지! 
' History : 2016.10.31 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<%
dim eCode, vUserID, cMil, vMileValue, vMileArr
	vUserID = GetEncLoginUserID()
	'vUserID = "10x10yellow"
	If Now() > #11/01/2016 00:00:00# AND Now() < #11/06/2016 23:59:59# Then
		vMileValue = 200
	Else
		vMileValue = 100
	End If

	Set cMil = New CEvaluateSearcher
	cMil.FRectUserID = vUserID
	cMil.FRectMileage = vMileValue
	
	If vUserID <> "" Then
		vMileArr = cMil.getEvaluatedTotalMileCnt
	End If
	Set cMil = Nothing
%>
<style type="text/css">
img {vertical-align:top;}
.myMileage {position:relative; padding-bottom:2.5rem; background:#e63a33 url(http://webimage.10x10.co.kr/eventIMG/2016/73157/bg_red.png) 0 0 repeat-y; background-size:100% auto;}
.myMileage .mgBox {position:relative; background:url(http://webimage.10x10.co.kr/eventIMG/2016/73157/m/bg_box.png) 0 0 repeat-y; background-size:100% auto;}
.myMileage .checkLogin {width:70%; margin:0 auto; padding-bottom:1.2rem; text-align:center; border-bottom:1px dashed #e5e5e5;}
.myMileage .checkLogin p {margin-top:0.8rem;}
.myMileage .checkLogin img {width:21.7rem;}
.myMileage .checkLogin strong {display:inline-block; margin-right:0.5rem; font-size:1.4rem; line-height:1.4rem; color:#eb3b34; border-bottom:1px solid #eb3b34;}
.myMileage .mgBox ul {padding:1rem 14.375% 0;}
.myMileage .mgBox li {position:relative; margin-top:0.4rem;}
.myMileage .mgBox li span {display:inline-block; width:10.4rem;}
.myMileage .mgBox li strong {position:absolute; right:0; top:0; width:10rem; height:100%; font-size:1.4rem; line-height:2.6rem; color:#eb3b34; text-align:right; background:#f2f2f2; border-radius:0.7rem;}
.myMileage .mgBox li strong img {width:2.25rem; margin-left:0.4rem;}
.myMileage .btnArea {position:relative; padding:2rem 8.75% 0;}
.myMileage .btnArea .deco {position:absolute; left:3.4%; top:-30%; width:26.875%; animation:bounce2 40 1s 1s;}
.myMileage .btnArea a {position:relative; animation:bounce1 40 1s 1s;}
.evtNoti {padding:3rem 7.8% 0;}
.evtNoti h3 {margin-bottom:1rem; font-weight:bold; font-size:1.5rem; color:#00baba;}
.evtNoti li {position:relative; color:#808290; padding:0 0 0 1.4rem; line-height:1.5rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0.2rem; top:0.55rem; width:0.6rem; height:0.15rem; background:#0d9a9a;}
@keyframes bounce1 {
	from, to{top:0; animation-timing-function:ease-in;}
	50% {top:4px; animation-timing-function:ease-out;}
}
@keyframes bounce2 {
	from, to{margin-top:0; animation-timing-function:ease-in;}
	50% {margin-top:4px; animation-timing-function:ease-out;}
}
</style>
<script>
function jsSubmitComment(){
	<% If isapp="1" Then %>
		parent.calllogin();
		return;
	<% else %>
		parent.jsevtlogin();
		return;
	<% End If %>
}
</script>
	<!-- 더블 마일리지 -->
	<div class="mEvt73157">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/73157/m/tit_double_mileage.png" alt="더블 마일리지" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/73157/m/txt_mileage.png" alt="구매후기를 쓰면 200마일리지, 첫 구매후기를 쓰면 400마일리지 적립" /></p>
		<!-- 예상 마일리지 확인하기 -->
		<div class="myMileage">
			<div class="mgBox">
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/73157/m/bg_box_top.png" alt="" /></div>
				<div class="checkLogin">
				<% If IsUserLoginOK Then %>
					<%' for dev msg : 로그인 후 %>
					<div>
						<strong><%= vUserID %></strong>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/73157/m/txt_get_01.png" alt="고객님!" style="width:4.1rem;" />
						<p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/73157/m/txt_get_02.png" alt="후기 남기고 더블 마일리지 받아가세요!" />
						</p>
					</div>
				<% else %>
					<%' for dev msg : 로그인 전 %>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/73157/m/txt_check_mileage.png" alt="나의 예상 적립 마일리지를 확인하세요!" /></div>
				<% end if %>
				</div>
				 <ul>
				 	<% If IsUserLoginOK Then %>
						<li class="m01">
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/73157/m/txt_num_01.png" alt="작성 가능한 후기 개수" /></span>
							<strong><%=vMileArr(0,0)%><img src="http://webimage.10x10.co.kr/eventIMG/2016/73157/m/txt_num_02.png" alt="개" /></strong>
						</li>
						<li class="m02">
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/73157/m/txt_expect_01.png" alt="예상 마일리지" /></span>
							<strong><%=FormatNumber(vMileArr(1,0),0)%><img src="http://webimage.10x10.co.kr/eventIMG/2016/73157/m/txt_expect_02.png" alt="M" /></strong>
						</li>
					<% else %>
						<li class="m01">
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/73157/m/txt_num_01.png" alt="작성 가능한 후기 개수" /></span>
							<strong><img src="http://webimage.10x10.co.kr/eventIMG/2016/73157/m/txt_num_02.png" alt="개" /></strong>
						</li>
						<li class="m02">
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2016/73157/m/txt_expect_01.png" alt="예상 마일리지" /></span>
							<strong><img src="http://webimage.10x10.co.kr/eventIMG/2016/73157/m/txt_expect_02.png" alt="M" /></strong>
						</li>
					<% end if %>
				</ul>
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/73157/m/bg_box_btm.png" alt="" /></div>
			</div>
			<div class="btnArea">
				<% If IsUserLoginOK Then %>
					<% If isApp="1" Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품후기','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/goodsusing.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73157/m/btn_review.png" alt="상품후기쓰고 더블 마일리지 받기" /></a>
					<% Else %>
						<a href="/my10x10/goodsusing.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73157/m/btn_review.png" alt="상품후기쓰고 더블 마일리지 받기" /></a>
					<% End If %>
				<% else %>
					<a href="" onClick="jsSubmitComment(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73157/m/btn_login.png" alt="로그인하기" /></a>
				<% end if %>
				<div class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73157/m/img_balloon.png" alt="" /></div>
			</div>
		</div>
		<!--// 예상 마일리지 확인하기 -->
		<div class="evtNoti">
			<h3>이벤트 유의사항</h3>
			<ul>
				<li>이벤트 기간 내에 새롭게 작성하신 상품후기에 한해서만 더블 마일리지가 적용됩니다.</li>
				<li>기존에 작성했던 상품후기 수정은 적용되지 않습니다.</li>
				<li>상품후기가 삭제된 경우에는 마일리지 지급이 되지 않습니다.</li>
				<li>상품후기는 배송정보 [출고완료] 이후부터 작성하실 수 있습니다.</li>
				<li>상품과 관련 없는 내용이나 이미지를 올리거나, 직접 찍은 사진이 아닐 경우 삭제 및 마일리지 지급이 취소될 수 있습니다.</li>
			</ul>
		</div>
	</div>
	<!--// 더블 마일리지 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->