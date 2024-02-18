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
' Discription : mobile_just1day_json // cache DB경유
' History : 2016-04-29 이종화 생성
' History : 2017-04-07 이종화 추가 -- 주말용
'#######################################################

Dim itemid , itemname ,  sellcash , orgPrice ,  makerid , brandname , sellyn , saleyn , limityn , limitno , limitsold
Dim couponYn , couponvalue , coupontype , imagebasic , itemdiv , ldv , label , templdv , vis1day , intI , vIdx , vTitle , tentenimage400, saleper
Dim vtodayban , vextraurl '//주말용
Dim vsubtitle , vsaleper '//주말특가용
Dim cPk
Dim gaParam : gaParam = "&gaparam=today_just1day_1" '//GA 체크 변수
Dim gaParam2 : gaParam2 = "&gaparam=today_just1day_2" '//ga 주말 특가
Dim gaParam3 : gaParam3 = "&gaparam=today_just1day_3" '//GA 주말 배너
Dim tmpjson : tmpjson = ""
Dim dataList(0)
Dim json
Dim timername

If Hour(now) < 2 Then
	timername = "1"
ElseIf Hour(now) >= 23 Then
	timername = "11"
Else
	timername = CInt(Hour(now) / 2)
End If

SET cPk = New CPick
	cPk.GetPickOne()

	If cPk.FTotalCount > 0 Then
		vIdx = cPk.FItemOne.Fidx
		vTitle = cPk.FItemOne.Ftitle
		vis1day = cPk.FItemOne.Fis1day
		vtodayban = cPk.FItemOne.Ftodayban '//주말용 배너
		vextraurl = cPk.FItemOne.Fextraurl '//주말용 URL
		vsubtitle = cPk.FItemOne.Fsubtitle '//주말특가 서브타이틀
		vsaleper  = cPk.FItemOne.Fsaleper '//주말특그 세일 %
	End IF

	If vIdx <> "" Then
		If vis1day = "W" then
			cPk.FPageSize = 3
		Else
			cPk.FPageSize = 1
		End If
		cPk.FCurrPage = 1
		cPk.FRectIdx  = vIdx
		If vis1day = "W" then
			cPk.FRectSort = 3
		Else
			cPk.FRectSort = 1
		End If
		cPk.GetPickItemList()
	End If

	Dim vTimerDate
	vTimerDate = DateAdd("d",1,Date())

'// 타이머용
%>
<% If vis1day = "Y" Then '//평일%>
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
<% End If %>
<%
'// 타이머용
'##################################################################
'// 원 판매 가격  '!
public Function getOrgPrice()
	if OrgPrice=0 then
		getOrgPrice = Sellcash
	else
		getOrgPrice = OrgPrice
	end if
end Function
'// 세일포함 실제가격  '!
public Function getRealPrice()
	getRealPrice = SellCash
end Function
'// 상품 쿠폰 여부  '!
public Function IsCouponItem()
	IsCouponItem = (couponYn="Y")
end Function
'// 할인가
public Function getDiscountPrice()
	dim tmp
	if (CLng((OrgPrice-SellCash)/OrgPrice*100)<>1) then
		tmp = cstr(Sellcash * CLng((OrgPrice-SellCash)/OrgPrice*100))
		getDiscountPrice = round(tmp / 100) * 100
	else
		getDiscountPrice = Sellcash
	end if
end Function
'// 할인율 '!
public Function getSalePro()
	if Orgprice=0 then
		getSalePro = 0 & "%"
	else
		getSalePro = CLng((OrgPrice-getRealPrice)/OrgPrice*100) & "%"
	end if
end Function
'// 쿠폰 적용가
public Function GetCouponAssignPrice() '!
	if (IsCouponItem) then
		GetCouponAssignPrice = getRealPrice - GetCouponDiscountPrice
	else
		GetCouponAssignPrice = getRealPrice
	end if
