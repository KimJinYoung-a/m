<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  X2 마일리지! 
' History : 2017-10-31 정태훈 생성
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
	If Now() > #11/08/2017 00:00:00# AND Now() < #11/12/2017 23:59:59# Then
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
.double-mileage {background-color:#f96e54;}
.my-mileage {position:relative; width:92%; margin:0 auto 3.07rem; padding:3rem 5.8% 2.56rem; background-color:#fff; border-radius:2.13rem;}
.my-mileage h3 {padding-bottom:1.7rem; font-size:1.6rem; line-height:2.2rem; color:#494949; text-align:center; font-weight:bold; border-bottom:1px dashed #ccc;}
.my-mileage h3 span {color:#e6583e;}
.my-mileage h3 strong {display:inline-block; margin-bottom:0.6rem; line-height:1; color:#e6583e; border-bottom:0.15rem solid #e6583e;}
.my-mileage ul {padding:1.7rem 0 2rem;}
.my-mileage li {position:relative; overflow:hidden; margin:1rem 0; padding-right:2rem; font-size:1.4rem; font-weight:600; color:#666;}
.my-mileage li:after {content:''; display:inline-block; position:absolute; left:0.3rem; top:0.4rem; width:0.25rem; height:0.25rem; background-color:#666; border-radius:50%;}
.my-mileage li span {display:inline-block; float:right;}
.my-mileage li span:first-child {position:absolute; left:1.28rem; top:0;}
.my-mileage li span strong {padding-right:0.5rem; color:#e6583e; font-size:1.45rem; font-weight:600;}
.noti {text-align:center; padding:3.5rem 6%; color:#fff; background:#494949;}
.noti h3 {margin-bottom:1.8rem; font-weight:bold; font-size:1.5rem; line-height:1.3;}
.noti h3 span {display:inline-block; border-bottom:0.15rem solid #fff; }
.noti li {position:relative; padding:0 0 0 1.4rem; font-size:1.1rem; line-height:1.5rem; margin-bottom:0.3rem; text-align:left;}
.noti li:after {content:''; display:inline-block; position:absolute; left:0.2rem; top:0.55rem; width:0.5rem; height:0.1rem; background:#fff;}
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
			<div class="mEvt81360 double-mileage">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/81360/m/tit_double_mileage.png" alt="더블 마일리지" /></h2>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/81360/m/txt_mileage.png" alt="상품후기를 쓰면 200마일리지, 첫 상품후기를 쓰면 400마일리지 적립" /></p>
				<!-- 예상 마일리지 확인하기 -->
				<div class="my-mileage">
					<% If IsUserLoginOK Then %>
					<h3><strong><%= vUserID %></strong><br />고객님의 예상 마일리지는?</h3>
					<% Else %>
					<h3>나의 <span>예상 적립 마일리지</span>를<br />확인하세요!</h3>
					<% End If %>
					<ul>
						<li>
							<span>작성 가능한 후기 개수</span>
							<span><strong><% If IsUserLoginOK Then %><%=vMileArr(0,0)%><% End if %></strong>개</span>
						</li>
						<li>
							<span>예상 마일리지</span>
							<span><strong><% If IsUserLoginOK Then %><%=FormatNumber(vMileArr(1,0),0)%><% End if %></strong>M</span>
						</li>
					</ul>
					<div class="btn-group">
						<% If IsUserLoginOK Then %>
						<% If isApp="1" Then %>
						<a href=""  onclick="fnAPPpopupBrowserURL('상품후기','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/goodsusing.asp'); return false;">
						<% Else %>
						<a href="/my10x10/goodsusing.asp">
						<% End If %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/81360/m/btn_mileage.png" alt="상품후기쓰고 더블 마일리지 받기" /></a>
						<% Else %>
						<a href="" onClick="jsSubmitComment(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81360/m/btn_login.png" alt="로그인하기" /></a>
						<% End If %>
						<!-- 로그인 전 -->
						<!-- 로그인 후 -->
					</div>
				</div>
				<!--// 예상 마일리지 확인하기 -->
				<div class="noti">
					<h3><span>이벤트 유의사항</span></h3>
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