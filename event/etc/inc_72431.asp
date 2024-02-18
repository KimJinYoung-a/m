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
Dim eCode
Dim vTimerDate, nowDate, sNow
Dim todayLinkItem1, todayImage1, todayItemname1, todayOrgprice1, todaySalePrice1, todaySalePer1
Dim todayLinkItem2, todayImage2, todayItemname2, todayOrgprice2, todaySalePrice2, todaySalePer2
Dim todayLinkItem3, todayImage3, todayItemname3, todayOrgprice3, todaySalePrice3, todaySalePer3
Dim todayLinkItem4, todayImage4, todayItemname4, todayOrgprice4, todaySalePrice4, todaySalePer4
nowDate = date()
sNow = now()
'nowDate = "2016-08-22"
'sNow = "2016-08-22 " & Hour(now) & ":" & Minute(now) & ":" & Second(now)

Select Case nowDate
	Case "2016-08-22"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "710156"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0822_01.jpg"
		todayItemname1		= "효종원 오미자 수 100ml*30포"
		todayOrgprice1		= "39,000"
		todaySalePrice1		= "33,000"
		todaySalePer1		= "15%"

		todayLinkItem2		= "1548284"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0822_02.jpg"
		todayItemname2		= "풍성한병 500ml"
		todayOrgprice2		= "44,000"
		todaySalePrice2		= "22,000"
		todaySalePer2		= "50%"

		todayLinkItem3		= "1515949"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0822_03.jpg"
		todayItemname3		= "달지않은과자 정성세트"
		todayOrgprice3		= "50,500"
		todaySalePrice3		= "47,970"
		todaySalePer3		= "5%"

		todayLinkItem4		= "1506836"
		todayImage4			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0822_04.jpg"
		todayItemname4		= "프리미엄 향신료세트(총21종)"
		todayOrgprice4		= "49,400"
		todaySalePrice4		= "44,460"
		todaySalePer4		= "10%"
	Case "2016-08-23"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "1285004"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0823_01.jpg"
		todayItemname1		= "닥터넛츠 오리지널 뉴 30개입"
		todayOrgprice1		= "38,700"
		todaySalePrice1		= "29,900"
		todaySalePer1		= "23%"

		todayLinkItem2		= "1548284"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0823_02.jpg"
		todayItemname2		= "풍성한병 500ml"
		todayOrgprice2		= "44,000"
		todaySalePrice2		= "22,000"
		todaySalePer2		= "50%"

		todayLinkItem3		= "1515949"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0823_03.jpg"
		todayItemname3		= "달지않은과자 정성세트"
		todayOrgprice3		= "50,500"
		todaySalePrice3		= "47,970"
		todaySalePer3		= "5%"

		todayLinkItem4		= "1506836"
		todayImage4			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0823_04.jpg"
		todayItemname4		= "프리미엄 향신료세트(총21종)"
		todayOrgprice4		= "49,400"
		todaySalePrice4		= "44,460"
		todaySalePer4		= "10%"
	Case "2016-08-24"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "1101573"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0824_01.jpg"
		todayItemname1		= "반테이블감사세트"
		todayOrgprice1		= "27,000"
		todaySalePrice1		= "22,950"
		todaySalePer1		= "15%"

		todayLinkItem2		= "1544992"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0824_02.jpg"
		todayItemname2		= "ALOHWA 16' Special Gift"
		todayOrgprice2		= "46,000"
		todaySalePrice2		= "41,400"
		todaySalePer2		= "10%"

		todayLinkItem3		= "1547074"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0824_03.jpg"
		todayItemname3		= "인테이크 힘내 홍삼 젤리스틱"
		todayOrgprice3		= "36,000"
		todaySalePrice3		= "30,000"
		todaySalePer3		= "17%"

		todayLinkItem4		= "1526508"
		todayImage4			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0824_04.jpg"
		todayItemname4		= "약선 프리미엄 순수 배즙(30팩)"
		todayOrgprice4		= "27,000"
		todaySalePrice4		= "27,000"
		todaySalePer4		= "0%"
	Case "2016-08-25"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "1498378"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0825_01.jpg"
		todayItemname1		= "제주감귤파이(14개입)"
		todayOrgprice1		= "17,500"
		todaySalePrice1		= "10,900"
		todaySalePer1		= "38%"

		todayLinkItem2		= "1544992"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0825_02.jpg"
		todayItemname2		= "ALOHWA 16' Special Gift"
		todayOrgprice2		= "46,000"
		todaySalePrice2		= "41,400"
		todaySalePer2		= "10%"

		todayLinkItem3		= "1346988"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0825_03.jpg"
		todayItemname3		= "NEW 마이넛츠박스 선물세트2"
		todayOrgprice3		= "70,000"
		todaySalePrice3		= "42,900"
		todaySalePer3		= "39%"

		todayLinkItem4		= "1544879"
		todayImage4			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0825_04.jpg"
		todayItemname4		= "현미 연강정 선물세트 M"
		todayOrgprice4		= "25,000"
		todaySalePrice4		= "22,500"
		todaySalePer4		= "10%"
	Case "2016-08-26", "2016-08-27", "2016-08-28"
		vTimerDate			= DateAdd("d", 3, "2016-08-26")
		todayLinkItem1		= "1346981"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0826_01.jpg"
		todayItemname1		= "프리미엄 5종 견과 선물세트"
		todayOrgprice1		= "60,000"
		todaySalePrice1		= "39,900"
		todaySalePer1		= "34%"

		todayLinkItem2		= "1548287"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0826_02.jpg"
		todayItemname2		= "'풍성한 한가위' 수제잼 선물세트"
		todayOrgprice2		= "41,500"
		todaySalePrice2		= "37,350"
		todaySalePer2		= "10%"

		todayLinkItem3		= "1468740"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0826_03.jpg"
		todayItemname3		= "당산나무 집벌꿀 답례품 中 세트"
		todayOrgprice3		= "42,800"
		todaySalePrice3		= "40,660"
		todaySalePer3		= "5%"

		todayLinkItem4		= "1443838"
		todayImage4			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0826_04.jpg"
		todayItemname4		= "명품 소꼬리 선물세트(3kg)"
		todayOrgprice4		= "71,000"
		todaySalePrice4		= "59,000"
		todaySalePer4		= "17%"
	Case "2016-08-29"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "1313465"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0829_01.jpg"
		todayItemname1		= "더치팩 세트 30 (50mlx30포)"
		todayOrgprice1		= "39,000"
		todaySalePrice1		= "19,500"
		todaySalePer1		= "50%"

		todayLinkItem2		= "1515948"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0829_02.jpg"
		todayItemname2		= "달지않은과자 감사세트"
		todayOrgprice2		= "19,500"
		todaySalePrice2		= "17,550"
		todaySalePer2		= "10%"

		todayLinkItem3		= "1506839"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0829_03.jpg"
		todayItemname3		= "천연조미료 5종패키지 세트"
		todayOrgprice3		= "12,000"
		todaySalePrice3		= "10,800"
		todaySalePer3		= "10%"

		todayLinkItem4		= "1544877"
		todayImage4			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0829_04.jpg"
		todayItemname4		= "프리미엄 수삼선물세트 L"
		todayOrgprice4		= "256,000"
		todaySalePrice4		= "243,200"
		todaySalePer4		= "5%"
	Case "2016-08-30"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "1552453"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0830_01.jpg"
		todayItemname1		= "튜브허니 버라이어티 세트"
		todayOrgprice1		= "39,000"
		todaySalePrice1		= "35,000"
		todaySalePer1		= "10%"

		todayLinkItem2		= "1548284"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0830_02.jpg"
		todayItemname2		= "풍성한병 500ml"
		todayOrgprice2		= "44,000"
		todaySalePrice2		= "22,000"
		todaySalePer2		= "50%"

		todayLinkItem3		= "1502469"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0830_03.jpg"
		todayItemname3		= "리얼 바닐라 시럽"
		todayOrgprice3		= "36,000"
		todaySalePrice3		= "30,600"
		todaySalePer3		= "15%"

		todayLinkItem4		= "1548283"
		todayImage4			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0830_04.jpg"
		todayItemname4		= "정담 견과/전병 선물세트"
		todayOrgprice4		= "60,000"
		todaySalePrice4		= "42,900"
		todaySalePer4		= "29%"
	Case "2016-08-31"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "1553422"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0831_01.jpg"
		todayItemname1		= "인테이크 건강한 간식 선물세트"
		todayOrgprice1		= "49,900"
		todaySalePrice1		= "39,900"
		todaySalePer1		= "20%"

		todayLinkItem2		= "1544992"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0831_02.jpg"
		todayItemname2		= "ALOHWA 16' Special Gift"
		todayOrgprice2		= "46,000"
		todaySalePrice2		= "41,400"
		todaySalePer2		= "10%"

		todayLinkItem3		= "949487"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0831_03.jpg"
		todayItemname3		= "영국 무설탕 슈퍼잼 선물세트 3종"
		todayOrgprice3		= "39,000"
		todaySalePrice3		= "23,400"
		todaySalePer3		= "40%"

		todayLinkItem4		= "1521153"
		todayImage4			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0831_04.jpg"
		todayItemname4		= "오미베리 베리티(325ml*8병)"
		todayOrgprice4		= "24,000"
		todaySalePrice4		= "21,600"
		todaySalePer4		= "10%"
	Case "2016-09-01"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "1199854"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0901_01.jpg"
		todayItemname1		= "영귤선물세트B"
		todayOrgprice1		= "38,000"
		todaySalePrice1		= "30,400"
		todaySalePer1		= "20%"

		todayLinkItem2		= "1546789"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0901_02.jpg"
		todayItemname2		= "말랑하고 부드러운 전통수제강정"
		todayOrgprice2		= "15,500"
		todaySalePrice2		= "15,500"
		todaySalePer2		= "0%"

		todayLinkItem3		= "1253348"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0901_03.jpg"
		todayItemname3		= "마이빈스 더치한첩 (50mlx40포)"
		todayOrgprice3		= "55,000"
		todaySalePrice3		= "41,250"
		todaySalePer3		= "25%"

		todayLinkItem4		= "1549038"
		todayImage4			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0901_04.jpg"
		todayItemname4		= "[선데이스위츠] 수제 보석양갱 10구"
		todayOrgprice4		= "15,000"
		todaySalePrice4		= "13,500"
		todaySalePer4		= "10%"
	Case "2016-09-02", "2016-09-03", "2016-09-04"
		vTimerDate			= DateAdd("d", 3, "2016-09-02")
		todayLinkItem1		= "1468740"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0902_01.jpg"
		todayItemname1		= "당산나무 집벌꿀 답례품 中 세트"
		todayOrgprice1		= "42,800"
		todaySalePrice1		= "40,660"
		todaySalePer1		= "5%"

		todayLinkItem2		= "1553422"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0902_02.jpg"
		todayItemname2		= "인테이크 건강한 간식 선물세트"
		todayOrgprice2		= "49,900"
		todaySalePrice2		= "39,900"
		todaySalePer2		= "20%"

		todayLinkItem3		= "1423035"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0902_03.jpg"
		todayItemname3		= "감성고기 저지방숙성 등심"
		todayOrgprice3		= "39,900"
		todaySalePrice3		= "39,900"
		todaySalePer3		= "0%"

		todayLinkItem4		= "1421169"
		todayImage4			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0902_04.jpg"
		todayItemname4		= "해남참기름320ml +해남들기름320ml"
		todayOrgprice4		= "68,000"
		todaySalePrice4		= "61,200"
		todaySalePer4		= "10%"
	Case "2016-09-05"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "1548287"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0905_01.jpg"
		todayItemname1		= "'풍성한 한가위' 수제잼 선물세트"
		todayOrgprice1		= "41,500"
		todaySalePrice1		= "35,270"
		todaySalePer1		= "15%"

		todayLinkItem2		= "1553686"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0905_02.jpg"
		todayItemname2		= "반테이블 워터팩30days"
		todayOrgprice2		= "39,200"
		todaySalePrice2		= "35,280"
		todaySalePer2		= "10%"

		todayLinkItem3		= "1506836"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0905_03.jpg"
		todayItemname3		= "프리미엄 향신료세트(총21종)"
		todayOrgprice3		= "49,400"
		todaySalePrice3		= "44,460"
		todaySalePer3		= "10%"

		todayLinkItem4		= "1410217"
		todayImage4			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0905_04.jpg"
		todayItemname4		= "우드 패키지 수삼선물세트 L"
		todayOrgprice4		= "166,000"
		todaySalePrice4		= "157,700"
		todaySalePer4		= "5%"
	Case "2016-09-06"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "1417458"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0906_01.jpg"
		todayItemname1		= "[콜록콜록] 한첩 GIFT SET"
		todayOrgprice1		= "36,800"
		todaySalePrice1		= "31,280"
		todaySalePer1		= "15%"

		todayLinkItem2		= "1553422"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0906_02.jpg"
		todayItemname2		= "인테이크 건강한 간식 선물세트"
		todayOrgprice2		= "49,900"
		todaySalePrice2		= "36,500"
		todaySalePer2		= "27%"

		todayLinkItem3		= "1544880"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0906_03.jpg"
		todayItemname3		= "현미 연강정 & 정과 & 편강 선물세트L"
		todayOrgprice3		= "50,000"
		todaySalePrice3		= "50,000"
		todaySalePer3		= "0%"

		todayLinkItem4		= "1544876"
		todayImage4			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0906_04.jpg"
		todayItemname4		= "힘삼 홍삼청"
		todayOrgprice4		= "26,000"
		todaySalePrice4		= "23,400"
		todaySalePer4		= "10%"
	Case "2016-09-07"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "915263"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0907_01.jpg"
		todayItemname1		= "명품감말랭이 선물세트(100g×12봉)"
		todayOrgprice1		= "42,000"
		todaySalePrice1		= "26,900"
		todaySalePer1		= "36%"

		todayLinkItem2		= "1544992"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0907_02.jpg"
		todayItemname2		= "ALOHWA 16' Special Gift"
		todayOrgprice2		= "46,000"
		todaySalePrice2		= "41,400"
		todaySalePer2		= "10%"

		todayLinkItem3		= "1253348"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0907_03.jpg"
		todayItemname3		= "마이빈스 더치한첩 (50mlx40포)"
		todayOrgprice3		= "55,000"
		todaySalePrice3		= "41,250"
		todaySalePer3		= "25%"

		todayLinkItem4		= "1551323"
		todayImage4			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0907_04.jpg"
		todayItemname4		= "6종 과일칩 선물세트_M"
		todayOrgprice4		= "48,000"
		todaySalePrice4		= "43,200"
		todaySalePer4		= "10%"
	Case "2016-09-08"
		vTimerDate			= DateAdd("d", 1, nowDate)
		todayLinkItem1		= "1536907"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0908_01.jpg"
		todayItemname1		= "인테이크 힘내! 홍삼구미"
		todayOrgprice1		= "25,000"
		todaySalePrice1		= "15,000"
		todaySalePer1		= "40%"

		todayLinkItem2		= "1515949"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0908_02.jpg"
		todayItemname2		= "달지않은과자 보름달세트"
		todayOrgprice2		= "50,500"
		todaySalePrice2		= "47,970"
		todaySalePer2		= "5%"

		todayLinkItem3		= "1549043"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0908_03.jpg"
		todayItemname3		= "꿀.건.달 벌꿀 4종 선물세트"
		todayOrgprice3		= "66,000"
		todaySalePrice3		= "59,400"
		todaySalePer3		= "10%"

		todayLinkItem4		= "1338234"
		todayImage4			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0908_04.jpg"
		todayItemname4		= "클래식 사과 보자기선물세트"
		todayOrgprice4		= "48,000"
		todaySalePrice4		= "45,600"
		todaySalePer4		= "5%"
	Case "2016-09-09", "2016-09-10", "2016-09-11"
		vTimerDate			= DateAdd("d", 3, "2016-09-09")
		todayLinkItem1		= "1426866"
		todayImage1			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0909_01.jpg"
		todayItemname1		= "허브차 3종 선물세트"
		todayOrgprice1		= "25,500"
		todaySalePrice1		= "21,670"
		todaySalePer1		= "15%"

		todayLinkItem2		= "1544992"
		todayImage2			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0909_02.jpg"
		todayItemname2		= "ALOHWA 16' Special Gift"
		todayOrgprice2		= "46,000"
		todaySalePrice2		= "41,400"
		todaySalePer2		= "10%"

		todayLinkItem3		= "1420154"
		todayImage3			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0909_03.jpg"
		todayItemname3		= "슈퍼잼2종 선물세트-유니언잭"
		todayOrgprice3		= "26,000"
		todaySalePrice3		= "15,600"
		todaySalePer3		= "40%"

		todayLinkItem4		= "1553170"
		todayImage4			= "http://webimage.10x10.co.kr/eventIMG/2016/72431/img_item_0909_04.jpg"
		todayItemname4		= "닥터넛츠 효도견과 선물세트"
		todayOrgprice4		= "45,000"
		todaySalePrice4		= "38,900"
		todaySalePer4		= "14%"
