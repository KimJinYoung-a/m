<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description :  브랜드
' History : 2013.12.13 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #INCLUDE Virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
Dim makerid, vCateDepth, vDisp, oGrCat, i
	vDisp =  getNumeric(request("disp"))
	makerid = requestcheckvar(request("makerid"),100)

if makerid="" then
	dbget.close()	:	response.end
end if

if vDisp<>"" then
	vCateDepth = cStr(len(vDisp)\3)+1			'하위 뎁스
else
	vCateDepth = "1"
end if
if vCateDepth>3 then vCateDepth=3

'// 카테고리별 검색결과(1Depth)
set oGrCat = new SearchItemCls
	oGrCat.FRectSearchItemDiv = "y"		'기본 카테고리만 SearchItemDiv="y"
	oGrCat.FRectSearchCateDep = "T"		'하위카테고리 모두 검색 SearchCateDep= "T"
	oGrCat.FCurrPage = 1
	oGrCat.FPageSize = 100
	oGrCat.FScrollCount =10
	oGrCat.FListDiv = "brand"
	oGrCat.FRectMakerid = makerid
	oGrCat.FRectCateCode	= vDisp
	oGrCat.FGroupScope = vCateDepth	'카테고리 그룹 범위(depth)
	oGrCat.FLogsAccept = False '그룹형은 절대 !!! False
	oGrCat.getGroupbyCategoryList		'//카테고리 접수
%>
<!-- #include virtual="/lib/inc/head.asp" -->

<title>10x10: 카테고리 선택</title>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<div class="header">
			<h1>카테고리</h1>
			<p class="btnPopClose"><button class="pButton" onclick="goBack('/category/category_list.asp?disp=101'); return false;">닫기</button></p>
		</div>
		<div class="content" id="contentArea">
			<div class="categoryListup">
				<ul>
				<% If oGrCat.FResultCount>0 Then %>
					<% FOR i = 0 to oGrCat.FResultCount-1 %>
						<li>
							<a href="/street/street_brand.asp?makerid=<%=makerid%>&disp=<%= left(oGrCat.FItemList(i).FCateCode,vCateDepth*3) %>">
							<%= splitValue(oGrCat.FItemList(i).FCateName,"^^",(vCateDepth-1)) %> 
							<%' if oGrCat.FItemList(lp).fisnew ="o" then %><!--<span class="icoHot">HOT</span>--><%' End If %></a>
						</li>
					<% Next %>
				<% end if %>
				</ul>
			</div>
		</div>
	</div>
</div>
</body>
</html>

<%
set oGrCat = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->