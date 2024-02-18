<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 마이텐바이텐
' History : 2015.06.04 한용민 생성
'####################################################
%>
<!-- #include virtual="/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<%
dim userid, orderserial, IsBiSearch, idx, i
	userid = getEncLoginUserID
	orderserial = requestCheckVar(request("orderserial"),11)
	idx         = requestCheckVar(request("idx"),11)

if ((userid="") and session("userorderserial")<>"") then
	IsBiSearch = true
	orderserial = session("userorderserial")
end if

dim myorder
set myorder = new CMyOrder

if (IsUserLoginOK()) then
    myorder.FRectUserID = userid
    myorder.FRectOrderserial = orderserial
    myorder.GetOneOrder
elseif (IsGuestLoginOK()) then
    orderserial = GetGuestLoginOrderserial()
    myorder.FRectOrderserial = orderserial
    myorder.GetOneOrder
end if

dim myorderdetail
set myorderdetail = new CMyOrder
myorderdetail.FRectOrderserial = orderserial
myorderdetail.FRectIdx = idx

if myorder.FResultCount>0 then
    myorderdetail.GetOneOrderDetail
end if

if ((myorder.FResultCount<1) or (myorderdetail.FResultCount<1)) then
    response.write "<script language='javascript'>alert('주문 정보가 존재하지 않습니다.');</script>"
    response.write "<script language='javascript'>history.back;</script>"
    dbget.close()	:	response.End
end if

dim IsRequireDetailEditEnable
IsRequireDetailEditEnable = (myorderdetail.FOneItem.IsRequireDetailExistsItem) and (myorderdetail.FOneItem.IsEditAvailState)

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script language='javascript'>

function editHandMadeRequire(frm){
    var detailArr='';

	<% if (IsRequireDetailEditEnable) then %>
	    if (frm.requiredetail != undefined) {
	        if (frm.requiredetail.value.length < 1) {
	            alert('주문 제작 문구를 입력해 주세요.');
	            frm.requiredetail.focus();
	            return;
	        }
	
	        if(GetByteLength(frm.requiredetail.value) > 500) {
	    		alert('문구 입력은 최대 250자(한글 기준) 까지 가능합니다.\n\n현재 글자수 : ' + frm.requiredetail.value.length);
	    		frm.requiredetailedit.focus();
	    		return;
	    	}
		}else{
		    <% if (myorderdetail.FOneItem.FItemNo>1) then %>
	    	for (var i = 0; i < <%=myorderdetail.FOneItem.FItemNo%>; i++) {
				var obj = eval("frm.requiredetail" + i);
	
	            if(GetByteLength(obj.value) > 500) {
	    			alert('문구 입력은 최대 250자(한글 기준) 까지 가능합니다.\n\n현재 글자수 : ' + obj.value.length);
	    			obj.focus();
	    			return;
	    		}
	
	            detailArr = detailArr + obj.value + '||';
	        }
	
	        if(GetByteLength(detailArr) > 800) {
				alert('문구 입력합계는 최대 400자(한글 기준) 까지 가능합니다.\n\n현재 글자수 : ' + detailArr.length);
				frm.requiredetail0.focus();
				return;
			}
	        <% end if %>
		}
	
		if (confirm('수정 하시겠습니까?')) {
			frm.submit();
		} else {
			return;
		}
	<% else %>
	    alert('수정 가능 상태가 아닙니다. 고객센터로 문의 해 주세요.');
	    return;
	<% end if %>
}

function chmyorderdetail(orderserial){
	location.replace('/my10x10/order/myorderdetail.asp?idx='+orderserial);
}

</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<div class="header">
			<h1>주문제작 문구수정</h1>
			<p class="btnPopClose"><button class="pButton" onclick="chmyorderdetail('<%= orderserial %>');">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="userInfo userInfoEidt inner10">
				<fieldset>
				<legend>주문제작 문구수정 변경</legend>
					<% if (myorderdetail.FResultCount>0) then %>
						<form name="frm" method="post" action="/my10x10/orderPopup/EditOrderInfo_process.asp" style="margin:0px;">
						<input type="hidden" name="mode" value="edithandmadereq">
						<input type="hidden" name="orderserial" value="<%= orderserial %>">
						<input type="hidden" name="detailidx" value="<%= idx %>">
						<div class="editSentence">
							<p>
								상품문구는 최대 120자까지 가능합니다.
	
								<% if myorderdetail.FOneItem.FItemNo > 1 then %>
									<br />같은 상품을 2개 이상 주문하시고 문구를 다르게 하실 경우, <br />반드시 각각의 문구를 작성해주시기 바랍니다.<br />제작 문구가 같을경우 1번째 상품에만 입력하시기 바랍니다.
								<% end if %>
							</p>

							<% if myorderdetail.FOneItem.FItemNo=1 then %>
								<textarea name="requiredetail" <% if (Not IsRequireDetailEditEnable) then %>readonly<% end if %> cols="60" rows="50" title="변경할 문구를 입력해주세요"><%= ChkIIF(myorderdetail.FOneItem.FrequiredetailUTF8="",myorderdetail.FOneItem.Frequiredetail,myorderdetail.FOneItem.FrequireDetailUTF8) %></textarea>
							<% else %>
								<% for i=0 to myorderdetail.FOneItem.FItemNo-1 %>
								<textarea name="requiredetail<%= i %>" <% if (Not IsRequireDetailEditEnable) then %>readonly<% end if %> cols="60" rows="50" title="변경할 문구를 입력해주세요"><%= splitValue(ChkIIF(myorderdetail.FOneItem.FrequiredetailUTF8="",myorderdetail.FOneItem.Frequiredetail,myorderdetail.FOneItem.FrequireDetailUTF8),CAddDetailSpliter,i) %></textarea>
								<% next %>
							<% end if %>
						</div>
						</form>
					<% end if %>

					<div class="btnWrap">
						<div class="ftLt w50p"><span class="button btB1 btGry2 cWh1 w100p"><button type="button" onclick="chmyorderdetail('<%= orderserial %>');">취소</button></span></div>
						<div class="ftLt w50p"><span class="button btB1 btRed cWh1 w100p"><button type="submit" onClick="editHandMadeRequire(document.frm);">수정</button></span></div>
					</div>
				</fieldset>
			</div>

		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>

<%
set myorder = Nothing
set myorderdetail = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->