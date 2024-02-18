<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/event/weddingCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'#######################################################
' Discription : wedding_plan_event // cache DB경유
' History : 2018-04-11 정태훈 생성
'#######################################################
Dim poscode , icnt ,jcnt, totalsaleper, totalprice
Dim sqlStr , rsMem, arrList, intI
Dim cEventItem, iTotCnt

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "WeddingMobilePlanEvent_"&Cint(timer/60)
Else
	cTime = 60*5
	dummyName = "WeddingMobilePlanEvent"
End If

'// foryou
sqlStr = "EXEC [db_sitemaster].[dbo].[usp_WWW_Wedding_PlanEvent_Mobile_Get]"
set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close


on Error Resume Next
%>
<base href="http://m.10x10.co.kr/">
<script type="text/javascript">
<!--
function fnWeddingEventView(){
<% If isApp=1 Then %>
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '웨딩 기획전', [BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/wedding/pop_wd_event.asp');
<% Else %>
	winwedding2 = window.open('/wedding/pop_wd_event.asp','winwedding2','scrollbars=yes');
	winwedding2.focus();
<% End If %>	
}

function jsEventlinkURL(eventid){
<% If isApp=1 Then %>
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '웨딩세트', [BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid='+eventid);
<% Else %>
	location.href='/event/eventmain.asp?eventid='+eventid;
<% End If %>	
}
//-->
</script>
</head>
<body class="default-font body-popup">
	<header class="tenten-header header-popup">
		<div class="title-wrap">
			<h1>웨딩 기획전</h1>
			<button type="button" class="btn-close" onclick="self.close();">닫기</button>
		</div>
	</header>
	<!-- contents -->
	<div id="content" class="content">
		<!-- exhibition/event list -->
		<section id="exhibitionList" class="exhibition-list">
			<h2 class="hidden">웨딩 기획전</h2>
			<div class="list-card type-align-left">
				<% If IsArray(arrList) Then %>
				<ul>
					<% For intI = 0 To ubound(arrlist,2) %>
					<% If (CInt(intI+1) Mod 3) = "0" Then %>
					<li class="exhibition-plus-item">
					<% Else %>
					<li>
					<% End If %>
						<a href="" onclick="jsEventlinkURL(<%=arrList(0,intI)%>);return false;">
							<div class="thumbnail"><img src="<%=arrList(5,intI)%>" alt="<%=arrList(1,intI)%>" /></div>
							<p class="desc">
								<b class="headline"><span class="ellipsis" style="width:80%;"><%=arrList(1,intI)%></span><% If arrList(3,intI)<>"" Then %><b class="discount color-red"> <%=arrList(3,intI)%></b><% End If %></b>
								<span class="subcopy"><% If arrList(4,intI)<>"" Then %><span class="label label-color"><em class="color-green">쿠폰<%=arrList(4,intI)%></em></span><% End If %><%=arrList(2,intI)%></span>
							</p>
						</a>
					<% If (CInt(intI+1) Mod 3) = "0" Then %>
					<%
						Set cEventItem = New ClsEvtItem
						cEventItem.FECode 	= arrList(0,intI)
						cEventItem.FEItemCnt	= 3
						cEventItem.FItemsort	= 2
						cEventItem.fnGetEventItem
						iTotCnt = cEventItem.FTotCnt
						If iTotCnt>0 Then
					%>
						<div class="additems">
							<div class="items">
								<ul>
									<% For icnt =0 To iTotCnt %>
									<li>
										<a href="/category/category_itemPrd.asp?itemid=1682275&pEtr=85159" onclick="TnGotoProduct('1682275');return false;">
											<div class="thumbnail"><img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(icnt).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(icnt).Ftentenimage400)),cEventItem.FCategoryPrdList(icnt).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(icnt).FImageBasic,200,200,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(icnt).FItemName %>"></div>
											<div class="desc">
												<div class="price">
													<%
														If cEventItem.FCategoryPrdList(icnt).IsSaleItem AND cEventItem.FCategoryPrdList(icnt).isCouponItem Then	'### 쿠폰 O 세일 O
															Response.Write "<b class=""discount color-red"">" & cEventItem.FCategoryPrdList(icnt).getSalePro & "</b>"
															Response.Write "<b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(icnt).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
															If cEventItem.FCategoryPrdList(icnt).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
																If InStr(cEventItem.FCategoryPrdList(icnt).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
																	Response.Write "<b class=""discount color-green""><small>쿠폰</small></b>"
																Else
																	Response.Write "<b class=""discount color-green"">" & cEventItem.FCategoryPrdList(icnt).GetCouponDiscountStr & "<small>쿠폰</small></b>"
																End If
															End If
														ElseIf cEventItem.FCategoryPrdList(icnt).IsSaleItem AND (Not cEventItem.FCategoryPrdList(icnt).isCouponItem) Then	'### 쿠폰 X 세일 O
															Response.Write "<b class=""discount color-red"">" & cEventItem.FCategoryPrdList(icnt).getSalePro & "</b>"
															Response.Write "<b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(icnt).getRealPrice,0) & "<span class=""won"">원</span></b>"
														ElseIf cEventItem.FCategoryPrdList(icnt).isCouponItem AND (NOT cEventItem.FCategoryPrdList(icnt).IsSaleItem) Then	'### 쿠폰 O 세일 X
															Response.Write "<b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(icnt).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
															If cEventItem.FCategoryPrdList(icnt).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
																If InStr(cEventItem.FCategoryPrdList(icnt).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
																	Response.Write "<b class=""discount color-green""><small>쿠폰</small></b>"
																Else
																	Response.Write "<b class=""discount color-green"">" & cEventItem.FCategoryPrdList(icnt).GetCouponDiscountStr & "<small>쿠폰</small></b>"
																End If
															End If
														Else
															Response.Write "<b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(icnt).getRealPrice,0) & "<span class=""won"">" & CHKIIF(cEventItem.FCategoryPrdList(icnt).IsMileShopitem," Point","원") & "</span></b>" &  vbCrLf
														End If
													%>
												</div>
											</div>
										</a>
									</li>
									<% Next %>
								</ul>
							</div>
						</div>
					<%
						End If
					Set cEventItem = Nothing
					%>
					<% End If %>
					</li>
					<% Next %>
				</ul>
				<%
				End If
				on Error Goto 0
				%>
			</div>
		</section>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->