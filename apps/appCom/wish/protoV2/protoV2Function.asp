<%
function getTopMenuJSon
    ''TODAY, BEST,SALE, EVENT, WISH, GIFT
    
    Dim URIFIX 
    URIFIX = "http://m.10x10.co.kr"
    IF application("Svr_Info")="Dev" THEN
         URIFIX = "http://testm.10x10.co.kr"   
    end if
    
    dim objRst
    Set objRst = jsArray()
    SET objRst(Null) = jsObject()
    if (request.serverVariables("REMOTE_ADDR")="211.206.236.117") then
        objRst(Null)("topid") ="today"
        objRst(Null)("topname") = "TODAY"
        objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/today/index.asp"
        objRst(Null)("topdefault") =1
    else
        objRst(Null)("topid") ="today"
        objRst(Null)("topname") = "TODAY"
        objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/today/index.asp"
        objRst(Null)("topdefault") =1
    end If

'	비오거나 흐린날 바캉스와 변경
'	SET objRst(Null) = jsObject()
'	objRst(Null)("topid") ="rain"
'	objRst(Null)("topname") = "RAIN"
'	objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/event/gnbeventmain.asp?eventid=63504"
'	objRst(Null)("topdefault") =0

'	신학기
'	SET objRst(Null) = jsObject()
'	objRst(Null)("topid") ="newterm"
'	objRst(Null)("topname") = "신학기"
'	objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/event/gnbeventmain.asp?eventid=65326"
'	objRst(Null)("topdefault") =0

'	한가위
	SET objRst(Null) = jsObject()
	objRst(Null)("topid") ="wedding"
	objRst(Null)("topname") = "WEDDING"
	objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/event/gnbeventmain.asp?eventid=66144"
	objRst(Null)("topdefault") =0
	
'	SET objRst(Null) = jsObject()
'	objRst(Null)("topid") ="vacance"
'	objRst(Null)("topname") = "바캉스"
'	objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/event/gnbeventmain.asp?eventid=64274"
'	objRst(Null)("topdefault") =0

'	SET objRst(Null) = jsObject()
'    objRst(Null)("topid") ="dontmiss"
'    objRst(Null)("topname") = "GO!"
'    objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/event/eventmain.asp?eventid=62313"
'    objRst(Null)("topdefault") =0	

'    SET objRst(Null) = jsObject()
'    objRst(Null)("topid") ="wedding"
'    objRst(Null)("topname") = "웨딩"
'    objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/event/eventmain.asp?eventid=60432"
'    objRst(Null)("topdefault") =0	

    SET objRst(Null) = jsObject()
    objRst(Null)("topid") ="best"
    objRst(Null)("topname") = "BEST"
    objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/award/awarditem.asp"
    objRst(Null)("topdefault") =0

    SET objRst(Null) = jsObject()
    objRst(Null)("topid") ="event"
    objRst(Null)("topname") = "EVENT"
    objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/shoppingtoday/shoppingchance_allevent.asp"
    objRst(Null)("topdefault") =0
 
    SET objRst(Null) = jsObject()
    objRst(Null)("topid") ="wish"
    objRst(Null)("topname") = "WISH"
    objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/wish/index.asp"
    objRst(Null)("topdefault") =0
    
    SET objRst(Null) = jsObject()
    objRst(Null)("topid") ="gift"
    objRst(Null)("topname") = "GIFT"
    objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/gift/gifttalk/index.asp"
    objRst(Null)("topdefault") =0
    
	SET objRst(Null) = jsObject()
    objRst(Null)("topid") ="play"
    objRst(Null)("topname") = "PLAY"
    objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/play/index.asp"
    objRst(Null)("topdefault") =0

    IF application("Svr_Info")="Dev" THEN
        SET objRst(Null) = jsObject()
        objRst(Null)("topid") ="link"
        objRst(Null)("topname") = "LINK"
        objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/pagelist.asp"
        objRst(Null)("topdefault") =0
    end if
    
    SET getTopMenuJSon = objRst
    
    Set objRst = Nothing
