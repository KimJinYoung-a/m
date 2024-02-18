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
'	History	:  2015-07-24 이종화 생성
'	Description : 카카오스토리 링크
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!DOCTYPE HTML>
<html>
  	<!-- #include virtual="/lib/inc/head.asp" -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>KakaoStory Share Button Demo - Kakao JavaScript SDK</title>
    <script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
  </head>
  <body>
    <div id="kakaostory-share-button"></div>
    <script>
      Kakao.init('d8ec7452bb7dc2e235287caac0aa5c5a');

      // 스토리 공유 버튼을 생성합니다.
      Kakao.Story.createShareButton({
        container: '#kakaostory-share-button',
        url: 'http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=862395',
        text: '스토리 공유 테스트'
      });
    </script>
  </body>
</html>