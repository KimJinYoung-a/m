<%
	response.write "<script type='text/javascript'>top.location.href='https://www.facebook.com/dialog/oauth?client_id=756945937691797&redirect_uri=https://m.10x10.co.kr/apps/facebook/app_test/index_mobile.asp&scope=publish_stream,read_stream,user_likes&display=page';</script>"
	''///// 접속 환경 분기 PC _ Mobile
	''// facebook
	''// http://apps.facebook.com/culture 캔버스 주소로 접속시 웹페이지는 페이지 탭으로 보여야 하기에  페이지 탭으로 리다이렉트
	''// 리다이렉트 시키키전 인증을 받아야 하므로 동일 페이지로 인증 code oauth 승인이 되면 페이지 탭으로 리다이렉트 * 중요
	''// 모바일은 facebook 지정내에서 모바일 페이지로 자동 리다이렉트 (모바일은 페이지 탭이 안되므로 캔버스 앱으로 전환하여 보여줌)
%>

