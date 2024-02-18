<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet="UTF-8"
%>
<% Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<!-- #include virtual="/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib2.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCashCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/inipay/kakao/incKakaopayCommon.asp"-->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/inipay/common/orderTempFunction.asp" -->
<%
'response.write "<script>alert('죄송합니다. 카카오페이 결제 잠시 점검중입니다.');history.back();</script>"
'response.end


Dim vQuery, vQuery1
Dim sqlStr

'// 앱일경우엔 앱경로 넣어준다.
Dim vAppLink : vAppLink =""
If isApp="1" Then
	wwwUrl = wwwUrl&"/apps/appCom/wish/web2014/"
	vAppLink = "/apps/appCom/wish/web2014"
End If


Dim vIDx, iErrMsg, ipgGubun
Dim irefPgParam   '' 결제 예약시 필요한 값들.
ipgGubun = "KA"
vIdx 	= ""

vIDx = fnSaveOrderTemp("KCTEN0001", iErrMsg, ipgGubun, irefPgParam)  '' order_temp 임시저장

if (vIDx<1) then
    response.write "ERR2:처리중 오류가 발생하였습니다.- "&iErrMsg&""
    response.write "<script>alert('처리중 오류가 발생했습니다.\n(" & replace(iErrMsg,"'","") & ")')</script>"
	response.write "<script>location.replace('" & wwwUrl & "/inipay/shoppingbag.asp');</script>"
    dbget.close()
    response.end
end if

if (irefPgParam is Nothing) then
    response.write "ERR2:처리중 오류가 발생하였습니다"
    response.write "<script>alert('처리중 오류가 발생했습니다.\n(ERR2)')</script>"
	response.write "<script>location.replace('" & wwwUrl & "/inipay/shoppingbag.asp');</script>"
    dbget.close()
    response.end
end if


''======================================================================================================================

Dim vPGoods : vPGoods = Request("P_GOODS")  ''카카오로 전송시에만 쓰임

''카카오페이
Dim objKMPay
dim ichannelType, iReturnURL
Dim PR_TYPE : PR_TYPE ="MPM" '' WPM / MPM
Dim channelType : channelType = "2"  ''2:모바일웹, 4:TMS  // 2 or 4 상관없는듯.

if (isApp="1") and (UCASE(flgDevice)="I")  then '' ios 앱인 경우만.  아래형태로 해야 결제후 자동으로 돌아옴. //  이 조건을 (FALSE) 로 해도 됨. 고객이 수동으로 전환
    ichannelType = "kakaopayDlp.setChannelType('MPM', 'APP');"& VBCRLF
    iReturnURL = "kakaopayDlp.setReturnUrl('tenwishapp://');" & VBCRLF
    iReturnURL = iReturnURL&"kakaopayDlp.setCancelUrl('tenwishapp://');"
    PR_TYPE    = "WPM"
else
    ichannelType = ""
    iReturnURL = ""
    
    ''PR_TYPE="WPM"
    ''channelType = "4"
end if

Dim KCURRENCY : KCURRENCY = "KRW"
Dim CERTIFIED_FLAG : CERTIFIED_FLAG = "CN" '' CN / N
Dim NO_INT_YN : NO_INT_YN = "N" ''무이자
Dim NO_INT_OPT: NO_INT_OPT = "" ''무이자 옵션
Dim MAX_INT : MAX_INT=""        '최대할부개월    
Dim FIXED_INT : FIXED_INT=""    '고정할부개월

Dim pointUseYN : pointUseYN="N"
Dim POSSI_CARD : POSSI_CARD=""
Dim blockCard  : blockCard =""

Dim ref_resultCode,ref_resultMsg,ref_txnId,ref_merchantTxnNum,ref_prDt

IF vIdx <> "" Then
    
''카카오페이 인증 getTxId.asp

