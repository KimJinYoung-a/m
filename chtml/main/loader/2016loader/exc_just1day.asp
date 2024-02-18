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
Dim couponYn , couponvalue , coupontype , imagebasic , itemdiv , ldv , label , templdv , vis1day , intI , vIdx , vTitle , tentenimage400
Dim vtodayban , vextraurl '//주말용
Dim vsubtitle , vsaleper '//주말특가용
Dim cPk
Dim gaParam : gaParam = "&gaparam=today_just1day_1" '//GA 체크 변수
Dim gaParam2 : gaParam2 = "&gaparam=today_just1day_2" '//ga 주말 특가
Dim gaParam3 : gaParam3 = "&gaparam=today_just1day_3" '//GA 주말 배너
Dim tmpjson : tmpjson = ""
Dim dataList(0)
Dim json

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
		$("#countdown").html("00:00:00");
		return;
	}

	if(dhour < 10) dhour = "0" + dhour;
	if(dmin < 10) dmin = "0" + dmin;
	if(dsec < 10) dsec = "0" + dsec;
	dhour = dhour+'';
	dmin = dmin+'';
	dsec = dsec+'';

	// Print Time
	$("#countdown").html(dhour.substr(0,1)+dhour.substr(1,1)+":"+dmin.substr(0,1)+dmin.substr(1,1)+":"+dsec.substr(0,1)+dsec.substr(1,1));
	
	var usrDt=new Date();	// 현재 브라우저 시간
	var vTerm = parseInt(usrDt.getTime()/1000)-parseInt(nowDt.getTime()/1000);	// 시작시 시간과의 차이(초)
	minus_second = vTerm;	// 증가시간에 차이 반영

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
<section class="timeSale">
	<% If vis1day = "Y" Then '//평일%>
	<div class="onedayV17">
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
%>
	<% If vis1day = "Y" Then '// 평일노출용%>
		<% If isapp = "1" Then %>
		<a href="" onclick="fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=itemid%>&ldv=<%=templdv%><%=gaParam%>');return false;">
		<% Else %>
		<a href="/category/category_itemPrd.asp?itemid=<%=itemid%>&ldv=<%=templdv%><%=gaParam%>">
		<% End If %>
			<div class="desc">
				<h2>Just 1 day</h2>
				<div class="time"><b id="countdown">00:00:00</b></div>
				<p class="pName"><%=itemname%></p>
				<div class="pPrice"><s><%=formatNumber(orgPrice,0)%></s> <span>
					<% IF saleyn = "Y" or couponYn = "Y" Then %>
						<% IF (saleyn="Y") and (OrgPrice-SellCash>0) And couponYn <> "Y" THEN %><%=FormatNumber(SellCash,0)%>원<% end if %>
						<% if couponYn = "Y" Then %><%=FormatNumber(GetCouponAssignPrice,0)%>원<% end if %>
					<% End If %>
				</span></div>
			</div>
			<div class="pdtCont">
				<div class="pPhoto">
				<% If application("Svr_Info") = "Dev" Then %>
					<img src="<%=chkiif(Not(isnull(tentenimage400) Or tentenimage400 = ""),tentenimage400,imagebasic)%>" alt="<%=itemname%>" />
				<% Else %>
					<img src="<%=chkiif(Not(isnull(tentenimage400) Or tentenimage400 = ""),tentenimage400,getThumbImgFromURL(imagebasic,200,200,"true","false"))%>" alt="<%=itemname%>" />
				<% End If %>
				</div>
				<div class="label">
					<b class="red"><span><i>
					<% iF (saleyn="Y") and (OrgPrice-SellCash>0) And couponYn <> "Y" Then %>
						<% If OrgPrice = 0 Then	Response.Write "" Else Response.Write "" & CLng((OrgPrice-SellCash)/OrgPrice*100) & "" End If %>%
					<% Else %>
						<% If OrgPrice = 0 Then	Response.Write "" Else Response.Write "" & fix((OrgPrice-GetCouponAssignPrice)/OrgPrice*100) & "" End If %>%
					<% End If %>
					</i></span></b>
				</div>
			</div>
		</a>
	<% ElseIf vis1day = "W" Then %>
		<% If intI = 0 Then '//한번만 노출%>
		<% If isapp = "1" Then %>
		<a href="" onclick="fnAPPpopupAutoUrl('<%=vextraurl%><%=gaParam2%>');return false;">
		<% Else %>
		<a href="<%=vextraurl%><%=gaParam2%>">
		<% End If '//한번만 노출%>
			<h2><%=vTitle%></h2>
			<p><span><%=vsubtitle%></span><b><%=vsaleper%></b></p>
			<ul>
		<% End If %>
				<li><div>
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
		<%%>
	<% Else '주말 / 휴일용%>
		<% If isapp = "1" Then %>
		<a href="" onclick="fnAPPpopupAutoUrl('<%=vextraurl%><%=gaParam3%>');return false;"><img src="<%=vtodayban%>" alt="" /></a>
		<% Else %>
		<a href="<%=vextraurl%><%=gaParam3%>"><img src="<%=vtodayban%>" alt="" /></a>
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