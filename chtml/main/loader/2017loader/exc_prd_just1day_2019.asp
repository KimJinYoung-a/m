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
' Discription : exc_prd_just1day_2019.asp 모바일 상품상세, 딜 하단 justonday
' History : 2019-01-29 최종원
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
Dim itemlimitno, itemlimitsold

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "PBJUST1DAYITEMMOBILE_"&Cint(timer/60)
Else
	cTime = 60*5
	cTime = 1*1
	dummyName = "PBJUST1DAYITEMMOBILE"
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
	sqlStr = "exec db_sitemaster.dbo.usp_Ten_pcmain_Just1DayItem2018 '"&listidx&"' "
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

intJ = 0

Dim vTimerDate
vTimerDate = DateAdd("d",1,Date())

'// 타이머용
%>
<% targetNum = 100-CInt((DateDiff("s", Now(),listenddate) / DateDiff("s", liststartdate, listenddate)*100)) %>
<script>
var j1yr = "<%=Year(vTimerDate)%>";
var j1mo = "<%=TwoNumber(Month(vTimerDate))%>";
var j1da = "<%=TwoNumber(Day(vTimerDate))%>";
var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
var j1today=new Date(<%=Year(now)%>, <%=Month(now)-1%>, <%=Day(now)%>, <%=Hour(now)%>, <%=Minute(now)%>, <%=Second(now)%>);

var j1minus_second = 0;		// 변경될 증가시간(초)
var j1nowDt=new Date();		// 시작시 브라우저 시간

function prdCountdown(){
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
		$("#countdown-dsp").html("00:00:00");
		return;
	}

	if(dhour < 10) dhour = "0" + dhour;
	if(dmin < 10) dmin = "0" + dmin;
	if(dsec < 10) dsec = "0" + dsec;
	dhour = dhour+'';
	dmin = dmin+'';
	dsec = dsec+'';

	// Print Time
	$("#countdown-dsp").html(dhour.substr(0,1)+dhour.substr(1,1)+" : "+dmin.substr(0,1)+dmin.substr(1,1)+" : "+dsec.substr(0,1)+dsec.substr(1,1));

	var usrDt=new Date();	// 현재 브라우저 시간
	var vTerm = parseInt(usrDt.getTime()/1000)-parseInt(j1nowDt.getTime()/1000);	// 시작시 시간과의 차이(초)
	j1minus_second = vTerm;	// 증가시간에 차이 반영

	setTimeout("prdCountdown()",500)
}
$(function(){
	prdCountdown();
});
</script>

<!-- 상품상세 justonday -->
<script type="text/javascript" src="/lib/js/jquery.easypiechart.min.js"></script>
<script>		
$(function(){
	$('.item-add-just1day .chart').easyPieChart({
		barColor: '#ff3131',
		trackColor: '#f5f5f5',
		scaleColor: false,
		lineWidth: 0.6,
		animate: 3500,
		onStep: function(from, to, percent) {
			var value = percent * 360 / 100;
			$(this.el).find('.percent').css('transform','rotate('+value+'deg)');
		}
	});
})
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
					gaparam = "item_just1day"					
			%>
			<!-- 상품상세 딜상세 Just 1 Day (M) -->
			<div class="item-add-just1day">
				<em class="txt-today">오늘 하루 특가!</em>
				<h3>JUST 1 DAY <b class="discount color-red">
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
				</b></h3>
				<p class="time">
					<span class="icon icon-clock"></span>남은시간 <b id="countdown-dsp"></b>					
				</p>
					<% If isapp = "1" Then %>
						<% If itemitemdiv="21" Then %>	
							<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_prd_just1day','type|itemid','just1day|<%=itemitemid%>', function(bool){if(bool) {fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/deal/deal.asp?itemid=<%=itemitemid%>&gaparam=<%=gaparam%>');}});return false;">
						<% Else %>
							<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_prd_just1day','type|itemid','just1day|<%=itemitemid%>', function(bool){if(bool) {fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=<%=itemitemid%>&gaparam=<%=gaparam%>');}});return false;">
						<% End If %>
					<% Else %>
						<% If itemitemdiv="21" Then %>	
							<a href="/deal/deal.asp?itemid=<%=itemitemid%>&gaparam=<%=gaparam%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_prd_just1day','type|itemid','just1day|<%=itemitemid%>');">
						<% Else %>
							<a href="/category/category_itemprd.asp?itemid=<%=itemitemid%>&gaparam=<%=gaparam%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_prd_just1day','type|itemid','just1day|<%=itemitemid%>');">
						<% End If %>
					<% End If %>
					<div class="image-cont">
						<div class="thumbnail">
								<% If Trim(itemfrontimage)<>"" Then %>						
									<img src="<%=Trim(itemfrontimage)%>" alt="<%=itemtitle%>">
								<% Else %>
									<img src="<%=Trim(itembasicimage)%>" alt="<%=itemtitle%>">
								<% End If %>				
								<% IF itemsellyn = "N" THEN%>
									<div class="soldout"><b>SOLD OUT</b></div>					
								<% END IF %>												
						</div>						
						<div class="chart" data-percent="<%=targetNum%>"><span class="percent"></span></div>
					</div>
					<div class="desc">
						<p class="name"><%=itemtitle%></p>
						<div class="price">
						<% If itemitemdiv="21" Then %>									
							<b><%=itemprice%></b>							
						<% Else %>							
							<b><%=FormatNumber(itemsellcash, 0)%></b>
							<span class="won">원</span>
						<% End If %>											
						</div>
					</div>
				</a>
			</div>
			<!--// 상품상세 딜상세 Just 1 Day (M) -->
			<% 
				If intI >= 0 Then
					Exit For
				End If
			%>
			<% Next %>				
		<% End If %>
	<% End If %>
<% End If %>
<%
	on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->