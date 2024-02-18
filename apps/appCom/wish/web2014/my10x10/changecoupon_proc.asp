<%@ codepage="65001" language="VBScript" %>
<% option explicit %>
<% Response.CharSet = "UTF-8" %>
<%
Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<%
dim uid, refip, ref

''쿠폰번호 한장으로 계속 발행할때(인증키 하나: UF37-XXXX)
function IsOneNumCoupon(icouponNo)
    IsOneNumCoupon = false
    if IsNULL(icouponNo) then Exit function

    if (Left(icouponNo,4)="UF37") then
        IsOneNumCoupon = true
    end if
end Function

uid = getEncLoginUserID
refip = request.ServerVariables("REMOTE_ADDR")
ref = lCase(request.ServerVariables("HTTP_REFERER"))

if InStr(ref,"10x10.co.kr/apps/appcom/wish/web2014/my10x10/changecoupon.asp")>0 then

else
	response.write "<script>alert('올바른 접속이 아닙니다.');</script>"
	response.write "<script>history.back();</script>"
	response.end
end if

if uid="" then
	response.write "<script>alert('로그인후 사용하세요.');</script>"
	response.write "<script>history.back();</script>"
	response.end
end if

dim cardno
cardno = request.Form("cardno1") & "-" & request.Form("cardno2") & "-" & request.Form("cardno3") & "-" & request.Form("cardno4")
cardno = requestCheckVar(UCase(cardno),20)

dim sqlstr, idx, masteridx, pcardno, expiredate, scrachdate, validsitename
dim usercouponproc
set usercouponproc = new CCoupon
	usercouponproc.FGubun = "1"
	usercouponproc.FCardNO = cardno
	usercouponproc.FMasterIDX = ""
	usercouponproc.FRectUserID = ""
	usercouponproc.FIDX = ""
	usercouponproc.FRefIP = ""
	usercouponproc.UserCouponProc

idx = 0

if usercouponproc.FOneItem.Fidx <> "" then
	idx = usercouponproc.FOneItem.Fidx
	masteridx = usercouponproc.FOneItem.Fmasteridx
	pcardno = usercouponproc.FOneItem.Fpcardno
	expiredate = usercouponproc.FOneItem.Fexpiredate
	scrachdate = usercouponproc.FOneItem.Fscrachdate
	validsitename = usercouponproc.FOneItem.Fvalidsitename
end if

if idx=0 then
	response.write "<script>alert('상품권 번호가 올바르지 않습니다.');</script>"
	response.write "<script>history.back();</script>"
	response.end
end if

if not IsNULL(scrachdate) then
	response.write "<script>alert('이미 사용한 상품권 입니다.');</script>"
	response.write "<script>history.back();</script>"
	response.end
end if

if (now()>expiredate) then
	response.write "<script>alert('유효기간이 만료된 상품권입니다.');</script>"
	response.write "<script>history.back();</script>"
	response.end
end if

if (validsitename<>"") then
    if (validsitename="academy") then
        response.write "<script>alert('핑거스 아카데미에서 사용및 발급 가능한 상품권입니다. 해당 사이트에서 발급해주세요.');</script>"
	    response.write "<script>history.back();</script>"
	    response.end
	else
	    response.write "<script>alert('" & validsitename & " 에서 사용 가능한 상품권입니다.');</script>"
	    'response.write "<script>history.back();</script>"
	    'response.end
    end if

end if

dim aleadyCouponOk
''####### 이미 상품권을 받았는지 체크. ###########

usercouponproc.FGubun = "2"
usercouponproc.FCardNO = ""
usercouponproc.FMasterIDX = CStr(masteridx)
usercouponproc.FRectUserID = uid
usercouponproc.FIDX = ""
usercouponproc.FRefIP = ""
usercouponproc.UserCouponProc

aleadyCouponOk = false

if usercouponproc.FOneItem.Fidx <> "" then
	aleadyCouponOk = true
end if

if aleadyCouponOk and masteridx<>"427" then
	response.write "<script>alert('이미 텐바이텐 상품권을 발급 받으셨습니다.\r\n본 상품권 사용은 1인 1회에 한에 사용 가능합니다.');</script>"
	response.write "<script>history.back();</script>"
	response.end
end if

usercouponproc.FGubun = "3"
usercouponproc.FCardNO = ""
usercouponproc.FMasterIDX = CStr(masteridx)
usercouponproc.FRectUserID = uid
usercouponproc.FIDX = CStr(idx)
usercouponproc.FRefIP = ""
usercouponproc.UserCouponProc

if usercouponproc.FOneItem.Fidx = "0" then
    response.write "<script>alert('상품권 발행에 오류가 발생하였습니다.(-1)');</script>"
	response.write "<script>history.back();</script>"
	response.end
end if

''쿠폰번호 하나로 계속 사용하는 경우가 아니면 scrachdate를 넣음.
if (Not IsOneNumCoupon(cardno)) then
	usercouponproc.FGubun = "4"
	usercouponproc.FCardNO = ""
	usercouponproc.FMasterIDX = ""
	usercouponproc.FRectUserID = uid
	usercouponproc.FIDX = CStr(idx)
	usercouponproc.FRefIP = refip
	usercouponproc.UserCouponProc
end if
%>
<script language='javascript'>
	alert('쿠폰이 발급되었습니다. 주문시 사용가능합니다.');
	location.replace('/apps/appcom/wish/web2014/my10x10/couponbook.asp');
</script>

<!-- #include virtual="/lib/db/dbclose.asp" -->