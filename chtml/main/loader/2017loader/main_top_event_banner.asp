<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/main/main_just1day.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
response.charset = "utf-8"
'#######################################################
' Discription : 모바일 메인상단 기획전배너
' History : 2018-11-29 최종원
'#######################################################
dim intI
Dim sqlStr , rsMem , arrList, arrItem, arrItemCount
dim currentDate, testdate
Dim gaParam

dim idx
dim contenttype	
dim evt_code
dim itemid1 
dim evttitle
dim evttitle2
dim evtimg
dim evtalt	
dim startdate 
dim enddate	
dim evtstdate 
dim evteddate 
dim sale_per 
dim coupon_per 
dim addtype 		
dim contentsInfo
dim etcOption


gaParam = "today_topevent_"
dim strSql, isUsing		
	strSql = " SELECT top 1 isUsing "
	strSql = strSql & "	FROM db_sitemaster.DBO.tbl_pcmain_top_exhibition_ctrl WHERE flatform = 'MOBILE' order by idx asc "	
	
	rsget.CursorLocation = adUseClient
	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly
	
	if Not rsget.Eof Then
		isUsing = rsget("isUsing")
	End If
	rsget.close		

testdate = request("testdate")

'스태프 미리보기 기능
if testdate <> "" Then
	if GetLoginUserLevel = "7" then
		currentDate = cdate(testdate) 	
	end if
end if

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "TOPEVENTBANNER_"&Cint(timer/60)
Else
	cTime = 60*5
'	cTime = 1*1
	dummyName = "TOPEVENTBANNER"
End If

sqlStr = "db_sitemaster.dbo.usp_Ten_mobile_main_top_exhibition '"& currentDate &"'"

set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrItem = rsMem.GetRows
	arrItemCount = rsMem.RecordCount
END IF
rsMem.close

on Error Resume Next
%>
<% if isusing = 1 then %>
	<% If IsArray(arrItem) Then %>
		<% If arrItemCount >= 3 Then %>
			<section class="time-sale">
				<div class="weekend">
					<ul class="items">
						<%
						dim displayInfoClass
						displayInfoClass = "color-red"

						For intI = 0 To UBound(arrItem, 2)
							idx			= arrItem(0,intI)
							contenttype	= arrItem(1,intI)			
							evt_code	= arrItem(2,intI)		
							itemid1		= arrItem(3,intI)	 
							evttitle	= arrItem(4,intI)		
							evttitle2	= arrItem(5,intI)		
							evtimg		= arrItem(6,intI)	
							evtalt		= arrItem(7,intI)		
							startdate	= arrItem(8,intI)		 
							enddate		= arrItem(9,intI)		
							evtstdate	= arrItem(10,intI)		 
							evteddate	= arrItem(11,intI)		 
							sale_per	= arrItem(12,intI)		 
							coupon_per	= arrItem(13,intI)		 
							addtype		= arrItem(14,intI)	 		
							contentsInfo= arrItem(15,intI)	 		
							etcOption	= arrItem(16,intI)	 		

						if contenttype = 2 then
							if sale_per <> "" and coupon_per <> "" then
								contentsInfo = sale_per
								displayInfoClass = "color-red"
							elseif coupon_per <> "" then
								contentsInfo = coupon_per
								displayInfoClass = "color-green"
							else 	
								contentsInfo = sale_per
								displayInfoClass = "color-red"							
							end if							
						else	
							Select Case etcOption
								Case "1"
									displayInfoClass = "color-red"	
								Case "2"
									displayInfoClass = "color-green"	
								case "3", "4", "5", "6", "7"
									displayInfoClass = "color-blue"			
								case else							
									displayInfoClass = "color-red"			
							End Select
						end if							
						%>					
						<li>
						<% if isapp = 1 then %>
							<% if contenttype = 1 then %>
								<a href="javascript:void(0)" onclick="fnAmplitudeEventMultiPropertiesAction('click_top_event_banner','number|content_type|code','<%=intI+1%>|event|<%=evt_code%>', function(bool){if(bool) {fnAPPpopupAutoUrl('/event/eventmain.asp?eventid=<%=evt_code%>&gaparam=<%=gaparam & intI + 1%>');}});return false;">							
							<% else %>
								<a href="javascript:void(0)" onclick="fnAmplitudeEventMultiPropertiesAction('click_top_event_banner','number|content_type|code','<%=intI+1%>|product|<%=itemid1%>', function(bool){if(bool) {fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=<%=itemid1%>&gaparam=<%=gaparam & intI + 1%>');}});return false;">
							<% end if %>
						<% else %>
							<% if contenttype = 1 then %>
								<a href="/event/eventmain.asp?eventid=<%=evt_code%>&gaparam=<%=gaparam & intI + 1%>"  onclick="fnAmplitudeEventMultiPropertiesAction('click_top_event_banner','number|content_type|code','<%=intI+1%>|event|<%=evt_code%>');">
							<% else %>
								<a href="/category/category_itemprd.asp?itemid=<%=itemid1%>&gaparam=<%=gaparam & intI + 1%>"  onclick="fnAmplitudeEventMultiPropertiesAction('click_top_event_banner','number|content_type|code','<%=intI+1%>|product|<%=itemid1%>');">
							<% end if %>
						<% end if %>							
								<div class="thumbnail"><img src="<%=evtimg%>" alt="<%=evtalt%>" /></div>
								<div class="desc">
									<p class="tit"><%=evttitle%></p>
									<p class="tit"><%=evttitle2%></p>
									<b class="discount <%=displayInfoClass%>"><%=contentsInfo%></b>
								</div>
							</a>
						</li>						
						<% 					
							If intI >= 2 Then
								Exit For
							End If
						%>							
						<% Next %>							
					</ul>
				</div>	
			</section>
		<% End If %>
	<% End If %>	
<% end if %>				
<%
	on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->