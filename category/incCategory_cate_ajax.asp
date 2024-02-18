<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/MyCategoryCls.asp" -->
<%
Dim cdL, cdM, cdS, GRScope, vDepth, vDisp
vDisp = request("disp")
If vDisp = "" Then
	vDepth = 1
Else
	vDepth = (Len(vDisp)/3)+1
End If

Dim oGrCat,rowCnt, lp, vJScript, vCateName, vBackLink, vListCode, arrMyCaList
vJScript = ""

'// 카테고리별 검색결과
Set oGrCat = new MyCategoryCls
oGrCat.FUserID = getLoginUserID
oGrCat.FDepth = vDepth
if (oGrCat.FUserID<>"") then
arrMyCaList = oGrCat.fnMyCategoryListLeft
end if
Set oGrCat = Nothing


Set oGrCat = new MyCategoryCls
oGrCat.FDepth = vDepth
oGrCat.FDisp = vDisp
oGrCat.fnDisplayCategoryList
%>

<ul class="<%=CHKIIF(vDepth=1,"categoryList oneDepth","categoryList")%>">
<%
	If vDepth > 1 Then
		If vDepth = 2 Then
			vBackLink = "ShowCategory('','xxx');"
		Else
			vBackLink = "ShowCategory('" & Left(vDisp,3*(vDepth-2)) & "','','','','x');"
		End If
		Response.Write "<li class=""prevMove""><div onclick=""" & vBackLink & """><p class=""elmBg"">이전으로</p></div></li>" & vbCrLf
		Response.Write "<li class=""topDepth""><div onclick=""""><p class=""c333"">" & getDisplayCateNameDB(vDisp) & "</p><dfn class=""elmBg""></dfn></div>" & vbCrLf
		Response.Write "	<ul class=""twoDepth"">" & vbCrLf
	End If

	If oGrCat.FResultCount>0 Then
		'// 본문 시작
		rowCnt = 1
		
		FOR lp = 0 to oGrCat.FResultCount-1
			rowCnt = rowCnt + 1

			If oGrCat.FItemList(lp).FIsEnd = "0" Then
				If oGrCat.FItemList(lp).Fcatename <> "" Then
					vListCode = oGrCat.FItemList(lp).Fcatecode
					Response.Write "<li id=""liCate" & vListCode & """><div onclick=""ShowCategoryList('" & vListCode & "','','','','0');""><p>" & db2html(oGrCat.FItemList(lp).Fcatename) & "</p><em id=""mycatedepth" & vDepth & vListCode & """ class=""elmBg" & CHKIIF(fnCheckMyCategory(arrMyCaList,vListCode)," select","") & """ onclick=""SaveMyCate('" & vListCode & "','" & vDepth & "');""></em></div></li>"
				End IF
			Else
				If oGrCat.FItemList(lp).Fcatename <> "" Then
					vListCode = oGrCat.FItemList(lp).Fcatecode
					Response.Write "<li><div onclick=""ShowCategory('" & vListCode & "','"&oGrCat.FItemList(lp).FIsEnd&"');""><p>" & db2html(oGrCat.FItemList(lp).Fcatename) & "</p><em id=""mycatedepth" & vDepth & vListCode & """ class=""elmBg" & CHKIIF(fnCheckMyCategory(arrMyCaList,vListCode)," select","") & """ onclick=""SaveMyCate('" & vListCode & "','" & vDepth & "');""></em></div></li>"
				End IF
			End IF
			
			'<!-- for dev msg : 즐겨찾는 메뉴 선택시 em 태그에 select클래스명 추가 -->
			vJScript = vJScript & "$(""#mycatedepth" & vDepth & vListCode & """).click(function(e){ e.stopPropagation(); });" & vbCrLf
		Next
	
	End If
	
	If vDepth > 1 Then
		Response.Write "	</ul>" & vbCrLf
		Response.Write "</li>" & vbCrLf
	End If
%>
</ul>

<script type="text/javascript">
$(function(){
	<%=vJScript%>
});
</script>
			
<% set oGrCat = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->