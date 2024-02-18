<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchCls.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim itemid, oItem, itEvtImg, itEvtImgMap, itEvtImgNm, sCatNm, lp, LoginUserid, cpid, addEx, viewnum, preitemid, nextitemid
dim oADD, i, ix, catecode, cTalk, vTalkCnt, makerid, itemVideos, IsTicketItem, vOrderBody, clsDiaryPrdCheck, eCode, sid
itemid = requestCheckVar(request("itemid"),9)
viewnum = requestCheckVar(request("viewnum"),2)
sid = requestCheckVar(request("sid"),2)
eCode = requestCheckVar(request("eCode"),9)
LoginUserid = getLoginUserid()

'======================================== 상품코드 정확성체크 및 상품관련내용 ====================================
if itemid="" or itemid="0" then
	Call Alert_Return("상품번호가 없습니다.")
	response.End
elseif Not(isNumeric(itemid)) then
	Call Alert_Return("잘못된 상품번호입니다.")
	response.End
else	'정수형태로 변환
	itemid=CLng(getNumeric(itemid))
end if

if itemid=0 then
	Call Alert_Return("잘못된 상품번호입니다.")
	response.End
end if

set oItem = new CatePrdCls
oItem.GetItemData itemid

if oItem.FResultCount=0 then
	Call Alert_Return("존재하지 않는 상품입니다.")
	response.End
end if
if oItem.Prd.Fisusing="N" then
	if GetLoginUserLevel()=7 then
		'STAFF는 종료상품도 표시
		Response.Write "<script>alert('판매가 종료되었거나 삭제된 상품입니다.');</script>"
	else
		'// 수정 2017-03-09 이종화 - 종료 상품일시 - page redirect
		'Call Alert_Return("판매가 종료되었거나 삭제된 상품입니다.")
		'response.End
		Response.redirect("/shopping/closedprd.asp?"&request.servervariables("QUERY_STRING"))
	end if
end if

itemid = oItem.Prd.FItemid
makerid = oItem.Prd.FMakerid
catecode = requestCheckVar(request("disp"),18)
If catecode <> "" Then
	If IsNumeric(catecode) = False Then
		catecode = ""
	End If
End If

if catecode="" or (len(catecode) mod 3)<>0 then catecode = oItem.Prd.FcateCode

'// 상품설명 추가
set addEx = new CatePrdCls
	addEx.getItemAddExplain itemid

'// 상품상세설명 동영상 추가
Set itemVideos = New catePrdCls
	itemVideos.fnGetItemVideos itemid, "video1"

'=============================== 추가 이미지 & 추가 이미지-메인 이미지 ==========================================
set oADD = new CatePrdCls
oADD.getAddImage itemid

function ImageExists(byval iimg)
	if (IsNull(iimg)) or (trim(iimg)="") or (Right(trim(iimg),1)="\") or (Right(trim(iimg),1)="/") then
		ImageExists = false
	else
		ImageExists = true
	end if
end function

Function getFirstAddimage()
	if ImageExists(oitem.Prd.FImageBasic) then
		getFirstAddimage= oitem.Prd.FImageBasic
	elseif ImageExists(oitem.Prd.FImageMask) then
		getFirstAddimage= oitem.Prd.FImageMask
	elseif (oAdd.FResultCount>0) then
		if ImageExists(oAdd.FADD(0).FAddimage) then
			getFirstAddimage= oAdd.FADD(0).FAddimage
		end if
	else
		getFirstAddimage= oitem.Prd.FImageMain
	end if
end Function

%>
							<div class="chosen-item">
								<div class="thumbnail"><img src="<%=getFirstAddimage()%>" alt="<%= replace(replace(oItem.Prd.FItemName,"<br>"," "),"<br />"," ") %>" /></div>
								<div class="item-detail">
									<p class="brand ellipsis"><%= UCase(oItem.Prd.FBrandName) %></p>
									<p class="name ellipsis-multi"><%= replace(replace(oItem.Prd.FItemName,"<br>"," "),"<br />"," ") %></p>
									<p class="price">
										<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<span class="orgin"><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></span>
										<% End If %>
										<span class="final-price"><%= FormatNumber(oItem.Prd.FSellCash,0) %></span>
									</p>
									<a href="javascript:fnSelectPickItem(<% = oitem.Prd.FItemid %>,'<%=getFirstAddimage()%>','<%=sid%>');" class=" btn btn-pick">선택하기</a>
									<% if isApp=1 then %>
									<a href="javascript:fnAPPpopupProduct('<% = oitem.Prd.FItemid %>');" class="btn btn-more">제품정보 보러가기</a>
									<% Else %>
									<a href="javascript:fnSelectItemDel(<% = oitem.Prd.FItemid %>);" class="btn btn-more">제품정보 보러가기</a>
									<% End If %>
								</div>
								<a href="javascript:fnClosePop();" class="close"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80412/m/img_close.png" alt="팝업닫기" /></a>
							</div>
<%
	Set oItem = Nothing
	Set oADD = Nothing
	Set itemVideos = Nothing
	Set addEx = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->