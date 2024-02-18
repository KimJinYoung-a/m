<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/event/timesale/timesaleCls.asp" -->
<%

''계속쇼핑하기 경로 설정
''Call setPreShoppingLocation

''userinfo.asp로 이동시 캐시가 않먹도록 파람추가, vParam 있는경우 뒤에 추가. 20180209
dim i_dtm : i_dtm = Year(now())&Right("00"&Month(now()),2)&Right("00"&Day(now()),2)&Right("00"&Hour(now()),2)&Right("00"&Minute(now()),2)&Right("00"&Second(now()),2)

''추가 로그 //2016/05/18 by eastone
function AppendLog_shoppingBagProc()
    dim iAddLogs
    ''if NOT (application("Svr_Info")="Dev") then exit function ''실서버 잠시 중지시.
        
    iAddLogs=request.Cookies("uinfo")("shix")
    if (iAddLogs="") then    
        iAddLogs=request.Cookies("shoppingbag")("GSSN")
    end if
    iAddLogs = "uk="&iAddLogs
    
    if (request.ServerVariables("QUERY_STRING")<>"") then iAddLogs="&"&iAddLogs
    
    iAddLogs=iAddLogs&"&ggsn="&fn_getGgsnCookie() ''2017/11/07 추가
    iAddLogs=iAddLogs&"&mode="&request.Form("mode")&"&rdsite="&request.cookies("rdsite")
    ''''&"&itemid="&request.Form("itemid")&"&itemoption="&request.Form("itemoption")&"&itemea="&request.Form("itemea")
    
    response.AppendToLog iAddLogs
    
end function


'' 사이트 구분
Const sitename = "10x10"

dim i, tmparr
dim userid, guestSessionID
userid = GetLoginUserID
guestSessionID = GetGuestSessionKey()

dim mode            : mode		    = requestCheckVar(request.Form("mode"),10)
dim itemid          : itemid		= requestCheckVar(request.Form("itemid"),9)
dim itemoption      : itemoption    = requestCheckVar(request.Form("itemoption"),4)
dim itemea          : itemea  	    = requestCheckVar(request.Form("itemea"),9)
dim bagarr          : bagarr	    = request.Form("bagarr")
dim requiredetail   : requiredetail = html2db(request.Form("requiredetail"))
dim chk_item        : chk_item      = request("chk_item")
dim bTp             : bTp           = request("bTp") ''dim jumundiv        : jumundiv      = request("jumundiv")  '' 2013/09 수정
dim jumundiv        : jumundiv      = request("jumundiv")
dim ckdidx
dim countryCode     : countryCode   = requestCheckvar(request("countryCode"),2)
dim vParam
dim rentalmonth     : rentalmonth   = requestCheckvar(request("rentalmonth"),20)

if requestCheckVar(request("rdsite"),32)<>"" then
	if (request.cookies("rdsite")<>requestCheckVar(request("rdsite"),32)) then
		response.cookies("rdsite").domain = "10x10.co.kr"
		response.cookies("rdsite") = requestCheckVar(request("rdsite"),32)
		response.cookies("rddata") = requestCheckVar(request("rddate"),32)
	end if
end if

Dim tp : tp = requestCheckVar(request("tp"),10)   '' not post
Dim fc : fc = requestCheckVar(request.Form("fc"),10)

Dim ValidRet
Dim retBool, iErrMsg, itemarr

if (itemid<>"") and (itemoption<>"") and (itemea<>"") and (mode="") then
    mode = "add"
end if

'2020-11-04 정태훈 오리온 쫄깃쫄KIT 구매금지 추가
if itemid="3371142" then
    response.write "<script>alert('정상적인 경로로 접근해주세요.');</script>"
    response.write "<script>history.back();</script>"		
    dbget.close() : response.end
end if

if (jumundiv<>"") and (jumundiv<>"1") then
	vParam = vParam & chkIIF(vParam="","?","&") & "jk=" + jumundiv
end if
if (bTp<>"")  then
	vParam = vParam & chkIIF(vParam="","?","&") & "bTp=" & bTp & CHKIIF(bTp="f" and countryCode<>"","&ctrCd="&countryCode,"")
end if

dim oShoppingBag
set oShoppingBag = new CShoppingBag
oShoppingBag.FRectUserID    = userid
oshoppingbag.FRectSessionID = guestSessionID
oShoppingBag.FRectSiteName  = sitename

dim NotValidItemExists

'체크 최종원
'타임세일 조건 : 이 로직을 타는 시간에 해당하는 상품코드 <> 들어온 상품코드
'2021.02.23 태훈 추가 DB로직 추가
if itemid <> "" and not (mode="del" or mode="edit" or mode="DLARR") then
	itemid = request.Form("itemid")
    itemarr = chk_item
	if not isOnTimeProduct(userid,itemid,itemarr) then
        response.write "<script>alert('정상적인 경로로 접근해주세요.');</script>"
        response.write "<script>history.back();</script>"		
        dbget.close() : response.end
	end if
end if
if bagarr <> "" then
    itemarr = chk_item
	if not isOnTimeProduct(userid,bagarr,itemarr) then
        response.write "<script>alert('정상적인 경로로 접근해주세요.');</script>"
        response.write "<script>history.back();</script>"		
        dbget.close() : response.end
	end if
end if

if (mode="add") then
    if (itemid<>"") and (itemoption<>"") and (itemea<>"") then

        ValidRet = oshoppingbag.checkValidItem(itemid,itemoption)
        if (ValidRet=0) then
            response.write "<script>alert('죄송합니다. 유효하지 않은 상품이거나 품절된 상품입니다.');</script>"
            response.write "<script>history.back();</script>"

            dbget.close() : response.end
        elseif (ValidRet=2) then
            ''동일한 상품이 이미 장바구니에 있을경우 : Confirm 후 담기
            if (fc<>"") then
                oshoppingbag.AddshoppingBagDB itemid,itemoption,itemea,requiredetail
                ValidRet = 1
                if (tp="pop") then
                    response.write "<script>self.close();</script>"
                    dbget.close() : response.end
                end if
            else
                oshoppingbag.AddshoppingBagDB itemid,itemoption,itemea,requiredetail
                ''response.write "<script>alert('동일상품이 존재..');</script>"
                ''dbget.close() : response.end
            end if
        else
            oshoppingbag.AddshoppingBagDB itemid,itemoption,itemea,requiredetail
        end if

        '// 장바구니에 상품을 담은 후 렌탈 상품일 경우 month값도 담는다.
        If Trim(rentalmonth) <> "" Then
            oshoppingbag.RentalProductBaguniUpdateMonth itemid,itemoption,itemea,rentalmonth
        End If
    end if

elseif (mode="edit") then
    if (itemid<>"") and (itemoption<>"") and (itemea<>"") then
		oshoppingbag.EditshoppingBagDB itemid,itemoption,itemea
	end if

elseif (mode="arr") then
    ''''관심품목에서 담을때는 1개로..
    ''''response.write "bagarr=" & bagarr
    NotValidItemExists = false
	bagarr = split(bagarr,"|")

	for i=LBound(bagarr) to UBound(bagarr)
	    if Trim(bagarr(i))<>"" then
			tmparr = split(bagarr(i),",")
			if UBound(tmparr)>1 then
				if (tmparr(0)<>"") and (tmparr(1)<>"") and (tmparr(2)<>"") then
				    if getNumeric(tmparr(2))="" then tmparr(2)=1
				    ValidRet = oshoppingbag.checkValidItem(tmparr(0),tmparr(1))

				    if ubound(tmparr)>2 then
				    	requiredetail = html2db(tmparr(3))  '''html2db 추가
				    else
				    	requiredetail = ""
				    end if

				    if (ValidRet=0) then
				        NotValidItemExists = true
				    elseif (ValidRet=2) then
	                    ''동일한 상품이 이미 장바구니에 있을경우 : Confirm 후 담기(X) ? or 1개로 조정
                        ''Edit... 으론 문구 수정이 안되어서 Add... 으로 변경(2019.03.15 원승현)
	                    'oshoppingbag.EditshoppingBagDB tmparr(0),tmparr(1),1
                        oshoppingbag.AddshoppingBagDB tmparr(0),tmparr(1),tmparr(2),requiredetail
	                else
				        oshoppingbag.AddshoppingBagDB tmparr(0),tmparr(1),tmparr(2),requiredetail
				    end if
				end if
			end if
		end if
	next
	ValidRet=1

