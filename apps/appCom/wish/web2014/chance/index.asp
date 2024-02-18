<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/main/main_Chance.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<%
'###########################################################
' Description :  CHANCE-모바일
' History : 2014-11-25 이종화 생성
'###########################################################

	Dim cPk, vIdx, vTitle, intI
	Dim oItem , vTimerDate
	
	SET cPk = New CPick
	cPk.GetPickOne()
	
	If cPk.FTotalCount > 0 Then
		vIdx = cPk.FItemOne.Fidx
		vTitle = cPk.FItemOne.Ftitle
	End IF
	
	If vIdx <> "" Then
		cPk.FPageSize = 30
		cPk.FCurrPage = 1
		cPk.FRectIdx = vIdx
		cPk.FRectSort = 1
		cPk.GetPickItemList()
	End If

	vTimerDate = DateAdd("d",1,now)

	Function labeltext(v)
		Dim returntext
		Select Case v
			Case "1"
				returntext = "10x10 ONLY"
			Case "2"
				returntext = "HOT ITEM"
			Case "3"
				returntext = "WISH NO.1"
			Case "4"
				returntext = "BEST ITEM"
			Case "5"
				returntext = "JUST 1 DAY"
			Case "6"
				returntext = "한정 Limited"
			Case "7"
				returntext = "1+1"
			Case "8"
				returntext = "SALE"
			Case "9"
				returntext = "무료배송"
		End select
		Response.write returntext
	End function

%>
<script>
var yr = "<%=Year(vTimerDate)%>";
var mo = "<%=TwoNumber(Month(vTimerDate))%>";
var da = "<%=TwoNumber(Day(vTimerDate))%>";
var tmp_hh = "99";
var tmp_mm = "99";
var tmp_ss = "99";
var minus_second = 0;
var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
var today=new Date(<%=Year(now)%>, <%=Month(now)-1%>, <%=Day(now)%>, <%=Hour(now)%>, <%=Minute(now)%>, <%=Second(now)%>);

function countdown(){
	today = new Date(Date.parse(today) + (1000+minus_second));	//서버시간에 1초씩 증가
	var todayy=today.getYear()

	if(todayy < 1000)
		todayy+=1900
		
		var todaym=today.getMonth()
		var todayd=today.getDate()
		var todayh=today.getHours()
		var todaymin=today.getMinutes()
		var todaysec=today.getSeconds()
		var todaystring=montharray[todaym]+" "+todayd+", "+todayy+" "+todayh+":"+todaymin+":"+todaysec
		//futurestring=montharray[mo-1]+" "+da+", "+yr+" 11:59:59";
		futurestring=montharray[mo-1]+" "+da+", "+yr+" 00:00:00";

		dd=Date.parse(futurestring)-Date.parse(todaystring)
		dday=Math.floor(dd/(60*60*1000*24)*1)
		dhour=Math.floor((dd%(60*60*1000*24))/(60*60*1000)*1)
		dmin=Math.floor(((dd%(60*60*1000*24))%(60*60*1000))/(60*1000)*1)
		dsec=Math.floor((((dd%(60*60*1000*24))%(60*60*1000))%(60*1000))/1000*1)

		if(dday < 0)
		{
			$(".time").hide();
			return;
		}

		if(dhour < 10) {
			dhour = "0" + dhour;
		}
		if(dmin < 10) {
			dmin = "0" + dmin;
		}
		if(dsec < 10) {
			dsec = "0" + dsec;
		}

		$("#lyrCounter").html(dhour +"<span>:</span>"+ dmin +"<span>:</span>"+ dsec);
		
		tmp_hh = dhour;
		tmp_mm = dmin;
		tmp_ss = dsec;
		minus_second = minus_second + 1;

	setTimeout("countdown()",1000)
}

