<%
    '// 로그원 로그인 사용자 정보 전송
    Sub sendLogoneLoginUser(byval userseq)
        Dim SendBody, clientId, StrRemoteIP
        clientId = "10x10-asp-m"

        SendBody = ""
        SendBody = SendBody & " { "
        SendBody = SendBody & " 	""clientName"" : """ & clientId & ""","
        SendBody = SendBody & " 	""headers"" : { "
        SendBody = SendBody & " 		""user-agent"" : """&Request.ServerVariables("HTTP_USER_AGENT")&""","
        SendBody = SendBody & " 		""host"" : """&Request.ServerVariables("HTTP_HOST")&""""
        SendBody = SendBody & " 	}, "

        SendBody = SendBody & "      ""event_name"": ""login_success_server"","
        SendBody = SendBody & "      ""cookies"": {"
        SendBody = SendBody & "        ""uinfo"": """ & Request.Cookies("uinfo") & ""","
        SendBody = SendBody & "        ""mssn"": """ & Request.Cookies("mssn") & ""","
        SendBody = SendBody & "        ""etc"": """ & Request.Cookies("etc") & """"
        SendBody = SendBody & "      },"

        SendBody = SendBody & " 	""user"" : { "
        SendBody = SendBody & " 		""ip"" : """ & Request.ServerVariables("REMOTE_ADDR") & ""","
        SendBody = SendBody & " 		""userseq"": """ & userseq & """"
        SendBody = SendBody & "     }, "
        SendBody = SendBody & "     ""tmeta"" : { "
        SendBody = SendBody & "         ""service_name"" : ""tenbyten_service"""
        SendBody = SendBody & " 	} "
        SendBody = SendBody & " } "

        Call sendLogoneMessage(SendBody)
    End Sub

    '// 로그원 전송
    Sub sendLogoneMessage(byval SendBody)
        Const lngMaxFormBytes = 800
        Dim oJson

        set oJson = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")	'xmlHTTP컨퍼넌트 선언
        
        oJson.open "POST", "http://172.16.0.218/", False
        oJson.setRequestHeader "Content-Type", "application/json; charset=utf-8"
        oJson.setRequestHeader "key","lkzxljk-fqwo@i3J875qlkzLjdv"
        oJson.setRequestHeader "CharSet", "utf-8" '있어도 되고 없어도 되고
        oJson.setRequestHeader "Accept","application/json"
        oJson.setRequestHeader "api-key-v1","bd05f7a763aa2978aeea5e8f2a8a3242abc0cbffeb3c28e0b056cef4e282eee9"
        oJson.setRequestHeader "host_lo", "logoneapi.10x10.co.kr" 
        oJson.send SendBody

        Set oJson = Nothing
    End Sub
%>