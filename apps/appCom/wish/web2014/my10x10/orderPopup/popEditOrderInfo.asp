<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 마이텐바이텐
' History : 2015.06.04 한용민 생성
'####################################################
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
'' 주문 내역 변경
'' etype          [recv         , ordr          , payn        , flow          , ]
''                [배송정보수정 , 주문자정보수정, 입금자명변경, 플라워정보수정, ]
dim i, userid, orderserial, etype
userid = getEncLoginUserID()
orderserial  = requestCheckvar(request("orderserial"),11)
etype        = requestCheckvar(request("etype"),10)

dim myorder
set myorder = new CMyOrder
	if IsUserLoginOK() then
        myorder.FRectUserID = getEncLoginUserID()
        myorder.FRectOrderserial = orderserial
        myorder.GetOneOrder
	elseif IsGuestLoginOK() then
        orderserial = GetGuestLoginOrderserial()
        myorder.FRectOrderserial = orderserial
        myorder.GetOneOrder
	end if

dim myorderdetail
set myorderdetail = new CMyOrder
	myorderdetail.FRectOrderserial = orderserial
	
	if myorder.FResultCount>0 then
	    myorderdetail.GetOrderDetail
	end if

dim IsWebEditEnabled
IsWebEditEnabled = myorder.FOneItem.IsWebOrderInfoEditEnable

''상세내역도 체크
if (IsWebEditEnabled) then
    IsWebEditEnabled = IsWebEditEnabled and myorder.FOneItem.IsEditEnable_BuyerInfo(myorderdetail)
end if

if (Not IsWebEditEnabled) then
    response.write "<script>alert('주문/배송정보 수정 가능 상태가 아닙니다. 고객센터로 문의해 주세요.');fnAPPclosePopup();</script>"
    dbget.close()	:	response.End
end if

'// 티켓주문일경우 관련 정보 접수
dim IsTicketOrder, TicketDlvType, oticketItem, captionTitle
IsTicketOrder = myorder.FOneItem.IsTicketOrder
if IsTicketOrder then
	Set oticketItem = new CTicketItem
		oticketItem.FRectItemID = myorderdetail.FItemList(0).FItemID
		oticketItem.GetOneTicketItem
		TicketDlvType = oticketItem.FOneItem.FticketDlvType		'// 티켓수령방법
	Set oticketItem = Nothing
end if

%>

<script language="javascript" src="/apps/appCom/wish/web2014/lib/js/confirm.js"></script>
<script language="javascript">

<% if (etype="ordr") then %>
    function CheckNSubmit(frm){
        if (validate(frm)) {
            if (check_form_email(frm.buyemail.value) == false) {
    		    alert('이메일 주소가 유효하지 않습니다.');
    		    frm.buyemail.focus();
    		    return ;
    		}
    		if (confirm('수정 하시겠습니까?')){
                frm.submit();
            }
        }
    }

<% elseif (etype="flow") then %>
    function CheckNSubmit(frm){
        if (validate(frm)) {
    		<% if (myorder.FOneItem.IsFixDeliverItemExists) then %>
            <%
                Dim nowdate,nowtime,yyyy,mm,dd,tt,hh
                nowdate = Left(CStr(now()),10)
                nowtime = Left(FormatDateTime(CStr(now()),4),2)

                if (yyyy="") then
                	yyyy = Left(nowdate,4)
                	mm   = Mid(nowdate,6,2)
                	dd   = Mid(nowdate,9,2)
                	hh = nowtime
                    tt = nowtime + 6
                end if
            %>

            var oyear = <%= yyyy %>;
            var omonth = <%= mm %>;
            var odate = <%= dd %>;
            var ohours = <%= hh %>;
            var MinTime = <%= tt %>;

            var reqDate = new Date(frm.yyyy.value,frm.mm.value,frm.dd.value,frm.tt.value);
            var nowDate = new Date(oyear,omonth,odate,ohours);
            var nextDay = new Date(oyear,omonth,odate,24);
            var fixDate = new Date(oyear,omonth,odate,MinTime);

            if (nowDate>reqDate){
                //수정 내역이므로 지난 시간 가능.?
            	alert("지난 시간은 선택하실 수 없습니다.");
            	frm.tt.focus();
            	return;
            }else if (fixDate>reqDate){
            	alert("상품준비 시간이 최소 4~6시간입니다!\n좀더 넉넉한 시간을 선택해주세요!");
            	frm.tt.focus();
            	return;
            }
            <% end if %>

    		if (confirm('수정 하시겠습니까?')){
                frm.submit();
            }
    	}
	}

	$(document).ready(function() {
	    $("select").removeClass("input_02").addClass("select");
	});

