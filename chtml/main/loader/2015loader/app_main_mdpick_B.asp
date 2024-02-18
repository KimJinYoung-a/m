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
Dim image , itemname , itemid , sellCash , orgPrice , sailYN , couponYn , couponvalue , LimitYn
Dim coupontype , newyn , limitno , limitdispyn , makerid , brandname
Dim CtrlTime : CtrlTime = hour(time)
Dim gaParam : gaParam = "&gaparam=todaymain_E"


	sqlStr = "Select top 30 s.subidx , s.listidx , s.itemid , s.isusing as itemusing , s.sortnum , isnull(s.itemname,i.itemname) as itemname , i.basicimage , datepart(hh, l.startdate) as starttime , datepart(hh, l.enddate) as endtime  , l.mdpicktitle"
	sqlStr = sqlStr & " , (case when DATEDIFF ( day , i.regdate  , getdate()) < 14 then 'Y' else 'N' end) as newyn "
	sqlStr = sqlStr & " , i.sellCash , i.orgPrice , i.sailyn , i.itemcouponYn , i.itemcouponvalue , i.limitYN , i.itemcoupontype , (i.limitno - i.limitsold) as limitno , i.limitdispyn , i.makerid , i.brandname"
	sqlStr = sqlStr & " From [db_sitemaster].[dbo].tbl_mobile_main_mdpick_item as s "
	sqlStr = sqlStr & "	left join db_item.dbo.tbl_item as i "
	sqlStr = sqlStr & "		on s.itemid=i.itemid "
	sqlStr = sqlStr & "			and i.itemid<>0 "
	sqlStr = sqlStr & "	left join [db_sitemaster].dbo.tbl_mobile_main_mdpick_list as l "
	sqlStr = sqlStr & "	on s.listidx = l.idx  "
	sqlStr = sqlStr & " Where s.isusing = 'Y' and ('" & Date() & "' between convert(varchar(10),l.startdate,120) and convert(varchar(10),l.startdate,120)) "
	sqlStr = sqlStr & " and ('"& CtrlTime &"' between datepart(hh, l.startdate) and datepart(hh, l.enddate)) and l.isusing = 'Y' and s.gubun = 0 "
	sqlStr = sqlStr & " order by s.listidx asc , s.sortnum asc  "

	'response.write sqlStr

	dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"MDPICK",sqlStr,60*10)
	If Not rsMem.EOF Then
		arrMdpick 	= rsMem.GetRows
	End if
	rsMem.close
	If isArray(arrMdpick) and not(isnull(arrMdpick)) Then
%>
	<section class="todayMdPickV15">
		<h2 class="tit01"><span>MD'S PICK</span></h2>
		<span class="goMore"><a href="" onclick="pickmore('n');return false;">MD'S PICK 상품 더보기</a></span>
		<div class="pdtListWrap" id="mdpicklist">
			<ul class="pdtList">
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
				<a href="" onclick="fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=itemid%><%=gaParam%>');return false;">
				<li class="<%=chkiif(LimitYn="Y" And limitno <= 10 And limitdispyn = "Y" ,"hurryUp","")%>">
					<div class="pPhoto"><p><span><em><%=chkiif(LimitYn="Y" And limitno <= 10 And limitdispyn = "Y" ,"HURRY UP!","")%></em></span></p><img src="<%= getThumbImgFromURL(image,400,400,"true","false") %>" alt="" /></div>
					<div class="pdtCont">
						<p class="pBrand"><%=UCase(brandname)%></p>
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
				</li>
				</a>
<%
		Next
%>
			</ul>
		</div>
		<!-- 		<p class="moreView hide"><span>더보기</span></p> -->
		<!--a href="" onclick="pickmore('m');return false;" class="moreView m01" id="pickmore" style="display:block;"><span>more</span></a><%'-- 하단에 상품 노출 --%>
		<a href="" onclick="pickmore('n');return false;" class="moreView m02" id="pickopen" style="display:none;"><span>more</span></a--><%'-- 엠디픽 팝업 오픈 --%>
	</section>
	<script>
		function pickmore(v){
			if (v =="m")
			{
				$("#pickmore").css("display","none");
				$("#pickopen").css("display","block");

				var rstStr = $.ajax({
						type: "POST",
						url: "/chtml/main/loader/2015loader/app_main_mdpick_B_ajax.asp",
						data: "mode=add",
						dataType: "text",
						async: false
					}).responseText;
					$("#mdpicklist").append(rstStr);

			}else{
				fnAPPpopupMdPick_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/mdpicklist/index.asp?gaparam=todaymain_E');
			}
		}
//
//		function pageup(){
//			window.$('html,body').animate({scrollTop:$("#mdpicklist").offset().top+700}, 0);
//		}
//
//		// md pick
//		$('.todayMdPickV15 .pdtList li:gt(7)').hide();
//		$('.moreView').click(function(){
//			$( ".moreView" ).toggleClass('hide');
//			$('.todayMdPickV15 .pdtList li:gt(7)').toggle();
//			//$('html, body').animate({ scrollTop: $('.todayMdPickV15 .pdtList li:nth-child(7)').offset().top}, 0);
//			//$('.todayMdPickV15 .pdtList li:nth-child(7)').scrollTop(300);
//			if ($(this).hasClass("hide")) {
//				$(this).children('span').text('더보기');
//				//setTimeout("pageup()",500);
//				pageup();
//			} else {
//				$(this).children('span').text('접기');
//			}
//		});
	</script>
<%
	End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->