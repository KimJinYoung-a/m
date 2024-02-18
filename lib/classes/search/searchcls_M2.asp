<%
'''--------------------------------------------------------------------------------------
Dim G_USE_MEMCACHE_SEARCH : G_USE_MEMCACHE_SEARCH = TRUE
Dim G_SEARCH_CACHE_TIME : G_SEARCH_CACHE_TIME = 600

DIM G_ORGSCH_ADDR
DIM G_1STSCH_ADDR
DIM G_2NDSCH_ADDR
DIM G_3RDSCH_ADDR
Dim G_4THSCH_ADDR

DIM G_SCH_TIME : G_SCH_TIME=formatdatetime(now(),4)

IF (application("Svr_Info") = "Dev") THEN
     G_1STSCH_ADDR = "61.252.133.4"  ''"110.93.128.109" ''
     G_2NDSCH_ADDR = "61.252.133.4"
     G_3RDSCH_ADDR = "61.252.133.4"
     G_4THSCH_ADDR = "61.252.133.4"
     G_ORGSCH_ADDR = "61.252.133.4"
ELSE
     G_1STSCH_ADDR = "192.168.0.110"        ''192.168.0.110  :: 검색페이지(search.asp)   '
     G_2NDSCH_ADDR = "192.168.0.107"        ''192.168.0.107  :: mobile
     G_3RDSCH_ADDR = "192.168.0.109"        ''192.168.0.109  :: GiftPlus , scn_dt_itemDispColor :: 확인.
     G_4THSCH_ADDR = "192.168.0.108"        ''192.168.0.108  :: 카테고리, 상품, 브랜드
     G_ORGSCH_ADDR = "192.168.0.106"
END IF

''sample in doc
function escapeQuery( istr )
	dim ret
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

function getTimeChkAddr(defaultAddr)
    '''6시10분 1차섭 인덱싱 및 2차서버로 Copy
    '''6시50분~ 1차=>3차서버로 Copy
    getTimeChkAddr = defaultAddr

    ''기본 무조건 G_2NDSCH_ADDR 인덱싱 시간에 G_4THSCH_ADDR
    IF (G_SCH_TIME>"06:10:00") and (G_SCH_TIME<"06:40:00") then
        getTimeChkAddr = G_2NDSCH_ADDR
    ELSE
        getTimeChkAddr = G_4THSCH_ADDR
    END IF

'    IF (defaultAddr=G_3RDSCH_ADDR) OR (defaultAddr=G_1STSCH_ADDR) THEN
'        IF (G_SCH_TIME>"06:45:00") and (G_SCH_TIME<"07:00:00") then
'            getTimeChkAddr = G_2NDSCH_ADDR
'        END IF
'    ELSE
'        IF (G_SCH_TIME>"06:10:00") and (G_SCH_TIME<"06:45:00") then
'            getTimeChkAddr = G_3RDSCH_ADDR
'        END IF
'    END IF


end function

function debugQuery(iDocruzer,Scn,iSearchQuery,iSortQuery,iFTotalCount,iFResultcount)
    exit function
    IF Not (application("Svr_Info")="Dev") THEN
        exit function
    ENd IF

    dim itime
    Call iDocruzer.GetResult_SearchTime(itime) '소요시간
    rw "-------------------------------"
    rw Scn
    rw iSearchQuery
    rw iSortQuery
    rw "FTotalCount:"&iFTotalCount
    rw "FResultcount:"&iFResultcount
    rw "GetResult_SearchTime:"&itime
end function
'''--------------------------------------------------------------------------------------


Class SearchGroupByItems

	Private SUB Class_initialize()

	End SUB

	Private SUB Class_Terminate()

	End SUB

	PUBLIC FImageSmall
	PUBLIC FSubTotal

	PUBLIC FCateCode
	PUBLIC FCateName
	PUBLIC FCateCd1
	PUBLIC FCateCd2
	PUBLIC FCateCd3
	PUBLIC FCateDepth

	PUBLIC FcolorCode
	PUBLIC FcolorName
	PUBLIC FcolorIcon

	PUBLIC FStyleCd
	PUBLIC FStyleName

	PUBLIC FAttribCd
	PUBLIC FAttribName

	PUBLIC FminPrice
	PUBLIC FmaxPrice

End Class

