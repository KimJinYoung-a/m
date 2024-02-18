<%
snpTitle	= Server.URLEncode(vTitle)
snpLink		= Server.URLEncode("http://www.10x10.co.kr/playing/view.asp?didx="&vDIdx&"")	'### PC주소
snpPre		= Server.URLEncode("10x10 PLAYing")
snpTag 		= Server.URLEncode("텐바이텐 " & Replace(vTitle," ",""))
snpTag2 	= Server.URLEncode("#10x10")

'// 카카오링크 변수
kakaotitle = "[텐바이텐] PLAYing - " & Replace(vTitle," ","") & ""
kakaoimage = vSquareImg
kakaoimg_width = "200"
kakaoimg_height = "200"

If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/playing/view.asp?didx="&vDIdx
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/playing/view.asp?didx="&vDIdx
End If
%>
<script>
function snschk(snsnum) {
	if(snsnum=="tw"){
		popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
		return false;
	}else if(snsnum=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
		return false;
	}else if(snsnum=="ka"){
		parent_kakaolink('<%=kakaotitle%>', '<%=kakaoimage%>' , '<%=kakaoimg_width%>' , '<%=kakaoimg_height%>' , '<%=kakaolink_url%>' );
		return false;
	}
}

function parent_kakaolink(label , imageurl , width , height , linkurl ){
	//카카오 SNS 공유
	Kakao.init('c967f6e67b0492478080bcf386390fdd');

	Kakao.Link.sendTalkLink({
		label: label,
		image: {
		src: imageurl,
		width: width,
		height: height
		},
		webButton: {
			text: '10x10 바로가기',
			url: linkurl
		}
	});
}
</script>
<div id="snsPlaying" class="sns">
	<ul>
		<li class="twitter"><a href="" onclick="snschk('tw'); return false;"><span></span>트위터에 공유하기</a></li>
		<li class="facebook"><a href="" onclick="snschk('fb'); return false;"><span></span>페이스북에 공유하기</a></li>
		<li class="kakao"><a href="" onclick="snschk('ka'); return false;"><span></span>카카오톡으로 공유하기</a></li>
		<li class="url"><a href="#lyUrl"><span></span>URL로 공유하기</a></li>
	</ul>
	<div id="lyUrl" class="lyUrl">
		<fieldset>
			<div class="field">
				<p>URL을 길게 눌러 복사해주세요</p>
				<a href="<%=kakaolink_url %>" onclick="return false;"><%=kakaolink_url %></a>
				<div class="button btB1 btBck cWh1 btnclose"><button type="button">닫기</button></div>
			</div>
		</fieldset>
	</div>
</div>
<div id="mask" style="display:none; position:absolute; top:0; left:0; z-index:55; width:100%; height:100%; background:rgba(0, 0, 0, .5);"></div>