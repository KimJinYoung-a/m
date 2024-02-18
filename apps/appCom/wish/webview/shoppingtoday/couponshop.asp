<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  쿠폰북
' History : 2014.06.25 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/enjoy/couponshopcls.asp" -->
<%
Dim stab, vProdCouponCnt, vEventCouponCnt, vProdfreeCouponCnt, arritemList, cCouponMaster, intLoop, arrItem, intItem, k, stype
dim userid, cbonus_item_coupon_all, arrbonusitemlist,ix, strGubun
	stab = requestCheckVar(Request("stab"),5)
	stype = requestCheckVar(Request("stype"),1)
	userid = GetLoginUserID

vEventCouponCnt = 0
vProdCouponCnt	= 0
vProdfreeCouponCnt = 0

If stab = "" Then
	'stab = "all"
	stab = "sale"
	'stab = "free"
	'stab = "bonus"
End If
If stype = "" Then
	'stype = 1
	stype = 2
	'stype = 3
	'stype = 0
End If

'//상품쿠폰, 보너스쿠폰 한번에 다 가져옴
set cbonus_item_coupon_all = new ClsCouponShop
	arrbonusitemlist = cbonus_item_coupon_all.fnGetCouponList
Set cbonus_item_coupon_all = nothing

'//쿠폰 종류별로 카운트 셈
if isarray(arrbonusitemlist) then
	For intLoop = 0 To UBound(arrbonusitemlist,2)
		'//보너스 쿠폰
		If arrbonusitemlist(0,intLoop) ="event" Then
			vEventCouponCnt = vEventCouponCnt + 1
		
		'//상품 쿠폰
		Else
			'//무료배송 쿠폰
			IF arrbonusitemlist(2,intLoop) = 3 THEN
				vProdfreeCouponCnt = vProdfreeCouponCnt + 1
			
			'//할인쿠폰
			else
				vProdCouponCnt = vProdCouponCnt + 1
			end if		
		End IF
	Next

	if stab="sale" or stab="free" then
		'//상품쿠폰
		set cCouponMaster = new ClsCouponShop
			cCouponMaster.Ftype = stype
			arritemList = cCouponMaster.fnGetCouponTabList
	end if
end if
%>

<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->

<script style="text/javascript">

	function changetab(stab,stype){
	   self.location.href = "/apps/appcom/wish/webview/shoppingtoday/couponshop.asp?stab="+stab+"&stype="+stype;
	}

	function PopItemCouponAssginList(iidx){
		//var popwin = window.open('/apps/appcom/wish/webview/my10x10/Pop_CouponItemList.asp?itemcouponidx=' + iidx + '&tab=Y','PopItemCouponAssginList','width=700,height=800,scrollbars=yes,resizable=yes');
		//popwin.focus();
		top.location.href='/apps/appcom/wish/webview/my10x10/Pop_CouponItemList.asp?itemcouponidx=' + iidx + '&tab=Y'
	}

	function jsDownCoupon(stype,idx){
		if ("<%=IsUserLoginOK%>"=="False") {
			jsChklogin('<%=IsUserLoginOK%>');
			return;
		}

		var frm;
		frm = document.frmC;
		frm.stype.value = stype;
		frm.idx.value = idx;
		frm.submit();
	}

	function jsDownSelCoupon(sgubun,gubun){
		if ("<%=IsUserLoginOK%>"=="False") {
			jsChklogin('<%=IsUserLoginOK%>');
			return;
		}
	
		var chkCnt = 0;
		var stype = "";
		var idx = "";
		var frm = document.frmC;
	
		if(sgubun=="A"){
			if(frm.allidx){
				if (!frm.allidx.length){
					 stype = frm.allidx.stype;
					 idx = frm.allidx.value;
					 chkCnt = 1;
				} else {
			 		for(i=0;i<frm.allidx.length;i++) {
		 				if (chkCnt == 0 ) {
		 					stype = frm.allidx[i].getAttribute("stype");
		 					idx = frm.allidx[i].value;
		 				} else {
		 					stype =stype+"," +frm.allidx[i].getAttribute("stype");
		 					idx = idx+"," +frm.allidx[i].value;
		 				}
		 				chkCnt += 1;
			 		}
			 	}
		 	}else{
		 		alert("등록된 쿠폰이 없습니다.");
		 		return;
		 	}
	  	 }else{
		  	 if(frm.chkidx){
					if (!frm.chkidx.length){
						if (frm.chkidx.checked) {
							if(frm.chkidx.stype == gubun){
								stype = frm.chkidx.stype;
								idx = frm.chkidx.value;
								chkCnt = 1;
							}
						}
					}else{
				 		for(i=0;i<frm.chkidx.length;i++){
				 			if(frm.chkidx[i].getAttribute("stype") == gubun){
								if (frm.chkidx[i].checked) {
									if ( chkCnt == 0 ){
										stype = frm.chkidx[i].getAttribute("stype");
										idx = frm.chkidx[i].value;
									}else{
										stype =stype+"," +frm.chkidx[i].getAttribute("stype");
										idx = idx+"," +frm.chkidx[i].value;
									}
									chkCnt += 1;
								}
					 		}
				 		}
				 	}
			 	}else{
			 		alert("등록된 쿠폰이 없습니다.");
		 			return;
			 	}
	
		 	if ( chkCnt == 0 ){
		 		alert("다운받으실 쿠폰을 선택해 주세요.");
		 		return;
		 	}
	  	 }
	
	  	frm.stype.value = stype;
	  	frm.idx.value =idx;
		frm.submit();
	}

