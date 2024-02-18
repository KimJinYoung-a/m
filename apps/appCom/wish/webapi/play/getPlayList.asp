<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64.asp"-->
<!-- #include virtual="/apps/appCom/wish/inc_constVar.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/webapi/play/getPlayList.asp
' Discription : 플레이 리스트
' Request : json > page_number , page_size , user_id , contents_cidx , type , adminid
' Response : response > 결과 : 
' History : 2018-07-02 이종화
'###############################################

'//헤더 출력
response.charset = "utf-8"
Response.ContentType = "application/json"

Dim sFDesc
Dim vPagenumber , vPageSize , vUserid , vCidx , vType , vAdminid
Dim sData : sData = Request("json")

''// Body Data 접수
'If Request.TotalBytes > 0 Then
'    Dim lngBytesCount
'        lngBytesCount = Request.TotalBytes
'    sData = BinaryToText(Request.BinaryRead(lngBytesCount),"UTF-8")
'End If



'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)

	vPagenumber = oResult.page_number
	vPageSize = oResult.page_size
	vUserid = requestCheckVar(oResult.user_id,32)
	vCidx = oResult.contents_cidx
	vType = oResult.view_type
	vAdminid = oResult.adminid
set oResult = Nothing

'// json객체 선언
Dim oJson
Dim contents_json , contents_object
Dim items_json , items_object

Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."

ElseIf vPagenumber = "" Then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "페이지 번호가 없습니다."

ElseIf vPageSize = "" Then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "페이지 크기가 없습니다."

ElseIf vCidx = "" Then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "컨텐츠 번호가 없습니다."

ElseIf vType = "" Then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "Type 설정이 없습니다."

Else

	Dim cTime , dummyName
	Dim arrList , vQuery , rsMem , openingList , arrListItem , sqlStr
	Dim recordcount : recordcount = 0
	Dim jcnt , icnt
	Dim vNickname , vOccupation
	Dim vTitleName , vContentsIdx , vContents , vMainImage

	'// contents
	Dim bedgeflag , pidx , cidx , contentsname , listimage , titlename , contents 
	Dim nickname , occupation , tags , myrecord , adminid , colorcode , uinumber , videourl , linkurl
	
	'// items
	Dim itemid , itemlistimage , mywish , evalcnt , favcount , itemname
	
	cTime = 60*5

	If vPagenumber = 1 Then '// 1페이지 일때만 필요함
		Select Case vType
			Case "masterpiece"
				dummyName = "PlayMasterPiece"
				
				'// 마스터피스 등록admin 닉네임 , 직업
				vQuery = "SELECT nickname , occupation FROM db_sitemaster.dbo.tbl_piece_nickname WITH(NOLOCK) where adminid = '"& vAdminid &"' "
				set rsMem = getDBCacheSQL(dbget, rsget, dummyName, vQuery, cTime)
				IF NOT (rsMem is Nothing) then 
					IF Not (rsMem.EOF OR rsMem.BOF) THEN
						vNickname	= rsMem("nickname")
						vOccupation = rsMem("occupation")
					END IF
					rsMem.close
				END IF
				set rsMem = Nothing

			Case "contents_home"
				dummyName = "PlayContents"

				'// 컨텐츠홈 컨텐츠 정보
				vQuery = "SELECT titlename , cidx , contents , mainimage FROM db_sitemaster.dbo.tbl_playcontents WITH(NOLOCK) WHERE cidx = '"& vCidx &"' "
				set rsMem = getDBCacheSQL(dbget, rsget, dummyName, vQuery, cTime)
				IF NOT (rsMem is Nothing) then 
					IF Not (rsMem.EOF OR rsMem.BOF) THEN
						vTitleName		= rsMem("titlename")
						vContentsIdx	= rsMem("cidx")
						vContents		= rsMem("contents")
						vMainImage		= rsMem("mainimage")
					END IF
					rsMem.close
				END IF
				set rsMem = Nothing
		End Select
	End If 

	'// 카운트
	vQuery = "EXEC db_sitemaster.dbo.usp_WWW_Play_PlayList_Count_Get '"& vUserid &"' , '0'  "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
	If Not Rsget.Eof then
		recordcount = rsget(0)
	end if
	rsget.close

	'// 공통 리스트 sp
	vQuery = "EXEC db_sitemaster.dbo.usp_WWW_Play_PlayList_Get "& vPagenumber &", "& vPageSize &", '"& vUserid &"', '"& vAdminid &"', '"& vCidx &"' ,'"& vType &"'  "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery,dbget,1
		IF Not (rsget.EOF OR rsget.BOF) THEN
			arrList = rsget.GetRows
		END If
	rsget.close

	'// 공통 리스트 - Contents 영역
	If IsArray(arrList) Then
		ReDim contents_object(ubound(arrList,2))
		For jcnt = 0 to ubound(arrList,2)

			bedgeflag		= arrList(0,jcnt)
			pidx			= arrList(1,jcnt)
			cidx			= arrList(2,jcnt)
			contentsname	= arrList(3,jcnt)
			listimage		= arrList(4,jcnt)
			titlename		= arrList(5,jcnt)
			contents		= arrList(6,jcnt)
			nickname		= arrList(7,jcnt)
			occupation		= arrList(8,jcnt)
			tags			= arrList(9,jcnt)
			myrecord		= arrList(10,jcnt)
			adminid			= arrList(11,jcnt)
			'colorcode		= arrList(12,jcnt)
			uinumber		= arrList(13,jcnt) '// ui 1 : 리스트형 , 2 : 상세형 , 4 : 동영상형 , 5 : 이벤트형
			videourl		= arrList(14,jcnt)
			linkurl			= arrList(15,jcnt)

			Set contents_json = jsObject()
				contents_json("ui_number")	= uinumber
				contents_json("bedge_flag")	= bedgeflag
				contents_json("contents_cidx")	= ""& cidx &""
				If uinumber = 5 Then '// 이벤트형일경우 썸네일 안태움
				contents_json("listimage")	= ""& b64encode(Trim(Replace(listimage,"//play","/play"))) &""
				Else
				contents_json("listimage")	= ""& b64encode(getThumbImgFromURL(Trim(Replace(listimage,"//play","/play")),750 , 750 ,"true","false")) &""
				End If 
				contents_json("title_name")	= titlename

			If uinumber = 1 Or uinumber = 2 Or uinumber = 4 Then 
				contents_json("contents_pidx")	= ""& pidx &""
			End If 

			If uinumber <> 5 Then 
				contents_json("contents_name")	= ""& contentsname &""
				contents_json("is_record")	= myrecord
			End If 

			If uinumber = 1 Then 
				contents_json("contents")	= chkiif(IsNull(contents) ,"", contents)
				contents_json("nickname")	= nickname
				contents_json("occupation")	= occupation
				contents_json("adminid")	= adminid

				'// 태그 정보
				Set contents_json("tags") = jsArray()
					If tags <> "" Then 
					contents_json("tags") = Split(tags,",")
					End If
			End If 

			'// 상세형 URL
			If uinumber = 2 Then
				contents_json("url") = ""& b64encode("http://m.10x10.co.kr/apps/appcom/wish/web2014/playwebview/detail.asp?pidx="& pidx ) &""
			End If 

			'// 비디오 상세
			If uinumber = 4 Then
				contents_json("url") = ""& Replace(videourl,"https://youtu.be/","") &""
			End If 

			'// 외부 이벤트 링크
			If uinumber = 5 Then
				contents_json("url") = ""& b64encode("http://m.10x10.co.kr/apps/appcom/wish/web2014/"&linkurl) &""
			End If 
			