$(function() {
	//counter
	countdown();
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container bgGry">
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="todayChance">
				<p class="time" id="lyrCounter">00<span>:</span>00<span>:</span>00</p>
				<p class="desc">오직 단 하루만 진행하는 투데이 찬스!</p>
			</div>
			<ul class="chanceList">
			<%
			If cPk.FResultCount > 0 Then
				For intI =0 To cPk.FResultCount
			%>
				<li>
					<a href="#" onclick="fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=cPk.FCategoryPrdList(intI).Fitemid%>&ldv=<%=cPk.FCategoryPrdList(intI).Fldv%>');return false;">
					<%
						if Not(cPk.FCategoryPrdList(intI).Fldv="" or isNull(cPk.FCategoryPrdList(intI).Fldv)) then
							cPk.FCategoryPrdList(intI).Fldv = trim(Base64decode(cPk.FCategoryPrdList(intI).Fldv))
							if isNumeric(cPk.FCategoryPrdList(intI).Fldv) then
								dim strSQL
								strSQL = " select m.itemcoupontype, m.itemcouponvalue "
								strSQL = strSQL & " from [db_item].[dbo].tbl_item_coupon_master as m "
								strSQL = strSQL & " Join [db_item].[dbo].tbl_item_coupon_detail as d "
								strSQL = strSQL & " on m.itemcouponidx=d.itemcouponidx "
								strSQL = strSQL & " where m.itemcouponidx='"& cPk.FCategoryPrdList(intI).Fldv &"' "
								strSQL = strSQL & " and d.itemid= '"& cPk.FCategoryPrdList(intI).Fitemid &"' "

								rsget.Open strSQL,dbget,1
								IF Not (rsget.EOF OR rsget.BOF) THEN
									cPk.FCategoryPrdList(intI).FCurrItemCouponIdx	= cPk.FCategoryPrdList(intI).Fldv
									cPk.FCategoryPrdList(intI).FItemCouponYN		= "Y"
									cPk.FCategoryPrdList(intI).FItemCouponType 		= rsget("itemcoupontype")
									cPk.FCategoryPrdList(intI).FItemCouponValue		= rsget("itemcouponvalue")
								END IF
								rsget.close
							end if
						end If
					%>

						<div class="dealPdt">
							<div class="pic"><img src="<%= cPk.FCategoryPrdList(intI).FImageBasic %>" alt="<%= cPk.FCategoryPrdList(intI).FItemName %>"></div>
							<% If cPk.FCategoryPrdList(intI).Flabel <> "0" Then %><span class="type"><%=labeltext(cPk.FCategoryPrdList(intI).Flabel)%></span><% End If %>
						</div>
						<div class="pdtCont">
							<p class="pName">[<%= cPk.FCategoryPrdList(intI).FBrandName %>] <%= cPk.FCategoryPrdList(intI).FItemName %></p>
							<!-- 가격 -->
							<% IF cPk.FCategoryPrdList(intI).IsSaleItem or cPk.FCategoryPrdList(intI).isCouponItem Then %>
								<% IF (cPk.FCategoryPrdList(intI).FSaleYn="Y") and (cPk.FCategoryPrdList(intI).FOrgPrice-cPk.FCategoryPrdList(intI).FSellCash>0) THEN %>
								<p class="pPrice"><%=FormatNumber(cPk.FCategoryPrdList(intI).FSellCash,0) & chkIIF(cPk.FCategoryPrdList(intI).IsMileShopitem,"Point","원")%>
									<span class="cRd1">
									<%
										If cPk.FCategoryPrdList(intI).FOrgprice = 0 Then
											Response.Write "[0%] "
										Else
											Response.Write "[" & CLng((cPk.FCategoryPrdList(intI).FOrgPrice-cPk.FCategoryPrdList(intI).FSellCash)/cPk.FCategoryPrdList(intI).FOrgPrice*100) & "%] "
										End If
									%>
									</span>
								</p>
								<% end if %>
								<% if cPk.FCategoryPrdList(intI).isCouponItem Then %>
								<p class="pPrice"><%= FormatNumber(cPk.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<%= cPk.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span>
								</p>
								<% end if %>
							<% Else %>
								<p class="pPrice"><%= FormatNumber(cPk.FCategoryPrdList(intI).getOrgPrice,0) %><% if cPk.FCategoryPrdList(intI).IsMileShopitem then %>Point<% else %>원<% end  if %></p>
							<% End If %>
						</div>
					</a>
				</li>
			<%
				Next
			End If
			%>
			</ul>
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</div>
</body>
</html>
<% 
	SET cPk = Nothing 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->