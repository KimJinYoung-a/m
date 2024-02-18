<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description : 2017 발렌타인
' History : 2017-01-25 유태욱 생성
'####################################################
Dim eCode
Dim vTimerDate, nowDate, sNow
Dim todayLinkItem1, todayImage1, todayItemname1, todayOrgprice1, todaySalePrice1, todaySalePer1, todayItemcopy1
Dim todayLinkItem2, todayImage2, todayItemname2, todayOrgprice2, todaySalePrice2, todaySalePer2, todayItemcopy2
Dim todayLinkItem3, todayImage3, todayItemname3, todayOrgprice3, todaySalePrice3, todaySalePer3, todayItemcopy3
Dim todayLinkItem4, todayImage4, todayItemname4, todayOrgprice4, todaySalePrice4, todaySalePer4, todayItemcopy4
nowDate = date()
sNow = now()
'nowDate = "2017-02-01"
'sNow = "2017-02-01 " & Hour(now) & ":" & Minute(now) & ":" & Second(now)

IF application("Svr_Info") = "Dev" THEN
	eCode 		= "66270"
Else
	eCode 		= "75738"
End If

Select Case nowDate
	Case "2017-01-30"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "1640286"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0130_01.png"
		todayItemname1		= "발렌타인데이 프랄린 수제초콜릿 선물세트 10pcs"
		todayItemcopy1		= "좋은것만 담은 프리미엄"
		todayOrgprice1		= "24,500"
		todaySalePrice1		= "19,600"
		todaySalePer1		= "20%"

		todayLinkItem2		= "289324"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0130_02.png"
		todayItemname2		= "러블리 초콜렛만들기 세트"
		todayItemcopy2		= "사랑스럽게 한박스 뚝딱"
		todayOrgprice2		= "21,800"
		todaySalePrice2		= "19,800"
		todaySalePer2		= "9%"

		todayLinkItem3		= "1640557"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0130_03.png"
		todayItemname3		= "파베닙스2단 초콜릿만들기세트"
		todayOrgprice3		= "32,900"
		todayItemcopy3		= "쉽게 만드는 진한 초콜릿"
		todaySalePrice3		= "26,900"
		todaySalePer3		= "18%"

	Case "2017-01-31"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "1424644"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0131_01.png"
		todayItemname1		= "디비디 파베 초콜릿 만들기 세트 - With"
		todayItemcopy1		= "한입에 살살녹는 파베초콜렛"
		todayOrgprice1		= "27,000"
		todaySalePrice1		= "22,950"
		todaySalePer1		= "15%"

		todayLinkItem2		= "289324"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0131_02.png"
		todayItemname2		= "러블리 초콜렛만들기 세트"
		todayItemcopy2		= "사랑스럽게 한박스 뚝딱"
		todayOrgprice2		= "21,800"
		todaySalePrice2		= "19,800"
		todaySalePer2		= "9%"

		todayLinkItem3		= "1640557"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0131_03.png"
		todayItemname3		= "파베닙스2단 초콜릿만들기세트"
		todayItemcopy3		= "쉽게 만드는 진한 초콜릿"
		todayOrgprice3		= "32,900"
		todaySalePrice3		= "26,900"
		todaySalePer3		= "18%"

	Case "2017-02-01"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "1639960"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0201_01.png"
		todayItemname1		= "메르시파베 초콜릿만들기세트"
		todayItemcopy1		= "앙증맞은 픽이 쏙쏙"
		todayOrgprice1		= "31,000"
		todaySalePrice1		= "21,700"
		todaySalePer1		= "30%"

		todayLinkItem2		= "1423601"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0201_02.png"
		todayItemname2		= "하트 브라우니 초콜릿 만들기 set"
		todayItemcopy2		= "색다른 초콜릿 선물"
		todayOrgprice2		= "28,500"
		todaySalePrice2		= "25,600"
		todaySalePer2		= "10%"

		todayLinkItem3		= "1639961"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0201_03.png"
		todayItemname3		= "핑크러브 초콜릿만들기세트"
		todayItemcopy3		= "예쁜 패키지에 시선집중"
		todayOrgprice3		= "23,500"
		todaySalePrice3		= "18,800"
		todaySalePer3		= "20%"

	Case "2017-02-02"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "1639667"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0202_01.png"
		todayItemname1		= "2017마이보틀아망드"
		todayItemcopy1		= "달콤하고 건강하게"
		todayOrgprice1		= "24,000"
		todaySalePrice1		= "20,400"
		todaySalePer1		= "15%"

		todayLinkItem2		= "1423601"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0202_02.png"
		todayItemname2		= "하트 브라우니 초콜릿 만들기 set"
		todayItemcopy2		= "색다른 초콜릿 선물"
		todayOrgprice2		= "28,500"
		todaySalePrice2		= "25,600"
		todaySalePer2		= "10%"

		todayLinkItem3		= "1639961"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0202_03.png"
		todayItemname3		= "핑크러브 초콜릿만들기세트"
		todayItemcopy3		= "예쁜 패키지에 시선집중"
		todayOrgprice3		= "23,500"
		todaySalePrice3		= "18,800"
		todaySalePer3		= "20%"

	Case "2017-02-03", "2017-02-04", "2017-02-05"
		vTimerDate			= DateAdd("d", 3, "2017-02-03")
		todayLinkItem1		= "999831"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0203_01.png"
		todayItemname1		= "발렌타인데이 쿠키만들기세트"
		todayItemcopy1		= "원하는 메시지를 적어보세요"
		todayOrgprice1		= "23,300"
		todaySalePrice1		= "18,640"
		todaySalePer1		= "20%"

		todayLinkItem2		= "1641232"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0203_02.png"
		todayItemname2		= "L 땡큐메르시 파베초콜릿만들기 세트"
		todayItemcopy2		= "사르르 녹는 달콤함"
		todayOrgprice2		= "33,500"
		todaySalePrice2		= "26,500"
		todaySalePer2		= "21%"

		todayLinkItem3		= "1639664"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0203_03.png"
		todayItemname3		= "메시지판초콜렛"
		todayItemcopy3		= "고백하기 좋은 초콜렛 만들기"
		todayOrgprice3		= "25,000"
		todaySalePrice3		= "22,500"
		todaySalePer3		= "10%"

	Case "2017-02-06"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "1445044"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0207_01.png"
		todayItemname1		= "사르르 녹는 입 안의 행복"
		todayItemcopy1		= "글라소디 파베초콜릿"
		todayOrgprice1		= "16,000"
		todaySalePrice1		= "13,600"
		todaySalePer1		= "15%"

		todayLinkItem2		= "1642961"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0206_02.png"
		todayItemname2		= "라피네 프루츠 앤 넛 초콜릿만들기 세트"
		todayItemcopy2		= "좋아하는 재료를 듬뿍"
		todayOrgprice2		= "29,900"
		todaySalePrice2		= ""
		todaySalePer2		= ""

		todayLinkItem3		= "1639667"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0206_03.png"
		todayItemname3		= "2017마이보틀아망드"
		todayItemcopy3		= "초콜릿 입은 고소한 아몬드"
		todayOrgprice3		= "24,000"
		todaySalePrice3		= "21,600"
		todaySalePer3		= "10%"

	Case "2017-02-07"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "1421210"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0206_01.png"
		todayItemname1		= "사랑하는 만큼 줄 수 있는 1+1"
		todayItemcopy1		= "G 로맨틱 플래그 파베초콜릿만들기"
		todayOrgprice1		= "29,600"
		todaySalePrice1		= "21,800"
		todaySalePer1		= "26%"

		todayLinkItem2		= "1640947"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0207_02.png"
		todayItemname2		= "러브베어발렌타인쿠키 DIY세트"
		todayItemcopy2		= "하트품은 곰"
		todayOrgprice2		= "15,900"
		todaySalePrice2		= ""
		todaySalePer2		= ""

		todayLinkItem3		= "1639503"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0207_03.png"
		todayItemname3		= "발레리제 생초콜릿 7종"
		todayItemcopy3		= "좋은 재료로 만든 수제 초콜릿"
		todayOrgprice3		= "10,000"
		todaySalePrice3		= ""
		todaySalePer3		= ""

	Case "2017-02-08"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "1642984"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0208_01.png"
		todayItemname1		= "스위트 띵스 초콜릿 만들기 세트"
		todayItemcopy1		= "다양하게 골라먹는 초콜릿"
		todayOrgprice1		= "29,800"
		todaySalePrice1		= "23,840"
		todaySalePer1		= "20%"

		todayLinkItem2		= "1640557"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0208_02.png"
		todayItemname2		= "파베닙스2단 초콜릿만들기세트"
		todayItemcopy2		= "파베닙스2단 초콜릿만들기세트 "
		todayOrgprice2		= "32,900"
		todaySalePrice2		= "22,900"
		todaySalePer2		= "30%"

		todayLinkItem3		= "1641243"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0208_03.png"
		todayItemname3		= "애니멀2단 초콜릿만들기세트"
		todayItemcopy3		= "입양하고 싶은 초콜릿"
		todayOrgprice3		= "28,900"
		todaySalePrice3		= "24,900"
		todaySalePer3		= "14%"

	Case "2017-02-09"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "1201699"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0209_01.png"
		todayItemname1		= "마시멜로 생초콜릿 만들기세트"
		todayItemcopy1		= "쫄깃한 마시멜로가 숨어있어요"
		todayOrgprice1		= "19,800"
		todaySalePrice1		= "14,900"
		todaySalePer1		= "25%"

		todayLinkItem2		= "976159"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0209_02.png"
		todayItemname2		= "쿠키몬스터 파티셰리 마카롱 9pack"
		todayItemcopy2		= "센스있는 여자친구라면"
		todayOrgprice2		= "19,800"
		todaySalePrice2		= "16,830"
		todaySalePer2		= "15%"

		todayLinkItem3		= "1646456"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0209_03.png"
		todayItemname3		= "글라소디 녹차 파베초콜릿"
		todayItemcopy3		= "달콤 쌉싸름한 행복"
		todayOrgprice3		= "16,000"
		todaySalePrice3		= ""
		todaySalePer3		= ""

	Case "2017-02-10", "2017-02-11", "2017-02-12"
		vTimerDate			= DateAdd("d", 3, "2017-02-10")
		todayLinkItem1		= "1641123"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0210_01.png"
		todayItemname1		= "땡스롤리 수제 카라멜"
		todayItemcopy1		= "믿을 수 있는 재료로 만든"
		todayOrgprice1		= "13,500"
		todaySalePrice1		= "12,820"
		todaySalePer1		= "5%"

		todayLinkItem2		= "439795"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0210_02.png"
		todayItemname2		= "로맨틱 플라워 초콜릿 만들기 "
		todayItemcopy2		= "화사하고 화려한 초콜릿"
		todayOrgprice2		= "31,600"
		todaySalePrice2		= "26,500"
		todaySalePer2		= "16%"

		todayLinkItem3		= "1615609"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0210_03.png"
		todayItemname3		= "쿠키몬스터 파티셰리 쇼콜라스노우"
		todayItemcopy3		= "색다른 초콜릿 선물"
		todayOrgprice3		= "24,000"
		todaySalePrice3		= "20,400"
		todaySalePer3		= "15%"

	Case "2017-02-13"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "1424547"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0213_01.png"
		todayItemname1		= "디비디 초콜릿 만들기 세트 - Dear"
		todayItemcopy1		= "사르르 녹는 입 안의 행복"
		todayOrgprice1		= "45,000"
		todaySalePrice1		= "31,500"
		todaySalePer1		= "30%"

		todayLinkItem2		= "593370"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0213_02.png"
		todayItemname2		= "로맨틱데이 초콜릿만들기 세트"
		todayItemcopy2		= "모양도 맛도 달콤해요"
		todayOrgprice2		= "28,900"
		todaySalePrice2		= ""
		todaySalePer2		= ""

		todayLinkItem3		= "1642953"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0213_03.png"
		todayItemname3		= "OWLBOX 2월호(발렌타인데이 특집) : 기쁨 나누기"
		todayItemcopy3		= "다양하게 골라먹는 초콜릿"
		todayOrgprice3		= "29,700"
		todaySalePrice3		= ""
		todaySalePer3		= ""

	Case "2017-02-14"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "1580948"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0214_01.png"
		todayItemname1		= "디비디 초콜릿 만들기 세트 - Mon"
		todayItemcopy1		= "원하는 토핑으로 꾸며봐요!"
		todayOrgprice1		= "25,000"
		todaySalePrice1		= "20,000"
		todaySalePer1		= "20%"

		todayLinkItem2		= "1639503"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0214_02.png"
		todayItemname2		= "발레리제 생초콜릿 7종"
		todayItemcopy2		= "좋은 재료로 만든 수제 초콜릿"
		todayOrgprice2		= "10,000"
		todaySalePrice2		= ""
		todaySalePer2		= ""

		todayLinkItem3		= "797848"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0214_03.png"
		todayItemname3		= "미셸클뤼젤 필레 드 사르딘느 (90g *2)"
		todayItemcopy3		= "정어리야 초콜릿이야?"
		todayOrgprice3		= "30,000"
		todaySalePrice3		= "27,000"
		todaySalePer3		= "10%"

	Case "2017-02-15"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= ""
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0215_01.png"
		todayItemname1		= ""
		todayItemcopy1		= ""
		todayOrgprice1		= ""
		todaySalePrice1		= ""
		todaySalePer1		= "%"

		todayLinkItem2		= ""
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0215_02.png"
		todayItemname2		= ""
		todayItemcopy2		= ""
		todayOrgprice2		= ""
		todaySalePrice2		= ""
		todaySalePer2		= "%"

		todayLinkItem3		= ""
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0215_03.png"
		todayItemname3		= ""
		todayItemcopy3		= ""
		todayOrgprice3		= ""
		todaySalePrice3		= ""
		todaySalePer3		= "%"

	Case "2017-02-16"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= ""
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0216_01.png"
		todayItemname1		= ""
		todayItemcopy1		= ""
		todayOrgprice1		= ""
		todaySalePrice1		= ""
		todaySalePer1		= "%"

		todayLinkItem2		= ""
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0216_02.png"
		todayItemname2		= ""
		todayItemcopy2		= ""
		todayOrgprice2		= ""
		todaySalePrice2		= ""
		todaySalePer2		= "%"

		todayLinkItem3		= ""
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0216_03.png"
		todayItemname3		= ""
		todayItemcopy3		= ""
		todayOrgprice3		= ""
		todaySalePrice3		= ""
		todaySalePer3		= "%"

	Case "2017-02-17", "2017-02-18", "2017-02-19"
		vTimerDate			= DateAdd("d", 3, "2017-02-17")
		todayLinkItem1		= ""
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0217_01.png"
		todayItemname1		= ""
		todayItemcopy1		= ""
		todayOrgprice1		= ""
		todaySalePrice1		= ""
		todaySalePer1		= "%"

		todayLinkItem2		= ""
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0217_02.png"
		todayItemname2		= ""
		todayItemcopy2		= ""
		todayOrgprice2		= ""
		todaySalePrice2		= ""
		todaySalePer2		= "%"

		todayLinkItem3		= ""
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0217_03.png"
		todayItemname3		= ""
		todayItemcopy3		= ""
		todayOrgprice3		= ""
		todaySalePrice3		= ""
		todaySalePer3		= "%"