'        CERTIFIED_FLAG = iCERTIFIED_FLAG							'가맹점 인증 구분값 ("N","NC")
'        PR_TYPE = iprType										    '결제 요청 타입
'        MERCHANT_ID = iMID										    '가맹점 ID
'        MERCHANT_TXN_NUM = imerchantTxnNumIn						'가맹점 거래번호
'        PRODUCT_NAME = iGoodsName								    '상품명
'        AMOUNT = iAmt											'상품금액(총거래금액) (총거래금액 = 공급가액 + 부가세 + 봉사료)
'        KCURRENCY = icurrency									'거래통화(KRW/USD/JPY 등)
'        RETURN_URL = ireturnUrl									'결제승인결과전송URL
'        POSSI_CARD = ipossiCard									'결제가능카드설정
'        channelType = ichannelType
'        
'        '무이자옵션
'        NO_INT_YN = inoIntYN									'무이자 설정
'        NO_INT_OPT = inoIntOpt									'무이자 옵션
'        MAX_INT =imaxInt										'최대할부개월
'        FIXED_INT = ifixedInt									'고정할부개월
'        pointUseYN = ipointUseYn								'카드사포인트사용여부
'        blockCard = iblockCard									'금지카드설정
'                  
'        SUPPLY_AMT = "0"										'공급가액
'        SUPPLY_AMT = "0"										'공급가액
'        GOODS_VAT = "0"											'부가세
'        SERVICE_AMT = "0"										'봉사료
'        CANCEL_TIME = "1440"									'결제취소시간(분)
'        
'        CARD_MERCHANT_NUM = ""									'카드사가맹점번호
'        RETURN_TYPE = ""										'결과리턴방식
    
    ' ENC KEY와 HASH KEY는 가맹점에서 DB 또는 별도 파일로 관리한 정보를 사용한다.
    
    '1) 객체 생성
    Set objKMPay = Server.CreateObject("LGCNS.KMPayService.MPayCallWebService")
    
    '2) 객체 멤버 세팅
    objKMPay.MerchantEncKey = KMPAY_MERCHANT_ENCKEY								'암호화 키
    objKMPay.MerchantHashKey = KMPAY_MERCHANT_HASHKEY							'해쉬 키
    objKMPay.RequestDealApproveUrl = KMPAY_CERT_SERVER_URL & KMPAY_CERT_SERVER_PAGE					'인증 요청 경로
    
    '3) 로그 정보
    objKMPay.SetMPayLogging KMPAY_LOG_DIR, KMPAY_LOG_LEVEL	        '-1:로그 사용 안함, 0:Error, 1:Info, 2:Debug
    
    '4) 인증요청 정보
    objKMPay.SetRequestData "PR_TYPE", PR_TYPE                    '결제 요청 타입
    objKMPay.SetRequestData "MERCHANT_ID", KMPAY_MERCHANT_ID      '가맹점 ID
    objKMPay.SetRequestData "MERCHANT_TXN_NUM", vIdx                '가맹점 거래번호
    objKMPay.SetRequestData "PRODUCT_NAME", vPGoods                 '상품명
    objKMPay.SetRequestData "AMOUNT", irefPgParam.FPrice            '상품금액(총거래금액) (총거래금액 = 공급가액 + 부가세 + 봉사료)
    objKMPay.SetRequestData "channelType", channelType
    
    objKMPay.SetRequestData "CURRENCY", KCURRENCY                 '거래통화(KRW/USD/JPY 등)
    objKMPay.SetRequestData "CERTIFIED_FLAG", CERTIFIED_FLAG      '가맹점 인증 구분값 ("N","NC")
    
    objKMPay.SetRequestData "NO_INT_YN", NO_INT_YN                '무이자 설정
    objKMPay.SetRequestData "NO_INT_OPT", NO_INT_OPT              '무이자 옵션
    objKMPay.SetRequestData "MAX_INT", MAX_INT                    '최대할부개월
    objKMPay.SetRequestData "FIXED_INT", FIXED_INT                '고정할부개월
    
    objKMPay.SetRequestData "POINT_USE_YN", pointUseYN            '카드사포인트사용여부
    objKMPay.SetRequestData "POSSI_CARD", POSSI_CARD              '결제가능카드설정
    objKMPay.SetRequestData "BLOCK_CARD", blockCard               '금지카드설정
    'objKMPay.SetRequestData "PAYMENT_HASH", ""                   'dll 내부에서 처리
    
    '5) 인증 요청
    objKMPay.DealConfirmMerchant
    
    '6) 인증 결과값
    ref_resultCode = objKMPay.GetResultCode
    ref_resultMsg = objKMPay.GetResultMsg
    ref_txnId = objKMPay.GetTxnId
    ref_merchantTxnNum = objKMPay.GetMerchantTxnNum
    ref_prDt = objKMPay.GetPrDt
    
    SET objKMPay = Nothing
    
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" href="<%=CNSPAY_DEAL_REQUEST_URL %>/dlp/css/pc/cnspay.css" type="text/css" />
        
<script src="<%=CNSPAY_DEAL_REQUEST_URL %>/dlp/scripts/lib/easyXDM.min.js" type="text/javascript"></script>
<script src="<%=CNSPAY_DEAL_REQUEST_URL %>/dlp/scripts/lib/json2.js" type="text/javascript"></script>
<!-- 카카오페이--------------------------------------------------------------------------------------------- -->
<link rel="stylesheet" type="text/css" href="kakaopayDlp.css" />

