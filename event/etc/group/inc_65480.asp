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
	preEcode = "javascript:alert('이전 브랜드가 없습니다.');"  '//이전이벤트
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
	nextEcode = evturl & "65853"   '//다음이벤트
ElseIf oEventid = "65853" Then
	tmpno = "12"
	preEcode = evturl & "65684"  '//이전이벤트
	nextEcode = evturl & "66008"   '//다음이벤트
ElseIf oEventid = "66008" Then
	tmpno = "13"
	preEcode = evturl & "65853"  '//이전이벤트
	nextEcode = evturl & "66181" '//다음이벤트
ElseIf oEventid = "66181" Then
	tmpno = "14"
	preEcode = evturl & "66008"  '//이전이벤트
	nextEcode = evturl & "66340" '//다음이벤트
ElseIf oEventid = "66340" Then
	tmpno = "15"
	preEcode = evturl & "66181"  '//이전이벤트
	nextEcode = evturl & "66440" '//다음이벤트
ElseIf oEventid = "66440" Then
	tmpno = "16"
	preEcode = evturl & "66340"  '//이전이벤트
	nextEcode = evturl & "66624" '//다음이벤트
ElseIf oEventid = "66624" Then
	tmpno = "17"
	preEcode = evturl & "66440"  '//이전이벤트
	nextEcode = evturl & "66710" '//다음이벤트
ElseIf oEventid = "66710" Then
	tmpno = "18"
	preEcode = evturl & "66624"  '//이전이벤트
	nextEcode = evturl & "66892" '//다음이벤트
ElseIf oEventid = "66892" Then
	tmpno = "19"
	preEcode = evturl & "66710"  '//이전이벤트
	nextEcode = evturl & "67036" '//다음이벤트
ElseIf oEventid = "67036" Then
	tmpno = "20"
	preEcode = evturl & "66892"  '//이전이벤트
	nextEcode = evturl & "67191" '//다음이벤트
ElseIf oEventid = "67191" Then
	tmpno = "21"
	preEcode = evturl & "67036"  '//이전이벤트
	nextEcode = evturl & "67348" '//다음이벤트
ElseIf oEventid = "67348" Then
	tmpno = "22"
	preEcode = evturl & "67191"  '//이전이벤트
	nextEcode = evturl & "67544" '//다음이벤트
ElseIf oEventid = "67544" Then
	tmpno = "23"
	preEcode = evturl & "67348"  '//이전이벤트
	nextEcode = evturl & "67708" '//다음이벤트
ElseIf oEventid = "67708" Then
	tmpno = "24"
	preEcode = evturl & "67544"  '//이전이벤트
	nextEcode = evturl & "67791" '//다음이벤트
ElseIf oEventid = "67791" Then
	tmpno = "25"
	preEcode = evturl & "67708"  '//이전이벤트
	nextEcode = evturl & "67963" '//다음이벤트
ElseIf oEventid = "67963" Then
	tmpno = "26"
	preEcode = evturl & "67791"  '//이전이벤트
	nextEcode = evturl & "68145" '//다음이벤트
ElseIf oEventid = "68145" Then
	tmpno = "27"
	preEcode = evturl & "67963"  '//이전이벤트
	nextEcode = evturl & "68286" '//다음이벤트
ElseIf oEventid = "68286" Then
	tmpno = "28"
	preEcode = evturl & "68145" '//이전이벤트
	nextEcode = evturl & "68378" '//다음이벤트
ElseIf oEventid = "68378" Then
	tmpno = "29"
	preEcode = evturl & "68286" '//이전이벤트
	nextEcode = evturl & "68563" '//다음이벤트
ElseIf oEventid = "68563" Then
	tmpno = "30"
	preEcode = evturl & "68378" '//이전이벤트
	nextEcode = evturl & "68743" '//다음이벤트
ElseIf oEventid = "68743" Then
	tmpno = "31"
	preEcode = evturl & "68563" '//이전이벤트
	nextEcode = evturl & "68880" '//다음이벤트
ElseIf oEventid = "68880" Then
	tmpno = "32"
	preEcode = evturl & "68743" '//이전이벤트
	nextEcode = evturl & "69050" '//다음이벤트