end function


function getTopMenuJSon_2015
    ''TODAY, LIVING , FASHION , LIFE STYLE , DIGITAL , BABY
    
    Dim URIFIX 
    URIFIX = "http://m.10x10.co.kr"
    IF application("Svr_Info")="Dev" THEN
         URIFIX = "http://testm.10x10.co.kr"   
    end if
    
    dim objRst
    Set objRst = jsArray()
    SET objRst(Null) = jsObject()
	objRst(Null)("topid") ="today"
	objRst(Null)("topname") = "TODAY"
	objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/today/index.asp"
	objRst(Null)("topdefault") =1

    SET objRst(Null) = jsObject()
    objRst(Null)("topid") ="living"
    objRst(Null)("topname") = "리빙"
    objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/catemain/index.asp?gnbcode=100"
    objRst(Null)("topdefault") =0

    SET objRst(Null) = jsObject()
    objRst(Null)("topid") ="stationery"
    objRst(Null)("topname") = "디자인문구"
    objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/catemain/index.asp?gnbcode=400"
    objRst(Null)("topdefault") =0

    SET objRst(Null) = jsObject()
    objRst(Null)("topid") ="fashion"
    objRst(Null)("topname") = "패션/뷰티"
    objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/catemain/index.asp?gnbcode=200"
    objRst(Null)("topdefault") =0

    SET objRst(Null) = jsObject()
    objRst(Null)("topid") ="lifestyle"
    objRst(Null)("topname") = "여행/취미"
    objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/catemain/index.asp?gnbcode=300"
    objRst(Null)("topdefault") =0
 
    SET objRst(Null) = jsObject()
    objRst(Null)("topid") ="digital"
    objRst(Null)("topname") = "디지털"
    objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/catemain/index.asp?gnbcode=500"
    objRst(Null)("topdefault") =0
    
    SET objRst(Null) = jsObject()
    objRst(Null)("topid") ="baby"
    objRst(Null)("topname") = "키즈"
    objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/catemain/index.asp?gnbcode=600"
    objRst(Null)("topdefault") =0

   
    SET getTopMenuJSon_2015 = objRst
    
    Set objRst = Nothing
end Function

function getTopMenuJSon_iOS_TEST
    ''TODAY, BEST,SALE, EVENT, WISH, GIFT
    
    Dim URIFIX 
    URIFIX = "http://m.10x10.co.kr"
    IF application("Svr_Info")="Dev" THEN
         URIFIX = "http://testm.10x10.co.kr"   
    end if
    
    dim objRst
    Set objRst = jsArray()
    SET objRst(Null) = jsObject()
    objRst(Null)("topid") ="today"
    objRst(Null)("topname") = "TODAY"
    objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/today/index_TT.asp"
    objRst(Null)("topdefault") =1

    SET objRst(Null) = jsObject()
    objRst(Null)("topid") ="best"
    objRst(Null)("topname") = "BEST"
    objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/award/awarditem_TT.asp"
    objRst(Null)("topdefault") =0

    SET objRst(Null) = jsObject()
    objRst(Null)("topid") ="sale"
    objRst(Null)("topname") = "SALE"
    objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/sale/saleitem_TT.asp"
    objRst(Null)("topdefault") =0

    SET objRst(Null) = jsObject()
    objRst(Null)("topid") ="event"
    objRst(Null)("topname") = "EVENT"
    objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/shoppingtoday/shoppingchance_allevent_TT.asp"
    objRst(Null)("topdefault") =0
 
    SET objRst(Null) = jsObject()
    objRst(Null)("topid") ="wish"
    objRst(Null)("topname") = "WISH"
    objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/wish/index_TT.asp"
    objRst(Null)("topdefault") =0
    
    SET objRst(Null) = jsObject()
    objRst(Null)("topid") ="gift"
    objRst(Null)("topname") = "GIFT"
    objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/gift/gifttalk/index_TT.asp"
    objRst(Null)("topdefault") =0