<!-- JQuery에 대한 부분은 site마다 버전이 다를수 있음 -->
<script type="text/javascript" src="<%=KMPAY_WEB_SERVER_URL %>/js/dlp/lib/jquery/jquery-1.11.1.min.js" charset="urf-8"></script>

<!-- DLP창에 대한 KaKaoPay Library -->
<script type="text/javascript" src="<%=KMPAY_WEB_SERVER_URL %>/js/dlp/client/kakaopayDlpConf.js" charset="utf-8"></script>
<script type="text/javascript" src="<%=KMPAY_WEB_SERVER_URL %>/js/dlp/client/kakaopayDlp.min.js" charset="utf-8"></script>
</head>
<body align="center">
	<form name="payForm" id="payForm" action="ordertemp_kakaoResult.asp" accept-charset="utf-8" method="post">
	<!-- kakaoPay -->
	
	<input type="hidden" name="PayMethod" value="KAKAOPAY">
	<input type="hidden" name="TransType" value="0"> <!--0일반,1에스크로-->
	<input type="hidden" name="GoodsName" value='<%= replace(vPGoods,"'","") %>'>
	<input type="hidden" name="Amt" value="<%= irefPgParam.FPrice %>">
	<input type="hidden" name="GoodsCnt" value="1">
	<input type="hidden" name="MID" value="<%=KMPAY_MERCHANT_ID %>">
	
	<!-- MPay에서 TXN_ID를 가져오기 위해 사용하는 변수 목록 -->
	<input type="hidden" id="CERTIFIED_FLAG" name="CERTIFIED_FLAG" value="<%=CERTIFIED_FLAG%>"><!-- CN : 웹결제, N : 인앱결제 -->
    <input type="hidden" name="AuthFlg" value="10"><!-- 고정 -->
	<input type="hidden" name="currency" value="<%=KCURRENCY%>">
	<input type="hidden" name="merchantEncKey" value="<%=KMPAY_MERCHANT_ENCKEY%>">
	<input type="hidden" name="merchantHashKey" value="<%=KMPAY_MERCHANT_HASHKEY%>">
	<input type="hidden" name="prType" value="<%=PR_TYPE%>"> <!-- 중요 WPM / MPM -->
	<input type="hidden" name="channelType" value="<%=channelType%>"> <!-- 2:모바일웹, 4:TMS -->
	<input type="hidden" id="merchantTxnNumIn" name="merchantTxnNumIn" value="<%=vIdx%>"> <!-- 가맹점 거래번호 -->
	<input type="hidden" id="possiCard" name="possiCard" value="<%=POSSI_CARD%>"> <!-- 카드선택 -->
	<input type="hidden" id="fixedInt" name="fixedInt" value="<%=FIXED_INT%>"> <!-- 할부개월 -->
	<input type="hidden" id="maxInt" name="maxInt" value="<%=MAX_INT%>"> <!-- 최대 할부개월 -->
	<input type="hidden" id="noIntYN" name="noIntYN" value="<%=NO_INT_YN%>"> <!-- 무이자 -->
	<input type="hidden" id="noIntOpt" name="noIntOpt" value="<%=NO_INT_OPT%>"> <!-- 무이자 옵션 -->
	<input type="hidden" id="pointUseYn" name="pointUseYn" value="<%=pointUseYN%>"> <!-- 카드사 포인트 -->
	<input type="hidden" id="blockCard" name="blockCard" value="<%=blockCard%>"> <!-- 금지카드 -->
	
	<input type="hidden" name="BuyerEmail" value="<%=irefPgParam.FBuyemail%>">
	<input type="hidden" name="BuyerName" value="<%=irefPgParam.FBuyname%>">
	<input type="hidden" name="returnUrl" value=""> <!-- 쓸모없는 값이지만 TXN_ID를 얻어올때 필요 ? -->
	
	<!-- MPay에서 TXN_ID 를 가져 올 때 함께 받아오는 변수 목록 -->
	<input type="hidden" name="resultCode" value="<%=ref_resultCode%>">
	<input type="hidden" name="resultMsg" value="<%=ref_resultMsg%>">
	<input type="hidden" name="txnId" value="<%=ref_txnId%>">
	<input type="hidden" id="merchantTxnNum"  name="merchantTxnNum" value="<%=ref_merchantTxnNum%>">
	<input type="hidden" id="prDt"  name="prDt" value="<%=ref_prDt%>">
	
	<!-- TODO : DLP창으로부터 받은 결과값을 SETTING 할 INPUT LIST -->
	<input type="hidden" name="SPU" value="">
	<input type="hidden" name="SPU_SIGN_TOKEN" value="">
	<input type="hidden" name="MPAY_PUB" value="">
	<input type="hidden" name="NON_REP_TOKEN" value="">
	
	
	<div id="kakaopay_layer" style="display: none"></div>
