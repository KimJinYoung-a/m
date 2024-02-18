<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'#######################################################
'	Description : Just 1 Day 상품 배너 출력
'	History	:  2015.07.01 허진원
'              2017.04.10 브라우저시간으로 변화량 측정; 허진원
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/Just1DayCls.asp" -->
<%
	dim oJustItem, itemid
	itemid = getNumeric(requestCheckVar(request("itemid"),9))

	if itemid="" then dbget.close(): Response.End

	'// 오늘의 상품 접수
	set oJustItem = New CJustOneDay
	oJustItem.FRectDate = Date
	oJustItem.FRectItemId = itemid	
	oJustItem.GetJustOneDayItemInfo

	'// 진행 상품이 맞는지 확인
	if cStr(itemid)<>cStr(oJustItem.FItemList(0).Fitemid) then
		set oJustItem = Nothing
		dbget.close(): Response.End
	end if

	If DateDiff("n",oJustItem.FItemList(0).FJustDate & " 23:59:59",now()) > 0 Then
		set oJustItem = Nothing
		dbget.close(): Response.End
	ElseIf (oJustItem.FItemList(0).FlimitYn="Y" and (oJustItem.FItemList(0).FlimitNo-oJustItem.FItemList(0).FlimitSold)<=0) or ((oJustItem.FItemList(0).FSellYn<>"Y")) Then
		set oJustItem = Nothing
		dbget.close(): Response.End
	End If

	'// 상품 할인이 없으면 종료
'	if oJustItem.FItemList(0).FsalePrice>=oJustItem.FItemList(0).ForgPrice then
'		set oJustItem = Nothing
'		dbget.close(): Response.End
'	end if

	Dim vTimerDate
	vTimerDate = DateAdd("d",1,oJustItem.FItemList(0).FJustDate)
%>
<script type="text/javascript">
var yr = "<%=Year(vTimerDate)%>";
var mo = "<%=TwoNumber(Month(vTimerDate))%>";
var da = "<%=TwoNumber(Day(vTimerDate))%>";
var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
var today=new Date(<%=Year(now)%>, <%=Month(now)-1%>, <%=Day(now)%>, <%=Hour(now)%>, <%=Minute(now)%>, <%=Second(now)%>);
var minus_second = 0;		// 변경될 증가시간(초)
var nowDt=new Date();		// 시작시 브라우저 시간

function countdown(){
	var cntDt = new Date(Date.parse(today) + (1000*minus_second));	//서버시간에 변화값(1초) 증가
	var todayy=cntDt.getYear()

	if(todayy < 1000) todayy+=1900;
		
	var todaym=cntDt.getMonth();
	var todayd=cntDt.getDate();
	var todayh=cntDt.getHours();
	var todaymin=cntDt.getMinutes();
	var todaysec=cntDt.getSeconds();
	var todaystring=montharray[todaym]+" "+todayd+", "+todayy+" "+todayh+":"+todaymin+":"+todaysec;
	var futurestring=montharray[mo-1]+" "+da+", "+yr+" 00:00:00";

	dd=Date.parse(futurestring)-Date.parse(todaystring);
	dday=Math.floor(dd/(60*60*1000*24)*1);
	dhour=Math.floor((dd%(60*60*1000*24))/(60*60*1000)*1);
	dmin=Math.floor(((dd%(60*60*1000*24))%(60*60*1000))/(60*1000)*1);
	dsec=Math.floor((((dd%(60*60*1000*24))%(60*60*1000))%(60*1000))/1000*1);

	if(dday < 0) {
		$("#countdown").html("00 : 00 : 00");
		return;
	}

	if(dhour < 10) dhour = "0" + dhour;
	if(dmin < 10) dmin = "0" + dmin;
	if(dsec < 10) dsec = "0" + dsec;
	dhour = dhour+'';
	dmin = dmin+'';
	dsec = dsec+'';

	// Print Time
	$("#countdown").html(dhour.substr(0,1)+dhour.substr(1,1)+" : "+dmin.substr(0,1)+dmin.substr(1,1)+" : "+dsec.substr(0,1)+dsec.substr(1,1));
	
	var usrDt=new Date();	// 현재 브라우저 시간
	var vTerm = parseInt(usrDt.getTime()/1000)-parseInt(nowDt.getTime()/1000);	// 시작시 시간과의 차이(초)
	minus_second = vTerm;	// 증가시간에 차이 반영

	setTimeout("countdown()",500);
}
</script>
<p>JUST 1 DAY SALE <span id="countdown">00 : 00 : 00</span></p>
<script>
$(function(){
	countdown();
});
</script>
<%
	set oJustItem = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->