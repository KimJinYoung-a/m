<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV3/inc_constVar.asp"-->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/protoV3/searchKeyword2017.asp
' Discription : 인기검색어, 자동완성
' Request : json > type, seedstr
' Response : response > 결과, keywords[type, word, icon, url, code, title]
' History : 2017.08.18 강준구 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "application/json"

Dim sFDesc
Dim sType, sKeyword, sOS, snID, sDeviceId, sAppKey, sVerCd
Dim sCateCd, sCateNm
Dim sData : sData = Request.form("json")
Dim oJson

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = NullfillWith(requestCheckVar(oResult.type,20),"best")
	sKeyword = requestCheckVar(oResult.keyword,300)
	
    if Not ERR THEN
    	'Optional Parameter
		sDeviceId = requestCheckVar(oResult.pushid,256)
		sVerCd = requestCheckVar(oResult.versioncode,20)
		sOS = requestCheckVar(oResult.OS,10)

		'DeviceID 정보 업데이트
		sAppKey = getWishAppKey(sOS)
	    if ERR THEN Err.Clear ''회원id 프로토콜 없음
    END IF
set oResult = Nothing


'// json객체 선언
Set oJson = jsObject()

	'###############################################################################################
	Dim i, chkMode, oList, vTotalCount, oAuto
	If sType = "best" Then	'####### 인기검색어
		DIM oPpkDoc, arrPpk, arrTg, oBestKyWd, mykeywordloop
		
		Dim isRequireRefresh : isRequireRefresh = false
		if isDate(application("app_kwd_time")) then 
			isRequireRefresh= (DateDiff("n",application("app_kwd_time"),now())>3)  '' n분이 지났으면. 
		else
			isRequireRefresh= true   ''date가 아님 
		end if
		arrPpk = application("app_kwd_arrPpk")
		arrTg  = application("app_kwd_arrTg")

		isRequireRefresh = isRequireRefresh or (NOT isArray(arrPpk)) or (NOT isArray(arrTg))
	''response.write isRequireRefresh&"|"&isArray(arrPpk)&"|"&isArray(arrTg)&"|"&application("app_kwd_time")&"|"&DateDiff("n",application("app_kwd_time"),now())&"<BR>"
		if (isRequireRefresh) then
			SET oPpkDoc = New SearchItemCls
				oPpkDoc.FPageSize = 10
				oPpkDoc.getRealtimePopularKeyWordsAppOnly arrPpk,arrTg		'순위정보 포함
			SET oPpkDoc = NOTHING

			application("app_kwd_arrPpk") = arrPpk
			application("app_kwd_arrTg") = arrTg
			application("app_kwd_time") = now()
		end if

		If isArray(arrPpk)  Then
			If Ubound(arrPpk)>0 Then
				set oList = jsArray()
				
				For mykeywordloop=0 To UBOUND(arrPpk)
					Set oBestKyWd = jsObject()
					
					If trim(arrPpk(mykeywordloop))<>"" Then
						oBestKyWd("type") = CStr("")
						oBestKyWd("word") = CStr(arrPpk(mykeywordloop))
						oBestKyWd("icon") = CStr(arrTg(mykeywordloop))
						oBestKyWd("url") = CStr("")
						oBestKyWd("title") = CStr("")
					End If
					
					set oList(null) = oBestKyWd
					Set oBestKyWd = Nothing
				Next
				
				chkMode = "procOK"
			End If
		Else
			chkMode = "fail1"
		End If

	ElseIf sType = "autocomplete" Then	'####### 자동완성
		
		dim Docruzer, vErrMSG
		'독크루저 컨퍼넌트 선언
		SET Docruzer = Server.CreateObject("ATLKSearch.Client")
		
		if Docruzer.BeginSession()<0 then
			'에러시 메세지 표시
			chkMode = "errConn1"
			vErrMSG = "BeginSession: " & Docruzer.GetErrorMessage()
		else
			IF NOT DocSetOption(Docruzer) THEN
				chkMode = "errConn2"
				vErrMSG = "SetOption: " & Docruzer.GetErrorMessage()
			ELSE
		    	'실행
				Dim SvrAddr, SvrPort, ret, nFlag, cnv_str, max_count, kwd_count, kwd_list, rank, meta1, meta2
				Dim vSearchWord, vMeta1, vMeta2, FItemList, vIsKyExist
				Dim vKyCateM1, vKyCateM2, vKyShCtM1, vKyShCtM2, vKyBrdM1, vKyBrdM2, vKyKey, vKyShCtWd, vKyBrdWd

				vIsKyExist = "x"	'### 키워드 존재여부

				IF application("Svr_Info")	= "Dev" THEN
				    ''SvrAddr = "110.93.128.108"''2차실서버
					SvrAddr = "192.168.50.10"'DocSvrAddr(테섭)
					'SvrAddr = "110.93.128.106"
				ELSE
					''SvrAddr = "192.168.0.109"'DocSvrAddr(실섭)
					SvrAddr = "192.168.0.206"
					'SvrAddr = "110.93.128.106"
				END IF

				if (Application("G_ORGSCH_ADDR")="") then
					Application("G_ORGSCH_ADDR")=SvrAddr
				end if

				SvrAddr = Application("G_ORGSCH_ADDR")
				
				SvrPort = "6167"			'DocSvrPort

				nFlag = 2		'검색방법 (0:앞부터, 1: 뒤부터, 2:앞or뒤)
				cnv_str = ""	'한영자동변환 결과
				max_count = 100	'최대 검색 수

				'자동완성 검색
				ret = Docruzer.CompleteKeyword2( _
							SvrAddr & ":" & SvrPort _
							,kwd_count, kwd_list, rank, meta1, meta2, cnv_str, max_count, sKeyword, nFlag, 5)
					
				'에러 출력
				if(ret<0) then
					chkMode = "errConn3"
					vErrMSG = "Error: " & Docruzer.GetErrorMessage()
				else
					'-----프로세스 시작

					REDIM FItemList(kwd_count)
					for i=0 to kwd_count-1
						SET FItemList(i) = new SearchKeyword2017Items
						FItemList(i).Fkwd_list	= kwd_list(i)
						FItemList(i).Fmeta1		= meta1(i)
						FItemList(i).Fmeta2		= meta2(i)

						'### 카테고리 best
						If vKyCateM1 = "" AND meta2(i) = "ca$$best" Then
							vKyCateM1 = Split(meta1(i),"$$")(1)	'### mobile url
							vKyCateM2 = meta2(i)
						End If
						
						'### 바로가기
						If vKyShCtM1 = "" AND Split(meta2(i),"$$")(0) = "sc" Then
							vKyShCtWd = kwd_list(i)
							vKyShCtM1 = Split(meta1(i),"$$")(1)	'### mobile url
							vKyShCtM2 = meta2(i)
						End If
						
						'### 브랜드
						If vKyBrdM1 = "" AND Split(meta2(i),"$$")(0) = "br" Then
							vKyBrdWd = kwd_list(i)
							vKyBrdM1 = Split(meta1(i),"$$")(1)	'### mobile url
							vKyBrdM2 = meta2(i)
						End If
						
						'### 키워드 존재여부
						If Split(meta2(i),"$$")(0) = "ky" Then
							vIsKyExist = "o"
						End If
					next

		    		Call Docruzer.EndSession()
		    		
		    		For i=0 to kwd_count-1

						'### 카테고리 best 없을경우
						If vKyCateM1 = "" AND Split(meta2(i),"$$")(0) = "ca" Then
							vKyCateM1 = Split(meta1(i),"$$")(1)	'### mobile url
							vKyCateM2 = meta2(i)
							
							Exit For
						End If

		    		Next
		    		
		    		
		    		'### 카테고리, 바로가기, 브랜드, 이벤트, 키워드 순으로 변수담기.
		    		Dim vKyShCtTit, vKyShCtIcon, vKyShCtType, vKyShCtURL, vKyBrdType, vKyBrdCd, vKyBrdIcon, vKyBrdTit
		    		Dim vKyEvtTmp, vKyEvtCd, vKyEvtType, vKyEvtTit, vKyEvtWd, vKyCaTmp, vKyCaType, vKyCaTit, vKyCaCd, vKyCaIcon, vKyCaWd
		    		
		    		
		    		set oList = jsArray()
		    		
		    		'### 카테고리
		    		If vKyCateM1 <> "" Then
		    			vKyCaTmp = fnGetSearchDispList(sKeyword)
		    			
		    			If vKyCaTmp <> "" Then
			    			Set oAuto = jsObject()
			    			
				    		vKyCaType = "category"
				    		vKyCaCd = Split(vKyCaTmp,"$$")(0)
							vKyCaWd = Split(vKyCaTmp,"$$")(1)
							vKyCaIcon = Replace(vKyCateM2,"ca$$","")
							vKyCaTit = fnGetDispName(vKyCaCd)
							
							oAuto("type") = CStr(vKyCaType)
							oAuto("word") = CStr(vKyCaWd)
							oAuto("icon") = CStr(vKyCaIcon)
							oAuto("url") = ""
							oAuto("code") = CStr(vKyCaCd)
							oAuto("title") = CStr(vKyCaTit)
							oAuto("searchgubun") = CStr("searchcategory")
							oAuto("searchgubunkwd") = CStr(sKeyword)
							
							set oList(null) = oAuto
							Set oAuto = Nothing
						End If
					End If
		    		
		    		
		    		'### 바로가기
		    		If vKyShCtM1 <> "" Then
		    			Set oAuto = jsObject()
		    			
			    		vKyShCtType = "direct"
			    		vKyShCtTit = "바로가기"
			    		vKyShCtURL = vKyShCtM1	'## full url
			    		vKyShCtIcon = Replace(vKyShCtM2,"sc$$","")
						
						oAuto("type") = CStr(vKyShCtType)
						oAuto("word") = CStr(vKyShCtWd)
						oAuto("icon") = CStr(vKyShCtIcon)
						If InStr(vKyShCtURL,"?") > 0 Then
							vKyShCtURL = vKyShCtURL & "&pNtr=ql_" & server.URLEncode(sKeyword)
						Else
							vKyShCtURL = vKyShCtURL & "?pNtr=ql_" & server.URLEncode(sKeyword)
						End If
						oAuto("url") = b64encode(mDomain & "/apps/appCom/wish/web2014/" & fnMoAppDifferentURL(vKyShCtURL))
						oAuto("code") = ""
						oAuto("title") = CStr(vKyShCtTit)
						oAuto("searchgubun") = CStr("")
						
						set oList(null) = oAuto
						Set oAuto = Nothing
			    	End If
		    		
		    		
		    		'### 브랜드
		    		If vKyBrdM1 <> "" Then
		    			Set oAuto = jsObject()
		    			
			    		vKyBrdType = "brand"
			    		vKyBrdTit = "브랜드"
			    		vKyBrdCd = Split(vKyBrdM1,"=")(1)	'## url에서 코드만
			    		vKyBrdIcon = Replace(vKyBrdM2,"br$$","")
			    		
						oAuto("type") = CStr(vKyBrdType)
						oAuto("word") = CStr(vKyBrdWd)
						oAuto("icon") = CStr(vKyBrdIcon)
						oAuto("url") = ""
						oAuto("code") = vKyBrdCd
						oAuto("title") = CStr(vKyBrdTit)
						oAuto("searchgubun") = CStr("searchbrand")
						oAuto("searchgubunkwd") = CStr(sKeyword)
						
						set oList(null) = oAuto
						Set oAuto = Nothing
		    		End If
		    		
		    		
		    		'### 이벤트
		    		vKyEvtType	= "event"
		    		vKyEvtTmp 	= fnGetSearchEvent(sKeyword)
					If vKyEvtTmp <> "" Then
			    		vKyEvtTit	= Split(vKyEvtTmp,"$$")(0)	'## 기획전 이벤트 구분
			    		vKyEvtWd	= Split(vKyEvtTmp,"$$")(1)	'## 이벤트명
			    		vKyEvtCd	= Split(vKyEvtTmp,"$$")(2)	'## url에서 코드만
			    		
		    			Set oAuto = jsObject()
		    			
						oAuto("type") = CStr(vKyEvtType)
						oAuto("word") = CStr(vKyEvtWd)
						oAuto("icon") = "none"	'## 이벤트는 아이콘 없음
						oAuto("url") = b64encode(mDomain &"/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&vKyEvtCd&"&pNtr=qe_"&server.URLEncode(sKeyword))
						oAuto("code") = ""
						oAuto("title") = CStr(vKyEvtTit)
						oAuto("searchgubun") = CStr("")
						
						set oList(null) = oAuto
						Set oAuto = Nothing
		    		End If
		    		
		    		
		    		'### 키워드
		    		Dim vKyCount
		    		vKyCount = 0
		    		If vIsKyExist = "o" Then
			    		For i=0 to kwd_count-1
							
							'### 카테고리 best 없을경우
							If Split(meta2(i),"$$")(0) = "ky" Then
								Set oAuto = jsObject()
								
								oAuto("type") = CStr("keyword")
								oAuto("word") = CStr(kwd_list(i))
								oAuto("icon") = CStr(Replace(meta2(i),"ky$$",""))
								oAuto("url") = ""
								oAuto("code") = ""
								oAuto("title") = ""
								oAuto("searchgubun") = CStr("searchkeyword")
								oAuto("searchgubunkwd") = CStr(sKeyword)
								
								set oList(null) = oAuto
								Set oAuto = Nothing
								
								vKyCount = vKyCount + 1
								
								If vKyCount > 9 Then
									Exit For
								End If
							End If
							
	'		    			FItemList(i).Fkwd_list
	'		    			FItemList(i).Fmeta1
	'		    			FItemList(i).Fmeta2
			    		Next
			    	End If
		    		
		    		chkMode = "procOK"
				end if

	    	End if
		end if
		
	End If
	'###############################################################################################

	'// 결과데이터 생성
	Select Case chkMode
		Case "procOK"
			'// 이미 연동 되어있는 경우 성공시 (요청 type: login)
			oJson("response") = getErrMsg("1000",sFDesc)
			oJson("seedstr") = CStr(sKeyword)
			set oJson("keywords") = oList

		Case "fail1"
			'// 데이터 없음(오류)
			oJson("response") = "fail1"
			oJson("faildesc") = "검색어 리스트를 가져오는데 오류가 발생했습니다.[E01]"

	End Select

IF (Err) then
	Set oJson = jsObject()
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
End if

if ERR then Call OnErrNoti()		'// 오류 이메일로 발송
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing

Class SearchKeyword2017Items

	PUBLIC Fkwd_list
	public Fmeta1
	public Fmeta2

End Class

function DocSetOption(iDocruzer)
    dim ret 
    ret = iDocruzer.SetOption(iDocruzer.OPTION_REQUEST_CHARSET_UTF8,1)
    DocSetOption = (ret>=0)
end function

Function fnGetSearchDispList(Kywd)
	'실행
	Dim SvrAddr, SvrPort, ret, i, nFlag, cnv_str, max_count, kwd_count, kwd_list, rank, meta1, meta2
	Dim vDisp, vDispFullname, viewcount

	dim Docruzer, vErrMSG
	'독크루저 컨퍼넌트 선언
	SET Docruzer = Server.CreateObject("ATLKSearch.Client")
	
	if Docruzer.BeginSession()<0 then
		'에러시 메세지 표시
		chkMode = "errConn1"
		vErrMSG = "BeginSession: " & Docruzer.GetErrorMessage()
	else
		IF NOT DocSetOption(Docruzer) THEN
			chkMode = "errConn2"
			vErrMSG = "SetOption: " & Docruzer.GetErrorMessage()
		ELSE
			
			IF application("Svr_Info")	= "Dev" THEN
			    ''SvrAddr = "110.93.128.108"''2차실서버
				SvrAddr = "192.168.50.10"'DocSvrAddr(테섭)
				'SvrAddr = "110.93.128.106"
			ELSE
				''SvrAddr = "192.168.0.109"'DocSvrAddr(실섭)
				SvrAddr = "192.168.0.206"
				'SvrAddr = "110.93.128.106"
			END IF

			if (Application("G_ORGSCH_ADDR")="") then
				Application("G_ORGSCH_ADDR")=SvrAddr
			end if

			SvrAddr = Application("G_ORGSCH_ADDR")
			
			SvrPort = "6167"			'DocSvrPort

			nFlag = 2		'검색방법 (0:앞부터, 1: 뒤부터, 2:앞or뒤)
			cnv_str = ""	'한영자동변환 결과
			max_count = 200	'최대 검색 수

			'자동완성 검색
			ret = Docruzer.CompleteKeyword2( _
						SvrAddr & ":" & SvrPort _
						,kwd_count, kwd_list, rank, meta1, meta2, cnv_str, max_count, Kywd, nFlag, 6)
				
			'에러 출력
			if(ret<0) then

			else
				'-----프로세스 시작
				viewcount = 1	'### 최상위 한개만 가져옴. 자동완성은 sort없고, 자동완성에 보여줄 목록의 기준이 따로 없음.
				'kwd_count = viewcount
				
				for i=0 to kwd_count-1
					vDispFullname	= meta1(i) & "$$" & Replace(meta2(i),"^^"," > ")
					If i = 0 Then
						Exit For
					End IF
				next
				
				Call Docruzer.EndSession()
			end if
		END IF
	end if
	fnGetSearchDispList = vDispFullname
End function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->