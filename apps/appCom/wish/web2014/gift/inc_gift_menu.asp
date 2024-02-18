<%
'###########################################################
' Description :  기프트
' History : 2015.02.02 한용민 생성
'###########################################################

'# 현재 페이지명 접수
dim nowViewPage_hint
nowViewPage_hint = request.ServerVariables("SCRIPT_NAME")
%>
<ul class="commonTabV16a">
	<li <% if lcase(nowViewPage_hint)=lcase("/apps/appcom/wish/web2014/gift/gifttalk/index.asp") then response.write " class='current'" %> name="tab01" style="width:50%;" onClick="location.href='/apps/appcom/wish/web2014/gift/gifttalk/index.asp';">GIFT TALK</li>
	<li <% if lcase(nowViewPage_hint)=lcase("/apps/appcom/wish/web2014/gift/gifthint/index.asp") then response.write " class='current'" %> name="tab02" style="width:50%;" onClick="location.href='/apps/appcom/wish/web2014/gift/gifthint/index.asp';">GIFT HINT</li>
</ul>