<!-- #include file="./lgdacom/md5.asp" -->

<%
     '/*
     '* [상점 결제결과처리(DB) 페이지]
     '*
     '* 1) 위변조 방지를 위한 hashdata값 검증은 반드시 적용하셔야 합니다.
     '*
     '*/

     '/*
     '* 공통결제결과 정보 
     '*/
    Dim LGD_RESPCODE            ' 응답코드: 0000(성공) 그외 실패
    Dim LGD_RESPMSG             ' 응답메세지
    Dim LGD_MID                 ' 상점아이디 
    Dim LGD_OID                 ' 주문번호
    Dim LGD_AMOUNT              ' 거래금액
    Dim LGD_TID                 ' LG유플러스에서 부여한 거래번호
    Dim LGD_PAYTYPE             ' 결제수단코드
    Dim LGD_PAYDATE             ' 거래일시(승인일시/이체일시)
    Dim LGD_HASHDATA            ' 해쉬값
    Dim LGD_FINANCECODE         ' 결제기관코드(카드종류/은행코드/이통사코드)
    Dim LGD_FINANCENAME         ' 결제기관이름(카드이름/은행이름/이통사이름)
    Dim LGD_ESCROWYN            ' 에스크로 적용여부
    Dim LGD_TIMESTAMP           ' 타임스탬프
    Dim LGD_FINANCEAUTHNUM      ' 결제기관 승인번호(신용카드, 계좌이체, 상품권)

     '/*
     '* 신용카드 결제결과 정보
     '*/
    Dim LGD_CARDNUM             ' 카드번호(신용카드)
    Dim LGD_CARDINSTALLMONTH    ' 할부개월수(신용카드) 
    Dim LGD_CARDNOINTYN         ' 무이자할부여부(신용카드) - '1'이면 무이자할부 '0'이면 일반할부
    Dim LGD_TRANSAMOUNT         ' 환율적용금액(신용카드)
    Dim LGD_EXCHANGERATE        ' 환율(신용카드)

     '/*
     '* 휴대폰
     '*/
    Dim LGD_PAYTELNUM           ' 결제에 이용된전화번호

     '/*
     '* 계좌이체, 무통장
     '*/
    Dim LGD_ACCOUNTNUM          ' 계좌번호(계좌이체, 무통장입금) 
    Dim LGD_CASTAMOUNT          ' 입금총액(무통장입금)
    Dim LGD_CASCAMOUNT          ' 현입금액(무통장입금)
    Dim LGD_CASFLAG             ' 무통장입금 플래그(무통장입금) - 'R':계좌할당, 'I':입금, 'C':입금취소 
    Dim LGD_CASSEQNO            ' 입금순서(무통장입금)
    Dim LGD_CASHRECEIPTNUM      ' 현금영수증 승인번호
    Dim LGD_CASHRECEIPTSELFYN   ' 현금영수증자진발급제유무 Y: 자진발급제 적용, 그외 : 미적용
    Dim LGD_CASHRECEIPTKIND     ' 현금영수증 종류 0: 소득공제용 , 1: 지출증빙용

     '/*
     '* OK캐쉬백
     '*/
    Dim LGD_OCBSAVEPOINT        ' OK캐쉬백 적립포인트
    Dim LGD_OCBTOTALPOINT       ' OK캐쉬백 누적포인트
    Dim LGD_OCBUSABLEPOINT      ' OK캐쉬백 사용가능 포인트

     '/*
     '* 구매정보
     '*/
	Dim LGD_BUYER               ' 구매자
	Dim LGD_PRODUCTINFO         ' 상품명
	Dim LGD_BUYERID             ' 구매자 ID
	Dim LGD_BUYERADDRESS        ' 구매자 주소
    Dim LGD_BUYERPHONE          ' 구매자 전화번호
	Dim LGD_BUYEREMAIL          ' 구매자 이메일
	Dim LGD_BUYERSSN            ' 구매자 주민번호
    Dim LGD_PRODUCTCODE         ' 상품코드
    Dim LGD_RECEIVER            ' 수취인
	Dim LGD_RECEIVERPHONE       ' 수취인 전화번호
	Dim LGD_DELIVERYINFO        ' 배송지

	Dim LGD_MERTKEY				' LG유플러스 제공 mertkey
	Dim resultMSG				' 결과처리 메시지

    LGD_RESPCODE            = trim(request("LGD_RESPCODE"))
    LGD_RESPMSG             = trim(request("LGD_RESPMSG"))
    LGD_MID                 = trim(request("LGD_MID"))
    LGD_OID                 = trim(request("LGD_OID"))
    LGD_AMOUNT              = trim(request("LGD_AMOUNT"))
    LGD_TID                 = trim(request("LGD_TID"))
    LGD_PAYTYPE             = trim(request("LGD_PAYTYPE"))
    LGD_PAYDATE             = trim(request("LGD_PAYDATE"))
    LGD_HASHDATA            = trim(request("LGD_HASHDATA"))
    LGD_FINANCECODE         = trim(request("LGD_FINANCECODE"))
    LGD_FINANCENAME         = trim(request("LGD_FINANCENAME"))
    LGD_ESCROWYN            = trim(request("LGD_ESCROWYN"))
    LGD_TRANSAMOUNT         = trim(request("LGD_TRANSAMOUNT"))
    LGD_EXCHANGERATE        = trim(request("LGD_EXCHANGERATE"))
    LGD_CARDNUM             = trim(request("LGD_CARDNUM"))
    LGD_CARDINSTALLMONTH    = trim(request("LGD_CARDINSTALLMONTH"))
    LGD_CARDNOINTYN         = trim(request("LGD_CARDNOINTYN"))
    LGD_TIMESTAMP           = trim(request("LGD_TIMESTAMP"))
    LGD_FINANCEAUTHNUM      = trim(request("LGD_FINANCEAUTHNUM"))
    LGD_PAYTELNUM           = trim(request("LGD_PAYTELNUM"))
    LGD_ACCOUNTNUM          = trim(request("LGD_ACCOUNTNUM"))
    LGD_CASTAMOUNT          = trim(request("LGD_CASTAMOUNT"))
    LGD_CASCAMOUNT          = trim(request("LGD_CASCAMOUNT"))
    LGD_CASFLAG             = trim(request("LGD_CASFLAG"))
    LGD_CASSEQNO            = trim(request("LGD_CASSEQNO"))
    LGD_CASHRECEIPTNUM      = trim(request("LGD_CASHRECEIPTNUM"))
    LGD_CASHRECEIPTSELFYN   = trim(request("LGD_CASHRECEIPTSELFYN"))
    LGD_CASHRECEIPTKIND     = trim(request("LGD_CASHRECEIPTKIND"))
    LGD_OCBSAVEPOINT        = trim(request("LGD_OCBSAVEPOINT"))
    LGD_OCBTOTALPOINT       = trim(request("LGD_OCBTOTALPOINT"))
    LGD_OCBUSABLEPOINT      = trim(request("LGD_OCBUSABLEPOINT"))

	LGD_BUYER               = trim(request("LGD_BUYER"))
	LGD_PRODUCTINFO         = trim(request("LGD_PRODUCTINFO"))
	LGD_BUYERID             = trim(request("LGD_BUYERID"))
	LGD_BUYERADDRESS        = trim(request("LGD_BUYERADDRESS"))
    LGD_BUYERPHONE          = trim(request("LGD_BUYERPHONE"))
	LGD_BUYEREMAIL          = trim(request("LGD_BUYEREMAIL"))
	LGD_BUYERSSN            = trim(request("LGD_BUYERSSN"))
    LGD_PRODUCTCODE         = trim(request("LGD_PRODUCTCODE"))
    LGD_RECEIVER            = trim(request("LGD_RECEIVER"))
	LGD_RECEIVERPHONE       = trim(request("LGD_RECEIVERPHONE"))
	LGD_DELIVERYINFO        = trim(request("LGD_DELIVERYINFO"))

     '/*
     '* hashdata 검증을 위한 mertkey는 상점관리자 -> 계약정보 -> 상점정보관리에서 확인하실수 있습니다. 
     '* LG유플러스에서 발급한 상점키로 반드시 변경해 주시기 바랍니다.
     '*/  

    LGD_MERTKEY = "95160cce09854ef44d2edb2bfb05f9f3" '[반드시 세팅] mertkey 

	LGD_HASHDATA2 = md5(LGD_MID & LGD_OID & LGD_AMOUNT & LGD_RESPCODE & LGD_TIMESTAMP & LGD_MERTKEY)

	
     '/*
     '* 상점 처리결과 리턴메세지
     '*
     '* OK   : 상점 처리결과 성공
     '* 그외 : 상점 처리결과 실패
     '*
     '* ※ 주의사항 : 성공시 'OK' 문자이외의 다른문자열이 포함되면 실패처리 되오니 주의하시기 바랍니다.
     '*/    
    resultMSG = "결제결과 상점 DB처리(NOTE_URL) 결과값을 입력해 주시기 바랍니다." '상점결과 리턴메세지

	
	if (LGD_HASHDATA2 = LGD_HASHDATA) then
	    if (LGD_RESPCODE = "0000") then
             '/*
             '* 거래성공 결과 상점 처리(DB) 부분
             '* 상점 결과 처리가 정상이면 "OK"
             '*/    
             'if( 결제성공 상점처리결과 성공 ) 
             	resultMSG = "OK"   
	    else 
             '/*
             '* 거래실패 결과 상점 처리(DB) 부분
             '* 상점결과 처리가 정상이면 "OK"
             '*/  
             'if( 결제실패 상점처리결과 성공 ) 
             	resultMSG = "OK"    
	    end if
	else
         '/*
         '* hashdata검증 실패 로그를 처리하시기 바랍니다. 
         '*/      
    	 'resultMSG = "결제결과 상점 DB처리(NOTE_URL) 해쉬값 검증이 실패하였습니다."    
	end if

    Response.Write(resultMSG)
%>
 
