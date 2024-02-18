<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
	Dim sqlStr , i , ii
	Dim arrTenClass , arrTenClass2
	Dim idx , mainimage , maincopy , subcopy , startdate , enddate

	dim	itemid , itemname , designrecomment , basicimage , sellyn , sailyn , limityn , limitno , limitsold , sellcash , orgprice
	Dim totalprice , totalsaleper

	Dim cTime
	If CDate(now()) <= CDate(Date() & " 00:05:00") Then
		cTime = 60*1
	Else
		cTime = 60*5
	End If

	sqlStr = "SELECT TOP 3 * FROM "
	sqlStr = sqlStr & "db_sitemaster.[dbo].[tbl_mobile_class] AS b WITH(NOLOCK) "
	sqlStr = sqlStr & "WHERE startdate <= dateadd(s, -1,dateadd(dd,datediff(dd,0,getdate()+1),0)) and isusing =  1 "
	sqlStr = sqlStr & "ORDER BY startdate DESC "
	dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"TENCLASS1",sqlStr,cTime)
	If Not rsMem.EOF Then
		arrTenClass 	= rsMem.GetRows
	End if
	rsMem.close

	idx = requestCheckVar(Request("idx"),10)

	'// nav
	If isArray(arrTenClass) and not(isnull(arrTenClass)) Then
		Dim tenclassidx1 , tenclassidx2 , tenclassidx3
		Dim tenclassStartdate1 ,  tenclassStartdate2 , tenclassStartdate3

			tenclassidx1 = arrTenClass(0,0) '// 최근 idx
			tenclassidx2 = arrTenClass(0,1) '// 최근 바로전 idx
			tenclassidx3 = arrTenClass(0,2) '// 최근 바로전전 idx

			tenclassStartdate1	 = Left(arrTenClass(4,0),10) '// 최근 날짜
			tenclassStartdate2	 = Left(arrTenClass(4,1),10) '// 최근 바로전 날짜
			tenclassStartdate3	 = Left(arrTenClass(4,2),10) '// 최근 바로전전 날짜
		Dim navInt

		For navInt = 0 To ubound(arrTenClass,2)
			If idx = "" Then
				mainimage	 = staticImgUrl & "/mobile/tenclass" + db2Html(arrTenClass(1,0)) '// 메인이미지
				maincopy	 = arrTenClass(2,0) '// 메인카피
				subcopy		 = arrTenClass(3,0) '// 서브카피
			ElseIf arrTenClass(0,navInt) = CInt(idx) Then
				mainimage	 = staticImgUrl & "/mobile/tenclass" + db2Html(arrTenClass(1,navInt)) '// 메인이미지
				maincopy	 = arrTenClass(2,navInt) '// 메인카피
				subcopy		 = arrTenClass(3,navInt) '// 서브카피
			End If
		Next
	End If

	If idx = "" Then idx = tenclassidx1

	'// item
	sqlStr = "EXEC [db_sitemaster].[dbo].[usp_Ten_Mobile_TenClass] @idx=" & idx
	Dim rsMem2 : set rsMem2 = getDBCacheSQL(dbget,rsget,"TENCLASS2",sqlStr,cTime)
	If Not rsMem2.EOF Then
		arrTenClass2 	= rsMem2.GetRows
	End if
	rsMem2.close



