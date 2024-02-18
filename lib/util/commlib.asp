<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/util/tenSessionLib.asp" -->
<%
'+---------------------------------------------------------------------------------------------------------+
'|                                          공 통   함 수 선 언                                            |
'+------------------------------------------+--------------------------------------------------------------+
'|                함 수 명                  |                          기    능                            |
'+------------------------------------------+--------------------------------------------------------------+
'| Num2Str(inum,olen,cChr,oalign)           | 숫자를 지정한 길이의 문자열로 변환한다.                      |
'|                                          | 사용예 : Num2Str(425,4,"0","R") → 0425                       |
'+------------------------------------------+--------------------------------------------------------------+
'| chrbyte(str,chrlen,dot)                  | 지정길이로 문자열 자르기                                     |
'|                                          | 사용예 : chrbyte("안녕하세요",3,"Y") → 안녕...               |
'+------------------------------------------+--------------------------------------------------------------+
'| printUserId(strID,lng,chr)               | 회원 아이디를 출력할 때 지정수만큼 문자 치환. 아이디 노출X   |
'|                                          | 사용예 : printUserId("kobula",2,"*") -> 'kobu**'             |
'+------------------------------------------+--------------------------------------------------------------+
'| getNumeric(strNum)                       | 문자열에서 숫자만 추출 변환                                  |
'|                                          | 사용예 : getNumeric("a45d61*124") -> 461124                  |
'+------------------------------------------+--------------------------------------------------------------+
'| requestCheckVar(orgval,maxlen)           | 파라메터 길이 체크 후 Maxlen 이하로 돌려줌 Code, id 등의 Param 에 사용|
'|                                          | 사용예 : requestCheckVar(request("id"),32)                   |
'+------------------------------------------+--------------------------------------------------------------+
'| db2html(checkvalue)                      | DB저장된 구문을 사이트에 쓸 수 있도록 변환                   |
'|                                          | 사용예 : Response.Write db2html(Rs("title"))                 |
'+------------------------------------------+--------------------------------------------------------------+
'| html2db(checkvalue)                      | 사이트에서 입력받은 내용을 DB에 저장할 수 있도록 변환        |
'|                                          | 사용예 : strSQL = html2db("내용을 저장합니다")               |
'+------------------------------------------+--------------------------------------------------------------+
'| stripHTML(strng)                         | HTML태그 제거                                                |
'|                                          | 사용예 : cont = stripHTML(Rs("content"))                     |
'+------------------------------------------+--------------------------------------------------------------+
'| Alert_msg(strMSG)                        | 경고창을 띄운다.                                             |
'|                                          | 사용예 : Call Alert_msg("알립니다.")                         |
'+------------------------------------------+--------------------------------------------------------------+
'| Alert_return(strMSG)                     | 경고창 띄운후 이전으로 돌아간다.                             |
'|                                          | 사용예 : Call Alert_return("뒤로 돌아갑니다.")               |
'+------------------------------------------+--------------------------------------------------------------+
'| Alert_close(strMSG)                      | 경고창 띄운후 현재창을 닫는다.                               |
'|                                          | 사용예 : Call Alert_close("창을 닫습니다.")                  |
'+------------------------------------------+--------------------------------------------------------------+
'| Alert_move(strMSG,targetURL)             | 경고창 띄운후 지정페이지로 이동한다.                         |
'|                                          | 사용예 : Call Alert_move("이동합니다.","/index.asp")         |
'+------------------------------------------+--------------------------------------------------------------+
'| ReplaceRequestSpecialChar(strng)        	| 특수 문자 제거(' ,--)                                        |
'|                                          | 사용예 : cont = ReplaceRequestSpecialChar(Rs("strng"))       |
'+------------------------------------------+--------------------------------------------------------------+
'| checkNotValidTxt(ostr)                   | 내용에 금지어 및 html 태그가 있는지 검사 		               |
'|                                          | 사용예 : checkNotValidTxt("http://") → true                  |
'+------------------------------------------+--------------------------------------------------------------+
'| checkNotValidHTML(ostr)                  | 내용에 금지된 HTML태그가 있는지 검사                         |
'|                                          | 사용예 : checkNotValidHTML("<script...") → true              |
'+------------------------------------------+--------------------------------------------------------------+
'| getSpecialShopItemPrice(sellcash)        | 우수 회원샵 상품 할인 판매가                                 |
'|                                          | 사용예 : discountprice = getSpecialShopItemPrice(sellcah)    |
'+------------------------------------------+--------------------------------------------------------------+
'| SplitValue(orgStr,delim,pos)             | 문자열을 잘라 원하는 위치의 값을 반환                        |
'|                                          | 사용예 : SplitValue("A/B/C","/","2") → B                     |
'+------------------------------------------+--------------------------------------------------------------+
'| ChkIIF(trueOrFalse, trueVal, falseVal)   | like iif function                                            |
'|                                          | 사용예 : ChkIIF(1>2,"a","b") → "b"                           |
'+------------------------------------------+--------------------------------------------------------------+
'| req()                                    | request 축약 + 디폴트                                        |
'|                                          | 사용예 : req("필드", 기본값)                                 |
'+------------------------------------------+--------------------------------------------------------------+
'| null2blank()                             | Null을 Blank 공백으로 치환, 레코드셋에서 사용                |
'|                                          | 사용예 : 속성 = null2blank(rsget("컬럼"))                    |
'+------------------------------------------+--------------------------------------------------------------+
'| fnPaging()                               | 2009 페이징 함수, 페이지값을 넘기는 파라미터명에 유의할 것   |
'| 사용예 : <%=fnPaging(페이지파라미터, 토탈레코드카운트, 현재페이지, 페이지사이즈, 블럭사이즈)%           |
'+------------------------------------------+--------------------------------------------------------------+
'| getThisFullURL()                         | 현재 페이지 URL + 모든 파라미터 QueryString                  |
'|                                          | 사용예 : 변수 = getThisFullURL()                             |
'+------------------------------------------+--------------------------------------------------------------+
'| Format00(totallength,orgData)            | 숫자 형식을 000NNNN 형식으로 변환                            |
'|                                          | 사용예 : Format00(7,69125) → 0069125                         |
'+------------------------------------------+--------------------------------------------------------------+
'| GetUserLevelStr(iuserlevel)              | 사용자 등급의 해당명칭을 반환                                |
'|                                          | 사용예 : GetUserLevelStr(2) → 블루                           |
'+------------------------------------------+--------------------------------------------------------------+
'| DrawTenBankAccount(accountnoName, accountno) |    무통장 입금 계좌                                      |
'|                                          | 사용예 : Call DrawTenBankAccount("accountno",accountno)      |
'+------------------------------------------+--------------------------------------------------------------+
'| BinaryToText(BinaryData, CharSet)         | 바이너리 데이터 TEXT형태로 변환                             |
'|                                           | 사용예 : BinaryToText(objXML.ResponseBody, "euc-kr")        |
'+-------------------------------------------+-------------------------------------------------------------+
'| CheckCurse(txt)		                    | 문자열의 형식을 정규식으로 검사                              |
'|                                          | 사용예 :  CheckCurse(txt) -> 글자수 만큼 * 모양으로 치환	   |
'+-------------------------------------------+-------------------------------------------------------------+
'| DrawBankCombo(selectedname,selectedId)   | 은행 목록                                                    |
'|                                          | 사용예 : Call DrawBankCombo("bankname",bankname)             |
'+------------------------------------------+--------------------------------------------------------------+
'| chkArrValue(aVal,cVal)                    | 콤마로 구분된 배열값에 지정된 값이 있는지 반환              |
'|                                           | 사용예 : chkArrValue("A,B,C", "B") → true                   |
'+-------------------------------------------+-------------------------------------------------------------+
'| chkArrValueLen(aVal,cVal,lmt)             | 콤마로 구분된 배열값에 지정된 값(지정길이)이 있는지 반환    |
'|                                           | 사용예 : chkArrValueLen("AA,BB,CC","B",1) → true            |
'+-------------------------------------------+-------------------------------------------------------------+
'| ArrayQuickSort(vec,loBound,hiBound,SortField) | 배열값을 내림차순으로 정렬                              |
'|                                          | 사용예 : ArrayQuickSort(배열명,최소수,배열최대수,기준열번호) |
'+-------------------------------------------+-------------------------------------------------------------+
'| ArraySwapRows(ary,row1,row2)             | 배열의 행 치환                                               |
'|                                          | 사용예 : ArraySwapRows(배열명,바꿀열,대상열)                 |
'+------------------------------------------+--------------------------------------------------------------+
'| CurrFormat(byVal v)                      | 숫자열을 화폐형으로 변환                                     |
'|                                          | 사용예 : CurrFormat(1250) → 1,250                            |
'+------------------------------------------+--------------------------------------------------------------+
'| RepWord(str,patrn,repval)                | 정규식 패턴을 사용한 문자열 처리                             |
'|                                          | 사용예 : RepWord(SearchText,"[^가-힣a-zA-Z0-9\s]","")        |
'+------------------------------------------+--------------------------------------------------------------+
'| chkWord(str,patrn)                       | 문자열의 형식을 정규식으로 검사                              |
'|                                          | 사용예 : chkWord("abcd","[^-a-zA-Z0-9/ ]") : 영어숫자만 허용 |
'+-------------------------------------------+-------------------------------------------------------------+
'| URLDecodeUTF8(byVal pURL)                | UTF8을 ASCII 문자열로 변환                                   |
'|                                          | 사용예 : strASC = URLDecodeUTF8(URL)                         |
'+------------------------------------------+--------------------------------------------------------------+
'| URLEncodeUTF8(byVal szSource)            | ASCII을 UTF8 문자열로 변환                                   |
'|                                          | 사용예 : strUF8 = URLEncodeUTF8(STR)                         |
'+------------------------------------------+--------------------------------------------------------------+
'| GetUserProfileImg(inum)					   | 유저 아이디별 프로필 이미지를 긁어옴                      |
'|                                          | 사용예 : Response.write GetUserProfileImg("1")               |
'+------------------------------------------+--------------------------------------------------------------+
'| checkFilePath(filePath)       | 파일이 해당경로에 있는지 체크한다.									   |
'|                                          | 사용예 : bool = checkFIlePath(filePath)					   |
'+------------------------------------------+--------------------------------------------------------------+
'| HTMLDecode(string)       				| 완성형한글 html decode									   |
'|                                          | 사용예 : HTMLDecode(str)					   				   |
'+------------------------------------------+--------------------------------------------------------------+



'+---------------------------------------------------------------------------------------------------------+
'|                                인 증 관 련   공 통   함 수 선 언                                        |
'+------------------------------------------+--------------------------------------------------------------+
'| IsUserLoginOK()                          | [아이디]로 로그인 했는지 여부 return Boolean                 |
'|                                          | 사용예 : bool = IsUserLoginOK()                              |
'+------------------------------------------+--------------------------------------------------------------+
'| IsGuestLoginOK()                         | [주문 번호]로 로그인 했는지 여부 return Boolean              |
'|                                          | 사용예 : bool = IsGuestLoginOK()                             |
'+------------------------------------------+--------------------------------------------------------------+
'| IsVIPUser()                         		| [회원등급]으로 VIP 인지 여부 return Boolean				   |
'|                                          | 사용예 : bool = IsVIPUser()                             	   |
'+------------------------------------------+--------------------------------------------------------------+
'| IsSpecialShopUser()                      | [회원등급]으로 우수회원샵 이용가능 여부 return Boolean	   |
'|                                          | 사용예 : bool = IsVIPUser()                             	   |
'+------------------------------------------+--------------------------------------------------------------+
'| GetLoginUserID()                         | 로그인 한 UserID                                             |
'|                                          | 사용예 : ret = getLoginUserID()                              |
'+------------------------------------------+--------------------------------------------------------------+
'| GetLoginUserName()                       | 로그인 한 UserName                                           |
'|                                          | 사용예 : ret = getLoginUserName()                            |
'+------------------------------------------+--------------------------------------------------------------+
'| GetLoginUserEmail()                      | 로그인 한 UserUserEmail                                      |
'|                                          | 사용예 : ret = getLoginUserEmail()                           |
'+------------------------------------------+--------------------------------------------------------------+
'| GetLoginUserLevel()                      | 로그인 한 UserUserLevel                                      |
'|                                          | 사용예 : ret = getLoginUserLevel()                           |
'+------------------------------------------+--------------------------------------------------------------+
'| GetLoginUserDiv()                        | 로그인 한 UserUserDiv                                        |
'|                                          | 사용예 : ret = getLoginUserDiv()                             |
'+------------------------------------------+--------------------------------------------------------------+
'| GetLoginRealNameCheck()                  | 로그인 한 실명확인 여부 ('Y','N')                            |
'|                                          | 사용예 : ret = GetLoginRealNameCheck()                       |
'+------------------------------------------+--------------------------------------------------------------+
'| getRealNameErrMsg(DCd)          		    | 실명확인 상세결과 코드에 따른 메시지 반환                    |
'|                                          | 사용예 : msg = getRealNameErrMsg("A")                        |
'+------------------------------------------+--------------------------------------------------------------+
'| GetCartCount()                           | 로그인 당시 장바구니에 담긴 갯수                             |
'|                                          | 사용예 : ret = GetCartCount()                                |
'+------------------------------------------+--------------------------------------------------------------+
'| SetCartCount(cartcount)                  | 장바구니에 담긴수 변경                                       |
'|                                          | 사용예 : SetCartCount(5)                                     |
'+------------------------------------------+--------------------------------------------------------------+
'| GetOrderCount()                          | 로그인 당시 최근 3주간 주문/배송 갯수                        |
'|                                          | 사용예 : ret = GetOrderCount()                               |
'+------------------------------------------+--------------------------------------------------------------+
'| SetOrderCount(ordcount)                  | 주문/배송 갯수 변경                                          |
'|                                          | 사용예 : SetOrderCount(5)                                    |
'+------------------------------------------+--------------------------------------------------------------+
'| GetLoginCouponCount()                    | 로그인 당시 할인권 + 상품쿠푠  갯수   - 쿠폰 받았을때 세팅 필요|
'|                                          | 사용예 : ret = GetLoginCouponCount()                         |
'+------------------------------------------+--------------------------------------------------------------+
'| GetLoginCurrentMileage()                 | 로그인 당시 마일리지   - 마일리지 변경시 세팅 필요           |
'|                                          | 사용예 : ret = GetLoginCurrentMileage()                      |
'+------------------------------------------+--------------------------------------------------------------+
'| GetLoginCurrentTenCash()                 | 로그인 당시 예치금   - 예치금 변경시 세팅 필요           	   |
'|                                          | 사용예 : ret = GetLoginCurrentTenCash()                      |
'+------------------------------------------+--------------------------------------------------------------+
'| SetLoginCurrentTenCash(currmileage)      | 로그인 당시 예치금 세팅                                      |
'|                                          | 사용예 : call SetLoginCurrentTenCash(currtencash)            |
'+------------------------------------------+--------------------------------------------------------------+
'| GetTodayViewItemCount()                  | 오늘 본 상품 수                                              |
'|                                          | 사용예 : ret GetTodayViewItemCount                           |
'+------------------------------------------+--------------------------------------------------------------+
'| SetLoginCouponCount(couponcount)         | 로그인 당시 할인권 + 상품쿠푠 갯수 세팅                      |
'|                                          | 사용예 : call SetLoginCouponCount(couponcount)               |
'+------------------------------------------+--------------------------------------------------------------+
'| SetLoginCurrentMileage(currmileage)      | 로그인 당시 마일리지 세팅                                    |
'|                                          | 사용예 : call SetLoginCurrentMileage(currmileage)            |
'+------------------------------------------+--------------------------------------------------------------+
'| GetGuestLoginOrderserial()               | [주문 번호]로그인 한 주문번호                                |
'|                                          | 사용예 : Call GetGuestLoginOrderserial()                     |
'+------------------------------------------+--------------------------------------------------------------+
'| sbPostDataToHtml()             		    | get 스트링 형태로 넘어온 데이터를 post 형태로 변경           |
'|                                          | 사용예 : Call sbPostDataToHtml()                             |
'+------------------------------------------+--------------------------------------------------------------+
'| fnMakePostData()            				|  post형식의 데이터  get 스트링 형태로 변경                   |
'|                                          | 사용예 : Call fnMakePostData()                     		   |
'+------------------------------------------+--------------------------------------------------------------+
'+---------------------------------------------------------------------------------------------------------+
'|                                  날 짜 관 련   공 통   함 수 선 언                                      |
'+------------------------------------------+--------------------------------------------------------------+
'|                함 수 명                  |                          기    능                            |
'+------------------------------------------+--------------------------------------------------------------+
'| FormatDate(ddate, formatstring)          | 날짜형식을 지정된 문자형으로 변환                            |
'|                                          | 사용예 : printdate = FormatDate(now(),"0000.00.00")          |
'+------------------------------------------+--------------------------------------------------------------+

'// 사내 접속여부
Function isTenbyTenConnect()
	Dim conIp, arrIp, tmpIp
	conIp = Request.ServerVariables("REMOTE_ADDR")
	if left(conIp,2)<>"::" then
		arrIp = split(conIp,".")
		tmpIp = Num2Str(arrIp(0),3,"0","R") & Num2Str(arrIp(1),3,"0","R") & Num2Str(arrIp(2),3,"0","R") & Num2Str(arrIp(3),3,"0","R")
	end if

	'121.78.103.60 : 15층 유선
	'10.10.10.36 : m2서버
	'192.168.1.x : 15층 운영,개발,인사,재무
	'192.168.6.x : 15층 일반망
	'110.11.187.233 : 15층 wireless6
	'110.93.128.x : IDC

	if tmpIp="121078103060" or tmpIp="110011187233" or (tmpIp=>"110093128001" and tmpIp<="110093128256") or (tmpIp=>"192168001001" and tmpIp<="192168001256") or (tmpIp=>"192168006001" and tmpIp<="192168006256") then
		isTenbyTenConnect = True
	else
		isTenbyTenConnect = False
	end if
End Function

