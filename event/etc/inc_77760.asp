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
	If Now() > #05/08/2017 00:00:00# AND Now() < #05/14/2017 23:59:59# Then
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
.myMileage {position:relative; padding:3rem 0 3.8rem; background-color:#ffeed8;}
.myMileage .checkLogin {width:70%; margin:0 auto; padding-bottom:1.4rem; text-align:center; border-bottom:1px dashed #bfbfbf;}
.myMileage .checkLogin .check img {width:14.7rem;}
.myMileage .checkLogin .expect img {width:15.1rem;}
.myMileage .checkLogin .expect p {margin-top:0.65rem;}
.myMileage .checkLogin .expect strong {display:inline-block; font-size:1.3rem; line-height:1.5rem; color:#eb3b34; border-bottom:1px solid #eb3b34;}
.myMileage ul {padding:1.7rem 14.375% 0;}
.myMileage ul li {position:relative; margin-bottom:0.4rem; padding:0.7rem 0;}
.myMileage ul li span {display:inline-block; width:10.4rem; height:1.1re m;}
.myMileage ul li.m02 span {width:6.85rem;}
.myMileage ul li strong {position:absolute; right:0; top:0; width:10.6rem; height:100%; font-size:1.4rem; line-height:2.6rem; color:#eb3b34; text-align:right; background:#fff; border-radius:0.8rem;}
.myMileage ul li strong img {width:1rem; margin:0.7rem 1.5rem 0.7rem 0.7rem;}
.myMileage .btnArea {position:relative; padding:2rem 8.75% 0; animation:bounce1 40 1s 1s;}
.evtNoti {padding:3rem 7.5% 0;}
.evtNoti h3 {margin-bottom:1rem; font-weight:bold; font-size:1.5rem; color:#000;}
.evtNoti li {position:relative; color:#808290; padding:0 0 0 1.4rem; line-height:1.5rem; margin-bottom:0.3rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0.2rem; top:0.6rem; width:0.3rem; height:0.15rem; background:#000;}
@keyframes bounce1 {
	from, to{top:0; animation-timing-function:ease-in;}
	50% {top:4px; animation-timing-function:ease-out;}
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
<div class="mEvt77760">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/77760/m/tit_double_mileage.jpg" alt="더블 마일리지" /></h2>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/77760/m/txt_mileage.jpg" alt="상품후기를 쓰면 200마일리지, 첫 상품후기를 쓰면 400마일리지 적립" /></p>
	<div class="myMileage">
		<div class="checkLogin">
			<% If IsUserLoginOK Then %>
			<div class="expect"><strong><%= vUserID %></strong><p><img src="http://webimage.10x10.co.kr/eventIMG/2017/77760/m/txt_get_01.png" alt="고객님의 예상 마일리지는?" /></p></div>
			<% Else %>
			<div class="check"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77760/m/txt_check_mileage.png" alt="나의 예상 적립 마일리지를 확인하세요!" /></div>
			<% End If %>
		</div>
		 <ul>
			<li class="m01">
				<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/77760/m/txt_num_1.png" alt="작성 가능한 후기 개수" /></span>
				<strong><% If IsUserLoginOK Then %><%=vMileArr(0,0)%><% End if %><img src="http://webimage.10x10.co.kr/eventIMG/2017/77760/m/txt_num_2.png" alt="개" /></strong>
			</li>
			<li class="m02">
				<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/77760/m/txt_expect_1.png" alt="예상 마일리지" /></span>
				<strong><% If IsUserLoginOK Then %><%=FormatNumber(vMileArr(1,0),0)%><% End if %><img src="http://webimage.10x10.co.kr/eventIMG/2017/77760/m/txt_expect_2.png" alt="M" /></strong>
			</li>
		</ul>
		<div class="btnArea">
			<% If IsUserLoginOK Then %>
				<% If isApp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품후기','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/goodsusing.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77760/m/btn_review.png" alt="상품후기쓰고 더블 마일리지 받기" /></a>
				<% Else %>
					<a href="/my10x10/goodsusing.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77760/m/btn_review.png" alt="상품후기쓰고 더블 마일리지 받기" /></a>
				<% End If %>
			<% else %>
				<a href="" onClick="jsSubmitComment(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77760/m/btn_login.png" alt="로그인하기" /></a>
			<% end if %>
		</div>
	</div>
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
<!-- #include virtual="/lib/db/dbclose.asp" -->