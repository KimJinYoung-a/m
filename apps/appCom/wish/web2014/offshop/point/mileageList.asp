<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
'##################################################
' PageName : /offshop/point/popmileagelist.asp
' Description : 오프라인샾 point1010 포인트 조회
' History : 2015-04-21 이종화 생성
'			2019-01-16 최종원 - 리뉴얼
'##################################################
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/offshop/lib/classes/offshopCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_mileage_logcls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
	Dim onoff , page , iPageSize 
	onoff = requestCheckvar(request("onoff"),1)
	page  =	requestCheckvar(request("page"),9)

	If onoff = "" Then onoff = "o"
	If page = "" Then page = "1"

	iPageSize = 1000

	'//온라인 total-mileage
	dim myMileage
	set myMileage = new TenPoint
	myMileage.FRectUserID = getEncLoginUserID
	if (getEncLoginUserID<>"") then
		myMileage.getTotalMileage

		Call SetLoginCurrentMileage(myMileage.FTotalmileage)
	end If
	
	'//온라인 마일리지
	dim myMileageLog , i
	set myMileageLog = New CMileageLog
	myMileageLog.FPageSize = iPageSize
	myMileageLog.FCurrPage = Cint(page)
	myMileageLog.FRectUserid = getEncLoginUserID
	myMileageLog.FRectMileageLogType = "A"
	myMileageLog.FRectShowDelete = "N"
	if (getEncLoginUserID<>"") then
	If onoff = "o" Then
		myMileageLog.getMileageLogAll
	End if
    End if
    
	'//오프라인 total-mileage
	dim myOffMileage
	set myOffMileage = new TenPoint
	myOffMileage.FGubun = "my10x10"
	myOffMileage.FRectUserID = getEncLoginUserID
	if (getEncLoginUserID<>"") then
		myOffMileage.getOffShopMileagePop
	end If
	
	'//오프라인 마일리지
	Dim iTotCnt , iTotalPage
	Dim vGoPoint, arrPointList , intN
	Dim ClsOSPoint
	set ClsOSPoint = new COffshopPoint1010

	vGoPoint = Request("cardgubun")
	If vGoPoint = "" Then
		vGoPoint = "1010"
	End If	
							
	ClsOSPoint.FCPage	= Cint(page)
	ClsOSPoint.FPSize	= iPageSize
	ClsOSPoint.FGubun 	= vGoPoint

	If onoff = "f" Then
		arrPointList = ClsOSPoint.fnGetMyCardPointList
		iTotCnt = ClsOSPoint.FTotCnt
	End If
%>
<script>
	function goPage(page) {
		document.frm.page.value = page;
		document.frm.submit();
	}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">	
	<!-- contents -->
	<div id="content" class="content my-own-detail mileage-index">
        <div class="own-info">
            <h2>나의 모든 마일리지</h2>
            <p><em><%=FormatNumber(getLoginCurrentMileage(),0)%></em>P</p>
            <div class="btn-group">
				<a href="" onclick="fnAPPpopupBrowserURL('멤버십 안내','<%=wwwUrl%>/apps/appCom/wish/web2014/offshop/point/popcardbenefit.asp','right','','sc'); return false;" class="btn-half">멤버십 마일리지 안내</a>				
                <a href="" onclick="fnAPPpopupBrowserURL('마일리지 전환','<%=M_SSLUrl%>/apps/appCom/wish/web2014/offshop/point/popmileagechange.asp');return false;" class="btn-half">마일리지 전환</a>								
            </div>            
			<div class="btn-membership-card"><a href="" onclick="fnAPPpopupBrowserURL('바코드','<%=wwwUrl%>/apps/appCom/wish/web2014/offshop/point/popbarcode.asp'); return false;">텐바이텐 멤버십카드 보기</a></div>
            <div class="btn-regist">
				<a href="" onclick="fnAPPpopupBrowserURL('멤버십카드 등록','<%=wwwUrl%>/apps/appCom/wish/web2014/offshop/point/cardregister.asp'); return false;">								
					<span class="icon-plus icon-plus-white"></span>
				</a>
			</div>
        </div>
        <div class="notify">오프라인 매장에서 적립된 마일리지를 온라인 쇼핑몰에서 사용하시려면 오프라인 &gt; 온라인 마일리지 전환이 필요합니다.</div>
        <div class="nav nav-stripe nav-stripe-large nav-stripe-red">
            <ul class="grid2">
                <li><a href="?page=1&onoff=o" class="<%=chkiif(onoff="o","on","")%>"><span class="name">온라인</span><b class="point"><%=FormatNumber(myMileage.FTotalMileage,0) %>P</b></a></li>
                <li><a href="?page=1&onoff=f" class="<%=chkiif(onoff="f","on","")%>"><span class="name">오프라인 매장</span><b class="point"><%=FormatNumber(myOffMileage.FOffShopMileage,0) %>P</b></a></li>
            </ul>
        </div>	
        <div class="own-history">
            <ul>
<% if (myMileageLog.FresultCount > 0) then %>
	<% 
	   dim tmpMileageTxtColorCls	
	   dim tmpMileageLog
	   dim sign 

	   for i=0 to myMileageLog.FResultCount - 1 	  			
	   		tmpMileageLog = FormatNumber(myMileageLog.FItemList(i).Fmileage, 0)

			if myMileageLog.FItemList(i).Fmileage < 0 then
				tmpMileageTxtColorCls = "price color-blue"				
				sign=""
			else
				tmpMileageTxtColorCls = "price color-red"						
				sign = "+"
			end if
	     
	%>
		<li>
			<span class="date">
				<span class="day"><%= formatdate(myMileageLog.FItemList(i).FRegdate,"0000.00.00") %></span>
				<span class="time"><%=FormatDateTime(myMileageLog.FItemList(i).FRegdate, 3) %></span>
			</span>
			<span class="desc">
				<em><%= myMileageLog.FItemList(i).Fjukyo %></em>
				<span class="<%= tmpMileageTxtColorCls %>"><%=sign & tmpMileageLog%>P</span>
			</span>
		</li>
	<% next %>
