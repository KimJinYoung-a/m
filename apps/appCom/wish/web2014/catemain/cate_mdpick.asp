<%
'#######################################################
' Discription : cate_mdpick // cache DB경유
' History : 2015-09-21 이종화 생성 + gnbcode
'#######################################################

Dim lprevDate , sqlStr , arrMdpick , i
Dim image , itemname , itemid , sellCash , orgPrice , sailYN , couponYn , couponvalue , LimitYn 
Dim coupontype , newyn , limitno , limitdispyn , makerid , brandname
gaParam = "&gaparam=catemain_c" '//GA 체크 변수
Dim CtrlTime : CtrlTime = hour(time)

	sqlStr = "Select top 10 s.subidx , s.listidx , s.itemid , s.isusing as itemusing , s.sortnum , isnull(s.itemname,i.itemname) as itemname , i.basicimage , datepart(hh, l.startdate) as starttime , datepart(hh, l.enddate) as endtime  , l.mdpicktitle"
	sqlStr = sqlStr & " , (case when DATEDIFF ( day , i.regdate  , getdate()) < 14 then 'Y' else 'N' end) as newyn "
	sqlStr = sqlStr & " , i.sellCash , i.orgPrice , i.sailyn , i.itemcouponYn , i.itemcouponvalue , i.limitYN , i.itemcoupontype , (i.limitno - i.limitsold) as limitno , i.limitdispyn , i.makerid , i.brandname" 
	sqlStr = sqlStr & " From [db_sitemaster].[dbo].tbl_mobile_cate_mdpick_item as s "
	sqlStr = sqlStr & "	left join db_item.dbo.tbl_item as i "
	sqlStr = sqlStr & "		on s.itemid=i.itemid "
	sqlStr = sqlStr & "			and i.itemid<>0 "
	sqlStr = sqlStr & "	left join [db_sitemaster].dbo.tbl_mobile_cate_mdpick_list as l "
	sqlStr = sqlStr & "	on s.listidx = l.idx  "
	sqlStr = sqlStr & " Where s.isusing = 'Y' and s.listidx = ( select top 1 idx from [db_sitemaster].dbo.tbl_mobile_cate_mdpick_list where gnbcode = "& gcode &" and ( '" & Date() & "' between convert(varchar(10),startdate,120) and convert(varchar(10),enddate,120)) and isusing ='Y' order by startdate desc ) "
	sqlStr = sqlStr & " order by s.listidx asc , s.sortnum asc  "

	'response.write sqlStr

	dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"CATEPICK",sqlStr,60*10)
	If Not rsMem.EOF Then
		arrMdpick 	= rsMem.GetRows
	End if
	rsMem.close

	If isArray(arrMdpick) and not(isnull(arrMdpick)) Then
%>
	<h2 class="title titleLine"><span>MD'S PICK</span></h2>
	<ul class="pdtListV15a">
<%
		FOR i=0 to ubound(arrMdpick,2)
			image		= webImgUrl & "/image/basic/" + GetImageSubFolderByItemid(db2Html(arrMdpick(2,i))) + "/" + db2Html(arrMdpick(6,i))
			itemname	= arrMdpick(5,i)
			itemid		= trim(arrMdpick(2,i))
			sellCash	= arrMdpick(11,i)
			orgPrice	= arrMdpick(12,i)
			sailYN		= arrMdpick(13,i)
			couponYn	= arrMdpick(14,i)
			couponvalue = arrMdpick(15,i)
			LimitYn		= arrMdpick(16,i)
			coupontype	= arrMdpick(17,i)
			newyn		= arrMdpick(10,i)
			limitno		= arrMdpick(18,i)
			limitdispyn = arrMdpick(19,i)
			makerid		= arrMdpick(20,i)
			brandname	= arrMdpick(21,i)
%>
		<li <% If LimitYn="Y" And limitdispyn="Y" And limitno = 0 Then %>class="soldOut"<% End If %><% If LimitYn="Y" And limitno > 0 And limitno <= 10 And limitdispyn = "Y" Then %>class="notiTagV15a"<% End If %>>
			<a href="" onclick="fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=itemid%><%=gaParam%>');return false;">
				<div class="pPhoto">
					<% If LimitYn="Y" And limitdispyn="Y" And limitno = 0 Then %>
					<p><span><em>품절</em></span></p>
					<% End If %>
					<% If LimitYn="Y" And limitno > 0 And limitno <= 10 And limitdispyn = "Y" Then %>
					<p class="bltTimeV15a"><span>HURRY UP</span></p>
					<% End If %>
					<img src="<%=getThumbImgFromURL(image,286,286,"true","false")%>" alt="<%=itemname%>" /></div>
				<div class="pdtCont">
					<p class="pName"><%=itemname%></p>
					<% If sailYN = "N" and couponYn = "N" then %>
					<p class="pPrice"><%=formatNumber(orgPrice,0)%>원 </p>
					<% End If 
						 If sailYN = "Y" and couponYn = "N" Then %>
					<p class="pPrice"><%=formatNumber(sellCash,0)%>원 <span class="cRd1"><% If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then  %>[<%=CLng((orgPrice-sellCash)/orgPrice*100)%>%]<% End If %></span></p>
					<% End If 
						if couponYn = "Y" And couponvalue>0 then%>
					<p class="pPrice">
						<%If coupontype = "1" Then
							response.write formatNumber(sellCash - CLng(couponvalue*sellCash/100),0)
						ElseIf coupontype = "2" Then
							response.write formatNumber(sellCash - couponvalue,0)
						ElseIf coupontype = "3" Then
							response.write formatNumber(sellCash,0)
						Else
							response.write formatNumber(sellCash,0)
						End If%>원 <span class="cGr1">[<%If coupontype = "1" Then
							response.write CStr(couponvalue) & "%"
						ElseIf coupontype = "2" Then
							response.write formatNumber(couponvalue,0) & "원 할인"
						ElseIf coupontype = "3" Then
							response.write "무료배송"
						Else
							response.write couponvalue
						End If %>]</span>
					</p>
					<% End If %>
				</div>
			</a>
		</li>
<%
		Next
%>
	</ul>
<%
	End If
%>