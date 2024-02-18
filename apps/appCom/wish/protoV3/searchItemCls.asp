<%
'''--------------------------------------------------------------------------------------
DIM G_KSCOLORCD : G_KSCOLORCD = Array("023","001","002","010","021","003","004","024","019","005","016","006","007","020","008","018","017","009","011","012","022","013","014","015","025","026","027","028","029","030","031")
DIM G_KSCOLORNM : G_KSCOLORNM = Array("와인","빨강","주황","갈색","카멜","노랑","베이지","아이보리","카키","초록","민트","연파랑","파랑","네이비","보라","연보라","베이비핑크","핑크","흰색","옅은회색","짙은회색","검정","은색","금색","체크","스트라이프","도트","플라워","드로잉","애니멀","기하학")

Dim G_KSSTYLECD : G_KSSTYLECD = Array("010","020","030","040","050","060","070","080","090")
Dim G_KSSTYLENM : G_KSSTYLENM = Array("클래식","큐티","댄디","모던","내추럴","오리엔탈","팝","로맨틱","빈티지")

DIM G_ORGSCH_ADDR , GG_ORGSCH_ADDR
DIM G_1STSCH_ADDR , GG_1STSCH_ADDR
DIM G_2NDSCH_ADDR , GG_2NDSCH_ADDR
DIM G_3RDSCH_ADDR , GG_3RDSCH_ADDR
Dim G_4THSCH_ADDR , GG_4THSCH_ADDR

DIM G_SCH_TIME : G_SCH_TIME=formatdatetime(now(),4)

IF (application("Svr_Info") = "Dev") THEN
     G_1STSCH_ADDR = "192.168.50.10"
     G_2NDSCH_ADDR = "192.168.50.10"
     G_3RDSCH_ADDR = "192.168.50.10"
     G_4THSCH_ADDR = "192.168.50.10"
     G_ORGSCH_ADDR = "192.168.50.10"
ELSE
     G_1STSCH_ADDR = "192.168.0.210"        ''192.168.0.210  :: www 검색페이지(search.asp)   '
     G_2NDSCH_ADDR = "192.168.0.207"        ''192.168.0.207  :: www 카테고리, 상품, 브랜드
     G_3RDSCH_ADDR = "192.168.0.209"        ''192.168.0.209  :: app 
     G_4THSCH_ADDR = "192.168.0.208"        ''192.168.0.208  :: mobile 6:10분에 인덱싱 시작 카피
     G_ORGSCH_ADDR = "192.168.0.206"        ''192.168.0.206
END IF

GG_1STSCH_ADDR = G_1STSCH_ADDR
GG_2NDSCH_ADDR = G_2NDSCH_ADDR
GG_3RDSCH_ADDR = G_3RDSCH_ADDR
GG_4THSCH_ADDR = G_4THSCH_ADDR
GG_ORGSCH_ADDR = G_ORGSCH_ADDR

'' 2017/10/09 추가 =================================================================================================
'' 오류 발생시 Application("G_3RDSCH_ADDR")=G_ORGSCH_ADDR 로 변경. 
'' 이후 오류 복구시 Application("G_3RDSCH_ADDR")="" 이부분 주석 해제후 G_3RDSCH_ADDR 로 치환할것. 이후 다시 주석처리
'' Application("G_3RDSCH_ADDR")=""
if (Application("G_3RDSCH_ADDR")="") then
    Application("G_3RDSCH_ADDR")=G_3RDSCH_ADDR
end if

G_3RDSCH_ADDR=Application("G_3RDSCH_ADDR")

'' event 쪽에서 쓴다..
if (Application("G_4THSCH_ADDR")="") then
    Application("G_4THSCH_ADDR")=G_4THSCH_ADDR
end if

G_4THSCH_ADDR=Application("G_4THSCH_ADDR")


if (Application("G_ORGSCH_ADDR")="") then
	Application("G_ORGSCH_ADDR")=G_ORGSCH_ADDR
end if

G_ORGSCH_ADDR = Application("G_ORGSCH_ADDR")
'' ==================================================================================================================

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
		case "("
			ret = ret & "\("
		case ")"
			ret = ret & "\)"
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
		FAddLogRemove = false
	End SUB

	Private SUB Class_Terminate()
	End SUB

	dim FItemList
	dim FPageSize		'페이지 단위
	dim StartNum		'시작 번호
	dim FResultCount
	dim FTotalCount
	
	dim FAppKey
	dim FVerCd
	dim FVerNm

	dim FRectSearchTxt		'검색어
	dim FRectSearchItemDiv	'카테고리 검색 범위 (y:기본 카테고리만, n:추가 카테고리 폼함)
	dim FRectSearchCateDep	'카테고리 검색 범위 (X:해당 카테고리만, T:하위 카테고리 포함)
	dim FRectPrevSearchTxt	'이전 검색어
	dim FRectExceptText		'제외어
	dim FRectSortMethod		'정렬방식 (ne:신상품, be:인기상품, lp:낮은가격, hp:높은가격, hs:할인률, br:상품후기, ws:위시수, bs:판매수)
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
	dim FAddLogRemove		''검색기본로그 제거 Logs = Logs & "ggsn=" inc_BestItem.asp 등에서 추가로그가 저장되는것을 방지함.

	dim FarrCate			'복수 카테고리
	dim FisTenOnly			'텐바이텐 전용상품
	dim FisLimit			'한정판매상품
	dim FisFreeBeasong

	dim FimgKind			'상품이미지 구분

    dim FRectChannel        '채널구분 / 이벤트에서 사용
    dim FRectIs2017
    dim FSearchGubun
    dim FSearchGubunKWD
    
    dim FRectThumbMode
    
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
			Case "saleonly"
				'할인상품 목록(무료배송쿠폰제외)
				FRectSearchFlag = "os"
			Case "fulllist"
				'카테고리없는 전체.
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
				strQue = getQrCon(strQue) & "idx_itemname='" & FRectSearchTxt & "'  allword synonym "	'키워드검색(동의어 포함) synonym
			End if
		END If
		
		'############# 딜상품 제외 조건(app Ver 2.19 이하) ######################
		if FVerNm="" then FVerNm=0
		if CDbl(FVerNm)<2.19 then
			strQue = strQue & getQrCon(strQue) & "idx_itemdiv != '21' "
		end if

		'@ 카테고리
		IF trim(FRectCateCode)<>"" Then
			if FRectSearchCateDep="X" then
				strQue = strQue & getQrCon(strQue) & "idx_catecode='" & FRectCateCode & "'"
			else
				IF FRectSearchItemDiv="y" Then ''기본카테고리
			        ''strQue = strQue & getQrCon(strQue) & "idx_catecode like '" & FRectCateCode & "*'"
			        strQue = strQue & getQrCon(strQue) & "idx_catecodelist='" & FRectCateCode & "'"
			    else                           ''추가카테검색
			        ''strQue = strQue & getQrCon(strQue) & "idx_catecodeExt like '" & FRectCateCode & "*'"
			        strQue = strQue & getQrCon(strQue) & "idx_catecodeExt='" & FRectCateCode & "'"
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
					''strQue = strQue & " idx_catecode like '" & RequestCheckVar(LCase(trim(arrCt(lpCt))),18) & "*' "
					strQue = strQue & " idx_catecodelist='" & RequestCheckVar(LCase(trim(arrCt(lpCt))),18) & "' "
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
				Case "os"	'할인전용 (무료배송 쿠폰 제외)
					strQue= strQue & getQrCon(strQue) & "(idx_saleyn='Y' or (idx_itemcouponyn='Y' and idx_isFreeBeasong='N')) "
				Case "pk"	'포장서비스
					strQue = strQue & getQrCon(strQue) & "idx_pojangok='Y' and (deliverytype='1' or deliverytype='4') "
				Case "scpk"	'포장서비스 & 세일쿠폰
					strQue = strQue & getQrCon(strQue) & "((idx_saleyn='Y' or idx_itemcouponyn='Y') and idx_pojangok='Y') and (deliverytype='1' or deliverytype='4') "
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
			Case "QT"	'바로배송
				strQue = strQue & getQrCon(strQue) & "idx_deliverfixday='Q'"
			Case "DT"	'해외직구
				strQue = strQue & getQrCon(strQue) & "idx_deliverfixday='G'"
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
				strQue = strQue & " ORDER BY regdate desc, itemid desc"
			Case "best", "be"	'인기상품
				if (FListDiv<>"search") then
    				strQue = strQue & " ORDER BY itemscore desc, itemid desc"
					
					'브랜드스트리트 상품목록은 딜상품 우선 정렬
					if FListDiv="brand" and FRectMakerid<>"" and FpageSize>=10 then
						strQue =replace(strQue, " ORDER BY " , " ORDER BY dealmasteritem DESC, ")
					end if									
    			else
    				''strQue = strQue & " ORDER BY $MATCH(recomkeyword) desc, $MATCHFIELD(cateboostkeylist,bestkeylist) desc, itemscore desc,itemid desc"
					strQue = strQue & " ORDER BY $CATEGORYFIELD( recomkeyword(1) seasonboost_groupid(3) categorynamelist(0) bestkeylist(2) makerid(4), '"&replace(TRIM(FRectSearchTxt)," ","")&"') desc, itemscore desc,itemid desc"
    			end if
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
			Case "bs"	'판매수순
				if (FListDiv<>"search") then '' 분리 2019/06/14
					strQue = strQue & " ORDER BY sellCnt desc,sellcash desc,itemid desc"
				else
					''strQue = strQue & " ORDER BY $MATCH(recomkeyword) desc, $MATCHFIELD(cateboostkeylist,bestkeylist) desc, sellCnt desc, itemscore desc, itemid desc"
					strQue = strQue & " ORDER BY $CATEGORYFIELD( recomkeyword(1) seasonboost_groupid(3) categorynamelist(0) bestkeylist(2) makerid(4), '"&replace(TRIM(FRectSearchTxt)," ","")&"') desc, sellCnt desc, itemscore desc, itemid desc"
				end if
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
        dim iDocErrMsg
        
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

		''2019/11/06 추가 
		Dim iggsnkey : iggsnkey = fn_getGgsnCookie()
		if (iggsnkey="") then
			Call fn_CheckNMakeGGsnCookie 
		end if

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
                Logs = Logs&TRIM(replace(replace(FRectSearchTxt,vbCr,""),vbLf,""))&"]["     ''## ]				 ''2019/11/06 기존 레거시를 유지하기 위해 ][ 를 넣는다.
            end if
		END IF

		Logs = Logs & "ggsn="&iggsnkey&"&page="&CLNG(StartNum/FPageSize)+1  ''2019/11/06 추가
		Logs = Logs & "&sid="&RIGHT(application("Svr_Info"),3)&"_"&session.sessionid ''2019/11/07 추가 세션ID값추가
		Logs = Logs & "&p=a"

		if (FAddLogRemove) then Logs=""

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
			dbget.execute "EXECUTE db_log.dbo.sp_Ten_DocLog @ErrMsg ='["&SvrAddr&"]"& html2db(Docruzer.GetErrorMessage())&"["&Request.ServerVariables("REMOTE_ADDR")&"]["&Request.ServerVariables("LOCAL_ADDR")&"]["& html2db(SearchQuery)&"]'"
            
            iDocErrMsg = Docruzer.GetErrorMessage()
            if (InStr(iDocErrMsg,"recv queue full")>0) or (InStr(iDocErrMsg,"socket time out")>0) or (InStr(iDocErrMsg,"cannot connect to server")>0) then
                if (Application("G_3RDSCH_ADDR")=GG_3RDSCH_ADDR) then
                    Application("G_3RDSCH_ADDR") = GG_ORGSCH_ADDR
                elseif (Application("G_3RDSCH_ADDR")=GG_ORGSCH_ADDR) then
                    Application("G_3RDSCH_ADDR") = GG_2NDSCH_ADDR
                end if
            end if
            
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING

''			IF FListDiv<>"search" THEN
''				'// 3차 서버 에서시 4차 서버에서 구동(4차도 에러면 Skip)
''				if (SvrAddr = G_3RDSCH_ADDR) then
''					SvrAddr = G_4THSCH_ADDR  ''"192.168.0.108"
''					if (G_3RDSCH_ADDR<>G_4THSCH_ADDR) then
''					    'call getSearchList()
''				    end if
''				end if
''			END IF

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
    						if (true)or (FListDiv="brand") then  ''2016/03/21 썸네일사이즈 200=>300 순차변경.
    						    FItemList(iRows).FimageUrl 	= getThumbImgFromURL(getItemImageUrl & "/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(11)),300,300,"true","false")
    						else
    						    FItemList(iRows).FimageUrl 	= getThumbImgFromURL(getItemImageUrl & "/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(11)),200,200,"true","false")
    						end if
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
    					    if (true)or (FListDiv="brand") then  ''2016/03/21 썸네일사이즈 200=>300 순차변경.
    					        FItemList(iRows).FimageUrl 	= getThumbImgFromURL(iImageBasic,300,300,"true","false")
    					    else
    						    FItemList(iRows).FimageUrl 	= getThumbImgFromURL(iImageBasic,200,200,"true","false")
    						end if
    				End Select
    				
                end if
            
				FItemList(iRows).FwebItemUrl	= cstItemPrdUrl & "?itemid=" & FItemList(iRows).FItemid
				''로그분석 추가. 2015/11/18 ---------------------------------------------------------------------------
				''pCtr=101109101, pRtr=문주란,pEtr=58574, pBtr=mmmg  FRectSearchTxt, FRectCateCode, FRectMakerid
				if (TRUE) then
    				if (FRectSearchTxt<>"") then  ''검색어 우선>브랜드>카테코드 (ios 1.981 부터 적용됨. 기존은 static)
    				    FItemList(iRows).FwebItemUrl = FItemList(iRows).FwebItemUrl&"&pRtr="&server.UrlEncode(FRectSearchTxt)
    				elseif (FRectMakerid<>"") then
    				    FItemList(iRows).FwebItemUrl = FItemList(iRows).FwebItemUrl&"&pBtr="&server.UrlEncode(FRectMakerid)
    				elseif (FRectCateCode<>"") then
    				    FItemList(iRows).FwebItemUrl = FItemList(iRows).FwebItemUrl&"&pCtr="&server.UrlEncode(FRectCateCode)
    			    end if

					'클릭 위치 tag 추가(rc 구분값_페이지_순서)
					FItemList(iRows).FwebItemUrl = FItemList(iRows).FwebItemUrl&"&rc=rpos_"&(fix(StartNum/FPageSize)+1)&"_"&cStr(iRows+1)
    			end if
			    ''------------------------------------------------------------------------------------------------------
				
				FItemList(iRows).FEvalcnt		= arrData(26)

				FItemList(iRows).FLimitYn		= arrData(20)
				FItemList(iRows).FSellYn		= arrData(18)
				FItemList(iRows).FSaleYn		= arrData(19)
				FItemList(iRows).FItemCouponYN	= arrData(23)
				FItemList(iRows).FItemCouponValue = arrData(24)
				FItemList(iRows).FItemCouponType  = arrData(25)
				
				FItemList(iRows).FTenOnlyYn		= arrData(33)
				FItemList(iRows).FRegdate		= dateserial(left(arrData(21),4),mid(arrData(21),5,2),mid(arrData(21),7,2))
                
                ''2015/11/17 추가
                FItemList(iRows).Fpojangok      = arrData(49) ''"N" ''
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
			'// 상품후기 평점 별4->5로 변경되면서 2.493 이전버전은 리스트에 별점 표시 안함
			if CDbl(FVerNm)<2.493 then
				objRst(Null)("numofcomment") = cStr(0)	'상품후기수
			Else
				objRst(Null)("numofcomment") = cStr(FItemList(iRows).FEvalcnt)	'상품후기수
			end if
            
            ''2014/09/25 추가
            objRst(Null)("dncolor") = FItemList(iRows).getDiscountcolor
            objRst(Null)("dntxt")   = FItemList(iRows).getDiscountText
            
            ''2015/11/17 추가
            objRst(Null)("pojangok")   = FItemList(iRows).Fpojangok
            
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
	
	
	'####### 상품 검색 - 검색 엔진 ######
	PUBLIC Function getSearchListJson2017()

		DIM Scn
		DIM Docruzer,ret

		DIM Logs ,iRows
		DIM arrData,arrSize, retMatchCd, retMatchVal, iImageBasic
		Dim objRst
		dim tmpId, tmpCnt, vSearchParam
        dim iDocErrMsg
		dim adultChkFlag  
		dim isAdultProduct

		'####### 내 상품비교 데이터 #######
		Dim vMyCArr, vMyCItem, c
		If IsUserLoginOK() Then
			vMyCArr = fnGetCompareItem("list",getLoginUserid())
			vMyCItem = ""
			
			If isArray(vMyCArr) Then
				For c=0 To UBound(vMyCArr,2)
					If c > 0 Then
						vMyCItem = vMyCItem & ","
					End If
					vMyCItem = vMyCItem & "item" & vMyCArr(0,c)
				Next
			End If
		End If


		'json Array선언
		Set objRst = jsArray()

		'// 검색 결과 출력 시나리오명
		Scn= "scn_dt_itemDisp"		'일반 상품 검색

		CALL getSearchQuery(SearchQuery)	'// 검색 쿼리생성
		CALL getSortQuery(SortQuery)		'// 정렬 쿼리 생성
		''Response.Write SearchQuery &"<Br>"
		IF SearchQuery="" THEN
			set getSearchListJson2017 = objRst
			Set objRst = Nothing
			EXIT Function
		END IF

		''2019/11/06 추가 
		Dim iggsnkey : iggsnkey = fn_getGgsnCookie()
		if (iggsnkey="") then
			Call fn_CheckNMakeGGsnCookie 
		end if

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
                Logs = Logs&TRIM(replace(replace(FRectSearchTxt,vbCr,""),vbLf,""))&"]["     ''## ]				 ''2019/11/06 기존 레거시를 유지하기 위해 ][ 를 넣는다.
            end if
		END IF

		Logs = Logs & "ggsn="&iggsnkey&"&page="&CLNG(StartNum/FPageSize)+1  ''2019/11/06 추가	
		Logs = Logs & "&sid="&RIGHT(application("Svr_Info"),3)&"_"&session.sessionid ''2019/11/07 추가 세션ID값추가
		Logs = Logs & "&p=a"

		if (FAddLogRemove) then Logs=""
		
		'독크루져 커넥션 선언
		SET Docruzer = Server.CreateObject("ATLKSearch.Client")
        
        IF NOT InitDocruzer(Docruzer) THEN
            set getSearchListJson2017 = objRst
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
			dbget.execute "EXECUTE db_log.dbo.sp_Ten_DocLog @ErrMsg ='["&SvrAddr&"]"& html2db(Docruzer.GetErrorMessage())&"["&Request.ServerVariables("REMOTE_ADDR")&"]["&Request.ServerVariables("LOCAL_ADDR")&"]["& html2db(SearchQuery)&"]'"
            
            iDocErrMsg = Docruzer.GetErrorMessage()
            if (InStr(iDocErrMsg,"recv queue full")>0) or (InStr(iDocErrMsg,"socket time out")>0) or (InStr(iDocErrMsg,"cannot connect to server")>0) then
                if (Application("G_3RDSCH_ADDR")=G_3RDSCH_ADDR) then
                    Application("G_3RDSCH_ADDR") = G_ORGSCH_ADDR
                elseif (Application("G_3RDSCH_ADDR")=G_ORGSCH_ADDR) then
                    Application("G_3RDSCH_ADDR") = G_2NDSCH_ADDR
                end if
            end if
            
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING

''			IF FListDiv<>"search" THEN
''				'// 3차 서버 에서시 4차 서버에서 구동(4차도 에러면 Skip)
''				if (SvrAddr = G_3RDSCH_ADDR) then
''					SvrAddr = G_4THSCH_ADDR  ''"192.168.0.108"
''					if (G_3RDSCH_ADDR<>G_4THSCH_ADDR) then
''					    'call getSearchList()
''				    end if
''				end if
''			END IF

			set getSearchListJson2017 = objRst
			Set objRst = Nothing
			EXIT Function
		END IF

		Call Docruzer.GetResult_TotalCount(FTotalCount) '검색결과 총 수
		Call Docruzer.GetResult_RowSize(FResultcount) '검색 결과 수
		'Response.write "검색결과수 : " & FTotalCount & "<br>"
		IF( FResultCount <= 0 ) THEN
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING

			set getSearchListJson2017 = objRst
			Set objRst = Nothing
			EXIT Function
		END IF

		REDIM FItemList(FResultCount)

		'### 위시담긴것 상품코드 비교 여부
		if IsUserLoginOK then
			'// 검색결과 상품목록 작성
			dim rstArrItemid, iLp, vWishArr
			rstArrItemid=""
			IF FResultCount >0 then
				FOR iRows=0 to FResultCount -1
					ret = Docruzer.GetResult_Row( arrData, arrSize, iRows )
					rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & arrData(4)
					SET arrData = NOTHING
				Next
			End if
			'// 위시결과 상품목록 작성
			if rstArrItemid<>"" then
				Call getMyFavItemList2017(getLoginUserid(),rstArrItemid,vWishArr)
			end if
		end if

		FOR iRows=0 to FResultCount -1

			ret = Docruzer.GetResult_Row( arrData, arrSize, iRows )
			IF( ret < 0 ) THEN
				EXIT FOR
			END IF

			SET FItemList(iRows) = NEW CWishItem

				FItemList(iRows).Fitemid		= arrData(4)
				FItemList(iRows).FItemDiv		= arrData(3)
				FItemList(iRows).Fmakerid		= arrData(9)
				FItemList(iRows).Fbrandname		= db2html(arrData(10))
				FItemList(iRows).Fitemname		= db2html(arrData(5))
				FItemList(iRows).ForgPrice		= arrData(8)
				FItemList(iRows).FsellPrice		= arrData(7)
				FItemList(iRows).FfavCount		= arrData(28)

				If fnIsMyFavItem(vWishArr,FItemList(iRows).Fitemid) Then
					FItemList(iRows).FisMyWish		= "1"		'내 위시상품 O
				Else
					FItemList(iRows).FisMyWish		= "0"		'내 위시상품 X
				End If

				adultChkFlag = session("isAdult") <> true and arrData(55) = 1
				isAdultProduct = arrData(55)
				if not adultChkFlag then
					isAdultProduct = 0
				end if

                if (FcolorCode="" or FcolorCode="0") then
    				Select Case FimgKind
    					Case "list"
    						''FItemList(iRows).FimageUrl 	= getItemImageUrl & "/list/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(13))			'100px이미지
    						''FItemList(iRows).FimageUrl	= "http://thumbnail.10x10.co.kr/webimage/image/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(11))	&"?cmd=thumb&width=100&height=100"
    						if FItemList(iRows).FItemDiv="21" then
    							'딜상품이면
								if instr(arrData(11),"/") > 0 then
    								FItemList(iRows).FimageUrl 	= getThumbImgFromURL(getItemImageUrl & "/basic/" &db2html(arrData(11)),100,100,"true","false")
								else
									FItemList(iRows).FimageUrl 	= getThumbImgFromURL(getItemImageUrl & "/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(11)),100,100,"true","false")
								end if
    						else
    							FItemList(iRows).FimageUrl 	= getThumbImgFromURL(getItemImageUrl & "/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(11)),100,100,"true","false")
    						end if
    						
    					Case "icon1" ''브랜드 스트리트 검색(가나다)
    						''FItemList(iRows).FimageUrl	= getItemImageUrl & "/icon1/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(15))			'200px이미지
    						''FItemList(iRows).FimageUrl	= "http://thumbnail.10x10.co.kr/webimage/image/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(11))&"?cmd=thumb&width=200&height=200"		'200px이미지
    						if FItemList(iRows).FItemDiv="21" then
    							'딜상품이면
								if instr(arrData(11),"/") > 0 then
    								FItemList(iRows).FimageUrl 	= getThumbImgFromURL(getItemImageUrl & "/basic/" &db2html(arrData(11)),200,200,"true","false")
								else
									FItemList(iRows).FimageUrl 	= getThumbImgFromURL(getItemImageUrl & "/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(11)),200,200,"true","false")
								end if
    						else
    							FItemList(iRows).FimageUrl 	= getThumbImgFromURL(getItemImageUrl & "/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(11)),200,200,"true","false")
    						end if
    					Case Else    ''브랜드 상품리스트, 카테고리 상품리스트, 검색 상품리스트
    						'FItemList(iRows).FimageUrl	= getItemImageUrl & "/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" & db2html(arrData(11))		'400px이미지
    						''FItemList(iRows).FimageUrl	= "http://thumbnail.10x10.co.kr/webimage/image/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(11))&"?cmd=thumb&width=200&height=200"
    						if (true)or (FListDiv="brand") then  ''2016/03/21 썸네일사이즈 200=>300 순차변경.
	    						if FItemList(iRows).FItemDiv="21" then
	    							'딜상품이면
									if instr(arrData(11),"/") > 0 then
	    								FItemList(iRows).FimageUrl 	= getThumbImgFromURL(getItemImageUrl & "/basic/" &db2html(arrData(11)),300,300,"true","false")
									else
										FItemList(iRows).FimageUrl 	= getThumbImgFromURL(getItemImageUrl & "/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(11)),300,300,"true","false")
									end if
	    						else
    						    	FItemList(iRows).FimageUrl 	= getThumbImgFromURL(getItemImageUrl & "/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(11)),300,300,"true","false")
    						    end if
    						else
	    						if FItemList(iRows).FItemDiv="21" then
	    							'딜상품이면
									if instr(arrData(11),"/") > 0 then
	    								FItemList(iRows).FimageUrl 	= getThumbImgFromURL(getItemImageUrl & "/basic/" &db2html(arrData(11)),200,200,"true","false")
									else
										FItemList(iRows).FimageUrl 	= getThumbImgFromURL(getItemImageUrl & "/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(11)),200,200,"true","false")
									end if
	    						else
    						    	FItemList(iRows).FimageUrl 	= getThumbImgFromURL(getItemImageUrl & "/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(11)),200,200,"true","false")
    						    end if
    						end if
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
    					    if (true)or (FListDiv="brand") then  ''2016/03/21 썸네일사이즈 200=>300 순차변경.
    					        FItemList(iRows).FimageUrl 	= getThumbImgFromURL(iImageBasic,300,300,"true","false")
    					    else
    						    FItemList(iRows).FimageUrl 	= getThumbImgFromURL(iImageBasic,200,200,"true","false")
    						end if
    				End Select
    				
                end if
            
				if FItemList(iRows).FItemDiv="21" then
					'딜상품이면
					FItemList(iRows).FwebItemUrl	= cstDealItemUrl & "?itemid=" & FItemList(iRows).FItemid
				else
					FItemList(iRows).FwebItemUrl	= cstItemPrdUrl & "?itemid=" & FItemList(iRows).FItemid
				end if

				''로그분석 추가. 2015/11/18 ---------------------------------------------------------------------------
				''pCtr=101109101, pRtr=문주란,pEtr=58574, pBtr=mmmg  FRectSearchTxt, FRectCateCode, FRectMakerid
				vSearchParam = ""
				If FSearchGubun = "searchcategory" Then	'### 자동완성 카테고리에서 넘어온 경우
					vSearchParam = "&pNtr=qc_" &server.UrlEncode(FSearchGubunKWD)
				ElseIf FSearchGubun = "searchbrand" Then	'### 자동완성 브랜드에서 넘어온 경우
					vSearchParam = "&pNtr=qb_" &server.UrlEncode(FSearchGubunKWD)
				ElseIf FSearchGubun = "searchkeyword" Then	'### 자동완성 키워드에서 넘어온 경우
					vSearchParam = "&pNtr=qk_" &server.UrlEncode(FSearchGubunKWD)
				End If
				
				if (TRUE) then
    				if (FRectSearchTxt<>"") then  ''검색어 우선>브랜드>카테코드 (ios 1.981 부터 적용됨. 기존은 static)
    				    FItemList(iRows).FwebItemUrl = FItemList(iRows).FwebItemUrl&"&pRtr="&server.UrlEncode(FRectSearchTxt) & vSearchParam
    				elseif (FRectMakerid<>"") then
    				    FItemList(iRows).FwebItemUrl = FItemList(iRows).FwebItemUrl&"&pBtr="&server.UrlEncode(FRectMakerid) & vSearchParam
    				elseif (FRectCateCode<>"" and FRectSearchTxt="") then
    				    FItemList(iRows).FwebItemUrl = FItemList(iRows).FwebItemUrl&"&pCtr="&server.UrlEncode(FRectCateCode) & vSearchParam
    				else
    					FItemList(iRows).FwebItemUrl = FItemList(iRows).FwebItemUrl&"&pRtr="&server.UrlEncode(FRectSearchTxt) & vSearchParam
    			   end if

					'클릭 위치 tag 추가(rc 구분값_페이지_순서)
					FItemList(iRows).FwebItemUrl = FItemList(iRows).FwebItemUrl&"&rc=rpos_"&(fix(StartNum/FPageSize)+1)&"_"&cStr(iRows+1)
    			end if
				if adultChkFlag then
					if getAppVersion() then						
						if getAppVersion() >= 2.483 then    '성인인증 블라인드 기능 탑재 버전
							FItemList(iRows).FwebItemUrl = "http://m.10x10.co.kr/login/login_adult.asp?adtprdid=" & FItemList(iRows).FItemid
						else	'구버전
							FItemList(iRows).FwebItemUrl = FItemList(iRows).FwebItemUrl&"&rc=rpos_"&(fix(StartNum/FPageSize)+1)&"_"&cStr(iRows+1)
						end if
					else 
						FItemList(iRows).FwebItemUrl = FItemList(iRows).FwebItemUrl&"&rc=rpos_"&(fix(StartNum/FPageSize)+1)&"_"&cStr(iRows+1)
					end if
				end if
			    ''------------------------------------------------------------------------------------------------------
				
				FItemList(iRows).FEvalcnt		= arrData(26)

				FItemList(iRows).FLimitYn		= arrData(20)
				FItemList(iRows).FSellYn		= arrData(18)
				FItemList(iRows).FSaleYn		= arrData(19)
				FItemList(iRows).FItemCouponYN	= arrData(23)
				FItemList(iRows).FItemCouponValue = arrData(24)
				FItemList(iRows).FItemCouponType  = arrData(25)
				
				FItemList(iRows).FTenOnlyYn		= arrData(33)
				FItemList(iRows).FRegdate		= dateserial(left(arrData(21),4),mid(arrData(21),5,2),mid(arrData(21),7,2))
                
                ''2015/11/17 추가
                FItemList(iRows).Fpojangok      = arrData(49) ''"N" ''
                FItemList(iRows).FPoints 		= arrData(50)
				'---------------------------------------- 검색엔진 추가 정보
				FItemList(iRows).FCateCode		= arrData(0)
				FItemList(iRows).FLimitYn		= arrData(20)
				FItemList(iRows).FOptionCnt		= arrData(51)
				
				''FItemList(iRows).FItemDiv	= arrData(3)
				''FItemList(iRows).FKeyWords = db2html(arrData(6))
				''FItemList(iRows).FEvalcnt_Photo = arrData(27)
				''FItemList(iRows).FItemScore = arrData(29)

				'// 무료배송
				FItemList(iRows).FFreeDeliveryYN = arrData(31)

				'// 해외직구
				FItemList(iRows).FDeliverFixDay = arrData(54)
				FItemList(iRows).FadultType = arrData(55)

				'// 카테고리 1depth명
				FItemList(iRows).FCateName = arrData(41)

			SET arrData = NOTHING
			SET arrSize = NOTHING

			'--------------------------------------------
			'JSON OBJ 저장
			Set objRst(Null) = jsObject()
			objRst(Null)("productid") = cStr(FItemList(iRows).Fitemid)		'상품번호
			objRst(Null)("manufacturer") = FItemList(iRows).Fbrandname		'브랜드명
			objRst(Null)("name") = cStr(FItemList(iRows).Fitemname) 	'상품명
			objRst(Null)("numofwish") = cStr(FItemList(iRows).FfavCount)		'위시수
			'objRst(Null)("originalprice") = cStr(FItemList(iRows).ForgPrice)	'원판매가
			'objRst(Null)("currentprice") = cStr(FItemList(iRows).GetCouponAssignPrice)	'현재판매가(할인등)  '' 쿠폰 반영가 (최종가 로 변경)
			objRst(Null)("wishstate") = FItemList(iRows).FisMyWish			'현재 위시여부 (0:안함, 1:위시됨)
			if adultChkFlag then
				objRst(Null)("imageurl") = b64encode("http://fiximage.10x10.co.kr/m/2019/common/img_adult_172.png")	'성인용품 블라인드 이미지
			else
				objRst(Null)("imageurl") = b64encode(FItemList(iRows).FimageUrl)	'상품이미지URL
			end if			
			objRst(Null)("url") = b64encode(FItemList(iRows).FwebItemUrl)		'웹상품URL
			objRst(Null)("quickviewurl") = chkIIF(FItemList(iRows).FItemDiv="21","",b64encode(mDomain & "/apps/appCom/wish/web2014/category/search_item_quickview.asp?itemid=" & FItemList(iRows).Fitemid)) '퀵뷰URL
			'// 상품후기 평점 별4->5로 변경되면서 2.493 이전버전은 리스트에 별점 표시 안함
			if CDbl(FVerNm)<2.493 then
				objRst(Null)("numofcomment") = cStr(0)	'상품후기수
			Else
				objRst(Null)("numofcomment") = cStr(FItemList(iRows).FEvalcnt)	'상품후기수
			end if
			objRst(Null)("pojangok")   = FItemList(iRows).Fpojangok
			objRst(Null)("dispcate")   = cStr(FItemList(iRows).FCateCode)
			'// 상품후기 평점 별4->5로 변경되면서 2.493 이전버전은 리스트에 별점 표시 안함
			if CDbl(FVerNm)<2.493 then
				objRst(Null)("evaltotalpoint")   = cStr(0)	'### 상품후기별 total 백분율 환산.
			Else
				objRst(Null)("evaltotalpoint")   = cStr(fnEvalTotalPointAVG(FItemList(iRows).FPoints,"search"))	'### 상품후기별 total 백분율 환산.
			End If
			'// 해외직구
			objRst(Null)("deliverfixday") = CStr(FItemList(iRows).FDeliverFixDay)
			'// 무료배송
			objRst(Null)("freedeliveryyn") = CStr(FItemList(iRows).FFreeDeliveryYN)
			'// 성인상품
			objRst(Null)("isAdultProduct") = isAdultProduct
			
			'// 카테고리 1depth명
			If Trim(FItemList(iRows).FCateName) <> "" Then
				objRst(Null)("categoryname1depth") = CStr(Split(FItemList(iRows).FCateName,"^^")(0))
			End If


			If FItemList(iRows).isSoldOut Then
				objRst(Null)("issoldout")  = cStr("Y")
			Else
				objRst(Null)("issoldout")  = cStr("N")
			End If
            
			IF FItemList(iRows).IsCouponItem AND FItemList(iRows).Fitemcoupontype = "3" Then	'### 무료배송쿠폰 있는지
				objRst(Null)("freedeliverycoupon")   = cStr("Y")
			Else
				objRst(Null)("freedeliverycoupon")   = cStr("N")
			End If
			
			If InStr(vMyCItem,"item"&FItemList(iRows).FItemID) > 0 Then	'### 상품비교에 있는 상품인지
				objRst(Null)("ismycompareitem")   = cStr("Y")
			Else
				objRst(Null)("ismycompareitem")   = cStr("N")
			End If
           
			'딜상품 여부(2018-01-02; 허진원)
			objRst(Null)("isDealItem")   = chkIIF(FItemList(iRows).FItemDiv="21",cStr("Y"),cStr("N"))

			' 딜상품 후기점수, 후기수, 위시수 IOS 2.524 버전부터 지원
			if FAppKey="5"  and FItemList(iRows).FItemDiv="21" and FVerCd<"2.524" then 	'' ios이면서 2.524 미만 버전 APP인경우 0 으로 반환
				objRst(Null)("numofcomment") = cStr(0)	'상품후기수
				objRst(Null)("evaltotalpoint")   = cStr(0)	'### 상품후기별 total 백분율 환산.
				objRst(Null)("numofwish") = cStr(0)		'위시수
			End If

			'//2017년 리뉴얼 json
			if ((FAppKey="6") and (FVerCd>="99")) or ((FAppKey="5") and (FVerCd>="2.13")) then  ''안드로이드 99버전부터 , ios 2.13 부터 2017-10-11

				If FItemList(iRows).IsSaleItem AND FItemList(iRows).isCouponItem Then
					
					'#################################### [쿠폰 O 세일 O] ###########################################
					objRst(Null)("normalprice") = CStr(FormatNumber(FItemList(iRows).GetCouponAssignPrice,0))
					objRst(Null)("normalcurrency") = CStr("원")
					objRst(Null)("salevalue") = CStr(Replace(Replace(FItemList(iRows).getSalePro,"[",""),"]",""))
					
					If FItemList(iRows).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
						If InStr(FItemList(iRows).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
							objRst(Null)("couponvalue") = CStr("")
						Else
							objRst(Null)("couponvalue") = CStr(Replace(Replace(FItemList(iRows).GetCouponDiscountStr,"[",""),"]",""))
						End If
						objRst(Null)("couponstring") = CStr("쿠폰")
					Else
						objRst(Null)("couponvalue") = CStr("")
						objRst(Null)("couponstring") = CStr("")
					End If
					'###############################################################################################
					
				ElseIf FItemList(iRows).IsSaleItem AND (Not FItemList(iRows).isCouponItem) Then
					
					'#################################### [쿠폰 X 세일 O] ###########################################
					objRst(Null)("normalprice") = CStr(FormatNumber(FItemList(iRows).getRealPrice,0))
					objRst(Null)("normalcurrency") = CStr("원")
					objRst(Null)("salevalue") = CStr(Replace(Replace(FItemList(iRows).getSalePro,"[",""),"]",""))
					objRst(Null)("couponvalue") = CStr("")
					objRst(Null)("couponstring") = CStr("")
					'###############################################################################################
					
				ElseIf FItemList(iRows).isCouponItem AND (NOT FItemList(iRows).IsSaleItem) Then
					
					'#################################### [쿠폰 O 세일 X] ###########################################
					objRst(Null)("normalprice") = CStr(FormatNumber(FItemList(iRows).GetCouponAssignPrice,0))
					objRst(Null)("normalcurrency") = CStr("원")
					objRst(Null)("salevalue") = CStr("")
					
					If FItemList(iRows).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
						If InStr(FItemList(iRows).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
							objRst(Null)("couponvalue") = CStr("")
						Else
							objRst(Null)("couponvalue") = CStr(Replace(Replace(FItemList(iRows).GetCouponDiscountStr,"[",""),"]",""))
						End If
						objRst(Null)("couponstring") = CStr("쿠폰")
					Else
						objRst(Null)("couponvalue") = CStr("")
						objRst(Null)("couponstring") = CStr("")
					End If
					'###############################################################################################
					
				Else
					
					'#################################### [쿠폰 X 세일 X] ###########################################
					objRst(Null)("normalprice") = CStr(FormatNumber(FItemList(iRows).getRealPrice,0))
					objRst(Null)("normalcurrency") = CStr(CHKIIF(FItemList(iRows).IsMileShopitem,"Point","원"))
					objRst(Null)("salevalue") = CStr("")
					objRst(Null)("couponvalue") = CStr("")
					objRst(Null)("couponstring") = CStr("")
					'###############################################################################################
					
				End If
				
				objRst(Null)("saleprice") = CStr("")
				objRst(Null)("couponprice") = CStr("")

				'텐텐딜 상품이면 할인율 표시
				if FItemList(iRows).FItemDiv="21" and FItemList(iRows).FOptionCnt>0 then
					objRst(Null)("normalcurrency") = CStr("원~")
					objRst(Null)("salevalue") = CStr(FItemList(iRows).FOptionCnt & "%")
				end if
			Else
				
				IF FItemList(iRows).IsSaleItem or FItemList(iRows).isCouponItem Then
					objRst(Null)("normalprice") = CStr("")
					objRst(Null)("normalcurrency") = CStr("")
					IF FItemList(iRows).IsSaleItem Then
						objRst(Null)("saleprice") = CStr(FItemList(iRows).getRealPrice)
						objRst(Null)("salevalue") = CStr(Replace(Replace(FItemList(iRows).getSalePro,"[",""),"]",""))
					Else
						objRst(Null)("saleprice") = CStr(FItemList(iRows).getRealPrice) ''CStr("")
						objRst(Null)("salevalue") = CStr(Replace(Replace(FItemList(iRows).getSalePro,"[",""),"]","")) ''CStr("")
					End IF
					IF FItemList(iRows).IsCouponItem AND FItemList(iRows).Fitemcoupontype <> "3" Then
						if (FRectThumbMode="S") then
							objRst(Null)("saleprice") = CStr(FItemList(iRows).GetCouponAssignPrice)
						end if
						objRst(Null)("couponprice") = CStr(FItemList(iRows).GetCouponAssignPrice)
						objRst(Null)("couponvalue") = CStr(Replace(Replace(FItemList(iRows).GetCouponDiscountStr,"[",""),"]",""))
					Else
						objRst(Null)("couponprice") = CStr("")
						objRst(Null)("couponvalue") = CStr("")
					End IF
				Else
					objRst(Null)("normalprice") = CStr(FItemList(iRows).getRealPrice)
					objRst(Null)("normalcurrency") = CHKIIF(FItemList(iRows).IsMileShopitem,CStr("Point"),CStr("원")) 
					objRst(Null)("saleprice") = CStr("")
					objRst(Null)("salevalue") = CStr("")
					objRst(Null)("couponprice") = CStr("")
					objRst(Null)("couponvalue") = CStr("")
				End if
				objRst(Null)("couponstring") = CStr("")
			End If

		NEXT
		CALL Docruzer.EndSession()
		SET Docruzer = NOTHING

		'// JSON결과 반환
		set getSearchListJson2017 = objRst

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
				SortQuery = " GROUP BY cd1grp order by cd1grp " 
			Case "2"
				SortQuery = " GROUP BY cd2grp order by cd2grp "
			Case "3"
				SortQuery = " GROUP BY cd3grp order by cd3grp "
			Case Else
				SortQuery = " GROUP BY cd1grp order by cd1grp "
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
		
		If FRectIs2017 = "o" Then
			MaxCnt = 10
		End If

        Dim objRst : Set objRst = jsArray()
        
		SET Docruzer = Server.CreateObject("ATLKSearch.Client")
        
        IF NOT InitDocruzer(Docruzer) THEN
            SET getRecommendKeyWordsJson = objRst
		    SET Docruzer = Nothing
			EXIT Function
		END IF

        SvrAddr = getTimeChkAddr(G_4THSCH_ADDR) ''G_ORGSCH_ADDR  '' 106번으로 일단 G_2NDSCH_ADDR '' G_ORGSCH_ADDR

		ret = Docruzer.RecommendKeyWord _
						(SvrAddr&":"&SvrPort,_
						arrSize,arrData,_
						MaxCnt,replace(FRectSearchTxt," ",""),3)

		IF( ret < 0 ) THEN
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING
			SET getRecommendKeyWordsJson = objRst
			EXIT FUNCTION

		END IF

        Dim tempcount 
        tempcount  = Ubound(arrData)
        
        If tempcount > 1 Then
	        For iRows=0 To tempcount
	            Set objRst(Null) = jsObject()
	            objRst(null)("keyword") = cStr(arrData(iRows))
	            'objRst(null)("keyword") = cStr(SvrAddr)
	        Next
    	End If
        
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
		
        SvrAddr = getTimeChkAddr(G_4THSCH_ADDR) ''G_ORGSCH_ADDR  '' 106번으로 일단 G_2NDSCH_ADDR ''  G_ORGSCH_ADDR

		ret = Docruzer.getPopularKeyword _
						(SvrAddr&":"&SvrPort,_
						arrSize,arrData,_
						MaxCnt,4)
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
		
        SvrAddr = getTimeChkAddr(G_4THSCH_ADDR) ''G_ORGSCH_ADDR  '' 106번으로 일단 G_2NDSCH_ADDR ''  G_ORGSCH_ADDR

		'인기 검색어 (추가정보)
		ret = Docruzer.getPopularKeyword2 _
						(SvrAddr&":"&SvrPort,_
						arrSize,arrData,arrTag,_
						MaxCnt,4)

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
		
        SvrAddr = getTimeChkAddr(G_4THSCH_ADDR) ''G_ORGSCH_ADDR  '' 106번으로 일단 G_2NDSCH_ADDR ''  G_ORGSCH_ADDR

		'자동완성 검색
		ret = Docruzer.CompleteKeyword( _
					SvrAddr & ":" & SvrPort _
					,kwd_count, kwd_list, cnv_str, max_count, seed_str, nFlag, 4)
					

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
        
        Dim Ibrandid,Ibrandname,Iisbestbrand,Iitemcnt
		FOR iRows = 0 to FResultcount -1

			ret = Docruzer.GetResult_Row( arrData, arrSize, iRows )

			IF( ret < 0 ) THEN
				'Response.write "GetResult_Row: " & Docruzer.msg
				EXIT FOR
			END IF
            
            Ibrandid        = arrData(0)
            Ibrandname      = arrData(1)
            Iisbestbrand    = arrData(4)
            Iitemcnt        = Scores(iRows)
            
            if (Ibrandid<>"") and (Ibrandname<>"") and (Iisbestbrand<>"") and (Iitemcnt>0) then
            Set objRst(Null) = jsObject()
                objRst(Null)("brandid") = Ibrandid
                objRst(Null)("brandname") = Ibrandname
                objRst(Null)("isbestbrand") = Iisbestbrand
                
                objRst(Null)("itemcnt") = Iitemcnt  ''2015 protoV3 추가
            end if
                
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
	
	
	'####### 상품 검색 이벤트 리스트  ###### Protocol V3 추가
	PUBLIC FUNCTION getEventListJson
	    dim Scn : Scn= "scn_dt_event2015" 		'// 검색 결과 출력 시나리오명
		dim Logs
		dim Docruzer,ret
		dim iRows
		dim arrData,arrSize

		dim FseekTime
        dim objTitle, vEvt_code, vEnm, vEnm_title, vEnm_Add, vEnm_Addcolor, vEvt_kind, vbrandID, vevt_LinkType, vEvt_bannerLink
        dim vIssale,vIscoupon,visgift,visItemps,viscomment,visoneplusone
        
        Dim objRst : Set objRst = jsArray()
        
		StartNum = 0	'// 검색시작 Row
		'// 검색 쿼리생성 (이벤트는 제외어 검색 하지말것 서버죽음 ㄷㄷ)
		'IF FRectExceptText<>"" Then
		'	SearchQuery = " (idx_eventKeyword='" & FRectSearchTxt & " ! " & FRectExceptText & "' BOOLEAN) "	'제외어
		'else
			SearchQuery = " idx_eventKeyword='" & FRectSearchTxt & "'  allword "	'키워드검색
		'End if

		SearchQuery = SearchQuery &_
					" and evt_state='7' " &_
					" and evt_startdate<='" & Replace(date(),"-","") & "000000' " &_
					" and evt_enddate>='" & Replace(date(),"-","") & "000000' "

		Select Case FRectChannel
			Case "W"
				SearchQuery = SearchQuery & " and idx_evt_isWeb=1 "
			Case "M"
				SearchQuery = SearchQuery & " and idx_evt_isMobile=1 "
			Case "A"
				SearchQuery = SearchQuery & " and idx_evt_isApp=1 "
			Case Else
				SearchQuery = SearchQuery & " and idx_evt_isMobile=1 "
		End Select

		'//그룹 범위별 지정(정렬 쿼리 생성)
		SortQuery = "Order by evt_startdate desc "

		dim Rowids,Scores

		SET Docruzer = Server.CreateObject("ATLKSearch.Client")

		IF NOT InitDocruzer(Docruzer) THEN
		    SET getEventListJson = objRst
		    SET Docruzer = Nothing
			EXIT FUNCTION
		END IF

		ret = Docruzer.SubmitQuery(SvrAddr, SvrPort, _
						AuthCode, Logs, Scn, _
						SearchQuery,SortQuery, _
						FRectSearchTxt,StartNum, FPageSize, _
						Docruzer.LC_KOREAN, Docruzer.CS_UTF8)

		If( ret < 0 ) Then
			CALL Docruzer.EndSession()
			SET getEventListJson = objRst
			SET Docruzer = NOTHING
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
            
            '이벤트 링크
''			IF oGrEvt.FItemList(lp).Fevt_kind="16" Then		'#브랜드할인이벤트(16)
''				vLink = "/street/street_brand.asp?makerid=" & oGrEvt.FItemList(lp).Fbrand
''				vEnm = split(oGrEvt.FItemList(lp).Fevt_name,"|")(0)
''			Else
''				vEnm = db2html(oGrEvt.FItemList(lp).Fevt_name)
''				if ubound(Split(vEnm,"|"))> 0 Then
''					If oGrEvt.FItemList(lp).Fissale Or (oGrEvt.FItemList(lp).Fissale And oGrEvt.FItemList(lp).Fiscoupon) then
''						vEnm	= cStr(Split(vEnm,"|")(0)) &" <span style=color:red>"&cStr(Split(vEnm,"|")(1))&"</span>"
''					ElseIf oGrEvt.FItemList(lp).Fiscoupon Then
''						vEnm	= cStr(Split(vEnm,"|")(0)) &" <span style=color:green>"&cStr(Split(vEnm,"|")(1))&"</span>"
''					End If 			
''				end If
''
''				IF oGrEvt.FItemList(lp).Fevt_LinkType="I" and oGrEvt.FItemList(lp).Fevt_bannerLink<>"" THEN		'#별도 링크타입
''					vLink = "top.location.href='" & oGrEvt.FItemList(lp).Fevt_bannerLink & "';"
''				Else
''					vLink = "TnGotoEventMain('" & oGrEvt.FItemList(lp).Fevt_code & "');"
''				End If
''			End If
''
''			'추가 태그
''			If oGrEvt.FItemList(lp).Fisgift AND vIcon = "" Then vIcon = " <span class=""cGr2"">GIFT</span>" End IF
''			If oGrEvt.FItemList(lp).FisItemps=1 or oGrEvt.FItemList(lp).Fiscomment=1 AND vIcon = "" Then vIcon = " <span class=""cBl2"">참여</span>" End IF
''			If oGrEvt.FItemList(lp).Fisoneplusone AND vIcon = "" Then vIcon = " <span class=""cGr2"">1+1</span>" End IF
							
                vEvt_code			= arrData(0)
                vEnm                     = arrData(11)
                vEvt_kind                = arrData(4)
                vbrandID                 = arrData(5)
                vEvt_LinkType            = arrData(6)
                vEvt_bannerLink          = arrData(7)
                
                vIssale = arrData(14)
                vIscoupon = arrData(17)
                visgift = arrData(15)
                visItemps = arrData(16)
                viscomment = arrData(22)
                visoneplusone = arrData(19)
                
                if ubound(Split(vEnm,"|"))> 0 Then
                    vEnm_title  = cStr(Split(vEnm,"|")(0))
                    vEnm_Add    = cStr(Split(vEnm,"|")(1))
                    if (vIssale=1) then
                        vEnm_Addcolor = "#FF0000"
                    elseif (vIscoupon=1) then
                        vEnm_Addcolor = "#00FF00"
                    end if
                else
                    vEnm_title = Trim(vEnm)               
                end if
                
                vEnm_title = stripHTML(vEnm_title)
                
                IF (vEnm_title<>"") and (arrData(24)<>"") and (arrData(13)<>"") and (vEnm_title<>"") then  ''2015/10/09 추가 evt_bannerimg 없어서 크래시
                    Set objRst(Null) = jsObject()
                    
                    objRst(Null)("evt_code") = arrData(0)
                    objRst(Null)("evt_bannerimg") = arrData(24)
    '                if (vEvt_kind="16") and (vbrandID<>"") then
    '                    objRst(Null)("evt_bannerlink") = "tenwishapp://App_brand?brandid="&vbrandID
    '                else
    '                    if (vevt_LinkType="I") and (vEvt_bannerLink<>"") then
    '                        objRst(Null)("evt_bannerlink") = vEvt_bannerLink
    '                    else
    '                        objRst(Null)("evt_bannerlink") = "http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&vEvt_code
    '                    end if
    '                end if
                    objRst(Null)("evt_bannerlink") = "http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&vEvt_code
                    objRst(Null)("evt_subcopy") = arrData(13)
                    
                    Set objTitle = jsArray()
                    SET objTitle(Null) = jsObject()
                    objTitle(Null)("title") = vEnm_title
                    objTitle(Null)("color") = "#000000"
                    
                    if (vEnm_Add<>"") and (vEnm_Addcolor<>"") then
                        SET objTitle(Null) = jsObject()
                        objTitle(Null)("title") = vEnm_Add
                        objTitle(Null)("color") = vEnm_Addcolor
                    end if
                    
                    if (visgift=1) then
                        SET objTitle(Null) = jsObject()
                        objTitle(Null)("title") = "GIFT"
                        objTitle(Null)("color") = "#1FBCB6"
                    end if
                    
                    if (visItemps=1) or (viscomment=1) then 
                        SET objTitle(Null) = jsObject()
                        objTitle(Null)("title") = "참여"
                        objTitle(Null)("color") = "#18b1d7"
                    end if
                    
                    if (visoneplusone=1) then 
                        SET objTitle(Null) = jsObject()
                        objTitle(Null)("title") = "1+1"
                        objTitle(Null)("color") = "#1FBCB6"
                    end if
                    
                    SET objRst(Null)("evt_title") = objTitle
                    
                    objRst(Null)("openType") = "OPEN_TYPE__FROM_RIGHT"
                    objRst(Null)("ltbs") = array()
                    objRst(Null)("title") = "이벤트"
                    objRst(Null)("rtbs") = array("BTN_TYPE__SHARE","BTN_TYPE__CART")
                    
                    objRst(Null)("pageType") = "event"
                end if
                
                
'			SET FItemList(iRows) = new SearchEventItems
'				FItemList(iRows).Fevt_code			= arrData(0)
'				FItemList(iRows).Fevt_bannerimg		= arrData(24) ''(pcWeb:1,M/A:24)
'				FItemList(iRows).Fevt_startdate		= dateSerial(left(arrData(2),4),mid(arrData(2),5,2),right(arrData(2),2))	'### ASP 날짜형태로 변환
'				FItemList(iRows).Fevt_enddate		= dateSerial(left(arrData(3),4),mid(arrData(3),5,2),right(arrData(3),2))	'### ASP 날짜형태로 변환
'				FItemList(iRows).Fevt_kind			= arrData(4)
'				FItemList(iRows).Fbrand				= arrData(5)
'				FItemList(iRows).Fevt_LinkType		= arrData(6)
'				FItemList(iRows).Fevt_bannerlink	= arrData(7)
'				FItemList(iRows).Fetc_itemid		= arrData(8)
'				FItemList(iRows).Fetc_itemimg		= arrData(9)
'				FItemList(iRows).Ficon1image		= arrData(10)
'				FItemList(iRows).Fevt_name			= arrData(11)
'				FItemList(iRows).Fevt_tag			= arrData(12)
'				FItemList(iRows).Fevt_subcopyK		= arrData(13)
'				FItemList(iRows).Fissale			= arrData(14)
'				FItemList(iRows).Fisgift			= arrData(15)
'				FItemList(iRows).Fisitemps			= arrData(16)
'				FItemList(iRows).Fiscoupon			= arrData(17)
'				FItemList(iRows).FisOnlyTen			= arrData(18)
'				FItemList(iRows).Fisoneplusone		= arrData(19)
'				FItemList(iRows).Fisfreedelivery	= arrData(20)
'				FItemList(iRows).Fisbookingsell		= arrData(21)
'				FItemList(iRows).Fiscomment			= arrData(22)
'				FItemList(iRows).Fevt_state			= arrData(23)

			SET arrData = NOTHING
			SET arrSize = NOTHING

		NEXT
        
        SET getEventListJson = objRst
        
		SET Rowids= NOTHING
		SET Scores= NOTHING

		CALL Docruzer.EndSession()
		SET Docruzer = NOTHING
	End FUNCTION
	
End Class


'###############################
'### 이벤트 검색             ###
'###############################

Class SearchEventItems

	Private SUB Class_initialize()

	End SUB

	Private SUB Class_Terminate()

	End SUB

	PUBLIC Fevt_code
	PUBLIC Fevt_bannerimg
	PUBLIC Fevt_startdate
	PUBLIC Fevt_enddate
	PUBLIC Fevt_kind
	PUBLIC Fbrand
	PUBLIC Fevt_LinkType
	PUBLIC Fevt_bannerlink
	PUBLIC Fetc_itemid
	PUBLIC Fetc_itemimg
	PUBLIC Ficon1image
	PUBLIC Fevt_name
	PUBLIC Fevt_tag
	PUBLIC Fevt_subcopyK
	PUBLIC Fissale
	PUBLIC Fisgift
	PUBLIC Fisitemps
	PUBLIC Fiscoupon
	PUBLIC FisOnlyTen
	PUBLIC Fisoneplusone
	PUBLIC Fisfreedelivery
	PUBLIC Fisbookingsell
	PUBLIC Fiscomment
	PUBLIC Fevt_state
	'// 검색결과 이벤트 배너영역 수정
	Public Fevt_subname

End Class

Class SearchEventCls
    ''검색페이지 이벤트.
	Private SUB Class_initialize()

        '' 기본 1차서버--------------------------------------------------------------------------------------------
		SvrAddr = getTimeChkAddr(G_4THSCH_ADDR)
		''---------------------------------------------------------------------------------------------------------

		SvrPort = "6167"'DocSvrPort
		AuthCode = "" '인증값
		Logs = "" '로그값

		FResultCount = 0
		FTotalCount = 0
		FPageSize = 10
		FCurrPage = 1
		FPageSize = 30

	End SUB

	Private SUB Class_Terminate()

	End SUB

	dim FItemList
	dim FPageSize
	dim FCurrPage
	dim FScrollCount
	dim FResultCount
	dim FTotalCount
	dim FTotalPage
	dim FRectSearchTxt		'검색어
	dim FRectExceptText		'제외어
	dim FRectChannel		'검색 채널 (W:isWeb, M:isMobile, A:isApp)
	dim FRectGubun
	dim FRectStartNum		'검색 수동 시작지점 (페이지 별로 사이즈가 다른경우 사용)

	Private SvrAddr
	Private SvrPort
	Private AuthCode
	Private Logs
	Private Scn
	private strQuery
	Private Order
	Private StartNum
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
    
    
	'####### 이벤트 검색 ######

	PUBLIC SUB getEventList()

		dim Scn : Scn= "scn_dt_event2015" 		'// 검색 결과 출력 시나리오명
		dim Logs
		dim Docruzer,ret
		dim iRows
		dim arrData,arrSize

		dim FseekTime

		if FRectStartNum="" then
			StartNum = (FCurrPage -1)*FPageSize	'// 검색시작 Row
		else
			StartNum = FRectStartNum
		end if
		'// 검색 쿼리생성 (이벤트는 제외어 검색 하지말것 서버죽음 ㄷㄷ)
		'IF FRectExceptText<>"" Then
		'	SearchQuery = " (idx_eventKeyword='" & FRectSearchTxt & " ! " & FRectExceptText & "' BOOLEAN) "	'제외어
		'else
			SearchQuery = " idx_eventKeyword='" & FRectSearchTxt & "'  allword "	'키워드검색
		'End if

		SearchQuery = SearchQuery &_
					" and idx_evt_state='7' " &_
					" and idx_evt_startdate<='" & Replace(date(),"-","") & "000000' " &_
					" and idx_evt_enddate>='" & Replace(date(),"-","") & "000000' "
					
		If FRectGubun = "mktevt" Then
				SearchQuery = SearchQuery & " and idx_evt_kind = '28' "
		Else FRectGubun = "planevt"
				SearchQuery = SearchQuery & " and (idx_evt_kind = '1' or idx_evt_kind = '19' or idx_evt_kind = '29' or idx_evt_kind = '13') "
		End If
'response.write SearchQuery
		Select Case FRectChannel
			Case "W"
				SearchQuery = SearchQuery & " and idx_evt_isWeb=1 "
			Case "M"
				SearchQuery = SearchQuery & " and idx_evt_isMobile=1 "
			Case "A"
				SearchQuery = SearchQuery & " and idx_evt_isApp=1 "
			Case Else
				SearchQuery = SearchQuery & " and idx_evt_isMobile=1 "
		End Select

		'//그룹 범위별 지정(정렬 쿼리 생성)
		SortQuery = "Order by evt_startdate desc "

		dim Rowids,Scores

		SET Docruzer = Server.CreateObject("ATLKSearch.Client")

		IF NOT InitDocruzer(Docruzer) THEN
		    SET Docruzer = Nothing
			EXIT SUB
		END IF

		ret = Docruzer.SubmitQuery(SvrAddr, SvrPort, _
						AuthCode, Logs, Scn, _
						SearchQuery,SortQuery, _
						FRectSearchTxt,StartNum, FPageSize, _
						Docruzer.LC_KOREAN, Docruzer.CS_UTF8)
'Response.write "GetResult_Row: " & ret
		If( ret < 0 ) Then
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING
			EXIT SUB
		END IF


		Call Docruzer.GetResult_RowSize(FResultcount) '검색 결과 수
		Call Docruzer.GetResult_Rowid(Rowids,Scores)

		REDIM FItemList(FResultCount)

		Call Docruzer.GetResult_TotalCount(FTotalCount) '검색결과 총 수
'Response.write "GetResult_Row: " & FTotalCount
		FOR iRows = 0 to FResultcount -1

			ret = Docruzer.GetResult_Row( arrData, arrSize, iRows )

			IF( ret < 0 ) THEN
				'Response.write "GetResult_Row: " & Docruzer.msg
				EXIT FOR
			END IF

			SET FItemList(iRows) = new SearchEventItems
				FItemList(iRows).Fevt_code			= arrData(0)
				FItemList(iRows).Fevt_bannerimg		= arrData(24) ''(pcWeb:1,M/A:24)
				FItemList(iRows).Fevt_startdate		= dateSerial(left(arrData(2),4),mid(arrData(2),5,2),right(arrData(2),2))	'### ASP 날짜형태로 변환
				FItemList(iRows).Fevt_enddate		= dateSerial(left(arrData(3),4),mid(arrData(3),5,2),right(arrData(3),2))	'### ASP 날짜형태로 변환
				FItemList(iRows).Fevt_kind			= arrData(4)
				FItemList(iRows).Fbrand				= arrData(5)
				FItemList(iRows).Fevt_LinkType		= arrData(6)
				FItemList(iRows).Fevt_bannerlink	= arrData(7)
				FItemList(iRows).Fetc_itemid		= arrData(8)
				FItemList(iRows).Fetc_itemimg		= arrData(9)
				FItemList(iRows).Ficon1image		= arrData(10)
				FItemList(iRows).Fevt_name			= arrData(11)
				FItemList(iRows).Fevt_tag			= arrData(12)
				FItemList(iRows).Fevt_subcopyK		= arrData(13)
				FItemList(iRows).Fissale			= arrData(14)
				FItemList(iRows).Fisgift			= arrData(15)
				FItemList(iRows).Fisitemps			= arrData(16)
				FItemList(iRows).Fiscoupon			= arrData(17)
				FItemList(iRows).FisOnlyTen			= arrData(18)
				FItemList(iRows).Fisoneplusone		= arrData(19)
				FItemList(iRows).Fisfreedelivery	= arrData(20)
				FItemList(iRows).Fisbookingsell		= arrData(21)
				FItemList(iRows).Fiscomment			= arrData(22)
				FItemList(iRows).Fevt_state			= arrData(23)
				'// 검색결과 이벤트 배너영역 수정
				FItemList(iRows).Fevt_subname		= arrData(28)
			SET arrData = NOTHING
			SET arrSize = NOTHING

		NEXT

		SET Rowids= NOTHING
		SET Scores= NOTHING

		CALL Docruzer.EndSession()
		SET Docruzer = NOTHING

	End SUB


	PUBLIC FUNCTION HasPreScroll()
		HasPreScroll = StartScrollPage > 1
	END FUNCTION

	PUBLIC FUNCTION HasNextScroll()
		HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
	END FUNCTION

	PUBLIC FUNCTION StartScrollPage()
		StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	END FUNCTION
end Class


'###############################
'### 플레잉 전체 리스트 검색   ###
'###############################

Class SearchPlayingItems

	Private SUB Class_initialize()

	End SUB

	Private SUB Class_Terminate()

	End SUB

	PUBLIC Fdidx
	public Ftitle
	public Fpc_bgcolor
	PUBLIC Fmo_bgcolor
	PUBLIC Fstate
	PUBLIC Fstartdate
	PUBLIC Ftitlestyle
	PUBLIC Fsubcopy
	PUBLIC Fkeyword
	PUBLIC Fimg28

End Class

Class SearchPlayingCls
    ''검색페이지 이벤트.
	Private SUB Class_initialize()

        '' 기본 1차서버--------------------------------------------------------------------------------------------
		SvrAddr = getTimeChkAddr(G_4THSCH_ADDR)
		''---------------------------------------------------------------------------------------------------------

		SvrPort = "6167"'DocSvrPort
		AuthCode = "" '인증값
		Logs = "" '로그값

		FResultCount = 0
		FTotalCount = 0
		FPageSize = 10
		FCurrPage = 1
		FPageSize = 30

	End SUB

	Private SUB Class_Terminate()

	End SUB

	dim FItemList
	dim FPageSize
	dim FCurrPage
	dim FScrollCount
	dim FResultCount
	dim FTotalCount
	dim FTotalPage
	dim FRectSearchTxt		'검색어
	dim FRectExceptText		'제외어
	dim FRectWord
	dim FRectStartNum		'검색 시작지점 (페이지별로 사이즈가 다른 경우 사용)

	Private SvrAddr
	Private SvrPort
	Private AuthCode
	Private Logs
	Private Scn
	private strQuery
	Private Order
	Private StartNum
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
    
    
	'####### 플레잉 전체리스트 검색 ######
	PUBLIC SUB getPlayingList2017()

		dim Scn : Scn= "scn_dt_playing2017" 		'// 검색 결과 출력 시나리오명
		dim Logs
		dim Docruzer,ret
		dim iRows
		dim arrData,arrSize

		dim FseekTime

		if FRectStartNum="" then
			StartNum = (FCurrPage -1)*FPageSize	'// 검색시작 Row
		else
			StartNum = FRectStartNum
		end if

		If FRectSearchTxt <> "" Then
			SearchQuery = " idx_playingKeyword='" & FRectSearchTxt & "'  allword "	'키워드검색
		End If
		SearchQuery = SearchQuery &_
					" and idx_state='7' " &_
					" and idx_startdate<='" & Replace(date(),"-","") & "000000' "
'response.write SearchQuery
		'//그룹 범위별 지정(정렬 쿼리 생성)
		SortQuery = "Order by didx desc "

		dim Rowids,Scores

		SET Docruzer = Server.CreateObject("ATLKSearch.Client")

		IF NOT InitDocruzer(Docruzer) THEN
		    SET Docruzer = Nothing
			EXIT SUB
		END IF

		ret = Docruzer.SubmitQuery(SvrAddr, SvrPort, _
						AuthCode, Logs, Scn, _
						SearchQuery,SortQuery, _
						FRectSearchTxt,StartNum, FPageSize, _
						Docruzer.LC_KOREAN, Docruzer.CS_UTF8)

		If( ret < 0 ) Then
			'Response.write "GetResult_Row: " & Docruzer.msg
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING
			EXIT SUB
		END IF


		Call Docruzer.GetResult_RowSize(FResultcount) '검색 결과 수
		Call Docruzer.GetResult_Rowid(Rowids,Scores)

		REDIM FItemList(FResultCount)

		Call Docruzer.GetResult_TotalCount(FTotalCount) '검색결과 총 수
'response.write FResultCount
		FOR iRows = 0 to FResultcount -1

			ret = Docruzer.GetResult_Row( arrData, arrSize, iRows )

			IF( ret < 0 ) THEN
				'Response.write "GetResult_Row: " & Docruzer.msg
				EXIT FOR
			END IF

			SET FItemList(iRows) = new SearchPlayingItems
				FItemList(iRows).Fdidx			= arrData(0)
				FItemList(iRows).Ftitle			= arrData(1)
				FItemList(iRows).Fpc_bgcolor	= arrData(2)
				FItemList(iRows).Fmo_bgcolor	= arrData(3)
				FItemList(iRows).Fstate			= arrData(4)
				FItemList(iRows).Fstartdate		= arrData(5)
				FItemList(iRows).Ftitlestyle	= arrData(6)
				FItemList(iRows).Fsubcopy		= arrData(7)
				FItemList(iRows).Fkeyword		= arrData(8)
				FItemList(iRows).Fimg28			= arrData(9)

			SET arrData = NOTHING
			SET arrSize = NOTHING

		NEXT

		SET Rowids= NOTHING
		SET Scores= NOTHING

		CALL Docruzer.EndSession()
		SET Docruzer = NOTHING

	End SUB
	


	PUBLIC FUNCTION HasPreScroll()
		HasPreScroll = StartScrollPage > 1
	END FUNCTION

	PUBLIC FUNCTION HasNextScroll()
		HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
	END FUNCTION

	PUBLIC FUNCTION StartScrollPage()
		StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	END FUNCTION
end Class


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

'// 내 위시 상품 목록(검색 결과에서 상품목록 전송)
Sub getMyFavItemList2017(uid,iid,byRef sWArr)
  'Exit Sub ''사용안함 2014/09/23
	dim strSQL
	strSQL = "execute [db_my10x10].[dbo].[sp_Ten_MyWishSearchItemNew] '" & CStr(uid) & "', '" & cStr(iid) & "'"
	rsget.CursorLocation = adUseClient
	rsget.Open strSQL,dbget,adOpenForwardOnly,adLockReadOnly
	if Not(rsget.EOF or rsget.BOF) then
		sWArr = rsget.getRows()
	end if
	rsget.Close
end Sub

Function fnIsMyFavItem(arr,itemid)
Dim i, r
	r = False
	If isArray(arr) Then
		For i=0 To UBound(arr,2)
			If InStr((","&arr(0,i)&","),(","&itemid&",")) > 0 Then
				r = True
				Exit For
			End If
		Next
	End If
	fnIsMyFavItem = r
End Function

Function fnGetReplacementKeyword(k)
	dim Docruzer, seed_str, vResultWord
	'검색어 접수	
	seed_str = k
	vResultWord = ""
	
	'독크루저 컨퍼넌트 선언
	SET Docruzer = Server.CreateObject("ATLKSearch.Client")
	
	if Docruzer.BeginSession()<0 then
		'에러시 메세지 표시
		Response.Write "BeginSession: " & Docruzer.GetErrorMessage()
	else
    	dim ret, sDocSetOption
	    ret = Docruzer.SetOption(Docruzer.OPTION_REQUEST_CHARSET_UTF8,1)
	    sDocSetOption = (ret>=0)
	    
	    IF NOT sDocSetOption THEN
			Response.Write "SetOption: " & Docruzer.GetErrorMessage()
		ELSE
    		'실행
			Dim SvrAddr, SvrPort
			Dim i, nFlag, cnv_str, max_count
			Dim kwd_count, result_word
			Dim objXML, objXMLv
			ret = ""

			SvrAddr = getTimeChkAddr(G_3RDSCH_ADDR)

			' IF application("Svr_Info")	= "Dev" THEN
			'     ''SvrAddr = "110.93.128.108"''2차실서버
			' 	SvrAddr = "192.168.50.10"'DocSvrAddr(테섭)
			' 	'SvrAddr = "110.93.128.106"
			' ELSE
			' 	''SvrAddr = "192.168.0.109"'DocSvrAddr(실섭)
			' 	SvrAddr = "192.168.0.206"
			' 	'SvrAddr = "110.93.128.106"
			' END IF

			SvrPort = "6167"			'DocSvrPort

			max_count = 1	'최대 검색 수

			'대체 검색
			ret = Docruzer.SpellCheck( _
						SvrAddr & ":" & SvrPort _
						,kwd_count, result_word, max_count, seed_str)
			'Response.Write "check: " & kwd_count
			'에러 출력
			if(ret<0) then
				Response.Write "Error: " & Docruzer.GetErrorMessage()
			end if

			'-----프로세스 시작
			for i=0 to kwd_count-1
				vResultWord = result_word(i)
			next
				
    		Call Docruzer.EndSession()
    	End if
	end if
	
	'독크루저 종료
	Set Docruzer = Nothing

	fnGetReplacementKeyword = vResultWord
End Function
%>