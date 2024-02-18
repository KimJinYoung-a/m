<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appCom/wish/webview/login/checkLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/emscls.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
Dim areaCode : areaCode = requestCheckVar(request("areaCode"),2)
Dim oems : SET oems = New CEms
Dim fiximgPath

if (areaCode<>"") then
    oems.FRectCurrPage = 1
    oems.FRectPageSize = 100
    oems.FRectEmsAreaCode  = areaCode
    oems.GetWeightPriceList
end if

'이미지 경로 지정(SSL 처리)
if request.ServerVariables("SERVER_PORT_SECURE")<>1 then
	fiximgPath = "http://fiximage.10x10.co.kr"
else
	fiximgPath = "/fiximage"
end if

dim i
%>
    <!-- modal#modalEMSChart -->
    <div class="modal" id="modalEMSChart">
        <div class="box">
            <header class="modal-header">
                <h1 class="modal-title">EMS 지역 요금 보기 </h1>
                <a href="#modalEMSChart" class="btn-close">&times;</a>
            </header>
            <div class="modal-body">
                <div class="iscroll-area">
	                <h2 class="inner">제 3 지역 중량별 요금</h2>
	                <table class="listed">
	                    <colgroup>
	                        <col width="50%"/>
	                        <col width="50%"/>
	                    </colgroup>
	                    <thead>
	                        <tr>
	                            <th>중량 (Kg)</th>
	                            <th>EMS 요금 (원)</th>
	                        </tr>
	                    </thead>
	                    <tbody>
	                    <% for i=0 to oems.FResultCount-1 %>
	                        <tr>
	                            <td><%= CLng(oems.FItemList(i).FWeightLimit/1000*10)/10 %></td>
	                            <td><%= FormatNumber(oems.FItemList(i).FemsPrice,0) %></td>
	                        </tr>
						<% next %>
	                    </tbody>
	                </table>
				</div>
            </div>
            <footer class="modal-footer">
                <a href="#modalEMSChart" class="btn type-a btn-close full-size">확인</a>
            </footer>
        </div>
    </div><!-- modal#modalEMSChart -->
<%
SET oems = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->