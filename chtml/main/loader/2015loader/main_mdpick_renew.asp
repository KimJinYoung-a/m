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
' Discription : mobile_mdpick // cache DB경유
' History : 2015-05-11 이종화 생성
'#######################################################

Dim lprevDate , sqlStr , arrMdpick , i 
Dim image , itemname , itemid , sellCash , orgPrice , sailYN , couponYn , couponvalue , LimitYn , tentenimg400
Dim coupontype , newyn , limitno , limitdispyn , makerid , brandname , gubun , linkurl
Dim gaParam1 : gaParam1 = "&gaparam=todaymain2_d" '//GA 체크 변수
Dim gaParam2 : gaParam2 = "&gaparam=todaymain2_e" '//GA 체크 변수
Dim CtrlTime : CtrlTime = hour(time)

	sqlStr = "Select top 20 s.subidx , s.listidx , s.itemid , s.isusing as itemusing , s.sortnum , isnull(s.itemname,i.itemname) as itemname , i.basicimage , datepart(hh, l.startdate) as starttime , datepart(hh, l.enddate) as endtime  , l.mdpicktitle"
	sqlStr = sqlStr & " , (case when DATEDIFF ( day , i.regdate  , getdate()) < 14 then 'Y' else 'N' end) as newyn "
	sqlStr = sqlStr & " , i.sellCash , i.orgPrice , i.sailyn , i.itemcouponYn , i.itemcouponvalue , i.limitYN , i.itemcoupontype , (i.limitno - i.limitsold) as limitno , i.limitdispyn , i.makerid , i.brandname , s.gubun , i.tentenimage400" 
	sqlStr = sqlStr & " From [db_sitemaster].[dbo].tbl_mobile_main_mdpick_item as s "
	sqlStr = sqlStr & "	left join db_item.dbo.tbl_item as i "
	sqlStr = sqlStr & "		on s.itemid=i.itemid "
	sqlStr = sqlStr & "			and i.itemid<>0 "
	sqlStr = sqlStr & "	left join [db_sitemaster].dbo.tbl_mobile_main_mdpick_list as l "
	sqlStr = sqlStr & "	on s.listidx = l.idx  "
	sqlStr = sqlStr & " Where s.isusing = 'Y' and ('" & Date() & "' between convert(varchar(10),l.startdate,120) and convert(varchar(10),l.startdate,120)) "
	sqlStr = sqlStr & " and ('"& CtrlTime &"' between datepart(hh, l.startdate) and datepart(hh, l.enddate)) and l.isusing = 'Y' and s.gubun <> 0 "
	sqlStr = sqlStr & " order by s.topview desc , s.gubun , s.listidx asc , s.sortnum asc  "

	'response.write sqlStr

	dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"MDPICK",sqlStr,60*10)
	If Not rsMem.EOF Then
		arrMdpick 	= rsMem.GetRows
	End if
	rsMem.close
	If isArray(arrMdpick) and not(isnull(arrMdpick)) Then
%>
<%
		FOR i=0 to ubound(arrMdpick,2)
			tentenimg400= webImgUrl & "/image/tenten400/" + GetImageSubFolderByItemid(db2Html(arrMdpick(2,i))) + "/" + db2Html(arrMdpick(23,i))
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
			gubun		= arrMdpick(22,i) '//gubun mdpick , rookie , chance , best

			If db2Html(arrMdpick(23,i)) = "" Or isnull(db2Html(arrMdpick(23,i))) Then '//tentenimg
				tentenimg400 = ""
			End If 
%>
			<% If i Mod 5 = 0 Then %>
			<%
				If gubun=1 Then linkurl = "onclick=""location.href='/mdpicklist/'"" " End if
				If gubun=2 Then linkurl = "onclick=""location.href='/shoppingtoday/shoppingchance_newitem.asp'"" " End if
				If gubun=3 Then linkurl = "onclick=""location.href='/shoppingtoday/shoppingchance_saleitem.asp'"" " End if
				If gubun=4 Then linkurl = "onclick=""location.href='/award/awarditem.asp'"" " End if
			%>
			<div class="curationSetV15a <%=chkiif(gubun = 2 Or gubun = 4,"setLt","setRt")%>">
				<div class="listTitV15a <%=chkiif(gubun = 4," bestCurateV15a","")%>" <%=linkurl%>>
					<div class="titContV15a">
						<div>
							<% If gubun=1 Then %>
							<h2 class="cur01V15a">MD'S PICK</h2>
							<p>텐바이텐 MD들이 <br />직접 선택한 아이템은?</p>
							<% End If %>
							<% If gubun=2 Then %>
							<h2 class="cur02V15a">ROOKIE!</h2>
							<p>한 발 앞선 트렌드, <br />지금 막 떠오르는 루키</p>
							<% End If %>
							<% If gubun=3 Then %>
							<h2 class="cur03V15a">CHANCE</h2>
							<p>지금 안사면 후회하는 <br />혜택 빵빵 아이템</p>
							<% End If %>
							<% If gubun=4 Then %>
							<h2 class="cur04V15a">BEST ITEM</h2>
							<p>요즘, 다른 사람들은 <br />뭘 살까?</p>
							<% End If %>
						</div>
						<% If gubun=1 Then %><a href="/mdpicklist/" class="pdtMoreV15a"><span>MD' PICK 더보기</span></a><% End If %>
						<% If gubun=2 Then %><a href="/shoppingtoday/shoppingchance_newitem.asp" class="pdtMoreV15a"><span>ROOKIE! 더보기</span></a><% End If %>
						<% If gubun=3 Then %><a href="/shoppingtoday/shoppingchance_saleitem.asp" class="pdtMoreV15a"><span>CHANCE 더보기</span></a><% End If %>
						<% If gubun=4 Then %><a href="/award/awarditem.asp" class="pdtMoreV15a"><span>BEST 더보기</span></a><% End If %>
						<% If gubun=4 Then %>
						<img src="http://fiximage.10x10.co.kr/m/2015/today/tit_box_best.png" alt="" />
						<% Else %>
						<img src="http://fiximage.10x10.co.kr/m/2015/today/tit_box.png" alt="" />
						<% End If %>
					</div>
				</div>
				<ul class="pdtListV15a">
			<% End If %>
					<li <% If LimitYn="Y" And limitdispyn="Y" And limitno = 0 Then %>class="soldOut"<% End If %><% If LimitYn="Y" And limitno > 0 And limitno <= 10 And limitdispyn = "Y" Then %>class="notiTagV15a"<% End If %>>
						<a href="/category/category_itemPrd.asp?itemid=<%=itemid%><%=chkiif(gubun=1 Or gubun=2,gaParam1,gaParam2)%>">
							<div class="pPhoto">
								<% If LimitYn="Y" And limitdispyn="Y" And limitno = 0 Then %>
								<p><span><em>품절</em></span></p>
								<% End If %>
								<% If LimitYn="Y" And limitno > 0 And limitno <= 10 And limitdispyn = "Y" Then %>
								<p class="bltTimeV15a"><span>HURRY UP</span></p>
								<% End If %>
								<img src="<%=chkiif(Not(isnull(tentenimg400) Or tentenimg400 = ""),tentenimg400,getThumbImgFromURL(image,400,400,"true","false"))%>" alt="<%=itemname%>" /></div>
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
						<img src="http://fiximage.10x10.co.kr/m/2015/today/list_box.png" alt="" />
					</li>
			<% If i Mod 5 = 4 Then %>
				</ul>
			</div>
			<% End If %>
<%
		Next
	End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->