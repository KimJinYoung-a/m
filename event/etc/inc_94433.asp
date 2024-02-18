<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  더블마일리지
' History : 2019-05-14 최종원 생성
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
	If Now() > #05/14/2019 00:00:00# AND Now() <= #05/22/2019 00:00:00# Then
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
.double-mileage {background-color:#0aded0;}
.my-mileage {position:relative; width:89.6%; margin:0 auto 4.43rem; padding:3.6rem 2.77rem 2.9rem; background-color:#fff; border-radius:.8rem;}
.my-mileage h3 {font-size:1.4rem; line-height:2.2rem; color:#535353; text-align:center; font-weight:bold;}
.my-mileage h3 strong {display:inline-block; margin-bottom:0.6rem; font-size:1.45rem; line-height:1; color:#0c0c0c; font-weight:600;}
.my-mileage ul {padding:2.41rem 0 2rem;}
.my-mileage li {position:relative; overflow:hidden; margin:1rem 0; font-size:1.3rem; font-weight:600; color:#3a3a3a;}
.my-mileage li:after {content:''; display:inline-block; position:absolute; left:0.3rem; top:1rem; width:0.25rem; height:0.25rem; background-color:#3a3a3a; border-radius:50%;}
.my-mileage li span {display:inline-block; float:right;}
.my-mileage li span strong {padding-right:0.5rem; color:#686868; font-size:1.45rem; font-weight:600; }
.my-mileage li span:nth-child(1) {position:absolute; left:1.2rem; top:0; line-height:2;}
.my-mileage li span:nth-child(2) {min-width:9.3rem; padding:.65rem 1.37rem .45rem 1.37rem; background-color:#ededed; border-radius:.64rem; text-align:right;}
.my-mileage li:nth-child(2) span:nth-child(2) strong {color:#f6424a;}
.noti {text-align:center; padding:3.5rem 8.6%; color:#fff; background:#1e1f2b;}
.noti h3 {width:11.264rem; margin:0 auto 1.8rem;}
.noti h3 span {display:inline-block; border-bottom:0.15rem solid #fff; }
.noti li {position:relative; padding:0 0 0 .6rem; font-size:1.1rem; line-height:1.84; margin-bottom:0.3rem; text-align:left; word-break:keep-all;}
.noti li:after {content:''; display:inline-block; position:absolute; left:0; top:1rem; width:0.1rem; height:0.1rem; background:#fff; border-radius:50%;}
</style>
<script>
function jsSubmitComment(){
	<% If isapp="1" Then %>
		parent.calllogin();
		return;
	<% else %>
        parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=94433")%>');
        return false;		
	<% End If %>
}
</script>

<%' 더블 마일리지 %>
			<div class="mEvt88837 double-mileage">
				<h2><img src="http://webimage.10x10.co.kr/fixevent/event/2019/94433/m/tit_double_mileage.png" alt="더블마일리지 5월 21일까지 상품 후기를 작성하시면 마일리지 2배 적립!" /></h2>
				<p><img src="http://webimage.10x10.co.kr/fixevent/event/2019/94433/m/txt_mileage.png?v=1.01" alt="상품후기를 쓰면 200마일리지, 포토후기 작성시 추가 200마일리지 포함 400마일리지 지급" /></p>
				<!-- 예상 마일리지 확인하기 -->
				<div class="my-mileage">
                    <% If IsUserLoginOK Then %>
                        <h3><strong><%= vUserID %></strong> 고객님이<br/>지금 후기를 쓰시면 얻게 될 혜택은?</h3>
                    <% Else %>
                        <h3>나의 예상 적립 마일리지를<br />확인하세요!</h3>                    
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
                            <%' 로그인 후 %>
                            <% If isApp="1" Then %>                            
                                <a href="" onclick="fnAPPpopupBrowserURL('상품후기','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/goodsusing.asp'); return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/94433/m/btn_review.png" alt="상품후기 쓰러 가기" /></a>
                            <% Else %>
                                <a href="/my10x10/goodsusing.asp"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/94433/m/btn_review.png" alt="상품후기 쓰러 가기" /></a>
                            <% End If %>
                        <% Else %>
                            <%' 로그인 전 %>
                            <a href="" onClick="jsSubmitComment(); return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/94433/m/btn_login.png" alt="로그인하기" /></a>
                        <% End If %>                    
					</div>
				</div>
				<!--// 예상 마일리지 확인하기 -->
				<div class="noti">
					<h3><img src="http://webimage.10x10.co.kr/fixevent/event/2019/94433/m/tit_noti.png" alt="이벤트 유의사항" /></h3>
					<ul>
						<li>이벤트 기간 내에 새롭게 작성하신 상품후기에 한해서만 더블 마일리지가 적용됩니다.</li>
						<li>기존에 작성했던 상품후기 수정은 적용되지 않습니다.</li>
						<li style="color:#ffab5c;">상품후기 및 포토후기가 작성된 이후에 삭제된 경우에는 마일리지 지급이 되지 않습니다.</li>
						<li>상품후기는 배송정보 [출고완료] 이후부터 작성하실 수 있습니다.</li>
						<li>상품과 관련 없는 내용이나 이미지를 올리거나, 직접 찍은 사진이 아닐 경우 삭제 및 마일리지 지급이 취소될 수 있습니다.</li>
						<li>마일리지는 즉시 지급 됩니다.</li>
						<li>첫 상품 후기 작성자는 최대 400마일리지로 지급됩니다.</li>
					</ul>
				</div>
			</div>
<%' 더블 마일리지 %>	
<!-- #include virtual="/lib/db/dbclose.asp" -->