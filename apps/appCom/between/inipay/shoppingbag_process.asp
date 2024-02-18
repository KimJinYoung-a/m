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
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/shoppingbagDBcls.asp" -->
<%

''계속쇼핑하기 경로 설정
''Call setPreShoppingLocation

'' 사이트 구분
Const sitename = "10x10"

dim i, tmparr
dim usersn, userid, guestSessionID
usersn = fnGetUserInfo("tenSn")
'userid = fnGetUserInfo("tenId")
'guestSessionID = GetGuestSessionKey()

dim mode            : mode		    = requestCheckVar(request.Form("mode"),10)
dim itemid          : itemid		= requestCheckVar(request.Form("itemid"),9)
dim itemoption      : itemoption    = requestCheckVar(request.Form("itemoption"),4)
dim itemea          : itemea  	    = requestCheckVar(request.Form("itemea"),9)
dim bagarr          : bagarr	    = request.Form("bagarr")
dim requiredetail   : requiredetail = html2db(request.Form("requiredetail"))
dim chk_item        : chk_item      = request("chk_item")
dim jumundiv        : jumundiv      = request("jumundiv")
dim ckdidx

if requestCheckVar(request("rdsite"),32)<>"" then
	if (session("rdsite")<>requestCheckVar(request("rdsite"),32)) then
		session("rdsite") = requestCheckVar(request("rdsite"),32)
		session("rddata") = requestCheckVar(request("rddate"),32)
	end if
end if

Dim tp : tp = requestCheckVar(request("tp"),10)   '' not post
Dim fc : fc = requestCheckVar(request.Form("fc"),10)

Dim ValidRet
Dim retBool, iErrMsg

if (itemid<>"") and (itemoption<>"") and (itemea<>"") and (mode="") then
    mode = "add"
end if


dim oShoppingBag
set oShoppingBag = new CShoppingBag
oShoppingBag.FRectUserSn    = "BTW_USN_" & usersn
oShoppingBag.FRectUserID    = userid
oshoppingbag.FRectSessionID = guestSessionID
oShoppingBag.FRectSiteName  = sitename

dim NotValidItemExists

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
                response.write "<script>if (confirm('이미 장바구니에 담긴 상품입니다.\n수량 변경은 장바구니에서 가능합니다.\n\n장바구니로 이동하시겠습니까?')){top.location.replace('/apps/appCom/between/inipay/ShoppingBag.asp');}</script>"
                dbget.close() : response.end
            end if
        else
            oshoppingbag.AddshoppingBagDB itemid,itemoption,itemea,requiredetail

	        '장바구니수 업데이트
	        Call SetBetweenCartCount(GetBetweenCartCount+1)
        end if
    end if

elseif (mode="edit") then
    if (itemid<>"") and (itemoption<>"") and (itemea<>"") then
		oshoppingbag.EditshoppingBagDB itemid,itemoption,itemea
	end if

elseif (mode="arr") then
    ''''관심품목에서 담을때는 1개로..
    ''''response.write "bagarr=" & bagarr
    NotValidItemExists = false
	bagarr = split(bagarr,";")

	for i=LBound(bagarr) to UBound(bagarr)
	    if Trim(bagarr(i))<>"" then
			tmparr = split(bagarr(i),",")
			if (tmparr(0)<>"") and (tmparr(1)<>"") and (tmparr(2)<>"") then
			    ValidRet = oshoppingbag.checkValidItem(tmparr(0),tmparr(1))

			    if (ValidRet=0) then
			        NotValidItemExists = true
			    elseif (ValidRet=2) then
                    ''동일한 상품이 이미 장바구니에 있을경우 : Confirm 후 담기(X) ? or 1개로 조정
                    oshoppingbag.EditshoppingBagDB tmparr(0),tmparr(1),1
                else
			        oshoppingbag.AddshoppingBagDB tmparr(0),tmparr(1),tmparr(2),""

			        '장바구니수 업데이트
			        Call SetBetweenCartCount(GetBetweenCartCount+1)
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

elseif (mode="DO1") then
    ''바로 주문.(선택 초기화 > 해당상품 체크 > 주문페이지로 이동)

    if (itemid<>"") and (itemoption<>"") and (itemea<>"") then
		'선택 초기화
		call oshoppingbag.OrderCheckOutDefault

    	'장바구니 담기
    	oshoppingbag.AddshoppingBagDB itemid,itemoption,itemea,requiredetail

        '장바구니수 업데이트
        Call SetBetweenCartCount(GetBetweenCartCount+1)
    end if

    if (oshoppingbag.CheckOutOneItem(itemid,itemoption,itemea)) then
        '주문으로 이동
        response.redirect M_SSLUrl & "/apps/appCom/between/inipay/UserInfo.asp"
    else
        response.write "<script>alert('죄송합니다. 유효하지 않은 상품이거나 품절된 상품입니다.');</script>"
        response.write "<script>history.back();</script>"

        dbget.close() : response.end
    end if
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
        if (jumundiv<>"") and (jumundiv<>"1") then
            response.redirect M_SSLUrl & "/apps/appCom/between/inipay/UserInfo.asp?jk=" + jumundiv
        else
            response.redirect M_SSLUrl & "/apps/appCom/between/inipay/UserInfo.asp"
        end if
    Else
        response.write "<script>alert('"&iErrMsg&"');</script>"
        response.write "<script>history.back();</script>"

        dbget.close() : response.end
    End if
elseif (mode="ALK") then
    ''전체주문
    retBool = oshoppingbag.CheckOutALLItem

    IF (retBool) then
        if (jumundiv<>"") and (jumundiv<>"1") then
            response.redirect M_SSLUrl & "/apps/appCom/between/inipay/UserInfo.asp?jk=" + jumundiv
        else
            response.redirect M_SSLUrl & "/apps/appCom/between/inipay/UserInfo.asp"
        end if
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

%>

<%
''상품이 이미 존재하는경우 ShoppingBag.asp에서 pop  and (ValidRet<>2)
if (tp<>"pop") then
    if (ValidRet<>2) then
        dbget.close()
        response.redirect "ShoppingBag.asp"
        response.end
    else
%>
        <form name="frmCk" method="post" action="/apps/appCom/between/inipay/ShoppingBag.asp">
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
<script type="text/javascript" src="/apps/appCom/between/lib/js/jquery-1.7.1.min.js"></script>
<script language="javascript">
if(confirm("선택한 상품이 장바구니에 담겼습니다.\n\n장바구니로 이동하시겠습니까?")) {
	top.location.href="/apps/appCom/between/inipay/ShoppingBag.asp";
} else {
	$("#lyrCartCnt", parent.document).show().html('<%=GetBetweenCartCount%>');
}
</script>
<%
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->