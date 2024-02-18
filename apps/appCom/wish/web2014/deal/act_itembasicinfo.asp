<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/classes/item/dealCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchCls.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<%
dim itemid, oItem, addEx, i
itemid = requestCheckVar(request("itemid"),9)

'======================================== 상품코드 정확성체크 및 상품관련내용 ====================================
If itemid="" Or itemid="0" Then
'	Call Alert_Return("상품번호가 없습니다.")
	response.End
ElseIf Not(isNumeric(itemid)) Then
'	Call Alert_Return("잘못된 상품번호입니다.")
	response.End
Else '정수형태로 변환
	itemid=CLng(getNumeric(itemid))
End If
If itemid=0 Then
'	Call Alert_Return("잘못된 상품번호입니다.")
	response.End
End If

Set oItem = New CatePrdCls
oItem.GetItemData itemid

Dim tempsource , tempsize
tempsource = oItem.Prd.FItemSource
tempsize = oItem.Prd.FItemSize

'// 상품설명 추가
Set addEx = New CatePrdCls
	addEx.getItemAddExplain itemid

%>
										<p>전자상거래 등에서의 상품정보 제공 고시에 따라 작성 되었습니다.</p>
										<ul class="essentialV16a">
											<%
												IF addEx.FResultCount > 0 THEN
													FOR i= 0 to addEx.FResultCount-1
														If addEx.FItem(i).FinfoCode = "35005" Then
															If tempsource <> "" then
															response.write "<li><strong>재질 :</strong> "&tempsource&" </li>"
															End If
															If tempsize <> "" then
															response.write "<li><strong>사이즈 :</strong> "&tempsize&" </li>"
															End If
														End If
											%>
												<li style="display:<%=chkiif(addEx.FItem(i).FInfoContent="" And addEx.FItem(i).FinfoCode ="02004" ,"none","")%>;"><strong><%=addEx.FItem(i).FInfoname%> :</strong> <%=addEx.FItem(i).FInfoContent%></li>
											<%
													Next
												End If
											%>
											<% if oItem.Prd.IsSafetyYN then %>
											<li><strong>안전인증대상 :</strong> <%=oItem.Prd.FsafetyNum%></li>
											<% End If %>
											<% if oItem.Prd.IsAboardBeasong then %>
											<li><strong>해외배송 기준 중량 :</strong> <% = formatNumber(oItem.Prd.FitemWeight,0) %> g (1차 포장을 포함한 중량)</li>
											<% End If %>
										</ul>
										<% if oItem.Prd.IsAboardBeasong then %>
										<p class="abroadDespV16a"><strong>해외배송 기준 중량 :</strong> <% = formatNumber(oItem.Prd.FitemWeight,0) %> g (1차 포장을 포함한 중량)</p>
										<% End If %>
<%
	Set oItem = Nothing
	Set addEx = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->