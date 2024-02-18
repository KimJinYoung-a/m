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
' Discription : mobile_just1day_2018_new
' History : 2018-12-03 최종원
'#######################################################

Dim poscode , intI ,intJ
Dim sqlStr , rsMem , arrList, arrItem, arrItemCount
Dim gaParam
Dim CtrlDate : CtrlDate = now()
Dim playingGubun, targetNum, intT
Dim amplitudeJust1Day

Dim listidx, listtitle, liststartdate, listenddate, listregdate, listlastupdate, listadminid, listlastadminid, listisusing, listmaxsaleper, listtype, listbannerimage, listlinkurl, listworkertext, listplatform
Dim itemsubidx, itemlistidx, itemtitle, itemitemid, itemfrontimage, itemprice, itemsaleper, itemisusing, itemsortnum, itemmakerid, itemitemdiv, itemgubun
Dim itemsellcash, itemorgprice, itemsailprice, itemsellyn, itemlimityn, itemsailyn, itembasicimage, itemitemcoupontype, itemitemcouponvalue, itemitemcouponyn, itemtenonlyyn, itemdispcate1, itembrandname
Dim itemlimitno, itemlimitsold, itemBasicIMG, itemTenIMG

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 1*1
	dummyName = "PBJUST1DAYNEWMAINMOBILE_"&Cint(timer/60)
Else
	cTime = 1*1
'	cTime = 1*1
	dummyName = "PBJUST1DAYNEWMAINMOBILE"
End If

sqlStr = "exec db_sitemaster.dbo.usp_Ten_pcmain_Just1DayList2018 'mobile'"

set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

If IsArray(arrList) Then
	listidx = arrList(0,0)
	listtitle = arrList(1,0)
	liststartdate = arrList(2,0)
	listenddate = arrList(3,0)
	listregdate = arrList(4,0)
	listlastupdate = arrList(5,0)
	listadminid = arrList(6,0)
	listlastadminid = arrList(7,0)
	listisusing = arrList(8,0)
	listmaxsaleper = arrList(9,0)
	listtype = arrList(10,0)
	listbannerimage = arrList(11,0)
	listlinkurl = arrList(12,0)
	listworkertext = arrList(13,0)
	listplatform = arrList(14,0)
End If

If IsArray(arrList) Then
	sqlStr = "exec db_sitemaster.dbo.usp_Ten_pcmain_Just1DayItem2019 '"&listidx&"' "
	'Response.write sqlStr
	'response.End
	set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
	IF Not (rsMem.EOF OR rsMem.BOF) THEN
		arrItem = rsMem.GetRows
		arrItemCount = rsMem.RecordCount
	END IF
	rsMem.close
End If

on Error Resume Next
if arrItemCount <= 2 then 
intJ = 0

Dim vTimerDate
vTimerDate = DateAdd("d",1,Date())

'// 타이머용
%>
<%	
	dim timePer 
	timePer = (100-CInt((DateDiff("s", Now(),listenddate) / DateDiff("s", liststartdate, listenddate)*100)) )	
	if timePer < 5 then timePer = 5
	
	targetNum = fix( timePer/5 ) 
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
	$("#countdown").html(dhour.substr(0,1)+dhour.substr(1,1)+":"+dmin.substr(0,1)+dmin.substr(1,1)+":"+dsec.substr(0,1)+dsec.substr(1,1)+" 남음");

	var usrDt=new Date();	// 현재 브라우저 시간
	var vTerm = parseInt(usrDt.getTime()/1000)-parseInt(j1nowDt.getTime()/1000);	// 시작시 시간과의 차이(초)
	j1minus_second = vTerm;	// 증가시간에 차이 반영

	setTimeout("countdown()",500)
}

