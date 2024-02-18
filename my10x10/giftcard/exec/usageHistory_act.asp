<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  기프트카드 사용내역
' History : 2019-06-21 최종원 생성
'####################################################
Response.Buffer = True
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%    
    if not IsUserLoginOK() then
        if isapp = 1 then             
            dim strTemp
            strTemp = 	"<script>" & vbCrLf &_
                    "alert('로그인을 하셔야 접근하실수 있는 페이지입니다.');" & vbCrLf &_
                    "calllogin();" & vbCrLf &_
                    "</script>"
            Response.Write strTemp                        
        else
            Call Alert_Return("로그인을 하셔야 접근하실수 있는 페이지입니다.")
            response.End
        end if
    end if

dim oGiftcard, currentCash : currentCash = 0
dim userid: userid = getEncLoginUserID ''GetLoginUserID
Dim vCurrPage, page 

vCurrPage = RequestCheckVar(Request("cpg"),5)

If vCurrPage = "" Then vCurrPage = 1

dim lp, jumpScroll, vIsOnOff, pagesize


vIsOnOff = requestCheckVar(request("isonoff"),1)
if vIsOnOff="" then vIsOnOff="T"
if pagesize="" then pagesize="20"

'// 기프트카드 잔액 확인	
set oGiftcard = new myGiftCard
    oGiftcard.FRectUserid = userid
    currentCash = oGiftcard.myGiftCardCurrentCash
set oGiftcard = Nothing

dim oGiftLog
set oGiftLog = new myGiftCard
    oGiftLog.FRectUserid = userid
    oGiftLog.FPageSize = pagesize
    oGiftLog.FCurrPage = vCurrPage
    oGiftLog.FRectSiteDiv = vIsOnOff
    oGiftLog.myGiftCardLogList

dim tempDate, tempTime

if oGiftLog.FResultCount>0 then
    For lp=0 to (oGiftLog.FResultCount-1)                    

    tempDate = FormatDate(oGiftLog.FItemList(lp).Fregdate, "0000.00.00") 
    tempTime = right(oGiftLog.FItemList(lp).Fregdate, inStr(oGiftLog.FItemList(lp).Fregdate, " 오"))  		    
%>
    <li>
        <span class="date">
            <span class="day"><%=tempDate%></span>
            <span class="time"><%=tempTime%></span>
        </span>
        <span class="desc">
            <em><%=oGiftLog.FItemList(lp).Fjukyo%></em>
            <span class="price color-<%=chkIIF(oGiftLog.FItemList(lp).FuseCash>0,"blue","red")%>"><%=CHKIIF(oGiftLog.FItemList(lp).FuseCash>0,"+","")%><%=formatNumber(oGiftLog.FItemList(lp).FuseCash,0)%>원</span>
        </span>
    </li>         
<%
    next
elseif vCurrPage = 1 and oGiftLog.FResultCount <= 0 then
%>
    <li class="no-data">
        <span class="no-data">기프트 카드 사용 내역이 없습니다.</span>
    </li>    
<%                
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->