<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
response.charset = "utf-8"
'#######################################################
' Discription : Mobile Todayenjoy // cache DB경유
' History : 2014-12-05 이종화 생성
'#######################################################
Dim lprevDate , sqlStr , arrTenjoy , i
Dim evtimg , evtalt , linkurl , linktype , evttitle , issalecoupon , evtstdate , evteddate , startdate , enddate , issalecoupontxt , evt_todaybanner , moListBanner
Dim CtrlTime : CtrlTime = hour(time)

	sqlStr = "select top 3 t.* , d.evt_todaybanner , d.evt_mo_listbanner "
	sqlStr = sqlStr + " from db_sitemaster.dbo.tbl_mobile_main_enjoyevent_new as t "
	sqlStr = sqlStr + " left outer join db_event.dbo.tbl_event_display as d "
	sqlStr = sqlStr + " on t.evt_code = d.evt_code"
	sqlStr = sqlStr & " where t.isusing = 'Y' "
	sqlStr = sqlStr & "		and t.enddate >= getdate() "
	sqlStr = sqlStr & "		and ('"& Date() &"' between convert(varchar(10),t.startdate,120) and convert(varchar(10),t.enddate,120))"
	sqlStr = sqlStr & " order by t.sortnum asc , t.startdate asc "

	'response.write sqlStr

	dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"EVT",sqlStr,60*60)
	If Not rsMem.EOF Then
		arrTenjoy 	= rsMem.GetRows
	End if
	rsMem.close
	If isArray(arrTenjoy) and not(isnull(arrTenjoy)) Then

%>
<section class="inner5 enjoyEvent">
	<h2 class="tit01"><span>ENJOY EVENT</span></h2>
	<span class="moreBtn"><a href="" onclick="callevent();return false;">이벤트 리스트로 이동</a></span>
	<ul class="todayEvtList">
<%

	FOR i=0 to ubound(arrTenjoy,2)
		evtimg				= arrTenjoy(4,i)
		evtalt				= arrTenjoy(5,i)
		linkurl				= arrTenjoy(2,i)
		linktype			= arrTenjoy(1,i)
		evttitle			= arrTenjoy(3,i)
		issalecoupon		= arrTenjoy(15,i)
		evtstdate			= arrTenjoy(18,i)
		evteddate			= arrTenjoy(19,i)
		startdate			= arrTenjoy(6,i)
		enddate				= arrTenjoy(7,i)
		issalecoupontxt		= arrTenjoy(16,i)
		evt_todaybanner		= arrTenjoy(21,i)
		moListBanner		= arrTenjoy(22,i)
%>
		<li onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014<%=linkurl%>');">
			<img src="<%=chkiif(linktype="1",moListBanner,evtimg)%>" alt="<%=evttitle%>" />
			<p class="evtTit"><%=evttitle%> <span class="<%=chkiif(issalecoupon="1","cRd1","cGr1")%>"><%=issalecoupontxt%></span></p>
		</li>
<%
	Next
%>
	</ul>
</section>
<%
	End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->