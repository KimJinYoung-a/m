<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>

<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/header.asp" -->

<%

' -------------------------------------
' 회원의 주소를 찾는 Popup Window 화면
' -------------------------------------
Dim strTarget
Dim strQuery
Dim strMode

strTarget	= requestCheckVar(Request("target"),32)
strQuery	= requestCheckVar(Request("query"),32)
strMode     = requestCheckVar(Request("strMode"),32)


Dim strSql
Dim nRowCount

Dim strAddress1
Dim strAddress2

dim useraddr01, useraddr02
dim FRecultCount

	strSql = "SELECT top 1000 ADDR_ZIP1, ADDR_ZIP2, ADDR_SI,ADDR_GU,ADDR_DONG,ADDR_ETC,ADDR_Fulltext FROM [db_zipcode].dbo.ADDR080TL WHERE ADDR_Fulltext like '%" & strQuery & "%' and Addr_sortNo<>'999' "

    if (strQuery<>"") then
        rsget.Open strSQL,dbget,1
        FRecultCount = rsget.RecordCount
        
    end if
    
    
%>
<style type="text/css">
<!--
#code_result {height:137px;overflow: auto;}
-->
</style>
<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
<script type="application/x-javascript" src="/lib/js/iui_clickEffect.js"></script>
<script type="text/javascript" src="/lib/js/nicescroll/jquery.nicescroll.min.js"></script>
<SCRIPT language="JavaScript">
$(document).ready(function() {
	$("#code_result").niceScroll({cursoropacitymin:.25});
});
	
function CopyZip(t,post1,post2,add,dong)
{
	var frm = eval("parent." + t);
	// copy
	<%
		Select Case strMode
			Case "MyAddress"
	%>
		frm.zip1.value			= post1;
		frm.zip2.value			= post2;
		frm.reqZipaddr.value	= add;
		frm.reqAddress.value	= dong;
	<%		Case "buyer" %>
		frm.buyZip1.value		= post1;
		frm.buyZip2.value		= post2;
		frm.buyAddr1.value		= add;
		frm.buyAddr2.value		= dong;
	<%		Case Else %>
		frm.txZip1.value		= post1;
		frm.txZip2.value		= post2;
		frm.txAddr1.value		= add;
		frm.txAddr2.value		= dong;
	<%	End Select %>

	// focus
	parent.focus();
	
	<% If strMode = "buyer" Then %>
	$("#boxscroll3", parent.document).css("height","0px");
	$("#boxscroll3", parent.document).css("display","none");
	<% Else %>
	$("#boxscroll4", parent.document).css("height","0px");
	$("#boxscroll4", parent.document).css("display","none");
	<% End If %>
}
function SubmitForm(frm)
{
        if (frm.query.value.length < 2) { alert("동 이름을 두글자 이상 입력하세요."); return; }
        frm.submit();
}

</SCRIPT>

<div style="padding:5px 0 0 0;"></div>
<div id="postcode_layer" selected="true" style="height:250px;background-color:#f9f9f9;">
<form action="/gift/lib/searchzip.asp" method="get" name="gil" onsubmit="SubmitForm(document.gil); return false;">
<input type=hidden name="target"	value="<%=strTarget%>">
<input type=hidden name="strMode"	value="<%=strMode%>">
<div style="padding:5px 0 0 5px;">
	<h3>우편번호 찾기</h3>
		<!--우편번호검색-->
		<div>
			<p>
			<div style="padding:5px 0 0 0;"></div>
			<span style="font-size:12px; color:#777; text-align:left;">검색 후 해당 주소를 클릭하시면 자동 입력됩니다.</span></br>
			<div style="padding:15px 0 0 0;"></div>
			<center>
				<strong style="font-size:12px; color:#c91314;">찾고자 하는 동/읍/면 이름을 입력하세요.</strong></br>
				<div style="padding:3px 0 0 0;"></div>
				<label><span style="font-size:12px; color:#777; text-align:center;">지역명</span>
				<input name="query" type="text" class="postinput" style="width:160px; height:20px;" />
				</label>
				<img src="http://fiximage.10x10.co.kr/m/2012/common/btn_postsearch.png" width="49" height="30" class="tm-4" onclick="SubmitForm(document.gil);" style="cursor:pointer" /></p>
				<div style="padding:5px 0 0 0;"></div>
			</center>
		</div>
		<!--우편번호 검색결과-->
		<% if (FRecultCount>0) then %>
			<div id="code_result" style="padding-right:5px;">
				<table cellspacing="0" cellpadding="0" border="0" class="code_list">
		          <% if (not rsget.eof) then 
		            do while (not rsget.EOF and nRowCount < rsget.PageSize)
		
		    		strAddress1 = trim(rsget("ADDR_SI")) & " " & trim( rsget("ADDR_GU")) & " " & trim( rsget("ADDR_DONG"))
		    		strAddress2 = trim(rsget("ADDR_Fulltext"))
		    
		    		useraddr01 = trim(rsget("ADDR_SI")) & " " & trim( rsget("ADDR_GU"))
		    		useraddr02 = trim( rsget("ADDR_DONG")) & " " & trim( rsget("ADDR_ETC"))
		            %>
					<tr onclick="CopyZip('<%= strTarget %>','<%=rsget("ADDR_ZIP1")%>','<%=rsget("ADDR_ZIP2")%>','<% = useraddr01 %>', '<% = useraddr02 %>')" style="cursor:pointer">
						<td class="code_num" width="20%" style="font-size:12px; color:#777;"><%=rsget("ADDR_zip1")%>-<%=rsget("ADDR_zip2")%></td>
						<td width="80%" style="font-size:12px; color:#777;"><%=strAddress2%></td>
					</tr>
		        <%
		              rsget.MoveNext
		    		loop
		    	    end if
		            rsget.close
		        %>
				</table>
			</div>
		 <% else %>
		 	<div id="code_result" style="font-size:12px; color:#777;padding:40px 0; text-align:center;"><% if (strQuery="") then %>지역명을 입력해 주세요.<% else %>검색 결과가 없습니다.<% end if %></div>
		 <% end if %>
</div>
</form>
</div>

<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->