$(function(){
	countdown();
});
</script>
<% If Trim(listtype)="just1day" Then %>
	<% If IsArray(arrItem) Then %>
		<% If arrItemCount >= 1 Then %>
			<% 
				For intI = 0 To UBound(arrItem, 2)
					itemsubidx = arrItem(0,intI)
					itemlistidx = arrItem(1,intI)
					itemtitle = arrItem(2,intI)
					itemitemid = arrItem(3,intI)
					itemfrontimage = arrItem(4,intI)
					itemprice = arrItem(5,intI)
					itemsaleper = arrItem(6,intI)
					itemisusing = arrItem(7,intI)
					itemsortnum = arrItem(8,intI)
					itemmakerid = arrItem(9,intI)
					itemitemdiv = arrItem(10,intI)
					itemgubun = arrItem(11,intI)
					itemsellcash = arrItem(12,intI)
					itemorgprice = arrItem(13,intI)
					itemsailprice = arrItem(14,intI)
					itemsellyn = arrItem(15,intI)
					itemlimityn = arrItem(16,intI)
					itemsailyn = arrItem(17,intI)
					itembasicimage = arrItem(18,intI)
					itemitemcoupontype = arrItem(19,intI)
					itemitemcouponvalue = arrItem(20,intI)
					itemitemcouponyn = arrItem(21,intI)
					itemtenonlyyn = arrItem(22,intI)
					itemdispcate1 = arrItem(23,intI)
					itembrandname = arrItem(24,intI)
					itemlimitno = arrItem(25,intI)
					itemlimitsold = arrItem(26,intI)
					itemBasicIMG = arrItem(27,intI)
					itemTenIMG = arrItem(28,intI)
					gaparam = "today_just1day_1_"&intI+1

					if itemTenIMG<>"" then
						itembasicimage = "http://thumbnail.10x10.co.kr/webimage/image/tenten600/"&GetImageSubFolderByItemid(itemitemid)&"/"&itemTenIMG
					else
						If itemitemdiv="21" then
							if instr(itemBasicIMG,"/") > 0 then
								itembasicimage = "http://thumbnail.10x10.co.kr/webimage/image/basic/"&itemBasicIMG
							Else
								itembasicimage = "http://thumbnail.10x10.co.kr/webimage/image/basic/"&GetImageSubFolderByItemid(itemitemid)&"/"&itemBasicIMG
							End If
						Else
							itembasicimage = "http://thumbnail.10x10.co.kr/webimage/image/basic/"&GetImageSubFolderByItemid(itemitemid)&"/"&itemBasicIMG
						End If
					End If
			%>
			<section class="time-sale">
				<div class="weekday">
					<% If isapp = "1" Then %>
						<% If itemitemdiv="21" Then %>	
							<a href="" class="items" onclick="fnAmplitudeEventMultiPropertiesAction('click_just1day','type|number|itemid','just1day|<%=intI+1%>|<%=itemitemid%>', function(bool){if(bool) {fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/deal/deal.asp?itemid=<%=itemitemid%>&gaparam=<%=gaparam%>');}});return false;">
						<% Else %>
							<a href="" class="items" onclick="fnAmplitudeEventMultiPropertiesAction('click_just1day','type|number|itemid','just1day|<%=intI+1%>|<%=itemitemid%>', function(bool){if(bool) {fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=<%=itemitemid%>&gaparam=<%=gaparam%>');}});return false;">
						<% End If %>
					<% Else %>
						<% If itemitemdiv="21" Then %>	
							<a href="/deal/deal.asp?itemid=<%=itemitemid%>&gaparam=<%=gaparam%>" class="items" onclick="fnAmplitudeEventMultiPropertiesAction('click_just1day','type|number|itemid','just1day|<%=intI+1%>|<%=itemitemid%>');">
						<% Else %>
							<a href="/category/category_itemprd.asp?itemid=<%=itemitemid%>&gaparam=<%=gaparam%>" class="items" onclick="fnAmplitudeEventMultiPropertiesAction('click_just1day','type|number|itemid','just1day|<%=intI+1%>|<%=itemitemid%>');">
						<% End If %>
					<% End If %>									 
						<div class="thumbnail">
								<% If Trim(itemfrontimage)<>"" Then %>						
									<img src="<%=Trim(itemfrontimage)%>" alt="<%=itemtitle%>">
								<% Else %>
									<img src="<%=Trim(itembasicimage)%>" alt="<%=itemtitle%>">
								<% End If %>													
						</div>
						<div class="desc">
							<h2 class="headline">JUST 1 DAY</h2>
							<b class="discount color-red">
							<%
							 If itemitemdiv="21" Then 							
								If Trim(itemsaleper)="" Then
									Response.write "하루특가"
								Else
									Response.write itemsaleper
								End If							
							 Else 								
								If Trim(itemsailyn)<>"Y" Then
                                    Response.write "하루특가"
                                Else
                                    Response.write CLng((itemorgprice-itemsellcash)/itemorgprice*100)&"%"
                                End If
							 End If 
							%>			
							</b>
							<p class="name"><%=itemtitle%></p>
							<div class="price">								
								<% If itemitemdiv="21" Then %>									
									<b class="sum"><%=itemprice%></b>									
								<% Else %>
									<s><%=FormatNumber(itemorgprice, 0)%></s>
									<b class="sum"><%=FormatNumber(itemsellcash, 0)%><span class="won">원</span></b>
								<% End If %>								
							</div>
						</div>
					</a>
					<div class="time-line interval-<%=targetNum%>"><%'1~20%>
						<span class="time" id="countdown"></span>
					</div>
				</div>	
			</section>
			<% 
				If intI >= 0 Then
					Exit For
				End If
			%>
			<% Next %>				
		<% End If %>
	<% End If %>
<% End If %>

<% If Trim(listtype)="event" Then %>
	<% If Trim(listtitle) <> "" Then %>
		<% If IsArray(arrItem) Then %>
			<!-- 20190103 : 주말특가 배너 개선(br) -->
			<section class="time-sale">
				<div class="weekendV19">
					<%
						gaparam = "today_just1day_event"
					%>
					<% If isapp = "1" Then %>
						<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_just1day','type|number|itemid','event|none|none', function(bool){if(bool) {fnAPPpopupAutoUrl('<%=listlinkurl%>&gaparam=<%=gaParam%>');}});return false;" class="items">
					<% Else %>
						<a href="<%=wwwurl&listlinkurl%>&gaparam=<%=gaParam%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_just1day','type|number|itemid','event|none|none');" class="items">
					<% End If %>	
					<%	
						itemtitle = arrItem(2,0)
						itemfrontimage = arrItem(4,0)
						itembasicimage = arrItem(18,0)
					%>							
					<% If Trim(itemfrontimage)<>"" Then %>
						<div class="thumbnail"><img src="<%=getThumbImgFromURL(itemfrontimage,200,200,"true","false")%>" alt="<%=itemtitle%>" /></div>										
					<% Else %>
						<div class="thumbnail"><img src="<%=getThumbImgFromURL(itembasicimage,200,200,"true","false")%>" alt="<%=itemtitle%>" /></div>										
					<% end if %>																	
						<div class="desc">
							<p class="name"><%=Trim(listtitle)%></p>
							<b class="discount color-red"><%=listmaxsaleper%></b>
						</div>
					</a>
				</div>
			</section>	
		<% End If %>
	<% End If %>
<% End If %>
<% End If %>

<%
	on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->