<% else %>
    function CheckNSubmit(frm){
        if (validate(frm)) {
    		if (confirm('수정 하시겠습니까?')){
                frm.submit();
            }
        }
    }
<% end if %>

function PopOldAddress() {
	if (document.frmorder.emsAreaCode.value=="KR" || document.frmorder.emsAreaCode.value=="") {
		var url = "/apps/appCom/wish/web2014/my10x10/MyAddress/popMyAddressList.asp";
		var win = "popMyAddressList";
	} else {
		var url = "/apps/appCom/wish/web2014/my10x10/MyAddress/popSeaAddressList.asp";
		var win = "popSeaAddressList";
	}

	window.open(url,win,'width=600,height=300,scrollbars=yes,resizable=yes');
}

</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
	<form name="frmorder" method="post" action="/apps/appCom/wish/web2014/my10x10/orderPopup/EditOrderInfo_process.asp" onsubmit="return false;">
	<input type="hidden" name="mode" value="<%= etype %>">
	<input type="hidden" name="orderserial" value="<%= orderserial %>">
	
	<%if (etype="ordr") then %>
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="userInfo userInfoEidt inner10">
				<form action="">
					<fieldset>
					<legend>구매자 정보변경</legend>
						<dl class="infoInput">
							<dt><label for="purchaser">주문하신 분</label></dt>
							<dd><input type="text" id="[on,off,2,16][주문자]" name="buyname" value="<%= myorder.FOneItem.FBuyname %>" maxlength="16" autocomplete="off" style="width:100%;" /></dd>
						</dl>
						<dl class="infoInput">
							<dt><label for="email">이메일주소</label></dt>
							<dd><input type="email" id="[on,off,3,100][주문자이메일]" name="buyemail" value="<%= myorder.FOneItem.Fbuyemail %>" maxlength="100" autocomplete="off" style="width:100%;" /></dd>
						</dl>
						<dl class="infoInput">
							<dt>전화번호</dt>
							<dd>
								<p>
									<span><input type="number" id="[on,on,2,3][주문자전화1]" name="buyphone1" value="<%= SplitValue(myorder.FOneItem.Fbuyphone,"-",0) %>" maxlength="3" title="전화번호 앞자리" autocomplete="off" class="ct" style="width:100%;" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="number" id="[on,on,3,4][주문자전화2]" name="buyphone2" value="<%= SplitValue(myorder.FOneItem.Fbuyphone,"-",1) %>" maxlength="4" title="전화번호 가운데자리" autocomplete="off" class="ct" style="width:100%;" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="number" id="[on,on,3,4][주문자전화3]" name="buyphone3" value="<%= SplitValue(myorder.FOneItem.Fbuyphone,"-",2) %>" maxlength="4" title="전화번호 뒷자리" autocomplete="off" class="ct" style="width:100%;" /></span>
								</p>
							</dd>
						</dl>
						<dl class="infoInput">
							<dt>휴대전화</dt>
							<dd>
								<p>
									<span><input type="number" id="[on,on,2,3][주문자핸드폰1]" name="buyhp1" value="<%= SplitValue(myorder.FOneItem.Fbuyhp,"-",0) %>" maxlength="3" title="휴대전화 앞자리" autocomplete="off" style="width:100%;" class="ct" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="number" id="[on,on,3,4][주문자핸드폰2]" name="buyhp2" value="<%= SplitValue(myorder.FOneItem.Fbuyhp,"-",1) %>" maxlength="4" title="휴대전화 가운데자리" autocomplete="off" class="ct" style="width:100%;" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="number" id="[on,on,3,4][주문자핸드폰3]" name="buyhp3" value="<%= SplitValue(myorder.FOneItem.Fbuyhp,"-",2) %>" maxlength="4" title="휴대전화 뒷자리" autocomplete="off" class="ct" style="width:100%;" /></span>
								</p>
							</dd>
						</dl>

						<div class="btnWrap">
							<div class="ftLt w50p"><span class="button btB1 btGry2 cWh1 w100p"><button type="button" onclick="fnAPPclosePopup();">취소</button></span></div>
							<div class="ftLt w50p"><span class="button btB1 btRed cWh1 w100p"><button type="button" onClick="CheckNSubmit(document.frmorder);">수정</button></span></div>
						</div>
					</fieldset>
				</form>
			</div>
		</div>
		<!-- //content area -->

	<% elseif (etype="recv") then %>
		<%
		captionTitle = ""
	
		if (IsTicketOrder and TicketDlvType="1") then
			captionTitle = "수령인 정보 변경"
		elseif (myorder.FOneItem.IsReceiveSiteOrder) then
			captionTitle = "수령인 정보 변경"
		else
			captionTitle = "배송지 정보 변경"
		end if
		%>
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="userInfo userInfoEidt inner10">
				<fieldset>
				<legend><%= captionTitle %></legend>
					<input type="hidden" name="emsAreaCode" value="<%=myorder.FOneItem.FemsAreaCode%>" />
					
					<%
					'/해외 배송인 경우
					if (myorder.FOneItem.IsForeignDeliver) then
					%>
						<dl class="infoInput">
							<dt><label for="receiver">수령자명</label></dt>
							<dd><input type="text" id="[on,off,2,16][수령인]" name="reqname" value="<%= myorder.FOneItem.Freqname %>" autocomplete="off" style="width:100%;" /></dd>
						</dl>
						<dl class="infoInput">
							<dt><label for="receiver">이메일</label></dt>
							<dd><input type="text" id="[on,off,4,100][수령인E-mail]" name="reqemail" value="<%= myorder.FOneItem.FreqEmail %>" autocomplete="off" style="width:100%;" /></dd>
						</dl>
						<dl class="infoInput">
							<dt>전화번호 (Tel. No)</dt>
							<dd>
								<p>
									<span><input type="number" id="[on,on,2,4][수령인전화1]" name="reqphone1" value="<%=SplitValue(myorder.FOneItem.Freqphone,"-",0) %>" onkeydown="onlyNumber(this,event);" title="전화번호" autocomplete="off" class="ct" style="width:100%;" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span><input type="number" id="[on,on,2,4][수령인전화1]" name="reqphone2" value="<%=SplitValue(myorder.FOneItem.Freqphone,"-",1) %>" onkeydown="onlyNumber(this,event);" title="전화번호" autocomplete="off" class="ct" style="width:100%;" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span><input type="number" id="[on,on,2,4][수령인전화1]" name="reqphone3" value="<%=SplitValue(myorder.FOneItem.Freqphone,"-",2) %>" onkeydown="onlyNumber(this,event);" title="전화번호" autocomplete="off" class="ct" style="width:100%;" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span><input type="number" id="[on,on,2,4][수령인전화1]" name="reqphone4" value="<%=SplitValue(myorder.FOneItem.Freqphone,"-",3) %>" onkeydown="onlyNumber(this,event);" title="전화번호" autocomplete="off" class="ct" style="width:100%;" /></span>
								</p>
							</dd>
						</dl>
						<dl class="infoInput">
							<dt><label for="receiver">우편번호 (Zip code)</label></dt>
							<dd><input type="text" id="[on,off,3,20][우편번호]" name="emsZipCode" value="<%=myorder.FOneItem.FemsZipCode%>" onkeydown="onlyNumber(this,event);" autocomplete="off" style="width:100%;" /></dd>
						</dl>
						<dl class="infoInput">
							<dt><label for="receiver">상세주소 (Address)</label></dt>
							<dd><input type="text" id="[on,off,1,100][상세주소 (Address)]" name="txAddr2" value="<%= myorder.FOneItem.Freqaddress %>" autocomplete="off" style="width:100%;" /></dd>
						</dl>
						<dl class="infoInput">
							<dt><label for="receiver">도시 및 주 (City/State)</label></dt>
							<dd><input type="text" id="[on,off,1,100][도시 및 주 (City/State)]" name="txAddr1" value="<%= myorder.FOneItem.Freqzipaddr %>" autocomplete="off" style="width:100%;" /></dd>
						</dl>

					<%
					'/현장수령일 경우
					elseif (myorder.FOneItem.IsReceiveSiteOrder) then
					%>
						<dl class="infoInput">
							<dt><label for="receiver">수령자명</label></dt>
							<dd><input type="text" id="[on,off,2,16][수령인]" name="reqname" value="<%= myorder.FOneItem.Freqname %>" autocomplete="off" style="width:100%;" /></dd>
						</dl>
						<dl class="infoInput">
							<dt>전화번호</dt>
							<dd>
								<p>
									<span><input type="number" id="[on,on,2,4][수령인전화1]" name="reqphone1" value="<%=SplitValue(myorder.FOneItem.Freqphone,"-",0) %>" onkeydown="onlyNumber(this,event);" title="전화번호 앞자리" autocomplete="off" class="ct" style="width:100%;" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="number" id="[on,on,2,4][수령인전화2]" name="reqphone2" value="<%=SplitValue(myorder.FOneItem.Freqphone,"-",1) %>" onkeydown="onlyNumber(this,event);" title="전화번호 가운데자리" autocomplete="off" class="ct" style="width:100%;" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="number" id="[on,on,2,4][수령인전화3]" name="reqphone3" value="<%=SplitValue(myorder.FOneItem.Freqphone,"-",2) %>" onkeydown="onlyNumber(this,event);" title="전화번호 뒷자리" autocomplete="off" class="ct" style="width:100%;" /></span>
								</p>
							</dd>
						</dl>
						<dl class="infoInput">
							<dt>휴대전화</dt>
							<dd>
								<p>
									<span><input type="number" name="reqhp1" id="[on,on,2,4][수령인휴대폰1]" value="<%=SplitValue(myorder.FOneItem.Freqhp,"-",0) %>" onkeydown="onlyNumber(this,event);" title="휴대전화 앞자리" autocomplete="off" style="width:100%;" class="ct" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="number" name="reqhp2" id="[on,on,2,4][수령인휴대폰2]" value="<%=SplitValue(myorder.FOneItem.Freqhp,"-",1) %>" onkeydown="onlyNumber(this,event);" title="휴대전화 가운데자리" autocomplete="off" class="ct" style="width:100%;" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="number" name="reqhp3" id="[on,on,2,4][수령인휴대폰3]" value="<%=SplitValue(myorder.FOneItem.Freqhp,"-",2) %>" onkeydown="onlyNumber(this,event);"  title="휴대전화 뒷자리" autocomplete="off" class="ct" style="width:100%;" /></span>
								</p>
							</dd>
						</dl>
						<dl class="infoInput">
							<dt>수령방법</dt>
							<dd class="tMar10 cGy3 fs12 lh14">현장수령</dd>
						</dl>
					<%
					'/일반주문
					else
					%>
						<dl class="infoInput">
							<dt><label for="receiver">받으시는 분</label></dt>
							<dd><input type="text" id="[on,off,2,16][수령인]" name="reqname" value="<%= myorder.FOneItem.Freqname %>" autocomplete="off" style="width:100%;" /></dd>
						</dl>
						<dl class="infoInput">
							<dt>전화번호</dt>
							<dd>
								<p>
									<span><input type="number" id="[on,on,2,4][수령인전화1]" name="reqphone1" value="<%=SplitValue(myorder.FOneItem.Freqphone,"-",0) %>" onkeydown="onlyNumber(this,event);" title="전화번호 앞자리" autocomplete="off" class="ct" style="width:100%;" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="number" id="[on,on,2,4][수령인전화2]" name="reqphone2" value="<%=SplitValue(myorder.FOneItem.Freqphone,"-",1) %>" onkeydown="onlyNumber(this,event);" title="전화번호 가운데자리" autocomplete="off" class="ct" style="width:100%;" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="number" id="[on,on,2,4][수령인전화3]" name="reqphone3" value="<%=SplitValue(myorder.FOneItem.Freqphone,"-",2) %>" onkeydown="onlyNumber(this,event);" title="전화번호 뒷자리" autocomplete="off" class="ct" style="width:100%;" /></span>
								</p>
							</dd>
						</dl>
						<dl class="infoInput">
							<dt>휴대전화</dt>
							<dd>
								<p>
									<span><input type="number" name="reqhp1" id="[on,on,2,4][수령인휴대폰1]" value="<%=SplitValue(myorder.FOneItem.Freqhp,"-",0) %>" onkeydown="onlyNumber(this,event);" title="휴대전화 앞자리" autocomplete="off" style="width:100%;" class="ct" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="number" name="reqhp2" id="[on,on,2,4][수령인휴대폰2]" value="<%=SplitValue(myorder.FOneItem.Freqhp,"-",1) %>" onkeydown="onlyNumber(this,event);" title="휴대전화 가운데자리" autocomplete="off" class="ct" style="width:100%;" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="number" name="reqhp3" id="[on,on,2,4][수령인휴대폰3]" value="<%=SplitValue(myorder.FOneItem.Freqhp,"-",2) %>" onkeydown="onlyNumber(this,event);"  title="휴대전화 뒷자리" autocomplete="off" class="ct" style="width:100%;" /></span>
								</p>
							</dd>
						</dl>
						
						<% if Not (IsTicketOrder and TicketDlvType="1") then %>
							<dl class="infoInput">
								<dt>주소</dt>
								<dd>
									<p>
										<span style="width:25%;"><input type="text" id="[on,off,5,10][우편번호]" name="txZip" value="<%= myorder.FOneItem.Freqzipcode %>" readonly title="우편번호" autocomplete="off" class="ct" style="width:100%;" /></span>
										&nbsp;<span class="button btS1 btGry cBk1"><a href="" onclick="TnFindZipNew('frmorder',''); return false;">우편번호 검색</a></span>
									</p>
									<p class="tPad05">
										<input type="text" id="[on,off,1,100][주소1]" name="txAddr1" value="<%= myorder.FOneItem.Freqzipaddr %>" readonly title="기본 주소" autocomplete="off" style="width:100%;" />
									</p>
									<p class="tPad05">
										<input type="text" id="[on,off,1,100][주소2]" name="txAddr2" value="<%= myorder.FOneItem.Freqaddress %>" maxlength="100" title="상세 주소" autocomplete="off" style="width:100%;" />
									</p>
								</dd>
							</dl>
						<% end if %>
						
						<% if Not(myorder.FOneItem.IsReceiveSiteOrder or (IsTicketOrder and TicketDlvType="1")) then %>
							<dl class="infoInput">
								<dt><label for="notication">유의사항</label></dt>
								<dd><input type="text" id="[off,off,off,off][배송유의사항]" name="comment" value="<%= myorder.FOneItem.Fcomment %>" maxlength="100" autocomplete="off" style="width:100%;" /></dd>
							</dl>
						<% end if %>
					<% end if %>

					<div class="btnWrap">
						<div class="ftLt w50p"><span class="button btB1 btGry2 cWh1 w100p"><button type="button" onclick="fnAPPclosePopup();">취소</button></span></div>
						<div class="ftLt w50p"><span class="button btB1 btRed cWh1 w100p"><button type="button" onClick="CheckNSubmit(document.frmorder);">수정</button></span></div>
					</div>
				</fieldset>
			</div>

		</div>
		<!-- //content area -->

	<% elseif (etype="flow") then %>
		<!-- content area -->
		<div class="content" id="contentArea">

			<div class="userInfo userInfoEidt inner10">
				<form action="">
					<fieldset>
					<legend>플라워 정보변경</legend>
						<dl class="infoInput">
							<dt><label for="sender">보내시는 분</label></dt>
							<dd><input type="text" id="[off,off,off,16]보내는 사람" name="fromname" value="<%= myorder.FOneItem.Ffromname %>" maxlength="16" autocomplete="off" style="width:100%;" /></dd>
						</dl>
						<dl class="infoInput">
							<dt>희망배송일</dt>
							<dd>
								<p>
									<span style="width:25%;">
										<select name="yyyy" title="희망배송일 년도 선택" style="width:100%;">
										    <% for i=Year(date()-1) to Year(date()+1) %>
												<% if (CStr(i)=CStr(SplitValue(myorder.FOneItem.Freqdate,"-",0))) then %>
													<option value='<%= CStr(i) %>' selected><%= CStr(i) %></option>
												<% else %>
										    		<option value="<%= CStr(i) %>"><%= CStr(i) %></option>
												<% end if %>
											<% next %>
										</select>
									</span>&nbsp;
									<span title="희망배송일 월 선택" style="width:25%;">
										<select name="mm" style="width:100%;">
										    <% for i=1 to 12 %>
												<% if (Format00(2,i)=Format00(2,SplitValue(myorder.FOneItem.Freqdate,"-",1))) then %>
													<option value='<%= Format00(2,i) %>' selected><%= Format00(2,i) %></option>
												<% else %>
										    	    <option value='<%= Format00(2,i) %>'><%= Format00(2,i) %></option>
												<% end if %>
											<% next %>
										</select>
									</span>&nbsp;
									<span style="width:25%;">
										<select name="dd" title="희망배송일 일 선택" style="width:100%;">
										    <% for i=1 to 31 %>
												<% if (Format00(2,i)=Format00(2,SplitValue(myorder.FOneItem.Freqdate,"-",2))) then %>
											    	<option value='<%= Format00(2,i) %>' selected><%= Format00(2,i) %></option>
												<% else %>
										        	<option value='<%= Format00(2,i) %>'><%= Format00(2,i) %></option>
												<% end if %>
										    <% next %>
										</select>
									</span>&nbsp;
									<span style="width:25%;">
										<select name="tt" title="희망배송일 시간 선택" style="width:100%;">
										    <% for i=9 to 18 %>
												<% if (Format00(2,i)=Format00(2,tt)) then %>
										        	<option value='<%= CStr(i) %>' selected><%= CStr(i) %>~<%= CStr(i + 2) %></option>
												<% else %>
										        	<option value='<%= CStr(i) %>'><%= CStr(i) %>~<%= CStr(i + 2) %></option>
												<% end if %>
										    <% next %>
										</select>
									</span>
								</p>
							</dd>
						</dl>
						<dl class="infoInput fwrMsgSlt">
							<dt>메시지 선택</dt>
							<dd>
								<p>
									<span class="lt"><input type="radio" name="cardribbon" id="msgSelect01" value="1" <% if myorder.FOneItem.Fcardribbon="1" then response.write "checked" %> /> <label for="msgType01">카드</label></span>
									<span class="lt"><input type="radio" name="cardribbon" id="msgSelect02" value="2" <% if myorder.FOneItem.Fcardribbon="2" then response.write "checked" %> /> <label for="msgType02">리본</label></span>
									<span class="lt"><input type="radio" id="msgSelect03" value="3" <% if myorder.FOneItem.Fcardribbon="3" then response.write "checked" %> /> <label for="msgType03">없음</label></span>
								</p>
							</dd>
						</dl>
						<dl class="infoInput">
							<dt><label for="msgDesc">메시지 내용</label></dt>
							<dd>
								<p>
									<textarea id="[off,off,off,100]메세지 내용" name="message" cols="50" rows="5" autocomplete="off" style="width:100%; height:100px;"><%= myorder.FOneItem.Fmessage %></textarea>
								</p>
							</dd>
						</dl>

						<div class="btnWrap">
							<% if (myorder.FOneItem.IsFixDeliverItemExists) then %>
								<input type="hidden" name="fixdeliveryedit" value="on" />
								<div class="ftLt w50p"><span class="button btB1 btGry2 cWh1 w100p"><button type="button" onclick="fnAPPclosePopup();">취소</button></span></div>
								<div class="ftLt w50p"><span class="button btB1 btRed cWh1 w100p"><button type="button" onClick="CheckNSubmit(document.frmorder);">수정</button></span></div>
							<% else %>
								플라워 배송정보를 수정할 수 없습니다. 고객센터로 문의해 주세요.
							<% end if %>
						</div>
					</fieldset>
				</form>
			</div>

		</div>
		<!-- //content area -->
	<% end if %>

	</form>
	</div>
</div>
</body>
</html>

<%
set myorder = Nothing
set myorderdetail = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->