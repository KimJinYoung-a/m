<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
'#######################################################
' Discription : fashion_week_event // cache DB경유
' History : 2018-04-16 이종화 생성
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

Dim arrevtcode , etype

	etype =  requestCheckVar(request("etype"),1)
	If etype = "" Then etype = 1

	If etype = 1 Then 
		arrevtcode = "86037,85825,85826,85827,85925,85708"
	Else
		arrevtcode = "86016,86017,86015,85999,85804,85894"
	End If 

sqlStr = "SELECT e.evt_code, e.evt_name , e.evt_subcopyK , d.evt_mo_listbanner , d.issale , d.iscoupon"
sqlStr = sqlStr  & " FROM db_event.dbo.tbl_event as e "
sqlStr = sqlStr  & "		inner join [db_event].[dbo].[tbl_event_display] as d "
sqlStr = sqlStr  & "		on e.evt_code = d.evt_code "
sqlStr = sqlStr  & "		WHERE e.evt_using='Y' "
sqlStr = sqlStr  & "		AND LEFT(GETDATE(),10) BETWEEN LEFT(e.evt_StartDate,10) AND LEFT(e.evt_EndDate,10)"
sqlStr = sqlStr  & "		AND e.evt_code in ("& arrevtcode &") "

set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close


on Error Resume Next
%>
<script type="text/javascript">
<!--
function fnWeddingEventView(){
<% If isApp=1 Then %>
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '패션위크', [BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/lib/pop_eventcode_list.asp');
<% Else %>
	eventlist = window.open('/event/lib/pop_eventcode_list.asp','eventlist','scrollbars=yes');
	eventlist.focus();
<% End If %>	
}

function jsEventlinkURL(eventid){
<% If isApp=1 Then %>
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '패션위크', [BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid='+eventid);
<% Else %>
	location.href='/event/eventmain.asp?eventid='+eventid;
<% End If %>	
}
//-->
</script>
</head>
<body class="default-font body-popup">
	<div id="content" class="content">
		<section id="exhibitionList" class="exhibition-list">
			<h2 class="hidden">패션위크</h2>
			<div class="list-card type-align-left">
				<% 
					If IsArray(arrList) Then
				%>
				<ul>
					<% 
						Dim eName , eNameredsale
						For intI = 0 To ubound(arrlist,2) 

						'//이벤트 명 할인이나 쿠폰시
						If arrList(4,intI) Or arrList(5,intI) Then
							if ubound(Split(arrList(1,intI),"|"))> 0 Then
								If arrList(4,intI) Or (arrList(4,intI) And arrList(5,intI)) then
									eName	= cStr(Split(arrList(1,intI),"|")(0))
									eNameredsale	= cStr(Split(arrList(1,intI),"|")(1))
								ElseIf arrList(5,intI) Then
									eName	= cStr(Split(arrList(1,intI),"|")(0))
									eNameredsale	= cStr(Split(arrList(1,intI),"|")(1))
								End If
							Else
								eName = arrList(1,intI)
								eNameredsale	= ""

							end If
						Else
							eName = arrList(1,intI)
							eNameredsale	= ""
						End If
					%>
					<% If (CInt(intI+1) Mod 3) = "0" Then %>
					<li class="exhibition-plus-item">
					<% Else %>
					<li>
					<% End If %>
						<a href="" onclick="jsEventlinkURL(<%=arrList(0,intI)%>);return false;">
							<div class="thumbnail"><img src="<%=arrList(3,intI)%>" alt="<%=arrList(1,intI)%>" /></div>
							<p class="desc">
								<b class="headline"><span class="ellipsis" style="width:80%;"><%=eName%></span><% If eNameredsale <> "" Then %><b class="discount color-red"> <%=eNameredsale%></b><% End If %></b>
								<span class="subcopy"><%=arrList(2,intI)%></span>
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
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->