End Select

%>
<style type="text/css">
.valentine .item {background-color:#ffd0c1;}
.valentine .rolling {padding-bottom:9%;}
.valentine .swiper {position:relative;}
.valentine .swiper .swiper-slide {background:#ffd0c1 url(http://webimage.10x10.co.kr/eventIMG/2017/75738/m/bg_back.png) no-repeat 50% 0; background-size:100% auto;}
.valentine .swiper .swiper-slide a {display:block; position:relative; width:79%; margin:0 auto; padding-top:5.5%; text-align:center;}
.valentine .swiper .label {position:absolute; top:5%; right:0; width:23.71%;}
.valentine .swiper .label .time {position:absolute; bottom:-0.9rem; left:50%; width:120%; height:1.8rem; margin-left:-60%; padding-top:0.1rem; border-radius:1.8rem; background-color:#332622; color:#fff; font-size:1.3rem; line-height:1.8rem;}
.valentine .swiper .desc {margin-top:13%;}
.valentine .swiper .desc span {display:block;}
.valentine .swiper .desc .copy {color:#ba5a4c; font-size:1.1rem;}
.valentine .swiper .name {overflow:hidden; margin-top:0.6rem; color:#842d20; font-size:1.3rem; font-weight:bold; text-overflow:ellipsis; white-space:nowrap;}
.valentine .swiper .price {margin-top:1.2rem; color:#d50c0c; font-size:1.4rem; font-weight:bold;}
.valentine .swiper .cRd1 {color:#d50c0c !important;}
.valentine .swiper .btnGet {width:20.5rem; margin:1.85rem auto 0;}

.valentine .swiper .pagination {height:auto; padding:0; margin-top:2.15rem;}
.valentine .swiper .pagination .swiper-pagination-switch {width:6px; height:6px; margin:0 0.45rem; border-radius:50%; background-color:#ffece6; transition:all 0.5s;}
.valentine .swiper .pagination .swiper-active-switch {background-color:#f26668;}

@media all and (min-width:360px){
	.valentine .swiper .pagination .swiper-pagination-switch {width:8px; height:8px;}
}
@media all and (min-width:600px){
	.valentine .swiper .pagination .swiper-pagination-switch {width:10px; height:10px;}
}
@media all and (min-width:768px){
	.valentine .swiper .pagination .swiper-pagination-switch {width:12px; height:12px;}
}

.valentine .rolling .btnNav {position:absolute; top:23%; z-index:5; width:11.25%; padding:10% 0; background-color:transparent;}
.valentine .rolling .btnPrev {left:0;}
.valentine .rolling .btnNext {right:0;}

.valentine .sweetShop {padding-bottom:8.2%; background:#843f22 url(http://webimage.10x10.co.kr/eventIMG/2017/75738/m/bg_pattern_brown.png) repeat-y 50% 0;}
.valentine .sweetShop ul {overflow:hidden; padding:0 4.68%;}
.valentine .sweetShop ul li {float:left; width:50%; margin-top:3.6%;}
.valentine .sweetShop ul li a {display:block; padding:0 3.4%;}

.valentine .bnr {margin-top:7.4%;}
.valentine .bnr ul li {margin-bottom:5%;}
</style>
<script type="text/javascript">
$(function(){
	countdown();
	itemSwiper = new Swiper("#rolling .swiper-container",{
		loop:false,
		autoplay:3000,
		speed:800,
		pagination:".rolling .pagination",
		paginationClickable:true,
		nextButton:".rolling .btnNext",
		prevButton:".rolling .btnPrev",
		effect:"fade"
	});
	
});

var yr = "<%=Year(vTimerDate)%>";
var mo = "<%=TwoNumber(Month(vTimerDate))%>";
var da = "<%=TwoNumber(Day(vTimerDate))%>";
var minus_second = 0;
var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
var today=new Date(<%=Year(sNow)%>, <%=Month(sNow)-1%>, <%=Day(sNow)%>, <%=Hour(sNow)%>, <%=Minute(sNow)%>, <%=Second(sNow)%>);

function countdown(){
	today = new Date(Date.parse(today) + (1000+minus_second));	//서버시간에 1초씩 증가
	var todayy=today.getYear()

	if(todayy < 1000) todayy+=1900;
		
	var todaym=today.getMonth();
	var todayd=today.getDate();
	var todayh=today.getHours();
	var todaymin=today.getMinutes();
	var todaysec=today.getSeconds();
	var todaystring=montharray[todaym]+" "+todayd+", "+todayy+" "+todayh+":"+todaymin+":"+todaysec;
	var futurestring=montharray[mo-1]+" "+da+", "+yr+" 00:00:00";

	dd=Date.parse(futurestring)-Date.parse(todaystring);
	dday=Math.floor(dd/(60*60*1000*24)*1);

	dhour = Math.floor(((dd%(60*60*1000*24))/(60*60*1000)*1));
	dhour = parseInt(dhour)+parseInt(24*dday);

	dmin=Math.floor(((dd%(60*60*1000*24))%(60*60*1000))/(60*1000)*1);
	dsec=Math.floor((((dd%(60*60*1000*24))%(60*60*1000))%(60*1000))/1000*1);

	if(dday < 0) {
		$("#dtime").html("0");
		return;
	}

	if(dhour < 10) dhour = "0" + dhour;
	if(dmin < 10) dmin = "0" + dmin;
	if(dsec < 10) dsec = "0" + dsec;
	dhour = dhour+'';
	dmin = dmin+'';
	dsec = dsec+'';

	// Print Time
	$("#dtime").html(dhour.substr(0,1)+dhour.substr(1,1)+":"+dmin.substr(0,1)+dmin.substr(1,1)+":"+dsec.substr(0,1)+dsec.substr(1,1));
	
	minus_second = minus_second + 1;

	if (( String(dhour) == '00' ) && ( String(dmin) == '00' ) && ( String(dsec) == '00' )) {
		document.location.reload();
	}else{
		setTimeout("countdown()",1000)
	}
}

function goEventLink(evt) {
	<% if isApp then %>
		parent.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid='+evt;
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}
</script>
	<div class="mEvt75738 valentine">
		<div class="item">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/75738/m/txt_valentine_v2.gif" alt="세상의 모든 달콤함을 만나는 날" /></p>
			<div id="rolling" class="rolling">
				<div class="swiper">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<% If isApp = 1 Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%= todayLinkItem1 %>'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=<%= todayLinkItem1 %>">
								<% End If %>
									<!-- for dev msg : 1day -->
									<div class="label">
										<em><img src="http://webimage.10x10.co.kr/eventIMG/2017/75738/m/ico_label_oneday.png" alt="" /></em>
										<em class="time"  id="dtime">99:99:99</em>
									</div>
									<%
									'<!-- for dev msg : 
									'	썸네일 alt값은 넣어주지 마세요! alt=""
									'	썸네일 이미지 파일명은 날짜별로 작업해두었습니다.
									'	예) img_item_0130_01.png ~ img_item_0130_03.png
									'	2/3 금요일 이미지를 토,일까지 사용!
									'	http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_item_0130_01.png
									'-->
									%>
									<div class="figure"><img src="<%= todayImage1 %>" alt="" /></div>
									<div class="desc">
										<%'' for dev msg : 카피 %>
										<span class="copy"><%= todayItemcopy1 %></span>
										<%'' for dev msg : 상품명 %>
										<span class="name"><%= todayItemname1 %></span>
										<% if todaySalePrice1 = "" then %>
											<span class="price"><%= todayOrgPrice1 %>won</span>
										<% else %>
											<span class="price"><%= todaySalePrice1 %>won <i class="cRd1">[<%= todaySalePer1 %>]</i></span>
										<% end if %>
									</div>
									<div class="btnGet"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75738/m/btn_get.png" alt="구매하러 가기" /></div>
								</a>
							</div>
							<div class="swiper-slide">
								<% If isApp = 1 Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%= todayLinkItem2 %>'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=<%= todayLinkItem2 %>">
								<% End If %>
									<!-- for dev msg : best -->
									<div class="label">
										<em><img src="http://webimage.10x10.co.kr/eventIMG/2017/75738/m/ico_label_best.png" alt="Best" /></em>
									</div>
									<div class="figure"><img src="<%= todayImage2 %>" alt="" /></div>
									<div class="desc">
										<span class="copy"><%= todayItemcopy2 %></span>
										<span class="name"><%= todayItemname2 %></span>
										<% if todaySalePrice2 = "" then %>
											<span class="price"><%= todayOrgPrice2 %>won</span>
										<% else %>
											<span class="price"><%= todaySalePrice2 %>won <i class="cRd1">[<%= todaySalePer2 %>]</i></span>
										<% end if %>
									</div>
									<div class="btnGet"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75738/m/btn_get.png" alt="구매하러 가기" /></div>
								</a>
							</div>
							<div class="swiper-slide">
								<% If isApp = 1 Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%= todayLinkItem3 %>'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=<%= todayLinkItem3 %>">
								<% End If %>
									<!-- for dev msg : md pick -->
									<div class="label">
										<em><img src="http://webimage.10x10.co.kr/eventIMG/2017/75738/m/ico_label_md_pick.png" alt="Best" /></em>
									</div>
									<div class="figure"><img src="<%= todayImage3 %>" alt="" /></div>
									<div class="desc">
										<span class="copy"><%= todayItemcopy3 %></span>
										<span class="name"><%= todayItemname3 %></span>
										<% if todaySalePrice3 = "" then %>
											<span class="price"><%= todayOrgPrice3 %>won</span>
										<% else %>
											<span class="price"><%= todaySalePrice3 %>won <i class="cRd1">[<%= todaySalePer3 %>]</i></span>
										<% end if %>
									</div>
									<div class="btnGet"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75738/m/btn_get.png" alt="구매하러 가기" /></div>
								</a>
							</div>
						</div>
					</div>
					<div class="pagination"></div>
					<button type="button" class="btnNav btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75738/m/btn_prev.png" alt="이전" /></button>
					<button type="button" class="btnNav btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75738/m/btn_next.png" alt="다음" /></button>
				</div>
			</div>
		</div>

		<div class="sweetShop">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/75738/m/tit_sweet_shop.png" alt="Sweet Shop" /></h3>
			<% If isApp="1" Then %>
			<ul>
				<li><a href="/street/street_brand.asp?makerid=glasody" onclick="fnAPPpopupBrand('glasody'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_sweet_shop_01.png" alt="취향따라 고르는 글라소디" /></a></li>
				<li><a href="/street/street_brand.asp?makerid=cmix5040" onclick="fnAPPpopupBrand('cmix5040'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_sweet_shop_02.png" alt="달콤함이 가득한 세상 위니비니" /></a></li>
				<li><a href="/street/street_brand.asp?makerid=monster10" onclick="fnAPPpopupBrand('monster10'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_sweet_shop_03_v1.png" alt="초콜릿보다 다양한 스윗츠 쿠키몬스터파티셰리" /></a></li>
				<li><a href="/street/street_brand.asp?makerid=dechocolate" onclick="fnAPPpopupBrand('dechocolate'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_sweet_shop_04.png" alt="합리적인 수제초콜릿 디초콜릿 커피앤드" /></a></li>
			</ul>
			<% Else %>
			<ul>
				<li><a href="/street/street_brand.asp?makerid=glasody"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_sweet_shop_01.png" alt="취향따라 고르는 글라소디" /></a></li>
				<li><a href="/street/street_brand.asp?makerid=cmix5040"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_sweet_shop_02.png" alt="달콤함이 가득한 세상 위니비니" /></a></li>
				<li><a href="/street/street_brand.asp?makerid=monster10"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_sweet_shop_03_v1.png" alt="초콜릿보다 다양한 스윗츠 쿠키몬스터파티셰리" /></a></li>
				<li><a href="/street/street_brand.asp?makerid=dechocolate"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_sweet_shop_04.png" alt="합리적인 수제초콜릿 디초콜릿 커피앤드" /></a></li>
			</ul>
			<% End If %>
		</div>

		<div class="bnr">
			<ul>
				<li><a href="" onclick="goEventLink('75739'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_bnr_01.jpg" alt="재료선택부터 데코까지 직접 초콜릿 재료 기획전 보러가기" /></a></li>
				<li><a href="" onclick="goEventLink('75740'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75738/m/img_bnr_02.jpg" alt="반짝반짝,포장부터 반하도록 포장지&amp;카드 기획전 보러가기" /></a></li>
			</ul>
		</div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->