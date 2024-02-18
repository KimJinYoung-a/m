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
' Discription : Today Deal 주말용 for_app
' History : 2015-02-17 이종화 생성
'#######################################################

Dim sqlStr , arrTodeal , i
Dim image , itemname , itemid , startdate , enddate	, dealtitle	, gubun1 , gubun2 , itemurl	, sellCash , orgPrice , sailYN , couponYn , couponvalue	, LimitYn , coupontype , itemurlmo
Dim reqdate : reqdate = Date()

	sqlStr = "select t.* , i.sellCash , i.orgPrice , i.sailyn , i.itemcouponYn, i.itemcouponvalue ,i.limitYN ,i.itemcoupontype , i.basicimage600 , i.basicimage "
	sqlStr = sqlStr + " , md.itemcouponidx , isnull(md.itemcoupontype,0) as ctype , isnull(md.itemcouponvalue,0) as cvalue "
	sqlStr = sqlStr + " from db_sitemaster.dbo.tbl_mobile_main_todaydeal as t "
	sqlStr = sqlStr + " inner join db_item.dbo.tbl_item as i "
	sqlStr = sqlStr + " on t.itemid = i.itemid "
	sqlStr = sqlStr + " left outer join "
	sqlStr = sqlStr + " ( "
	sqlStr = sqlStr + "   select m.itemcouponidx,m.itemcoupontype, m.itemcouponvalue , d.itemid "
	sqlStr = sqlStr + "   from [db_item].[dbo].tbl_item_coupon_detail as d "
	sqlStr = sqlStr + "		inner join [db_item].[dbo].tbl_item_coupon_master as m "
	sqlStr = sqlStr + "		on d.itemcouponidx = m.itemcouponidx "
	sqlStr = sqlStr + "		and m.coupongubun = 'T' "
'	sqlStr = sqlStr + "		and m.openstate in ('7') "
'	sqlStr = sqlStr + "		and getdate() between m.itemcouponstartdate and m.itemcouponexpiredate "
	sqlStr = sqlStr + "  ) as md on i.itemid = md.itemid "
	sqlStr = sqlStr & " where t.isusing = 'Y' "
	sqlStr = sqlStr & "		and t.enddate >= getdate() "
	sqlStr = sqlStr & "		and ('"& reqdate &"' between convert(varchar(10),t.startdate,120) and convert(varchar(10),t.enddate,120))"
	sqlStr = sqlStr & " order by t.startdate asc , t.sortnum asc , cvalue desc"

	dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"DEAL",sqlStr,60*60)
	If Not rsMem.EOF Then
		arrTodeal 	= rsMem.GetRows
	End if
	rsMem.close
	If isArray(arrTodeal) and not(isnull(arrTodeal)) Then

%>
<section class="todayDeal">
	<span class="icoTime"></span>
<%
	FOR i=0 to ubound(arrTodeal,2)

		If isnull(arrTodeal(24,i)) Or arrTodeal(24,i) = "" Then
			If isnull(arrTodeal(25,i)) Or arrTodeal(25,i) = "" Then
				image = ""
			Else 
				image = webImgUrl & "/image/basic/" + GetImageSubFolderByItemid(arrTodeal(10,i)) + "/" + arrTodeal(25,i)
			End if
		Else
			image = webImgUrl & "/image/basic600/" + GetImageSubFolderByItemid(arrTodeal(10,i)) + "/" + arrTodeal(24,i)
		End If 

		itemname			=	arrTodeal(11,i)
		itemid				=	arrTodeal(10,i)
		startdate			=	arrTodeal(1,i)
		enddate				=	arrTodeal(2,i)
		dealtitle			=	arrTodeal(12,i)
		gubun1				=	arrTodeal(13,i)
		gubun2				=	arrTodeal(14,i)
		itemurl				=	arrTodeal(15,i)
		sellCash			=	arrTodeal(17,i)
		orgPrice			=	arrTodeal(18,i)
		sailYN				=	arrTodeal(19,i)
		couponYn			=	arrTodeal(20,i)
		couponvalue			=	arrTodeal(21,i)
		LimitYn				=	arrTodeal(22,i)
		coupontype			=	arrTodeal(23,i)
		itemurlmo			=	arrTodeal(16,i)
%>
		<h2><% If gubun1 = "1" Then %>TIME SALE<% End If %><% If gubun1 = "2" Then %>WISH No.1<% End If %><% If gubun1 = "3" Then %>ISSUE ITEM<% End If %></h2>
		<p class="fs12"><%=dealtitle%></p>
		<div class="dealPdt" onclick="fnAPPpopupProduct('<%=itemid%>');">
			<div class="pic">
				<img src="<%= getThumbImgFromURL(image,420,420,"true","false") %>" alt="<%=itemname%>" />
			</div>
			<% If gubun1 = "3" Then %>
				<% If gubun2 = "1" Then %><span class="limit">한정<br />재입고</span><% End If %>
				<% If gubun2 = "2" Then %><span class="limit">HOT<br />ITEM</span><% End If %>
				<% If gubun2 = "3" Then %><span class="limit">SPECIAL<br />EDITION</span><% End If %>
				<% If gubun2 = "4" Then %><span class="limit">10X10<br />ONLY</span><% End If %>
			<% Else %>
				<% If cInt(datediff("h", now() , enddate)) < 1 Then %>
				<span class="limit">마감<br />임박!</span>
				<% Else %>
				<span class="limit"><%=cInt(datediff("h", now() , enddate))%>시간<br />남음</span>
				<% End If %>
			<% End If %>
		</div>
		<div class="pdtCont">
			<p class="pName"><%=itemname%></p>
			<% If sailYN = "N" and couponYn = "N" then %>
			<p class="pPrice"><%=formatNumber(orgPrice,0)%>원 </p>
			<% End If 
				 If sailYN = "Y" Then %>
			<p class="pPrice"><%=formatNumber(sellCash,0)%>원 <span class="cRd1"><% If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then  %>[<%=CLng((orgPrice-sellCash)/orgPrice*100)%>%]<% End If %></span></p>							
			<% End If 
				if couponYn = "Y" And couponvalue>0 then%>
			<p class="pPrice">
				<%If coupontype = "1" Then
					response.write formatNumber(sellCash - CLng(couponvalue*sellCash/100),0) & "원"
					response.write " <span class=""cGr1"">[" & couponvalue & "%]</span>"
				ElseIf coupontype = "2" Then
					response.write formatNumber(sellCash - couponvalue,0) & "원"
					response.write " <span class=""cGr1"">[" & couponvalue & "원 할인]</span>"
				ElseIf coupontype = "3" Then
					response.write formatNumber(sellCash,0) & "원"
					response.write " <span class=""cGr1"">[무료배송]</span>"
				Else
					response.write formatNumber(sellCash,0) & "원"
				End If%>
			</p>
			<% End If %>
		</div>
<%
	Next
%>
</section>
<%
	End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->