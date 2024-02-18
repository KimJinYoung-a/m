<%
'####################################################
' Description : 2017 소품전 - SNS 공유 include
' History : 2017-03-30 유태욱
'####################################################
Dim sCurrUrl , Etitle , Eurl , gTitle , snsHtml , Eimgurl, kkoimg, snseCode
	sCurrUrl = Request.ServerVariables("url")
	snseCode = requestCheckVar(request("eventid"),5)
	'공유 문구 

	'Main page			-- 나만을 위한 소품이 가득한 곳! 15일동안 30%! 
	'MD기획전			-- 15개의 테마별 상품을 매일매일 확인하세요!
	'출석체크			-- 하루에 한번 카드를 확인하면 피규어 친구가 찾아갑니다!
	'상품찾기이벤트		-- 매일매일 힌트를 확인하고, 텐바이텐 속 숨어있는 보물을 찾아보세요!
	'구매사은품			-- 선착순 한정수량! 생활 속 꼭 필요한 아이템이 사은품으로!
	'배송박스이벤트		-- 일상속에 스티커를 붙이고 인증샷을 찍어주세요! 

	'gTitle

	'1. 인덱스 페이지 제외 (title 없이 해주세요)
	'2. Welcome to 소품랜드
	'3. 내 친구를 소개합니다.
	'4. 숨은 보물 찾기
	'5. 구매사은품
	'6. 반짝반짝 내친구

	IF snseCode =  77059 Then '// 메인페이지
		Etitle = "나만을 위한 소품이 가득한 곳! 15일동안 30%! "
		gTitle = "소품전"
		kkoimg = "http://webimage.10x10.co.kr/eventIMG/2017/sopum/77059/m/img_kakao.jpg"
	ElseIf snseCode =  77061 Then
		Etitle = "하루에 한번 카드를 확인하면 피규어 친구가 찾아갑니다!"
		gTitle = "내 친구를 소개합니다."
		kkoimg = "http://webimage.10x10.co.kr/eventIMG/2017/sopum/77061/m/img_kakao.jpg"
	ElseIf snseCode =  77062 Then
		Etitle = "매일매일 힌트를 확인하고, 텐바이텐 속 숨어있는 보물을 찾아보세요!"
		gTitle = "숨은 보물 찾기"
		kkoimg = "http://webimage.10x10.co.kr/eventIMG/2017/sopum/77062/m/img_kakao.jpg"
	ElseIf snseCode =  77063 Then
		Etitle = "선착순 한정수량! 생활 속 꼭 필요한 아이템이 사은품으로!"
		gTitle = "완전 소중한 사은품"
		kkoimg = "http://webimage.10x10.co.kr/eventIMG/2017/sopum/77063/m/img_kakao.jpg"
	ElseIf snseCode =  77064 Then
		Etitle = "일상속에 스티커를 붙이고 인증샷을 찍어주세요!"
		gTitle = "반짝반짝 스티커"
		kkoimg = "http://webimage.10x10.co.kr/eventIMG/2017/sopum/77064/m/img_kakao.jpg"
	Else
		Etitle = "15개의 테마별 상품을 매일매일 확인하세요!"
		gTitle = "Welcome to 소품랜드"
		kkoimg = "http://webimage.10x10.co.kr/eventIMG/2017/sopum/77060/m/img_kakao.jpg"
	End If

Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode("[텐바이텐] "&Etitle)
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&snseCode)
snpPre = Server.URLEncode("10x10 이벤트")

'기본 태그
snpTag = Server.URLEncode("텐바이텐")
snpTag2 = Server.URLEncode("#10x10 #소품전")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] "&Etitle
Dim kakaoimage : kakaoimage = kkoimg
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url 
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&snseCode
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&snseCode
End If

	snsHtml = ""
	snsHtml = snsHtml &"	<h3><img src=""http://webimage.10x10.co.kr/eventIMG/2017/sopum/common/m/tit_sns.gif"" alt=""함께하는 즐거움, 텐바이텐 소품전을 공유해주세요!""/></h3>"
	snsHtml = snsHtml &"	<ul>"
	snsHtml = snsHtml &"		<li class=""kakao""><a href="""" title="""&gTitle&""" onclick=""parent_kakaolink('"&kakaotitle&"','"&kakaoimage&"','"&kakaoimg_width&"','"&kakaoimg_height&"','"&kakaolink_url&"'); return false;""><img src=""http://webimage.10x10.co.kr/eventIMG/2017/sopum/common/m/btn_kakao.png"" alt=""카카오톡"" /></a></li>"
	snsHtml = snsHtml &"		<li class=""facebook""><a href="""" title="""&gTitle&""" onclick=""popSNSPost('fb','"&snpTitle&"','"&snpLink&"','','');return false;""><img src=""http://webimage.10x10.co.kr/eventIMG/2017/sopum/common/m/btn_facebook.png"" alt=""페이스북""/></a></li>"
	snsHtml = snsHtml &"	</ul>"
%>
