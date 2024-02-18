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
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'#######################################################
' Discription : wedding_plan_event // cache DB경유
' History : 2018-04-11 정태훈 생성
'#######################################################
Dim poscode , icnt ,jcnt, totalsaleper, totalprice
Dim sqlStr , rsMem, arrList, intI

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

If IsArray(arrList) Then
%>
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
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '웨딩 기획전', [BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid='+eventid);
<% Else %>
	location.href='/event/eventmain.asp?eventid='+eventid;
<% End If %>	
}
//-->
</script>
		<div class="wed-evt">
			<ul>
				<% For intI = 0 To 1 %>
				<li>

					<a href="" onclick="jsEventlinkURL(<%=arrList(0,intI)%>);return false;">
						<div class="tumb"><img src="<%=arrList(5,intI)%>" alt="<%=arrList(1,intI)%>" /></div>
						<p class="evt-tit"><em><%=arrList(1,intI)%></em><% If arrList(3,intI)<>"" Then %><em class="sale"> <%=arrList(3,intI)%></em><% End If %></p>
						<p><% If arrList(4,intI)<>"" Then %><span class="label label-color"><em class="color-green">쿠폰<%=arrList(4,intI)%></em></span><% End If %><%=arrList(2,intI)%></p>
					</a>
				</li>
				<% Next %>
			</ul>
			<div class="more"><a href="javascript:fnWeddingEventView();">웨딩 기획전 전체 보기</a></div>
		</div>
<%
End If
on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->