</script>
</head>
<body class="event">
<!-- wrapper -->
<div class="wrapper myinfo">
    <!-- #content -->
    <div id="content">
        <div class="inner">
            <div class="diff"></div>
            <div class="main-title">
                <h1 class="title"><span class="label">쿠폰북</span></h1>
            </div>
        </div>

        <div class="well type-b type-cp">
            <ul class="txt-list">
                <li>텐바이텐 회원을 위해 준비된 할인 쿠폰입니다.<br> (비회원 적용 불가)</li>
                <li>발행된 쿠폰은 [마이텐바이텐]에서<br> 확인하실 수 있습니다.</li>
            </ul>
            <a href="" onclick="jsDownSelCoupon('A','event'); return false;" class="btn-down-all"><span>쿠폰 전체<br> 다운받기</span></a>
        </div>

		<form name="frmC" method="post" action="/apps/appcom/wish/webview/shoppingtoday/couponshop_process.asp" style="margin:0px;">
		<input type="hidden" name="stype" value="">
		<input type="hidden" name="idx" value="">
        <div class="inner">
            <div class="tabs type-c three">
                <a href="" <% if stab="sale" then response.write " class='active'" %> onclick="changetab('sale','2'); return false;"><span class="label">할인쿠폰 (<span><%= vProdCouponCnt %></span>)</span></a>
                <a href="" <% if stab="bouns" then response.write " class='active'" %> onclick="changetab('bouns','0'); return false;"><span class="label">보너스쿠폰 (<span><%= vEventCouponCnt %></span>)</span></a>
                <a href="" <% if stab="free" then response.write " class='active'" %> onclick="changetab('free','3'); return false;"><span class="label">무료배송쿠폰 (<span><%= vProdfreeCouponCnt %></span>)</span></a>
            </div>
            <div class="diff"></div>

			<%
			'//쿠폰 전체 다운받기
			If vProdCouponCnt > 0 or vEventCouponCnt >0  or vProdfreeCouponCnt>0 Then
			%>
				<% if isarray(arrbonusitemlist) then %>
					<% For intLoop = 0 To UBound(arrbonusitemlist,2) %>
						<input name="allidx" type="hidden" value="<%=arrbonusitemlist(1,intLoop)%>" stype="<%=arrbonusitemlist(0,intLoop)%>">
					<% Next %>
				<% end if %>
			<%	End If	%>

			<% if stab="sale" then %>
				<% If isarray(arritemList) Then %>
					<!-- 할인쿠폰 -->
					<ul class="coupon-list">
						<% For intLoop = 0 To UBound(arritemList,2) %>
						<% If arritemList(0,intLoop) <> "event" Then %>
							<li class="coupon-box">
								<div class="gutter">
									<p class="amount green">
										<!-- 할인쿠폰 -->
										<% if arritemList(2,intLoop)="1" then %>
											<strong class="green"><%= arritemList(3,intLoop) %>%</strong><span class="unit">할인</span>
										<% else %>
											<strong class="green"><%= arritemList(3,intLoop) %>원</strong><span class="unit">할인</span>
										<% end if %>
									</p>
									<p class="desc"><%=chrbyte(db2html(arritemList(4,intLoop)),30,"Y")%></p>
									<p class="period">유효기간 : <%=FormatDate(arritemList(7,intLoop),"0000.00.00")%> ~ <%=FormatDate(arritemList(8,intLoop),"0000.00.00")%></p>
								</div>
								<div class="condition btn-cp-area">
									<div class="half"><button onclick="jsDownCoupon('<%=arritemList(0,IntLoop)%>','<%=arritemList(1,IntLoop)%>');" class="btn type-h small">쿠폰다운받기</button></div>
									<div class="half"><a href="" onclick="PopItemCouponAssginList('<%=arritemList(1,intLoop)%>'); return false;" class="btn type-i small">적용상품보기</a></div>
								</div>
							</li>
						<% End If %>
						<% Next %>
					</ul>
					<div class="diff"></div>
					<!-- //할인쿠폰 -->
				<% end if %>
			<% end if %>

			<% if stab="bouns" then %>
				<% If vEventCouponCnt > 0 Then %>
					<!-- 보너스쿠폰 -->
					<ul class="coupon-list">
						<% For intLoop = 0 To UBound(arrbonusitemlist,2) %>
						<% If arrbonusitemlist(0,intLoop) = "event" Then %>
							<li class="coupon-box">
								<div class="gutter">
									<p class="amount green">
										<% if arrbonusitemlist(2,intLoop)="1" then %>
											<strong class="green"><%= arrbonusitemlist(3,intLoop) %>%</strong><span class="unit">할인</span>
										<% else %>
											<strong class="green"><%= arrbonusitemlist(3,intLoop) %>원</strong><span class="unit">할인</span>
										<% end if %>
									</p>
									<p class="desc"><%=chrbyte(db2html(arrbonusitemlist(4,intLoop)),30,"Y")%></p>
									<p class="period">유효기간 : <%=FormatDate(arrbonusitemlist(7,intLoop),"0000/00/00")%> ~ <%=FormatDate(arrbonusitemlist(8,intLoop),"0000/00/00")%></p>
									<p class="terms">텐바이텐 배송 상품금액 <%= FormatNumber(arrbonusitemlist(9,intLoop),0) %>원 이상</p>
								</div>
								<div class="condition btn-cp-area">
									<div class="half"><button onclick="jsDownCoupon('<%=arrbonusitemlist(0,IntLoop)%>','<%=arrbonusitemlist(1,IntLoop)%>');" class="btn type-h small">쿠폰다운받기</button></div>
								</div>
							</li>
						<% End If %>
						<% Next %>
					</ul>
					<div class="diff"></div>
					<!-- //보너스쿠폰 -->
				<%	End If	%>
			<% end if %>

			<% if stab="free" then %>
				<% If isarray(arritemList) Then %>						
					<!-- 무료배송쿠폰 -->
					<ul class="coupon-list">
						<% For intLoop = 0 To UBound(arritemList,2) %>
						<% If arritemList(0,intLoop) <> "event" Then %>
							<li class="coupon-box">
								<div class="gutter">
									<p class="amount green">
										<strong class="green">무료배송</strong></span>
									</p>
									<p class="desc"><%=chrbyte(db2html(arritemList(4,intLoop)),30,"Y")%></p>
									<p class="period">유효기간 : <%=FormatDate(arritemList(7,intLoop),"0000/00/00")%> ~ <%=FormatDate(arritemList(8,intLoop),"0000/00/00")%></p>
								</div>
								<div class="condition btn-cp-area">
									<div class="half"><button onclick="jsDownCoupon('<%=arritemList(0,IntLoop)%>','<%=arritemList(1,IntLoop)%>');" class="btn type-h small">쿠폰다운받기</button></div>
									<div class="half"><a href="" onclick="PopItemCouponAssginList('<%=arritemList(1,intLoop)%>'); return false;" class="btn type-i small">적용상품보기</a></div>
								</div>
							</li>
						<% End If %>
						<% Next %>
					</ul>
					<div class="diff"></div>
					<!-- //무료배송쿠폰 -->
				<% end if %>
			<% end if %>
        </div>
        </form>
    </div>
    <!-- #content -->

    <!-- #footer -->
    <footer id="footer">
    </footer>
    <!-- #footer -->
    
</div>
<!-- wrapper -->
</body>
</html>
<%
Set cCouponMaster = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->