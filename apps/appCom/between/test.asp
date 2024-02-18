<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.Charset="UTF-8"

rw "- 토큰 : " & btwToken
rw "<hr>★ 내정보"
rw "- 아이디 : " & fnGetUserInfo("id")
rw "- 이름 : " & fnGetUserInfo("name")
rw "- 성별 : " & fnGetUserInfo("sex")
rw "- 생일 : " & fnGetUserInfo("birth")
rw "- 텐바이텐 userid : " & fnGetUserInfo("tenId")
rw "- 텐바이텐 회원등급 : " & fnGetUserInfo("tenLv")
rw "- 텐바이텐 userSn : " & fnGetUserInfo("tenSn")

rw "<hr>☆ 파트너"
rw "- 아이디 : " & fnGetPartnerInfo("id")
rw "- 이름 : " & fnGetPartnerInfo("name")
rw "- 성별 : " & fnGetPartnerInfo("sex")
rw "- 생일 : " & fnGetPartnerInfo("birth")

rw "<hr>♥ 기념일"
rw "- 첫만남 : " & fnGetAnniversary("first") & " [" & getTermAnniv(fnGetAnniversary("first")) & "일 남음]"
rw "- 결혼 : " & fnGetAnniversary("wedding") & " [" & getTermAnniv(fnGetAnniversary("wedding")) & "일 남음]"
rw getAnniversary("2011-02-29")
rw getTermAnniv("2011-05-13")
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->