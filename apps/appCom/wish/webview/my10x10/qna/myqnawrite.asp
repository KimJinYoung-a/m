<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checkUserGuestLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<%
'SSL확인 및 이동
if request.ServerVariables("SERVER_PORT_SECURE")<>1 then
    IF application("Svr_Info")="Dev" THEN
    	'response.redirect "https://2009www.10x10.co.kr/my10x10/qna/myqnawrite.asp"
    else
    	'response.redirect "https://www.10x10.co.kr/my10x10/qna/myqnawrite.asp"
    end if
    'response.end
end if

dim orderserial, itemid, qadiv
dim userid

orderserial = requestCheckVar(request("orderserial"),11)
qadiv       = requestCheckVar(request("qadiv"),4)
itemid      = requestCheckVar(request("itemid"),9)
' querystring으로 못 받아오면 form으로 받아온다.
If itemID = "" Then
	itemID = request.Form("itemID")
End If

'if (orderserial<>"") then itemid=""

if IsGuestLoginOK() then orderserial = GetGuestLoginOrderserial()

dim myorder
set myorder = new CMyOrder

if (orderserial<>"") then
    if IsUserLoginOK() then
        myorder.FRectUserID = userid
        myorder.FRectOrderserial = orderserial
        myorder.GetOneOrder
    elseif IsGuestLoginOK() then
        myorder.FRectOrderserial = orderserial
        myorder.GetOneOrder
    end if
end if


dim oItem, ItemExists
set oItem = New CatePrdCls

if (itemid<>"") then
    oItem.GetItemData itemid

    if (oItem.Prd.FItemid="") then
        response.write "<script language='javascript'>alert('검색된 상품이 없습니다.');</script>"
    else
        ItemExists = True
    end if
end if

strPageTitle = "생활감성채널, 텐바이텐 > 1:1 상담"
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script>
	var CurrDisp = "";
	function popMyOrderNo()
	{
		var f = document.SubmitFrm;
		var url = "/apps/appcom/wish/webview/my10x10/orderPopup/popMyOrderNo.asp?frmname=" + f.name + "&targetname=" + f.orderserial.name;

		jsOpenModal(url);
	}

	function popMyOrderItemID()
	{
		var f = document.SubmitFrm;
		var url = "/apps/appcom/wish/webview/my10x10/orderPopup/popMyOrderItemID.asp?frmname=" + f.name + "&targetname=" + f.itemid.name + "&orderserial=" + f.orderserial.value;

		jsOpenModal(url);

	}

	function SubmitForm(frm){
		var qaIdx = getCheckedIndex(frm.qadiv);

		if (qaIdx<0){
			alert("상담구분을 선택해주세요!!");
			frm.qadiv[0].focus();
			return;
		}
		var qadiv = frm.qadiv[qaIdx].value;

		if ((CurrDisp=="1")&&(frm.s_orderserial.value.length<1)){
			alert('주문번호를 조회해 주세요');
			return;
		}

		if ((CurrDisp=="2")&&(frm.s_itemid.value.length<1)){
			alert('문의하실 상품번호를 조회해 주세요');
			return;
		}

		if (frm.username.value.length<1) {
			alert("성함을 입력하세요.");
			frm.username.focus();
			return;
		}

		if (frm.title.value.length<1) {
			alert("제목을 입력하세요.");
			frm.title.focus();
			return;
		}

		if (frm.contents.value.length<1) {
			alert("내용을 입력하세요.");
			frm.contents.focus();
			return;
		}

		if (frm.usermail.value.length<1) {
			alert("이메일을 입력하세요.");
			frm.usermail.focus();
			return;
		}

		if (!check_form_email(frm.usermail.value)){
			alert("이메일 주소가 유효하지 않습니다.");
			frm.usermail.focus();
			return;
		}

		if (confirm("내용을 정확히 입력하셨습니까?")) {
			frm.action = "myqna_process.asp";
			frm.submit();
		}
	}

	function getItemInfo(frm){
		if (frm.itemid.value.length<1){
			alert("상품번호를 먼저 넣어주세요.");
			frm.itemid.focus();
			return;
		}

		if (!IsDigit(frm.itemid.value)||(frm.itemid.value=="")){
			alert("상품번호는 숫자만 가능합니다.");
			frm.itemid.focus();
			return;
		}
		if (getValue(frm.qadiv)!="02")
		{
			alert("직접입력은 상품문의일때만 가능합니다.");
		}
		else
		{
			frm.orderserial.value= "";
			frm.submit();
		}
	}

	function check_form_email(email){
		var pos;
		pos = email.indexOf('@');
		if (pos < 0){				//@가 포함되어 있지 않음
			return(false);
		}else{

			pos = email.indexOf('@', pos + 1)
			if (pos >= 0)			//@가 두번이상 포함되어 있음
				return(false);
		}


		pos = email.indexOf('.');

		if (pos < 0){				//@가 포함되어 있지 않음
			return false;
		}
		return(true);
	}

	function showItemHelp()
	{
		if (getValue(document.SubmitFrm.qadiv)=="02")
		{
			if (document.getElementById("divItemHelp").style.display == "none")
				document.getElementById("divItemHelp").style.display = "block";
			else
				document.getElementById("divItemHelp").style.display = "none";
		}
	}

	window.onload = function()
	{
		setValue(document.SubmitFrm.qadiv,"<%=qaDiv%>");
		initDiv();
	}

	function initDiv()
	{
		var f = document.SubmitFrm;
		var qaDiv = getValue(f.qadiv);

		document.getElementById("layoutView1").style.display = "none";
		document.getElementById("layoutView2").style.display = "none";
		document.getElementById("btnItem1").style.display = "none";
		document.getElementById("btnItem2").style.display = "none";

		if (qaDiv=="02")
		{
			document.getElementById("layoutView2").style.display = "block";
			document.getElementById("btnItem1").style.display = "";
		}
		else if (qaDiv=="00" || qaDiv=="01" || qaDiv=="04" || qaDiv=="14" || qaDiv=="06" || qaDiv=="05"  || qaDiv=="15" || qaDiv=="09" || qaDiv=="23")
		{
			document.getElementById("layoutView1").style.display = "block";
			document.getElementById("layoutView2").style.display = "block";
			document.getElementById("btnItem2").style.display = "";
		}
	}