<% else %>			
		<li class="no-data">
			<span class="no-data">마일리지 적립/사용 내역이 없습니다.</span>
		</li>
<% end if %>
            </ul>
        </div>
	</div>
	<!-- //contents -- >					
			<!-- content area -->
			<!--
			<div class="content" id="contentArea">
				<div class="inner10 mgList">					
					<ul class="myTenNoti tMar10">
						<li>마일리지는 부여된 해로부터 5년 이내 사용가능 합니다.</li>
						<li>3만원 이상 구매 시 현금처럼 사용하실 수 있습니다.</li>
						<li>구매 마일리지는 상품출고 후 적립 및 사용이 가능합니다.</li>
					</ul>
					<p class="ct tMar20"><span class="button btB1 btRed cWh1 w70p"><a href="" onclick="fnAPPpopupBrowserURL('마일리지 전환','<%=M_SSLUrl%>/apps/appCom/wish/web2014/offshop/point/popmileagechange.asp');return false;">온라인 마일리지로 전환</a></span></p>
					<div class="tab02 tMar20">
						<ul class="tabNav tNum2">
							<li class="<%=chkiif(onoff="o","current","")%>"><a href="/apps/appcom/wish/web2014/offshop/point/mileagelist.asp?page=1&onoff=o">온라인(<%=FormatNumber(myMileage.FTotalMileage,0) %>p)</a></li>
							<li class="<%=chkiif(onoff="f","current","")%>"><a href="/apps/appcom/wish/web2014/offshop/point/mileagelist.asp?page=1&onoff=f">오프라인(<%=FormatNumber(myOffMileage.FOffShopMileage,0) %>p)</a></li>
						</ul>
						<div class="tabContainer">
							<% If onoff = "o" Or isnull(onoff) Then %>
							<div id="online" class="tabContent">
								<table class="listTable05">
								<colgroup>
									<col width="30%">
									<col width="">
									<col width="30%">
								</colgroup>
								<thead>
								<tr>
									<th>날짜</th>
									<th>내용</th>
									<th>적립/사용</th>
								</tr>
								</thead>
								<tbody>
								<% if (myMileageLog.FresultCount > 0) then %>
								<% for i=0 to myMileageLog.FResultCount - 1 %>
								<tr>
									<td><%= formatdate(myMileageLog.FItemList(i).FRegdate,"0000/00/00") %></td>
									<td><%= myMileageLog.FItemList(i).Fjukyo %></td>
									<td><%= FormatNumber(myMileageLog.FItemList(i).Fmileage, 0) %>p</td>
								</tr>
								<% next %>
								<% Else %>
								<tr>
									<td colspan="3">포인트 적립 및 사용내역이 없습니다.</td>
								</tr>
								<% End If %>
								</tbody>
								</table>
								<% if (myMileageLog.FresultCount > 0) then %>
								<div class="paging">
									<%=fnDisplayPaging_New(myMileageLog.FCurrpage,myMileageLog.FTotalCount,iPageSize,4,"goPage")%>
								</div>
								<% End If %>
							</div>
							<% End If %>
							<% If onoff = "f" Then %>
							<div id="offline" class="tabContent">
								<table class="listTable05">
								<colgroup>
									<col width="30%">
									<col width="">
									<col width="30%">
								</colgroup>
								<thead>
								<tr>
									<th>날짜</th>
									<th>내용</th>
									<th>적립/사용</th>
								</tr>
								</thead>
								<tbody>
								<%	
									IF isArray(arrPointList) Then 
										iTotalPage 	=  Int(iTotCnt/iPageSize)
										IF (iTotCnt MOD iPageSize) > 0 THEN	iTotalPage = iTotalPage + 1

										For intN =0 To UBound(arrPointList,2)
								%>
								<tr>
									<td><%=formatdate(arrPointList(2,intN),"0000/00/00")%></td>
									<td>
										<%
											'### 포인트 0이고 code가 3(포인트이관)일때 카드등록으로 나타냄.
											If arrPointList(5,intN) = "0" AND arrPointList(7,intN) = "3" Then
												Response.Write arrPointList(8,intN)
											Else
												Response.Write arrPointList(3,intN)
											End IF
										%>
									</td>
									<td><%=FormatNumber(arrPointList(5,intN),0)%>p</td>
								</tr>
								<%
										Next
									Else
								%>
								<tr>
									<td colspan="3">포인트 적립 및 사용내역이 없습니다.</td>
								</tr>
								<% End If %>
								</tbody>
								</table>
								<% IF isArray(arrPointList) Then  %>
								<div class="paging">
									<%=fnDisplayPaging_New(ClsOSPoint.FCPage,ClsOSPoint.FTotCnt,iPageSize,4,"goPage")%>
								</div>
								<% End If %>
							</div>
							<% End If %>
							<form name="frm" method="get" action="/apps/appcom/wish/web2014/offshop/point/mileagelist.asp" style="margin:0px;">
							<input type="hidden" name="page" >
							<input type="hidden" name="onoff" value="<%=onoff%>">
							</form>
						</div>
					</div>
				</div>
			</div>
			-->
			<!-- //content area -->
		</div>
	</div>
</div>
</body>
</html>
<% 
	set myOffMileage = Nothing
	set myMileage = Nothing
	Set myMileageLog = Nothing
	Set ClsOSPoint = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->