elseif (mode="del") then
	itemid = split(itemid,",")
	itemoption = split(itemoption,",")
	itemea = split(itemea,",")
	for i=LBound(itemid) to UBound(itemid)
	    if (Trim(itemid(i))<>"") and (Trim(itemoption(i))<>"") and (Trim(itemea(i))<>"") then
			oshoppingbag.EditshoppingBagDB Trim(itemid(i)),Trim(itemoption(i)),Trim(itemea(i))
		end if
	next

elseif (mode="DO1") Then
    ''바로 주문.(선택 초기화 > 해당상품 체크 > 주문페이지로 이동)
    if (itemid<>"") and (itemoption<>"") and (itemea<>"") then
		'선택 초기화
		call oshoppingbag.OrderCheckOutDefault

        '장바구니수 업데이트
        if oshoppingbag.checkValidItem(itemid,itemoption)=1 then
        	Call SetCartCount(GetCartCount+1)
        end if

    	'장바구니 담기
    	oshoppingbag.AddshoppingBagDB itemid,itemoption,itemea,requiredetail

        '// 장바구니에 상품을 담은 후 렌탈 상품일 경우 month값도 담는다.
        If Trim(rentalmonth) <> "" Then
            oshoppingbag.RentalProductBaguniUpdateMonth itemid,itemoption,itemea,rentalmonth
        End If        
    end if

    if (oshoppingbag.CheckOutOneItem(itemid,itemoption,itemea)) then
        Call AppendLog_shoppingBagProc() ''2016/05/18 추가
        response.redirect M_SSLUrl & "/inipay/UserInfo.asp"&"?dtm="&i_dtm
    else
        response.write "<script>alert('죄송합니다. 유효하지 않은 상품이거나 품절된 상품입니다.');</script>"
        response.write "<script>history.back();</script>"

        dbget.close() : response.end
    end If