'/서버 주기적 업데이트 위한 공사중 처리 '2011.11.11 한용민 생성
'/리뉴얼시 이전해 주시고 지우지 말아 주세요 
Sub serverupdate_underconstruction()
	dim isServerDown : isServerDown = false
		'isServerDown = true	' 서버다운
		isServerDown = false	' 서버활성화
		if isTenbyTenConnect then isServerDown = false	'사내접속 허용

	if Not(isServerDown) then exit Sub

	Response.write "<html>"
	Response.write "<head>"
	Response.write "<meta http-equiv='content-type' content='text/html; charset=UTF-8' />"
	Response.write "<meta name='viewport' content='initial-scale=1.0; maximum-scale=1.0; minimum-scale=1.0; user-scalable=no; width=device-width;' />"
	Response.write "<title>10x10: 서비스 점검중</title>"
	Response.write "</head>"
	Response.write "<body>"
	Response.write "<table width='100%' height='100%' cellpadding='0' cellspacing='0' border='0'>"
	Response.write "<tr>"
	Response.write "	<td align='center' valign='middle'><img src='http://fiximage.10x10.co.kr/web2015/common/2015_10x10_open_ready_M.jpg' width='100%' border='0' ></td>"
	Response.write "</tr>"
	Response.write "</table>"
	Response.write "</body>"
	Response.write "</html>"
	response.End
End Sub

'// 개발환경 쿠키구성 //
function GetCookieDomainName()
	GetCookieDomainName = "10x10.co.kr"
	IF application("Svr_Info")="Dev" THEN
	    if (InStr(request.ServerVariables("HTTP_HOST"),"10x10.co.kr")>0) then '' 로컬에서 dev.10x10.co.kr 등으로 사용할경우 SKIP
            GetCookieDomainName = request.ServerVariables("HTTP_HOST")
        elseif (request.ServerVariables("LOCAL_ADDR")="::1") or (request.ServerVariables("LOCAL_ADDR")="127.0.0.1") then
            GetCookieDomainName = "localhost"
        end if
	End IF
end Function

'//날짜형식 2013-01-01 오후 03:00:00 형식을 2013-01-01 15:00:00로 변환		'/2013.04.22 한용민 생성
function dateconvert(dateval)
	dim tmpval
	if dateval = "" then exit function

	tmpval = year(dateval)
	tmpval = tmpval & "-" & Format00(2,month(dateval))
	tmpval = tmpval & "-" & Format00(2,day(dateval))
	tmpval = tmpval & " " & Format00(2,hour(dateval))
	tmpval = tmpval & ":" & Format00(2,minute(dateval))
	tmpval = tmpval & ":" & Format00(2,second(dateval))

	dateconvert = left(tmpval,19)
end Function

Function GetPolderName(pDept)
	On Error Resume Next
	Dim vScriptUrl		'/소스 경로저장 변수
	Dim vIndex2			'/ 2번째 슬래시 위치
	Dim vIndex3			'/ 3번째 슬래시 위치
	Dim vIndex4			'/ 4번째 슬래시 위치

	vScriptUrl = Request.ServerVariables("SCRIPT_NAME")
	vIndex2 = InStr(2, vScriptUrl, "/")

	Select Case pDept
		Case 2
			vIndex3 = InStr(vIndex2+1, vScriptUrl, "/")
			GetPolderName = Mid(vScriptUrl, vIndex2+1, vIndex3-vIndex2-1)
		Case 3
			vIndex3 = InStr(vIndex2+1, vScriptUrl, "/")
			vIndex4 = InStr(vIndex3+1, vScriptUrl, "/")
			GetPolderName = Mid(vScriptUrl, vIndex3+1, vIndex4-vIndex3-1)
		Case Else
			GetPolderName = Mid(vScriptUrl, 2, vIndex2-2)
	End Select
	On Error Goto 0
End Function

'/현재 페이지 URL에서 확장자도 제끼고 파일명 추출
Function GetFileName()
	On Error Resume Next
	Dim vUrl			'/소스 경로저장 변수
	Dim FullFilename		'파일이름
	Dim strName			'확장자를 제외한 파일이름

	vUrl = Request.ServerVariables("SCRIPT_NAME")
	FullFilename = mid(vUrl,instrrev(vUrl,"/")+1)
	strName = Mid(FullFilename, 1, Instr(FullFilename, ".") - 1)

	GetFileName = strName
End Function

'// 숫자를 지정한 길이의 문자열로 반환 //
Function Num2Str(inum,olen,cChr,oalign)
	dim i, ilen, strChr

	ilen = len(Cstr(inum))
	strChr = ""

	if ilen < olen then
		for i=1 to olen-ilen
			strChr = strChr & cChr
		next
	end if

	'결합방법에따른 결과 분기
	if oalign="L" then
		'왼쪽기준
		Num2Str = inum & strChr
	else
		'오른쪽 기준 (기본값)
		Num2Str = strChr & inum
	end if

End Function

'' Call set_cookie_secure("CHKSESSION", "2020-09-03", "/", 24)
public sub set_cookie_secure(cookie_name, cookie_value, cookie_path, expire_hour)
    dim cookie_header

    cookie_header = cookie_name & "=" & server.URLEncode(cookie_value) & "; expires=" & dateAdd("h", expire_hour, Now()) & "; path=" & cookie_path & "; Domain=" & GetCookieDomainName

    cookie_header = cookie_header & "; HttpOnly; SameSite=None"

    if UCase(request.ServerVariables("HTTPS")) = "ON" then
        cookie_header = cookie_header & "; Secure"
    end if

	Response.AddHeader "Set-Cookie", cookie_header
end sub

'// 지정길이로 문자열 자르기(유니코드용) //
Function chrbyte(str,chrlen,dot)

    Dim charat, wLen, cut_len, ext_chr, cblp

    if IsNULL(str) then Exit function

    for cblp=1 to len(str)
        charat=mid(str, cblp, 1)
        if asc(charat)=1 then
            '//유니코드 한글은 ascii:1
            wLen=wLen+2
        else
            wLen=wLen+1
        end if

        if wLen >= cint(chrlen) then
           cut_len = cblp
           exit for
        end if
    next

    if len(cut_len) = 0 then
        cut_len = len(str)
    end if

	if len(str)>cut_len and dot="Y" then
		ext_chr = "..."
	else
		ext_chr = ""
	end if

    chrbyte = Trim(left(str,cut_len)) & ext_chr

end function



'// 사이트 출력용 회원ID 변환 함수(지정수만큼 지정한 문자로 바꿈)
Function printUserId(strID,lng,chr)
	dim le, te

	''if GetLoginUserDiv()<>"01" then	'회원 구분이 일반회원이 아니라면 아이디 변환 안함(업체/직원 등 당첨자등 참고-2015.09.02;허진원 제거)
	if GetLoginUserLevel="7" then	'회원 등급이 STAFF라면 아이디 변환 안함(직원 당첨자 등 참고)
		printUserId = strID
		Exit Function
	else
		le = len(strID)
		if(le<lng) Then
			printUserId = String(lng, le)
			Exit Function
		end if

		te = left(strID,le-lng) & String(lng, chr)
		printUserId = te
	end if
End Function

'// 문자열에서 숫자만 추출 변환
Function getNumeric(strNum)
	Dim lp, tmpNo, strRst
	For lp=1 to len(strNum)
		tmpNo = mid(strNum, lp, 1)
		if asc(tmpNo)>47 and asc(tmpNo)<58 then
			strRst = strRst & tmpNo
		end if
	Next
	getNumeric = strRst
End Function

'// 파라메터 길이 체크 후 Maxlen 이하로 돌려줌 Code, id 등의 Param 에 사용 //
function requestCheckVar(orgval,maxlen)
	requestCheckVar = trim(orgval)
	requestCheckVar = replace(requestCheckVar,"'","")
'	requestCheckVar = replace(requestCheckVar,"declare","")
'	requestCheckVar = replace(requestCheckVar,"DECLARE","")
'	requestCheckVar = replace(requestCheckVar,"Declare","")
	requestCheckVar = Left(requestCheckVar,maxlen)
end function