Class SearchItemCls

	Private SUB Class_initialize()
        ''기본 1차 서버.------------------------
		SvrAddr = getTimeChkAddr(G_1STSCH_ADDR)
		''--------------------------------------

		SvrPort = "6167"'DocSvrPort

		AuthCode = "" '인증값

		Logs = "" '로그값

		FResultCount = 0
		FTotalCount = 0
		FPageSize = 10
		FCurrPage = 1
		FPageSize = 30
		FRectColsSize =5
		FLogsAccept = false

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

	public function GetLevelUpCount()

		if (FCurrRank<FLastRank) then
			GetLevelUpCount = CStr(FLastRank-FCurrRank)
		elseif (FCurrRank=FLastRank) and (FLastRank=0) then
			GetLevelUpCount = ""
		elseif (FCurrRank=FLastRank) then
			GetLevelUpCount = ""
		elseif (FCurrRank>FLastRank) and (FLastRank=0) then
			GetLevelUpCount = ""
		else
			GetLevelUpCount = CStr(FCurrRank-FLastRank)
			if FCurrRank-FLastRank>=FCurrPos then
				GetLevelUpCount = ""
			end if
		end if
	end function

	public function GetLevelUpArrow()
		if (FCurrRank<FLastRank) then
			GetLevelUpArrow = "<img src='http://fiximage.10x10.co.kr/web2013/award/ico_rank_up.gif' alt='순위 상승' /> " & GetLevelUpCount()
		elseif (FCurrRank=FLastRank) and (FLastRank=0) then
			GetLevelUpArrow = ""
		elseif (FCurrRank=FLastRank) then
			'GetLevelUpArrow = "<img src='http://fiximage.10x10.co.kr/web2010/bestaward/ico_none.gif' align='absmiddle' style='display:inline;'> <font class='eng11px00'><b>0</b></font>"
			GetLevelUpArrow = ""
		elseif (FCurrRank>FLastRank) and (FLastRank=0) then
			GetLevelUpArrow = ""
		else
			GetLevelUpArrow = "<img src='http://fiximage.10x10.co.kr/web2013/award/ico_rank_down.gif' alt='순위 하락' /> " & GetLevelUpCount()
			if FCurrRank-FLastRank>=FCurrPos then
				'GetLevelUpArrow = "<font class='eng11px00'><b>0</b></font>"
				GetLevelUpArrow = ""
			end if
		end if
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
			FRectSearchTxt = chgCoinedKeyword(FRectSearchTxt)
			IF FRectExceptText<>"" Then
				strQue = getQrCon(strQue) & "(idx_itemname='" & FRectSearchTxt & " ! " & FRectExceptText & "' BOOLEAN) "	'제외어
			else
				strQue = getQrCon(strQue) & "idx_itemname='" & FRectSearchTxt & "'  allword "	'키워드검색(동의어 포함) synonym
				'strQue = getQrCon(strQue) & "idx_itemname='" & FRectSearchTxt & "'  natural "		'자연어 검색(동의어 포함) synonym
			End if
		END IF

		'@ 카테고리 검색 범위
		IF FRectSearchItemDiv="y" Then
			''strQue = strQue & getQrCon(strQue) & "idx_isDefault='y' "
		END IF

		'@ 카테고리
		IF FRectCateCode<>"" Then
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
					strQue = strQue & " idx_catecode='" & LCase(trim(arrCt(lpCt))) & "' "
				else
					strQue = strQue & " idx_catecode like '" & LCase(trim(arrCt(lpCt))) & "*' "
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
				strQue = strQue & " idx_makerid='" & LCase(trim(arrMkr(lpMkr))) & "'  "
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
				strQue = strQue & getQrCon(strQue) & "("
				for lp=0 to ubound(arrCCD)
					if getNumeric(arrCCD(lp))<>"" then
						if lp>0 then strQue = strQue & " or "
						strQue = strQue & "idx_colorCd='" & getNumeric(arrCCD(lp)) & "'"
					end if
				next
				strQue = strQue & ")"
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
				strQue = strQue & getQrCon(strQue) & "("
				for lp=0 to ubound(arrSCD)
					if getNumeric(arrSCD(lp))<>"" then
						if lp>0 then strQue = strQue & " or "
						strQue = strQue & "idx_styleCd='" & getNumeric(arrSCD(lp)) & "'"
					end if
				next
				strQue = strQue & ")"
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
				strQue = strQue & getQrCon(strQue) & "("
				for lp=0 to ubound(arrACD)
					if getNumeric(arrACD(lp))<>"" then
						if lp>0 then strQue = strQue & " or "
						strQue = strQue & "idx_attribCd='" & getNumeric(arrACD(lp)) & "'"
					end if
				next
				strQue = strQue & ")"
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

		query = strQue
	End FUNCTION

	Sub getSortQuery(byref query)
		dim strQue

		'// 중복 상품 제거(중복 등록 카테고리일경우)
		IF (FRectCateCode<>"" and FRectSearchItemDiv<>"y") Then '' 추가 카테고리 검색시
    		strQue = " GROUP BY itemid"
    	END IF

		'// 정렬
		IF FRectSortMethod="ne" THEN '신상품
			strQue = strQue & " ORDER BY itemid desc"
		ELSEIF FRectSortMethod="be" THEN '인기상품
			strQue = strQue & " ORDER BY itemscore desc,itemid desc"
		ELSEIF FRectSortMethod="lp" THEN '낮은가격
			strQue = strQue & " ORDER BY sellcash "
		ELSEIF FRectSortMethod="hp" THEN'높은가격
			strQue = strQue & " ORDER BY sellcash desc"
		ELSEIF FRectSortMethod="hs" THEN '핫세일 (할인율이 높은순)
			strQue = strQue & " ORDER BY SalePercent desc, salePrice desc"
		ELSEIF FRectSortMethod="br" THEN '베스트후기순
			strQue = strQue & " ORDER BY EvalCnt desc,itemid desc"
		ELSEIF FRectSortMethod="ws" THEN '위시순
			strQue = strQue & " ORDER BY favcount desc,itemid desc"
		ELSE
			strQue = strQue & " ORDER BY itemid desc"
		END IF
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
	PUBLIC SUB getSearchList()

		DIM Scn
		DIM Docruzer,ret

		DIM Logs ,iRows
		DIM arrData,arrSize

		'// 검색 결과 출력 시나리오명
		if FcolorCode="" or FcolorCode="0" then
			Scn= "scn_dt_itemDisp"		'일반 상품 검색
		else
			'Scn= "scn_dt_itemColor"		'상품 컬러별 검색
			Scn= "scn_dt_itemDispColor"		'상품 컬러별 검색(전시카테고리)
		end if

		StartNum = (FCurrPage -1)*FPageSize '// 검색시작 Row

		CALL getSearchQuery(SearchQuery)	'// 검색 쿼리생성
		CALL getSortQuery(SortQuery)		'// 정렬 쿼리 생성
		''Response.Write SearchQuery &"<Br>"
		IF SearchQuery="" THEN
			EXIT SUB
		END IF

		IF FLogsAccept THEN
            Logs = ("상품+^" & FRectSearchTxt & "]##" & FRectSearchTxt & "||" & FRectPrevSearchTxt ) 	'// 로그값
		END IF

        ''상품검색/브랜드검색이 아닌경우 2차서버로.
        ''---------------------------------------------------------------------------------------------------------
        if (FRectCateCode<>"") or (FRectMakerid<>"") and (FRectSearchTxt="")  then
            'response.write "2차서버<br>"
             SvrAddr = getTimeChkAddr(G_2NDSCH_ADDR) 
        end if
        ''칼라칩검색/브랜드검색 3차
        if (Scn= "scn_dt_itemDispColor") or (FRectMakerid<>"") then
        	'response.write "3차서버<br>"
        	SvrAddr = getTimeChkAddr(G_3RDSCH_ADDR)
        end if
        ''---------------------------------------------------------------------------------------------------------

		SET Docruzer = Server.CreateObject("ATLDocruzer_3_2.Client")

		IF ( Docruzer.BeginSession() < 0 ) THEN
			EXIT SUB
		END IF

		ret = Docruzer.SubmitQuery(SvrAddr, SvrPort, _
						AuthCode, Logs, Scn, _
						SearchQuery,SortQuery, _
						FRectSearchTxt,StartNum, FPageSize, _
						Docruzer.LC_KOREAN, Docruzer.CS_EUCKR)

		IF( ret < 0 ) THEN
			dbget.execute "EXECUTE db_log.dbo.sp_Ten_DocLog @ErrMsg ='"& html2db(SearchQuery) & "[" & html2db(Docruzer.GetErrorMessage()) &"]'"

			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING

			IF FListDiv<>"search" THEN
				'// 1번 서버 에서시 2번에서 구동(2번도 에러면 Skip)
				if (SvrAddr = G_1STSCH_ADDR) then
					SvrAddr = G_2NDSCH_ADDR  ''"192.168.0.108"
					if (G_1STSCH_ADDR<>G_2NDSCH_ADDR) then
					    call getSearchList()
				    end if
				end if
			END IF

			EXIT SUB
		END IF

		Call Docruzer.GetResult_TotalCount(FTotalCount) '검색결과 총 수
		Call Docruzer.GetResult_RowSize(FResultcount) '검색 결과 수
		'Response.write "검색결과수 : " & FTotalCount & "<br>"
		IF( FResultCount <= 0 ) THEN
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING
			EXIT SUB 'Response.write "GetResult_RowSize: " & Docruzer.GetErrorMessage()
		END IF

		FTotalPage =  Cdbl(FTotalCount\FPageSize)
		IF  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) THEN
			FtotalPage = FtotalPage +1
		END IF

		REDIM FItemList(FResultCount)

		FOR iRows=0 to FResultCount -1

			ret = Docruzer.GetResult_Row( arrData, arrSize, iRows )

			IF( ret < 0 ) THEN
				'Response.write "GetResult_Row: " & Docruzer.GetErrorMessage()
				EXIT FOR
			END IF

			SET FItemList(iRows) = NEW CCategoryPrdItem

				FItemList(iRows).FCateCode = arrData(0)
				FItemList(iRows).FItemDiv	= arrData(3)
				FItemList(iRows).FItemid = arrData(4)
				FItemList(iRows).FItemName = db2html(arrData(5))
				FItemList(iRows).FKeyWords = db2html(arrData(6))
				FItemList(iRows).FSellCash = arrData(7)
				FItemList(iRows).FOrgPrice = arrData(8)
				FItemList(iRows).FMakerId = arrData(9)
				FItemList(iRows).FBrandName = db2html(arrData(10))
				FItemList(iRows).FImageBasic 	= getItemImageUrl & "/basic/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(11))
				FItemList(iRows).FImageMask 	= getItemImageUrl & "/mask/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(12))
				FItemList(iRows).FImageList 	= getItemImageUrl & "/list/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(13))
				FItemList(iRows).FImageList120 	= getItemImageUrl & "/list120/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(14))
				FItemList(iRows).FImageIcon1 	= getItemImageUrl & "/icon1/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(15))
				FItemList(iRows).FImageIcon2 	= getItemImageUrl & "/icon2/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html(arrData(16))
				FItemList(iRows).FImageSmall	= getItemImageUrl & "/small/" & GetImageSubFolderByItemid(FItemList(iRows).FItemid) & "/" &db2html( arrData(17))
				FItemList(iRows).FSellyn = arrData(18)
				FItemList(iRows).FSaleyn = arrData(19)
				FItemList(iRows).FLimityn = arrData(20)
				FItemList(iRows).FRegdate = dateserial(left(arrData(21),4),mid(arrData(21),5,2),mid(arrData(21),7,2))
				IF arrData(22)<>"" Then
					FItemList(iRows).FReipgodate= dateserial(left(arrData(22),4),mid(arrData(22),5,2),mid(arrData(22),7,2))
				End IF
				FItemList(iRows).FItemcouponyn = arrData(23)
				FItemList(iRows).FItemCouponValue = arrData(24)
				FItemList(iRows).FItemCouponType = arrData(25)
				FItemList(iRows).FEvalCnt = arrData(26)
				FItemList(iRows).FEvalcnt_Photo = arrData(27)
				FItemList(iRows).FfavCount = arrData(28)
				FItemList(iRows).FItemScore = arrData(29)
				FItemList(iRows).FtenOnlyYn = arrData(33)

			SET arrData = NOTHING
			SET arrSize = NOTHING

		NEXT
		CALL Docruzer.EndSession()
		SET Docruzer = NOTHING

	End SUB

	'####### 상품 검색 카테고리별 카운팅  ######
	PUBLIC SUB getGroupbyCategoryList()

		'// 검색 결과 출력 시나리오명
		'Scn= "scn_dt_itemDisp"		'일반 상품 검색
        Scn= "scn_dt_itemDispCateGroup"   ''2014/11/07
        
		dim Logs
		dim Docruzer,ret
		dim iRows
		dim arrData,arrSize

		dim FseekTime

		StartNum = 0 						'// 검색시작 Row
		call getSearchQuery(SearchQuery)	'// 검색 쿼리생성

		'//그룹 범위별 지정(정렬 쿼리 생성)
		Select Case FGroupScope
			Case "1"
				SortQuery = " GROUP BY cd1 order by cateSortNo, cd1 "
			Case "2"
				SortQuery = " GROUP BY cd1, cd2 order by cd1, cd2 "
			Case "3"
				SortQuery = " GROUP BY cd1, cd2, cd3 order by cd1, cd2, cd3 "
			Case Else
				SortQuery = " GROUP BY cd1 order by cateSortNo, cd1 "
		end Select

		IF SearchQuery="" Then
			EXIT SUB
		End If

		dim Rowids,Scores
		FTotalCount = 0

		'SET Docruzer = Server.CreateObject("ATLDocruzer_3_2.Client")
        ''MemCached Wrapper==========================================
        SET Docruzer = New CDocWrapper
        call Docruzer.InItWrapper(G_USE_MEMCACHE_SEARCH,"D_CATE_CNT2",2,G_SEARCH_CACHE_TIME)
        ''===========================================================
        
		IF ( Docruzer.BeginSession() < 0 ) THEN
			EXIT SUB
		End If

		'response.write "group : " & SearchQuery & SortQuery & "<br>"
		ret = Docruzer.SubmitQuery(SvrAddr, SvrPort, _
						AuthCode, Logs, Scn, _
						SearchQuery,SortQuery, _
						FRectSearchTxt,StartNum, FPageSize, _
						Docruzer.LC_KOREAN, Docruzer.CS_EUCKR)

		If( ret < 0 ) Then
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING
			EXIT SUB
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

			SET FItemList(iRows) = new SearchGroupByItems
				FItemList(iRows).FCateCode	= arrData(0)            ''0
				FItemList(iRows).FCateName	= arrData(1)            ''41
				FItemList(iRows).FCateCd1	= arrData(2)            ''38
				FItemList(iRows).FCateCd2	= arrData(3)            ''39
				FItemList(iRows).FCateCd3	= arrData(4)            ''40
				FItemList(iRows).FCateDepth	= arrData(5)            ''37

				FItemList(iRows).FImageSmall = getItemImageUrl & "/small/" & GetImageSubFolderByItemid(arrData(6)) & "/" &db2html( arrData(7))  ''4 17
				FItemList(iRows).FSubTotal 	= Scores(iRows)
				FTotalCount = FTotalCount + Scores(iRows)
			SET arrData = NOTHING
			SET arrSize = NOTHING

		NEXT

		SET Rowids= NOTHING
		SET Scores= NOTHING

		CALL Docruzer.EndSession()
		SET Docruzer = NOTHING

	End SUB

	'####### 상품 검색 브랜드별 카운팅  ######
	PUBLIC SUB getGroupbyBrandList()

		'// 검색 결과 출력 시나리오명
		'Scn= "scn_dt_itemDisp"		'일반 상품 검색
		Scn= "scn_dt_itemDispBrandGroup"    ''2014/11/07
		
		dim Logs
		dim Docruzer,ret
		dim iRows
		dim arrData,arrSize

		dim FseekTime

		StartNum = 0 						'// 검색시작 Row
		call getSearchQuery(SearchQuery)	'// 검색 쿼리생성

		'//그룹 범위별 지정(정렬 쿼리 생성)
		'SortQuery = " GROUP BY makerid order by brandname "
		SortQuery = " GROUP BY makerid desc "

		IF SearchQuery="" Then
			EXIT SUB
		End If

		dim Rowids,Scores
		FTotalCount = 0

		'SET Docruzer = Server.CreateObject("ATLDocruzer_3_2.Client")
        ''MemCached Wrapper==========================================
        SET Docruzer = new CDocWrapper
        Call Docruzer.InItWrapper(G_USE_MEMCACHE_SEARCH,"D_BRAN_CNT2",2,G_SEARCH_CACHE_TIME)
        ''===========================================================
        
		IF ( Docruzer.BeginSession() < 0 ) THEN
			EXIT SUB
		End If

		'response.write "group : " & SearchQuery & SortQuery & "<br>"
		ret = Docruzer.SubmitQuery(SvrAddr, SvrPort, _
						AuthCode, Logs, Scn, _
						SearchQuery,SortQuery, _
						FRectSearchTxt,StartNum, FPageSize, _
						Docruzer.LC_KOREAN, Docruzer.CS_EUCKR)

		If( ret < 0 ) Then
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING
			EXIT SUB
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

            SET FItemList(iRows) = new CCategoryPrdItem
				FItemList(iRows).FMakerID		= arrData(0)                ''9
				FItemList(iRows).FBrandName		= arrData(1)                ''10
				FItemList(iRows).FImageSmall	= getItemImageUrl & "/small/" & GetImageSubFolderByItemid(arrData(2)) & "/" &db2html( arrData(3))  ''4, 17
				FItemList(iRows).FisBestBrand	= arrData(4)                ''42
				FItemList(iRows).FItemScore 	= Scores(iRows)
				FItemList(iRows).FCurrRank		= arrData(5)                ''43

			SET arrData = NOTHING
			SET arrSize = NOTHING
			
		NEXT

		SET Rowids= NOTHING
		SET Scores= NOTHING

		CALL Docruzer.EndSession()
		SET Docruzer = NOTHING

	End SUB


	'####### 상품 스타일별 카운팅  ######
	PUBLIC SUB getGroupbyStyleList()

		'// 검색 결과 출력 시나리오명
		Scn= "scn_dt_itemDispStyleGroup"		'상품스타일 검색

		dim Logs
		dim Docruzer,ret
		dim iRows
		dim arrData,arrSize

		dim FseekTime

		StartNum = 0 						'// 검색시작 Row
		call getSearchQuery(SearchQuery)	'// 검색 쿼리생성

		'//그룹 범위 지정(정렬 쿼리 생성)
		SortQuery = " GROUP BY styleCd order by styleCd "

		IF SearchQuery="" Then
			EXIT SUB
		End If

		dim Rowids,Scores
		FTotalCount = 0

		SET Docruzer = Server.CreateObject("ATLDocruzer_3_2.Client")

		IF ( Docruzer.BeginSession() < 0 ) THEN
			EXIT SUB
		End If

		'response.write "group : " & SearchQuery & SortQuery & "<br>"
		ret = Docruzer.SubmitQuery(SvrAddr, SvrPort, _
						AuthCode, Logs, Scn, _
						SearchQuery,SortQuery, _
						FRectSearchTxt,StartNum, FPageSize, _
						Docruzer.LC_KOREAN, Docruzer.CS_EUCKR)

		If( ret < 0 ) Then
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING
			EXIT SUB
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

			SET FItemList(iRows) = new SearchGroupByItems
				FItemList(iRows).FStyleCd		= arrData(0)
				FItemList(iRows).FStyleName		= arrData(1)

				FItemList(iRows).FSubTotal 	= Scores(iRows)
				FTotalCount = FTotalCount + Scores(iRows)
			SET arrData = NOTHING
			SET arrSize = NOTHING

		NEXT

		SET Rowids= NOTHING
		SET Scores= NOTHING

		CALL Docruzer.EndSession()
		SET Docruzer = NOTHING

	End SUB


	'####### 상품 속성별 카운팅  ######
	PUBLIC SUB getGroupbyAttribList()

		'// 검색 결과 출력 시나리오명
		Scn= "scn_dt_itemDispAttribGroup"		'상품속성 검색

		dim Logs
		dim Docruzer,ret
		dim iRows
		dim arrData,arrSize

		dim FseekTime

		StartNum = 0 						'// 검색시작 Row
		call getSearchQuery(SearchQuery)	'// 검색 쿼리생성

		'//그룹 범위 지정(정렬 쿼리 생성)
		SortQuery = " GROUP BY attribCd order by attribCd "

		IF SearchQuery="" Then
			EXIT SUB
		End If

		dim Rowids,Scores
		FTotalCount = 0

		SET Docruzer = Server.CreateObject("ATLDocruzer_3_2.Client")

		IF ( Docruzer.BeginSession() < 0 ) THEN
			EXIT SUB
		End If

		'response.write "group : " & SearchQuery & SortQuery & "<br>"
		ret = Docruzer.SubmitQuery(SvrAddr, SvrPort, _
						AuthCode, Logs, Scn, _
						SearchQuery,SortQuery, _
						FRectSearchTxt,StartNum, FPageSize, _
						Docruzer.LC_KOREAN, Docruzer.CS_EUCKR)

		If( ret < 0 ) Then
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING
			EXIT SUB
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

			SET FItemList(iRows) = new SearchGroupByItems
				FItemList(iRows).FAttribCd		= arrData(0)
				FItemList(iRows).FAttribName	= arrData(1)

				FItemList(iRows).FSubTotal 	= Scores(iRows)
				FTotalCount = FTotalCount + Scores(iRows)
			SET arrData = NOTHING
			SET arrSize = NOTHING

		NEXT

		SET Rowids= NOTHING
		SET Scores= NOTHING

		CALL Docruzer.EndSession()
		SET Docruzer = NOTHING

	End SUB


	'####### 상품 검색 총 카운팅  ######
	PUBLIC SUB getTotalCount()

		'// 검색 결과 출력 시나리오명
		if FcolorCode="" or FcolorCode="0" then
			Scn= "scn_dt_itemDisp"		'일반 상품 검색
		else
			'Scn= "scn_dt_itemColor"		'상품 컬러별 검색
			Scn= "scn_dt_itemDispColor"		'상품 컬러별 검색(전시카테고리)
		end if
		dim Logs
		dim Docruzer,ret
		dim iRows
		dim arrData,arrSize

		dim FseekTime

		StartNum = 0 						'// 검색시작 Row
		call getSearchQuery(SearchQuery)	'// 검색 쿼리생성

		IF (FRectCateCode<>"" and FRectSearchItemDiv<>"y") Then
		    SortQuery = " GROUP BY itemid" ''2013 조건추가
		else
    		SortQuery = " "	'// 정렬 쿼리 생성
    	end if

		IF SearchQuery="" Then
			EXIT SUB
		End If

		dim Rowids,Scores

        '// 기본으로 검색2번 섭, 검색어가 있다면 1번섭 사용
        ''---------------------------------------------------------------------------------------------------------
        if (FRectCateCode<>"") or (FRectMakerid<>"") and (FRectSearchTxt="")  then
            SvrAddr = getTimeChkAddr(G_2NDSCH_ADDR) 
        end if
        ''칼라칩검색/브랜드검색 3차
        if (Scn= "scn_dt_itemDispColor") or (FRectMakerid<>"") then SvrAddr = getTimeChkAddr(G_3RDSCH_ADDR)
        ''---------------------------------------------------------------------------------------------------------

		'SET Docruzer = Server.CreateObject("ATLDocruzer_3_2.Client")
        ''MemCached Wrapper==========================================
        SET Docruzer = new CDocWrapper
        Call Docruzer.InItWrapper(G_USE_MEMCACHE_SEARCH,"D_TOTL_CNT",1,G_SEARCH_CACHE_TIME)
        ''===========================================================
        
		IF ( Docruzer.BeginSession() < 0 ) THEN
			EXIT SUB
		End If

		'response.write "group : " & SearchQuery & SortQuery & "<br>"
		ret = Docruzer.SubmitQuery(SvrAddr, SvrPort, _
						AuthCode, Logs, Scn, _
						SearchQuery,SortQuery, _
						FRectSearchTxt,StartNum, FPageSize, _
						Docruzer.LC_KOREAN, Docruzer.CS_EUCKR)

		If( ret < 0 ) Then
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING
			EXIT SUB
		END IF

		Call Docruzer.GetResult_TotalCount(FTotalCount) '검색결과 총 수


		CALL Docruzer.EndSession()
		SET Docruzer = NOTHING

	End SUB

	'####### 상품색상별 카운팅  ######
	PUBLIC SUB getTotalItemColorCount()
        '' 컬러칩 박스.
		'// 검색 결과 출력 시나리오명
		'Scn= "scn_dt_itemColor"		'상품 컬러별 검색
		Scn= "scn_dt_itemDispColorGroup"		'상품 컬러별 검색(전시카테고리)

		dim Logs
		dim Docruzer,ret
		dim iRows
		dim arrData,arrSize

		dim FseekTime

		StartNum = 0 						'// 검색시작 Row
		call getSearchQuery(SearchQuery)	'// 검색 쿼리생성
		SortQuery = "Group by colorCd Order by colorSortNo, colorCd "	'// 정렬 쿼리 생성

		IF SearchQuery="" Then
			EXIT SUB
		End If

		dim Rowids,Scores
		FTotalCount = 0
        ''---------------------------------------------------------------------------------------------------------
        if (FRectCateCode<>"") or (FRectMakerid<>"") and (FRectSearchTxt="")  then
            SvrAddr = getTimeChkAddr(G_2NDSCH_ADDR)
        end if
        ''칼라칩검색/브랜드검색 3차
        if (Scn= "scn_dt_itemDispColor") or (FRectMakerid<>"") then SvrAddr = getTimeChkAddr(G_3RDSCH_ADDR)
        ''---------------------------------------------------------------------------------------------------------

		SET Docruzer = Server.CreateObject("ATLDocruzer_3_2.Client")

		IF ( Docruzer.BeginSession() < 0 ) THEN
			EXIT SUB
		End If

		'response.write "group : " & SearchQuery & SortQuery & "<br>"
		ret = Docruzer.SubmitQuery(SvrAddr, SvrPort, _
						AuthCode, Logs, Scn, _
						SearchQuery,SortQuery, _
						FRectSearchTxt,StartNum, FPageSize, _
						Docruzer.LC_KOREAN, Docruzer.CS_EUCKR)

		If( ret < 0 ) Then
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING
			EXIT SUB
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

			SET FItemList(iRows) = new SearchGroupByItems
				FItemList(iRows).FcolorCode		= arrData(0)
				FItemList(iRows).FcolorName		= arrData(1)
				FItemList(iRows).FcolorIcon		= "http://webimage.10x10.co.kr/color/colorchip/" & arrData(2)

				FItemList(iRows).FSubTotal 	= Scores(iRows)
				FTotalCount = FTotalCount + Scores(iRows)

			SET arrData = NOTHING
			SET arrSize = NOTHING

		NEXT

		SET Rowids= NOTHING
		SET Scores= NOTHING

		CALL Docruzer.EndSession()
		SET Docruzer = NOTHING

	End SUB


	'####### 상품가격 범위 (최소가격,최대가격)  ######
	PUBLIC SUB getItemPriceRange()

		'// 검색 결과 출력 시나리오명
		Scn= "scn_dt_itemDisp"		'상품일반 검색

		dim Logs
		dim Docruzer,ret
		dim iRows
		dim arrData,arrSize

		dim FseekTime

		StartNum = 0 						'// 검색시작 Row
		FPageSize = 1						'// 결과 값
		call getSearchQuery(SearchQuery)	'// 검색 쿼리생성

		IF SearchQuery="" Then EXIT SUB

		dim Rowids,Scores

		SET Docruzer = Server.CreateObject("ATLDocruzer_3_2.Client")

		IF ( Docruzer.BeginSession() < 0 ) THEN EXIT SUB

		'//정렬 쿼리 생성 : 최소가격
		SortQuery = " order by sellcash asc "
		ret = Docruzer.SubmitQuery(SvrAddr, SvrPort, AuthCode, Logs, Scn, SearchQuery,SortQuery, _
						FRectSearchTxt,StartNum, FPageSize, Docruzer.LC_KOREAN, Docruzer.CS_EUCKR)

		If( ret < 0 ) Then
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING
			EXIT SUB
		END IF

		Call Docruzer.GetResult_RowSize(FResultcount) '검색 결과 수
		Call Docruzer.GetResult_Rowid(Rowids,Scores)
