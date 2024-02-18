<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 57102 - 시리즈
' History : 2014-12-01 이종화 생성
'####################################################

Dim oEventid : oEventid = Trim(request("eventid"))

%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.selectDate {width:100%; height:35px; color:#fff; font-weight:bold; border:0; border-radius:0; margin-bottom:5px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/bg_select.gif) 97% 50% no-repeat #4c4c4c; background-size:21px 21px;}
@media all and (min-width:480px){
	/*.selectDate {height:53px; margin-bottom:8px; background-size:32px 32px;}*/
}
</style>
<script>
	function chgBA(v){
		var chkapp = navigator.userAgent.match('tenapp');
		if ( chkapp ){
			parent.location.href="/apps/appcom/wish/web2014/event/eventmain.asp?eventid="+v;	//앱영역 스크립트
		}else{
			parent.location.href="/event/eventmain.asp?eventid="+v;	//모바일영역 스크립트
		}
	}
</script>
</head>
<body>
	<select class="selectDate" onchange="chgBA(this.value);">
		<% If Now() > #12/29/2014 00:00:00# Then %><option value="58092" <% if oEventid = "58092" then response.write "selected" end if%>>12.29 / MACCHIATTO</option><% End If %>
		<% If Now() > #12/26/2014 00:00:00# Then %><option value="57208" <% if oEventid = "57208" then response.write "selected" end if%>>12.26 / WALKER BOOKS</option><% End If %>
		<% If Now() > #12/24/2014 00:00:00# Then %><option value="57206" <% if oEventid = "57206" then response.write "selected" end if%>>12.24 / SNURK</option><% End If %>
		<% If Now() > #12/23/2014 00:00:00# Then %><option value="57204" <% if oEventid = "57204" then response.write "selected" end if%>>12.23 / RIFLE PAPER CO.</option><% End If %>
		<% If Now() > #12/22/2014 00:00:00# Then %><option value="57218" <% if oEventid = "57218" then response.write "selected" end if%>>12.22 / DECOVIEW</option><% End If %>
		<% If Now() > #12/19/2014 00:00:00# Then %><option value="57215" <% if oEventid = "57215" then response.write "selected" end if%>>12.19 / MOTHER PIANO</option><% End If %>
		<% If Now() > #12/18/2014 00:00:00# Then %><option value="57223" <% if oEventid = "57223" then response.write "selected" end if%>>12.18 / DEMETER</option><% End If %>
		<% If Now() > #12/17/2014 00:00:00# Then %><option value="57212" <% if oEventid = "57212" then response.write "selected" end if%>>12.17 / INSTAX</option><% End If %>
		<% If Now() > #12/16/2014 00:00:00# Then %><option value="57220" <% if oEventid = "57220" then response.write "selected" end if%>>12.16 / A.MONO</option><% End If %>
		<% If Now() > #12/15/2014 00:00:00# Then %><option value="57236" <% if oEventid = "57236" then response.write "selected" end if%>>12.15 / INVITE.L</option><% End If %>
		<% If Now() > #12/12/2014 00:00:00# Then %><option value="57216" <% if oEventid = "57216" then response.write "selected" end if%>>12.12 / KAMOME KITCHEN</option><% End If %>
		<% If Now() > #12/11/2014 00:00:00# Then %><option value="57219" <% if oEventid = "57219" then response.write "selected" end if%>>12.11 / BLOOIMG &amp; ME</option><% End If %>
		<% If Now() > #12/10/2014 00:00:00# Then %><option value="57238" <% if oEventid = "57238" then response.write "selected" end if%>>12.10 / ITHINKSO</option><% End If %>
		<% If Now() > #12/09/2014 00:00:00# Then %><option value="57224" <% if oEventid = "57224" then response.write "selected" end if%>>12.09/ PLAYMOBIL</option><% End If %>
		<% If Now() > #12/08/2014 00:00:00# Then %><option value="57235" <% if oEventid = "57235" then response.write "selected" end if%>>12.08 / MONOPOLY</option><% End If %>
		<% If Now() > #12/05/2014 00:00:00# Then %><option value="57213" <% if oEventid = "57213" then response.write "selected" end if%>>12.05 / BUY BEAM</option><% End If %>
		<% If Now() > #12/04/2014 00:00:00# Then %><option value="57222" <% if oEventid = "57222" then response.write "selected" end if%>>12.04 / MARTHA IN THE GARRET</option><% End If %>
		<% If Now() > #12/03/2014 00:00:00# Then %><option value="57211" <% if oEventid = "57211" then response.write "selected" end if%>>12.03 / IFACE</option><% End If %>
		<% If Now() > #12/02/2014 00:00:00# Then %><option value="57185" <% if oEventid = "57185" then response.write "selected" end if%>>12.02 / THE LEATHER SATCHEL</option><% End If %>
		<% If Now() > #12/01/2014 00:00:00# Then %><option value="57102" <% if oEventid = "57102" then response.write "selected" end if%>>12.01 / ICONIC</option><% End If %>
	</select>
</body>
</html>