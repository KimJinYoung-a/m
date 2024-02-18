<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	'currentdate = date()
	currentdate = "2020-04-21"

	'response.write currentdate
%>
<!-- #include virtual="/lib/inc/head.asp" -->

<!-- 104829 -->
<div class="mEvt104829">
    <% if currentdate < "2020-08-07" then %>
    <div><img src="//webimage.10x10.co.kr/eventIMG/2020/104829/m_txt2.png" alt="D-2"></div>
    
    <% elseif currentdate < "2020-08-08" then %>
    <div><img src="//webimage.10x10.co.kr/eventIMG/2020/104829/m_txt1.png" alt="D-1"></div>
    
    <% else %>
    <div><img src="//webimage.10x10.co.kr/eventIMG/2020/104829/m_txt0.png" alt="D-day"></div>
    <% end if %>
</div>
<!--// 104829 -->