</script>
</head>
<body class="mypage default-font">
    <!-- wrapper -->
    <div class="wrapper myinfo">
		<% If  IsGuestLoginOK()  Then %>
		 <!-- #header -->
        <header id="header">
            <div class="tabs type-c">
                <a href="/apps/appcom/wish/webview/my10x10/order/myorderlist.asp">주문배송 조회</a>
                <a href="/apps/appcom/wish/webview/my10x10/qna/myqnalist.asp" class="active">1:1 상담</a>
            </div>
        </header><!-- #header -->
        <div class="well type-b">
            <ul class="txt-list">
                <li>한번 등록한 상담내용은 수정이 불가능하며 수정을 원하시는 경우 삭제 후 재등록 하셔야 합니다. </li>
                <li>문의하신 1:1 상담은 고객님의 메일로도 확인할 수 있습니다.</li>
            </ul>
        </div>
		<% End If %>

        <!-- #content -->
        <div id="content">
            <div class="inner">
                <div class="diff"></div>
                <div class="main-title">
                    <h1 class="title"><span class="label"><%=CHKIIF(IsVIPUser()=True,"VIP ","")%>1:1 상담 신청</span></h1>
                </div>
            </div>
            <div class="well type-b">
                <ul class="txt-list">
	            	<li>문의하실 분야를 선택하신 후 내용을 입력하신 다음 " 신청하기 " 버튼을 눌러주세요.</li>
	                <li>한번 등록한 상담내용은 수정이 불가능하며 수정을 원하시는 경우 삭제 후 재등록 하셔야 합니다. </li>
                </ul>
            </div>
            <div class="diff"></div>
            <form name="SubmitFrm" method="post" action="" onsubmit="return false;">
			<input type="hidden" name="mode" value="INS">
			<% if myorder.FResultCount>0 then %>
			<input type="hidden" name="s_orderserial" value="<%= myorder.FOneItem.Forderserial %>">
			<% else %>
			<input type="hidden" name="s_orderserial" value="">
			<% end if %>
			<% if (ItemExists) then %>
			<input type="hidden" name="s_itemid" value="<%= oItem.Prd.FItemid %>">
			<% else %>
			<input type="hidden" name="s_itemid" value="">
			<% end if %>
            <div class="inner">
                <div class="categories">
                    <h1 class="red">구매관련 문의</h1>
                    <ul>
                        <li><label for="cat1_1" onClick="initDiv();"><input type="radio" class="form type-c" name="qadiv" id="cat1_1" value="00" onClick="initDiv();"> 배송</label></li>
                        <li><label for="cat1_2" onClick="initDiv();"><input type="radio" class="form type-c" name="qadiv" id="cat1_2" value="01" onClick="initDiv();"> 주문</label></li>
                        <li><label for="cat1_3" onClick="initDiv();"><input type="radio" class="form type-c" name="qadiv" id="cat1_3" value="04" onClick="initDiv();"> 취소</label></li>
                        <li><label for="cat1_4" onClick="initDiv();"><input type="radio" class="form type-c" name="qadiv" id="cat1_4" value="14" onClick="initDiv();"> 반품</label></li>
                        <li><label for="cat1_5" onClick="initDiv();"><input type="radio" class="form type-c" name="qadiv" id="cat1_5" value="06" onClick="initDiv();"> 교환/AS</label></li>
                        <li><label for="cat1_6" onClick="initDiv();"><input type="radio" class="form type-c" name="qadiv" id="cat1_6" value="05" onClick="initDiv();"> 환불</label></li>
                        <li><label for="cat1_7" onClick="initDiv();"><input type="radio" class="form type-c" name="qadiv" id="cat1_7" value="23" onClick="initDiv();"> 사은품</label></li>
                        <li><label for="cat1_8" onClick="initDiv();"><input type="radio" class="form type-c" name="qadiv" id="cat1_8" value="15" onClick="initDiv();"> 입금</label></li>
                        <li><label for="cat1_9" onClick="initDiv();"><input type="radio" class="form type-c" name="qadiv" id="cat1_9" value="09" onClick="initDiv();"> 증빙서류</label></li>
                        <li><label for="cat1_10" onClick="initDiv();"><input type="radio" class="form type-c" name="qadiv" id="cat1_10" value="08" onClick="initDiv();"> 이벤트</label></li>
                    </ul>
                    <div class="clear"></div>
                </div>

                <div class="categories">
                    <h1 class="red">일반상담 문의</h1>
                    <ul>
                        <li><label for="cat2_1" onClick="initDiv();"><input type="radio" class="form type-c" name="qadiv" id="cat2_1" value="12" onClick="initDiv();"> 회원정보</label></li>
                        <li><label for="cat2_2" onClick="initDiv();"><input type="radio" class="form type-c" name="qadiv" id="cat2_2" value="11" onClick="initDiv();"> 회원제도</label></li>
                        <li><label for="cat2_3" onClick="initDiv();"><input type="radio" class="form type-c" name="qadiv" id="cat2_3" value="18" onClick="initDiv();"> 결제방법</label></li>
                        <li><label for="cat2_4" onClick="initDiv();"><input type="radio" class="form type-c" name="qadiv" id="cat2_4" value="02" onClick="initDiv();"> 상품</label></li>
                        <li><label for="cat2_5" onClick="initDiv();"><input type="radio" class="form type-c" name="qadiv" id="cat2_5" value="13" onClick="initDiv();"> 당첨</label></li>
                        <li><label for="cat2_6" onClick="initDiv();"><input type="radio" class="form type-c" name="qadiv" id="cat2_6" value="17" onClick="initDiv();"> 쿠폰/마일리지</label></li>
                    </ul>
                    <div class="clear"></div>
                </div>

                <div class="categories">
                    <h1 class="red">기타 문의</h1>
                    <ul>
                        <li><label for="cat3_1" onClick="initDiv();"><input type="radio" class="form type-c" name="qadiv" id="cat3_1" value="16" onClick="initDiv();"> 오프라인</label></li>
                        <li><label for="cat3_2" onClick="initDiv();"><input type="radio" class="form type-c" name="qadiv" id="cat3_2" value="21" onClick="initDiv();"> 아이띵소</label></li>
                        <li><label for="cat3_3" onClick="initDiv();"><input type="radio" class="form type-c" name="qadiv" id="cat3_3" value="10" onClick="initDiv();"> 시스템</label></li>
                        <li><label for="cat3_4" onClick="initDiv();"><input type="radio" class="form type-c" name="qadiv" id="cat3_4" value="20" onClick="initDiv();"> 기타</label></li>
                    </ul>
                    <div class="clear"></div>
                </div>

				<div id="layoutView1" style="display:none">
                <hr class="week">
                <div class="input-block">
                    <label for="orderno" class="input-label">주문번호</label>
                    <div class="input-controls">
                        <input type="text" name="orderserial" id="orderno" class="form full-size" value="<%= orderserial %>" maxlength="11" Readonly>
                        <button class="btn side-btn type-a" onClick="popMyOrderNo();">조회</button>
                    </div>
                </div>
				<% if myorder.FResultCount>0 then %>
                <em class="em red">주문일 <%= Left(myorder.FOneItem.FRegdate,10) %> / 총 결제금액 <%= FormatNumber(myorder.FOneItem.FSubTotalPrice,0) %>원 (<%= myorder.FOneItem.getAccountDivName %>)</em>
				<% end if %>
				</div>
				<div id="layoutView2" style="display:none">
                <div class="input-block">
                    <label for="productCode" class="input-label">상품코드</label>
                    <div class="input-controls">
                        <input type="text" name="itemid" id="productCode" class="form full-size" value="<%= itemid %>" maxlength="6">
                        <button class="btn side-btn type-a"  id="btnItem1" onclick="getItemInfo(SubmitFrm);">조회</button>
                        <button class="btn side-btn type-a" id="btnItem2" onclick="popMyOrderItemID();">조회</button>
                    </div>
                </div>
                <em class="em red"><% if (ItemExists) then %><%= chrbyte(oItem.Prd.FItemName,30,"Y") %>&nbsp;<%= FormatNumber(oItem.Prd.FSellcash,0) %> 원<% else %>&nbsp;<% end if %></em>
				</div>

                <hr class="week">
                <table class="plain type-b">
                    <colgroup>
                        <col width="100"/>
                        <col/>
                        <tr>
                            <th>주문자</th>
                            <td><%=GetLoginUserName()%>
							<% if GetLoginUserID()<>"" then %>
							<input type="hidden" name="username" class="form full-size" value="<%=GetLoginUserName()%>">
							<% else %>
							<input type="text" name="username" class="form full-size" value="" maxlength="16">
							<% end if %>
							</td>
                        </tr>
                        <tr>
                            <th>아이디</th>
                            <td><% if GetLoginUserID()<>"" then %><%= GetLoginUserID() %> [<%= GetUserLevelStr(GetLoginUserLevel) %>고객]<% else %>비회원입니다.<% end if %></td>
                        </tr>
                    </colgroup>
                </table>
                <div class="input-block">
                    <label for="email" class="input-label">이메일</label>
                    <div class="input-controls">
                        <input type="email" name="usermail" id="email" class="form full-size" value="<%= GetLoginUserEmail() %>" >
                    </div>
                </div>

                <div class="input-block no-label">
                    <label for="title" class="input-label">제목</label>
                    <div class="input-controls">
                        <input type="text" name="title" id="title" class="form full-size" placeholder="제목을 입력하세요.">
                    </div>
                </div>
                <textarea name="contents" id="question" class="form bordered full-size" placeholder="내용을 입력하세요." style="height:150px; margin-bottom:5px;"></textarea>
                <div class="input-block">
                    <label for="phone" class="input-label">휴대전화</label>
                    <div class="input-controls">
                        <input type="text" name="userphone" id="userphone" class="form full-size" >
                    </div>
                </div>
                <em class="em">* 답변 등록 시 SMS가 발송됩니다.</em>
            </div>
            <div class="form-actions highlight">
                <button class="btn type-b full-size" onclick="SubmitForm(SubmitFrm);">상담하기</button>
            </div>
            </form>
        </div><!-- #content -->

        <!-- #footer -->
        <footer id="footer">

        </footer><!-- #footer -->

    </div><!-- wrapper -->
	<!-- modal layer -->
	<div class="modal" id="modalCont" style="display:none;"></div>

	<!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>
<%
	set myorder = Nothing
	set oItem = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
