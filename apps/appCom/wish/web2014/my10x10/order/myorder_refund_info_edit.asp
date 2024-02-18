<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

'####################################################
' Description : 마이텐바이텐 - 환불 계좌 정보 수정
' History : 2020-11-24 정태훈 생성
'####################################################
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/inc/incForceSSL.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<%
'해더 타이틀
strHeadTitleName = "품절 시 처리 방법"

dim userid, rebankname, rebankownername, encaccount
userid = getEncLoginUserID()

if userid<>"" then
    fnSoldOutMyRefundInfo userid, rebankname, rebankownername, encaccount
end if
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script>
function fnMyRefundInfoEdit(){
    frmedit = document.frmedit;
    if(frmedit.rebankname.value==""){
        alert('환불 받을 계좌의 은행을 선택해주세요.');
        frmedit.rebankname.focus();
        return;
    }
    if(frmedit.encaccount.value==""){
        alert('계좌번호를 정확히 입력해주세요.');
        frmedit.encaccount.focus();
        return;
    }
    if(frmedit.rebankownername.value==""){
        alert('예금주를 정확히 입력해주세요.');
        frmedit.rebankownername.focus();
        return;
    }
    if(confirm("입력된 환불 계좌 정보로 변경하시겠습니까?")){
        frmedit.submit();
    }
}
function fnCloseWin(){
    self.opener = self;
    self.close();
}
</script>
</head>
<body class="default-font body-sub body-1depth">
	<div id="content" class="content">
        <form name="frmedit" method="post" action="refundinfo_process.asp" style="margin:0px;">
		<div class="cartV16a inner10 bgWht">
			<div class="tPad20 ct">
				<p class="fs1-2r">빠른 주문 처리를 위해 품절 발생 시 별도의 연락을 하지 않고 입력하신 계좌로 안전하게 환불해 드립니다.</p>
			</div>
			<div class="infoUnitV16a pad0 tPad20">
				<dl class="infoArrayV16a">
					<dt class="vTop">환불 은행 선택</dt>
					<dd>
                        <select name="rebankname" id="rebankname" style="width:100%;">
                            <option value=''>선택</option>
                            <option value='경남' <% if rebankname="경남" then response.write "selected" %>>경남</option>
                            <option value='광주' <% if rebankname="광주" then response.write "selected" %>>광주</option>
                            <option value='국민' <% if rebankname="국민" then response.write "selected" %>>국민</option>
                            <option value='기업' <% if rebankname="기업" then response.write "selected" %>>기업</option>
                            <option value='농협' <% if rebankname="농협" then response.write "selected" %>>농협</option>
                            <option value='단위농협' <% if rebankname="단위농협" then response.write "selected" %>>단위농협</option>
                            <option value='대구' <% if rebankname="대구" then response.write "selected" %>>대구</option>
                            <option value='도이치' <% if rebankname="도이치" then response.write "selected" %>>도이치</option>
                            <option value='부산' <% if rebankname="부산" then response.write "selected" %>>부산</option>
                            <option value='산업' <% if rebankname="산업" then response.write "selected" %>>산업</option>
                            <option value='새마을금고' <% if rebankname="새마을금고" then response.write "selected" %>>새마을금고</option>
                            <option value='수협' <% if rebankname="수협" then response.write "selected" %>>수협</option>
                            <option value='신한' <% if rebankname="신한" then response.write "selected" %>>신한</option>
                            <option value='KEB하나' <% if rebankname="KEB하나" then response.write "selected" %>>KEB하나</option>
                            <option value='우리' <% if rebankname="우리" then response.write "selected" %>>우리</option>
                            <option value='우체국' <% if rebankname="우체국" then response.write "selected" %>>우체국</option>
                            <option value='전북' <% if rebankname="전북" then response.write "selected" %>>전북</option>
                            <option value='제일' <% if rebankname="제일" then response.write "selected" %>>제일</option>
                            <option value='시티' <% if rebankname="시티" then response.write "selected" %>>시티</option>
                            <option value='홍콩샹하이' <% if rebankname="홍콩샹하이" then response.write "selected" %>>홍콩샹하이</option>
                            <option value='ABN암로은행' <% if rebankname="ABN암로은행" then response.write "selected" %>>ABN암로은행</option>
                            <option value='UFJ은행' <% if rebankname="UFJ은행" then response.write "selected" %>>UFJ은행</option>
                            <option value='신협' <% if rebankname="신협" then response.write "selected" %>>신협</option>
                            <option value='제주' <% if rebankname="제주" then response.write "selected" %>>제주</option>
                            <option value='현대스위스상호저축은행' <% if rebankname="현대스위스상호저축은행" then response.write "selected" %>>현대스위스상호저축은행</option>
                            <option value='케이뱅크' <% if rebankname="케이뱅크" then response.write "selected" %>>케이뱅크</option>
                            <option value='카카오뱅크' <% if rebankname="카카오뱅크" then response.write "selected" %>>카카오뱅크</option>
                        </select>
					</dd>
				</dl>
				<dl class="infoArrayV16a">
					<dt class="vTop">환불 계좌번호</dt>
					<dd><input type="text" name="encaccount" value="<%=encaccount%>" style="width:100%;"></dd>
				</dl>
				<dl class="infoArrayV16a">
					<dt class="vTop">예금주</dt>
					<dd><input type="text"  name="rebankownername" value="<%=rebankownername%>" style="width:100%;"></dd>
				</dl>
			</div>
			<div class="cartNotiV16a pad0 tMar05">
				<ul>
					<li>주문 취소일 기준으로 3-5일(주말제외) 후 환불금액이 입금됩니다.</li>
				</ul>
			</div>
			<div class="myOrderView tMar25">
				<span class="button btM1 btRed cWh1 w100p"><a href="javascript:fnMyRefundInfoEdit();">변경하기</a></span>
			</div>
		</div>
        </form>
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->