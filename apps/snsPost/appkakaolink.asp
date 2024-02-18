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
    <title>KakaoLink Demo(App Button) - Kakao Javascript SDK</title>
    <script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
  </head>
  <body>
    <h3>카카오톡 링크는 카카오톡 앱이 설치되어 있는 모바일 기기에서만 전송 가능합니다. 이 페이지를 모바일 기기에서 열어 주세요.</h3>
    <a id="kakao-link-btn" href="javascript:;">
      <img src="http://dn.api1.kage.kakao.co.kr/14/dn/btqa9B90G1b/GESkkYjKCwJdYOkLvIBKZ0/o.jpg" />
    </a>

    <script>
    Kakao.init('c967f6e67b0492478080bcf386390fdd');

    // 카카오톡 링크 버튼을 생성합니다. 처음 한번만 호출하면 됩니다.
    Kakao.Link.createTalkLinkButton({
      container: '#kakao-link-btn',
      label: '카카오링크 샘플에 오신 것을 환영합니다.',
      image: {
        src: 'http://dn.api1.kage.kakao.co.kr/14/dn/btqaWmFftyx/tBbQPH764Maw2R6IBhXd6K/o.jpg',
        width: '300',
        height: '200'
      },
      appLink: {
        text: '앱으로 이동',
		execParams :{
			android : {"url":"http://m.10x10.co.kr/apps/appCom/wish/webview/event/eventmain.asp?eventid=52595"}
		}
      }
    });
    </script>
  </body>
</html>