<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
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
Dim gaParam : gaParam = "&gaparam=today_mainroll_" '//GA 체크 변수
Dim CtrlDate : CtrlDate = now()
Dim limitcnt : limitcnt = 0 '//최대 배너 갯수

poscode = 2063

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime
If CDate(now()) <= CDate(Date() & " 00:05:00") Then
	cTime = 60*1
Else
	cTime = 60*5
End If

IF poscode = "" THEN
	Call Alert_Return("잘못된 접근입니다.")
	response.End
END IF

Dim topcnt : topcnt = 25

If isapp = "1" Then
	limitcnt = 5 '배열이라 -1개 총 6개 (app 전용 배너)
Else
	limitcnt = 4 '배열이라 -1개 총 5개
End If  

sqlStr = "select top "& topcnt &" imageurl , linkurl , startdate ,  enddate , altname from [db_sitemaster].[dbo].tbl_mobile_mainCont"
	If isapp ="1" Then 
		sqlStr = sqlStr & " where poscode in (2063,2064) "
	Else
		sqlStr = sqlStr & " where poscode = (2063) "
	End If 
sqlStr = sqlStr & " and isusing = 'Y' and isnull(imageurl,'') <> '' "
sqlStr = sqlStr & " and enddate >= getdate() "
sqlStr = sqlStr & " order by orderidx asc , idx desc , poscode asc  "

'Response.write sqlStr

set rsMem = getDBCacheSQL(dbget, rsget, "MBIMG", sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

on Error Resume Next
intJ = 0
If IsArray(arrList) Then
%>
<script>
$(function(){
	var swiper1 = new Swiper("#mainRolling .swiper-container", {
		pagination:"#mainRolling .paginationDot",
		paginationClickable:true,
		autoplay:3000,
		loop:true,
		speed:800
		,onImagesReady:function(){
			chkSwiper++;
			rectPosition('#mainRolling');
			setTimeout(function(){swiper1.stopAutoplay();},300);
			setTimeout(function(){swiper1.startAutoplay();},2000);
		}
	});
});
</script>
<div id="mainRolling" class="swiperFull mainRollingV16">
	<div class="swiper-container">
		<div class="swiper-wrapper">
<%
	Dim img, link ,startdate , enddate , altname , alink
	For intI = 0 To ubound(arrlist,2)
		
		If CDate(CtrlDate) >= CDate(arrlist(2,intI)) AND CDate(CtrlDate) <= CDate(arrlist(3,intI)) Then
			If intJ > limitcnt Then Exit For '//매뉴별 최대 갯수

		img				= staticImgUrl & "/mobile/" + db2Html(arrlist(0,intI))
		link			= db2Html(arrlist(1,intI))
		startdate		= arrlist(2,intI)
		enddate			= arrlist(3,intI)
		altname			= db2Html(arrlist(4,intI))

		If isapp = "1" Then
			If InStr(link,"/clearancesale/") > 0 Then
				alink = "fnAPPpopupClearance_URL('"& link & gaparamchk(link,gaParam) & (intJ+1) &"');return false;"
			Else
				alink = "fnAPPpopupAutoUrl('"& link & gaparamchk(link,gaParam) & (intJ+1) &"');return false;"
			End If
		Else 
			alink = link & gaparamchk(link,gaParam) & (intJ+1)
		End If
%>			
			<div class="swiper-slide">
				<% If isapp = "1" Then %>
				<a href="" onclick="<%=alink%>">
				<% Else %>
				<a href="<%=alink%>">
				<% End If %>
				<img src="<%=img%>" alt="<%=altname%>" /></a>
			</div>
<%
			intJ = intJ + 1
		End if
	Next
%>
		</div>
		<div class="paginationDot"></div>
	</div>
</div>
<%
End If 
on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->