CALL debugQuery(Docruzer,Scn,SearchQuery,SortQuery,FTotalCount,FResultcount)

		REDIM FItemList(FResultCount)
		SET FItemList(0) = new SearchGroupByItems

		if FResultcount>0 then
			ret = Docruzer.GetResult_Row( arrData, arrSize, 0 )
			IF ret>=0 THEN
				FItemList(0).FminPrice		= arrData(7)
			end if
			SET arrData = NOTHING
			SET arrSize = NOTHING
		end if

		SET Rowids= NOTHING
		SET Scores= NOTHING

		'//정렬 쿼리 생성 : 최대가격
		SortQuery = " order by sellcash desc "
		ret = Docruzer.SubmitQuery(SvrAddr, SvrPort, AuthCode, Logs, Scn, SearchQuery,SortQuery, _
						FRectSearchTxt,StartNum, FPageSize, Docruzer.LC_KOREAN, Docruzer.CS_EUCKR)

		If( ret < 0 ) Then
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING
			EXIT SUB
		END IF

		Call Docruzer.GetResult_RowSize(FResultcount) '검색 결과 수
		Call Docruzer.GetResult_Rowid(Rowids,Scores)
CALL debugQuery(Docruzer,Scn,SearchQuery,SortQuery,FTotalCount,FResultcount)

		if FResultcount>0 then
			ret = Docruzer.GetResult_Row( arrData, arrSize, 0 )
			IF ret>=0 THEN
				FItemList(0).FmaxPrice		= arrData(7)
			end if
			SET arrData = NOTHING
			SET arrSize = NOTHING
		end if

		SET Rowids= NOTHING
		SET Scores= NOTHING

		CALL Docruzer.EndSession()
		SET Docruzer = NOTHING

	End SUB


	'####### 추천검색어  ######
	PUBLIC FUNCTION getRecommendKeyWords()

		Dim Docruzer,ret
		Dim iRows
		Dim arrData,arrSize
		Dim MaxCnt : MaxCnt =5

		SET Docruzer = Server.CreateObject("ATLDocruzer_3_2.Client")

		IF ( Docruzer.BeginSession() < 0 ) THEN
			EXIT FUNCTION
		END IF

        SvrAddr = G_ORGSCH_ADDR  '' 106번으로 일단

		ret = Docruzer.RecommendKeyWord _
						(SvrAddr&":"&SvrPort,_
						arrSize,arrData,_
						MaxCnt,replace(FRectSearchTxt," ",""),6)

		IF( ret < 0 ) THEN
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING
			EXIT FUNCTION

		END IF

		getRecommendKeyWords = arrData
		SET arrData = NOTHING
		CALL Docruzer.EndSession()
		SET Docruzer = NOTHING

	END FUNCTION

	'####### 인기검색어  ######
	PUBLIC FUNCTION getPopularKeyWords()

		DIM Docruzer,ret
		DIM iRows
		DIM arrData,arrSize
		DIM MaxCnt : MaxCnt =FPageSize

		SET Docruzer = Server.CreateObject("ATLDocruzer_3_2.Client")

		IF ( Docruzer.BeginSession() < 0 ) THEN
			EXIT FUNCTION
		END IF

        SvrAddr = G_ORGSCH_ADDR  '' 106번으로 일단

		ret = Docruzer.getPopularKeyword _
						(SvrAddr&":"&SvrPort,_
						arrSize,arrData,_
						MaxCnt,6)
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

	PUBLIC FUNCTION HasPreScroll()
		HasPreScroll = StartScrollPage > 1
	END FUNCTION

	PUBLIC FUNCTION HasNextScroll()
		HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
	END FUNCTION

	PUBLIC FUNCTION StartScrollPage()
		StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	END FUNCTION