elseif (mode="DO2") then
	dim vAddItemCnt: vAddItemCnt=0
	dim vChkOutItem: vChkOutItem=false

	''바로 주문(배열)
	bagarr = split(bagarr,"|")

	'선택 초기화
	if UBound(bagarr)>0 then
		call oshoppingbag.OrderCheckOutDefault
	end if

	for i=LBound(bagarr) to UBound(bagarr)
	    if Trim(bagarr(i))<>"" then
			tmparr = split(bagarr(i),",")
			if UBound(tmparr)>1 then
				if (tmparr(0)<>"") and (tmparr(1)<>"") and (tmparr(2)<>"") then
					if getNumeric(tmparr(2))="" then tmparr(2)=1
				    ValidRet = oshoppingbag.checkValidItem(tmparr(0),tmparr(1))

				    if ubound(tmparr)>2 then
				    	requiredetail = html2db(tmparr(3))  '''html2db 추가
				    else
				    	requiredetail = ""
				    end if

				    if (ValidRet=2) then
	                    ''동일한 상품이 이미 장바구니에 있을경우
                        ''Edit... 으론 문구 수정이 안되어서 Add... 으로 변경(2019.03.15 원승현)
	                    'oshoppingbag.EditshoppingBagDB tmparr(0),tmparr(1),tmparr(2)
                        oshoppingbag.AddshoppingBagDB tmparr(0),tmparr(1),tmparr(2),requiredetail
	                else
				        oshoppingbag.AddshoppingBagDB tmparr(0),tmparr(1),tmparr(2),requiredetail
				        vAddItemCnt = vAddItemCnt + 1
				    end if

				    '장바구니 담기
				    if (oshoppingbag.CheckOutOneItem(tmparr(0),tmparr(1),tmparr(2))) then	vChkOutItem=true
				end if
			end if
		end if
	next

    '장바구니수 업데이트
    Call SetCartCount(GetCartCount+vAddItemCnt)

    if vChkOutItem then
        Call AppendLog_shoppingBagProc() ''2016/05/18 추가
        
        dbget.close()
        response.redirect M_SSLUrl & "/inipay/UserInfo.asp"&"?dtm="&i_dtm
    else
        response.write "<script>alert('죄송합니다. 유효하지 않은 상품이거나 품절된 상품입니다.');</script>"
        response.write "<script>history.back();</script>"

        dbget.close() : response.end
    end if
elseif (mode="DO4") Then	''장바구니내 바로 주문
    ''바로 주문.(선택 초기화 > 해당상품 체크 > 주문페이지로 이동)
    if (itemid<>"") and (itemoption<>"") and (itemea<>"") then
		'선택 초기화
		call oshoppingbag.OrderCheckOutDefault

        '장바구니수 업데이트
        if oshoppingbag.checkValidItem(itemid,itemoption)=1 then
        	Call SetCartCount(GetCartCount+1)
        end if
    end if

    if (oshoppingbag.CheckOutOneItem(itemid,itemoption,itemea)) then
        Call AppendLog_shoppingBagProc() ''2016/05/18 추가
        
        response.redirect M_SSLUrl & "/inipay/UserInfo.asp" & vParam &CHKIIF(vParam="","?","&")&"dtm="&i_dtm
    else
        response.write "<script>alert('죄송합니다. 유효하지 않은 상품이거나 품절된 상품입니다.');</script>"
        response.write "<script>history.back();</script>"

        dbget.close() : response.end
    end If
elseif (mode="OCK") then
    ''선택상품 주문

    chk_item   = split(chk_item,",")
    itemid     = split(request.Form("itemid"),",")
    itemoption = split(request.Form("itemoption"),",")

    if IsArray(chk_item) then
        retBool = True
        ''다른상품 모두 초기화..
        If (Not oshoppingbag.OrderCheckOutDefault) then
	        retBool = false
	        iErrMsg = "장바구니 수정중 오류가 발생 하였습니다. Err-101"
	    end if

	    IF (retBool) then
            for i=LBound(chk_item) to UBound(chk_item)
                ckdidx = Trim(chk_item(i))
        	    if ckdidx<>"" then
        			if (Trim(itemid(ckdidx))<>"") and (Trim(itemoption(ckdidx))<>"") then
        			    If (Not oshoppingbag.CheckOutOneItem(Trim(itemid(ckdidx)),Trim(itemoption(ckdidx)),0)) then
        			        retBool= false
        			        iErrMsg = "장바구니 수정중 오류가 발생 하였습니다. 상품코드:"&Trim(itemid(ckdidx))
        			    end if
        			end if
        		end if
        	next
        End if
    end if

    IF (retBool) then
        Call AppendLog_shoppingBagProc() ''2016/05/18 추가
        
		response.redirect M_SSLUrl & "/inipay/UserInfo.asp" & vParam&CHKIIF(vParam="","?","&")&"dtm="&i_dtm
    Else
        response.write "<script>alert('"&iErrMsg&"');</script>"
        response.write "<script>history.back();</script>"

        dbget.close() : response.end
    End if
elseif (mode="ALK") then
    ''전체주문
    retBool = oshoppingbag.CheckOutALLItem

    IF (retBool) then
        Call AppendLog_shoppingBagProc() ''2016/05/18 추가
        
		response.redirect M_SSLUrl & "/inipay/UserInfo.asp" & vParam&CHKIIF(vParam="","?","&")&"dtm="&i_dtm
    Else
        iErrMsg = "장바구니 수정중 오류가 발생 하였습니다. Err-201"
        response.write "<script>alert('"&iErrMsg&"');</script>"
        response.write "<script>history.back();</script>"

        dbget.close() : response.end
    End if
elseif (mode="DLARR") then
    ''장바구니에서 삭제
    chk_item   = split(chk_item,",")
    itemid     = split(request.Form("itemid"),",")
    itemoption = split(request.Form("itemoption"),",")

    if IsArray(chk_item) then
        retBool = True
        for i=LBound(chk_item) to UBound(chk_item)
            ckdidx = Trim(chk_item(i))
    	    if ckdidx<>"" then
    			if (Trim(itemid(ckdidx))<>"") and (Trim(itemoption(ckdidx))<>"") then
    			     oshoppingbag.EditshoppingBagDB Trim(itemid(ckdidx)),Trim(itemoption(ckdidx)),0

    			end if
    		end if
    	next
    end if

else
    '' noparams
    ''response.write "<script>alert('No params : '"&mode&");</script>"
    response.End
end if

set oshoppingbag = Nothing

Call AppendLog_shoppingBagProc() ''2016/05/18 추가
%>

<%
'//처리 후 최종 장바구니 상품수 접수
dim vBagCnt: vBagCnt = getDBCartCount
Call setCartCount(vBagCnt)

''상품이 이미 존재하는경우 ShoppingBag.asp에서 pop  and (ValidRet<>2)
if (tp<>"pop") then
    if (ValidRet<>2) then
        dbget.close()
        response.redirect "ShoppingBag.asp" & vParam
        response.end
    else
%>
        <form name="frmCk" method="post" action="ShoppingBag.asp">
        <input type="hidden" name="chKdp" value="on">
        <input type="hidden" name="itemid" value="<%= itemid %>">
        <input type="hidden" name="itemoption" value="<%= itemoption %>">
        <input type="hidden" name="itemea" value="<%= itemea %>">
        <input type="hidden" name="requiredetail" value="<%= doubleQuote(requiredetail) %>">
        </form>
        <script language='javascript'>
        document.frmCk.submit();
        </script>
<%
        dbget.close() : response.end
    end if
else
%>
<script type="text/javascript">
try {
	parent.document.getElementById('ibgaCNT').innerHTML = '<%=vBagCnt%>';
} catch(e) {}

	<% if (ValidRet=2) then %>
		parent.fnsbagly('o');
	<% else %>
		parent.fnsbagly('x');
	<% end if %>

//if(confirm("선택한 상품이 장바구니에 담겼습니다.\n\n장바구니로 이동하시겠습니까?")) {
//	top.location.href="/inipay/ShoppingBag.asp";
//}
</script>
<%
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->