end Function
'// 쿠폰 할인가 '?
public Function GetCouponDiscountPrice()
	Select case coupontype
		case "1" ''% 쿠폰
			GetCouponDiscountPrice = CLng(couponvalue*getRealPrice/100)
		case "2" ''원 쿠폰
			GetCouponDiscountPrice = couponvalue
		case "3" ''무료배송 쿠폰
			GetCouponDiscountPrice = 0
		case else
			GetCouponDiscountPrice = 0
	end Select
end Function
'##################################################################
on Error Resume Next
if cPk.fresultcount >= 0 Then
	Dim i : i = 0
%>
<section class="time-sale">
	<% If vis1day = "Y" Then '//평일%>
	<div class="weekday">
	<% ElseIf vis1day = "W" Then '//주말특가%>
	<div class="weekend">
	<% Else '//주말 배너%>
	<div class="bnr">
	<% End If %>
<%
	for intI = 0 to cPk.fresultcount

		itemid			= cPk.FCategoryPrdList(intI).FItemID
		itemname		= cPk.FCategoryPrdList(intI).FItemName
		sellcash		= cPk.FCategoryPrdList(intI).FSellcash
		orgPrice		= cPk.FCategoryPrdList(intI).FOrgPrice
		makerid			= cPk.FCategoryPrdList(intI).FMakerId
		brandname		= cPk.FCategoryPrdList(intI).FBrandName
		sellyn			= cPk.FCategoryPrdList(intI).FSellYn
		saleyn			= cPk.FCategoryPrdList(intI).FSaleYn
		limityn			= cPk.FCategoryPrdList(intI).FLimitYn
		limitno			= cPk.FCategoryPrdList(intI).FLimitNo
		limitsold		= cPk.FCategoryPrdList(intI).FLimitSold
		couponYn		= cPk.FCategoryPrdList(intI).Fitemcouponyn
		couponvalue		= cPk.FCategoryPrdList(intI).FItemCouponValue
		coupontype		= cPk.FCategoryPrdList(intI).Fitemcoupontype
		imagebasic		= cPk.FCategoryPrdList(intI).FImageBasic
		itemdiv			= cPk.FCategoryPrdList(intI).Fitemdiv
		ldv				= cPk.FCategoryPrdList(intI).Fldv
		label			= cPk.FCategoryPrdList(intI).Flabel
		templdv			= cPk.FCategoryPrdList(intI).Fldv
		tentenimage400	= cPk.FCategoryPrdList(intI).Ftentenimage400
		saleper	= cPk.FCategoryPrdList(intI).Fsaleper