'	SET objRst(Null) = jsObject()
'    objRst(Null)("topid") ="diary"
'    objRst(Null)("topname") = "DIARY"
'    objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/diarystory2015/index_TT.asp"
'    objRst(Null)("topdefault") =0

    IF application("Svr_Info")="Dev" THEN
        SET objRst(Null) = jsObject()
        objRst(Null)("topid") ="link"
        objRst(Null)("topname") = "LINK"
        objRst(Null)("topurl")  = URIFIX&"/apps/appCom/wish/web2014/pagelist.asp"
        objRst(Null)("topdefault") =0
    end if
    
    SET getTopMenuJSon_iOS_TEST = objRst
    
    Set objRst = Nothing
end function


function getRealTimeBestKeywords
    dim objRst
    DIM oPpkDoc, arrList, iRows
    Set objRst = jsArray()
    
    
	SET oPpkDoc = NEW SearchItemCls
		arrList = oPpkDoc.getPopularKeyWords()
	SET oPpkDoc = NOTHING 
	 
	IF isArray(arrList)  THEN	 
		if Ubound(arrList)>0 then
		    FOR iRows =0 To UBOUND(arrList)
		        Set objRst(Null) = jsObject()
    	        objRst(null)("keyword") = cStr(arrList(iRows))	
	        Next
	    END IF
    END IF            
						    
        
    SET getRealTimeBestKeywords = objRst
    
    Set objRst = Nothing
end function	

''순위변동 포함
function getRealTimeBestKeywords2
    dim objRst
    DIM oPpkDoc, arrList, iRows
    DIM arTg
    Set objRst = jsArray()
    
    
	SET oPpkDoc = NEW SearchItemCls
		Call oPpkDoc.getPopularKeyWords2(arrList, arTg)
	SET oPpkDoc = NOTHING 
	 
	IF isArray(arrList)  THEN	 
		if Ubound(arrList)>0 then
		    FOR iRows =0 To UBOUND(arrList)
		        Set objRst(Null) = jsObject()
    	        objRst(null)("keyword") = cStr(arrList(iRows))	
    	        if cStr(arTg(iRows))="" then
    	            objRst(null)("rank") = cStr("0")
    	        else
    	            objRst(null)("rank") = cStr(arTg(iRows))
    	        end if
	        Next
	    END IF
    END IF            
    SET getRealTimeBestKeywords2 = objRst
    Set objRst = Nothing
end function	

''검색어 자동완성
function getAutoCompleteKeywords(seed_str)
    dim objRst
    DIM oPpkDoc, ikwd_count, ikwd_list, icnv_str, iRows
    Set objRst = jsArray()
    
    
	SET oPpkDoc = NEW SearchItemCls
		Call oPpkDoc.getAutoCompleteKeywords(seed_str, ikwd_count, ikwd_list, icnv_str)
	SET oPpkDoc = NOTHING 
	 
	
    FOR iRows =0 To ikwd_count-1
        Set objRst(Null) = jsObject()
        objRst(null)("Word") = cStr(ikwd_list(iRows))	
        objRst(null)("Seed") = cStr(seed_str)	
        objRst(null)("Conv") = "" 'cStr(icnv_str)	search4에서 구조가 좀 바뀌었음  2015/03/09
    Next
						    
        
    SET getAutoCompleteKeywords = objRst
    
    Set objRst = Nothing
end function

function getRecentOrderCount(iuserid)
    dim sqlStr
    getRecentOrderCount =0
    if Len(userid)<1 then Exit function
    
    sqlStr = " exec [db_order].dbo.sp_Ten_get_His_recent_OrderCNT '"&iuserid&"'" 
    rsget.CursorLocation = adUseClient
    rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
    if Not rsget.Eof then
        getRecentOrderCount = rsget("CNT")
    end if
	rsget.Close
	
    
end function

