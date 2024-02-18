<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'#######################################################
'	History	: 2015.11.02 허진원 생성
'	Description : 상품 상세 설명 이미지 JSON 출력
'#######################################################

'	Session.CodePage = 65001
'	Response.ContentType = "application/json"
'	response.charset = "utf-8"


'//헤더 출력
Response.ContentType = "text/html"

'//사용자 함수
function ImageExists(byval iimg)
	if (IsNull(iimg)) or (trim(iimg)="") or (Right(trim(iimg),1)="\") or (Right(trim(iimg),1)="/") then
		ImageExists = false
	else
		ImageExists = true
	end if
end function

Dim sType, sDeviceId
Dim sOS, sVerCd, sVerNm, sJsonVer, sAppKey, sMinUpVer, sCurrVer, sCurrVerNm, sUUID, snID

Dim sData : sData = Request("json")
Dim oJson
dim itemid



'// 전송결과 파징
'on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type

	sOS = requestCheckVar(oResult.OS,10)
	sVerCd = requestCheckVar(oResult.versioncode,20)
	''sVerNm = requestCheckVar(oResult.versionname,32)
	sJsonVer = requestCheckVar(oResult.version,10)

	sAppKey = getWishAppKey(sOS)
    
    ''sDeviceId = requestCheckVar(oResult.pushid,256)	
	''sUUID = requestCheckVar(oResult.uuid,40)
	''snID = requestCheckVar(oResult.nid,40)
	
	itemid = requestCheckVar(oResult.itemid,10)
set oResult = Nothing
	

	
	dim isContErrMsg : isContErrMsg=""
	
	Set oJson = jsObject()

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
	dim oItem, ItemContent, itemVideos
	

	set oItem = new CatePrdCls
	oItem.GetItemData itemid

	if oItem.FResultCount=0 then
	    isContErrMsg = "존재하지 않는 상품이거나 종료된 상품입니다."
	end if

	if oItem.Prd.Fisusing="N" then
	    isContErrMsg = "존재하지 않는 상품이거나 종료된 상품입니다."
	end if

    if (isContErrMsg<>"") then
        oJson("itemid") = cStr(itemid)
        Set oJson("conts") = jsArray()
        Set oJson("conts")(Null) = jsObject()
        oJson("conts")(Null)("txt") = isContErrMsg
        oJson("conts")(Null)("image") = "" '' errimage
        Set oJson("videos") = jsArray()
        Set oJson("videos")(Null) = jsObject()
        oJson("videos")(Null)("videosurl") = ""
        oJson.Flush
        set oItem = Nothing
		dbget.Close : response.End
    end if
    
	'// 추가 이미지
	dim oADD
	dim itemContImg, tmpExtImgArr, i
	'// 결과 JSON 생성
	Dim arrRst, strItemDesc, tmpDesc
	Dim vCaptureExist, isUseCaptureView, VCaptureImgArr
	
	'### 상품 VIEW Count Plus
	oItem.sbDetailCaptureViewCount itemid
	vCaptureExist = oItem.FCaptureExist

	'// 상품 상세설명 동영상 추가
	Set itemVideos = New catePrdCls '// 상품상세설명 동영상 추가
	itemVideos.fnGetItemVideos itemid, "video1"	 '// 상품상세설명 동영상 추가
	
	if (vCaptureExist="1") then 
        isUseCaptureView = true
        VCaptureImgArr = oItem.sbDetailCaptureViewImages(itemid)
    end if
    
    IF (isUseCaptureView) then  ''캡쳐리스트
        if isArray(VCaptureImgArr) then
            oJson("itemid") = cStr(itemid) 
    	    Set oJson("conts") = jsArray()
		    for i=0 to UBound(VCaptureImgArr,2)
		        if (ImageExists( VCaptureImgArr(2,i))) then
    		        Set oJson("conts")(Null) = jsObject()
                    oJson("conts")(Null)("txt") = ""
                    oJson("conts")(Null)("image") = VCaptureImgArr(2,i)
                end if
		    Next
    	    Set oJson("videos") = jsArray()
			Set oJson("videos")(Null) = jsObject()
			oJson("videos")(Null)("videosurl") = itemVideos.Prd.FvideoUrl
		else
		    oJson("itemid") = cStr(itemid) 
    	    Set oJson("conts") = jsArray()
    	    Set oJson("conts")(Null) = jsObject()
            oJson("conts")(Null)("txt") = "설명이 존재하지 않습니다."
            oJson("conts")(Null)("image") = "" '' errimage
    	    Set oJson("videos") = jsArray()
			Set oJson("videos")(Null) = jsObject()
			oJson("videos")(Null)("videosurl") = ""
		end if
        
        '//객체 정리
    	set oItem = Nothing
		Set itemVideos = Nothing
    ELSE
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
    
        strItemDesc = Trim(strItemDesc)
    	'상품설명이미지 분해
    	arrRst = split(itemContImg,vbCrLf)
    
    	if oItem.Prd.FItemContent<>"" then
    	    oJson("itemid") = cStr(itemid) 
    	    Set oJson("conts") = jsArray()
    	    if (ubound(arrRst)>-1) then
        	    for i=0 to ubound(arrRst)
                    Set oJson("conts")(Null) = jsObject()
                    if (i=0) then
                    oJson("conts")(Null)("txt") = strItemDesc
                    else
                    oJson("conts")(Null)("txt") = ""
                    end if
        			oJson("conts")(Null)("image") = Trim(cStr(arrRst(i)))
        		Next
    		else
    		    Set oJson("conts")(Null) = jsObject()
                oJson("conts")(Null)("txt") = strItemDesc
                oJson("conts")(Null)("image") = "" '' errimage
    	    end If
    	    Set oJson("videos") = jsArray()
			Set oJson("videos")(Null) = jsObject()
			oJson("videos")(Null)("videosurl") = itemVideos.Prd.FvideoUrl
    	else
    	    oJson("itemid") = cStr(itemid) 
    	    Set oJson("conts") = jsArray()
    	    Set oJson("conts")(Null) = jsObject()
            oJson("conts")(Null)("txt") = "설명이 존재하지 않습니다."
            oJson("conts")(Null)("image") = "" '' errimage
    	    Set oJson("videos") = jsArray()
			Set oJson("videos")(Null) = jsObject()
			oJson("videos")(Null)("videosurl") = ""
    	end if
    
    
    	
    
    	'//객체 정리
    	set oItem = Nothing
    	set oADD = Nothing
		Set itemVideos = Nothing
    End If
    
if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->