%>
	<% If vis1day = "Y" Then '// 평일노출용%>
		<% If isapp = "1" Then %>
		<a href="" onclick="fnAmplitudeEventAction('click_just1day','type','weekday', function(bool){if(bool) {fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=itemid%>&ldv=<%=templdv%><%=gaParam%>');}});return false;" class="items">
		<% Else %>
		<a href="/category/category_itemPrd.asp?itemid=<%=itemid%>&ldv=<%=templdv%><%=gaParam%>" onclick=fnAmplitudeEventAction('click_just1day','type','weekday'); class="items">
		<% End If %>
			<div class="thumbnail">
				<% If vtodayban <> "" Then %>
					<img src="<%=vtodayban%>" alt="<%=itemname%>" />
				<% Else %>
					<% If application("Svr_Info") = "Dev" Then %>
						<img src="<%=chkiif(Not(isnull(tentenimage400) Or tentenimage400 = ""),tentenimage400,imagebasic)%>" alt="<%=itemname%>" />
					<% Else %>
						<img src="<%=chkiif(Not(isnull(tentenimage400) Or tentenimage400 = ""),tentenimage400,getThumbImgFromURL(imagebasic,200,200,"true","false"))%>" alt="<%=itemname%>" />
					<% End If %>
				<% End If %>
			</div>
			<div class="desc">
				<h2 class="headline">JUST 1 DAY</h2>
				<b class="discount color-red">
					<% If itemdiv="21" Then %>
					<% = saleper %>%
					<% Else %>
					<% iF (saleyn="Y") and (OrgPrice-SellCash>0) And couponYn <> "Y" Then %>
						<% If OrgPrice = 0 Then	Response.Write "" Else Response.Write "" & CLng((OrgPrice-SellCash)/OrgPrice*100) & "" End If %>%
					<% Else %>
						<% If OrgPrice = 0 Then	Response.Write "" Else Response.Write "" & fix((OrgPrice-GetCouponAssignPrice)/OrgPrice*100) & "" End If %>%
					<% End If %>
					<% End If %>
				</b>
				<p class="name"><%=itemname%></p>
				<div class="price">
					<% If itemdiv="21" Then %>
					<%else%>
					<s><%=formatNumber(orgPrice,0)%></s>
					<% End If %>
					<b class="sum">
					<% If itemdiv="21" Then %>
					<%=formatNumber(SellCash,0)%><span class="won">원~</span>
					<%else%>
						<% IF saleyn = "Y" or couponYn = "Y" Then %>
							<% IF (saleyn="Y") and (OrgPrice-SellCash>0) And couponYn <> "Y" THEN %><%=FormatNumber(SellCash,0)%><span class="won">원</span><% end if %>
							<% if couponYn = "Y" Then %><%=FormatNumber(GetCouponAssignPrice,0)%><span class="won">원</span><% end if %>
						<% End If %>
					<% End If %>
					</b>
				</div>
			</div>
		</a>
		<div class="time-line interval-<%=timername%>"><span class="time" id="countdown">00:00:00 남음</span></div>
	<% ElseIf vis1day = "W" Then %>
		<% If intI = 0 Then '//한번만 노출%>
		<% If isapp = "1" Then %>
		<a href="" onclick="fnAmplitudeEventAction('click_just1day','type','event', function(bool){if(bool) {fnAPPpopupAutoUrl('<%=vextraurl%><%=gaParam2%>');}});return false;">
		<% Else %>
		<a href="<%=vextraurl%><%=gaParam2%>" onclick=fnAmplitudeEventAction('click_just1day','type','event');>
		<% End If '//한번만 노출%>
			<h2 class="headline">
				<span class="copy"><span class="ellipsis"><%=vTitle%></span><span class="icon icon-arrow"></span></span>
				<b class="discount color-red"><%=vsaleper%></b>
			</h2>
			<ul class="items">
		<% End If %>
				<li><div class="thumbnail">
				<% If application("Svr_Info") = "Dev" Then %>
					<img src="<%=chkiif(Not(isnull(tentenimage400) Or tentenimage400 = ""),tentenimage400,imagebasic)%>" alt="<%=itemname%>" />
				<% Else %>
					<img src="<%=chkiif(Not(isnull(tentenimage400) Or tentenimage400 = ""),tentenimage400,getThumbImgFromURL(imagebasic,180,180,"true","false"))%>" alt="<%=itemname%>" />
				<% End If %>
				</div></li>
		<% If intI = cPk.fresultcount Then '//한번만 노출%>
			</ul>
		</a>
		<% End If '//한번만 노출%>
	<% Else '주말 / 휴일용%>
		<% If isapp = "1" Then %>
		<a href="" onclick="fnAmplitudeEventAction('click_just1day','type','weekend', function(bool){if(bool) {fnAPPpopupAutoUrl('<%=vextraurl%><%=gaParam3%>');}});return false;"><div class="thumbnail"><img src="<%=vtodayban%>" alt="" /></div></a>
		<% Else %>
		<a href="<%=vextraurl%><%=gaParam3%>" onclick=fnAmplitudeEventAction('click_just1day','type','weekend');><div class="thumbnail"><img src="<%=vtodayban%>" alt="" /></div></a>
		<% End If %>
	<% End If %>
<%
	Next
	set cPk = Nothing
%>
	</div>
</section>
<%
End If
on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->