End Class

'###############################
'### 상품후기 검색           ###
'###############################
Class SearchItemEvaluate
	public FItemList()

	public FResultCount
	public FPageSize
	public FCurrpage
	public FTotalCount
	public FTotalPage
	public FScrollCount

	public FRectDispCate
	public FRectSort
	public FRectMode
	public FRectArrItemid

	Private Sub Class_Initialize()
		redim preserve FItemList(0)
	End Sub

	Private Sub Class_Terminate()
	End Sub

	'// 베스트 리뷰 선택 목록(검색用) 접수 : 상품당 최근 1개 리뷰 목록 //
	public Sub GetBestReviewArrayList()
		dim sql, i

		if FRectArrItemid="" then
			Exit Sub
		end if

		'// 목록 접수 //
		sql = " SELECT e.idx, e.userid, e.regdate, e.itemid " + vbcrlf
		sql = sql & " , e.contents, (Case When isNull(i.frontMakerid,'')='' then i.makerid else i.frontMakerid end) as makerid, i.brandname, e.TotalPoint as Tpoint " + vbcrlf
		sql = sql & " , i.itemname, i.sellcash, i.orgprice, i.sellyn, i.sailyn, i.limityn, i.itemcouponyn, i.itemcoupontype, i.itemcouponvalue " + vbcrlf
		sql = sql & " , i.listimage120, i.evalcnt, i.itemscore, e.File1, e.File2, i.icon1image, i.evalcnt, ic.favcount, i.tenOnlyYn  " + vbcrlf
		sql = sql & " FROM db_board.[dbo].tbl_item_evaluate e " + vbcrlf
		sql = sql & " JOIN  [db_item].[dbo].tbl_item i  " + vbcrlf
		sql = sql & " 	on e.itemid = i.itemid " + vbcrlf
		sql = sql & " JOIN  [db_item].[dbo].tbl_item_contents ic  " + vbcrlf
		sql = sql & " 	on i.itemid = ic.itemid " + vbcrlf
		sql = sql & " WHERE e.idx in (" & vbcrlf
		sql = sql & "	 Select idx from (" & vbcrlf
		sql = sql & "		select itemid, max(idx) as idx " & vbcrlf
		sql = sql & "		from db_board.[dbo].tbl_item_evaluate" & vbcrlf
		sql = sql & "		where itemid in (" & FRectArrItemid & ")" & vbcrlf
		sql = sql & "			and isusing='Y'" & vbcrlf

		if FRectMode="photo" then
			sql = sql & " and (File1 is Not Null or File2 is Not Null) " + vbcrlf
		end if

		sql = sql & "		group by itemid) as T )"
		Select Case FRectSort
			Case "ne"
				'신상순
				sql = sql & " ORDER BY e.itemid DESC  " + vbcrlf
			Case "be"
				'인기상품 순
				sql = sql & " ORDER BY i.itemscore DESC  " + vbcrlf
			Case "lp"
				'낮은 가격순
				sql = sql & " ORDER BY i.sellcash asc  " + vbcrlf
			Case "hp"
				'높은 가격순
				sql = sql & " ORDER BY i.sellcash desc  " + vbcrlf
			Case "hs"
				'높은 할인순
				sql = sql & " ORDER BY (i.sellcash/i.orgprice) desc  " + vbcrlf
			Case else
				sql = sql & " ORDER BY e.itemid DESC  " + vbcrlf
		End Select

		rsget.Open SQL,dbget,1

		FResultCount = rsget.RecordCount
		if FResultCount<1 then FResultCount=0

		redim preserve FItemList(FResultCount)

		if  not rsget.EOF  then
			i = 0
			Do Until rsget.EOF or rsget.BOF
				set FItemList(i) = new CCategoryPrdItem

                ''FItemList(i).Fidx				= rsget("idx")
				FItemList(i).Fitemid			= rsget("itemid")
				FItemList(i).Fuserid			= rsget("userid")
				FItemList(i).Fregdate			= rsget("regdate")
				FItemList(i).Fitemname			= db2html(rsget("itemname"))
				FItemList(i).Fmakerid			= db2html(rsget("makerid"))
				FItemList(i).Fbrandname			= db2html(rsget("brandname"))
				FItemList(i).Fevalcnt			= rsget("evalcnt")
				FItemList(i).Fcontents			= db2html(rsget("contents"))
				FItemList(i).FOrgprice			= rsget("orgprice")
				FItemList(i).FSellYn			= rsget("sellyn")
				FItemList(i).FSaleYn			= rsget("sailyn")
				FItemList(i).FLimitYn			= rsget("limityn")
				FItemList(i).FSellCash			= rsget("sellcash")
				FItemList(i).FPoints			= rsget("TPoint")
				FItemList(i).Fitemcouponyn		= rsget("itemcouponyn")
				FItemList(i).Fitemcoupontype	= rsget("itemcoupontype")
				FItemList(i).FItemCouponValue	= rsget("itemcouponvalue")
				FItemList(i).FTenOnlyYn			= rsget("tenOnlyYn")

				if Not(rsget("File1")="" or isNull(rsget("File1"))) then
					FItemList(i).FImageIcon1		= "http://imgstatic.10x10.co.kr/goodsimage/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("File1")
				end if
				if Not(rsget("File2")="" or isNull(rsget("File2"))) then
					FItemList(i).FImageIcon2		= "http://imgstatic.10x10.co.kr/goodsimage/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("File2")
				end if
				FItemList(i).FImageList120    = "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage120")
				FItemList(i).FIcon1Image	  = "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("icon1image")
				FItemList(i).FEvalcnt		  = rsget("evalcnt")
				FItemList(i).Ffavcount		  = rsget("favcount")

				rsget.moveNext
				i = i + 1
			Loop
		end if
		rsget.close
	end Sub

	PUBLIC FUNCTION HasPreScroll()
		HasPreScroll = StartScrollPage > 1
	END FUNCTION

	PUBLIC FUNCTION HasNextScroll()
		HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
	END FUNCTION

	PUBLIC FUNCTION StartScrollPage()
		StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	END FUNCTION
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

