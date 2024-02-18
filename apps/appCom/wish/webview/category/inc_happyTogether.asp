<%
'#######################################################
'	Description : 함께 구매한 상품
'	History	: 2014.01.08 한용민 생성
'           : 2014.03.11 허진원 - 스라이더 기능 추가, 카테고리 베스트 추가
'#######################################################
%>
<%
	dim oHTBCItem

	set oHTBCItem = New CAutoCategory
	oHTBCItem.FRectItemId = itemid
	oHTBCItem.FRectDisp = vDisp
	oHTBCItem.GetCateRightHappyTogetherNCateBestItemList

	if oHTBCItem.FResultCount>0 then
	'// 함께 구매한 상품
%>
<h4>함께 구매한 상품</h4>
<div class="together-list">
	<ul class="bxslider clear">
	<%	For lp = 0 To oHTBCItem.FResultCount - 1 %>
		<% if lp>8 then Exit For %>	
	    <li onClick="top.location.href='/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=<%=oHTBCItem.FItemList(lp).FItemId %>';">
	        <img src="<%=oHTBCItem.FItemList(lp).FImageList120 %>" alt="<%=oHTBCItem.FItemList(lp).FItemName%>">
	        <p class="product-name"><%=oHTBCItem.FItemList(lp).FItemName%></p>
	    </li>
    <%	next %>
	</ul>
</div>
<div class="clear diff-40"></div>
<%
	if oHTBCItem.FResultCount > 9 then
	'// 카테고리 베스트
%>
<h4 class="pull-left">카테고리 인기상품</h4>
<% 
'======================================== more ===============================================
dim strHistory, strLink, SQL, ii, jj, StrLogTrack
jj = (len(vDisp)/3)

'히스토리 기본
strHistory = ""
StrLogTrack = ""

If jj > 0 Then  '//jj

	'// 카테고리 이름 접수
	SQL = "SELECT ([db_item].[dbo].[getCateCodeFullDepthName]('" & vDisp & "'))"

	rsget.CursorLocation = adUseClient
	rsget.Open SQL, dbget, adOpenForwardOnly, adLockReadOnly  '' 수정.2015/08/12

	if NOT(rsget.EOF or rsget.BOF) then
		If Not(isNull(rsget(0))) Then
			for ii = 1 to jj
				StrLogTrack = StrLogTrack & Left(vDisp,(3*ii)) &"^^"
			next
		End If
		strHistory = rsget(0)
	end If
	rsget.Close

Dim moreUrl '//categorymove

If strHistory <> "" Then 
	
	If Split(strHistory,"^^")(0)<>"" Then
		moreUrl = "cd1="& Split(StrLogTrack,"^^")(0) & "&nm1="& Split(db2html(strHistory),"^^")(0)
	End If 

	If jj > 1 Then '2depth
		If Split(strHistory,"^^")(1)<>"" Then 
			moreUrl = "cd1="& Split(StrLogTrack,"^^")(0) & "&cd2="& Split(StrLogTrack,"^^")(1) & "&nm1="& Split(db2html(strHistory),"^^")(0) & "&nm2="& Split(db2html(strHistory),"^^")(1)
		End If 
	End If 

	If jj > 2 Then '3depth
		If Split(strHistory,"^^")(2)<>"" Then 
			moreUrl = "cd1="& Split(StrLogTrack,"^^")(0) & "&cd2="& Split(StrLogTrack,"^^")(1) & "&cd3="& Split(StrLogTrack,"^^")(2) & "&nm1="& Split(db2html(strHistory),"^^")(0) & "&nm2="& Split(db2html(strHistory),"^^")(1) & "&nm3="& Split(db2html(strHistory),"^^")(2)
		End If 
	End If 
End If 
'======================================== more ===============================================
	If flgDevice = "A" Then 
		If strHistory <> "" Then 
%>
<a href="#" onClick="opencategoryCustom('<%=moreUrl%>');" class="pull-right">더보기</a>
<% 
		End If 
	End If 
End If '//jj
%>
<div class="clear"></div>
<div class="together-list">
    <ul class="bxslider clear">
<%
		For lp = 9 To oHTBCItem.FResultCount - 1
			if lp>17 then Exit For
%>
	    <li onClick="top.location.href='/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=<%=oHTBCItem.FItemList(lp).FItemId %>';">
	        <img src="<%=oHTBCItem.FItemList(lp).FImageList120 %>" alt="<%=oHTBCItem.FItemList(lp).FItemName%>">
	        <p class="product-name"><%=oHTBCItem.FItemList(lp).FItemName%></p>
	    </li>
<%
		Next
%>
    </ul>
</div>
<div class="clear diff-40"></div>
<%	end if %>
<script>
    $(function(){
        $('.together-list .bxslider').bxSlider({
            slideWidth: 100,
            minSlides: 3,
            maxSlides: 3,
            moveSlides: 3,
            slideMargin: 0,
            controls: false,
            infiniteLoop: false
        });
    })
</script>
<%
	end if

	set oHTBCItem = nothing
%>