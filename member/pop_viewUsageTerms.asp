<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 이용약관
' History : 2014.09.03 한용민 생성
'         : 2014.09.30 허진원 - Modal형태로 변경
'         : 2015.06.05 허진원 - 약관 개정
'####################################################
%>
<div class="layerPopup">
	<div class="popWin">
		<div class="header">
			<h1>이용약관</h1>
			<p class="btnPopClose"><button type="button" class="pButton" onclick="fnCloseModal();">닫기</button></p>
		</div>
		<div class="content" id="layerScroll">
			<div id="scrollarea">
				<div class="inner5">
					<!-- #include virtual="/common/usage_external.asp" -->
				</div>
			</div>
			<!-- //content area -->
		</div>
	</div>
</div>
