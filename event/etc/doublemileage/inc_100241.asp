<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  더블마일리지
' History : 2020-01-21 이종화 생성
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
	If Now() > #02/05/2020 00:00:00# AND Now() < #02/09/2020 23:59:59# Then
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
.double-mileage {position:relative; background:#b245eb;}
.my-mileage {position:relative; width:86%; margin:0 auto 4.27rem; padding:3.5rem 2.7rem 2.6rem; background:#fff; border-radius:0.85rem;}
.my-mileage h3 {font-size:1.37rem; line-height:1.5; color:#555; text-align:center; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.my-mileage .user-id {display:inline-block; color:#222; font-family:'CoreSansCMedium'; vertical-align:text-bottom;}
.my-mileage h3 b {color:#111;}
.my-mileage h3 em {color:#b245eb;}
.my-mileage ul {padding:1.8rem 0 2.1rem;}
.my-mileage li {position:relative; overflow:hidden; margin:1.1rem 0; font-size:1.1rem; color:#3a3a3a;}
.my-mileage li .tit {position:absolute; left:0; top:50%; -webkit-transform:translateY(-40%); transform:translateY(-40%);}
.my-mileage li .num {float:right; min-width:9.6rem; padding:0.7rem 1.37rem 0.4rem; background:#ededed; border-radius:0.64rem; text-align:right; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; font-size:1.28rem;}
.my-mileage li .num b {font-family:'CoreSansCBold'; margin-right:0.4rem;}
.my-mileage li.m01 b {color:#686868;}
.my-mileage li.m02 b {color:#f6424a;}
.my-mileage .btn-group {padding:0 0.5rem;}
</style>
<script>
function jsSubmitComment(){
	<% If isapp="1" Then %>
		calllogin();
		return;
	<% else %>
		jsevtlogin();
		return;
	<% End If %>
}
</script>
<div class="mEvt88837 double-mileage">
	<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/100241/m/tit_mileage.jpg" alt="더블 마일리지"></h2>
	<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/100241/m/txt_mileage.jpg" alt="후기를 쓰면"></p>

	<div class="my-mileage">
        <% If IsUserLoginOK Then %>
		<h3><span class="user-id"><%= vUserID %></span> 고객님이<br><em>지금 후기를 쓰시면 얻게 될 혜택</em>은?</h3>
		<% Else %>
		<h3><b>나의 예상 적립 마일리지</b>를<br>확인하세요!</h3>
		<% End If %>
		<ul>
			<li class="m01">
				<strong class="tit">&middot; 작성 가능한 후기 개수</strong>
				<span class="num"><b><% If IsUserLoginOK Then %><%=vMileArr(0,0)%><% else %>0<% End if %></b>개</span>
			</li>
			<li class="m02">
				<strong class="tit">&middot; 예상 마일리지</strong>
				<span class="num"><b><% If IsUserLoginOK Then %><%=FormatNumber(vMileArr(1,0),0)%><% else %>0<% End if %></b>M</span>
			</li>
		</ul>
		<div class="btn-group">
            <% If IsUserLoginOK Then %>
				<% If isApp="1" Then %>
				<a href=""  onclick="fnAPPpopupBrowserURL('상품후기','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/goodsusing.asp'); return false;">
				<% Else %>
				<a href="/my10x10/goodsusing.asp">
				<% End If %>
				<img src="//webimage.10x10.co.kr/fixevent/event/2020/100241/m/btn_review.png" alt="상품후기쓰고 더블 마일리지 받기" /></a>
			<% Else %>
				<a href="" onClick="jsSubmitComment(); return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100241/m/btn_login.png" alt="로그인하기" /></a>
			<% End If %>
		</div>
	</div>

	<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/100241/m/txt_noti.jpg" alt="이벤트 유의사항"></p>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->