<%
    END IF	
%>
    </form>    

    <script language="javascript">
    function cnspay() {
        //if (document.getElementById("kakaopay").checked) {
            // TO-DO : 가맹점에서 해줘야할 부분(TXN_ID)과 KaKaoPay DLP 호출 API
            // 결과코드가 00(정상처리되었습니다.)
            if (document.payForm.resultCode.value == '00') {
                // TO-DO : 가맹점에서 해줘야할 부분(TXN_ID)과 KaKaoPay DLP 호출 API
                kakaopayDlp.setTxnId(document.payForm.txnId.value);
                <%=ichannelType%>
                <%=iReturnURL%>
                
                kakaopayDlp.callDlp('kakaopay_layer', document.payForm, submitFunc);
            } else {
                alert('[RESULT_CODE] : ' + document.payForm.resultCode.value + '\n[RESULT_MSG] : ' + document.payForm.resultMsg.value);
            }
        //}
    }
    
    var submitFunc = function cnspaySubmit(data) {

        if (data.RESULT_CODE === '00') {

            // 부인방지토큰은 기본적으로 name="NON_REP_TOKEN"인 input박스에 들어가게 되며, 아래와 같은 방법으로 꺼내서 쓸 수도 있다.
            // 해당값은 가군인증을 위해 돌려주는 값으로서, 가맹점과 카카오페이 양측에서 저장하고 있어야 한다.
            // var temp = data.NON_REP_TOKEN;
            
            payProcessing();
            document.payForm.submit();

        } else if (data.RESLUT_CODE === 'KKP_SER_002') {
            // X버튼 눌렀을때의 이벤트 처리 코드 등록
            //alert('[RESULT_CODE] : ' + data.RESULT_CODE + '\n[RESULT_MSG] : ' + data.RESULT_MSG);
            alert(data.RESULT_MSG);
            location.replace("<%=M_SSLUrl&vAppLink%>/inipay/UserInfo.asp");
        } else {
            //alert('[RESULT_CODE] : ' + data.RESULT_CODE + '\n[RESULT_MSG] : ' + data.RESULT_MSG);
            alert(data.RESULT_MSG);
            location.replace("<%=M_SSLUrl&vAppLink%>/inipay/UserInfo.asp");
        }
    };
    
    function hideKaPayBtn(){
        document.getElementById("ipayBtn").style.display="none";
        document.getElementById("icancelBtn").style.display="none";
    }
    
    function cancelKaPay(){
        if (confirm('결제 진행을 취소하시겠습니까?')){
            location.replace('<%=M_SSLUrl&vAppLink%>/inipay/UserInfo.asp');
        }
    }
    
    function payProcessing(){
        document.getElementById("iactBtnImg").style.display="none";
        document.getElementById("ipayProcess").style.display="inline";
    }
    
    $(document).ready(function() {
//        document.getElementById("ipayBtn").style.display="inline";
    });
    </script>
		<div class="kkoBridge">
			<!-- p class="kkoBdgLogo"><img src="kakao_bridge_logo.png" alt="카카오페이로고"></p -->
			<div class="kkoBdgTxt">
				<div><img id="iactBtnImg" src="kakao_bridge_txt.png" alt="결제를 위해 카카오페이 실행 버튼을 눌러주세요."></div>
			</div>
			<div class="kkoBdgBtn">
				<button id="ipayBtn" onClick="hideKaPayBtn(); cnspay();"><img src="kakao_bridge_btn.png" alt="카카오페이 실행"></button>
				<div align="center" id="ipayProcess" style="display:none">결제 진행중입니다.</div>
			</div>
			<div class="kkoBdgFoot">
				<button id="icancelBtn" type="button" id="kkoBdgClose"><img src="kakao_bridge_cancel.png" alt="취소하기" onClick="cancelKaPay();"></button>
			</div>
		</div>
		<style>
			.kkoBridge {position:relative; height:100%; background-color:#fee42f;}
			/*
			.kkoBdgLogo {position:absolute; top:21px; left:19px;}
			.kkoBdgLogo img {width: 93px; height: 17px;}
			*/
			.kkoBdgTxt {position:absolute; top:40%; width:100%;}
			.kkoBdgTxt img {width:204px; height:43px;}
			.kkoBdgBtn {position:absolute; bottom:57px; width:100%; text-align:center;}
			.kkoBdgBtn img {width:290px; height:66px;}
			.kkoBdgFoot {position:absolute; bottom:22px; width:100%;}
			.kkoBdgFoot img {width:51px; height:15px;}
			button {margin:0; padding:0; border:none; background-color:transparent;}
		</style>
    </body>
</html>
<%
SET irefPgParam = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->