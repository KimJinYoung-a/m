<%
	'// 수작업 하단 컨텐츠 영역
	If ecode = "83586" Then '// 특정 이벤트 코드 일경우에만 노출 되도록 합니다. 이벤트 코드를 넣어주세요
	'// If ecode = "이벤트코드" or ecode = "이벤트코드" Then '// 복수의 이벤트경우 요 코드로

	Dim ftegCode : ftegCode = requestCheckVar(Request("eGC"),10) '이벤트 그룹코드

	'// ON / OFF 기능용 그룹코드를 넣어주세요
	Function fnFootTabOnOff(eGc)
		If eGc = "" Then EXiT Function
		If ftegCode = eGc Then fnFootTabOnOff = "on"
	End Function
%>
	<script>
	<%'링크 URL 변환용 %>
	function jsMobAppUrlChange(e,g,m){
		var ecode = e;
		var gcode = g;
		var mcode=m;
		<% if isapp = "1" then %>
				<% if instr(Request.ServerVariables("url"),"/gnbeventmain.asp") > 0 then '// gnb %>
				jsGNBEventlink(ecode,gcode);
			<% else %>
				location.href = '/apps/appcom/wish/web2014/event/eventmain.asp?eventid='+ecode+'&eGc='+gcode+"&mid="+mcode;
			<% end if %>
		<% else %>
			<% if instr(Request.ServerVariables("url"),"/gnbeventmain.asp") > 0 then '// gnb %>
				jsGNBEventlink(ecode,gcode);
			<% else %>
				location.href = '/event/eventmain.asp?eventid='+ecode+'&eGc='+gcode+"&mid="+mcode;
			<% end if %>
		<% end if %>
		return false;
	}

	$(function(){
		<% if ftegCode = "" then %>
		if ($(".sweet-gift2 > ul > li").eq(0).hasClass("on") == false){
			$(".sweet-gift2 > ul > li").eq(0).addClass("on");
		}
		<% end if %>
	});
	</script>


	<%'!-- 최하단 nav --%>
	<div class="sweet-gift sweet-gift2">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/tit_bottom_nav.gif" alt="sweet gift" /></h3>
		<ul>
			<%'!-- 해당 탭에 on --%>
			<li class="<%=fnFootTabOnOff("232018")%>"><a href="" onclick="jsMobAppUrlChange('83586','232018','1');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_1.png" alt="DIY" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_1_on.png" alt="선택" /></span></a></li>
			<li class="<%=fnFootTabOnOff("232019")%>"><a href="" onclick="jsMobAppUrlChange('83586','232019','2');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_2.png" alt="초콜렛" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_2_on.png" alt="선택" /></span></a></li>
			<li class="<%=fnFootTabOnOff("232020")%>"><a href="" onclick="jsMobAppUrlChange('83586','232020','3');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_3.png" alt="스낵류" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_3_on.png" alt="선택" /></span></a></li>
			<li class="<%=fnFootTabOnOff("232021")%>"><a href="" onclick="jsMobAppUrlChange('83586','232021','4');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_4.png" alt="클래스" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_4_on.png" alt="선택" /></span></a></li>
		</ul>
	</div>
<%
	End If
%>