function getRecentOrderCountGuest(iorderserial)
    dim sqlStr
    getRecentOrderCountGuest =0
    if Len(iorderserial)<1 then Exit function
 exit function ''사용안함.
    
    '' 최근 3주간 주문/배송 갯수. (주문대기 이상, 정상건)
    sqlStr = "select Count(*) as CNT"
	sqlStr = sqlStr + " from db_order.dbo.tbl_order_master "
	sqlStr = sqlStr + " where orderserial='" + iorderserial + "'"
	sqlStr = sqlStr + " and ipkumdiv>=2 "
	sqlStr = sqlStr + " and jumundiv<>9 "
	sqlStr = sqlStr + " and cancelyn='N' "
	sqlStr = sqlStr + " and datediff(ww,regdate,getdate()) between 0 and 2 "
	rsget.CursorLocation = adUseClient
    rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
	if Not rsget.Eof then
        getRecentOrderCountGuest = rsget("CNT")
    end if
	rsget.Close
end function


function getPersonalNotiList(iuserid)
    dim objRst
    dim sqlStr, rorderserial
    dim clsEvtPrize, arrEvtPrize, revtprize_code, rbcpnidx
    Set objRst = jsArray()
        if (TRUE) or (iuserid="") then  ''
            SET getPersonalNotiList = objRst
            Set objRst = Nothing
            
            Exit function
        end if
        
        '' 최근 배송건
        sqlStr = "select top 1 d.orderserial from db_order.dbo.tbl_order_detail D"&VBCRLF
        sqlStr = sqlStr + " 	Join db_order.dbo.tbl_order_master m"&VBCRLF
        sqlStr = sqlStr + " 	on D.orderserial=M.orderserial"&VBCRLF
        sqlStr = sqlStr + " where m.userid='"&iuserid&"'"&VBCRLF
        sqlStr = sqlStr + " and m.cancelyn='N'"&VBCRLF
        sqlStr = sqlStr + " and m.sitename='10x10'"&VBCRLF
        sqlStr = sqlStr + " and m.ipkumdiv>3"
        sqlStr = sqlStr + " and m.jumundiv not in ('6','9')"&VBCRLF
        sqlStr = sqlStr + " and d.itemid<>0"&VBCRLF
        sqlStr = sqlStr + " and d.cancelyn<>'Y'"&VBCRLF
        sqlStr = sqlStr + " and datediff(d,m.regdate,getdate())<31"&VBCRLF   ''한달간 주문
        sqlStr = sqlStr + " and datediff(d,d.beasongdate,getdate())<7"&VBCRLF  ''최근 일주일
        sqlStr = sqlStr + " order by d.beasongdate desc"
        rsget.Open sqlStr,dbget,1
    	if Not rsget.Eof then
            rorderserial = rsget("orderserial")
        end if
    	rsget.Close
    
    if (iuserid="10x10green") then    
        rorderserial="14091243059"
    end if
        if (rorderserial<>"") then
            Set objRst(Null) = jsObject()
            objRst(Null)("notikey") = "ord_"&rorderserial
            objRst(Null)("btntext") = "주문상세내역"
            objRst(Null)("notitext") = rorderserial&"<br>상품이 <b>출고완료</b> 되었습니다."
            objRst(Null)("notitype") = 1
            'objRst(Null)("bgcolor") = "#F1A76B" 
            'objRst(Null)("notiimg") = "http://fiximage.10x10.co.kr/m/2014/common/private_delevery.png"
            objRst(Null)("notiurl") = "http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/order/myorderdetail.asp?idx="&rorderserial
        end if
        
        '' 최근 이벤트 당첨.
        revtprize_code = 0
        set clsEvtPrize  = new CEventPrize
	    clsEvtPrize.FUserid = userid
        arrEvtPrize = clsEvtPrize.fnGetEventPrizeLastOneForApp()
        
        if (clsEvtPrize.FResultCount > 0) then
            revtprize_code = arrEvtPrize(0,0)
        end if
        set clsEvtPrize = Nothing
   if (iuserid="10x10green") then
    revtprize_code=1     
   end if
        if (revtprize_code>0) then
            Set objRst(Null) = jsObject()
            objRst(Null)("notikey") = "win_"&revtprize_code
            objRst(Null)("btntext") = "이벤트 당첨확인"
            objRst(Null)("notitext") = "이벤트 당첨을 축하드립니다."
            objRst(Null)("notitype") = 2
            'objRst(Null)("bgcolor") = "#67BCAD"  
            'objRst(Null)("notiimg") = "http://fiximage.10x10.co.kr/m/2014/common/private_event.png"
            objRst(Null)("notiurl") = "http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/myeventmaster.asp"  ''페이지 확인.
        end if
        
        '' 최근 생일쿠폰
        rbcpnidx=0
        
        sqlStr = "select top 1 idx from [db_user].dbo.tbl_user_coupon"&vbCrlf
        sqlStr = sqlStr&" where masteridx=126"&vbCrlf
        sqlStr = sqlStr&" and userid='"&iuserid&"'"&vbCrlf
        sqlStr = sqlStr&" and isusing='N'"&vbCrlf
        sqlStr = sqlStr&" and deleteyn='N'"&vbCrlf
        sqlStr = sqlStr&" and datediff(d,startdate,getdate())<7"&vbCrlf
        sqlStr = sqlStr&" and expiredate>getdate()"&vbCrlf
        sqlStr = sqlStr&" order by idx desc"&vbCrlf
        
        rsget.Open sqlStr,dbget,1
    	if Not rsget.Eof then
            rbcpnidx = rsget("idx")
        end if
    	rsget.Close
   if (iuserid="10x10green") then
    rbcpnidx=1 	
   end if
        if (rbcpnidx>0) then
            Set objRst(Null) = jsObject()
            objRst(Null)("notikey") = "cpn_"&rbcpnidx
            objRst(Null)("btntext") = "MY 쿠폰확인"
            objRst(Null)("notitext") = "<b>HAPPY BIRTHDAY</b><br>5,000 쿠폰 선물을 준비했습니다."
            objRst(Null)("notitype") = 3
            'objRst(Null)("bgcolor") = "#A599D8"
            'objRst(Null)("notiimg") = "http://fiximage.10x10.co.kr/m/2014/common/private_birthday.png"
            objRst(Null)("notiurl") = "http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp"
        end if
    SET getPersonalNotiList = objRst
    Set objRst = Nothing