End Select


IF application("Svr_Info") = "Dev" THEN
	eCode 		= "66183"
Else
	eCode 		= "72431"
End If
%>
<style type="text/css">
img {vertical-align:top;}

.chuseok {background-color:#faecc0;}
.chuseok button {background-color:transparent;}

.rollingWrap {position:relative; background-color:#f8ebc0;}
.rolling {position:absolute; top:0; left:50%; width:84%; margin-left:-42%;}
.rolling .swiper {position:relative; padding-top:4%; padding-bottom:4.6%;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .swiper .swiper-slide {padding:0 5.94%; text-align:center;}
.rolling .swiper .swiper-slide a {display:block;}
.rolling .swiper .swiper-slide .bg {position:absolute; top:-3%; left:50%; width:98.6%; margin-left:-48.4%;}
.rolling .swiper .swiper-slide .bg img {border-radius:0;}
.rolling .swiper .swiper-slide .figure {overflow:hidden; position:relative; border-radius:50%;}
.rolling .swiper .swiper-slide .figure img {border-radius:50%;}
.rolling .swiper .swiper-slide .label {position:absolute; top:0; right:0; z-index:5; width:28.62%;}
.rolling .swiper .swiper-slide span {display:block;}
.rolling .swiper .swiper-slide .name {overflow:hidden; height:1.3rem; margin-top:10%; padding:0 1.6rem; font-size:1.3rem; font-weight:bold; text-overflow:ellipsis; white-space:nowrap;}
.rolling .swiper .swiper-slide .price {margin-top:0.7rem; font-weight:bold;}
.rolling .swiper .swiper-slide .price s {color:#646464; font-size:1.3rem;}
.rolling .swiper .swiper-slide .price b {color:#d60000; font-size:1.6rem;}
.rolling .swiper .swiper-slide .price .black {color:#000;}
.rolling .swiper .swiper-slide .btnGet {width:67.2%; margin:6.5% auto 0;}
.rolling .swiper .swiper-slide .time {position:absolute; bottom:0; left:0; width:100%; height:5rem; padding-top:0.7rem; background-color:rgba(0, 0, 0, 0.65);}
.rolling .swiper .swiper-slide .time strong {padding-left:1.4rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/72431/img_watch.png) no-repeat 0 50%; background-size:1.1rem 1.1rem; color:#f8eabf;}
.rolling .swiper .swiper-slide .time .timer {margin-top:0.5rem; color:#fff; font-size:1.6rem;}
.rolling .swiper .swiper-slide .time .timer span, .rolling .swiper .swiper-slide .time .timer i {display:inline; margin:0 -2px;}
.rolling button {position:absolute; top:30%; z-index:20; width:10.96%; background-color:transparent;}
.rolling .swiper .btn-prev {left:-9%;}
.rolling .swiper .btn-next {right:-9%;}
.rolling .swiper .pagination {position:absolute; bottom:0; left:0; z-index:10; width:100%; height:auto; padding-top:0; text-align:center;}
.rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; position:relative; width:6px; height:6px; margin:0 0.9rem; border:2px solid #fff; background-color:transparent; cursor:pointer;}

.rolling .swiper .pagination .swiper-pagination-switch {transform-style:preserve-3d; transition:transform 0.6s ease, opacity 0.6s ease; -webkit-transform-style:preserve-3d; -webkit-transition:-webkit-transform 0.6s ease, opacity 0.6s ease;}
.rolling .swiper .pagination .swiper-active-switch {border:2px solid #cab782; background-color:#cab782; transform rotateY(180deg); -webkit-transform:rotateY(180deg);}
@media all and (min-width:360px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:8px; height:8px;}
}
@media all and (min-width:480px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:10px; height:10px;}
}
@media all and (min-width:768px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:14px; height:14px;}
}

.bnr {background-color:#f4f7f7; padding:3% 0 6%;}
.bnr ul {overflow:hidden; margin:0 -3%;}
.bnr ul li {float:left; width:50%; margin-top:3%;}
.bnr ul li a {display:block; margin:0 3%;}

.commentevt {background-color:#f4f7f7;}
.commentevt .fold {position:relative;}
.commentevt .after {padding-bottom:10%;}
.commentevt .after .btnMore {position:absolute; bottom:-8%; left:0; width:100%;}
.commentevt .after .btnMore button {width:100%;}
.commentevt .before {display:none; margin-top:-21%;}
.commentevt .before .btnEvent {position:absolute; bottom:17%; left:50%; width:56.56%; margin-left:-28.28%;}
.commentevt .before .btnClose {position:absolute; right:0; bottom:4%; width:18.125%;}
</style>
<script type="text/javascript">
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
		$(".time .timer span").html("0");
		return;
	}

	if(dhour < 10) dhour = "0" + dhour;
	if(dmin < 10) dmin = "0" + dmin;
	if(dsec < 10) dsec = "0" + dsec;
	dhour = dhour+'';
	dmin = dmin+'';
	dsec = dsec+'';

	// Print Time
	$("#j1dRmH1").html(dhour.substr(0,1));
	$("#j1dRmH2").html(dhour.substr(1,1));
	$("#j1dRmM1").html(dmin.substr(0,1));
	$("#j1dRmM2").html(dmin.substr(1,1));
	$("#j1dRmS1").html(dsec.substr(0,1));
	$("#j1dRmS2").html(dsec.substr(1,1));
	
	minus_second = minus_second + 1;

	if (( String(dhour) == '00' ) && ( String(dmin) == '00' ) && ( String(dsec) == '00' )) {
		document.location.reload();
	}else{
		setTimeout("countdown()",1000)
	}
}
</script>

<div class="mEvt72431 chuseok">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/txt_chuseok_v1.jpg" alt="밝은 달 아래, 추석의 설렘은 풍요로운 먹거리로부터" /></h2>
<%' for dev msg : 
'	오늘의 특가선물 : ico_label_01.png
'	텐바이텐 단독선물 : ico_label_02.png
'	베스트 셀러 : ico_label_03.png
'	엠디 추천선물 : ico_label_04.png
'
'	날짜별 상품이미지는 img_item_0822_01.jpg ~ 04.jpg입니다.
'	금, 토, 일은 금요일 상품이미지로 해주세요!
%>
	<div class="rollingWrap">
		<div id="rolling" class="rolling">
			<div class="swiper">
				<div class="swiper-container swiper">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
						<% If isApp = 1 Then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%= todayLinkItem1 %>'); return false;">
						<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=<%= todayLinkItem1 %>">
						<% End If %>
								<div class="bg"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/bg_frame.png" alt="" /></div>
								<em class="label"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/ico_label_01.png" alt="오늘의 특가선물" /></em>
								<div class="figure">
									<%' for dev msg : 이미지 alt값 생략해주세요 %>
									<img src="<%= todayImage1 %>" alt="" />
									<div class="time">
										<strong>남은시간</strong>
										<div class="timer">
											<span id="j1dRmH1">9</span>
											<span id="j1dRmH2" class="left">9</span>
											<i>:</i>
											<span id="j1dRmM1">9</span>
											<span id="j1dRmM2" class="left">9</span>
											<i>:</i>
											<span id="j1dRmS1">9</span>
											<span id="j1dRmS2" class="left">9</span>
										</div>
									</div>
								</div>
								<span class="name"><%= todayItemname1 %></span>
								<span class="price"><s><%= todayOrgprice1 %>원</s> <b><%= todaySalePrice1 %>원 [<%= todaySalePer1 %>]</b></span>
								<div class="btnGet"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/btn_get.png" alt="구매하러 가기" /></div>
							</a>
						</div>
						<div class="swiper-slide">
						<% If isApp = 1 Then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%= todayLinkItem2 %>'); return false;">
						<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=<%= todayLinkItem2 %>">
						<% End If %>
								<div class="bg"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/bg_frame.png" alt="" /></div>
								<em class="label"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/ico_label_02.png" alt="텐바이텐 단독선물" /></em>
								<div class="figure"><img src="<%= todayImage2 %>" alt="" /></div>
								<span class="name"><%= todayItemname2 %></span>
							<% If nowDate = "2016-09-01" Then %>
								<span class="price"><b class="black"><%= todaySalePrice2 %>원</b></span>
							<% Else %>
								<span class="price"><s><%= todayOrgprice2 %>원</s> <b><%= todaySalePrice2 %>원 [<%= todaySalePer2 %>]</b></span>
							<% End If %>
								<div class="btnGet"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/btn_get.png" alt="구매하러 가기" /></div>
							</a>
						</div>
						<div class="swiper-slide">
						<% If isApp = 1 Then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%= todayLinkItem3 %>'); return false;">
						<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=<%= todayLinkItem3 %>">
						<% End If %>
								<div class="bg"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/bg_frame.png" alt="" /></div>
								<em class="label"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/ico_label_03.png" alt="베스트 셀러" /></em>
								<div class="figure"><img src="<%= todayImage3 %>" alt="" /></div>
								<span class="name"><%= todayItemname3 %></span>
							<% If (nowDate = "2016-09-02") OR (nowDate = "2016-09-03") OR (nowDate = "2016-09-04") OR (nowDate = "2016-09-06") Then %>
								<span class="price"><b class="black"><%= todaySalePrice3 %>원</b></span>
							<% Else %>
								<span class="price"><s><%= todayOrgprice3 %>원</s> <b><%= todaySalePrice3 %>원 [<%= todaySalePer3 %>]</b></span>
							<% End If %>
								<div class="btnGet"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/btn_get.png" alt="구매하러 가기" /></div>
							</a>
						</div>
						<div class="swiper-slide">
						<% If isApp = 1 Then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%= todayLinkItem4 %>'); return false;">
						<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=<%= todayLinkItem4 %>">
						<% End If %>
								<div class="bg"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/bg_frame.png" alt="" /></div>
								<em class="label"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/ico_label_04.png" alt="엠디 추천선물" /></em>
								<div class="figure"><img src="<%= todayImage4 %>" alt="" /></div>
								<span class="name"><%= todayItemname4 %></span>
							<% If nowDate = "2016-08-24" Then %>
								<span class="price"><b class="black"><%= todaySalePrice4 %>원</b></span>
							<% Else %>
								<span class="price"><s><%= todayOrgprice4 %>원</s> <b><%= todaySalePrice4 %>원 [<%= todaySalePer4 %>]</b></span>
							<% End If %>
								<div class="btnGet"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/btn_get.png" alt="구매하러 가기" /></div>
							</a>
						</div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/btn_prev.png" alt="이전" /></button>
				<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/btn_next.png" alt="다음" /></button>
			</div>
		</div>
		<img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/bg_paper_v2.jpg" alt="" />
	</div>

	<div class="bnr">
		<ul>
			<li><a href="eventmain.asp?eventid=72432"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/img_bnr_01.jpg" alt="건강간식 견과류 기획전 보러가기" /></a></li>
			<li><a href="eventmain.asp?eventid=72433"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/img_bnr_02.jpg" alt="명절엔 곶감 기획전 보러가기" /></a></li>
			<li><a href="eventmain.asp?eventid=72434"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/img_bnr_03.jpg" alt="추석 다과 백서 기획전 보러가기" /></a></li>
			<li><a href="eventmain.asp?eventid=72610"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/img_bnr_04_v1.jpg" alt="명절 준비 시작! 요리가 쉬어진다 기획전 보러가기" /></a></li>
		</ul>
	</div>

	<div id="commentevt" class="commentevt">
		<div class="fold after">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/txt_comment_event_01_v1.jpg" alt="가족의 행복한 다과상을 만들어 드립니다." /></p>
			<div class="btnMore">
				<button type="button"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/btn_more_v1.png" alt="자세히 보기" /></button>
			</div>
		</div>
		<div class="fold before">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/txt_comment_event_02.png" alt="이번 추석, 가족들과 어떤 이야기를 나누고 싶으신가요? 정성껏 코멘트를 남겨주신 8분을 추첨하여 텐바이텐이 정성껏 고른 선물을 달지 않은 과자 감사세트 2명, 알로화 스페셜 기프트 1명, 마이빈스 풍성한병 5명께 드립니다. 코멘트 작성 기간은 2016년 8월 22일부터 9월 1일까지며, 당첨자 발표는 9월 2일입니다." /></p>
			<a href="#replyList" class="btnEvent"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/btn_comment_event.png" alt="이벤트 참여하기" /></a>
			<button type="button" class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72431/btn_close.png" alt="접기" /></button>
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	/* swiper js */
	countdown();
	mySwiper = new Swiper("#rolling .swiper-container",{
		autoplay:2500,
		speed:800,
		pagination:"#rolling .pagination",
		paginationClickable:true,
		prevButton:'#rolling .btn-prev',
		nextButton:'#rolling .btn-next'
	});

	$("#commentevt .before").hide();
	$("#commentevt .btnMore").click(function(event){
		$("#commentevt .before").show();
	});
	$("#commentevt .btnClose").click(function(event){
		$("#commentevt .before").hide();
	});

	/* skip to comment */
	$("#commentevt .btnEvent").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},800);
	});
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->