%>
<script type="text/javascript">
$(function(){
	$(".navigator li.all").show()
	$(".navigator li.open").last().show().addClass("last");
	$(".navigator li.open").last().prev().show();
	$(".navigator li.open").last().prev().prev().show();
});
</script>
</head>
<body class="default-font body-main bg-grey">
	<div id="content" class="content">
		<div class="evtContV15">
			<div class="tenten-class">
				<ul id="navigator" class="navigator">
					<li class="all">
						<a href="" onclick="fnAPPpopupAutoUrl('/category/category_list.asp?disp=104119');return false;">ALL </a>
					</li>
					<li class="open <%=chkiif(CInt(idx)=CInt(tenclassidx3)," current","")%>">
						<a href="/apps/appcom/wish/web2014/tenclass/?idx=<%=tenclassidx3%>" target="_top"><%=formatdate(tenclassStartdate3,"00.00")%></a>
					</li>
					<li class="open <%=chkiif(CInt(idx)=CInt(tenclassidx2)," current","")%>">
						<a href="/apps/appcom/wish/web2014/tenclass/?idx=<%=tenclassidx2%>" target="_top"><%=formatdate(tenclassStartdate2,"00.00")%></a>
					</li>
					<li class="open <%=chkiif(CInt(idx)=CInt(tenclassidx1)," current","")%>">
						<a href="/apps/appcom/wish/web2014/tenclass/?idx=<%=tenclassidx1%>" target="_top"><%=formatdate(tenclassStartdate1,"00.00")%></a>
					</li>
				</ul>

				<h2><img src="<%=mainimage%>" alt="<%=maincopy%>" /></h2>
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/83172/m/tit_best.png" alt="텐바이텐 추천 클래스" /></h3>

				<% If isArray(arrTenClass2) and not(isnull(arrTenClass2)) Then %>
				<div class="class-list">
					<ul>
						<% FOR ii=0 to ubound(arrTenClass2,2) %>
						<%
							itemid			= arrTenClass2(0,ii)
							itemname		= arrTenClass2(1,ii)
							designrecomment	= arrTenClass2(2,ii)
							basicimage		= webImgUrl & "/image/basic/" & GetImageSubFolderByItemid(itemid) & "/" & db2Html(arrTenClass2(3,ii))
							sellyn			= arrTenClass2(4,ii)
							sailyn			= arrTenClass2(5,ii)
							limityn			= arrTenClass2(6,ii)
							limitno			= arrTenClass2(7,ii)
							limitsold		= arrTenClass2(8,ii)
							sellcash		= arrTenClass2(9,ii)
							orgprice		= arrTenClass2(10,ii)

							'// 할인
							If sailyn = "N" Then
								totalprice = formatNumber(orgPrice,0)
								totalsaleper = ""
							ElseIf sailyn = "Y" Then
								totalprice = formatNumber(sellCash,0)
								If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then
									totalsaleper = CLng((orgPrice-sellCash)/orgPrice*100) &"%"
								End If
							End If
						%>
						<li <%=chkiif(sellyn="N","class='soldout'","")%>>
							<a href="/category/category_itemPrd.asp?itemid=<%=itemid%>" onclick="TnGotoProduct('<%=itemid%>');return false;">
								<div class="thumbnail">
									<img src="<%=basicimage%>" alt="" />
									<div class="label">
										<span><i></i></span>
									</div>
									<% If limityn ="Y" Then %>
									<p class="limit">남은좌석<span><%=limitno-limitsold%></span></p>
									<% End If %>
								</div>
								<div class="desc">
									<p class="name"><%=itemname%></p><!-- for dev msg : 클래스 명 (19자이내) -->
									<p class="price"><%=FormatNumber(totalprice,0)%>원</p>
									<p class="txt"><%=designrecomment%></p>
								</div>
							</a>
						</li>
						<% Next %>
					</ul>
				</div>
				<% End If %>
				<!--<a href="" onclick="fnAPPpopupAutoUrl('/category/category_list.asp?disp=104119');return false;"><img src="http://fiximage.10x10.co.kr/m/2018/tentenclass/img_all_class.jpg" alt="전체 클래스 보러가기"></a>-->
				<ul class="btn-group">
					<li>
						<a href="" onclick="fnAPPpopupAutoUrl('/category/category_list.asp?disp=104119');return false;">
							<span>전체 클래스 보러가기<i></i></span>
							<img src="http://fiximage.10x10.co.kr/m/2018/tentenclass/bg_all_class.jpg" alt="">
						</a>
					</li>
					<li><a href="" onclick="fnAPPpopupExternalBrowser('https://docs.google.com/forms/d/1xOAyfs1XCR9JnrKtkyUtTH6W1SdLO6TYqMfuTSXGbuI'); return false;"><span>기업/단체 대관 문의<i></i></span></a></li>
					<li><a href="" onclick="fnAPPpopupExternalBrowser('https://docs.google.com/forms/d/158q_CTXEljRicSRoxNfqtY4ZVYZKE7qj3adlbFTxPLk/edit'); return false;"><span>강사 신청하기<i></i></span></a></li>
				</ul>
			</div>
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->