ElseIf oEventid = "69050" Then
	tmpno = "33"
	preEcode = evturl & "68880" '//이전이벤트
	nextEcode = evturl & "69104" '//다음이벤트
ElseIf oEventid = "69104" Then
	tmpno = "34"
	preEcode = evturl & "69050" '//이전이벤트
	nextEcode = evturl & "69157" '//다음이벤트
ElseIf oEventid = "69157" Then
	tmpno = "35"
	preEcode = evturl & "69104" '//이전이벤트
	nextEcode = evturl & "69354" '//다음이벤트
ElseIf oEventid = "69354" Then
	tmpno = "36"
	preEcode = evturl & "69157" '//이전이벤트
	nextEcode = evturl & "69480" '//다음이벤트
ElseIf oEventid = "69480" Then
	tmpno = "37"
	preEcode = evturl & "69354" '//이전이벤트
	nextEcode = evturl & "69571" '//다음이벤트
ElseIf oEventid = "69571" Then
	tmpno = "38"
	preEcode = evturl & "69480" '//이전이벤트
	nextEcode = evturl & "69787" '//다음이벤트
ElseIf oEventid = "69787" Then
	tmpno = "39"
	preEcode = evturl & "69571" '//이전이벤트
	nextEcode = evturl & "69972" '//다음이벤트
ElseIf oEventid = "69972" Then
	tmpno = "40"
	preEcode = evturl & "69787" '//이전이벤트
	nextEcode = evturl & "70046" '//다음이벤트
ElseIf oEventid = "70046" Then
	tmpno = "41"
	preEcode = evturl & "69972" '//이전이벤트
	nextEcode = evturl & "70157" '//다음이벤트
ElseIf oEventid = "70157" Then
	tmpno = "42"
	preEcode = evturl & "70046" '//이전이벤트
	nextEcode = evturl & "70304" '//다음이벤트
ElseIf oEventid = "70304" Then
	tmpno = "43"
	preEcode = evturl & "70157" '//이전이벤트
	nextEcode = evturl & "70393" '//다음이벤트
ElseIf oEventid = "70393" Then
	tmpno = "44"
	preEcode = evturl & "70304" '//이전이벤트
	nextEcode = evturl & "70536" '//다음이벤트
ElseIf oEventid = "70536" Then
	tmpno = "45"
	preEcode = evturl & "70393" '//이전이벤트
	nextEcode = evturl & "70629" '//다음이벤트
ElseIf oEventid = "70629" Then
	tmpno = "46"
	preEcode = evturl & "70536" '//이전이벤트
	nextEcode = evturl & "70765" '//다음이벤트
ElseIf oEventid = "70765" Then
	tmpno = "47"
	preEcode = evturl & "70629" '//이전이벤트
	nextEcode = evturl & "70863" '//다음이벤트
ElseIf oEventid = "70863" Then
	tmpno = "48"
	preEcode = evturl & "70765" '//이전이벤트
	nextEcode = evturl & "71013" '//다음이벤트
ElseIf oEventid = "71013" Then
	tmpno = "49"
	preEcode = evturl & "70863" '//이전이벤트
	nextEcode = evturl & "71147" '//다음이벤트
ElseIf oEventid = "71147" Then
	tmpno = "50"
	preEcode = evturl & "71013" '//이전이벤트
	nextEcode = evturl & "71253" '//다음이벤트
ElseIf oEventid = "71253" Then
	tmpno = "51"
	preEcode = evturl & "71147" '//이전이벤트
	nextEcode = evturl & "71393" '//다음이벤트
ElseIf oEventid = "71393" Then
	tmpno = "52"
	preEcode = evturl & "71253" '//이전이벤트
	nextEcode = evturl & "71563" '//다음이벤트
ElseIf oEventid = "71563" Then
	tmpno = "53"
	preEcode = evturl & "71393" '//이전이벤트
	nextEcode = evturl & "71723" '//다음이벤트
ElseIf oEventid = "71723" Then
	tmpno = "54"
	preEcode = evturl & "71563" '//이전이벤트
	nextEcode = evturl & "71856" '//다음이벤트
ElseIf oEventid = "71856" Then
	tmpno = "55"
	preEcode = evturl & "71723" '//이전이벤트
	nextEcode = evturl & "72005" '//다음이벤트
