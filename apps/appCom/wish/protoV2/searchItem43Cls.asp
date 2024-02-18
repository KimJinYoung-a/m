<%
'''--------------------------------------------------------------------------------------
DIM G_KSCOLORCD : G_KSCOLORCD = Array("023","001","002","010","021","003","004","024","019","005","016","006","007","020","008","018","017","009","011","012","022","013","014","015","025","026","027","028","029","030","031")
DIM G_KSCOLORNM : G_KSCOLORNM = Array("와인","빨강","주황","갈색","카멜","노랑","베이지","아이보리","카키","초록","민트","연파랑","파랑","네이비","보라","연보라","베이비핑크","핑크","흰색","옅은회색","짙은회색","검정","은색","금색","체크","스트라이프","도트","플라워","드로잉","애니멀","기하학")

Dim G_KSSTYLECD : G_KSSTYLECD = Array("010","020","030","040","050","060","070","080","090")
Dim G_KSSTYLENM : G_KSSTYLENM = Array("클래식","큐티","댄디","모던","내추럴","오리엔탈","팝","로맨틱","빈티지")

DIM G_ORGSCH_ADDR
DIM G_1STSCH_ADDR
DIM G_2NDSCH_ADDR
DIM G_3RDSCH_ADDR
Dim G_4THSCH_ADDR

DIM G_SCH_TIME : G_SCH_TIME=formatdatetime(now(),4)

IF (application("Svr_Info") = "Dev") THEN
     G_1STSCH_ADDR = "192.168.50.10"
     G_2NDSCH_ADDR = "192.168.50.10"
     G_3RDSCH_ADDR = "192.168.50.10"
     G_4THSCH_ADDR = "192.168.50.10"
     G_ORGSCH_ADDR = "192.168.50.10"
ELSE
     G_1STSCH_ADDR = "192.168.0.210"        ''192.168.0.210  :: 검색페이지(search.asp)   '
     G_2NDSCH_ADDR = "192.168.0.207"        ''192.168.0.207  :: mobile
     G_3RDSCH_ADDR = "192.168.0.209"        ''192.168.0.209  :: GiftPlus , scn_dt_itemDispColor :: 확인.
     G_4THSCH_ADDR = "192.168.0.208"        ''192.168.0.208  :: 카테고리, 상품, 브랜드
     G_ORGSCH_ADDR = "192.168.0.206"		''192.168.0.206  :: 인덱싱 및 배포
END IF

function getTimeChkAddr(defaultAddr)
    getTimeChkAddr = defaultAddr

    IF (defaultAddr=G_4THSCH_ADDR) THEN
        IF (G_SCH_TIME>"06:10:00") and (G_SCH_TIME<"06:40:00") then
            getTimeChkAddr = G_2NDSCH_ADDR
        END IF
    ELSE
        IF (G_SCH_TIME>"06:40:00") and (G_SCH_TIME<"07:00:00") then
            getTimeChkAddr = G_4THSCH_ADDR
        END IF
    END IF
    
    ''기본 무조건 G_3RDSCH_ADDR 인덱싱 시간에 G_4THSCH_ADDR
'    IF (G_SCH_TIME>"06:40:00") and (G_SCH_TIME<"07:00:00") then
'        getTimeChkAddr = G_4THSCH_ADDR
'    ELSE
'        getTimeChkAddr = G_3RDSCH_ADDR
'    END IF
end function

''2015
'' StringList 검색 결과중  컬러검새 관련
function getDocArrMatchCodeVal(iRectArr,iResultCdArr,iResultValArr,byref retMatchCd,byref retMatchVal)
    dim findvalArr : findvalArr = split(trim(iRectArr),",")
    dim rsltCd : rsltCd = split(iResultCdArr," ")
    dim rsltVal : rsltVal = split(iResultValArr," ")
    dim findval, i,j
    
    for i=LBound(findvalArr) to Ubound(findvalArr)
        findval = findvalArr(i)
        for j=LBound(rsltCd) to Ubound(rsltCd)
            if (rsltCd(j)=findval) then
                retMatchCd  = rsltCd(j)
                retMatchVal = rsltVal(j)
                exit for
            end if
        next
    next
end function

function getCdPosVal(iCD,icdArr,iValArr)
    dim i,iPos
    getCdPosVal = ""
    if Not isArray(icdArr) then Exit function
    if Not isArray(iValArr) then Exit function
    if UBound(icdArr)<>UBound(iValArr) then Exit function
        
    iPos = -1
    for i=LBound(icdArr) to UBound(icdArr)
        if (iCD=icdArr(i)) then
            iPos = i
            Exit For
        end if
    next
    if iPos<0 then Exit function
    getCdPosVal=iValArr(iPos)
end function

function escapeQuery( istr )
	dim ret, c, i
	ret = ""
	For i=1 To Len(istr)
		c = Mid(istr,i,1)
		select case c
		case "\"
			ret = ret & "\\"
		case "'"
			ret = ret & "\'"
		case chr(34)
			ret = ret & "\" & chr(34)
		case "*"
			ret = ret & "\*"
		case else
			ret = ret & c
		end select
	Next
	escapeQuery = ret
end function

Class SearchItemCls
	Private SUB Class_initialize()
        ''기본 3차서버.------------------------
		SvrAddr = getTimeChkAddr(G_3RDSCH_ADDR)
		''--------------------------------------
		SvrPort = "6167"'DocSvrPort

		AuthCode = "" '인증값
		Logs = "" '로그값

		FResultCount = 0
		FTotalCount = 0
		FPageSize = 10
		StartNum = 0
		FRectColsSize =5
		FLogsAccept = false

	End SUB

	Private SUB Class_Terminate()
	End SUB

	dim FItemList
	dim FPageSize		'페이지 단위
	dim StartNum		'시작 번호
	dim FResultCount
	dim FTotalCount

	dim FRectSearchTxt		'검색어
	dim FRectSearchItemDiv	'카테고리 검색 범위 (y:기본 카테고리만, n:추가 카테고리 폼함)
	dim FRectSearchCateDep	'카테고리 검색 범위 (X:해당 카테고리만, T:하위 카테고리 포함)
	dim FRectPrevSearchTxt	'이전 검색어
	dim FRectExceptText		'제외어
	dim FRectSortMethod		'정렬방식 (ne:신상품, be:인기상품, lp:낮은가격, hp:높은가격, hs:할인률, br:상품후기, ws:위시수)
	dim FRectSearchFlag 	'검색범위 (sc:세일쿠폰, ea:사용기전체, ep:포토사용기, ne:신상품, fv:위시상품)

	dim FRectMakerid		'업체 아이디
	dim FRectCateCode		'카테고리코드
	dim FListDiv			'카테고리/검색 구분용
	dim FSellScope			'판매가능 상품검색 여부
	dim FGroupScope			'검색시 그룹핑 범위 (1:1depth, 2:2depth, 3:3depth)
	dim FdeliType			'배송방법 (FD:무료배송, TN:텐바이텐 배송, FT:무료+텐바이텐 배송, WD:해외배송)

	dim FcolorCode			'상품컬러칩
	dim FstyleCd			'상품스타일
	dim FattribCd			'상품속성

	dim FminPrice			'가격최소값
	dim FmaxPrice			'가격최대값
	dim FSalePercentHigh	'할인율 최대값
	dim FSalePercentLow		'할인율 최소값

	dim FCheckResearch 		'결과내 재검색 체크용
	dim FRectColsSize		'결과 리스트 열수
	dim FLogsAccept			'추가 로그 저장 여부

	dim FarrCate			'복수 카테고리
	dim FisTenOnly			'텐바이텐 전용상품
	dim FisLimit			'한정판매상품
	dim FisFreeBeasong

	dim FimgKind			'상품이미지 구분

	Private SvrAddr
	Private SvrPort
	Private AuthCode
	Private Logs
	Private Scn
	private strQuery
	Private Order

	Private SearchQuery
	Private SortQuery
    
    public function InitDocruzer(iDocruzer)
        InitDocruzer = FALSE
        IF ( iDocruzer.BeginSession() < 0 ) THEN
			EXIT function
		End If
        
        IF NOT DocSetOption(iDocruzer) THEN
			EXIT function
		End If
		InitDocruzer = TRUE
    End function

    public function DocSetOption(iDocruzer)
        dim ret 
        ret = iDocruzer.SetOption(iDocruzer.OPTION_REQUEST_CHARSET_UTF8,1)
        DocSetOption = (ret>=0)
    end function
    
	''/검색 조건 설정
	FUNCTION getSearchQuery(byref query)
		dim strQue, arrCCD, arrSCD, arrACD, lp

		'### 검색구분에 따른 기본값 확인 및 설정 ###
		Select Case FListDiv
			Case "search"
				'검색 페이지 결과
				IF (FRectSearchTxt="" or isNull(FRectSearchTxt)) Then EXIT FUNCTION
			Case "list"
				'카테고리 목록
				IF (FRectCateCode="" or isNull(FRectCateCode)) Then EXIT FUNCTION
			Case "colorlist"
				'컬러 검색 결과
				if (FcolorCode="" and FcolorCode="0") Then EXIT FUNCTION
			Case "brand"
				'브랜드 상품 목록
				IF (FRectMakerid="" or isNull(FRectMakerid)) Then EXIT FUNCTION
				FRectSearchItemDiv = "y"
			Case "salelist"
				'할인상품 목록
				FRectSearchFlag = "sc"
			Case "newlist"
				'신상품 목록
				FRectSearchFlag = "ne"
				IF FRectCateCode="" Then FRectSearchItemDiv = "y"
			Case "bestlist"
				'베스트상품 목록
				FRectSearchItemDiv = "y"
			Case "aboard"
				'해외판매 상품 목록
				FdeliType = "WD"
			Case Else
				EXIT FUNCTION
		End Select

		'### 검색조건 생성 ###

		'@ 검색어(키워드)
		IF FRectSearchTxt<>"" Then
		    FRectSearchTxt = escapeQuery(FRectSearchTxt)  ''2015 추가
			IF FRectExceptText<>"" Then
			    FRectExceptText = escapeQuery(FRectExceptText)  ''2015 추가
				strQue = getQrCon(strQue) & "(idx_itemname='" & FRectSearchTxt & " ! " & FRectExceptText & "' BOOLEAN) "	'제외어
			else
				strQue = getQrCon(strQue) & "idx_itemname='" & FRectSearchTxt & "'  allword "	'키워드검색(동의어 포함) synonym
			End if
		END IF

		'@ 카테고리
		IF trim(FRectCateCode)<>"" Then
			if FRectSearchCateDep="X" then
				strQue = strQue & getQrCon(strQue) & "idx_catecode='" & FRectCateCode & "'"
			else
				IF FRectSearchItemDiv="y" Then ''기본카테고리
			        strQue = strQue & getQrCon(strQue) & "idx_catecode like '" & FRectCateCode & "*'"
			    else                           ''추가카테검색
			        strQue = strQue & getQrCon(strQue) & "idx_catecodeExt like '" & FRectCateCode & "*'"
			    end if
			end if
		END IF

		'@ 복수 카테고리
		IF FarrCate<>"" THEN
			dim arrCt, lpCt
			if right(FarrCate,1)="," then FarrCate=left(FarrCate,len(FarrCate)-1)
			arrCt = split(FarrCate,",")
			strQue = strQue & getQrCon(strQue) & "("
			for lpCt=0 to ubound(arrCt)
				if FRectSearchCateDep="X" then
					strQue = strQue & " idx_catecode='" & RequestCheckVar(LCase(trim(arrCt(lpCt))),18) & "' "
				else
					strQue = strQue & " idx_catecode like '" & RequestCheckVar(LCase(trim(arrCt(lpCt))),18) & "*' "
				end if
				if lpCt<ubound(arrCt) then strQue = strQue & " or "
			next
			strQue = strQue & " )"
		END IF

		'@ 검색범위
		IF FRectSearchFlag<>"" THEN
			Select Case FRectSearchFlag
				Case "sc"	'세일쿠폰
					strQue= strQue & getQrCon(strQue) & "(idx_saleyn='Y' or idx_itemcouponyn='Y') "
				Case "ea"	'전체사용기
					strQue= strQue & getQrCon(strQue) & "(idx_evalcnt>0) "
				Case "ep"	'포토사용기
					strQue= strQue & getQrCon(strQue) & "(idx_evalcntPhoto>0) "
				Case "ne"	'신상품
					strQue = strQue & getQrCon(strQue) & "idx_newyn='Y' "
				Case "fv"	'위시상품
					strQue = strQue & getQrCon(strQue) & "(idx_favcount>0) "
			End Select
		END IF

		'@ 브랜드
		IF FRectMakerid<>"" THEN
			dim arrMkr, lpMkr
			if right(FRectMakerid,1)="," then FRectMakerid=left(FRectMakerid,len(FRectMakerid)-1)
			arrMkr = split(FRectMakerid,",")
			strQue = strQue & getQrCon(strQue) & "("
			for lpMkr=0 to ubound(arrMkr)
				strQue = strQue & " idx_makerid='" & RequestCheckVar(LCase(trim(arrMkr(lpMkr))),32) & "'  "
				if lpMkr<ubound(arrMkr) then strQue = strQue & " or "
			next
			strQue = strQue & " )"
		END IF

		'@ 가격범위
		if FminPrice<>"" then
			strQue = strQue & getQrCon(strQue) & "idx_sellcash>='" & FminPrice & "'"
		end if
		if FmaxPrice<>"" then
			strQue = strQue & getQrCon(strQue) & "idx_sellcash<='" & FmaxPrice & "'"
		end if

		'@ 할인범위
		IF FSalePercentHigh<>"" Then
			strQue = strQue & getQrCon(strQue) & "idx_salepercent >=" & (1-FSalePercentHigh)*100 & " "
		End IF
		IF FSalePercentLow<>"" Then
			strQue = strQue & getQrCon(strQue) & "idx_salepercent <" & (1-FSalePercentLow)*100 & " "
		End IF

		'@ 배송방법
		Select Case FdeliType
			Case "FD"	'무료배송
				strQue = strQue & getQrCon(strQue) & "isFreeBeasong='Y'"
			Case "TN"	'텐바이텐배송
				strQue = strQue & getQrCon(strQue) & "(deliverytype='1' or deliverytype='4')"
			Case "FT"	'무료 + 텐바이텐배송
				strQue = strQue & getQrCon(strQue) & "(deliverytype='1' or deliverytype='4') and isFreeBeasong='Y'"
			Case "WD"	'해외배송
				strQue = strQue & getQrCon(strQue) & "isAboard='Y'"
		end Select

		'@ 텐바이텐 전용상품
		IF FisTenOnly="only" Then
			strQue = strQue & getQrCon(strQue) & "idx_tenOnlyYn='Y' "
		End IF

		'@ 한정상품
		IF FisLimit="limit" Then
			strQue = strQue & getQrCon(strQue) & "idx_limityn='Y' "
		End IF

		'@ 무료배송상품
		IF FisFreeBeasong="free" Then
			strQue = strQue & getQrCon(strQue) & "idx_isFreeBeasong='Y' "
		End If

		'@ 컬러검색
		if Not(FcolorCode="" or isNull(FcolorCode) or FcolorCode="0") then
			arrCCD = split(FcolorCode,",")
			if ubound(arrCCD)>0 then
				'다중 컬러코드 적용
				strQue = strQue & getQrCon(strQue) & "(idx_colorCd='"&replace(FcolorCode,","," ")&"' anystring)"  ''2015 변경
'				strQue = strQue & getQrCon(strQue) & "("
'				for lp=0 to ubound(arrCCD)
'					if getNumeric(arrCCD(lp))<>"" then
'						if lp>0 then strQue = strQue & " or "
'						strQue = strQue & "idx_colorCd='" & getNumeric(arrCCD(lp)) & "'"
'					end if
'				next
'				strQue = strQue & ")"
			else
				'단일 컬러코드 적용
				strQue = strQue & getQrCon(strQue) & "idx_colorCd='" & getNumeric(arrCCD(0)) & "'"
			end if
		end if

		'@ 스타일 조건 쿼리
		if Not(FstyleCd="" or isNull(FstyleCd)) then
			arrSCD = split(FstyleCd,",")
			if ubound(arrSCD)>0 then
				'다중 스타일코드 적용
				strQue = strQue & getQrCon(strQue) & "(idx_styleCd='"&replace(FstyleCd,","," ")&"' anystring)"  ''2015 변경
'				strQue = strQue & getQrCon(strQue) & "("
'				for lp=0 to ubound(arrSCD)
'					if getNumeric(arrSCD(lp))<>"" then
'						if lp>0 then strQue = strQue & " or "
'						strQue = strQue & "idx_styleCd='" & getNumeric(arrSCD(lp)) & "'"
'					end if
'				next
'				strQue = strQue & ")"
			else
				'단일 스타일코드 적용
				strQue = strQue & getQrCon(strQue) & "idx_styleCd='" & getNumeric(arrSCD(0)) & "'"
			end if
		end if

		'@ 상품속성 조건 쿼리
		if Not(FattribCd="" or isNull(FattribCd)) then
			arrACD = split(FattribCd,",")
			if ubound(arrACD)>0 then
				'다중 속성코드 적용
				strQue = strQue & getQrCon(strQue) & "(idx_attribCd='"&replace(FattribCd,","," ")&"' anystring)"  ''2015 변경
'				strQue = strQue & getQrCon(strQue) & "("
'				for lp=0 to ubound(arrACD)
'					if getNumeric(arrACD(lp))<>"" then
'						if lp>0 then strQue = strQue & " or "
'						strQue = strQue & "idx_attribCd='" & getNumeric(arrACD(lp)) & "'"
'					end if
'				next
'				strQue = strQue & ")"
			else
				'단일 속성코드 적용
				strQue = strQue & getQrCon(strQue) & "idx_attribCd='" & getNumeric(arrACD(0)) & "'"
			end if
		end if

		'@ 상품 판매 범위
		IF FSellScope="Y" Then
			strQue = strQue & getQrCon(strQue) & "idx_sellyn='Y' "
		ELSE
			strQue = strQue & getQrCon(strQue) & "(idx_sellyn='Y' or idx_sellyn='S') "
		End IF
        
        ''2015 추가 string list group by 사용시 해당필드에 널값이 있는경우 빈값 대신 000 넣음.
        IF scn="scn_dt_itemDispStyleGroup" then
            strQue = strQue & getQrCon(strQue) & "idx_styleCd!='000' "
        ELSEIF  scn="scn_dt_itemDispAttribGroup" then
            strQue = strQue & getQrCon(strQue) & "idx_attribgrp!='000' "
        ELSEIF  scn="scn_dt_itemDispColorGroup" then
            strQue = strQue & getQrCon(strQue) & "idx_colorgrp!='000' "
        ELSEIF  scn="scn_dt_itemDispCateGroup" then
            if (FGroupScope="2") then
                strQue = strQue & getQrCon(strQue) & "idx_cd2grp!='000' "
            elseif (FGroupScope="3") then
                strQue = strQue & getQrCon(strQue) & "idx_cd3grp!='000' "
            end if
        END IF
        
		query = strQue
	End FUNCTION

	Sub getSortQuery(byref query)
		dim strQue

		'// 중복 상품 제거(중복 등록 카테고리일경우)
		'IF (FRectCateCode<>"" and FRectSearchItemDiv<>"y") Then '' 추가 카테고리 검색시
    	'	strQue = " GROUP BY itemid"
    	'END IF

		'// 정렬
		Select Case FRectSortMethod
			Case "new", "ne"	'신상품
				strQue = strQue & " ORDER BY itemid desc"
			Case "best", "be"	'인기상품
				strQue = strQue & " ORDER BY itemscore desc, itemid desc"
			Case "sale", "hs"	'핫세일 (할인율이 높은순)
				strQue = strQue & " ORDER BY salepercent desc, saleprice desc, itemid desc"
			Case "highprice", "hp"	'높은가격
				strQue = strQue & " ORDER BY sellcash desc, itemid desc"
			Case "lowprice", "lp"	'낮은가격
				strQue = strQue & " ORDER BY sellcash, itemid desc"
			Case "br","review"	'베스트후기순
				strQue = strQue & " ORDER BY evalcnt desc, itemid desc"
			Case "ws"	'위시순
				strQue = strQue & " ORDER BY favcount desc,itemid desc"
			Case Else
				strQue = strQue & " ORDER BY itemid desc"
		end Select

		query = strQue
	End Sub

	Function getQrCon(query)
		if Not(query="" or isNull(query)) then
			getQrCon = " and "
		end if
	End Function

	'// 상품 이미지 폴더 반환(컬러코드 유무에 따라 일반/컬러칩 구분)
	Function getItemImageUrl()
		IF application("Svr_Info")	= "Dev" THEN
			if FcolorCode="" or FcolorCode="0" then
				getItemImageUrl = "http://webimage.10x10.co.kr/image"
			else
				getItemImageUrl = "http://webimage.10x10.co.kr/color"
			end if
		Else
			if FcolorCode="" or FcolorCode="0" then
				getItemImageUrl = "http://webimage.10x10.co.kr/image"
			else
				getItemImageUrl = "http://webimage.10x10.co.kr/color"
			end if
		End If
	end function

	'####### 상품 검색 - 검색 엔진 ######
	PUBLIC Function getSearchListJson()

		DIM Scn
		DIM Docruzer,ret

		DIM Logs ,iRows
		DIM arrData,arrSize, retMatchCd, retMatchVal, iImageBasic
		Dim objRst
		dim tmpId, tmpCnt

		'json Array선언
		Set objRst = jsArray()

		'// 검색 결과 출력 시나리오명
		if FcolorCode="" or FcolorCode="0" then
			Scn= "scn_dt_itemDisp"		'일반 상품 검색
		else
			'Scn= "scn_dt_itemDispColor"		'상품 컬러별 검색(전시카테고리)
			Scn= "scn_dt_itemDisp"		    '일반 상품 검색 통일 2015
		end if

		CALL getSearchQuery(SearchQuery)	'// 검색 쿼리생성
		CALL getSortQuery(SortQuery)		'// 정렬 쿼리 생성
		''Response.Write SearchQuery &"<Br>"
		IF SearchQuery="" THEN
			set getSearchListJson = objRst
			Set objRst = Nothing
			EXIT Function
		END IF

		IF (FLogsAccept) and (FRectSearchTxt<>"") and (StartNum="0") THEN ''일단 1페이지만
            Logs = ("상품+^" & FRectSearchTxt & "]##" & FRectSearchTxt & "||" & FRectPrevSearchTxt ) 	'// 로그값
            if (now()>"2015-03-04") then
                Dim iLOG_SITE : iLOG_SITE = "APP"
                Dim iLOG_CATE : iLOG_CATE = "RECT" 
                Dim iLOG_USER : iLOG_USER = GetUserStrlarge(GetLoginUserLevel) '' 회원등급을 사용
                Dim iLOG_SEX  : iLOG_SEX  = "" '' 0비로그인,1남성,2여성
                Dim iLOG_AGE  : iLOG_AGE  = "" '' 0비로그인,1:10대,2:20대,3:30대,4:40대,5:50대
                Dim iLOG_STYPE : iLOG_STYPE = "" '' 서비스 사용안함 X
                Dim iLOG_FIRST : iLOG_FIRST = "" '' 첫검색/재검색 사용안함 X  FCheckResearch
                
                Dim iCurrPage : iCurrPage = "1" ''CLNG(StartNum/FPageSize)+1 ''APP만 
                
                Logs = iLOG_SITE&"@"                ''[ @
                Logs = Logs&iLOG_CATE&"+"           ''@ +
                Logs = Logs&iLOG_USER&"$"           ''+ $
                Logs = Logs&iLOG_SEX&"|"            ''$ |
                Logs = Logs&iLOG_AGE&"|"            ''| | 
                Logs = Logs&iLOG_STYPE&"|"          ''| | 
                Logs = Logs&iLOG_FIRST&"|"          ''| | 
                Logs = Logs&iCurrPage&"|"           ''| | 
                Logs = Logs&FRectSortMethod&"^"     ''| ^ 
                Logs = Logs&FRectPrevSearchTxt&"##" ''^ ##
                Logs = Logs&FRectSearchTxt          ''## ]
            end if
		END IF

		'독크루져 커넥션 선언
		SET Docruzer = Server.CreateObject("ATLKSearch.Client")
        
        IF NOT InitDocruzer(Docruzer) THEN
            set getSearchListJson = objRst
			Set objRst = Nothing
		    SET Docruzer = Nothing
			EXIT Function
		END IF
		
		ret = Docruzer.SubmitQuery(SvrAddr, SvrPort, _
						AuthCode, Logs, Scn, _
						SearchQuery,SortQuery, _
						FRectSearchTxt,StartNum, FPageSize, _
						Docruzer.LC_KOREAN, Docruzer.CS_UTF8)

		IF( ret < 0 ) THEN
			dbget.execute "EXECUTE db_log.dbo.sp_Ten_DocLog @ErrMsg ='"& html2db(SearchQuery) & "[" & html2db(Docruzer.GetErrorMessage()) &"]'"

			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING

			IF FListDiv<>"search" THEN
				'// 3차 서버 에서시 4차 서버에서 구동(4차도 에러면 Skip)
				if (SvrAddr = G_3RDSCH_ADDR) then
					SvrAddr = G_4THSCH_ADDR  ''"192.168.0.108"
					if (G_3RDSCH_ADDR<>G_4THSCH_ADDR) then
					    'call getSearchList()
				    end if
				end if
			END IF

			set getSearchListJson = objRst
			Set objRst = Nothing
			EXIT Function
		END IF

		Call Docruzer.GetResult_TotalCount(FTotalCount) '검색결과 총 수
		Call Docruzer.GetResult_RowSize(FResultcount) '검색 결과 수
		'Response.write "검색결과수 : " & FTotalCount & "<br>"
		IF( FResultCount <= 0 ) THEN
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING

			set getSearchListJson = objRst
			Set objRst = Nothing
			EXIT Function
		END IF

		REDIM FItemList(FResultCount)

		FOR iRows=0 to FResultCount -1

			ret = Docruzer.GetResult_Row( arrData, arrSize, iRows )
			IF( ret < 0 ) THEN
				EXIT FOR
			END IF

			SET FItemList(iRows) = NEW CWishItem

				FItemList(iRows).Fitemid		= arrData(4)
				FItemList(iRows).Fmakerid		= arrData(9)
				FItemList(iRows).Fbrandname		= db2html(arrData(10))
				FItemList(iRows).Fitemname		= db2html(arrData(5))
				FItemList(iRows).ForgPrice		= arrData(8)
				FItemList(iRows).FsellPrice		= arrData(7)

'				if IsUserLoginOK then
'					Call getMyFavItemList(GetLoginUserID,arrData(4),tmpId,tmpCnt)
'					if Not(tmpId="" or isNull(tmpId)) then
'						FItemList(iRows).FfavCount		= cStr(tmpCnt)
'						FItemList(iRows).FisMyWish		= "1"		'내 위시상품
'					else
'						FItemList(iRows).FfavCount		= arrData(28)
'						FItemList(iRows).FisMyWish		= "0"		'위시상품 아님
'					end if
'				else
					FItemList(iRows).FfavCount		= arrData(28)
					FItemList(iRows).FisMyWish		= "0"
'				end if

                if (FcolorCode="" or FcolorCode="0") then
    				Select Case FimgKind
    					Case "list"
    						''FItemList(iRows).FimageUrl 	= getItemImageUrl & "/list/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(13))			'100px이미지
    						''FItemList(iRows).FimageUrl	= "http://thumbnail.10x10.co.kr/webimage/image/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(11))	&"?cmd=thumb&width=100&height=100"
    						FItemList(iRows).FimageUrl 	= getThumbImgFromURL(getItemImageUrl & "/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(11)),100,100,"true","false")
    						
    					Case "icon1" ''브랜드 스트리트 검색(가나다)
    						''FItemList(iRows).FimageUrl	= getItemImageUrl & "/icon1/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(15))			'200px이미지
    						''FItemList(iRows).FimageUrl	= "http://thumbnail.10x10.co.kr/webimage/image/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(11))&"?cmd=thumb&width=200&height=200"		'200px이미지
    						FItemList(iRows).FimageUrl 	= getThumbImgFromURL(getItemImageUrl & "/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(11)),200,200,"true","false")
    					Case Else    ''브랜드 상품리스트, 카테고리 상품리스트, 검색 상품리스트
    						'FItemList(iRows).FimageUrl	= getItemImageUrl & "/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" & db2html(arrData(11))		'400px이미지
    						''FItemList(iRows).FimageUrl	= "http://thumbnail.10x10.co.kr/webimage/image/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(11))&"?cmd=thumb&width=200&height=200"
    						FItemList(iRows).FimageUrl 	= getThumbImgFromURL(getItemImageUrl & "/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(11)),200,200,"true","false")
    				End Select
                else
                    retMatchCd  = ""
				    retMatchVal = ""
				    
				    Call getDocArrMatchCodeVal(FcolorCode,arrData(35),arrData(44),retMatchCd,retMatchVal)
				    
				    iImageBasic 	= getItemImageUrl & "/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &retMatchVal
				    Select Case FimgKind
    					Case "list"
    						FItemList(iRows).FimageUrl 	= getThumbImgFromURL(iImageBasic,100,100,"true","false")
    					Case "icon1" ''브랜드 스트리트 검색(가나다)
    						FItemList(iRows).FimageUrl 	= getThumbImgFromURL(iImageBasic,200,200,"true","false")
    					Case Else    ''브랜드 상품리스트, 카테고리 상품리스트, 검색 상품리스트
    						FItemList(iRows).FimageUrl 	= getThumbImgFromURL(iImageBasic,200,200,"true","false")
    				End Select
    				
                end if
            
				FItemList(iRows).FwebItemUrl	= cstItemPrdUrl & "?itemid=" & FItemList(iRows).FItemid
				FItemList(iRows).FEvalcnt		= arrData(26)

				FItemList(iRows).FLimitYn		= arrData(20)
				FItemList(iRows).FSellYn		= arrData(18)
				FItemList(iRows).FSaleYn		= arrData(19)
				FItemList(iRows).FItemCouponYN	= arrData(23)
				FItemList(iRows).FItemCouponValue = arrData(24)
				FItemList(iRows).FItemCouponType  = arrData(25)
				
				FItemList(iRows).FTenOnlyYn		= arrData(33)
				FItemList(iRows).FRegdate		= dateserial(left(arrData(21),4),mid(arrData(21),5,2),mid(arrData(21),7,2))

				'---------------------------------------- 검색엔진 추가 정보
				''FItemList(iRows).FCateCode = arrData(0)
				''FItemList(iRows).FItemDiv	= arrData(3)
				''FItemList(iRows).FKeyWords = db2html(arrData(6))
				''FItemList(iRows).FEvalcnt_Photo = arrData(27)
				''FItemList(iRows).FItemScore = arrData(29)

			SET arrData = NOTHING
			SET arrSize = NOTHING

			'--------------------------------------------
			'JSON OBJ 저장
			Set objRst(Null) = jsObject()
			objRst(Null)("productid") = cStr(FItemList(iRows).Fitemid)		'상품번호
			objRst(Null)("manufacturer") = FItemList(iRows).Fbrandname		'브랜드명
			objRst(Null)("name") = FItemList(iRows).Fitemname 				'상품명
			objRst(Null)("numofwish") = cStr(FItemList(iRows).FfavCount)		'위시수
			objRst(Null)("originalprice") = cStr(FItemList(iRows).ForgPrice)	'원판매가
			objRst(Null)("currentprice") = cStr(FItemList(iRows).GetCouponAssignPrice)	'현재판매가(할인등)  '' 쿠폰 반영가 (최종가 로 변경)
			objRst(Null)("wishstate") = FItemList(iRows).FisMyWish			'현재 위시여부 (0:안함, 1:위시됨)
			objRst(Null)("imageurl") = b64encode(FItemList(iRows).FimageUrl)	'상품이미지URL
			objRst(Null)("url") = b64encode(FItemList(iRows).FwebItemUrl)		'웹상품URL
			objRst(Null)("numofcomment") = cStr(FItemList(iRows).FEvalcnt)	'상품후기수
            
            ''2014/09/25 추가
            objRst(Null)("dncolor") = FItemList(iRows).getDiscountcolor
            objRst(Null)("dntxt")   = FItemList(iRows).getDiscountText
            
			Set objRst(Null)("state") = jsArray()										'판매상태 (아이콘)

			IF FItemList(iRows).isSoldOut Then
				Set objRst(Null)("state")(null) = jsObject()
				objRst(Null)("state")(null)("name") = "soldout"			'품절(일시품절 이상)
			else
				IF FItemList(iRows).isSaleItem Then
					'할인상품
					Set objRst(Null)("state")(null) = jsObject()
					objRst(Null)("state")(null)("name") = "sale"
				end if
				IF FItemList(iRows).isCouponItem Then
					'상품쿠폰
					Set objRst(Null)("state")(null) = jsObject()
					objRst(Null)("state")(null)("name") = "coupon"
				end if
				IF FItemList(iRows).isLimitItem Then
					'한정상품
					Set objRst(Null)("state")(null) = jsObject()
					objRst(Null)("state")(null)("name") = "limited"
				end if
				IF FItemList(iRows).IsTenOnlyitem Then
					'텐바이텐 독점상품
					Set objRst(Null)("state")(null) = jsObject()
					objRst(Null)("state")(null)("name") = "only"
				end if
				IF FItemList(iRows).isNewItem Then
					'신상품
					Set objRst(Null)("state")(null) = jsObject()
					objRst(Null)("state")(null)("name") = "new"
				end if
				IF FItemList(iRows).IsFreeBeasong Then
					'무료배송
					Set objRst(Null)("state")(null) = jsObject()
					objRst(Null)("state")(null)("name") = "freedelivery"
				end if
			end if

		NEXT
		CALL Docruzer.EndSession()
		SET Docruzer = NOTHING

		'// JSON결과 반환
		set getSearchListJson = objRst

		Set objRst = Nothing

	End Function


	'####### 상품 검색 카테고리별 카운팅  ######
	PUBLIC Function getGroupbyCategoryListJson()

		'// 검색 결과 출력 시나리오명
		Scn= "scn_dt_itemDispCateGroup"		'일반 상품 검색

		dim Logs
		dim Docruzer,ret
		dim iRows
		dim arrData,arrSize
		dim objRst

		dim FseekTime

		'json Array선언
		Set objRst = jsArray()

		StartNum = 0 						'// 검색시작 Row
		call getSearchQuery(SearchQuery)	'// 검색 쿼리생성

		'//그룹 범위별 지정(정렬 쿼리 생성)
		Select Case FGroupScope
			Case "1"
				SortQuery = " GROUP BY idx_cd1grp order by idx_cd1grp " 
			Case "2"
				SortQuery = " GROUP BY idx_cd2grp order by idx_cd2grp "
			Case "3"
				SortQuery = " GROUP BY idx_cd3grp order by idx_cd3grp "
			Case Else
				SortQuery = " GROUP BY idx_cd1grp order by idx_cd1grp "
		end Select

		IF SearchQuery="" Then
			set getGroupbyCategoryListJson = objRst
			Set objRst = Nothing
			EXIT Function
		End If

		dim Rowids,Scores
		FTotalCount = 0

		SET Docruzer = Server.CreateObject("ATLKSearch.Client")
        
        IF NOT InitDocruzer(Docruzer) THEN
            set getGroupbyCategoryListJson = objRst
			Set objRst = Nothing
		    SET Docruzer = Nothing
			EXIT Function
		END IF
		
		''response.write "group : " & SearchQuery & SortQuery & "<br>"
		ret = Docruzer.SubmitQuery(SvrAddr, SvrPort, _
						AuthCode, Logs, Scn, _
						SearchQuery,SortQuery, _
						FRectSearchTxt,StartNum, FPageSize, _
						Docruzer.LC_KOREAN, Docruzer.CS_UTF8)

		If( ret < 0 ) Then
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING
			set getGroupbyCategoryListJson = objRst
			Set objRst = Nothing
			EXIT Function
		END IF


		Call Docruzer.GetResult_RowSize(FResultcount) '검색 결과 수
		Call Docruzer.GetResult_Rowid(Rowids,Scores)

		REDIM FItemList(FResultCount)

		FOR iRows = 0 to FResultcount -1

			ret = Docruzer.GetResult_Row( arrData, arrSize, iRows )

			IF( ret < 0 ) THEN
				'Response.write "GetResult_Row: " & Docruzer.msg
				EXIT FOR
			END IF

			Set objRst(Null) = jsObject()
			objRst(null)("categoryid") = left(arrData(0),3*FGroupScope)					'카테고리 코드
			if Not(arrData(1)="" or isNull(arrData(1))) then
				if (FGroupScope-1)>ubound(split(arrData(1),"^^")) then FGroupScope=ubound(split(arrData(1),"^^"))+1
				objRst(null)("name") = cStr(replace(split(arrData(1),"^^")(FGroupScope-1),"&nbsp;",""))	'카테고리명
			else
				objRst(null)("name") = ""
			end if
			objRst(null)("ishot")     = cStr("N")                           'isHot
			objRst(null)("numofitem") = cStr(Scores(iRows))					'상품수

			SET arrData = NOTHING
			SET arrSize = NOTHING

		NEXT

		'// 결과 반환
		set getGroupbyCategoryListJson = objRst

		'변수 정리
		SET Rowids= NOTHING
		SET Scores= NOTHING

		CALL Docruzer.EndSession()
		SET Docruzer = NOTHING
		Set objRst = Nothing

	End Function

    '####### 추천검색어  ###### Protocol V2 추가
	PUBLIC FUNCTION getRecommendKeyWordsJson()

		Dim Docruzer,ret
		Dim iRows
		Dim arrData,arrSize
		Dim MaxCnt : MaxCnt =4 ''임시 스크롤관련 2014/12/08

        Dim objRst : Set objRst = jsArray()
        
		SET Docruzer = Server.CreateObject("ATLKSearch.Client")
        
        IF NOT InitDocruzer(Docruzer) THEN
            SET getRecommendKeyWordsJson = objRst
		    SET Docruzer = Nothing
			EXIT Function
		END IF

        SvrAddr = G_ORGSCH_ADDR  '' 106번으로 일단

		ret = Docruzer.RecommendKeyWord _
						(SvrAddr&":"&SvrPort,_
						arrSize,arrData,_
						MaxCnt,replace(FRectSearchTxt," ",""),6)

		IF( ret < 0 ) THEN
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING
			SET getRecommendKeyWordsJson = objRst
			EXIT FUNCTION

		END IF

        Dim tempcount 
        tempcount  = Ubound(arrData)
        
        For iRows=0 To tempcount
            Set objRst(Null) = jsObject()
            objRst(null)("keyword") = cStr(arrData(iRows))
        Next
        
		set getRecommendKeyWordsJson = objRst
		SET arrData = NOTHING
		CALL Docruzer.EndSession()
		SET Docruzer = NOTHING
        Set objRst = Nothing
        
	END FUNCTION
	
	'####### 인기검색어  ######
	PUBLIC FUNCTION getPopularKeyWords()

		DIM Docruzer,ret
		DIM iRows
		DIM arrData,arrSize
		DIM MaxCnt : MaxCnt =FPageSize

		SET Docruzer = Server.CreateObject("ATLKSearch.Client")
        
        IF NOT InitDocruzer(Docruzer) THEN
		    SET Docruzer = Nothing
			EXIT Function
		END IF
		
        SvrAddr = G_ORGSCH_ADDR  '' 106번으로 일단

		ret = Docruzer.getPopularKeyword _
						(SvrAddr&":"&SvrPort,_
						arrSize,arrData,_
						MaxCnt,0)
		IF( ret < 0 ) THEN
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING
			EXIT FUNCTION
		END IF

		getPopularKeyWords = arrData
		SET arrData = NOTHING
		CALL Docruzer.EndSession()
		SET Docruzer = NOTHING

	END FUNCTION
	
	'####### 인기검색어 (추가정보) ######
	PUBLIC FUNCTION getPopularKeyWords2(byRef arDt, byRef arTg)

		DIM Docruzer,ret
		DIM iRows
		DIM arrSize, arrData, arrTag
		DIM MaxCnt : MaxCnt =FPageSize

		SET Docruzer = Server.CreateObject("ATLKSearch.Client")

        IF NOT InitDocruzer(Docruzer) THEN
		    SET Docruzer = Nothing
			EXIT Function
		END IF
		
        SvrAddr = G_ORGSCH_ADDR  '' 106번으로 일단

		'인기 검색어 (추가정보)
		ret = Docruzer.getPopularKeyword2 _
						(SvrAddr&":"&SvrPort,_
						arrSize,arrData,arrTag,_
						MaxCnt,0)

		IF( ret < 0 ) THEN
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING
			EXIT FUNCTION
		END IF

		arDt = arrData
		arTg = arrTag
		
		SET arrData = NOTHING
		CALL Docruzer.EndSession()
		SET Docruzer = NOTHING

	END FUNCTION
	
	'####### 검색어 자동완성 ######
	PUBLIC FUNCTION getAutoCompleteKeywords(seed_str, byRef ikwd_count,byRef ikwd_list,byRef icnv_str)

		DIM Docruzer,ret
		DIM iRows
		DIM arrSize, arrData, arrTag
        DIM nFlag : nFlag = 2 '검색방법 (0:앞부터, 1: 뒤부터, 2:앞or뒤)
        Dim max_count : max_count =10 ''최대 수량
        Dim kwd_count : kwd_count =0
        Dim kwd_list, cnv_str
        
		SET Docruzer = Server.CreateObject("ATLKSearch.Client")
        
        IF NOT InitDocruzer(Docruzer) THEN
		    SET Docruzer = Nothing
			EXIT Function
		END IF
		
        SvrAddr = G_ORGSCH_ADDR  '' 106번으로 일단

		'자동완성 검색
		ret = Docruzer.CompleteKeyword( _
					SvrAddr & ":" & SvrPort _
					,kwd_count, kwd_list, cnv_str, max_count, seed_str, nFlag, 0)
					

		IF( ret < 0 ) THEN
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING
			EXIT FUNCTION
		END IF

		ikwd_count = kwd_count
		ikwd_list = kwd_list
		icnv_str = cnv_str
		
		SET arrData = NOTHING
		CALL Docruzer.EndSession()
		SET Docruzer = NOTHING

	END FUNCTION
	
	'####### 상품 검색 브랜드별 카운팅  ###### Protocol V2 추가
	PUBLIC FUNCTION getGroupbyBrandListJson()

		'// 검색 결과 출력 시나리오명
		Scn= "scn_dt_itemDispBrandGroup"		'일반 상품 검색
		dim Logs
		dim Docruzer,ret
		dim iRows
		dim arrData,arrSize

		dim FseekTime
        Dim objRst : Set objRst = jsArray()
        
		StartNum = 0 						'// 검색시작 Row
		call getSearchQuery(SearchQuery)	'// 검색 쿼리생성

		'//그룹 범위별 지정(정렬 쿼리 생성)
		'SortQuery = " GROUP BY makerid order by brandname "
		SortQuery = " GROUP BY makerid order by count(*) desc"

		IF SearchQuery="" Then
		    SET getGroupbyBrandListJson = objRst
			EXIT FUNCTION
		End If

		dim Rowids,Scores
		FTotalCount = 0

		SET Docruzer = Server.CreateObject("ATLKSearch.Client")
        
        IF NOT InitDocruzer(Docruzer) THEN
            SET getGroupbyBrandListJson = objRst
		    SET Docruzer = Nothing
			EXIT Function
		END IF
		
		'response.write "group : " & SearchQuery & SortQuery & "<br>"
		ret = Docruzer.SubmitQuery(SvrAddr, SvrPort, _
						AuthCode, Logs, Scn, _
						SearchQuery,SortQuery, _
						FRectSearchTxt,StartNum, FPageSize, _
						Docruzer.LC_KOREAN, Docruzer.CS_UTF8)

		If( ret < 0 ) Then
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING
			SET getGroupbyBrandListJson = objRst
			EXIT FUNCTION
		END IF

		Call Docruzer.GetResult_RowSize(FResultcount) '검색 결과 수
		Call Docruzer.GetResult_Rowid(Rowids,Scores)

		REDIM FItemList(FResultCount)

		Call Docruzer.GetResult_TotalCount(FTotalCount) '검색결과 총 수

		FOR iRows = 0 to FResultcount -1

			ret = Docruzer.GetResult_Row( arrData, arrSize, iRows )

			IF( ret < 0 ) THEN
				'Response.write "GetResult_Row: " & Docruzer.msg
				EXIT FOR
			END IF
            
            Set objRst(Null) = jsObject()
                objRst(Null)("brandid") = arrData(0)
                objRst(Null)("brandname") = arrData(1)
                objRst(Null)("isbestbrand") = arrData(4)
                
			SET arrData = NOTHING
			SET arrSize = NOTHING

		NEXT
        
        SET getGroupbyBrandListJson = objRst
        
		SET Rowids= NOTHING
		SET Scores= NOTHING

		CALL Docruzer.EndSession()
		SET Docruzer = NOTHING
        Set objRst = Nothing
	End FUNCTION
	
End Class


'// 내 위시 상품 목록(검색 결과에서 상품목록 전송)
Sub getMyFavItemList(uid,iid,byRef sIid, byRef sCnt)
   Exit Sub ''더이상 사용하지 않음
	dim strSQL, aiid, acnt
	aiid="": acnt=""

	if (uid="") then Exit Sub
	strSQL = "execute [db_my10x10].[dbo].[sp_Ten_MyWishSearchItem] '" & CStr(uid) & "', '" & cStr(iid) & "'"
	rsget.CursorLocation = adUseClient
	rsget.CursorType=adOpenStatic
	rsget.Locktype=adLockReadOnly
	rsget.Open strSQL, dbget
	if Not(rsget.EOF or rsget.BOF) then
		Do Until rsget.EOF
			aiid = aiid & chkIIF(aiid<>"",",","") & rsget("itemid")
			acnt = acnt & chkIIF(acnt<>"",",","") & rsget("favcount")
			rsget.MoveNext
		Loop
	end if
	rsget.Close

	'결과 반환
	sIid = aiid
	sCnt = acnt
end Sub
%>