'			If uinumber = 2 Then
'				contents_json("colorcode") = ""& colorcode &""
'			End If 


			If uinumber = 1 Or uinumber = 4 Then 
				'// 연관상품 sp
				sqlStr = "EXEC db_sitemaster.dbo.usp_WWW_Play_PlayList_Items_Get "& pidx &" , '"& vUserid &"' "
'				set rsMem = getDBCacheSQL(dbget, rsget, "PlayListItem", sqlStr, cTime)
'				IF Not (rsMem.EOF OR rsMem.BOF) THEN
'					arrListItem = rsMem.GetRows
'				END IF
'				rsMem.close

				rsget.CursorLocation = adUseClient
				rsget.Open sqlStr,dbget,1
					IF Not (rsget.EOF OR rsget.BOF) THEN
						arrListItem = rsget.GetRows
					END If
				rsget.close

				If isArray(arrListItem) Then
					ReDim items_object(ubound(arrListItem,2))
					For icnt = 0 to ubound(arrListItem,2)

						itemid			=	arrListItem(0,icnt)
						itemlistimage	=	arrListItem(1,icnt)
						mywish			=	arrListItem(2,icnt)
						evalcnt			=	arrListItem(3,icnt)
						favcount		=	arrListItem(4,icnt)
						itemname		=	arrListItem(5,icnt)

						itemlistimage	=   Trim(getThumbImgFromURL("http://webimage.10x10.co.kr/image/list/" & GetImageSubFolderByItemid(itemid) & "/" & itemlistimage ,100,100,"true","false"))

						Set items_json = jsObject()
							items_json("item_id")		= ""& itemid &""
							items_json("item_image")	= ""& b64encode(itemlistimage) &""
							items_json("my_wish")		= mywish
							items_json("review_count")	= evalcnt
							items_json("wish_count")	= favcount
							items_json("item_name")		= ""& itemname &""
							items_json("url")			= ""& b64encode("http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid="& itemid) &""

						Set items_object(icnt) = items_json
					Next 			
				End If 

				'// 연관상품
				Set contents_json("items") = jsArray()
					contents_json("items") = items_object
			End If 

			Set contents_object(jcnt) = contents_json
		Next 
	End If 
end If

	oJson("record_count")	= ""& recordcount &""

	If vType = "masterpiece" then
	oJson("nickname")		= ""& vNickname &""
	oJson("occupation")		= ""& vOccupation &""
	End If 

	If vType = "contents_home" then
	oJson("contents_name")	= ""& vTitleName &""
	oJson("contents_cidx")	= ""& vContentsIdx &""
	oJson("contents_desc")	= ""& vContents &""
	oJson("contents_image")	= ""& b64encode(Trim(Replace(Replace(vMainImage,"\","/"),"//play","/play"))) &""
	End If 

	If jcnt > 0 Then 
		oJson("contents")		= contents_object
	Else
		Set oJson("contents")		= jsArray()
	End If 

	'Json 출력(JSON)
	oJson.flush
Set oJson = Nothing

if ERR then Call OnErrNoti()
On Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->