ElseIf oEventid = "72005" Then
	tmpno = "56"
	preEcode = evturl & "71856" '//이전이벤트
	nextEcode = evturl & "72144" '//다음이벤트
ElseIf oEventid = "72144" Then
	tmpno = "57"
	preEcode = evturl & "72005" '//이전이벤트
	nextEcode = evturl & "72231" '//다음이벤트
ElseIf oEventid = "72231" Then
	tmpno = "58"
	preEcode = evturl & "72144" '//이전이벤트
	nextEcode = evturl & "72365" '//다음이벤트
ElseIf oEventid = "72365" Then
	tmpno = "59"
	preEcode = evturl & "72231" '//이전이벤트
	nextEcode = evturl & "72532" '//다음이벤트
ElseIf oEventid = "72532" Then
	tmpno = "60"
	preEcode = evturl & "72365" '//이전이벤트
	nextEcode = evturl & "72651" '//다음이벤트
ElseIf oEventid = "72651" Then
	tmpno = "61"
	preEcode = evturl & "72532" '//이전이벤트
	nextEcode = evturl & "72738" '//다음이벤트
ElseIf oEventid = "72738" Then
	tmpno = "62"
	preEcode = evturl & "72651" '//이전이벤트
	nextEcode = evturl & "72938" '//다음이벤트
ElseIf oEventid = "72938" Then
	tmpno = "63"
	preEcode = evturl & "72738" '//이전이벤트
	nextEcode = evturl & "73070" '//다음이벤트
ElseIf oEventid = "73070" Then
	tmpno = "64"
	preEcode = evturl & "72938" '//이전이벤트
	nextEcode = evturl & "73073" '//다음이벤트
ElseIf oEventid = "73073" Then
	tmpno = "65"
	preEcode = evturl & "72938" '//이전이벤트
	nextEcode = evturl & "73310" '//다음이벤트
ElseIf oEventid = "73310" Then
	tmpno = "66"
	preEcode = evturl & "73073" '//이전이벤트
	nextEcode = evturl & "73453" '//다음이벤트
ElseIf oEventid = "73453" Then
	tmpno = "67"
	preEcode = evturl & "73310" '//이전이벤트
	nextEcode = evturl & "73606" '//다음이벤트
ElseIf oEventid = "73606" Then
	tmpno = "68"
	preEcode = evturl & "73453" '//이전이벤트
	nextEcode = evturl & "73748" '//다음이벤트
ElseIf oEventid = "73748" Then
	tmpno = "69"
	preEcode = evturl & "73606" '//이전이벤트
	nextEcode = evturl & "73893" '//다음이벤트
ElseIf oEventid = "73893" Then
	tmpno = "70"
	preEcode = evturl & "73748" '//이전이벤트
	nextEcode = evturl & "74013" '//다음이벤트
ElseIf oEventid = "74013" Then
	tmpno = "71"
	preEcode = evturl & "73893" '//이전이벤트
	nextEcode = evturl & "74175" '//다음이벤트