'// DB저장된 구문을 사이트에 쓸 수 있도록 변환 //
function db2html(checkvalue)
	dim v
	v = checkvalue
	if Isnull(v) then Exit function

    On Error resume Next
    v = replace(v, "&amp;", "&")
    ''v = replace(v, "&lt;", "<")
    ''v = replace(v, "&gt;", ">")
    v = replace(v, "&quot;", "'")
    v = Replace(v, "", "<br>")
    v = Replace(v, "\0x5C", "\")
    v = Replace(v, "\0x22", "'")
    v = Replace(v, "\0x25", "'")
    v = Replace(v, "\0x27", "%")
    v = Replace(v, "\0x2F", "/")
    v = Replace(v, "\0x5F", "_")

    db2html = v
end function


'// 사이트에서 입력받은 내용을 DB에 저장할 수 있도록 변환 //
function html2db(checkvalue)
	dim v
	v = checkvalue
	if Isnull(v) then Exit function
	v = Replace(v, "'", "''")
	html2db = v
end Function

function html2db2017(checkvalue)
	dim v
	v = checkvalue
	if Isnull(v) then Exit function
	v = replace(v, "'", "\0x22")
	v = replace(v, "'", "\0x25")
	v = replace(v, "'", "&quot;")
	html2db2017 = v
end Function

function db2html2017(checkvalue)
	dim v
	v = checkvalue
	if Isnull(v) then Exit function
	v = replace(v, "&quot;", "'")
    v = Replace(v, "\0x22", "'")
    v = Replace(v, "\0x25", "'")
	db2html2017 = v
end function


'// HTML태그 제거 //
function stripHTML(strng)
   Dim regEx
   Set regEx = New RegExp
   regEx.Pattern = "[<][^>]*[>]"
   regEx.IgnoreCase = True
   regEx.Global = True
   stripHTML = regEx.Replace(strng, " ")
   Set regEx = nothing
End Function

'// 정규식 데이터 추출 //
Function RegExpArray(ByVal pattern, ByVal strText)
     Dim objRegExp
     Set objRegExp = new RegExp
     objRegExp.Pattern = pattern
     objRegExp.Global = True
     objRegExp.IgnoreCase = True

     Dim match, Matches, idx
     Dim arrList()
     idx = -1

     Set Matches = objRegExp.Execute(strText)
     If Matches.Count = 0 Then
          RegExpArray = Null
     Else
          For Each match In Matches
               idx = idx + 1
               ReDim Preserve arrList(idx)
               arrList(idx) = match
          Next

          RegExpArray = arrList
     End If
     Set objRegExp = Nothing
End Function

'// 꺽은괄호 HTML코드로 치환 //
Function ReplaceBracket(strng)
	strng = Replace(strng,"<","&lt;")
	strng = Replace(strng,">","&gt;")
	ReplaceBracket = strng
end Function


'// UTF8을 ASCII 문자열로 변환 //
Function URLDecodeUTF8(byVal pURL)
	Dim i, s1, s2, s3, u1, u2, result
	pURL = Replace(pURL,"+"," ")

	For i = 1 to Len(pURL)
		if Mid(pURL, i, 1) = "%" then
			s1 = CLng("&H" & Mid(pURL, i + 1, 2))

			'1바이트일 경우(Pass)
			if (s1 < &H80) then
				result = result & Mid(pURL, i, 3)
				i = i + 2
			'2바이트일 경우
			elseif ((s1 AND &HC0) = &HC0) AND ((s1 AND &HE0) <> &HE0) then
				s2 = CLng("&H" & Mid(pURL, i + 4, 2))

				u1 = (s1 AND &H1C) / &H04
				u2 = ((s1 AND &H03) * &H04 + ((s2 AND &H30) / &H10)) * &H10
				u2 = u2 + (s2 AND &H0F)
				result = result & ChrW((u1 * &H100) + u2)
				i = i + 5

			'3바이트일 경우
			elseif (s1 AND &HE0 = &HE0) then
				s2 = CLng("&H" & Mid(pURL, i + 4, 2))
				s3 = CLng("&H" & Mid(pURL, i + 7, 2))

				u1 = ((s1 AND &H0F) * &H10)
				u1 = u1 + ((s2 AND &H3C) / &H04)
				u2 = ((s2 AND &H03) * &H04 +  (s3 AND &H30) / &H10) * &H10
				u2 = u2 + (s3 AND &H0F)
				result = result & ChrW((u1 * &H100) + u2)
				i = i + 8
			end if
		else
			result = result & Mid(pURL, i, 1)
		end if

	Next
	URLDecodeUTF8 = result
End Function

'// ASCII을 UTF8 문자열로 변환 //
Public Function URLEncodeUTF8(byVal szSource)
	Dim szChar, WideChar, nLength, i, result
	if isNull(szSource) then  exit Function

	nLength = Len(szSource)

	For i = 1 To nLength
		szChar = Mid(szSource, i, 1)

		If Asc(szChar) < 0 Then
			WideChar = CLng(AscB(MidB(szChar, 2, 1))) * 256 + AscB(MidB(szChar, 1, 1))

			If (WideChar And &HFF80) = 0 Then
				result = result & "%" & Hex(WideChar)
			ElseIf (WideChar And &HF000) = 0 Then
				result = result & _
					"%" & Hex(CInt((WideChar And &HFFC0) / 64) Or &HC0) & _
					"%" & Hex(WideChar And &H3F Or &H80)
			Else
				result = result & _
					"%" & Hex(CInt((WideChar And &HF000) / 4096) Or &HE0) & _
					"%" & Hex(CInt((WideChar And &HFFC0) / 64) And &H3F Or &H80) & _
					"%" & Hex(WideChar And &H3F Or &H80)
			End If
		Else
			if (Asc(szChar)>=48 and Asc(szChar)<=57) or (Asc(szChar)>=65 and Asc(szChar)<=90) or (Asc(szChar)>=97 and Asc(szChar)<=122) then
				result = result + szChar
			else
				if Asc(szChar)=32 then
					result = result & "+"
				else
					result = result & "%" & Hex(AscB(MidB(szChar, 1, 1)))
				end if
			end if
		End If
	Next
	URLEncodeUTF8 = result
End Function


'// 경고문 출력 //
Sub Alert_msg(strMSG)
	dim strTemp
	strTemp = 	"<script>" & vbCrLf &_
			"alert('" & strMSG & "');" & vbCrLf &_
			"</script>"
	Response.Write strTemp
End Sub

'// 경고문 출력후 뒤로가기 //
Sub Alert_return(strMSG)
	dim strTemp
	strTemp = 	"<script>" & vbCrLf &_
			"alert('" & strMSG & "');" & vbCrLf &_
			"history.back();" & vbCrLf &_
			"</script>"
	Response.Write strTemp
End Sub


'// 경고문 출력후 창닫기 //
Sub Alert_close(strMSG)
	dim strTemp
	strTemp = 	"<script>" & vbCrLf &_
			"alert('" & strMSG & "');" & vbCrLf &_
			"self.close();" & vbCrLf &_
			"</script>"
	Response.Write strTemp
End Sub


'// 경고문 출력후 지정 페이지로 이동 //
Sub Alert_move(strMSG,targetURL)
	dim strTemp
	strTemp = 	"<script>" & vbCrLf &_
			"alert('" & strMSG & "');" & vbCrLf &_
			"self.location='" & targetURL & "';" & vbCrLf &_
			"</script>"
	Response.Write strTemp
End Sub


'// 아이디로 로그인 했는지 여부 //
Function IsUserLoginOK()
    IsUserLoginOK = (GetLoginUserID<>"")
End Function


'// 주문번호로 로그인 했는지 여부 //
Function IsGuestLoginOK()
    IsGuestLoginOK = (GetGuestLoginOrderserial<>"")
End Function


'// VIP 인지 여부 //
'// 2018 회원등급 개편
Function IsVIPUser()
	If GetLoginUserLevel() = "2" OR GetLoginUserLevel() = "3" OR GetLoginUserLevel() = "4" OR GetLoginUserLevel() = "6" Then
    	IsVIPUser = True
    Else
		IsVIPUser = False
	End If
End Function

'// VVIP 인지 여부 //
'// 2018 회원등급 개편
Function IsVVIPUser()
	If GetLoginUserLevel() = "4" Or GetLoginUserLevel() = "6" Then
    	IsVVIPUser = True
    Else
		IsVVIPUser = False
	End If
End Function

'// 로그인 아이디 - 암호화 필요 //
Function GetLoginUserID()
	if (session("ssnuserid")<>"") then
		GetLoginUserID = session("ssnuserid")
		exit function
	end if

    ''GetLoginUserID = request.cookies("uinfo")("muserid")
End Function


'// 로그인 한 이름  //
Function GetLoginUserName()
	if (session("ssnusername")<>"") then
		GetLoginUserName = session("ssnusername")
		exit function
	end if

    ''GetLoginUserName = request.cookies("uinfo")("musername")
End Function


'// 로그인 이메일 //
Function GetLoginUserEmail()
    if (session("ssnuseremail")<>"") then
		GetLoginUserEmail = session("ssnuseremail")
		exit function
	end if

    ''GetLoginUserEmail = request.cookies("uinfo")("museremail")
End Function


'// 로그인 레벨 //
'// 2018 회원등급 개편
Function GetLoginUserLevel()
    dim uselevel

    uselevel = session("ssnuserlevel")
    if (uselevel="") then
		GetLoginUserLevel = "0"
	else
		GetLoginUserLevel = CStr(uselevel)
	end if
End Function

'// 로그인 회원구분 //
Function GetLoginUserDiv()
    dim userDiv

    userDiv = session("ssnuserdiv")
    if (userDiv="") then
		GetLoginUserDiv = "01"
	else
		GetLoginUserDiv = userDiv
	end if
End Function

'// 로그인 실명확인여부 //
Function GetLoginRealNameCheck()
    dim RealNameCheck

    RealNameCheck = session("ssnrealnamecheck")
    if (RealNameCheck="") then
		GetLoginRealNameCheck = "N"
	else
		GetLoginRealNameCheck = RealNameCheck
	end if
End Function


'//실명확인 상세 에러메시지 반환
function getRealNameErrMsg(DCd)
	Select Case DCd
		Case "A"
			getRealNameErrMsg = "실명 확인"
		Case "B"
			getRealNameErrMsg = "성명 불일치\n\n실명확인이 실패하였습니다.\n입력하신 정보를 확인하시고 다시 시도해주세요."
		Case "C"
			getRealNameErrMsg = "명의도용 차단 신청중입니다.\n\n마이크레딧 명의보호관리 서비스에서\n명의도용 차단을 일시 해제 하신 후에 이용가능합니다."
		Case "D"
			getRealNameErrMsg = "주민등록 번호가 조합체계에 맞지 않습니다.\n\n입력하신 정보를 확인하시고 다시 시도해주세요."
		Case "E"
			getRealNameErrMsg = "일시적으로 통신장애가 발생했습니다.\n\n잠시 후에 다시 시도해주세요."
		Case "F"
			getRealNameErrMsg = "고객님의 성명이 두음법칙에 맞지 않게 입력되었습니다.\n(예: 류지선→유지선)\n\n입력하신 정보를 확인하시고 다시 시도해주세요."
		Case "Y"
			getRealNameErrMsg = "실명안심차단 대상자입니다.\n\n차단 해제화면에서 일시 해제 후 이용가능합니다."
		Case "G"
			getRealNameErrMsg = "주민등록 정보가 존재하지 않습니다.\n한국신용정보(1588-2486) 또는\nhttp://idcheck.co.kr/idcheck/sub3_02.jsp에서 개인정보를 등록해주세요."
		Case "H"
			getRealNameErrMsg = "실명확인 DB의 실명정보가 불완전한 상태입니다.\n한국신용정보(1588-2486) 또는\nhttp://idcheck.co.kr/idcheck/sub3_02.jsp에서 개인정보를 정정해주세요."
		Case Else
			getRealNameErrMsg = "실명확인을 할 수 없는 상태입니다.\n\n잠시 후에 다시 시도해주세요."
	End Select
end function


'// 사용자 등급의 해당명칭을 반환 //
'// 2018 회원등급 개편
function GetUserLevelStr(iuserlevel)
	Select Case CStr(iuserlevel)
		Case "0"
			GetUserLevelStr = "<span class='g-white'>WHITE</span>"
		Case "1"
			GetUserLevelStr = "<span class='g-red'>RED</span>"
		Case "2"
			GetUserLevelStr = "<span class='g-vip'>VIP</span>"
		Case "3"
			GetUserLevelStr = "<span class='g-vipgold'>VIP GOLD</span>"
		Case "4"
			GetUserLevelStr = "<span class='g-vvip'>VVIP</span>"
		Case "5"
			GetUserLevelStr = "<span class='g-white'>WHITE</span>"
		Case "6"
			GetUserLevelStr = "<span class='g-vvip'>VVIP</span>"
		Case "7"
			GetUserLevelStr = "<span class='g-staff'>STAFF</span>"
		Case "8"
			GetUserLevelStr = "<span class='g-family'>FAMILY</span>"
		Case "9"
			GetUserLevelStr = "<span class='g-biz'>BIZ</span>"
		Case Else
			GetUserLevelStr = "<span class='g-white'>WHITE</span>"
	end Select
end Function

'// 사용자 등급의 해당명칭의 CSS 클래스를 반환 숫자버전		'/2014.09.18 한용민 생성
'// 2018 회원등급 개편
Function GetUserLevelCSSClassnumber()
	Select Case CStr(GetLoginUserLevel)
		Case "0"	GetUserLevelCSSClassnumber = "10"
		Case "1"	GetUserLevelCSSClassnumber = "11"
		Case "2"	GetUserLevelCSSClassnumber = "12"
		Case "3"	GetUserLevelCSSClassnumber = "13"
		Case "4"	GetUserLevelCSSClassnumber = "14"
		Case "5"	GetUserLevelCSSClassnumber = "10"
		Case "6"	GetUserLevelCSSClassnumber = "16"
		Case "7"	GetUserLevelCSSClassnumber = "17"
		Case "8"	GetUserLevelCSSClassnumber = "17"
		Case "9"	GetUserLevelCSSClassnumber = "17"
		Case Else	GetUserLevelCSSClassnumber = "15"
	End Select
End Function

'// 사용자 등급의 해당명칭의 CSS 클래스를 반환 //		'/2014.09.18 한용민 수정
'// 2018 회원등급 개편
Function GetUserLevelCSSClass()
	Select Case CStr(GetLoginUserLevel)
		Case "0"	GetUserLevelCSSClass = "g-white"
		Case "1"	GetUserLevelCSSClass = "g-red"
		Case "2"	GetUserLevelCSSClass = "g-vip"
		Case "3"	GetUserLevelCSSClass = "g-vipgold"
		Case "4"	GetUserLevelCSSClass = "g-vvip"
		Case "5"	GetUserLevelCSSClass = "g-white"
		Case "6"	GetUserLevelCSSClass = "g-vvip"
		Case "7"	GetUserLevelCSSClass = "g-staff"
		Case "8"	GetUserLevelCSSClass = "g-family"
		Case "9"	GetUserLevelCSSClass = "g-biz"
		Case Else	GetUserLevelCSSClass = "g-white"
	End Select
End Function

'// 소문자
'// 2018 회원등급 개편
function GetUserStr(iuserlevel)
	Select Case CStr(iuserlevel)
		Case "0"
			GetUserStr = "white"
		Case "1"
			GetUserStr = "red"
		Case "2"
			GetUserStr = "vip"
		Case "3"
			GetUserStr = "vipgold"
		Case "4"
			GetUserStr = "vvip"
		Case "5"
			GetUserStr = "white"
		Case "6"
			GetUserStr = "vvip"
		Case "7"
			GetUserStr = "staff"
		Case "8"
			GetUserStr = "family"
		Case "9"
			GetUserStr = "biz"
		Case Else
			GetUserStr = "white"
	end Select
end Function

'// 다음달등업
'// 2018 회원등급 개편
function NextGetUserStr(iuserlevel)
	Select Case CStr(iuserlevel)
		Case "0"
			NextGetUserStr = "red"
		Case "1"
			NextGetUserStr = "vip"
		Case "2"
			NextGetUserStr = "vipgold"
		Case "3"
			NextGetUserStr = "vvip"
		Case "4"
			NextGetUserStr = "vvip"
		Case "5"
			NextGetUserStr = "red"
		Case "6"
			NextGetUserStr = "vvip"
		Case Else
			NextGetUserStr = "white"
	end Select
end Function

'//대문자
'// 2018 회원등급 개편
function GetUserStrlarge(iuserlevel)
	Select Case CStr(iuserlevel)
		Case "0"
			GetUserStrlarge = "WHITE"
		Case "1"
			GetUserStrlarge = "RED"
		Case "2"
			GetUserStrlarge = "VIP"
		Case "3"
			GetUserStrlarge = "VIP GOLD"
		Case "4"
			GetUserStrlarge = "VVIP"
		Case "5"
			GetUserStrlarge = "WHITE"
		Case "6"
			GetUserStrlarge = "VVIP"
		Case "7"
			GetUserStrlarge = "STAFF"
		Case "8"
			GetUserStrlarge = "FAMILY"
		Case "9"
			GetUserStrlarge = "BIZ"
		Case Else
			GetUserStr = "WHITE"
	end Select
end function


'// 로그인 레벨에 따른 색상 //
'// 2018 회원등급 개편
Function GetLoginUserColor()
    dim uselevel
    uselevel = GetLoginUserLevel

    Select Case Cstr(uselevel)
        Case "0"
            ''WHITE
            GetLoginUserColor = "#999"
        Case "1"
            ''RED
            GetLoginUserColor = "#ff5b73"
        Case "2"
            ''VIP
            GetLoginUserColor = "#5a88ff"
        Case "3"
            ''VIP GOLD
            GetLoginUserColor = "#ffb400"
        Case "4"
            ''VVIP
            GetLoginUserColor = "#bd2edd"
        Case "5"
            ''WHITE
            GetLoginUserColor = "#999"
        Case "6"
            ''VVIP
            GetLoginUserColor = "#bd2edd"
        Case "7"
            ''STAFF
            GetLoginUserColor = "#000"
        Case "8"
            ''STAFF
            GetLoginUserColor = "#000"
        Case Else
			GetLoginUserColor = "#999"
	End Select

End Function

''// 장바구니 갯수 :
Function GetCartCount()
    dim tmp
    GetCartCount = 0

    tmp = request.cookies("etc")("cartCnt")

    if (Not IsNumeric(tmp)) then Exit function

    if tmp<1 then tmp = 0

    GetCartCount = tmp
End Function


''// 장바구니 갯수세팅
Function SetCartCount(cartcount)
    dim tmp
    tmp = cartcount

    if (Not IsNumeric(tmp)) then Exit function
    if tmp<1 then tmp = 0

    response.Cookies("etc").domain = "10x10.co.kr"
    response.Cookies("etc")("cartCnt") = tmp
End Function

''//장바구니 금액 가져오기
Function getCartTotalAmount(userid)
    If IsNull(userid) Or userid="" Then Exit Function
	On Error Resume Next
    dim sqlStr
	sqlStr = "exec [db_user].[dbo].[usp_cm_cart_total_amount] @userid ='" & CStr(userid) & "'"

	rsget.CursorLocation = adUseClient
	rsget.CursorType=adOpenStatic
	rsget.Locktype=adLockReadOnly
	rsget.Open sqlStr, dbget

	If Not(rsget.bof Or rsget.eof) Then
		getCartTotalAmount = rsget("totalamount")
	End If
	rsget.close

    On Error goto 0
End Function

''// 최근 주문/배송 갯수 :
Function GetOrderCount()
    dim tmp
    GetOrderCount = 0

    tmp = request.cookies("etc")("ordCnt")

    if (Not IsNumeric(tmp)) then Exit function

    if tmp<1 then tmp = 0

    GetOrderCount = tmp
End Function

''// 주문/배송 갯수세팅
Function SetOrderCount(ordcount)
    dim tmp
    tmp = ordcount

    if (Not IsNumeric(tmp)) then Exit function
    if tmp<1 then tmp = 0

    response.Cookies("etc").domain = "10x10.co.kr"
    response.Cookies("etc")("ordCnt") = tmp
End Function


''// 로그인 당시 쿠폰 + 상품 쿠폰 갯수 - 쿠폰 받았을때 /사용했을때 세팅 필요 :
Function GetLoginCouponCount()
    dim tmp
    GetLoginCouponCount = 0

    tmp = request.cookies("etc")("mcouponCnt")

    if (Not IsNumeric(tmp)) then Exit function

    if tmp<1 then tmp = 0

    GetLoginCouponCount = tmp
End Function


''// 로그인 당시 마일리지 - 변경시 세팅 필요/ Display에만 사용 :
Function GetLoginCurrentMileage()
    dim tmp
    GetLoginCurrentMileage = 0

    tmp = request.cookies("etc")("mcurrentmile")

    if (Not IsNumeric(tmp)) then Exit function

    if tmp<1 then tmp = 0

    GetLoginCurrentMileage = tmp
End Function

''// 로그인 당시 예치금 - 변경시 세팅 필요/ Display에만 사용 :
Function GetLoginCurrentTenCash()
    dim tmp
    GetLoginCurrentTenCash = 0

    tmp = request.cookies("etc")("currtencash")

    if (Not IsNumeric(tmp)) then Exit function

    if tmp<1 then tmp = 0

    GetLoginCurrentTenCash = tmp
End Function

''// 로그인 당시 예치금 세팅
Function SetLoginCurrentTenCash(currtencash)
    dim tmp
    tmp = currtencash

    if (Not IsNumeric(tmp)) then Exit function
    if tmp<1 then tmp = 0

    response.Cookies("etc").domain = "10x10.co.kr"
    response.Cookies("etc")("currtencash") = tmp
End Function

''// 로그인 당시 쿠폰 + 상품쿠폰세팅
Function SetLoginCouponCount(couponcount)
    dim tmp
    tmp = couponcount

    if (Not IsNumeric(tmp)) then Exit function
    if tmp<1 then tmp = 0

    response.Cookies("etc").domain = "10x10.co.kr"
    response.cookies("etc")("mcouponCnt") = tmp
End Function


''// 로그인 당시 마일리지 세팅
Function SetLoginCurrentMileage(currmileage)
    dim tmp
    tmp = currmileage

    if (Not IsNumeric(tmp)) then Exit function
    if tmp<1 then tmp = 0

    response.Cookies("etc").domain = "10x10.co.kr"
    response.cookies("etc")("mcurrentmile") = tmp
End Function

''// 오늘본 상품 수
Function GetTodayViewItemCount()
    dim tmp
    GetTodayViewItemCount = 0

    tmp = Trim(request.cookies("todayviewitemidlist"))
    if tmp="" or tmp="||" then Exit function
	tmp = split(tmp,"|")

    GetTodayViewItemCount = ubound(tmp)-1
End Function

'// 로그인 아이콘(번호로 변경) //
Function GetLoginUserICon()
    GetLoginUserICon = request.cookies("etc")("musericonNo")
End Function


'// 주문번호 로그인  //
Function GetGuestLoginOrderserial()
    GetGuestLoginOrderserial = session("userorderserial") 'request.cookies("guestinfo")("orderserial")
End Function


'//문자열내 특수문자 제거
function ReplaceRequestSpecialChar(v)
	ReplaceRequestSpecialChar = replace(v,"'","")
	ReplaceRequestSpecialChar = replace(ReplaceRequestSpecialChar,"--","")
end function

''//파일명을 메인메뉴 고유번호로 변환
function getTopMenuId(pageName)
	Select Case Lcase(pageName)
		Case "/designfingers/index.asp"
			getTopMenuId = "Fingers"

		Case "/artist/index.asp"
			getTopMenuId = "Artist"

		Case "/redribbon/index.asp"
			getTopMenuId = "RedRibbon"

		Case "/culturestation/index.asp"
			getTopMenuId = "Culture"

		Case Else
			getTopMenuId = ""
	End Select
end function

'//null 일때 대체값
Function NullFillWith(src , data )
	if isNULL(src) or src = "" then
		if Not isNull(data) or data = "" then
			NullFillWith = data
		 else
		 	NullFillWith = 0
		end if
	else
		If Not IsNumeric(src) then
			NullFillWith = Replace(Trim(src),"'","''")
		else
			NullFillWith = src
		End if
	end if
End Function

Function CurrURL()
	CurrURL = Request.ServerVariables("PATH_INFO")
End Function

Function CurrURLQ()
	CurrURLQ = "http://" & Request.ServerVariables("Server_name") & Request.ServerVariables("PATH_INFO")
	If Request.ServerVariables("REQUEST_METHOD") = "POST" then
		CurrURLQ = Request.ServerVariables("PATH_INFO") & "?" & Request.Form
	 else
 		CurrURLQ = Request.ServerVariables("PATH_INFO") & "?" & Request.QueryString
	End if
End Function

Function RefURLQ()
	dim strRef
	strRef = Split(Replace(request.ServerVariables("HTTP_REFERER"),"http://",""),"/")
	if ubound(strRef)>0 then
		RefURLQ = Replace(Replace(request.ServerVariables("HTTP_REFERER"),"http://",""),strRef(0),"")
	else
		RefURLQ = ""
	end if
End Function

'// 문자열내 CR/LF를 <BR>태그로 치환 //
function nl2br(v)
	if IsNull(v) then
		nl2br = ""
		Exit function
	end if

    v = Replace(v, vbcrlf,"<br />")
    v = Replace(v, vbCr,"<br />")
    v = Replace(v, vbLf,"<br />")
    nl2br = v
end function

'// 상품 이미지 경로를 계산하여 반환 //
function GetImageSubFolderByItemid(byval iitemid)
    if (iitemid <> "") then
	    GetImageSubFolderByItemid = Num2Str(CStr(Clng(iitemid) \ 10000),2,"0","R")
	else
	    GetImageSubFolderByItemid = ""
	end if
end function

'// get 스트링 형태로 넘어온 데이터를 post 형태로 변경
Sub sbPostDataToHtml(ByVal strPostData)
	If Trim(strPostData) = "" Then Exit Sub

	Dim arrTemp	: arrTemp = Split(strPostData, "&")
	Dim arrData	: arrData	= Null
	Dim intTemp

	If IsArray(arrTemp) Then
		For intTemp = 0 To Ubound(arrTemp) - 1
			arrData = Split(arrTemp(intTemp), "=")
			%>
			<input type="hidden" name="<%= arrData(0)%>" value="<%= arrData(1)%>">
			<%
		Next
	End If
End Sub

'// 내용에 금지어가 있는지 검사 //
function checkNotValidTxt(ostr)
	dim LcaseStr, sNotValid, arrNotValid,i
	checkNotValidTxt = false

	' html 태그 검사
	IF (checkNotValidHTML(ostr)) THEN
		checkNotValidTxt = true
		exit function
	END IF

	'금지어 정의
	sNotValid = "010.;010-;011.;011-;016.;016-;018.;018-;019.;019-"
	arrNotValid = split(sNotValid,";")

	LcaseStr = Lcase(ostr)
	LcaseStr = Replace(LcaseStr," ","")

	'금지어 검¬
	for i =0 to uBound(arrNotValid)
	if InStr(LcaseStr,trim(arrNotValid(i)))>0 then
		checkNotValidTxt = true
		exit function
	end if
	next

end function

'// 내용에 금지된 HTML태그가 있는지 검사 //
function checkNotValidHTML(ostr)
	checkNotValidHTML = false

	dim LcaseStr
	LcaseStr = Lcase(ostr)
	LcaseStr = Replace(LcaseStr," ","")

	if InStr(LcaseStr,"<script")>0 or InStr(LcaseStr,"<object")>0 then
		checkNotValidHTML = true
	end if

	if InStr(LcaseStr,"</iframe>")>0 or InStr(LcaseStr,"<iframe>")>0 or InStr(LcaseStr,"iframe")>0 then
		checkNotValidHTML = true
	end if

	if InStr(LcaseStr,"imgsrc")>0 or InStr(LcaseStr,"ahref")>0 or InStr(LcaseStr,"src=")>0 then
		checkNotValidHTML = true
	end if

	if InStr(LcaseStr,"<body")>0 or InStr(LcaseStr,"<input")>0 or InStr(LcaseStr,"<select")>0 or InStr(LcaseStr,"<textarea")>0 then
		checkNotValidHTML = true
	end if

	if InStr(LcaseStr,"onload=")>0 or InStr(LcaseStr,"onunload=")>0 or InStr(LcaseStr,"onclick=")>0 or InStr(LcaseStr,"onscroll=")>0 or InStr(LcaseStr,"onblur=")>0 then
		checkNotValidHTML = true
	end if

	if InStr(LcaseStr,"onkeyup=")>0 or InStr(LcaseStr,"onkeydown=")>0 or InStr(LcaseStr,"onkeypress=")>0 then
		checkNotValidHTML = true
	end if

	if InStr(LcaseStr,"onmouseover=")>0 or InStr(LcaseStr,"onmouseout=")>0 or InStr(LcaseStr,"onmousedown=")>0 then
		checkNotValidHTML = true
	end if

	if InStr(LcaseStr,".wmf")>0 or InStr(LcaseStr,".js")>0 then
		checkNotValidHTML = true
	end if
end function

'// 기존 블루등급 이상 신규 vip 등급 이상부터 오픈
'// 2018 회원등급 개편
Function IsSpecialShopUser()
	If GetLoginUserLevel() = "2" OR GetLoginUserLevel() = "3" OR GetLoginUserLevel() = "4" OR GetLoginUserLevel() = "6" OR GetLoginUserLevel() = "7" OR GetLoginUserLevel() = "8" Then
    	IsSpecialShopUser = True
    Else
		IsSpecialShopUser = False
	End If
End Function

'// 등급별 할인율
'// 2018 회원등급 개편
Function getSpecialShopPercent()
	SELECT Case GetLoginUserLevel()
		case "2" : getSpecialShopPercent = "15"
		case "3" : getSpecialShopPercent = "20"
		case "4" : getSpecialShopPercent = "25"
		case "6" : getSpecialShopPercent = "25"
		case "7" : getSpecialShopPercent = "25"
		case "8" : getSpecialShopPercent = "20"
	End SELECT
End Function

''//우수회원샵 상품 가격
'// 2018 회원등급 개편
function getSpecialShopItemPrice(orgprice)
    dim rPrice, ulevel
    rPrice = orgprice
    ulevel = CStr(GetLoginUserLevel())

    Select Case ulevel
		Case "2"
			'' VIP 15%
			rPrice = CLng(orgprice*0.85)
		Case "3"
			'' VIP GOLD 20%
			rPrice = CLng(orgprice*0.8)
		Case "4"
			'' VVIP 25%
			rPrice = CLng(orgprice*0.75)
		Case "6"
			'' VVIP 25%
			rPrice = CLng(orgprice*0.75)
		Case "7"
			'' STAFF 30%->25%로변경 20150112
			rPrice = CLng(orgprice*0.75)
		Case "8"
			'' FAMILY 20%
			rPrice = CLng(orgprice*0.8)
	end Select

	getSpecialShopItemPrice = rPrice
end function


'// 큰따옴표 input 박스 value=""에 사용할때 치환
Function doubleQuote(ByVal v)
	If IsNull(v) Then
		doubleQuote = ""
	Else
		doubleQuote = Replace(v, """","&quot;")
	End If
End Function


'// 문자열을 잘라 원하는 위치의 값을 반환 //
function SplitValue(orgStr,delim,pos)
    dim buf
    SplitValue = ""
    if IsNULL(orgStr) then Exit function
    if (Len(delim)<1) then Exit function
    buf = split(orgStr,delim)

    if UBound(buf)<pos then Exit function

    SplitValue = buf(pos)
end function


'// post형식의 데이타  스트링 형태로 변경
Function fnMakePostData()
	Dim strMethod			: strMethod			= Request.ServerVariables("REQUEST_METHOD")	' Form의 Method 정보

	'// 지역변수
	Dim strFormName
	Dim strPostData		: strPostData		= ""

	'// Post 형식일 경우 Form값을 String 형태로 취합한다.
	If Lcase(strMethod) = "post" Then
		For Each strFormName	 In Request.Form
				strPostData = strPostData & strFormName & "=" & Request.Form(strFormName) & "&"
		Next
	End If
	fnMakePostData =strPostData
End Function


'// 날짜를 지정된 문자형으로 변환 //
function FormatDate(ddate, formatstring)
	dim s
	Select Case formatstring
		Case "0000.00.00"
			s = CStr(year(ddate)) & "." &_
				Num2Str(month(ddate),2,"0","R") & "." &_
				Num2Str(day(ddate),2,"0","R")
		Case "0000-00-00"
			s = CStr(year(ddate)) & "-" &_
				Num2Str(month(ddate),2,"0","R") & "-" &_
				Num2Str(day(ddate),2,"0","R")
		Case "00000000"
			s = CStr(year(ddate)) &_
				Num2Str(month(ddate),2,"0","R") &_
				Num2Str(day(ddate),2,"0","R")
		Case "00000000000000"
			s = CStr(year(ddate))  &_
				Num2Str(month(ddate),2,"0","R") &_
				Num2Str(day(ddate),2,"0","R")  &_
				Num2Str(hour(ddate),2,"0","R")  &_
				Num2Str(minute(ddate),2,"0","R") &_
				Num2Str(Second(ddate),2,"0","R")
		Case "0000.00"
			s = CStr(year(ddate)) & "." &_
				Num2Str(month(ddate),2,"0","R")
		Case "0000.00.00-00:00:00"
			s = CStr(year(ddate)) & "." &_
				Num2Str(month(ddate),2,"0","R") & "." &_
				Num2Str(day(ddate),2,"0","R") & "-" &_
				Num2Str(hour(ddate),2,"0","R") & ":" &_
				Num2Str(minute(ddate),2,"0","R") & ":" &_
				Num2Str(Second(ddate),2,"0","R")
		Case "0000.00.00 00:00:00"
			s = CStr(year(ddate)) & "." &_
				Num2Str(month(ddate),2,"0","R") & "." &_
				Num2Str(day(ddate),2,"0","R") & " " &_
				Num2Str(hour(ddate),2,"0","R") & ":" &_
				Num2Str(minute(ddate),2,"0","R") & ":" &_
				Num2Str(Second(ddate),2,"0","R")
		Case "0000/00/00"
			s = CStr(year(ddate)) & "/" &_
				Num2Str(month(ddate),2,"0","R") & "/" &_
				Num2Str(day(ddate),2,"0","R")
		Case "00/00/00"
			s = Num2Str(right(year(ddate),2),2,"0","R") & "/" &_
				Num2Str(month(ddate),2,"0","R") & "/" &_
				Num2Str(day(ddate),2,"0","R")
		Case "00.00.00"
			s = Num2Str(right(year(ddate),2),2,"0","R") & "." &_
				Num2Str(month(ddate),2,"0","R") & "." &_
				Num2Str(day(ddate),2,"0","R")
		Case "00/00"
			s = Num2Str(month(ddate),2,"0","R") & "/" &_
				Num2Str(day(ddate),2,"0","R")
		Case "00.00"
			s = Num2Str(month(ddate),2,"0","R") & "." &_
				Num2Str(day(ddate),2,"0","R")
		Case "00:00" '시 분
			s = Num2Str(hour(ddate),2,"0","R") & ":" &_
				Num2Str(minute(ddate),2,"0","R")
		Case "00:00:00" '시 분 초
			s = Num2Str(hour(ddate),2,"0","R") & ":" &_
				Num2Str(minute(ddate),2,"0","R") & ":" &_
				Num2Str(Second(ddate),2,"0","R")
		Case "0000/00/00 00:00:00"
			s = CStr(year(ddate)) & "/" &_
				Num2Str(month(ddate),2,"0","R") & "/" &_
				Num2Str(day(ddate),2,"0","R") & " " &_
				Num2Str(hour(ddate),2,"0","R") & ":" &_
				Num2Str(minute(ddate),2,"0","R") & ":" &_
				Num2Str(Second(ddate),2,"0","R")
		Case Else
			s = CStr(ddate)
	End Select

	FormatDate = s
end function


'// 값비교 후 Return 값 like iif function
Function ChkIIF(trueOrFalse, trueVal, falseVal)
	if (trueOrFalse) then
	    ChkIIF = trueVal
	else
	    ChkIIF = falseVal
	end if
End Function


' request 대체 함(파라미터명, 디폴트값)
Function req(ByVal param, ByVal value)
'	VarType Return 값
'	0 (공백)
'	1 (널)
'	2 integer
'	3 Long
'	4 Single
'	5 Double
'	6 Currency
'	7 Date
'	8 String
'	9 OLE Object
'	10 Error
'	11 Boolean
'	12 Variant
'	13 Non-OLE Object
'	17 Byte
'	8192 Array

	Dim tmpValue

	If VarType(value) = 2 Or VarType(value) = 3 Or VarType(value) = 4 Or VarType(value) = 5 Or VarType(value) = 6 Then
		tmpValue = Replace(Trim(Request(param)),",","")
		If Not IsNumeric(tmpValue) Then	' 숫자가 아니면
			tmpValue = value
		End If
		tmpValue = CDbl(tmpValue)
	Else
		tmpValue = Trim(Request(param))
		If tmpValue = "" Then			' Request값이 없으면
			tmpValue = value
		End If
	End If
	req = tmpValue

End Function


' Null을 공백으로 치환
Function null2blank(ByVal v)
	If IsNull(v) Then
		null2blank = ""
	Else
		null2blank = v
	End If
End Function


' 페이징 함수 <%=fnPaging(페이지파라미터, 토탈레코드카운트, 현재페이지, 페이지사이즈, 블럭사이즈)
Function fnPaging(ByVal pageParam, ByVal iTotalCount, ByVal iCurrPage, ByVal iPageSize, ByVal iBlockSize)

	If iTotalCount = "" Then iTotalCount = 0
	Dim iTotalPage
	iTotalPage  = Int ( (iTotalCount - 1) / iPageSize ) + 1
	If iTotalCount = 0 Then	iTotalPage = 1

	Dim str, i, iStartPage
	Dim url, arr
	url = getThisFullURL()
	If InStr(url,pageParam) > 0 Then
		arr = Split(url, pageParam&"=")
		If UBOUND(arr) > 0 Then
			If InStr(arr(1),"&") Then
				url = arr(0) & Mid(arr(1),InStr(arr(1),"&")+1) & "&" & pageParam&"="
			Else
				url = arr(0) & pageParam&"="
			End If
		End If
	ElseIf InStr(url,"?") > 0 Then
		url = url & "&" &  pageParam & "="
	Else
		url = url & "?" &  pageParam & "="
	End If
	url = Replace(url,"?&","?")

	Dim imgPrev01, imgNext01, imgPrev02, imgNext02
	imgPrev01	= "<span class='elmBg prev'>이전 페이지</span>"
	imgNext01	= "<span class='elmBg next'>다음 페이지</span>"
'	imgPrev02	= "<img src=""http://fiximage.10x10.co.kr/web2009/common/btn_pageprev02.gif"" border=0 align=""absmiddle"">"
'	imgNext02	= "<img src=""http://fiximage.10x10.co.kr/web2009/common/btn_pagenext02.gif"" border=0 align=""absmiddle"">"


	' 시작페이지
	If (iCurrPage Mod iBlockSize) = 0 Then
		iStartPage = (iCurrPage - iBlockSize) + 1
	Else
		iStartPage = ((iCurrPage \ iBlockSize) * iBlockSize) + 1
	End If

	' 1 Page로 이동
'	str = str & "<a href=""" & url & "1"" class=""numArrow"">" & imgPrev02 & "</a>"
'	str = str & "&nbsp; &nbsp;"

	' 이전 Block으로 이동
	If (iCurrPage / iBlockSize) > 1 Then
		str = str & "<a href=""javascript:goPage(" & (iStartPage - iBlockSize) & ");"" class=""arrow"">" & imgPrev01 & "</a>"
	Else
		str = str & "<a href=""javascript:goPage(1);"" class=""arrow"">" & imgPrev01 & "</a>"
	End If
'	str = str & "&nbsp; &nbsp;"

	' 페이지 Count 루프
	i = iStartPage

	Do While ((i < iStartPage + iBlockSize) And (i <= iTotalPage))
		If i > iStartPage Then str = str & ""
		If Int(i) = Int(iCurrPage) Then
			str = str & "<a href=""javascript:goPage(" & i & ");"" class=""current""><span>" & i & "</span></a>"
		Else
			str = str & "<a href=""javascript:goPage(" & i & ");"" class=""""><span>" & i & "</span></a>"
		End If
		i = i + 1
	Loop

	' 다음 Block으로 이동
'	str = str & "&nbsp; &nbsp;"
	If (iStartPage+iBlockSize) < iTotalPage+1 Then
		str = str & "<a href=""javascript:goPage(" & i & ");"" class=""arrow"">" & imgNext01 & "</a>"
	Else
		str = str & "<a href=""javascript:goPage(" & iTotalPage & ");"" class=""arrow"">" & imgNext01 & "</a>"
	End If

	' 마지막 Page로 이동
'	str = str & "&nbsp; &nbsp;"
'	str = str & "<a href=""" & url & "" & iTotalPage & """>" & imgNext02 & "</a>"

	fnPaging	= str

End Function

' 현재 페이지 URL + 모든 파라미터
Function getThisFullURL()
	Dim url
	url = Request.ServerVariables("URL")
	If Request.ServerVariables("QUERY_STRING") <> "" Then
		url = url & "?" & Request.ServerVariables("QUERY_STRING")
	Else
		url = url & "?"
	End If

	Dim objItem
	For Each objItem In Request.Form
		url = url & objItem & "="
		url = url & Request.Form(objItem) & "&"
	Next

	getThisFullURL = url
End Function


'// 숫자 형식을 000NNNN 형식으로 변환  //
function Format00(totallength,orgData)
    Format00 = ""

    if IsNULL(orgData) then Exit Function

    Format00 = Num2Str(orgData,totallength,"0","R")
end function


Function TwoNumber(number)
	Dim vNumber
	If len(number) = 1 Then
		vNumber = "0" & number
	Else
		vNumber = number
	End If
	TwoNumber = vNumber
End Function


''// 공사중일때 회사IP외에는 지정페이지로 이동
Sub Underconstruction()
	if Not(isTenbyTenConnect) then
		Response.write "<html>"
		Response.write "<head>"
		Response.write "<meta http-equiv='content-type' content='text/html; charset=UTF-8' />"
		Response.write "<meta name='viewport' content='initial-scale=1.0; maximum-scale=1.0; minimum-scale=1.0; user-scalable=no; width=device-width;' />"
		Response.write "<title>10x10: 서비스 점검중</title>"
		Response.write "</head>"
		Response.write "<body>"
		Response.write "<img src='http://fiximage.10x10.co.kr/m/2017/common/renewalopen_info_banner.jpg' width='100%' alt='서비스 점검중' />"
		Response.write "</body>"
		Response.write "</html>"
		response.End
	end if
End Sub


''EMail ComboBox
function DrawEamilBoxHTML(frmName,txBoxName, cbBoxName,emailVal,classNm)
    dim RetVal, i, isExists : isExists=false
    dim eArr : eArr = Array("naver.com", "daum.net", "hanmail.net", "gmail.com", "nate.com", "empal.com")
	emailVal = LCase(emailVal)

    RetVal = "<input name='"&txBoxName&"' type='text' value='' style='display:none;width:40%;'/>&nbsp;"
    RetVal = RetVal & "<select name='"&cbBoxName&"' id='select3' class='"&classNm&"' onChange=""jsShowMailBox('"&frmName&"','"&cbBoxName&"','"&txBoxName&"');""\>"
    ''RetVal = RetVal & "<option value=''>메일선택</option>"
    for i=LBound(eArr) to UBound(eArr)
        if (eArr(i)=emailVal) then
            isExists = true
            RetVal = RetVal & "<option value='"&eArr(i)&"' selected>"&eArr(i)&"</option>"
        else
            RetVal = RetVal & "<option value='"&eArr(i)&"' >"&eArr(i)&"</option>"
        end if
    next

    if (Not isExists) and (emailVal<>"") then
        RetVal = RetVal & "<option value='"&emailVal&"' selected>"&emailVal&"</option>"
    end if
    RetVal = RetVal & "<option value='etc' >직접 입력</option>"
    RetVal = RetVal & "</select>"

    response.write RetVal

end Function


'// 무통장 입금 텐바이텐 계좌 //
Sub DrawTenBankAccount(accountnoName, accountno)
    dim buf
    buf = "<select name='" & accountnoName & "' class='postinput' style='width:95%; height:18px;'>"
    buf = buf & "<option value='국민 470301-01-014754' " & ChkIIF(accountno="국민 470301-01-014754","selected","") & " >국민은행 470301-01-014754</option>"
    buf = buf & "<option value='신한 100-016-523130' " & ChkIIF(accountno="신한 100-016-523130","selected","") & " >신한은행 100-016-523130</option>"
    buf = buf & "<option value='우리 092-275495-13-001' " & ChkIIF(accountno="우리 092-275495-13-001","selected","") & " >우리은행 092-275495-13-001</option>"
    buf = buf & "<option value='하나 146-910009-28804' " & ChkIIF(accountno="하나 146-910009-28804","selected","") & " >하나은행 146-910009-28804</option>"
    buf = buf & "<option value='기업 277-028182-01-046' " & ChkIIF(accountno="기업 277-028182-01-046","selected","") & " >기업은행 277-028182-01-046</option>"
    buf = buf & "<option value='농협 029-01-246118' " & ChkIIF(accountno="농협 029-01-246118","selected","") & " >농 협 029-01-246118</option>"
    buf = buf & "</select>"

    response.write buf
end Sub

'//바이너리 데이터 TEXT형태로 변환
Function  BinaryToText(BinaryData, CharSet)
	 Const adTypeText = 2
	 Const adTypeBinary = 1

	 Dim BinaryStream
	 Set BinaryStream = CreateObject("ADODB.Stream")

	'원본 데이터 타입
	 BinaryStream.Type = adTypeBinary

	 BinaryStream.Open
	 BinaryStream.Write BinaryData
	 ' binary -> text
	 BinaryStream.Position = 0
	 BinaryStream.Type = adTypeText

	' 변환할 데이터 캐릭터셋
	 BinaryStream.CharSet = CharSet

	'변환한 데이터 반환
	 BinaryToText = BinaryStream.ReadText

	 Set BinaryStream = Nothing
End Function

'욕파일 한글 불러오기 2017-02-10 유태욱
Function ReadTextFile(FileName, CharSet)
	Const adTypeText = 2

	Dim BinaryStream
	Set BinaryStream = CreateObject("ADODB.Stream")

	BinaryStream.Type = adTypeText

	If Len(CharSet) > 0 Then
	BinaryStream.CharSet = CharSet
	End If

	BinaryStream.Open

	BinaryStream.LoadFromFile FileName

	ReadTextFile = BinaryStream.ReadText
End Function

Function CheckCurse (ByVal txt) '욕 체크 2012-01-02 이종화
	Const Filename = "/curse.txt"
	Const ForReading = 1, ForWriting = 2, ForAppending = 3
	Const TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0

	Dim FilePath
	FilePath =  server.mappath("/chtml/curse/")

	dim Contents
	Contents = ReadTextFile(Filepath&Filename, "utf-8")
'	Dim FSO
'	set FSO = server.createObject("Scripting.FileSystemObject")
'
'	if FSO.FileExists(Filepath&Filename) Then
'
'		Dim TextStream
'		Set TextStream = FSO.OpenTextFile(Filepath&Filename, ForReading, False, TristateUseDefault)
'
'		Dim Contents '욕 -_-
'		Contents = TextStream.ReadAll
'		TextStream.Close
'		Set TextStream = nothing
'	Else
'
'		Response.Write "<h3><i><font color=red> File " & Filename &_
'					   " does not exist</font></i></h3>"
'
'	End If
'	Set FSO = Nothing

	If Contents <> "" Then

		Dim aFile
		aFile = Split(Contents,",")

		Dim Bftxt
		Dim i , ii
		Dim rpsStr ,costStr ,lenStr

		For i = 0 To UBound(aFile)
			If InStr(1,txt,aFile(i)) <> "0" Then
				lenStr = Len(aFile(i))
				'길이 만큼 * 모양
				For ii = 1 To lenStr
					costStr = "*"
					rpsStr = rpsStr & costStr
				Next
				'기존 텍스트 변환
				txt = Replace(txt,aFile(i),rpsStr)
				'별모양 초기화
				rpsStr = ""
			End If
			Bftxt = txt
		Next
	End if
	CheckCurse = Bftxt
End function


'// 콤마로 구분된 배열값에 지정된 값이 있는지 반환
function chkArrValue(aVal,cVal)
	dim arrV, i
	chkArrValue = false
	arrV = split(aVal,",")
	for i=0 to ubound(arrV)
		if cStr(arrV(i))=cStr(cVal) then
			chkArrValue = true
			exit function
		end if
	next
end function

'// 콤마로 구분된 배열값에 지정된 값이 있는지 반환(지정길이)
function chkArrValueLen(aVal,cVal,lmt)
	dim arrV, i
	chkArrValueLen = false
	arrV = split(aVal,",")
	for i=0 to ubound(arrV)
		if left(arrV(i),lmt)=left(cVal,lmt) then
			chkArrValueLen = true
			exit function
		end if
	next
end function

'// 콤마로 구분된 배열들에 지정된 값이 있는지 반환 (같은 수의 배열중 1에 있으면 2의 값을 반환)
function chkArrSelVal(aVal1,aVal2,cVal)
	dim arrV1, arrV2, i
	arrV1 = split(aVal1,",")
	arrV2 = split(aVal2,",")
	for i=0 to ubound(arrV1)
		if cStr(arrV1(i))=cStr(cVal) then
			chkArrSelVal = arrV2(i)
			exit function
		end if
	next
end function


'// 은행 목록 //
Sub DrawBankCombo(selectedname,selectedId)
    dim buf

	buf = "<select name='" & selectedname & "' style='width:99%'>"
	buf = buf + "<option value='' " & chkIIF(selectedId="","selected","") & " ></option>"
	buf = buf + "<option value='경남'" & chkIIF(selectedId="경남","selected","") & " >경남</option>"
	buf = buf + "<option value='광주'" & chkIIF(selectedId="광주","selected","") & " >광주</option>"
	buf = buf + "<option value='국민'" & chkIIF(selectedId="국민","selected","") & " >국민</option>"
	buf = buf + "<option value='기업'" & chkIIF(selectedId="기업","selected","") & " >기업</option>"
	buf = buf + "<option value='농협'" & chkIIF(selectedId="농협","selected","") & " >농협</option>"
	buf = buf + "<option value='단위농협'" & chkIIF(selectedId="단위농협","selected","") & " >단위농협</option>"
	buf = buf + "<option value='대구'" & chkIIF(selectedId="대구","selected","") & " >대구</option>"
	buf = buf + "<option value='도이치'" & chkIIF(selectedId="도이치","selected","") & " >도이치</option>"
	buf = buf + "<option value='부산'" & chkIIF(selectedId="부산","selected","") & " >부산</option>"
	buf = buf + "<option value='산업'" & chkIIF(selectedId="산업","selected","") & " >산업</option>"
	buf = buf + "<option value='새마을금고'" & chkIIF(selectedId="새마을금고","selected","") & " >새마을금고</option>"
	buf = buf + "<option value='수협'" & chkIIF(selectedId="수협","selected","") & " >수협</option>"
	buf = buf + "<option value='신한'" & chkIIF(selectedId="신한","selected","") & " >신한</option>"
	buf = buf + "<option value='외환'" & chkIIF(selectedId="외환","selected","") & " >외환</option>"
	buf = buf + "<option value='우리'" & chkIIF(selectedId="우리","selected","") & " >우리</option>"
	buf = buf + "<option value='우체국'" & chkIIF(selectedId="우체국","selected","") & " >우체국</option>"
	buf = buf + "<option value='전북'" & chkIIF(selectedId="전북","selected","") & " >전북</option>"
	buf = buf + "<option value='제일'" & chkIIF(selectedId="제일","selected","") & " >제일</option>"
	buf = buf + "<option value='조흥'" & chkIIF(selectedId="조흥","selected","") & " >조흥</option>"
	buf = buf + "<option value='평화'" & chkIIF(selectedId="평화","selected","") & " >평화</option>"
	buf = buf + "<option value='하나'" & chkIIF(selectedId="하나","selected","") & " >하나</option>"
	buf = buf + "<option value='시티'" & chkIIF(selectedId="시티","selected","") & " >시티</option>"
	buf = buf + "<option value='카카오뱅크'" & chkIIF(selectedId="카카오뱅크","selected","") & " >카카오뱅크</option>"
	buf = buf + "<option value='홍콩샹하이'" & chkIIF(selectedId="홍콩샹하이","selected","") & " >홍콩샹하이</option>"
	buf = buf + "<option value='ABN암로은행'" & chkIIF(selectedId="ABN암로은행","selected","") & " >ABN암로은행</option>"
	buf = buf + "<option value='UFJ은행'" & chkIIF(selectedId="UFJ은행","selected","") & " >UFJ은행</option>"
	buf = buf + "<option value='신협'" & chkIIF(selectedId="신협","selected","") & " >신협</option>"
	buf = buf + "</select>"

	response.write buf
end Sub

'// 은행 목록 apps //
Sub DrawBankCombo_Apps(selectedname,selectedId)
    dim buf

	buf = "<select name='" & selectedname & "' id='bank' class='form full-size'>"
	buf = buf + "<option value='' " & chkIIF(selectedId="","selected","") & " ></option>"
	buf = buf + "<option value='경남'" & chkIIF(selectedId="경남","selected","") & " >경남</option>"
	buf = buf + "<option value='광주'" & chkIIF(selectedId="광주","selected","") & " >광주</option>"
	buf = buf + "<option value='국민'" & chkIIF(selectedId="국민","selected","") & " >국민</option>"
	buf = buf + "<option value='기업'" & chkIIF(selectedId="기업","selected","") & " >기업</option>"
	buf = buf + "<option value='농협'" & chkIIF(selectedId="농협","selected","") & " >농협</option>"
	buf = buf + "<option value='단위농협'" & chkIIF(selectedId="단위농협","selected","") & " >단위농협</option>"
	buf = buf + "<option value='대구'" & chkIIF(selectedId="대구","selected","") & " >대구</option>"
	buf = buf + "<option value='도이치'" & chkIIF(selectedId="도이치","selected","") & " >도이치</option>"
	buf = buf + "<option value='부산'" & chkIIF(selectedId="부산","selected","") & " >부산</option>"
	buf = buf + "<option value='산업'" & chkIIF(selectedId="산업","selected","") & " >산업</option>"
	buf = buf + "<option value='새마을금고'" & chkIIF(selectedId="새마을금고","selected","") & " >새마을금고</option>"
	buf = buf + "<option value='수협'" & chkIIF(selectedId="수협","selected","") & " >수협</option>"
	buf = buf + "<option value='신한'" & chkIIF(selectedId="신한","selected","") & " >신한</option>"
	buf = buf + "<option value='외환'" & chkIIF(selectedId="외환","selected","") & " >외환</option>"
	buf = buf + "<option value='우리'" & chkIIF(selectedId="우리","selected","") & " >우리</option>"
	buf = buf + "<option value='우체국'" & chkIIF(selectedId="우체국","selected","") & " >우체국</option>"
	buf = buf + "<option value='전북'" & chkIIF(selectedId="전북","selected","") & " >전북</option>"
	buf = buf + "<option value='제일'" & chkIIF(selectedId="제일","selected","") & " >제일</option>"
	buf = buf + "<option value='조흥'" & chkIIF(selectedId="조흥","selected","") & " >조흥</option>"
	buf = buf + "<option value='평화'" & chkIIF(selectedId="평화","selected","") & " >평화</option>"
	buf = buf + "<option value='하나'" & chkIIF(selectedId="하나","selected","") & " >하나</option>"
	buf = buf + "<option value='시티'" & chkIIF(selectedId="시티","selected","") & " >시티</option>"
	buf = buf + "<option value='홍콩샹하이'" & chkIIF(selectedId="홍콩샹하이","selected","") & " >홍콩샹하이</option>"
	buf = buf + "<option value='ABN암로은행'" & chkIIF(selectedId="ABN암로은행","selected","") & " >ABN암로은행</option>"
	buf = buf + "<option value='UFJ은행'" & chkIIF(selectedId="UFJ은행","selected","") & " >UFJ은행</option>"
	buf = buf + "<option value='신협'" & chkIIF(selectedId="신협","selected","") & " >신협</option>"
	buf = buf + "</select>"

	response.write buf
end Sub

'// 은행 목록 예치금 //
Sub DrawBankComboForSCM(selectedname,selectedId)
    dim buf

	buf = "<select name='" & selectedname & "' id='bank' class='form full-size'>"
	buf = buf + "<option value='' " & chkIIF(selectedId="","selected","") & " >은행을 선택해주세요.</option>"
	buf = buf + "<option value='경남'" & chkIIF(selectedId="경남","selected","") & " >경남</option>"
	buf = buf + "<option value='광주'" & chkIIF(selectedId="광주","selected","") & " >광주</option>"
	buf = buf + "<option value='국민'" & chkIIF(selectedId="국민","selected","") & " >국민</option>"
	buf = buf + "<option value='기업'" & chkIIF(selectedId="기업","selected","") & " >기업</option>"
	buf = buf + "<option value='농협'" & chkIIF(selectedId="농협","selected","") & " >농협</option>"
	buf = buf + "<option value='단위농협'" & chkIIF(selectedId="단위농협","selected","") & " >단위농협</option>"
	buf = buf + "<option value='대구'" & chkIIF(selectedId="대구","selected","") & " >대구</option>"
	buf = buf + "<option value='도이치'" & chkIIF(selectedId="도이치","selected","") & " >도이치</option>"
	buf = buf + "<option value='부산'" & chkIIF(selectedId="부산","selected","") & " >부산</option>"
	buf = buf + "<option value='산업'" & chkIIF(selectedId="산업","selected","") & " >산업</option>"
	buf = buf + "<option value='새마을금고'" & chkIIF(selectedId="새마을금고","selected","") & " >새마을금고</option>"
	buf = buf + "<option value='수협'" & chkIIF(selectedId="수협","selected","") & " >수협</option>"
	buf = buf + "<option value='신한'" & chkIIF(selectedId="신한","selected","") & " >신한</option>"
	buf = buf + "<option value='KEB하나'" & chkIIF(selectedId="KEB하나","selected","") & " >KEB하나</option>"
	buf = buf + "<option value='우리'" & chkIIF(selectedId="우리","selected","") & " >우리</option>"
	buf = buf + "<option value='케이뱅크'" & chkIIF(selectedId="케이뱅크","selected","") & " >케이뱅크</option>"
	buf = buf + "<option value='카카오뱅크'" & chkIIF(selectedId="카카오뱅크","selected","") & " >카카오뱅크</option>"
	buf = buf + "<option value='우체국'" & chkIIF(selectedId="우체국","selected","") & " >우체국</option>"
	buf = buf + "<option value='전북'" & chkIIF(selectedId="전북","selected","") & " >전북</option>"
	buf = buf + "<option value='제일'" & chkIIF(selectedId="제일","selected","") & " >제일</option>"
	buf = buf + "<option value='시티'" & chkIIF(selectedId="시티","selected","") & " >시티</option>"
	buf = buf + "<option value='홍콩샹하이'" & chkIIF(selectedId="홍콩샹하이","selected","") & " >홍콩샹하이</option>"
	buf = buf + "<option value='ABN암로은행'" & chkIIF(selectedId="ABN암로은행","selected","") & " >ABN암로은행</option>"
	buf = buf + "<option value='UFJ은행'" & chkIIF(selectedId="UFJ은행","selected","") & " >UFJ은행</option>"
	buf = buf + "<option value='신협'" & chkIIF(selectedId="신협","selected","") & " >신협</option>"
	buf = buf + "<option value='제주'" & chkIIF(selectedId="제주","selected","") & " >제주</option>"
	buf = buf + "<option value='현대스위스상호저축은행'" & chkIIF(selectedId="현대스위스상호저축은행","selected","") & " >현대스위스상호저축은행</option>"
	buf = buf + "</select>"

	response.write buf
end Sub

''쿠키에 넣을때 사용 / 아이디 단방향 해쉬값 : 사용시 md5 필요. (md5 부하 심할경우 component, db 이용 가능)
function HashTenID(byval oid)
    dim orgid : orgid = LCASE(oid)
    dim hashid

    HashTenID = orgid
    if Len(orgid)<1 then Exit function      ''빈값인경우 원래값
    if Len(orgid)<2 then orgid=orgid+"1"    ''길이가1일경우 오류피함.


    hashid = Right(orgid,4) + Left(orgid,Len(orgid)-1)
    hashid = Right(hashid,5) + Left(hashid,Len(hashid)-2)
    hashid = Right(hashid,6) + Left(hashid,Len(hashid)-3)
    hashid = Right(hashid,7) + Left(hashid,Len(hashid)-4)
    hashid = Right(hashid,8) + Left(hashid,Len(hashid)-5)
    HashTenID = MD5(hashid)

end function

''쿠키 조작 검증이 필요한곳에서 기존 getLoginUserID 대신 사용
function getEncLoginUserID()
    dim ret : ret=""
    dim planid : planid = getLoginUserID()
    dim encedID : encedID = request.cookies("uinfo")("shix")      ''암호화된쿠키값.
    getEncLoginUserID = ret

    if (planid="") then Exit function   '' 아이디 쿠키값없으면 로그인 안된것임

    if (encedID="") then encedID = request.cookies("mssn")("shix")

    if (UCASE(HashTenID(planid))=UCASE(encedID)) then   ' '' 더이상 필요 없을듯한데..
        getEncLoginUserID = planid
        Exit function
    end if

    if (encedID="") and (LCASE(planid)=LCASE(session("ssnuserid"))) then
        getEncLoginUserID = planid
        Exit function
    end if

'    if (encedID="") then                '' 암호화된값이 없으면. 암호화전 운영인경우가 있으므로 일단 정상으로 판단. 차후 주석처리
'        getEncLoginUserID = planid
'        Exit function
'    end if

    ''다른경우 조작된 경우임.
    ''관리자에게 메세지발송
    On Error Resume Next
    call InfoMsgMailSend("planid="&planid&"<br />"&"encedID="&encedID)
    On Error Goto 0

    ''진행 계속 못함 (버퍼링 삭제 후 로그아웃!)
	If Response.Buffer Then
		Response.Clear
		Response.ContentType = "text/html"
		Response.Expires = 0
	End If
    response.write "<script>" & vbCrLf &_
    			   " alert('죄송합니다. 암호화 처리중 오류가 발생하였습니다. 다시 로그인후 이용해주세요.');" & vbCrLf &_
    			   " document.location = '/login/dologout.asp';" & vbCrLf &_
    			   "</script>"
    response.end

end function


''관리자에게 메세지 발송 (검증페이지에서 사용.)
function InfoMsgMailSend(paramMsg)
    dim strMsg, strMethod
    dim lngMaxFormBytes : lngMaxFormBytes =800
    strMsg = strMsg & "<li>서버:<br />"
	strMsg = strMsg & application("Svr_Info")
	strMsg = strMsg & "<br/ ><br /></li>"

	'// 접속자 브라우저 정보
	strMsg = strMsg & "<li>브라우저 종류:<br />"
	strMsg = strMsg & Server.HTMLEncode(Request.ServerVariables("HTTP_USER_AGENT"))
	strMsg = strMsg & "<br /><br /></li>"
	strMsg = strMsg & "<li>접속자 IP:<br />"
	strMsg = strMsg & Server.HTMLEncode(Request.ServerVariables("REMOTE_ADDR"))
	strMsg = strMsg & "<br /><br /></li>"
	strMsg = strMsg & "<li>경유페이지:<br />"
	strMsg = strMsg & request.ServerVariables("HTTP_REFERER")
	strMsg = strMsg & "<br /><br /></li>"
	'// 오류 페이지 정보
	strMsg = strMsg & "<li>페이지:<br />"
	strMethod = Request.ServerVariables("REQUEST_METHOD")
	strMsg = strMsg & "HOST : " & Request.ServerVariables("HTTP_HOST") & "<BR />"
	strMsg = strMsg & strMethod & " : "

	If strMethod = "POST" Then
		strMsg = strMsg & Request.TotalBytes & " bytes to "
	End If

	strMsg = strMsg & Request.ServerVariables("SCRIPT_NAME")
	strMsg = strMsg & "</li>"

	If strMethod = "POST" Then
		strMsg = strMsg & "<br /><li>POST Data:<br />"

		'실행에 관련된 에러를 출력합니다.
		On Error Resume Next
		If Request.TotalBytes > lngMaxFormBytes Then
			strMsg = strMsg & Server.HTMLEncode(Left(Request.Form, lngMaxFormBytes)) & " . . ."'
		Else
			strMsg = strMsg & Server.HTMLEncode(Request.Form)
		End If
		On Error Goto 0
		strMsg = strMsg & "</li>"
	elseif strMethod = "GET" then
		strMsg = strMsg & "<br /><li>GET Data:<br />"
		strMsg = strMsg & Request.QueryString
	End If
	strMsg = strMsg & "<br /><br /></li>"

    '### 시스템팀 구성원에게 오류 발생 내용 발송 ###
	dim cdoMessage,cdoConfig

	Set cdoConfig = CreateObject("CDO.Configuration")
	'-> 서버 접근방법을 설정합니다
	cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2 '1 - (cdoSendUsingPickUp)  2 - (cdoSendUsingPort)
	'-> 서버 주소를 설정합니다
	cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver")="webadmin.10x10.co.kr"
	'-> 접근할 포트번호를 설정합니다
	cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
	'-> 접속시도할 제한시간을 설정합니다
	cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 30
	'-> SMTP 접속 인증방법을 설정합니다
	cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
	'-> SMTP 서버에 인증할 ID를 입력합니다
	cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "MailSendUser"
	'-> SMTP 서버에 인증할 암호를 입력합니다
	cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "wjddlswjddls"
	cdoConfig.Fields.Update

	Set cdoMessage = CreateObject("CDO.Message")
	Set cdoMessage.Configuration = cdoConfig

	cdoMessage.To 		= "kobula@10x10.co.kr;tozzinet@10x10.co.kr"
	cdoMessage.From 	= "webserver@10x10.co.kr"
	cdoMessage.SubJect 	= "["&date()&"] 10x10페이지 메세지 발생"
	cdoMessage.HTMLBody	= strMsg & "<br /><li>Message:<br />" & paramMsg &"</li>"

	cdoMessage.BodyPart.Charset="ks_c_5601-1987"         '/// 한글을 위해선 꼭 넣어 주어야 합니다.
    cdoMessage.HTMLBodyPart.Charset="ks_c_5601-1987"     '/// 한글을 위해선 꼭 넣어 주어야 합니다.

	cdoMessage.Send

	Set cdoMessage = nothing
	Set cdoConfig = nothing
end function

'// 자동로그인 확인(2011.12.09; 허진원 추가)
Sub chk_AutoLogin()
    '' 이 함수는 이제 그만 사용하자 .. 2018/08/20
	Exit Sub

	dim iflgDvc, ssnlogindt

	if Not(IsUserLoginOK) and request.cookies("mSave")("SAVED_AUTO")<>"" then
		if (request.Cookies("mssn")("ssnhash")="") then  ''2018/08/18 '' 이값이 있으면 tenSesionLib 에서 로그인처리를 한다.
			if tenDec(request.cookies("mSave")("SAVED_ID"))<>"" and tenDec(request.cookies("mSave")("SAVED_PW"))<>"" then
				on Error Resume Next
				iflgDvc = flgDevice
				'#HTTP통신으로 회원정보 확인
				dim objXML, xmlDOM, unm
				Set objXML= CreateObject("MSXML2.ServerXMLHTTP.3.0")
				objXML.Open "POST", web1URL & "/login/m/actLoginData.asp", false
				objXML.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
				objXML.Send("userid=" & server.URLEncode(request.cookies("mSave")("SAVED_ID")) & "&userpass=" & server.URLEncode(request.cookies("mSave")("SAVED_PW")) & "&device=" & iflgDvc &"&refip="&Request.ServerVariables("REMOTE_ADDR")&"&iggsn="&fn_getGgsnCookie())
				If objXML.Status = "200" Then

					'//전달받은 내용 확인
					'response.write BinaryToText(objXML.ResponseBody, "UTF-8")
					'response.End

					'XML을 담을 DOM 객체 생성
					Set xmlDOM = Server.CreateObject("MSXML2.DomDocument.3.0")
					xmlDOM.async = False
					'DOM 객체에 XML을 담는다.(바이너리 데이터로 받아서 UTF-8로 변환(한글문제))
					xmlDOM.LoadXML BinaryToText(objXML.ResponseBody, "UTF-8")

					unm = xmlDOM.getElementsByTagName("username").item(0).text
					if Not(unm="" or isNull(unm)) then
						response.Cookies("uinfo").domain = "10x10.co.kr"
						'response.Cookies("uinfo")("muserid") = tenDec(request.cookies("mSave")("SAVED_ID"))
						'response.Cookies("uinfo")("musername") = xmlDOM.getElementsByTagName("username").item(0).text
						'response.Cookies("uinfo")("muserdiv") = xmlDOM.getElementsByTagName("userdiv").item(0).text
						'response.cookies("uinfo")("muserlevel") = xmlDOM.getElementsByTagName("userlevel").item(0).text
						'response.cookies("uinfo")("mrealnamecheck") = xmlDOM.getElementsByTagName("realchk").item(0).text

						response.cookies("uinfo")("shix") = xmlDOM.getElementsByTagName("shix").item(0).text        '''201212 추가.

						response.Cookies("etc").domain = "10x10.co.kr"
						response.cookies("etc")("mcouponCnt") = xmlDOM.getElementsByTagName("coupon").item(0).text
						response.cookies("etc")("mcurrentmile") = xmlDOM.getElementsByTagName("mileage").item(0).text
						response.cookies("etc")("currtencash") = xmlDOM.getElementsByTagName("currtencash").item(0).text
						response.cookies("etc")("currtengiftcard") = xmlDOM.getElementsByTagName("currtengiftcard").item(0).text
						response.cookies("etc")("cartCnt") = xmlDOM.getElementsByTagName("cartCnt").item(0).text
						response.Cookies("etc")("ordCnt") = xmlDOM.getElementsByTagName("ordCnt").item(0).text
						response.Cookies("etc")("musericonNo") = xmlDOM.getElementsByTagName("usericonNo").item(0).text
						response.Cookies("etc")("logindate") = now()

						'' 2018/08/18 TenSessionLib    ===============================
						ssnlogindt = fnDateTimeToLongTime(now())  '' reqire tenSEssionLib
						response.Cookies("mssn").domain = "10x10.co.kr"
						response.Cookies("mssn")("ssndt") = ssnlogindt
						response.cookies("mssn")("shix") = xmlDOM.getElementsByTagName("shix").item(0).text

						session("ssnuserid")  = LCase(ouser.FOneUser.FUserID)
						session("ssnlogindt") = ssnlogindt
						session("ssnlastcheckdt") = ssnlogindt

						session("ssnusername") 	= ouser.FOneUser.FUserName
						session("ssnuserdiv") 	= ouser.FOneUser.FUserDiv
						session("ssnuserlevel")	= CStr(ouser.FOneUser.FUserLevel)
						session("ssnrealnamecheck")	= ouser.FOneUser.FRealNameCheck
						session("ssnuseremail")	= ouser.FOneUser.FUserEmail

						Dim isSSnLongKeep : isSSnLongKeep = 1  '' 값이 1이면 길게 유지
						Dim retSsnHash
						retSsnHash = fnDBSessionCreateV2("K",isSSnLongKeep)  ''2018/08/07
						if (isSSnLongKeep>0) then
							response.cookies("mssn").Expires = Date + 15     '' tensessionLib 참고.
							response.Cookies("mssn")("dtauto") = ssnlogindt  '' 로그인 유지일경우 로그인 세팅한 날짜를 넣자.
						end if
						response.Cookies("mssn")("ssnhash") = retSsnHash
						session("ssnhash") = retSsnHash
						'' ==========================================================

						'####### 쇼핑톡 나의글에 새의견이 있는지 체크. 있으면 쿠키에 담음. ("uinfo")("isnewcomm")
						Dim vQuery, vCnt
						vCnt = 0
						vQuery = "EXECUTE [db_board].[dbo].[sp_Ten_ShoppingTalk_MyTalkCommCheck] '" & tenDec(request.cookies("mSave")("SAVED_ID")) & "'"
						rsget.Open vQuery,dbget,1
						If Not rsget.Eof Then
							vCnt = rsget(0)
						End IF
						rsget.close()
						If vCnt > 0 Then
							response.Cookies("uinfo")("isnewcomm") = "o"
						End If
					else
						response.Cookies("mSave").domain = "10x10.co.kr"
						response.cookies("mSave") = ""
						response.Cookies("mSave").Expires = Date - 1
					end if

					Set xmlDOM = Nothing
				else
					response.Cookies("mSave").domain = "10x10.co.kr"
					response.cookies("mSave") = ""
					response.Cookies("mSave").Expires = Date - 1
				end if

				Set objXML= Nothing

				on Error Goto 0
			end if
		end if
	end if
end Sub

Sub chk_SsnLoginEvalMonthCoupon()
    '' 1. 자동로그인에 대한 loginlog / lastLogindate 처리. => tenSesionLib 에서 처리하는것으로 변경
	'' 2. 월이 지났을 경우 쿠폰 발행 처리. (자동로그인, 일반 둘다.)
	if (Not IsUserLoginOK) then Exit Sub
	if (session("ltimeloginchk")<>"") then Exit Sub '' 함 체크 했으믄 그만.

	dim lgDt : lgDt = request.cookies("mssn")("dtauto") ''자동로그인체크시각 (자동로그인 한경우)
	if (lgDt="") then lgDt = request.Cookies("mssn")("ssndt")

	if (lgDt="") then Exit Sub  '' 없으면 상관없음.
	if (NOT IsNumeric(lgDt)) then Exit Sub

	if (DateDiff("h",DateSerial(Year(date),Month(date),1), now) < 4) then Exit Sub '' 월초 1일 4시 전은 동작하지 말자..

	dim isRequireCpnEval : isRequireCpnEval = FALSE
	dim isRequireReAutologinSet : isRequireReAutologinSet = FALSE

    dim iorginDt : iorginDt = Now()
    dim nowDt : nowDt = Year(iorginDt)&Right("00"&Month(iorginDt),2)&Right("00"&Day(iorginDt),2)&Right("00"&Hour(iorginDt),2)&Right("00"&Minute(iorginDt),2)&Right("00"&Second(iorginDt),2)

	Dim diffTime
	diffTime = CLNG((nowDt-lgDt)/60/60)  '' 경과시간

	if NOT (LEFT(nowDt,6)>LEFT(lgDt,6)) then Exit Sub '' 달이 지난경우만 상관있음.

	if (getLoginUserDiv="01") or (getLoginUserDiv="05") or (getLoginUserDiv="99") then
		Call PublishMonthUserLevelBonushCoupon(getLoginUserID)
	end if

	session("ltimeloginchk") = lgDt
End Sub

''userloginclass 에서도 사용가능하다.
Sub PublishMonthUserLevelBonushCoupon(iuserid)
	'' 로그를 쌓아보자.
	dim iAddLogs
    iAddLogs = "r=mcpneval"
    if (request.ServerVariables("QUERY_STRING")<>"") then iAddLogs="&"&iAddLogs
    response.AppendToLog iAddLogs&"&"

	''로그방식으로 변경. 2018/08/31  in tenSessionLib.fnChkSsnLoginEvalMonthCoupon
	Exit Sub '''''''''''''''''''''''

end Sub

'// 로그인 유효기간 확인(2015.07.07; 허진원 추가)
Sub chk_ValidLogin()
    '' 그만 사용 2018/08/19
    exit Sub


''	dim lgDt : lgDt = LEFT(request.Cookies("etc")("logindate"),10) ''left 추가 2015/07/16
''	dim isChk : isChk=false
''
''	if lgDt<>"" and IsUserLoginOK then
''		if isDate(lgDt) then
''			if datediff("m",lgDt,now)=0 then
''				isChk = true
''			end if
''		else
''			isChk = true
''		end if
''	end if
''
''	''2018/08/18 다른방식의 처리가 필요함
''	'' ("etc")("logindate") 대신 ("mssn")("ssndt") 를 쓰는게 좋을듯...
''	'' 월이 바뀌면. Cookies("mssn")("ssndt") / session("ssnlogindt") 로 체크 하여 쿠폰 프로세스를 태운다.
''	'' lastlogin 정보를 업데이트하고, loginlog에도 쌓아준다 (휴면계정 관련) active User 수 관련 있을듯함..
''
''
''	Exit Sub
''
''
''	// 로그아웃 처리
''	if Not(isChk) and IsUserLoginOK then
''		response.Cookies("uinfo").domain = "10x10.co.kr"
''		response.Cookies("uinfo") = ""
''		response.Cookies("uinfo").Expires = Date - 1
''
''		response.Cookies("etc").domain = "10x10.co.kr"
''		response.Cookies("etc") = ""
''		response.Cookies("etc").Expires = Date - 1
''
''		response.Cookies("mybadge").domain = "10x10.co.kr"
''		response.Cookies("mybadge") = ""
''		response.Cookies("mybadge").Expires = Date - 1
''	end if
end Sub

'// 로그인 로그 입력만 한다.
Function MyBadge_IsExist_LoginDateCookie()
	dim loginDate, currDate

	MyBadge_IsExist_LoginDateCookie = False

	loginDate = request.cookies("mybadge")("logindate")
	if (Len(loginDate) <> 13) then
		exit Function
	end if

	currDate = Left(FormatDate(Now, "0000.00.00-00:00:00"), 13)

	if (Left(loginDate, 10) <> Left(currDate, 10)) then
		exit Function
	end if

	'' if (CInt(Right(loginDate,2)) < 4) and (CInt(Right(currDate,2)) >= 4) then
	'' 	exit Function
	'' end if

	MyBadge_IsExist_LoginDateCookie = True
end Function

'// 배열 치환
Sub ArraySwapRows(ary,row1,row2)
  Dim x,tempvar
  For x = 0 to Ubound(ary,2)
    tempvar = ary(row1,x)
    ary(row1,x) = ary(row2,x)
    ary(row2,x) = tempvar
  Next
End Sub  'SwapRows

'// 배열 정렬
Sub ArrayQuickSort(vec,loBound,hiBound,SortField)
  Dim pivot(),loSwap,hiSwap,temp,counter
  Redim pivot (Ubound(vec,2))

  if hiBound - loBound = 1 then
    if vec(loBound,SortField) > vec(hiBound,SortField) then Call ArraySwapRows(vec,hiBound,loBound)
  End If

  For counter = 0 to Ubound(vec,2)
    pivot(counter) = vec(int((loBound + hiBound) / 2),counter)
    vec(int((loBound + hiBound) / 2),counter) = vec(loBound,counter)
    vec(loBound,counter) = pivot(counter)
  Next

  loSwap = loBound + 1
  hiSwap = hiBound

  do
    while loSwap < hiSwap and vec(loSwap,SortField) <= pivot(SortField)
      loSwap = loSwap + 1
    wend

    while vec(hiSwap,SortField) > pivot(SortField)
      hiSwap = hiSwap - 1
    wend

    if loSwap < hiSwap then Call ArraySwapRows(vec,loSwap,hiSwap)

  loop while loSwap < hiSwap

  For counter = 0 to Ubound(vec,2)
    vec(loBound,counter) = vec(hiSwap,counter)
    vec(hiSwap,counter) = pivot(counter)
  Next

  if loBound < (hiSwap - 1) then Call ArrayQuickSort(vec,loBound,hiSwap-1,SortField)
  if hiSwap + 1 < hibound then Call ArrayQuickSort(vec,hiSwap+1,hiBound,SortField)

End Sub

'// ston캐시 서버 썸네일 제작(퀄러티 함께)
function getStonReSizeImg(furl,wd,ht,qua)
    getStonReSizeImg = furl&"/10x10/resize/"&wd&"x"&ht&"/quality/"&qua&"/"
end function

'// ston캐시 서버 썸네일 제작(기존 포토서버 썸네일 변경) - 리스트 위주
function getStonThumbImgURL(furl,wd,ht,fit,ws)
    getStonThumbImgURL = furl&"/10x10/resize/"&wd&"x"&ht&"/quality/85/"
end function

'// 포토서버 썸네일 제작(기존 파일명)
function getThumbImgFromURL(furl,wd,ht,fit,ws)
	dim sCmd

    ''ston cache Type
    'getThumbImgFromURL = furl&"/10x10/resize/"&wd&"x"&ht&"/"
    'Exit function

	'도메인 치환
	if instr(furl,"imgstatic")>0 then
		furl = replace(furl,"imgstatic.10x10.co.kr/","thumbnail.10x10.co.kr/imgstatic/")
	elseif instr(furl,"webimage")>0 then
		furl = replace(furl,"webimage.10x10.co.kr/","thumbnail.10x10.co.kr/webimage/")
	end if

	'썸네일 커맨드
	sCmd = "?cmd=thumb"
	if wd<>"" then sCmd = sCmd & "&w=" & wd
	if ht<>"" then sCmd = sCmd & "&h=" & ht
	if fit<>"" then sCmd = sCmd & "&fit=" & fit
	if ws<>"" then sCmd = sCmd & "&ws=" & ws

	'변환주소 반환
	getThumbImgFromURL = furl & sCmd
end function

'// 포토서버 흑백아이콘 제작(기존 파일명)
function getGrayImgFromURL(furl)
	dim sCmd

	'도메인 치환
	if instr(furl,"imgstatic")>0 then
		furl = replace(furl,"imgstatic.10x10.co.kr/","thumbnail.10x10.co.kr/imgstatic/")
	elseif instr(furl,"webimage")>0 then
		furl = replace(furl,"webimage.10x10.co.kr/","thumbnail.10x10.co.kr/webimage/")
	end if

	'썸네일 커맨드
	sCmd = "?cmd=gray"

	'변환주소 반환
	getGrayImgFromURL = furl & sCmd
end function

'// 숫자열을 화폐형으로 변환 //
function CurrFormat(byVal v)
	CurrFormat = FormatNumber(FormatCurrency(v),0)
end Function

'// 정규식 패턴지정 문자열 처리/반환
Function RepWord(str,patrn,repval)
	Dim regEx

	SET regEx = New RegExp
	regEx.Pattern = patrn			' 패턴을 설정.
	regEx.IgnoreCase = True			' 대/소문자를 구분하지 않도록 .
	regEx.Global = True				' 전체 문자열을 검색하도록 설정.
	RepWord = regEx.Replace(str,repval)
End Function


'// 패스워드 복잡성 검사 함수(웹용)
Function chkSimplePwdComplex(uid,pwd)
	dim msg, i, sT, sN
	msg = ""

	'비밀번호 길이 검사
	if len(pwd)<8 then
		msg = msg & "- 비밀번호는 최소 8자리이상으로 입력해주세요.\n"
	end if

	'아이디와 동일 또는 포함하고 있는가?
	''if instr(lcase(pwd),lcase(uid))>0 then
	''	msg = msg & "- 아이디와 동일하거나 아이디를 포함하고 있는 비밀번호입니다.\n"
	''end if
	if lcase(pwd)=lcase(uid) then
		msg = msg & "- 아이디와 동일한 비밀번호입니다.\n"
	end if

	'영문/숫자/특수문자 두가지 이상 조합
    dim aAlpha, aNumber, aSpecial, chkCnt
    chkCnt = 0
    aAlpha = "[a-zA-Z]"
    aNumber = "[0-9]"
    aSpecial = "[!|@|#|$|%|^|&|*|(|)|-|_|?]"

	if Not(chkWord(pwd,aAlpha)) then chkCnt = chkCnt+1
	if Not(chkWord(pwd,aNumber)) then chkCnt = chkCnt+1
	if Not(chkWord(pwd,aSpecial)) then chkCnt = chkCnt+1

	if chkCnt<2 then
		msg = msg & "- 패스워드는 영문/숫자/특수문자 중 두 가지 이상의 조합으로 입력해주세요.\n"
	end if

	'결과 반환
	chkSimplePwdComplex = msg
end Function

'//정규식 문자열 검사
Function chkWord(str,patrn)
    Dim regEx, match, matches

    SET regEx = New RegExp
    regEx.Pattern = patrn	' 패턴을 설정.
    regEx.IgnoreCase = True	' 대/소문자를 구분하지 않도록 .
    regEx.Global = True		' 전체 문자열을 검색하도록 설정.
    SET Matches = regEx.Execute(str)
	if 0 < Matches.count then
		chkWord= false
	Else
		chkWord= true
	end if

	'pattern0 = "[^가-힣]"  '한글만
	'pattern1 = "[^-0-9 ]"  '숫자만
	'pattern2 = "[^-a-zA-Z]"  '영어만
	'pattern3 = "[^-가-힣a-zA-Z0-9/ ]" '숫자와 영어 한글만
	'pattern4 = "<[^>]*>"   '태그만
	'pattern5 = "[^-a-zA-Z0-9/ ]"    '영어 숫자만
End Function

''프로필 이미지 번호가 0일경우 사용.
function getDefaultProfileImgNo(vuid)
    dim t : t = LEFT(vuid,1)
    if (t="") then
        getDefaultProfileImgNo = "1"
        exit function
    end if
    getDefaultProfileImgNo = cStr((ASC(t) mod 30)+1)
end function

'// 유저 프로필 이미지
Function GetUserProfileImg(inum,vuid)
	Dim Rvinum
	Rvinum = getNumeric(inum)

	If Rvinum="0" or Rvinum="" Then
	    Rvinum = getDefaultProfileImgNo(vuid)
	end if

	GetUserProfileImg = "http://fiximage.10x10.co.kr/m/2014/common/thumb_member"& Num2Str(Rvinum,2,"0","R") &".png"
End Function

Function fnBackPathURLChange(url)
	url = Replace(url,"/","%2F")
	url = Replace(url,".","%2E")
	url = Replace(url,"?","%3F")
	url = Replace(url,"=","%3D")
	url = Replace(url,"&","%26")
	fnBackPathURLChange = url
End Function

'// 해당경로에 파일이 있는지 체크한다.
Function checkFilePath(filePath)
	Dim fso, result
	Set fso = CreateObject("Scripting.FileSystemObject")
	If fso.Fileexists(filePath) Then
		result = 1
	Else
		result = 0
	End If
	checkFilePath = result
	Set fso = nothing
End Function

''EMail ComboBox
function DrawEamilBoxHTML_m(frmName,txBoxName, cbBoxName,emailVal,classNm1,classNm2,jscript1,jscript2)
    dim RetVal, i, isExists : isExists=false
    dim eArr : eArr = Array("naver.com","netian.com","paran.com","hanmail.net","dreamwiz.com","nate.com" _
                ,"empal.com","orgio.net","unitel.co.kr","chol.com","kornet.net","korea.com" _
                ,"freechal.com","hanafos.com","hitel.net","hanmir.com","hotmail.com")
	emailVal = LCase(emailVal)

    RetVal = "<input name='"&txBoxName&"' class='"&classNm1&"' type='text' value='' style='display:none;' "&jscript1&" />&nbsp;"
    RetVal = RetVal & "<select name='"&cbBoxName&"' id='select3' class='"&classNm2&"' "&jscript2&" \>"
    ''RetVal = RetVal & "<option value=''>메일선택</option>"
    for i=LBound(eArr) to UBound(eArr)
        if (eArr(i)=emailVal) then
            isExists = true
            RetVal = RetVal & "<option value='"&eArr(i)&"' selected>"&eArr(i)&"</option>"
        else
            RetVal = RetVal & "<option value='"&eArr(i)&"' >"&eArr(i)&"</option>"
        end if
    next

    if (Not isExists) and (emailVal<>"") then
        RetVal = RetVal & "<option value='"&emailVal&"' selected>"&emailVal&"</option>"
    end if
    RetVal = RetVal & "<option value='etc' >직접 입력</option>"
    RetVal = RetVal & "</select>"

    response.write RetVal

end Function

Function gaparamchk(url,gaparam)
	Dim rtnurl
	If InStr(url,"?") > 0 Or InStr(url,"&") > 0 Then
		rtnurl = gaparam
	Else
		rtnurl = Replace(gaparam,"&","?")
	End If

	gaparamchk = rtnurl
End Function

'// 최근본상품, 기획전, 이벤트, 검색어, 검색어를 통해서 들어온 상품상세 로그남김.(2017.01.11 원승현 생성)
Sub fnUserLogCheck(utype, uuserid, uitemid, uevtcode, urect, uplatform)

	If IsNull(uuserid) Or uuserid="" Then Exit Sub
	If IsNull(utype) Or utype="" Then Exit Sub

	On Error Resume Next

	If uitemid="" Then uitemid=0
	If uevtcode="" Then uevtcode=0
	If urect="" Then urect=""

    dim uCon : set uCon = CreateObject("ADODB.Connection")
    Dim cmd : set cmd = server.CreateObject("ADODB.Command")

    dim uResult

    dim sqlStr

	''소스통일  2017/04/07 eastone
	sqlStr = "db_EVT.dbo.[usp_Ten_ItemEvent_UserLogData]" '// 실서버용
    uCon.Open Application("db_EVT") ''커넥션 스트링. '// 실서버용

    cmd.ActiveConnection = uCon
    cmd.CommandText = sqlStr
    cmd.CommandType = adCmdStoredProc

    cmd.Parameters.Append cmd.CreateParameter("returnValue", adInteger, adParamReturnValue)
    cmd.Parameters.Append cmd.CreateParameter("@type", adVarchar, adParamInput, 15, utype)
    cmd.Parameters.Append cmd.CreateParameter("@userid", adVarchar, adParamInput, 32, uuserid)
    cmd.Parameters.Append cmd.CreateParameter("@itemid", adInteger, adParamInput, 0, uitemid)
    cmd.Parameters.Append cmd.CreateParameter("@evtcode", adInteger, adParamInput, 0, uevtcode)
    cmd.Parameters.Append cmd.CreateParameter("@rect", adVarWChar, adParamInput, 200, urect)
    cmd.Parameters.Append cmd.CreateParameter("@platform", adVarchar, adParamInput, 10, uplatform)
    cmd.Execute

    uResult = cmd.Parameters("returnValue").Value
    set cmd = Nothing
    uCon.Close
    SET uCon = Nothing

	If uResult=99 Then
'		response.write "<script>alert('오류');</script>"
	End If

	On Error goto 0

End Sub

''// 최근본상품 로그 장바구니 담기
Sub fnUserLogCheck_AddShoppingBag(iuserKey,iIsLoginUser,iItemid,iItemoption,iChannel)
    dim irefer : irefer = Request.ServerVariables("HTTP_REFERER")

    if (iChannel="") then  ''채널이 지정되어 있지 않으면
        if InStr(irefer,"/wish/web2014/")>0 then
            iChannel = "app"
        else
            iChannel = "mw"
        end if
    end if
    On Error Resume Next
	irefer = TRIM(LEFT(irefer,250))  ''nv쪽 param이 길어졌다. 2019/04/11

    dim uCon : set uCon = CreateObject("ADODB.Connection")
    Dim cmd : set cmd = server.CreateObject("ADODB.Command")


    dim sqlStr
    sqlStr = "db_EVT.dbo.[usp_Ten_ItemEvent_UserLogData_AddBaguni]"
    uCon.Open Application("db_EVT") ''커넥션 스트링.

    cmd.ActiveConnection = uCon
    cmd.CommandText = sqlStr
    cmd.CommandType = adCmdStoredProc

    cmd.Parameters.Append cmd.CreateParameter("@userKey", adVarchar, adParamInput, 32, iuserKey)
    cmd.Parameters.Append cmd.CreateParameter("@isLoginUser", adVarchar, adParamInput, 1, iIsLoginUser)
    cmd.Parameters.Append cmd.CreateParameter("@itemid", adInteger, adParamInput, 0, iItemid)
    cmd.Parameters.Append cmd.CreateParameter("@itemoption", adVarchar, adParamInput, 4, iItemoption)
    cmd.Parameters.Append cmd.CreateParameter("@channel", adVarchar, adParamInput, 10, iChannel)
    cmd.Parameters.Append cmd.CreateParameter("@pval", adVarchar, adParamInput, 250, irefer)

    cmd.Execute

    set cmd = Nothing
    uCon.Close
    SET uCon = Nothing

    On Error goto 0

End Sub


''// 최근본상품 로그 장바구니 담기 비회원=>회원 치환(2017/05/25 by eastone)
Sub fnUserLogCheck_SwapBaguniData(iuserid,iGuestSSNKey)

    If IsNull(iuserid) Or iuserid="" Then Exit Sub
	If IsNull(iGuestSSNKey) Or iGuestSSNKey="" Then Exit Sub

	On Error Resume Next

    dim uCon : set uCon = CreateObject("ADODB.Connection")
    Dim cmd : set cmd = server.CreateObject("ADODB.Command")


    dim sqlStr
    sqlStr = "db_EVT.dbo.[usp_Ten_ItemEvent_UserLogData_SwapBaguniData]"
    uCon.Open Application("db_EVT") ''커넥션 스트링.

    cmd.ActiveConnection = uCon
    cmd.CommandText = sqlStr
    cmd.CommandType = adCmdStoredProc

    cmd.Parameters.Append cmd.CreateParameter("@UserID", adVarchar, adParamInput, 32, iuserid)
    cmd.Parameters.Append cmd.CreateParameter("@GuestSSNKey", adVarchar, adParamInput, 32, iGuestSSNKey)
    cmd.Execute

    set cmd = Nothing
    uCon.Close
    SET uCon = Nothing

    On Error goto 0
End Sub

''// 비회원 orderserial-바구니 키값 (uk)저장 (2017/10/23 by eastone)
Sub fnUserLogCheck_AddGuestOrderserial_UK(iorderserial,iGuestSSNKey)

    If IsNull(iorderserial) Or iorderserial="" Then Exit Sub
	If IsNull(iGuestSSNKey) Or iGuestSSNKey="" Then Exit Sub

	On Error Resume Next

    dim uCon : set uCon = CreateObject("ADODB.Connection")
    Dim cmd : set cmd = server.CreateObject("ADODB.Command")


    dim sqlStr
    sqlStr = "db_EVT.dbo.[usp_Ten_Add_guestOrderserial_uk]"
    uCon.Open Application("db_EVT") ''커넥션 스트링.

    cmd.ActiveConnection = uCon
    cmd.CommandText = sqlStr
    cmd.CommandType = adCmdStoredProc

    cmd.Parameters.Append cmd.CreateParameter("@orderserial", adVarchar, adParamInput, 11, iorderserial)
    cmd.Parameters.Append cmd.CreateParameter("@uk", adVarchar, adParamInput, 64, iGuestSSNKey)
    cmd.Execute

    set cmd = Nothing
    uCon.Close
    SET uCon = Nothing

    On Error goto 0
End Sub

function fn_MakeGuestGuid()
    Dim iTypeLib, iGuid
    Set iTypeLib = CreateObject("Scriptlet.TypeLib")
    iGuid = iTypeLib.Guid
    iGuid = replace(replace(replace(TRIM(iGuid),"}",""),"{",""),"-","")

    SET iTypeLib = Nothing
    fn_MakeGuestGuid = iGuid
end Function

function fn_CheckNMakeGGsnCookie()
    Dim G_ggsn : G_ggsn = fn_getGgsnCookie()
    if (G_ggsn="") then
        G_ggsn = fn_MakeGuestGuid()
        response.Cookies("ggsn").domain = "10x10.co.kr"
        response.cookies("ggsn").Expires = dateAdd("m", 12, Now())	'12(N)개월간 쿠키 저장
        response.Cookies("ggsn") = G_ggsn
    end if
end function

function fn_AddIISAppendToLOG(iAddLogs)
    ''addLog 추가 로그
    if (request.ServerVariables("QUERY_STRING")<>"") then iAddLogs="&"&iAddLogs
    response.AppendToLog iAddLogs
end function

function fn_AddIISAppendToLOG_GGSN()
    ''ggsn 추가 로그
    CALL fn_AddIISAppendToLOG("ggsn="&fn_getGgsnCookie())
end function

function fn_getGgsnCookie()
    fn_getGgsnCookie = request.Cookies("ggsn")
end Function

Function fn_brcheck(v)
	If InStr(v,"<br/>") > 0 Then
		fn_brcheck = Replace(v,"<br/>","")
	ElseIf InStr(v,"<br />") > 0 Then
		fn_brcheck = Replace(v,"<br />","")
	ElseIf InStr(v,"<br>") > 0 Then
		fn_brcheck = Replace(v,"<br>","")
	ElseIf InStr(v,"</br>") > 0 Then
		fn_brcheck = Replace(v,"</br>","")
	ElseIf InStr(v,"</BR>") > 0 Then
		fn_brcheck = Replace(v,"</BR>","")
	Else
		fn_brcheck = v
	End If
End Function

'// 카테고리 코드로 Depth별 카테고리 이름
FUNCTION getCateName(byRef code, depth)
	DIM SQL : SQL = "SELECT ([db_item].[dbo].[getCateCodeFullDepthNameUse]('" & code & "'))"
	DIM rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"CATEH_B",SQL,60*60)
	DIM lenght : lenght = len(code)/3
	DIM str

	IF (rsMem is Nothing) then
		code=0
		Exit Function
	END IF

	IF rsMem(0) <> "" AND NOT(rsMem.EOF or rsMem.BOF) then
		IF Not(isNull(rsMem(0))) Then
		    IF depth = 1 AND lenght >= 1 THEN
		        str = Split(db2html(rsMem(0)),"^^")(0)
		    ELSEIF depth = 2 AND lenght >= 2 THEN
		        str = Split(db2html(rsMem(0)),"^^")(1)
		    ELSEIF depth = 3 AND lenght >= 3  THEN
		        str = Split(db2html(rsMem(0)),"^^")(2)
            END IF
		END IF
	END IF

	rsMem.Close

	IF trim(str)<>"" then
        getCateName = str
    ELSE
        code=0
    END IF
END FUNCTION

''// 상품코드로 1뎁스 카테고리명 가져오기
Function fnItemIdToCategory1DepthName(ItemId)

    If IsNull(ItemId) Or ItemId="" Then Exit Function
	On Error Resume Next
    dim sqlStr
	sqlStr = "execute [db_item].[dbo].[sp_Ten_getOneItemIdToCategoryName] @ItemID ='" & CStr(ItemId) & "'"

	rsget.CursorLocation = adUseClient
	rsget.CursorType=adOpenStatic
	rsget.Locktype=adLockReadOnly
	rsget.Open sqlStr, dbget

	If Not(rsget.bof Or rsget.eof) Then
		fnItemIdToCategory1DepthName = Replace(Replace(rsget("catename")," ",""),Chr(9),"")
	End If
	rsget.close

    On Error goto 0
End Function

''// 상품코드로 브랜드명 가져오기
Function fnItemIdToBrandName(ItemId)

    If IsNull(ItemId) Or ItemId="" Then Exit Function
	On Error Resume Next
    dim sqlStr
	sqlStr = "execute [db_item].[dbo].[sp_Ten_getOneItemIdToBrandName] @ItemID ='" & CStr(ItemId) & "'"

	rsget.CursorLocation = adUseClient
	rsget.CursorType=adOpenStatic
	rsget.Locktype=adLockReadOnly
	rsget.Open sqlStr, dbget

	If Not(rsget.bof Or rsget.eof) Then
		fnItemIdToBrandName = Replace(Replace(rsget("socname")," ",""),Chr(9),"")
	End If
	rsget.close

    On Error goto 0
End Function

''// 1뎁스 카테고리 코드로 카테고리명 가져오기 static
Function fnCateCodeToCategory1DepthName(cCode)

    If IsNull(cCode) Or cCode="" Then Exit Function
	On Error Resume Next

	Select Case Trim(cCode)
		Case "101"
			fnCateCodeToCategory1DepthName = "디자인문구"
		Case "102"
			fnCateCodeToCategory1DepthName = "디지털/핸드폰"
		Case "103"
			fnCateCodeToCategory1DepthName = "캠핑/트래블"
		Case "104"
			fnCateCodeToCategory1DepthName = "토이/취미"
		Case "110"
			fnCateCodeToCategory1DepthName = "Cat&Dog"
		Case "112"
			fnCateCodeToCategory1DepthName = "키친"
		Case "115"
			fnCateCodeToCategory1DepthName = "베이비/키즈"
		Case "116"
			fnCateCodeToCategory1DepthName = "패션잡화"
		Case "117"
			fnCateCodeToCategory1DepthName = "패션의류"
		Case "118"
			fnCateCodeToCategory1DepthName = "뷰티"
		Case "119"
			fnCateCodeToCategory1DepthName = "푸드"
		Case "120"
			fnCateCodeToCategory1DepthName = "패브릭/생활"
		Case "121"
			fnCateCodeToCategory1DepthName = "가구/수납"
		Case "122"
			fnCateCodeToCategory1DepthName = "데코/조명"
		Case "123"
			fnCateCodeToCategory1DepthName = "클리어런스"
		Case "124"
			fnCateCodeToCategory1DepthName = "디자인가전"
		Case "125"
			fnCateCodeToCategory1DepthName = "주얼리/시계"
		Case Else
			fnCateCodeToCategory1DepthName = ""
	End Select

    On Error goto 0
End Function

'// html decode 완성형한글
Function HTMLDecode(sText)
    Dim regEx
    Dim matches
    Dim match
    sText = Replace(sText, "&quot;", Chr(34))
    sText = Replace(sText, "&lt;"  , Chr(60))
    sText = Replace(sText, "&gt;"  , Chr(62))
    sText = Replace(sText, "&amp;" , Chr(38))
    sText = Replace(sText, "&nbsp;", Chr(32))


    Set regEx= New RegExp

    With regEx
    .Pattern = "&#(\d+);" 'Match html unicode escapes
    .Global = True
    End With

    Set matches = regEx.Execute(sText)

    'Iterate over matches
    For Each match in matches
        'For each unicode match, replace the whole match, with the ChrW of the digits.

        sText = Replace(sText, match.Value, ChrW(match.SubMatches(0)))
    Next

    HTMLDecode = sText
End Function

'// 특정공백 제거(스페이스,탭등)
Function stripSpaceChar(checkvalue)
	dim v
	v = checkvalue
	if Isnull(v) then Exit function

    On Error resume Next
    v = replace(v, chr(10), "")
    v = replace(v, chr(13), "")
    v = replace(v, chr(9), "")
    stripSpaceChar = v
End Function

''// 모바일 전용 중요공지 값 가져오기
Function fnGetImportantNotice()

	On Error Resume Next
    dim sqlStr
	sqlStr = " execute [db_cs].[dbo].[sp_Ten_getOneImportantNotice] "

	rsget.CursorLocation = adUseClient
	rsget.CursorType=adOpenStatic
	rsget.Locktype=adLockReadOnly
	rsget.Open sqlStr, dbget

	If Not(rsget.bof Or rsget.eof) Then
		fnGetImportantNotice = rsget("id")&"|||||"&rsget("title")
	End If
	rsget.close

    On Error goto 0
End Function

'// app 쿠키 테스트용
function fnTestLoginLabel()
	if (GetLoginUserID="ysys1418") or (GetLoginUserID="motions") then
		fnTestLoginLabel = "<div style='position:absolute; top:100px; left:0; z-index:50; width:80px; height:80px; padding-top:30px; background-color:rgba(0, 0, 0, 0.7); color:#fff; font-size:12px; text-align:center;'><strong>이게보인다면<br /> 로그인중</strong></div>"
	else
		fnTestLoginLabel = ""
	end if
end function

public Function getCouponInfo(couponIdx)

    If IsNull(couponIdx) Or couponIdx="" Then Exit Function
	On Error Resume Next

    dim sqlStr
	sqlStr = sqlStr & " SELECT TOP 1 "
	sqlStr = sqlStr & " 	IDX "
	sqlStr = sqlStr & " 	, couponvalue "
	sqlStr = sqlStr & " 	, couponname "
	sqlStr = sqlStr & " 	, minbuyprice "
	sqlStr = sqlStr & " 	, startdate "
	sqlStr = sqlStr & " 	, expiredate "
	sqlStr = sqlStr & " FROM DB_USER.DBO.tbl_user_coupon_master with(nolock) "
	sqlStr = sqlStr & "  where idx = '"& couponIdx &"'            "

	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

	if not rsget.EOF then
		getCouponInfo = rsget.getRows()
	end if
	rsget.close

    On Error goto 0
End Function

public function addClassStr(originalClass, classToAdd)
    dim whiteSpace, classStr
    whiteSpace = " "

    if classToAdd = "" then
        exit function
    end if

    if originalClass <> "" then
        classStr = originalClass & whiteSpace & classToAdd
    else
        classStr = classToAdd
    end if

    addClassStr = classStr
end function

Public Function getParam(params)
	Dim query : query = Request.ServerVariables("QUERY_STRING")
	Dim Dic : Set Dic = Server.CreateObject("Scripting.Dictionary")
	Dim Reg : Set Reg = New RegExp
	Reg.Global = True
	Reg.Pattern = "^\?"
	query = Reg.Replace(query,"")
	Reg.Pattern = "^(.*)=(.*)$"

	' 기존 파라메터 담기
	If query <> "" Then
	  Dim obj_key,obj_name,obj_value

	  For Each obj_key In Split(query,"&")

	    If Reg.Test(obj_key) = True Then
	      obj_name = Reg.Replace(obj_key,"$1")
	      obj_value = Reg.Replace(obj_key,"$2")
	      Dic.Add obj_name,obj_value
	    End If
	  Next
	End If

	' 임의의 파라메터 담기
	If params <> "" Then
	  Dim new_key,new_name,new_value
	  For Each new_key In Split(params,"&")
	    If Reg.Test(new_key) = True Then
	      new_name = Reg.Replace(new_key,"$1")
	      new_value = Reg.Replace(new_key,"$2")

	      If Dic.Exists(new_name) = True Then '있을때
	        If new_value = "" Then
	          Dic.Remove(new_name)
	        Else
	          Dic.item(new_name) = new_value
	        End If
	      Else
	        Dic.Add new_name,new_value
	      End If

	    End If
	  Next
	End If

	Dim params_ext : params_ext = ""
	Dim acc_key,acc_name,acc_value
	For Each acc_key in Dic.Keys
	  acc_name = acc_key
	  acc_value = Dic.item(acc_name)

		If acc_value <> "" Then
			if acc_name <> "_" then
				params_ext = params_ext & acc_name & "=" & acc_value & "&"
			End if
		End If
	Next

	If params_ext <> "" Then
	  Reg.Pattern = "&$"
	  getParam = Reg.Replace(params_ext,"")
	Else
	  getParam = ""
	End If
End Function
public Function getEventDate(evtcode)

    If IsNull(evtcode) Or evtcode="" Then Exit Function
	On Error Resume Next
    dim sqlStr
	sqlStr = "SELECT top 1 "
	sqlStr = sqlStr & "     convert(char(10), evt_startdate, 23) as evt_startdate "
	sqlStr = sqlStr & "     , convert(char(10), evt_enddate, 23) as evt_enddate "
	sqlStr = sqlStr & "   from db_event.dbo.tbl_event as a "
	sqlStr = sqlStr & "  where evt_code = '"& CStr(evtCode) &"'            "

	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

	if not rsget.EOF then
		getEventDate = rsget.getRows()
	end if
	rsget.close

    On Error goto 0
End Function

public function getEvtSalePer(evtCode)

	If IsNull(evtCode) Or evtCode="" Then Exit Function
	On Error Resume Next
	dim sqlStr, salePer
	dim objConn, objCmd, rs

	set objConn = CreateObject("ADODB.Connection")
	objConn.Open Application("db_main")
	Set objCmd = Server.CreateObject ("ADODB.Command")

	sqlStr = sqlStr & "  SELECT top 1 case B.salePer when '' then 0 else isnull(B.salePer, 0) end as salePer "
	sqlStr = sqlStr & "    FROM DB_EVENT.DBO.tbl_event AS A WITH(NOLOCK) "
	sqlStr = sqlStr & "  INNER JOIN db_event.DBO.tbl_event_display B WITH(NOLOCK) ON A.evt_code = B.evt_code "
	sqlStr = sqlStr & "   WHERE A.evt_code = ? "


	objCmd.ActiveConnection = objConn
	objCmd.CommandType = adCmdText
	objCmd.CommandText = sqlStr

	objCmd.Parameters.Append(objCmd.CreateParameter("A.evt_code", adVarChar, adParamInput, Len(evtCode), evtCode))

	set rs = objCmd.Execute

	if  not rs.EOF  then
		salePer = rs("salePer")
	End if

	objConn.Close
	SET objConn = Nothing

	getEvtSalePer = salePer
	On Error goto 0
end function

public function getEvtTotalSalePer(evtCode)

	If IsNull(evtCode) Or evtCode="" Then Exit Function
	On Error Resume Next
	dim sqlStr, salePer
	dim objConn, objCmd, rs

	set objConn = CreateObject("ADODB.Connection")
	objConn.Open Application("db_main")
	Set objCmd = Server.CreateObject ("ADODB.Command")

	sqlStr = sqlStr & "  SELECT top 1 case B.salePer when '' then 0 else CONVERT(INT,isnull(B.salePer, 0)) end + case when B.saleCPer = '' or B.iscoupon = '0' then 0 else CONVERT(INT,isnull(B.saleCPer, 0)) end as salePer "
	sqlStr = sqlStr & "    FROM DB_EVENT.DBO.tbl_event AS A WITH(NOLOCK) "
	sqlStr = sqlStr & "  INNER JOIN db_event.DBO.tbl_event_display B WITH(NOLOCK) ON A.evt_code = B.evt_code "
	sqlStr = sqlStr & "   WHERE A.evt_code = ? "


	objCmd.ActiveConnection = objConn
	objCmd.CommandType = adCmdText
	objCmd.CommandText = sqlStr

	objCmd.Parameters.Append(objCmd.CreateParameter("A.evt_code", adVarChar, adParamInput, Len(evtCode), evtCode))

	set rs = objCmd.Execute

	if  not rs.EOF  then
		salePer = rs("salePer")
	End if

	objConn.Close
	SET objConn = Nothing

	getEvtTotalSalePer = salePer
	On Error goto 0
end function

public function getAppVersion()
	dim appVersion, VuserAgent
	VuserAgent = Request.ServerVariables("HTTP_USER_AGENT")
	'VuserAgent = "Mozilla/5.0 (Linux; Android 8.0.0; SM-G935K Build/R16NW; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/73.0.3683.90 Mobile Safari/537.36tenapp A2.482"
	if Instr(VuserAgent,"tenapp") > 0 then
		appVersion = mid(VuserAgent, Instr(VuserAgent,"tenapp")+8, 5)
	end if

	getAppVersion = appVersion
end function

function Newhtml2db(checkvalue)
	dim v
	v = checkvalue
	if Isnull(v) then Exit function
	v = Replace(v, "'", "''")
	Newhtml2db = v
end function

'//상품후기 총점수 %로 환산
Public function fnEvaluteTotalPointAVG(t,g)
	dim vTmp
	vTmp = 0
	If t <> "" Then
		If isNumeric(t) Then
			If t > 0 Then
				If g = "search" Then
					vTmp = (t/5)
				Else
					vTmp = ((Round(t,2) * 100)/5)
				End If
				vTmp = Round(vTmp)
			End If
		End If
	End If
	fnEvaluteTotalPointAVG = vTmp
end function

'// 배송비 부담 관련 로그 남김(2020.09.03 원승현 생성)
Sub fnHalfDeliveryLog(orderserial, userid, itemid, orderdate, orderprice, deliverypay)

	If IsNull(userid) Or userid="" Then Exit Sub
	If IsNull(orderserial) Or orderserial="" Then Exit Sub
	If IsNull(itemid) Or itemid="" Then Exit Sub

	On Error Resume Next

	If orderprice="" Then orderprice=0
	If deliverypay="" Then deliverypay=0

    dim uCon : set uCon = CreateObject("ADODB.Connection")
    Dim cmd : set cmd = server.CreateObject("ADODB.Command")

    dim uResult

    dim sqlStr

    sqlStr = "db_log.dbo.usp_Ten_HalfDeliveryPayLog" '// 실서버용
    uCon.Open Application("db_main") ''커넥션 스트링. '// 실서버용

    cmd.ActiveConnection = uCon
    cmd.CommandText = sqlStr
    cmd.CommandType = adCmdStoredProc

    'cmd.Parameters.Append cmd.CreateParameter("returnValue", adInteger, adParamReturnValue)
    cmd.Parameters.Append cmd.CreateParameter("@orderserial", adVarchar, adParamInput, 11, orderserial)
    cmd.Parameters.Append cmd.CreateParameter("@userid", adVarchar, adParamInput, 32, userid)
    cmd.Parameters.Append cmd.CreateParameter("@itemid", adInteger, adParamInput, 0, itemid)
    cmd.Parameters.Append cmd.CreateParameter("@orderdate", adDate, adParamInput, 0, orderdate)
    cmd.Parameters.Append cmd.CreateParameter("@itemprice", adInteger, adParamInput, 0, orderprice)
    cmd.Parameters.Append cmd.CreateParameter("@orderdeliverprice", adInteger, adParamInput, 0, deliverypay)
    cmd.Execute

    'uResult = cmd.Parameters("returnValue").Value
    set cmd = Nothing
    uCon.Close
    SET uCon = Nothing

	'If uResult=99 Then
'		response.write "<script>alert('오류');</script>"
	'End If

	On Error goto 0

End Sub

'// useq값 가져오기
public Function getUserSeqValue(uid)

    If IsNull(uid) Or uid="" Then Exit Function
	On Error Resume Next
    dim sqlStr
	sqlStr = "SELECT top 1 "
	sqlStr = sqlStr & "     useq*3 "
	sqlStr = sqlStr & "   from [db_user].[dbo].tbl_logindata WITH(NOLOCK) "
	sqlStr = sqlStr & "  Where userid='"&uid&"' "

	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

	if not rsget.EOF then
		getUserSeqValue = rsget(0)
	Else
		getUserSeqValue = ""
	end if
	rsget.close

    On Error goto 0
End Function

'// 2020리뉴얼 페이지인지
Public Function fnIsRenewalPage2020()
	Dim renewal_path, renewal_paths, current_url, is_renewal_path
    current_url = Request.ServerVariables("url")
	renewal_paths = Array( _
        "/search/search_", _
        "/category/category_", _
        "/brand/brand_", _
        "/list/", _
		"/hitchhiker/", _
		"/biz/brand" _
	)

	is_renewal_path = false
	For Each renewal_path In renewal_paths
        If InStr(current_url, renewal_path) > 0 Then
            is_renewal_path = true
            Exit For
        End If
	Next
	fnIsRenewalPage2020 = is_renewal_path And InStr(current_url, "2020.asp") > 0
End Function

'// Biz 페이지인지
Public Function fnIsBizPage(isBizMode)
	Dim bizModeCheckPages, isBizModeCheckPage, page, currentUrl
    currentUrl = LCase(Request.ServerVariables("url"))
	bizModeCheckPages = Array(_
		"/search/search_product2020.asp", _
		"/category/category_main2020.asp" _
	)

	isBizModeCheckPage = False
	For Each page In bizModeCheckPages
		If currentUrl = page Then
			isBizModeCheckPage = True
			Exit For
		End If
	Next

	fnIsBizPage = (isBizModeCheckPage And isBizMode) Or InStr(currentUrl, "/biz/") > 0
End Function

'// m -> pc
Public Function fnRedirectToPc()
	Dim this_refer, refer_start_index, is_not_ten_refer
	this_refer = Request.ServerVariables("HTTP_REFERER")
	If this_refer <> "" and LEN(this_refer) > 11 Then
		refer_start_index = InStr(this_refer, ".")
		is_not_ten_refer = (LEFT(RIGHT(this_refer, LEN(this_refer) - refer_start_index),11) <> "10x10.co.kr")
	Else
		is_not_ten_refer = True
	End If
	
	If flgDevice = "W" and is_not_ten_refer Then
        fnRedirectToPc = webURL
	End If
End Function

'/*
' * 브랜드 이미지 통합 Function
' * http://confluence.tenbyten.kr:8090/pages/viewpage.action?pageId=118587491
' * 1순위 : [Admin] 파트너 관리 > 브랜드 이미지
' * 2순위 : [Partner Admin] 브랜드 스트릿 > 브랜드 페이지 정보 > 상단 BG 이미지
' * 3순위 : 브랜드 대표상품의 텐바이텐 이미지
' * 4순위 : 브랜드 대표상품의 1번 이미지
' */
Public Function fnGetBrandImage(modelItemId, imageUrl)
	'// 비어있따면 빈값 그냥 리턴
	If IsNull(imageUrl) Or imageUrl = "" Or Len(imageUrl) < 2 Then
		fnGetBrandImage  = imageUrl
		Exit Function
	End If

	Dim imageType, fullImageUrl
	imageType = Left(imageUrl, 2)
	imageUrl = Right(imageUrl, Len(imageUrl) - 2)

	If imageType = "BI" Then '// 1순위
		fullImageUrl = "http://oimgstatic.10x10.co.kr/brandstreet/main/" & imageUrl
	ElseIf imageType = "SI" Then '// 2순위
		fullImageUrl = "http://thumbnail.10x10.co.kr/imgstatic/brandstreet/hello/" & imageUrl & "?cmd=thumbnail&w=300"
	ElseIf imageType = "IT" Then '// 3순위
		fullImageUrl = getThumbImgFromURL("http://webimage.10x10.co.kr/image/tenten/" & GetImageSubFolderByItemid(modelItemId) & "/" & imageUrl,300,300,"true","false")
	ElseIf imageType = "IB" Then '// 4순위
		fullImageUrl = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(modelItemId) & "/" & imageUrl,300,300,"true","false")
	Else
		fullImageUrl = imageUrl
	End If

	fnGetBrandImage = fullImageUrl
End Function
%>