End Class

Class SearchEventCls
    ''검색페이지 이벤트.
	Private SUB Class_initialize()

        '' 기본 1차서버--------------------------------------------------------------------------------------------
		SvrAddr = getTimeChkAddr(G_1STSCH_ADDR)
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

	'####### 이벤트 검색 ######
	PUBLIC SUB getEventList()

		dim Scn : Scn= "scn_dt_event2013" 		'// 검색 결과 출력 시나리오명
		dim Logs
		dim Docruzer,ret
		dim iRows
		dim arrData,arrSize

		dim FseekTime

		StartNum = (FCurrPage -1)*FPageSize	'// 검색시작 Row
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

		'//그룹 범위별 지정(정렬 쿼리 생성)
		SortQuery = "Order by evt_startdate desc "

		dim Rowids,Scores

		SET Docruzer = Server.CreateObject("ATLDocruzer_3_2.Client")

		IF ( Docruzer.BeginSession() < 0 ) THEN
			EXIT SUB
		End If

		ret = Docruzer.SubmitQuery(SvrAddr, SvrPort, _
						AuthCode, Logs, Scn, _
						SearchQuery,SortQuery, _
						FRectSearchTxt,StartNum, FPageSize, _
						Docruzer.LC_KOREAN, Docruzer.CS_EUCKR)

		If( ret < 0 ) Then
			CALL Docruzer.EndSession()
			SET Docruzer = NOTHING
			EXIT SUB
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

			SET FItemList(iRows) = new SearchEventItems
				FItemList(iRows).Fevt_code			= arrData(0)
				FItemList(iRows).Fevt_bannerimg		= arrData(1)
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
  Exit Sub ''사용안함 2014/09/23
	dim strSQL, aiid, acnt
	aiid="": acnt=""
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

