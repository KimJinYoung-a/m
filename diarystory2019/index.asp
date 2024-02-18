<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리스토리 2019 메인페이지
' History : 2018-08-30 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2019/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2019/lib/classes/diary_class_B.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
dim GiftSu, i, weekDate, imglink, gnbflag

gnbflag = RequestCheckVar(request("gnbflag"),1)

If gnbflag <> "" Then '//gnb 숨김 여부
	gnbflag = true 
Else 
	gnbflag = False
	strHeadTitleName = "2019 다이어리"
End if

weekDate = weekDayName(weekDay(now)) '// 요일 구하기 내장 함수
if date = "2018-12-25" then
	weekDate = "공휴일"
end if

'weekDate="공휴일"
GiftSu=0

dim cDiary	'평일
dim cDiaryE'주말

 '1+1
Set cDiary = new cdiary_list
	cDiary.getOneplusOneDaily

'일반배너
Set cDiaryE = new cdiary_list
If weekDate = "토요일" Or weekDate = "일요일" Or weekDate = "공휴일" Then
	cDiaryE.Ftopcount = 6
else
	cDiaryE.Ftopcount = 5
end if
cDiaryE.getOneDailynot
	
if cDiary.ftotalcount>0 then
	GiftSu = cDiary.getGiftDiaryExists(cDiary.FOneItem.Fitemid) '사은품 수
		if GiftSu = false then GiftSu=0
else
	GiftSu=0
end if

' dim cDiarycnt
' Set cDiarycnt = new cdiary_list
' 	cDiarycnt.getDiaryCateCnt '상태바 count
	
IF application("Svr_Info") = "Dev" THEN
	imglink = "testimgstatic"
Else
	imglink = "imgstatic"
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/diary2019.css?v=1.07" />
<script type="text/javascript">
$(document).ready(function(){
	fnAmplitudeEventMultiPropertiesAction('view_diary_main','','');		
});
</script>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%> diary2019">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<div id="content" class="content diary-main">
		<h2><a href="/diarystory2019/?gnbflag=1"><img src="http://fiximage.10x10.co.kr/web2018/diary2019/m/tit_diary_story.png" alt="Diary Story" /></a></h2>
		<a href="/diarystory2019/daccu.asp" class="btn-go-daccu"><img src="http://fiximage.10x10.co.kr/web2018/diary2019/m/img_daccu.gif" alt="다꾸채널" /></a>
		<a href="/diarystory2019/daccu_ranking.asp" class="btn-go-daccu-ranking"><img src="http://fiximage.10x10.co.kr/web2018/diary2019/m/img_daccu_ranking.png" alt="다꾸랭킹" /></a>
		<%'메인 롤링%>
		<!-- #include virtual="/diarystory2019/sub/rolling.asp" -->
		<%'사은품 %>
		<!-- #include virtual="/diarystory2019/sub/gift.asp" -->
		<%'추천다이어리 (best , event , 검색) %>
		<!-- #include virtual="/diarystory2019/sub/items.asp" -->
		<%'다이어리 이벤트 (공통) %>
		<!-- #include virtual="/diarystory2019/sub/etc_event.asp" -->
		<!-- 17주년 메인으로 이동 (10/10~10/31 노출)-->
		<% If Now() > #10/10/2018 00:00:00# AND Now() < #10/31/2018 23:59:59# Then  %>		
			<% if isApp = 1 then %>		
			<a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/17th/');"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_bnr_main.jpg" alt="텐텐 슬기로운 생활 17주년 메인으로 이동" /></a>				
			<% else %>
			<a href="/event/17th/index.asp"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_bnr_main.jpg" alt="텐텐 슬기로운 생활 17주년 메인으로 이동" /></a>				
			<% end if %>				
		<% end if %>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incfooter.asp" -->	
</body>
</html>
<%
Set cDiary = Nothing
Set cDiaryE = Nothing
' Set cDiarycnt = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->