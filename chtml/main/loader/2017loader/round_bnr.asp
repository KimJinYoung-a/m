<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/main/main_just1day.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'#######################################################
' Discription : 모바일 메인 라운드 배너
' History : 2018-12-31 최종원
'#######################################################
%>
<%
dim intI
Dim sqlStr , rsMem , arrList, arrItem, arrItemCount
dim currentDate, testdate
Dim gaParam

dim contenttype	
dim evt_code
dim itemid1 
dim evttitle
dim evtimg
dim evtalt

dim addtype

gaParam = "today_round_"

dim strSql

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
	dummyName = "TOPROUNDBANNER_"&Cint(timer/60)
Else
	cTime = 60*5
	'cTime = 1*1
	dummyName = "TOPROUNDBANNER"
End If

sqlStr = "db_sitemaster.dbo.usp_Ten_mobile_main_roundbanner '"& currentDate &"'"

set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrItem = rsMem.GetRows
	arrItemCount = rsMem.RecordCount
END IF
rsMem.close

on Error Resume Next
%>

<% If IsArray(arrItem) Then %>
	<% If arrItemCount >= 6 Then %>
		<section class="hotkey-list">
			<ul>
			<% 
			for intI = 0 to UBound(arrItem, 2)
				idx			= arrItem(0,intI)
				contenttype	= arrItem(1,intI)
				evt_code	= arrItem(2,intI)
				itemid1		= arrItem(3,intI)
				evttitle	= arrItem(4,intI)
				evtimg		= arrItem(5,intI)
				evtalt		= arrItem(6,intI)
			%>
				<li>
					<% if isapp = 1 then %>
						<% if contentType = 1 then %>
							<a href="javascript:void(0)" onclick="fnAmplitudeEventMultiPropertiesAction('click_round_banner','number|content_type|code','<%=intI+1%>|event|<%=evt_code%>', function(bool){if(bool) {fnAPPpopupAutoUrl('/event/eventmain.asp?eventid=<%=evt_code%>&gaparam=<%=gaParam & intI+1%>');}});return false;">						
						<% else %>
							<a href="javascript:void(0)" onclick="fnAmplitudeEventMultiPropertiesAction('click_round_banner','number|content_type|code','<%=intI+1%>|product|<%=itemid1%>', function(bool){if(bool) {fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=<%=itemid1%>&gaparam=<%=gaParam & intI+1%>');}});return false;">																
						<% end if %>						
					<% else %>		
						<% if contentType = 1 then %>
							<a href="/event/eventmain.asp?eventid=<%=evt_code%>&gaparam=<%=gaParam & intI+1%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_round_banner','number|content_type|code','<%=intI+1%>|event|<%=evt_code%>');">
						<% else %>
							<a href="/category/category_itemPrd.asp?itemid=<%=itemid1%>&gaparam=<%=gaParam & intI+1%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_round_banner','number|content_type|code','<%=intI+1%>|product|<%=itemid1%>');">
						<% end if %>																
					<% end if %>											
						<div class="thumb-area"><div class="thumbnail"><img src="<%=evtimg%>" alt="" /></div></div>
						<div class="desc"><%=evttitle%></div>
					</a>
				</li>
			<% next %>	
			</ul>
		</section>
	<% End If %>	
<% end if %>	