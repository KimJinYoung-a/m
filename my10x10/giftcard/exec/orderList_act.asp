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
<!-- #include virtual="/lib/classes/giftcard/giftcard_ordercls.asp" -->
<%    
Dim myorder, currentPage, i, pagesize, userid
userid = getEncLoginUserID()
currentPage = requestCheckvar(request("cpg"),9)
if pagesize="" then pagesize="15"
if (currentPage="") then currentPage = 1

set myorder = new cGiftcardOrder
myorder.FPageSize = pagesize
myorder.FCurrpage = currentPage
myorder.FUserID = userid
myorder.getGiftcardOrderList
%>
    <%
    If myorder.FResultCount > 0 Then
        For i = 0 To (myorder.FResultCount - 1) 
    %>    
        <li>
            <a href="javascript:linkToDetail('<%=myorder.FItemList(i).Fgiftorderserial%>')">
                <div class="odrInfo">
                    <p><%=formatDate(myorder.FItemList(i).Fregdate,"0000.00.00")%></p>
                    <p>주문번호(<%=myorder.FItemList(i).Fgiftorderserial%>)</p>
                </div>
                <div class="odrCont">
                    <p class="type<%=CHKIIF(myorder.FItemList(i).Fjumundiv="5"," cBl1","")%>">
                        <%
                            If (myorder.FItemList(i).FCancelyn<>"N") Then
                                Response.Write "[취소주문]"
                            Else
                                Response.Write "["&myorder.FItemList(i).GetJumunDivName&"]"
                            End If
                        %>
                    </p>
                    <p class="item"><%=myorder.FItemList(i).FCarditemname%>&nbsp;<%=myorder.FItemList(i).FcardOptionName%></p>
                    <p class="price"><strong><%=FormatNumber(myorder.FItemList(i).Fsubtotalprice,0)%></strong>원</p>
                </div>
            </a>
            <div class="btnCancel">
                <%
                    If (myorder.FItemList(i).FCancelyn="N") Then
                        If (myorder.FItemList(i).IsWebOrderCancelEnable) Then
                            if isapp then
                                Response.Write "<span class=""button btS1 btnRed1V16a cRd1V16a""><a href=""/apps/appCom/wish/web2014/my10x10/giftcard/giftCardCancel.asp?giftorderserial=" & myorder.FItemList(i).Fgiftorderserial & """ >주문취소</a></span>"
                            else 
                                Response.Write "<span class=""button btS1 btnRed1V16a cRd1V16a""><a href=""/my10x10/giftcard/giftCardCancel.asp?giftorderserial=" & myorder.FItemList(i).Fgiftorderserial & """ >주문취소</a></span>"
                            end if
                        End If
                    End If
                %>                            
            </div>
        </li>
    <% 
        next 
    elseif currentPage = 1 and myorder.FResultCount <= 0 then
    %>
    <div class="nodata-list online">
        <span class="icon icon-no-data"></span>
        <p>주문내역이 없습니다.</p>
    </div>                    
    <%
    end if
    %>

<!-- #include virtual="/lib/db/dbclose.asp" -->