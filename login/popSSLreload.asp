<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>

<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/util/commlib.asp" -->

<%
dim isOpen, strPath,blnclose
isOpen  = request("isOpen")
strPath = request("strPath")
blnclose = request("blnclose")

%>
<script type="text/javascript">
<!--
function jsReload(isOpen, strPath,blnclose){
	if (isOpen == "on"){
		if(blnclose=="Y"){		
			try {
				opener.top.location.replace(strPath);
			} catch (e) { 
				window.location.replace(strPath);
			}
		    self.close();	//2008.04.11 정윤정 추가
		}else{
			try {
				window.opener.location.href=strPath;
			} catch (e) { 
				window.location.replace(strPath);
			}
			self.close();
		}
	}
//	location.href=strPath;

}

jsReload('<%= isOpen %>','<%= strPath %>','<%= blnclose %>');	
//-->
</script>	

