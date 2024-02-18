<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
Session.Codepage = 65001
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'#######################################################
' Discription : mobile_main_banner // cache DB경유
' History : 2016-04-27 이종화 생성
'#######################################################
Dim poscode , intI ,intJ
Dim sqlStr , rsMem , arrList
Dim gaParam : gaParam = "&gaparam=living_mainroll_0" '//GA 체크 변수
Dim CtrlDate : CtrlDate = now()
Dim limitcnt : limitcnt = 0 '//최대 배너 갯수

poscode = 2075

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "GNBEvent_"&Cint(timer/60)
Else
	cTime = 60*5
	'cTime = 1*1
	dummyName = "GNBEvent"
End If

IF poscode = "" THEN
	Call Alert_Return("잘못된 접근입니다.")
	response.End
END IF

Dim topcnt : topcnt = 8

If isapp = "1" Then
	limitcnt = 8 '배열이라 -1개 총 4개 (app 전용 배너)
Else
	limitcnt = 8 '배열이라 -1개 총 4개 (M 전용 배너)
End If

sqlStr = "EXEC [db_sitemaster].[dbo].[usp_WWW_MobileGNB_TopEvent_Get]"
set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

on Error Resume Next
intJ = 0
If IsArray(arrList) Then

	Dim Evt_Code, Evt_Title, Evt_Subcopy, Evt_Img, salePer, saleCPer
	Dim opttag, link, alink
%>
		<div class="ctgy-main-bnr">
			<div class="swiper-container">
				<div class="swiper-wrapper">
<%
	For intI = 0 To ubound(arrlist,2)
		opttag = ""
		If intJ > limitcnt Then Exit For '//매뉴별 최대 갯수

		Evt_Code		= arrlist(0,intI)
        Evt_Title			= db2Html( arrlist(1,intI))
        Evt_Subcopy	= db2Html(arrlist(2,intI))
        Evt_Img			= db2Html(arrlist(3,intI))
        salePer			= db2Html(arrlist(4,intI))
        saleCPer		= db2Html(arrlist(5,intI))
        link = "/event/eventmain.asp?eventid=" + Cstr(Evt_Code)
		If isapp = "1" Then
			If InStr(link,"/clearancesale/") > 0 Then
				alink = "fnAmplitudeEventAction('click_gnb_living_mainrolling','rollingnumber','"&intJ+1&"', function(bool){if(bool) {fnAPPpopupClearance_URL('"& link & gaparamchk(link,gaParam) & (intJ+1) &"');}});return false;"
			Else
				alink = "fnAmplitudeEventAction('click_gnb_living_mainrolling','rollingnumber','"&intJ+1&"', function(bool){if(bool) {fnAPPpopupAutoUrl('"& link & gaparamchk(link,gaParam) & (intJ+1) &"');}});return false;"
			End If
		Else
			alink = link & gaparamchk(link,gaParam) & (intJ+1)
		End If
%>

					<div class="swiper-slide">
						<% If isapp = "1" Then %>
						<a onClick="<%=alink%>">
						<% Else %>
						<a href="<%=alink%>" onClick="<%=alink%>">
						<% End If %>
							<div class="thumbnail"><img src="<%=Evt_Img%>" alt="<%=Evt_Title%>"></div>
							<div class="desc">
								<b class="headline"><span class="ellipsis"><%=Evt_Title%></span><% If salePer>0 Then %> <b class="discount color-red">~<%=salePer%>%</b><% End If %></b>
								<p class="subcopy"><span class="ellipsis"><%=Evt_Subcopy%></span></p>
							</div>
						</a>
					</div>
<%
		intJ = intJ + 1
	Next
%>
				</div>
			</div>
		</div>
<script>
//스와이퍼
$(function(){
	/* main banner */
	var fMainSwiper = new Swiper(".ctgy-main-bnr .swiper-container", {
		loop:true,
		slidesPerView:'auto',
		centeredSlides:true,
		speed:600
	});
});
</script>
<%
End If
on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->