end function

''proto V2 추가  브랜드 이벤트 리스트
public function getBrandeventListJson(iMakerid)
    dim objRst, sqlStr
    Set objRst = jsArray()
    
    sqlStr = " select top 5 e.evt_code,e.evt_name"
    sqlStr = sqlStr&" from db_event.dbo.tbl_event E"
    sqlStr = sqlStr&" 	Join db_event.dbo.tbl_event_Display D"
    sqlStr = sqlStr&" 	on E.evt_code=D.evt_code"
    sqlStr = sqlStr&" where isNULL(D.brand,'')='"&iMakerid&"'" ''D.brand='travelmate01'  ''인덱스 필요.?
    sqlStr = sqlStr&" and E.evt_state=7"
    sqlStr = sqlStr&" and E.evt_startdate<getdate()"
    sqlStr = sqlStr&" and E.evt_enddate>getdate()"
    sqlStr = sqlStr&" and dateDiff(m,E.evt_startdate,getdate())<12" '' 최근 1년
    sqlStr = sqlStr&" and E.evt_using='Y' "
    sqlStr = sqlStr&" and E.evt_Kind in (19,25)" ''확인
    sqlStr = sqlStr&" order by E.evt_code desc "
    
    rsget.Open sqlStr,dbget,1
	if Not rsget.Eof then
        Set objRst(Null) = jsObject()
    	objRst(null)("evttitle") = cStr(stripHTML(rsget("evt_name")))
    	objRst(null)("evturl") = cStr("http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&rsget("evt_code"))
    	
    	rsget.movenext
    end if
	rsget.Close
	
'	Set objRst(Null) = jsObject()
'    	objRst(null)("evttitle") = cStr("이벤트명 이벤트....")
'    	objRst(null)("evturl") = cStr("http://m.10x10.co.kr/event/eventmain.asp?eventid=54590")
	
    SET getBrandeventListJson = objRst
    Set objRst = Nothing
end function

function getNotReadPushNotiExists(sDeviceId,slastconfirmtime)
    dim sqlStr
    getNotReadPushNotiExists =0
    if Len(sDeviceId)<1 then Exit function
    if LEN(Trim(slastconfirmtime))<>19 then Exit function ''오전, 오후 특정디바이스에 있음? IOS 1.92 //2015/03/02
    if (left(slastconfirmtime,2)="00") then Exit function ''// 0027-06-25 18:14:01 
    if (Not IsDate(slastconfirmtime)) then Exit function '' 2015/07/29
                
    sqlStr = "exec db_AppNoti.dbo.sp_Ten_getAppHisRecentNotiCount '"&sDeviceId&"','"&slastconfirmtime&"'"
    
	rsAppNotiget.Open sqlStr,dbAppNotiget,1
	if Not rsAppNotiget.Eof then
	    if rsAppNotiget("CNT")>0 then
            getNotReadPushNotiExists = 1
        else
            getNotReadPushNotiExists = 0
        end if
    end if
	rsAppNotiget.Close
end function

function getPushNotiList(sDeviceId,slastconfirmtime)
    dim objRst, sqlStr
    dim multipskey,sendmsg,resultdate, diffmin, notititle, notitime, notiurl
    dim pos1,pos2
    
    Set objRst = jsArray()
    
    if Len(sDeviceId)<1 then 
        SET getPushNotiList = objRst
        Set objRst = Nothing
        Exit function
    end if
    
    sqlStr = "exec db_AppNoti.dbo.sp_Ten_getAppHisRecentNotiList '"&sDeviceId&"'"
    
	rsAppNotiget.Open sqlStr,dbAppNotiget,1
	do until rsAppNotiget.Eof 
	    Set objRst(Null) = jsObject()
	    multipskey  = rsAppNotiget("multipskey")
	    sendmsg     = rsAppNotiget("sendmsg")
	    resultdate  = rsAppNotiget("resultdate")
	    diffmin     = rsAppNotiget("diffmin")
	    
	    pos1 = InStr(sendmsg,"{""noti"":""")
        if (pos1>0) then 
            pos1=pos1+LEN("{""noti"":""")
            pos2=InStr(MID(sendmsg,pos1,1024),"""")
            if (pos2>0) then
                notititle = Mid(sendmsg,pos1,pos2-1)
            end if
        end if
        
        pos1 = InStr(sendmsg,"""url"":""")
        if (pos1>0) then 
            pos1=pos1+LEN("""url"":""")
            pos2=InStr(MID(sendmsg,pos1,1024),"""")
            if (pos2>0) then
                notiurl = Mid(sendmsg,pos1,pos2-1)
            end if
        end if

        if (diffmin>=1440) then
            notitime = MID(resultdate,6,2)&"월 "&MID(resultdate,9,2)&"일"
        elseif (diffmin>=60) then
            notitime = CLNG(diffmin/60)&"시간 전"
        elseif (diffmin<1) then
            notitime = "방금 전"
        end if
        
	    if (multipskey>0) then
	        objRst(null)("noticolor") = cStr("#D60000")
	    else
	        if InStr(notititle,"상품이 출고")>0 then
	            objRst(null)("noticolor") = cStr("#48C8F7")
	        else
	            objRst(null)("noticolor") = cStr("#FFC0000")
	        end if
	    end if
	    
    	objRst(null)("notititle") = cStr(notititle)
    	objRst(null)("notitime") = cStr(notitime)
    	objRst(null)("notiurl") = cStr(notiurl)
    	
        rsAppNotiget.moveNext
    loop
	rsAppNotiget.Close
	
	SET getPushNotiList = objRst
    Set objRst = Nothing
    
end function
%>