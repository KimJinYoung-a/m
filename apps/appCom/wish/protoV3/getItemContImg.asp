<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
'#######################################################
'	History	: 2015.11.02 허진원 생성
'	Description : 상품 상세 설명 이미지 JSON 출력
'#######################################################

	Session.CodePage = 65001
	Response.ContentType = "application/json"
	response.charset = "utf-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<%
	dim itemid	: itemid = requestCheckVar(request("itemid"),9)
	dim isContErrMsg : isContErrMsg=""
	
	Dim rstJson
	Set rstJson = jsObject()

	if itemid="" or itemid="0" then
	    ''"존재하지 않는 상품"
		isContErrMsg = "존재하지 않는 상품이거나 종료된 상품입니다."
	elseif Not(isNumeric(itemid)) then
		''"잘못된 상품번호."
		isContErrMsg = "존재하지 않는 상품이거나 종료된 상품입니다."
	else
		'정수형태로 변환
		itemid=CLng(getNumeric(itemid))
	end if

	'/// 상품 상세 내용 접수
	dim oItem, ItemContent
	
	set oItem = new CatePrdCls
	oItem.GetItemData itemid

	if oItem.FResultCount=0 then
	    isContErrMsg = "존재하지 않는 상품이거나 종료된 상품입니다."
	end if

	if oItem.Prd.Fisusing="N" then
	    isContErrMsg = "존재하지 않는 상품이거나 종료된 상품입니다."
	end if

    if (isContErrMsg<>"") then
        rstJson("itemid") = cStr(itemid)
        Set rstJson("conts") = jsArray()
        rstJson("conts")("txt") = isContErrMsg
        rstJson("conts")("image") = "" '' errimage
        rstJson.Flush
		dbget.Close : response.End
    end if
    
	'// 추가 이미지
	dim oADD
	dim itemContImg, tmpExtImgArr, i
	'// 결과 JSON 생성
	Dim arrRst, strItemDesc, tmpDesc
	
	set oADD = new CatePrdCls
	oADD.getAddImage itemid

	'## 설명이미지 표시 (1순위: HTML내 이미지, 2순위: 추가이미지, 3순위: 업로드된 이미지)
	

	'HTML내 이미지
	tmpExtImgArr = RegExpArray("[^=']*\.(gif|jpg|bmp|png)", lCase(oItem.Prd.FItemContent))
	if isArray(tmpExtImgArr) then
		for i=0 to ubound(tmpExtImgArr)
			itemContImg = itemContImg & chkIIF(itemContImg<>"",vbCrLf,"") & Replace(tmpExtImgArr(i),"""","")
		next
	end if

	'추가이미지
	IF oAdd.FResultCount > 0 THEN
		FOR i= 0 to oAdd.FResultCount-1
			IF oAdd.FADD(i).FAddImageType=1 THEN
				itemContImg = itemContImg & chkIIF(itemContImg<>"",vbCrLf,"") & oAdd.FADD(i).FAddimage
			End IF
		NEXT
	end if

	'상품 설명 업로드 이미지
	if ImageExists(oItem.Prd.FImageMain) then
		itemContImg = itemContImg & chkIIF(itemContImg<>"",vbCrLf,"") & oItem.Prd.FImageMain
	end if
	if ImageExists(oItem.Prd.FImageMain2) then
		itemContImg = itemContImg & chkIIF(itemContImg<>"",vbCrLf,"") & oItem.Prd.FImageMain2
	end if
	if ImageExists(oItem.Prd.FImageMain3) then
		itemContImg = itemContImg & chkIIF(itemContImg<>"",vbCrLf,"") & oItem.Prd.FImageMain3
	end if


	

	'상품설명 Text 추출
	strItemDesc = trim(oItem.Prd.FItemContent)
	IF oItem.Prd.FUsingHTML="Y" THEN strItemDesc = replace(strItemDesc,vbCrLf,"")		'HTML사용일때 엔터 제거
	strItemDesc = replace(strItemDesc,vbTab,"")
	strItemDesc = replace(strItemDesc,"<br>",vbCrLf)
	strItemDesc = replace(strItemDesc,"<br/>",vbCrLf)
	strItemDesc = replace(strItemDesc,"<br />",vbCrLf)
	strItemDesc = replace(strItemDesc,"<BR>",vbCrLf)
	strItemDesc = replace(strItemDesc,"<BR/>",vbCrLf)
	strItemDesc = replace(strItemDesc,"<BR />",vbCrLf)
	strItemDesc = stripHTML(strItemDesc)

	'내용 빈칸 삭제
	tmpDesc = split(strItemDesc,vbCrLf)
	strItemDesc = ""
	
	for i=0 to ubound(tmpDesc)
		if trim(tmpDesc(i))<>"" then
			strItemDesc = chkIIF(strItemDesc<>"",vbCrLf,"") & tmpDesc(i)
		end if
	next

	'상품설명이미지 분해
	arrRst = split(itemContImg,vbCrLf)

	if oItem.Prd.FItemContent<>"" then
	    
	    rstJson("itemid") = cStr(itemid) 
	    Set rstJson("conts") = jsArray()
	    for i=0 to ubound(arrRst)
            Set rstJson("conts")(Null) = jsObject()
            if (i=0) then
            rstJson("conts")(Null)("txt") = strItemDesc
            else
            rstJson("conts")(Null)("txt") = ""
            end if
			rstJson("conts")(Null)("image") = cStr(arrRst(i))
		next
		
		rstJson.Flush
	
	end if


	'//사용자 함수
	function ImageExists(byval iimg)
		if (IsNull(iimg)) or (trim(iimg)="") or (Right(trim(iimg),1)="\") or (Right(trim(iimg),1)="/") then
			ImageExists = false
		else
			ImageExists = true
		end if
	end function

	'//객체 정리
	set oItem = Nothing
	set oADD = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->