ElseIf oEventid = "74175" Then
	tmpno = "72"
	preEcode = evturl & "74013" '//이전이벤트
	nextEcode = evturl & "65469" '//다음이벤트
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
.numbering {position:absolute; right:4%; bottom:2%; width:92%; text-align:right; display:none;}
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

		<% If Date() >= "2016-11-07" Then '// 일별로 options 추가%>
		<option value="74175" <% if oEventid = "74175" then response.write "selected" end if%>>72. SRISALZZAC</option>
		<% End If %>
		<option value="74013" <% if oEventid = "74013" then response.write "selected" end if%>>71. WITH AESH</option>
		<option value="73893" <% if oEventid = "73893" then response.write "selected" end if%>>70. BETTERS</option>
		<option value="73748" <% if oEventid = "73748" then response.write "selected" end if%>>69. CITYLIFE</option>
		<option value="73606" <% if oEventid = "73606" then response.write "selected" end if%>>68. UN POCO PIU LENTO</option>
		<option value="73453" <% if oEventid = "73453" then response.write "selected" end if%>>67. A LITTLE LOVELY COMPANY</option>
		<option value="73310" <% if oEventid = "73310" then response.write "selected" end if%>>66. FLUFFY HOUSE</option>
		<option value="73073" <% if oEventid = "73073" then response.write "selected" end if%>>65. MOONLIGHT PUNCH ROMANCE</option>
		<option value="73070" <% if oEventid = "73070" then response.write "selected" end if%>>64. HICOSTUMEJEWELRY</option>
		<option value="72938" <% if oEventid = "72938" then response.write "selected" end if%>>63. MAKIT</option>
		<option value="72738" <% if oEventid = "72738" then response.write "selected" end if%>>62. CONFEITO</option>
		<option value="72651" <% if oEventid = "72651" then response.write "selected" end if%>>61. 806MADIVE</option>
		<option value="72532" <% if oEventid = "72532" then response.write "selected" end if%>>60. CREME</option>
		<option value="72365" <% if oEventid = "72365" then response.write "selected" end if%>>59. YOA</option>
		<option value="72231" <% if oEventid = "72231" then response.write "selected" end if%>>58. RIRIRHIM</option>
		<option value="72144" <% if oEventid = "72144" then response.write "selected" end if%>>57. COLLECTOGRAPH DESIGN STUDIO</option>
		<option value="72005" <% if oEventid = "72005" then response.write "selected" end if%>>56. ZEROMILLIMETER</option>
		<option value="71856" <% if oEventid = "71856" then response.write "selected" end if%>>55. SEOULBUND</option>
		<option value="71723" <% if oEventid = "71723" then response.write "selected" end if%>>54. FLAT POINT</option>
		<option value="71563" <% if oEventid = "71563" then response.write "selected" end if%>>53. MINUUMINUU</option>
		<option value="71393" <% if oEventid = "71393" then response.write "selected" end if%>>52. MIDNIGHT CIRCUS</option>
		<option value="71253" <% if oEventid = "71253" then response.write "selected" end if%>>51. FOGBOW</option>
		<option value="71147" <% if oEventid = "71147" then response.write "selected" end if%>>50. GENTLE BREEZE</option>
		<option value="71013" <% if oEventid = "71013" then response.write "selected" end if%>>49. ABLE TIME</option>
		<option value="70863" <% if oEventid = "70863" then response.write "selected" end if%>>48. HERSERIES</option>
		<option value="70765" <% if oEventid = "70765" then response.write "selected" end if%>>47. KINTO</option>
		<option value="70629" <% if oEventid = "70629" then response.write "selected" end if%>>46. ZIGZAG FACTORY</option>
		<option value="70536" <% if oEventid = "70536" then response.write "selected" end if%>>45. HAPOOOOOM</option>
		<option value="70393" <% if oEventid = "70393" then response.write "selected" end if%>>44. WARMGREYTAIL</option>
		<option value="70304" <% if oEventid = "70304" then response.write "selected" end if%>>43. ALLGRAY</option>
		<option value="70157" <% if oEventid = "70157" then response.write "selected" end if%>>42. SONG OF SONGS</option>
		<option value="70046" <% if oEventid = "70046" then response.write "selected" end if%>>41. MOKUYOBI THREADS</option>
		<option value="69972" <% if oEventid = "69972" then response.write "selected" end if%>>40. VIVFLAT</option>
		<option value="69787" <% if oEventid = "69787" then response.write "selected" end if%>>39. GREEN BLISS</option>
		<option value="69571" <% if oEventid = "69571" then response.write "selected" end if%>>38. CLOSINGMENT</option>
		<option value="69480" <% if oEventid = "69480" then response.write "selected" end if%>>37. 22KITCHEN</option>
		<option value="69354" <% if oEventid = "69354" then response.write "selected" end if%>>36. SMEG</option>
		<option value="69157" <% if oEventid = "69157" then response.write "selected" end if%>>35. MUNITO Daily</option>
		<option value="69104" <% if oEventid = "69104" then response.write "selected" end if%>>34. Masion de aloha</option>
		<option value="69050" <% if oEventid = "69050" then response.write "selected" end if%>>33. EPOK</option>
		<option value="68880" <% if oEventid = "68880" then response.write "selected" end if%>>32. BECKSTORE</option>
		<option value="68743" <% if oEventid = "68743" then response.write "selected" end if%>>31. YOURBREEZE</option>
		<option value="68563" <% if oEventid = "68563" then response.write "selected" end if%>>30. DANBAM</option>
		<option value="68378" <% if oEventid = "68378" then response.write "selected" end if%>>29. FEATURE</option>
		<option value="68286" <% if oEventid = "68286" then response.write "selected" end if%>>28. DEAR MAISON</option>
		<option value="68145" <% if oEventid = "68145" then response.write "selected" end if%>>27. HOWSLOW</option>
		<option value="67963" <% if oEventid = "67963" then response.write "selected" end if%>>26. OIMU</option>
		<option value="67791" <% if oEventid = "67791" then response.write "selected" end if%>>25. 3rd TRIP</option>
		<option value="67708" <% if oEventid = "67708" then response.write "selected" end if%>>24. Altesse</option>
		<option value="67544" <% if oEventid = "67544" then response.write "selected" end if%>>23. HANAHZO</option>
		<option value="67348" <% if oEventid = "67348" then response.write "selected" end if%>>22. M ET TOI</option>
		<option value="67191" <% if oEventid = "67191" then response.write "selected" end if%>>21. HOTEL SALT</option>
		<option value="67036" <% if oEventid = "67036" then response.write "selected" end if%>>20. ALL MY STUFF</option>
		<option value="66892" <% if oEventid = "66892" then response.write "selected" end if%>>19. MOSH </option>
		<option value="66710" <% if oEventid = "66710" then response.write "selected" end if%>>18. TISSH</option>
		<option value="66624" <% if oEventid = "66624" then response.write "selected" end if%>>17. IZOLA</option>
		<option value="66440" <% if oEventid = "66440" then response.write "selected" end if%>>16. MIDNIGHT RECIPE</option>
		<option value="66340" <% if oEventid = "66340" then response.write "selected" end if%>>15. 29X29</option>
		<option value="66181" <% if oEventid = "66181" then response.write "selected" end if%>>14. DAYDREAMER</option>
		<option value="66008" <% if oEventid = "66008" then response.write "selected" end if%>>13. MAIS E MAIS</option>
		<option value="65853" <% if oEventid = "65853" then response.write "selected" end if%>>12. MIND OVER MATTER</option>
		<option value="65684" <% if oEventid = "65684" then response.write "selected" end if%>>11. WILD BRICKS</option>
		<option value="65480" <% if oEventid = "65480" then response.write "selected" end if%>>10. JACKSONCHAMELEON</option>
		<option value="65476" <% if oEventid = "65476" then response.write "selected" end if%>>09. VeryVeryNess</option>
		<option value="65481" <% if oEventid = "65481" then response.write "selected" end if%>>08. TERRANATION</option>
		<option value="65498" <% if oEventid = "65498" then response.write "selected" end if%>>07. MINGYUM</option>
		<option value="65496" <% if oEventid = "65496" then response.write "selected" end if%>>06. DANKE</option>
		<option value="65484" <% if oEventid = "65484" then response.write "selected" end if%>>05. YURT</option>
		<option value="65478" <% if oEventid = "65478" then response.write "selected" end if%>>04. CHUMS</option>
		<option value="65482" <% if oEventid = "65482" then response.write "selected" end if%>>03. 1802</option>
		<option value="65471" <% if oEventid = "65471" then response.write "selected" end if%>>02. 3MONTHS</option>
		<option value="65470" <% if oEventid = "65470" then response.write "selected" end if%>>01. FROMDANO</option>
	</select>
</div>
<div class="myOwnBrand">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/65469/img_my_brand<%=tmpno%>.jpg" alt="" /></h2>
	<div class="navigator">
		<span class="prevBrand"><a href="<%=nextEcode%>" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65469/btn_prev.png" alt="이전 브랜드 보기" /></a></span>
		<span class="nextBrand"><a href="<%=preEcode%>" style="width:12.7%;" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65469/btn_next.png" alt="다음 브랜드 보기" /></a></span>
	</div>
	<div class="numbering">
		<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/65469/txt_num_<%=tmpno%>.png" alt="10" /></span>
		<span class="total"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65469/txt_num_total10.png" alt="/10" /></span>
	</div>
</div>