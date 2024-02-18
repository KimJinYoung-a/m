<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  더블마일리지
' History : 2018-04-20 정태훈 생성
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
	If Now() > #08/29/2018 00:00:00# AND Now() < #09/04/2018 23:59:59# Then
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
.double-mileage {background-color:#005cba;}
.my-mileage {position:relative; width:92%; margin:3.07rem auto; padding:3rem 5.8% 2.56rem; background-color:#fff; border-radius:2.13rem;}
.my-mileage h3 {padding-bottom:1.7rem; font-size:1.6rem; line-height:2.2rem; color:#494949; text-align:center; font-weight:bold; border-bottom:1px dashed #ccc;}
.my-mileage h3 span {color:#8a35b5;}
.my-mileage h3 strong {display:inline-block; margin-bottom:0.6rem; line-height:1; color:#d32301; border-bottom:0.15rem solid #d32301; font-weight:600;}
.my-mileage ul {padding:1.7rem 0 2rem;}
.my-mileage li {position:relative; overflow:hidden; margin:1rem 0; padding-right:2rem; font-size:1.4rem; font-weight:600; color:#666;}
.my-mileage li:after {content:''; display:inline-block; position:absolute; left:0.3rem; top:0.4rem; width:0.25rem; height:0.25rem; background-color:#666; border-radius:50%;}
.my-mileage li span {display:inline-block; float:right;}
.my-mileage li span:first-child {position:absolute; left:1.28rem; top:0;}
.my-mileage li span strong {padding-right:0.5rem; color:#d32301 ; font-size:1.45rem; font-weight:600;}
.noti {text-align:center; padding:3.5rem 6.4%; color:#fff; background:#2e2e2e;}
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
			<!-- 더블 마일리지 -->
			<div class="mEvt88837 double-mileage">
				<h2><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88837/m/tit_double_mileage.png" alt="일주일간 진행되는 X2 마일리지 - 지금 상품후기 완성하면 마일리지 2배 적립!" /></h2>
				<p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88837/m/txt_mileage.png" alt="상품후기를 쓰면 200마일리지, 포토후기 작성시 추가 200마일리지 포함 400마일리지 지급" /></p>
				<!-- 예상 마일리지 확인하기 -->
				<div class="my-mileage">
				<% If IsUserLoginOK Then %>
					<h3><strong><%= vUserID %></strong><br />고객님이 지금 후기를 쓰시면 <br />얻게 될 혜택은?</h3>
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
						<img src="http://webimage.10x10.co.kr/fixevent/event/2018/88837/m/btn_review.png" alt="상품후기 쓰러 가기" /></a>
					<% Else %>
						<a href="" onClick="jsSubmitComment(); return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88837/m/btn_login.png" alt="로그인하기" /></a>
					<% End If %>											
					</div>
				</div>
				<!--// 예상 마일리지 확인하기 -->
				<div class="noti">
					<h3><span>이벤트 유의사항</span></h3>
					<ul>
						<li>이벤트 기간 내에 새롭게 작성하신 상품후기에 한해서만 더블 마일리지가 적용됩니다.</li>
						<li>기존에 작성했던 상품후기 수정은 적용되지 않습니다.</li>
						<li style="color:#fffd6b;">상품후기 및 포토후기가 작성된 이후에 삭제된 경우에는 마일리지 지급이 되지 않습니다.</li>
						<li>상품후기는 배송정보 [출고완료] 이후부터 작성하실 수 있습니다.</li>
						<li>상품과 관련 없는 내용이나 이미지를 올리거나, 직접 찍은 사진이 아닐 경우 삭제 및 마일리지 지급이 취소될 수 있습니다.</li>
						<li>상품후기 마일리지는 즉시 지급 됩니다.</li>
						<li>포토후기의 추가지급 마일리지(200point)는 9월 10일(월) 일괄지급 될 예정입니다.</li>
					</ul>
				</div>
			</div>
			<!--// 더블 마일리지 -->
			
<!-- #include virtual="/lib/db/dbclose.asp" -->