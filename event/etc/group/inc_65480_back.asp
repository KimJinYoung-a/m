<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 65480 - 시리즈
' History : 2015-08-17 이종화 생성
'####################################################

Dim oEventid : oEventid = requestCheckVar(Request("eventid"),10)
Dim tmpno '//이벤트 별 배너 코드
Dim preEcode , nextEcode
Dim evturl

If isapp = "1" Then
	evturl = "/apps/appcom/wish/web2014/event/eventmain.asp?eventid="
Else
	evturl = "/event/eventmain.asp?eventid="
End If 

If oEventid = "65470" Then
	tmpno = "01"
	preEcode = evturl & "65469"  '//이전이벤트
	nextEcode = evturl & "65471"   '//다음이벤트
ElseIf oEventid = "65471" Then
	tmpno = "02"
	preEcode = evturl & "65470"  '//이전이벤트
	nextEcode = evturl & "65482"   '//다음이벤트
ElseIf oEventid = "65482" Then
	tmpno = "03"
	preEcode = evturl & "65471"  '//이전이벤트
	nextEcode = evturl & "65478"   '//다음이벤트
ElseIf oEventid = "65478" Then
	tmpno = "04"
	preEcode = evturl & "65482"  '//이전이벤트
	nextEcode = evturl & "65484"   '//다음이벤트
ElseIf oEventid = "65484" Then
	tmpno = "05"
	preEcode = evturl & "65478"  '//이전이벤트
	nextEcode = evturl & "65496"   '//다음이벤트
ElseIf oEventid = "65496" Then
	tmpno = "06"
	preEcode = evturl & "65484"  '//이전이벤트
	nextEcode = evturl & "65498"   '//다음이벤트
ElseIf oEventid = "65498" Then
	tmpno = "07"
	preEcode = evturl & "65496"  '//이전이벤트
	nextEcode = evturl & "65481"   '//다음이벤트
ElseIf oEventid = "65481" Then
	tmpno = "08"
	preEcode = evturl & "65498"  '//이전이벤트
	nextEcode = evturl & "65476"   '//다음이벤트
ElseIf oEventid = "65476" Then
	tmpno = "09"
	preEcode = evturl & "65481"  '//이전이벤트
	nextEcode = evturl & "65480"   '//다음이벤트
ElseIf oEventid = "65480" Then
	tmpno = "10"
	preEcode = evturl & "65476"  '//이전이벤트
	nextEcode = evturl & "65684"   '//다음이벤트
ElseIf oEventid = "65684" Then
	tmpno = "11"
	preEcode = evturl & "65480"  '//이전이벤트
	nextEcode = "javascript:alert('다음 브랜드가 추가 예정입니다.');"   '//다음이벤트
End If 

'// 아래 부분 위에 늘어 날때마다 추가 해주세요
'ElseIf oEventid = "이벤트코드" Then
'	tmpno = "브랜드다음숫자"
'	preEcode = evturl & "65470"  '//이전이벤트
'	nextEcode = "javascript:alert('다음 브랜드가 추가 예정입니다.');"   '//다음이벤트

%>
<script>
	function chgBA(v){
		var chkapp = navigator.userAgent.match('tenapp');
		if ( chkapp ){
			parent.location.href="/apps/appcom/wish/web2014/event/eventmain.asp?eventid="+v;	//앱영역 스크립트
		}else{
			parent.location.href="/event/eventmain.asp?eventid="+v;	//모바일영역 스크립트
		}
	}

	$(function(){
		var tmpnum 
		tmpnum = $('select').find('option').length-1; //나만 알고 싶은 브랜드 빼고 나머지 카운트
		$(".numbering .total img").attr("src","http://webimage.10x10.co.kr/eventIMG/2015/65469/txt_num_total"+tmpnum+".png");
	});
</script>
<style>
.selectBrand {padding:9px 10px; background:#f2f2f2;}
.selectBrand select {width:100%; border-radius:0; border:1px solid #d1d1d1; color:#000; font-weight:bold; background:#fff url(http://webimage.10x10.co.kr/eventIMG/2015/65469/blt_arrow.gif) no-repeat 97% 50%; background-size:22px 22px;}
.myOwnBrand {position:relative;}
.navigator span {display:block; position:absolute; top:45%; width:12.7%;}
.navigator .prevBrand {left:0;}
.navigator .nextBrand {right:0;}
.numbering {position:absolute; right:4%; bottom:2%; width:92%; text-align:right;}
.numbering span {display:inline-block; width:4.1%;}
.numbering span.total {width:8.2%;}
@media all and (min-width:480px){
	.myOwnBrand .selectBrand {padding:13px 15px;}
	.myOwnBrand .selectBrand select {background-size:33px 33px;}
}
</style>
<div class="selectBrand">
	<select onchange="chgBA(this.value);">
		<option value="65469" <% if oEventid = "65469" then response.write "selected" end if%>>나만 알고 싶은 브랜드</option>
		<option value="65470" <% if oEventid = "65470" then response.write "selected" end if%>>01. FROMDANO</option>
		<option value="65471" <% if oEventid = "65471" then response.write "selected" end if%>>02. 3MONTHS</option>
		<option value="65482" <% if oEventid = "65482" then response.write "selected" end if%>>03. 1802</option>
		<option value="65478" <% if oEventid = "65478" then response.write "selected" end if%>>04. CHUMS</option>
		<option value="65484" <% if oEventid = "65484" then response.write "selected" end if%>>05. YURT</option>
		<option value="65496" <% if oEventid = "65496" then response.write "selected" end if%>>06. DANKE</option>
		<option value="65498" <% if oEventid = "65498" then response.write "selected" end if%>>07. MINGYUM</option>
		<option value="65481" <% if oEventid = "65481" then response.write "selected" end if%>>08. Terranation</option>
		<option value="65476" <% if oEventid = "65476" then response.write "selected" end if%>>09. VeryVeryNess</option>
		<option value="65480" <% if oEventid = "65480" then response.write "selected" end if%>>10. JacksonChameleon</option>
		<% If Date() >= "2015-08-24" Then '// 일별로 options 추가%>
		<option value="65684" <% if oEventid = "65684" then response.write "selected" end if%>>11. WILD BRICKS</option>
		<% End If %>
	</select>
</div>
<div class="myOwnBrand">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/65469/img_my_brand<%=tmpno%>.jpg" alt="" /></h2>
	<div class="navigator">
		<span class="prevBrand"><a href="<%=preEcode%>" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65469/btn_prev.png" alt="이전 브랜드 보기" /></a></span>
		<span class="nextBrand"><a href="<%=nextEcode%>" style="width:12.7%;" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65469/btn_next.png" alt="다음 브랜드 보기" /></a></span>
	</div>
	<div class="numbering">
		<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/65469/txt_num_<%=tmpno%>.png" alt="10" /></span>
		<span class="total"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65469/txt_num_total10.png" alt="/10" /></span>
	</div>
</div>