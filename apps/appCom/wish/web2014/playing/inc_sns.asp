<%
snpTitle	= vTitle
snpLink		= wwwUrl&"/playing/view.asp?didx="&vDIdx&"" '### PC주소
snpPre		= "10x10 PLAYing"
snpTag 		= "텐바이텐 " & Replace(vTitle," ","")
snpTag2 	= "#10x10"

'// 카카오링크 변수
kakaotitle = "[텐바이텐] PLAYing - " & Replace(vTitle," ","") & ""
kakaoimage = vSquareImg
kakaoimg_width = "200"
kakaoimg_height = "200"
snpImg=kakaoimage
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/playing/view.asp?didx="&vDIdx
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/playing/view.asp?didx="&vDIdx
End If
%>
<script>
// SNS 공유 팝업
function fnAPPRCVpopSNS(){
	//fnAPPpopupBrowserURL("공유","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popShare.asp?sTit=<%=snpTitle%>&sLnk=<%=snpLink%>&sPre=<%=snpPre%>&sImg=<%=vSquareImg%>");
	$("#lySns").show();
	$("#lySns .inner").removeClass("lySlideDown").addClass("lySlideUp");
	return false;
}
</script>