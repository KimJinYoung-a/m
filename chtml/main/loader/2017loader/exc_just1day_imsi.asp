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
' Discription : mobile_just1day_json 테스트용
' History : 2018-05-14 원승현
'#######################################################

Dim poscode , intI ,intJ
Dim sqlStr , rsMem , arrList, arrItem
Dim gaParam
Dim CtrlDate : CtrlDate = now()
Dim playingGubun, targetNum, intT
Dim amplitudeJust1Day

Dim just1daymaxsaleper
Dim itemid, pclinkurl, mobilelinkurl, pcimageurl, mobileimageurl, title, price, saleper

Dim just1daylistidx, just1daysubidx

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "PBJUST1DAYTESTMAIN_"&Cint(timer/60)
Else
	cTime = 60*5
'	cTime = 1*1
	dummyName = "PBJUST1DAYTESTMAIN"
End If

sqlStr = "db_temp.dbo.usp_Ten_Just1DayList_Test"

set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

If IsArray(arrList) Then
	just1daylistidx = arrList(0,0)	
	just1daymaxsaleper = arrList(9,0)
End If

If IsArray(arrList) Then
	sqlStr = "db_temp.dbo.[usp_Ten_Just1DayItem_Test] ('"&just1daylistidx&"') "
	'Response.write sqlStr
	'response.End
	set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
	IF Not (rsMem.EOF OR rsMem.BOF) THEN
		arrItem = rsMem.GetRows
	END IF
	rsMem.close
End If

on Error Resume Next

intJ = 0

Dim vTimerDate
vTimerDate = DateAdd("d",1,Date())

'// 타이머용
%>
<script>
var j1yr = "<%=Year(vTimerDate)%>";
var j1mo = "<%=TwoNumber(Month(vTimerDate))%>";
var j1da = "<%=TwoNumber(Day(vTimerDate))%>";
var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
var j1today=new Date(<%=Year(now)%>, <%=Month(now)-1%>, <%=Day(now)%>, <%=Hour(now)%>, <%=Minute(now)%>, <%=Second(now)%>);

var j1minus_second = 0;		// 변경될 증가시간(초)
var j1nowDt=new Date();		// 시작시 브라우저 시간

function countdown(){
	var cntDt = new Date(Date.parse(j1today) + (1000*j1minus_second));	//서버시간에 변화값(1초) 증가
	var todayy=cntDt.getYear()

	if(todayy < 1000) todayy+=1900;

	var todaym=cntDt.getMonth();
	var todayd=cntDt.getDate();
	var todayh=cntDt.getHours();
	var todaymin=cntDt.getMinutes();
	var todaysec=cntDt.getSeconds();
	var todaystring=montharray[todaym]+" "+todayd+", "+todayy+" "+todayh+":"+todaymin+":"+todaysec;
	var futurestring=montharray[j1mo-1]+" "+j1da+", "+j1yr+" 00:00:00";

	dd=Date.parse(futurestring)-Date.parse(todaystring);
	dday=Math.floor(dd/(60*60*1000*24)*1);
	dhour=Math.floor((dd%(60*60*1000*24))/(60*60*1000)*1);
	dmin=Math.floor(((dd%(60*60*1000*24))%(60*60*1000))/(60*1000)*1);
	dsec=Math.floor((((dd%(60*60*1000*24))%(60*60*1000))%(60*1000))/1000*1);

	if(dday < 0) {
		$("#countdown").html("00:00:00 남음");
		return;
	}

	if(dhour < 10) dhour = "0" + dhour;
	if(dmin < 10) dmin = "0" + dmin;
	if(dsec < 10) dsec = "0" + dsec;
	dhour = dhour+'';
	dmin = dmin+'';
	dsec = dsec+'';

	// Print Time
	$("#countdown").html(dhour.substr(0,1)+dhour.substr(1,1)+":"+dmin.substr(0,1)+dmin.substr(1,1)+":"+dsec.substr(0,1)+dsec.substr(1,1)+" <s>남음</s>");

	var usrDt=new Date();	// 현재 브라우저 시간
	var vTerm = parseInt(usrDt.getTime()/1000)-parseInt(j1nowDt.getTime()/1000);	// 시작시 시간과의 차이(초)
	j1minus_second = vTerm;	// 증가시간에 차이 반영

	setTimeout("countdown()",500)
}

$(function(){
	countdown();
});
</script>

<% If IsArray(arrItem) Then %>
	<section class="multi-time-sale time-sale">
		<div class="multi-head">
			<h2 class="headline ftLt">JUST 1 DAY</h2>
			<span class="time ftLt" id="countdown">00:00:00 &nbsp;<s>남음</s></span>
		</div>
		<% 
		For intI = 0 To UBound(arrItem, 2)
			itemid = arrItem(3,intI)
			gaparam = "today_just1day_1_"&intI+1
			pclinkurl = arrItem(4,intI)
			mobilelinkurl = arrItem(5,intI)
			pcimageurl = arrItem(6,intI)
			mobileimageurl = arrItem(7,intI)
			title = arrItem(2,intI)
			price = arrItem(8,intI)
			saleper = arrItem(9,intI)
		%>
			<div class="weekday" <% If intI = 0 Then %>style="margin-top:0;"<% End If %>>
				<div class="items">
					<div class="thumbnail"><img src="<%=mobileimageurl%>" alt="" /></div>
					<div class="desc">
						<b class='discount <% If Trim(saleper)="" Then %>special-discount <% End If %>color-red'>
							<%
								If Trim(saleper)="" Then
									Response.write "하루특가"
								Else
									Response.write saleper
								End If
							%>
						</b>
						<p class="name"><%=title%></p>
						<div class="price"><b class="sum"><%=price%></b></div>
					</div>
					<% If isapp = "1" Then %>
						<a href="" onclick="fnAmplitudeEventAction('click_just1day','number','<%=intI+1%>', function(bool){if(bool) {fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014<%=mobilelinkurl%>?itemid=<%=itemid%>&gaparam=<%=gaparam%>');}});return false;"></a>
					<% Else %>
						<a href="<%=mobilelinkurl%>?itemid=<%=itemid%>&gaparam=<%=gaparam%>" onclick=fnAmplitudeEventMultiPropertiesAction('click_just1day','type|number','weekday|<%=intI+1%>');></a>
					<% End If %>
				</div>
			</div>
		<% Next %>
	</section>
<% End If %>
<%
	on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->