<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/street/sp_ZZimBrandCls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/pageformlib.asp" -->
<%
dim  page, vDisp, pagesize, OrderType, chgtype
	page        = requestCheckVar(request("page"),9)
	vDisp       = requestCheckVar(request("disp"),3)
	pagesize    = requestCheckVar(request("pagesize"),9)
	OrderType   = requestCheckVar(request("OrderType"),2)

	if page="" then page=1
	if OrderType="" then OrderType="rg"

'// 정렬방법 통일로 인한 코드 변환
Select Case OrderType
	Case "rg": chgtype = "recent"		'등록순
	Case "nm": chgtype = "brandname"		'이름순
	Case Else: chgtype = "recent"		'기본값(등록순)
End Select

dim omyZzimbrand
	set omyZzimbrand = new CMyZZimBrand
	omyZzimbrand.FRectUserid = getEncLoginUserID
	omyZzimbrand.FCurrPage  = page
	omyZzimbrand.FPageSize  = 12
	omyZzimbrand.FRectDisp   = vDisp
	omyZzimbrand.FRectOrder = chgtype

	'// 로그인상태일경우에만 처리
	if getEncLoginUserID<>"" then
	    omyZzimbrand.GetMyZZimBrand
	end if

dim i, lp

%>
<% If (omyZzimbrand.FResultCount > 0) Then %>
<% for i=0 to omyZzimbrand.FResultCount -1 %>
	<li>
		<a href="" onclick="fnAPPpopupBrand('<%= omyZzimbrand.FItemList(i).FMakerid %>');return false;">
			<div class="box1">
				<div class="pdtInfo">
					<p class="pBrand"><%= omyZzimbrand.FItemList(i).Fsocname %></p>
					<p class="pName"><%= omyZzimbrand.FItemList(i).Fsocname_Kor %></p>
				</div>
				<div class="pic"><img src="<%= getThumbImgFromURL(omyZzimbrand.FItemList(i).fbasicimage,240,240,"true","false") %>" alt="<%= omyZzimbrand.FItemList(i).Fsocname %>" /></div>
				<button class="btnDel" onclick="DelFavBrand('<%= omyZzimbrand.FItemList(i).FMakerid %>');return false;">찜브랜드 삭제</button>
			</div>
		</a>
	</li>
<% Next %>
<% End If %>
<%
set omyZzimbrand = Nothing
%>