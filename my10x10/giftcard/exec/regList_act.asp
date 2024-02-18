<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.Buffer = True
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<%    
dim currentPage, pagesize, i
dim userid: userid = getEncLoginUserID ''GetLoginUserID

currentPage = requestCheckVar(getNumeric(request("cpg")),4)

if currentPage="" then currentPage=1
if pagesize="" then pagesize="20"
    
dim oGiftcard
set oGiftcard = new myGiftCard
    oGiftcard.FRectUserid = userid
    oGiftcard.FPageSize = pagesize
    oGiftcard.FCurrPage = currentPage
    oGiftcard.myGiftCardRegList
%>
    <%
    dim tempTime
    if oGiftcard.FResultCount>0 then
        For i=0 to (oGiftcard.FResultCount-1)
        tempTime = right(oGiftcard.FItemList(i).FbuyDate, inStr(oGiftcard.FItemList(i).FbuyDate, " 오"))  		            
    %>							
                <li>
                    <span class="date">
                        <span class="day"><%=formatDate(oGiftcard.FItemList(i).FbuyDate,"0000.00.00")%></span>
                        <span class="time"><%=tempTime%></span>
                    </span>
                    <span class="desc">
                        <em>인증번호 <%=oGiftcard.FItemList(i).FmasterCardCode%></em>
                        <span class="price color-red">사용 만료일 <%=formatDate(oGiftcard.FItemList(i).FcardExpire,"0000.00.00")%></span>
                    </span>
                </li>
    <% 
        next 
    elseif currentPage = 1 and oGiftcard.FResultCount <= 0 then
    %>
    <li class="no-data">
        <span class="no-data">기프트 카드 사용 내역이 없습니다.</span>
    </li>  
    <%
    end if
    %>

<!-- #include virtual="/lib/db/dbclose.asp" -->