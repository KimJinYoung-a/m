<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- #include virtual="/lib/classes/enjoy/shoppingchanceCls_B.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<%
'###########################################################
' Description :  CATE Main (index) + 카테고리 번호
' History : 2015-09-21 이종화 생성 - 모바일
'###########################################################
'// mdpick , event_list DBcache사용
%>
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'//gnbcode
dim gcode	: gcode = requestCheckVar(request("gnbcode"),3)
Dim dbgcode , dbgname '// dbcache
Dim cShopchance
Dim gaParam '//param GA

if gcode="" or gcode="0" Then
	gcode = 100 '//stationery
End If

'데이터 가져오기 '//gnbcode 
set cShopchance = new ClsShoppingChance
	cShopchance.Fgnbcode = gcode
	cShopchance.fnGetgnbname
	dbgcode		= cShopchance.Fgcode	'gnbcode 가져오기
	dbgname		= cShopchance.Fgname	'gnbname 가져오기
set cShopchance = Nothing

If dbgcode = "" And dbgname = "" Then
	gcode = 100 '//stationery
elseif Not(isNumeric(gcode)) then
	Call Alert_Return("잘못된 접근입니다")
	response.End
else
	'정수형태로 변환
	gcode=CLng(getNumeric(gcode))
end If

'// 다음 페이지 카테고리 번호
dim sNextGnbCd, arrNextGbCd, sNextUrl, lp , arrNextGbName , sNextGnbName
arrNextGbCd = split("500,200,100,300,600,400,700",",")
arrNextGbName = split("digital,fashion,living,lifestyle,baby,stationery,PLAYing",",")
for lp=0 to ubound(arrNextGbCd)
	if cStr(gcode)=cStr(arrNextGbCd(lp)) then
		sNextGnbCd= arrNextGbCd(lp+1)
		sNextGnbName = arrNextGbName(lp+1)
	end if
next
if sNextGnbCd<>"" then sNextUrl = chkIIF(cStr(sNextGnbCd)="700",wwwUrl&"/apps/appcom/wish/web2014/playing/?gnbcode=700",wwwUrl&"/apps/appcom/wish/web2014/catemain/index.asp?gnbcode=" & sNextGnbCd)
%>
<link rel="stylesheet" type="text/css" href="/lib/css/newV15a.css" />
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry">
			<!-- content area -->
			<div class="content ctgyIdxV15a" id="contentArea">
				<%' 메인이벤트 %>
				<section class="listShowcaseV15b">
					<h2>메인 이벤트</h2>
					<ul>
					<% 
						On Error Resume Next
						server.Execute "/chtml/main/loader/2015catemain/app_cateXMLBanner_1_"&gcode&".asp"
						On Error Goto 0
					%>
					<% 
						On Error Resume Next
						server.Execute "/chtml/main/loader/2015catemain/app_main_top2event_"&gcode&".asp"
						On Error Goto 0
					%>
					</ul>
				</section>
				<%' 메인이벤트 %>
				<%' 키워드 %>
				<section class="keywordV15a">
					<h2>키워드</h2>
					<% 
						On Error Resume Next
						server.Execute "/chtml/main/loader/2015catemain/app_main_topkeyword_"&gcode&".asp"
						On Error Goto 0
					%>
				</section>
				<%' 키워드 %>
				<%' 텍스트배너 %>
				<section class="txtBnrV15a">
					<%	
						On Error Resume Next
						server.Execute "/chtml/main/loader/2015catemain/app_cateXMLBanner_2_"&gcode&".asp"
						On Error Goto 0
					%>
				</section>
				<%' 텍스트배너 %>
				<%' MD`S PICK %>
				<section class="mdPickV15a">
					<!-- #include virtual="/apps/appcom/wish/web2014/catemain/cate_mdpick.asp" -->
				</section>
				<%' MD`S PICk %>
				<%' 이벤트 %>
				<section class="trendEvtV15a">
					<!-- #include virtual="/apps/appcom/wish/web2014/catemain/cate_event_list.asp" -->
				</section>
				<%' 이벤트 %>
			</div>
			<!-- //content area -->
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
<!-- 	<div class="btnTouch"> -->
<!-- 		<a href="" onclick="fnAPPselectGNBMenu('<%=sNextGnbName%>','<%=sNextUrl%>');return false;">여기를 터치하면<br /> <b>'우측 메뉴'</b>로 이동합니다</a> -->
<!-- 	</div> -->
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->