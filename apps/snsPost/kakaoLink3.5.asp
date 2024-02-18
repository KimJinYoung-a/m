<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.Charset = "UTF-8"
%>
<%
'#######################################################
'	History	:  2014.06.16 이종화 생성
'	Description : 카카오 링크
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!doctype HTML>
<html>
  <head>
	<!-- #include virtual="/lib/inc/head.asp" -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>KakaoLink Demo(Web Button) - Kakao Javascript SDK</title>
    <script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
  </head>
  <body>
    <h3>카카오톡 링크는 카카오톡 앱이 설치되어 있는 모바일 기기에서만 전송 가능합니다. 이 페이지를 모바일 기기에서 열어 주세요.</h3>
    <a id="kakaoa" href="javascript:;">
      <img src="http://dn.api1.kage.kakao.co.kr/14/dn/btqa9B90G1b/GESkkYjKCwJdYOkLvIBKZ0/o.jpg" />
    </a>

    <script>
    Kakao.init('c967f6e67b0492478080bcf386390fdd');

    // 카카오톡 링크 버튼을 생성합니다. 처음 한번만 호출하면 됩니다.
    Kakao.Link.createTalkLinkButton({
	  //1000자 이상일경우 , 1000자까지만 전송 
	  //메시지에 표시할 라벨
      container: '#kakaoa',
      label: '테스트메시지',
      image: {
		//500kb 이하 이미지만 표시됨
        src: 'http://imgstatic.10x10.co.kr/main/201406/642/v1EnjoyBanner_38904.jpg',
        width: '300',
        height: '200'
      },
      webButton: {
        text: '웹으로이동테스트',
        url: 'https://m.10x10.co.kr' // 앱 설정의 웹 플랫폼에 등록한 도메인의 URL이어야 합니다.
      }
		// 기존 2.0 버전 메시지
//		webLink: {
//		  text: '발송 메시지',
//		  url: 'http://m.10x10.co.kr/event/eventmain.asp?eventid=52580' //링크를 보낼곳
//		}
    });
    </script>
  </body>
</html>