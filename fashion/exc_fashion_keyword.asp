<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
Session.Codepage = 65001
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'#######################################################
' Discription : mobile_main_banner // cache DB경유
' History : 2016-04-27 이종화 생성
'#######################################################
Dim poscode , intI ,intJ 
Dim sqlStr , rsMem , arrList , arrListItem
Dim gaParam : gaParam = "&gaparam=fashion_keyword0" '//GA 체크 변수
Dim CtrlDate : CtrlDate = now()
Dim vQuery


Dim itemid , basicimage , itemname , sellcash , orgprice ,orgsupplycash , sailyn , sailsuplycash , couponyn , coupontype , couponvalue , newyn

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "FEKY_"&Cint(timer/60)
Else
	cTime = 60*5
	dummyName = "FEKY"
End If

'// keyword
sqlStr = "EXEC db_sitemaster.dbo.usp_WWW_FashionGnb_Keyword_Get"

set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

on Error Resume Next
If IsArray(arrList) Then
%>
<div class="fashion-keyword">
	<h2><small>Fashion Keyword</small>지금 뜨는 패션 키워드!</h2>
	<div class="kwd-list"></div>
	<div class="swiper-container">
		<div class="swiper-wrapper">
<%
	For intI = 0 To ubound(arrlist,2)
	
		'// 상품 아이템
		vQuery = "db_sitemaster.dbo.usp_WWW_FashionGnb_KeywordItem_Get @idx ="& arrList(0,intI)
		rsget.Open vQuery, dbget, 1
		IF Not rsget.Eof Then
			arrListItem = rsget.GetRows
		End If 
		rsget.close

%>
			<div class="swiper-slide">
				<div class="items type-column type-column-2">
					<ul>
						<%
							For intJ = 0 To ubound(arrListItem,2)
								itemid			=	arrListItem(0,intJ)
								basicimage		=	"http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(itemid) & "/" & arrListItem(1,intJ)
								itemname		=	arrListItem(2,intJ)
'								sellcash		=	arrListItem(3,intJ)
'								orgprice		=	arrListItem(4,intJ)
'								orgsupplycash	=	arrListItem(5,intJ)
'								sailyn			=	arrListItem(6,intJ)
'								sailsuplycash	=	arrListItem(7,intJ)
'								couponyn		=	arrListItem(8,intJ)
'								coupontype		=	arrListItem(9,intJ)
'								couponvalue		=	arrListItem(12,intJ)
'								newyn			=	arrListItem(14,intJ)
						%>
						<li>
							<% If isapp = "1" Then %>
							<a href="" onclick="fnAPPpopupProduct('<%=itemid%>');return false;">
							<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=<%=itemid%><%=gaParam%><%=intI+1%>_0<%=intj+1%>">
							<% End If %>
								<% If newyn = "Y" Then %>
								<span class="label label-triangle"><em>NEW</em></span>
								<% End If %>
								<div class="thumbnail"><img src="<%=getThumbImgFromURL(basicimage,"200","200","true","false") %>" alt="<%=itemname%>" /></div>
							</a>
						</li>
						<%
							Next 
						%>
					</ul>
				</div>
				<div class="btn-group">
					<% If isapp Then %>
					<a href="" onclick="fnAPPpopupCategory('<%=arrList(2,intI)%>');return false;" class="btn-plus"><span class="icon icon-plus icon-plus-black"></span> <%=Replace(arrList(1,intI),"베스트","")%> 더보기</a>
					<% Else %>
					<a href="/category/category_list.asp?disp=<%=arrList(2,intI)%><%=gaParam%><%=intI+1%>_00" class="btn-plus"><span class="icon icon-plus icon-plus-black"></span> <%=Replace(arrList(1,intI),"베스트","")%> 더보기</a>
					<% End If %>
				</div>
			</div>
<%
	Next
%>
		</div>
	</div>
</div>
<script>
/* keyword */
	var kwd = ['<%=arrList(1,0)%>', '<%=arrList(1,1)%>', '<%=arrList(1,2)%>']
	var kwdSwiper = new Swiper(".fashion-keyword .swiper-container", {
		loop:true,
		autoplay:3000,
		speed:300,
		effect:'fade',
		pagination:'.fashion-keyword .kwd-list',
		paginationClickable:true,
		paginationBulletRender: function (index, className) {
			return '<span class="' + className + '">' + (kwd[index]) + '</span>';
		}
	});
</script>
<%
End If
on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->