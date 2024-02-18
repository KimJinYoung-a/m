<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	Description : 이용약관
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
    <!-- modal#modalTerms -->
    <div class="modal" id="modalTerms">
        <div class="box">
            <header class="modal-header">
                <h1 class="modal-title">텐바이텐 이용약관</h1>
                <a href="#modalTerms" class="btn-close">&times;</a>
            </header>
            <div class="modal-body">
                <div class="inner doc">
					<!-- #include virtual="/apps/appCom/wish/webview/member/usageCont.asp" -->
                </div>
            </div>
            <footer class="modal-footer">
                <a href="#modalTerms" class="btn type-a btn-hide-modal full-size">확인</a>
            </footer>
        </div>
    </div><!-- modal#modalTerms -->