'// 내검색어 저장처리 (쿠키, 최근 10개 저장)
Sub procMySearchKeyword(kwd)
	Dim arrCKwd, rstKwd, i, excKwd
	'''arrCKwd = request.Cookies("search")("keyword")
	arrCKwd = session("myKeyword")
	arrCKwd = split(arrCKwd,",")
	''excKwd = "update,select,insert,and,union,from,alter,shutdown,kill,declare,exec,having,;,--"		'쿠키저장 제외 단어 (쿠키 인젝션)

	rstKwd = trim(kwd)
	if ubound(arrCKwd)>-1 then
		for i=0 to ubound(arrCKwd)
			if not(chkArrValue(excKwd,lcase(arrCKwd(i)))) then
				if arrCKwd(i)<>trim(kwd) then rstKwd = rstKwd & "," & arrCKwd(i)
			end if
			if i>9 then Exit For
		next
	end if

	'쿠키저장
	''response.Cookies("search").domain = "10x10.co.kr"
	''''response.cookies("search").Expires = Date + 3	'3일간 쿠키 저장 => 브라우저
	''response.Cookies("search")("keyword") = rstKwd
	session("myKeyword") = rstKwd
end Sub

'// 신조어/동의어 변환 처리 (신조어가 및 동의어가 안되는 문제 있을때 사용)
Function chgCoinedKeyword(kwd)
	dim arrChgTxt, arrItm
	arrChgTxt = split("반8||ban8",",")

	for each arrItm in arrChgTxt
		arrItm = split(arrItm,"||")
		if ubound(arrItm)>0 then
			kwd = Replace(kwd,arrItm(0),arrItm(1))
		end if
	next

	chgCoinedKeyword = kwd
end Function
%>
