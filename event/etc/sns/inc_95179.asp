<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 텐텐 크리에이터
' History : 2018-12-12 이종화
'####################################################
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "✨텐텐 크리에이터✨를 찾습니다!"
	Dim kakaodescription : kakaodescription = "총 200만원의 상금을 지원하는\n텐텐 크리에이터에 도전하세요!"
	Dim kakaooldver : kakaooldver = "총 200만원의 상금을 지원하는\n텐텐 크리에이터에 도전하세요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2019/95179/etcitemban20190610143924.JPEG"
	Dim kakaolink_url 
	If isapp = "1" Then '앱일경우
		kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=95179"
	Else '앱이 아닐경우
		kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid=95179"
	End If
%>
<script>
function snschk() {
	<% if isapp="1" then %>
		fnAPPshareKakao('etc','<%=kakaotitle%>\n<%=kakaodescription%>','<%=kakaolink_url%>','<%=kakaolink_url%>','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');
		return false;
	<% else %>
		event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaolink_url%>' );
	<% end if %>
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

//카카오 SNS 공유 v2.0
function event_sendkakao(label , description , imageurl , linkurl){	
	Kakao.Link.sendDefault({
		objectType: 'feed',
		content: {
			title: label,
			description : description,
			imageUrl: imageurl,
			link: {
			mobileWebUrl: linkurl
			}
		},
		buttons: [
			{
				title: '웹으로 보기',
				link: {
					mobileWebUrl: linkurl
				}
			}
		]
	});
}
</script>
<div class="mEvt95179">
	<h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/95179/m/tit_creator.jpg" alt="텐텐크리에이터를 찾습니다"></h2>
	<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/95179/m/txt_01.jpg" alt=""></p>
	<p><a href="mailto:your10x10@naver.com"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95179/m/txt_02.jpg" alt="your10x10@naver.com"></a></p>
	<div class="bnr-sns">
		<a href="" onclick="snschk();return false;" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95179/m/bnr_sns.jpg" alt="카카오톡 공유하기"></a>
		<a href="" onclick="snschk();return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95179/m/bnr_sns.jpg" alt="카카오톡 공유하기"></a>
	</div>
</div>