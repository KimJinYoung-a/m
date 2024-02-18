//var apiurl = "http://testfapi.10x10.co.kr:8080/api/web/v1";
var apiurl = "http://localhost:8080/api/web/v1";
var categories_dataurl = apiurl + "/search/main/";
// Decode Base64
function decodeBase64(str) {
    return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
}
String.prototype.replaceAll = function(searchStr, replaceStr) {
    return this.split(searchStr).join(replaceStr);
}

var store = new Vuex.Store({
    state : {
        params : { // 파라미터
            keyword: '스누피'
        },
        options : { // 옵션
            
        },
        reviews : [
          {
            "idx": 8335562,
            "item_id": 2542004,
            "item_name": "스누피 캘린더 캐시북 2020",
            "content": "탁상달력 고민하다가 스누피 귀여워서 구매했어요. 달력이 너무 귀여워요ㅠ 매월 디자인 달라서 이뿌네요. 뒷면은 가계부라 넘 유용한거 같아요ㅎㅎ 근데 이 투명한 스누피 스티커같은건..스티커인줄 알았는데 눌러봐도 뭔가 스티커 뗄 가장자리가 안보이네요. 읭?ㅋㅋ 아무래도 스티커가 아니었나봐요ㅋㅋㅋ좀 더 살펴봐야겠어요. 달력은 2019년 12월부터 있어서 좋네요. 바로 사용 가능해요ㅎㅎ",
            "review_images": null,
            "item_image": "aHR0cDovL3RodW1ibmFpbC4xMHgxMC5jby5rci93ZWJpbWFnZS9pbWFnZS9iYXNpYy8yNTQvQjAwMjU0MjAwNC0yLmpwZz9jbWQ9dGh1bWImZml0PXRydWUmd3M9ZmFsc2Umdz02MDAmd2g9NjAw",
            "user_id": "pbr08**",
            "total_point": 5,
            "move_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL2NhdGVnb3J5L2NhdGVnb3J5X2l0ZW1QcmQuYXNwP2l0ZW1pZD0yNTQyMDA0",
            "sell_yn": "N",
            "more_view_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL2NvbW1vbi9Qb3BJdGVtRXZhbHVhdGUuYXNwP2l0ZW1pZD0yNTQyMDA0"
          },
          {
            "idx": 8840281,
            "item_id": 2706808,
            "item_name": "[Peanuts] 스누피 백팩_블랙",
            "content": "가방 엄청 귀여움!! 일단 제일 마음에 드는건 크기! 딱 적당함! 노트북 15인치쓰는데 안에 노트북 넣는 공간에 넉넉히 들어가고, 내 생각에 더 큰 사이즈 노트북도 들어갈듯! 가방 앞에 주머니 많고 안 주머니도 있어서 수납공간 완전 많음ㅎ 그리고 작은 스누피 주머니 달랑거리는데 완전 귀여움ㅠㅠ 진짜 대만족이에여ㅠㅠ",
            "review_images": null,
            "item_image": "aHR0cDovL3RodW1ibmFpbC4xMHgxMC5jby5rci93ZWJpbWFnZS9pbWFnZS90ZW50ZW4vMjcwL1QwMDI3MDY4MDguanBnP2NtZD10aHVtYiZmaXQ9dHJ1ZSZ3cz1mYWxzZSZ3PTYwMCZ3aD02MDA",
            "user_id": "bumblebe**",
            "total_point": 5,
            "move_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL2NhdGVnb3J5L2NhdGVnb3J5X2l0ZW1QcmQuYXNwP2l0ZW1pZD0yNzA2ODA4",
            "sell_yn": "N",
            "more_view_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL2NvbW1vbi9Qb3BJdGVtRXZhbHVhdGUuYXNwP2l0ZW1pZD0yNzA2ODA4"
          },
          {
            "idx": 9024290,
            "item_id": 2597804,
            "item_name": "[PEANUTS] MUG CUP WITH FIGURE 4종",
            "content": "큽 ㅜㅜㅜ 진. 짜. 귀. 여. 워. 요. !!!!! 사실 구입한 바로 다음날에 세일이벤트해서ㅠㅠ 아깝고안타까웠는데??보자마자 그런 생각이 사라져요 헉.. ㅜㅜㅜㅜ\r\n색도 너무 예쁘고ㅜㅜㅜ 옆에 스누피가 쿠키 찾고있는것도 귀여운데 ㅋㅋㅋㅋ 컵안에 쿠키있는것도 귀여워요 ㅋㅋㅋㅋ빨강색 재입고되면 빨강도 데리고오게요.. 아쉬운건 손잡이 옆에 찍힌 자국이있네요ㅠㅠㅠ 잘 검수해서 예쁜 컵으로 보내주세요 ㅠㅠ 깨진건 아니라서 잘 쓰려구요~너무 귀여워요ㅜㅜ 다른색 재입고도 얼릉 부탁드려봅니다??",
            "review_images": [
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzI1OS9TQjIwMjAwNDA4MDI1NDAwLmpwZWcvMTB4MTAvcmVzaXplLzYwMHgvcXVhbGl0eS85NS8",
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzI1OS9TQjIwMjAwNDA4MDI1NDA5LmpwZWcvMTB4MTAvcmVzaXplLzYwMHgvcXVhbGl0eS85NS8",
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzI1OS9TQjIwMjAwNDA4MDI1NDE2LmpwZWcvMTB4MTAvcmVzaXplLzYwMHgvcXVhbGl0eS85NS8"
            ],
            "item_image": "aHR0cDovL3RodW1ibmFpbC4xMHgxMC5jby5rci93ZWJpbWFnZS9pbWFnZS90ZW50ZW4vMjU5L1QwMDI1OTc4MDQtMy5qcGc_Y21kPXRodW1iJmZpdD10cnVlJndzPWZhbHNlJnc9NjAwJndoPTYwMA",
            "user_id": "gpals**",
            "total_point": 5,
            "move_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL2NhdGVnb3J5L2NhdGVnb3J5X2l0ZW1QcmQuYXNwP2l0ZW1pZD0yNTk3ODA0",
            "sell_yn": "S",
            "more_view_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL2NvbW1vbi9Qb3BJdGVtRXZhbHVhdGUuYXNwP2l0ZW1pZD0yNTk3ODA0"
          },
          {
            "idx": 8805774,
            "item_id": 2706808,
            "item_name": "[Peanuts] 스누피 백팩_블랙",
            "content": "솔직한 리뷰 시작할게. 받기 전에 기대를 많이 했는데 막상 받으니 상상이상으로 좋아. 앞쪽 메쉬포켓은 티 안 나게 자랑하고 싶은 거 넣기 너무 딱이야. 보조 주머니(?)에는 아침에 맨날 까먹고 학교 가는 도중에 생각 나는 학생증이 쏙 들어갈 만큼 적당해. 3번째 사진 봐봐 저렇게 넣고도 교과서 3개 더 들어간다면 말 끝났지^!^ 안쪽에 아이패드가 들어가고도 널널해. 노트북은 딱 맞는 패딩 입은 거 같을 거야. 마지막으로 한마디 하겠어. 아이스티만 새 학기 필수템이 아니야 스누피 엽서가 보이는 스누피 가방까지 있어야 학교를 장악할 인싸될 완벽한 준비를 마쳤다 볼 수 있어.솔직히 중학생보다는 고등학생한테 추천해^^. 이 정도 했으면 이미 머릿속에선 결제창을 누르고 있을 거야 (찡긋-☆)",
            "review_images": [
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzI3MC9BX0VGNzc1N0M4RkQwNzRDRTc5M0Q5RThCNzJBMjZGODU1XzI3MDY4MDguanBnLzEweDEwL3Jlc2l6ZS82MDB4L3F1YWxpdHkvOTUv",
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzI3MC9CX0IzNzFFQTA4MTk2NDQ0MUQ5QjUzOUM4OUUyOTczREVFXzI3MDY4MDguanBnLzEweDEwL3Jlc2l6ZS82MDB4L3F1YWxpdHkvOTUv",
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzI3MC9CXzBCODI1QTVCOEJBRTREMzVBOUEzN0ZCMEFDNDc4ODY5XzI3MDY4MDguanBnLzEweDEwL3Jlc2l6ZS82MDB4L3F1YWxpdHkvOTUv"
            ],
            "item_image": "aHR0cDovL3RodW1ibmFpbC4xMHgxMC5jby5rci93ZWJpbWFnZS9pbWFnZS90ZW50ZW4vMjcwL1QwMDI3MDY4MDguanBnP2NtZD10aHVtYiZmaXQ9dHJ1ZSZ3cz1mYWxzZSZ3PTYwMCZ3aD02MDA",
            "user_id": "hoyeonby**",
            "total_point": 5,
            "move_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL2NhdGVnb3J5L2NhdGVnb3J5X2l0ZW1QcmQuYXNwP2l0ZW1pZD0yNzA2ODA4",
            "sell_yn": "Y",
            "more_view_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL2NvbW1vbi9Qb3BJdGVtRXZhbHVhdGUuYXNwP2l0ZW1pZD0yNzA2ODA4"
          },
          {
            "idx": 6169510,
            "item_id": 1494880,
            "item_name": "PEANUTS : MY BUSY BOOKS",
            "content": "좋아요!!\r\n책만 봐도 예쁘고 피규어도 너무 예뻐요.ㅎ\r\n피규어가 살짝 (스누피!!) 아쉬운 부분도 있긴한데...\r\n가격 생각하면 너무 만족스러워요.^^\r\n종류가 여러가지 있는데 하나 사보고 괜찮다 싶으면 다른것도 구입하려고\r\n맛보기로 구입한거였는데! 다른 종류도 몇개 더 구입할거예욥!!\r\n소장용으로도 괜찮고 선물용으로도 너무 좋습니다.",
            "review_images": [
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzE0OS9BNjE2OTUxMF8xNDk0ODgwLmpwZy8xMHgxMC9yZXNpemUvNjAweC9xdWFsaXR5Lzk1Lw",
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzE0OS9CNjE2OTUxMF8xNDk0ODgwLmpwZy8xMHgxMC9yZXNpemUvNjAweC9xdWFsaXR5Lzk1Lw",
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzE0OS9DNjE2OTUxMF8xNDk0ODgwLmpwZy8xMHgxMC9yZXNpemUvNjAweC9xdWFsaXR5Lzk1Lw"
            ],
            "item_image": "aHR0cDovL3RodW1ibmFpbC4xMHgxMC5jby5rci93ZWJpbWFnZS9pbWFnZS9iYXNpYy8xNDkvQjAwMTQ5NDg4MC5qcGc_Y21kPXRodW1iJmZpdD10cnVlJndzPWZhbHNlJnc9NjAwJndoPTYwMA",
            "user_id": "cool**",
            "total_point": 5,
            "move_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL2NhdGVnb3J5L2NhdGVnb3J5X2l0ZW1QcmQuYXNwP2l0ZW1pZD0xNDk0ODgw",
            "sell_yn": "N",
            "more_view_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL2NvbW1vbi9Qb3BJdGVtRXZhbHVhdGUuYXNwP2l0ZW1pZD0xNDk0ODgw"
          },
          {
            "idx": 8973427,
            "item_id": 2706808,
            "item_name": "[Peanuts] 스누피 백팩_블랙",
            "content": "너무 사랑스러워서 안살수가 없었어요♡\r\n이미 큰 백팩이 3개나 있지만.. 블랙컬러는\r\n없다며 핑계삼아 질러버렸습니다!! (훗)\r\n\r\n세트인 파우치도 너무 귀엽고... 사진처럼\r\n뱃찌도 달고싶어서 같이 구매해줬어요\r\n\r\n이젠 학생도 아니고 솔직히 직장다니면서\r\n백팩 사용할 일이 거의 없는데. 여행다닐때\r\n사용해주려구요 (그냥 보고있어도 힐링)\r\n\r\n깔끔한 블랙이라 더 좋아요♡ 굿♡",
            "review_images": [
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzI3MC9BXzNGNEVDRTg5N0NDRTRGMjRCRjc1NzFEQjEzMTk5OTc3XzI3MDY4MDguanBnLzEweDEwL3Jlc2l6ZS82MDB4L3F1YWxpdHkvOTUv",
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzI3MC9CXzM1NTIyQ0UwNTc5RjQzRDg5RTEwQ0IwQTM4OUVBMEQ3XzI3MDY4MDguanBnLzEweDEwL3Jlc2l6ZS82MDB4L3F1YWxpdHkvOTUv",
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzI3MC9CX0NFNzY0MkFDMzkxRDQ5MDhCRThDNEJEMEE5RkU1RkUxXzI3MDY4MDguanBnLzEweDEwL3Jlc2l6ZS82MDB4L3F1YWxpdHkvOTUv"
            ],
            "item_image": "aHR0cDovL3RodW1ibmFpbC4xMHgxMC5jby5rci93ZWJpbWFnZS9pbWFnZS90ZW50ZW4vMjcwL1QwMDI3MDY4MDguanBnP2NtZD10aHVtYiZmaXQ9dHJ1ZSZ3cz1mYWxzZSZ3PTYwMCZ3aD02MDA",
            "user_id": "noircielch**",
            "total_point": 5,
            "move_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL2NhdGVnb3J5L2NhdGVnb3J5X2l0ZW1QcmQuYXNwP2l0ZW1pZD0yNzA2ODA4",
            "sell_yn": "Y",
            "more_view_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL2NvbW1vbi9Qb3BJdGVtRXZhbHVhdGUuYXNwP2l0ZW1pZD0yNzA2ODA4"
          },
          {
            "idx": 8970351,
            "item_id": 2730081,
            "item_name": "[Peanuts] 월간 스누피 첫번째 이야기 세트",
            "content": "사진찍을 욕구가 샘솟는 세트에여ㅕㅕ\r\n펜홀더사진은 못찍었지만 실물완전 이뻐여ㅜ 스누피 표정 진짜 어쩔꺼냐며. 흰솜뭉탱이 같으니라구!! 찰리 펜홀더도 탐나눈데ㅜㅜ하...\r\n 주말 스누피 홈카페 오픈할라구여. 유리컵은 레트로 느낌나게 묵직하니   이런느낌 좋은데여?? 스누피명언도 유명한데 컵에 들어간 디자인, 노트랑 어울려서 짱조아여ㅕㅎ헿ㅎ노트 색감이랑.... 캐릭터랑.. 진짜 맘에 들어여. 몇달뒤 또 나올거니까 지금 열심히 만드시는 중이겠져? 기대할게영ㅇㅇㅋㅋㅋㅋ",
            "review_images": [
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzI3My9TQjIwMjAwNDAyMjE1OTA5LmpwZWcvMTB4MTAvcmVzaXplLzYwMHgvcXVhbGl0eS85NS8",
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzI3My9TQjIwMjAwNDAyMjE1OTE4LmpwZWcvMTB4MTAvcmVzaXplLzYwMHgvcXVhbGl0eS85NS8",
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzI3My9TQjIwMjAwNDAyMjE1OTI2LmpwZWcvMTB4MTAvcmVzaXplLzYwMHgvcXVhbGl0eS85NS8"
            ],
            "item_image": "aHR0cDovL3RodW1ibmFpbC4xMHgxMC5jby5rci93ZWJpbWFnZS9pbWFnZS90ZW50ZW4vMjczL1QwMDI3MzAwODEuanBnP2NtZD10aHVtYiZmaXQ9dHJ1ZSZ3cz1mYWxzZSZ3PTYwMCZ3aD02MDA",
            "user_id": "d2**",
            "total_point": 5,
            "move_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL2NhdGVnb3J5L2NhdGVnb3J5X2l0ZW1QcmQuYXNwP2l0ZW1pZD0yNzMwMDgx",
            "sell_yn": "Y",
            "more_view_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL2NvbW1vbi9Qb3BJdGVtRXZhbHVhdGUuYXNwP2l0ZW1pZD0yNzMwMDgx"
          },
          {
            "idx": 9028394,
            "item_id": 2689530,
            "item_name": "[Peanuts] 트윈링노트 _ 유선",
            "content": "독서하는 스누피랑 같이 낚시하는 스누피도 샀는데 둘 다 만족합니다 ㅎㅎㅎ\r\n하드커버 내부가 파란색이라 좋아요! 시원해보이고 스누피 그림이랑 잘 어울려요\r\n독서하는 스누피 후기에 비침테스트를 해봤는데 그 사진을 가져왔어요!\r\n맨 마지막 사진 보면 볼펜이랑 형광펜을 썼는데 잘 안 비쳐요!! 종이 재질이 좋은 건지 그렇게 두껍다는 생각은 안 했는데 잘 안 비치더라고요? 신기했어요\r\n흰색이라 질리지도 않을 것 같고 넘 기엽꼬.. 좋아요! 오래오래 팔아주세요ㅠㅠ 이것도 다 쓰면 또 사러 올게요 ㅜㅜ",
            "review_images": [
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzI2OC9TQjIwMjAwNDA4MTI1NTM1LmpwZWcvMTB4MTAvcmVzaXplLzYwMHgvcXVhbGl0eS85NS8",
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzI2OC9TQjIwMjAwNDA4MTI1NTQ1LmpwZWcvMTB4MTAvcmVzaXplLzYwMHgvcXVhbGl0eS85NS8",
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzI2OC9TQjIwMjAwNDA4MTI1NjAwLmpwZWcvMTB4MTAvcmVzaXplLzYwMHgvcXVhbGl0eS85NS8"
            ],
            "item_image": "aHR0cDovL3RodW1ibmFpbC4xMHgxMC5jby5rci93ZWJpbWFnZS9pbWFnZS90ZW50ZW4vMjY4L1QwMDI2ODk1MzAuanBnP2NtZD10aHVtYiZmaXQ9dHJ1ZSZ3cz1mYWxzZSZ3PTYwMCZ3aD02MDA",
            "user_id": "jang920**",
            "total_point": 5,
            "move_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL2NhdGVnb3J5L2NhdGVnb3J5X2l0ZW1QcmQuYXNwP2l0ZW1pZD0yNjg5NTMw",
            "sell_yn": "Y",
            "more_view_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL2NvbW1vbi9Qb3BJdGVtRXZhbHVhdGUuYXNwP2l0ZW1pZD0yNjg5NTMw"
          },
          {
            "idx": 8198622,
            "item_id": 2530059,
            "item_name": "[Peanuts] 허그머그_3종세트",
            "content": "생각했던 것 만큼 아주아주 고급진 느낌은 아녔지만..^^;;;\r\n\r\n세일 할 때 좋은 가격에 겟 할 수 있어서 넘넘 좋았네요~\r\n\r\n오랜 스누피 덕후라..ㅠㅠ\r\n\r\n근데, \r\n다른거 이리저리 고르다가 \r\n텐텐이 기념컵인 빨강 머그를 놓쳐서 넘 아쉬워요..ㅠㅠ\r\n(그건 따로 판매조차 안하는 거라..;;;)\r\n\r\n빨강이까지 함께하면 더 완벽한 조합이 될 듯 싶네요~\r\n\r\n살짝 톤다운된 앤틱 머그라 더 소장가치 뿜뿜~★",
            "review_images": [
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzI1My9BX0JBN0VDODE0Rjg5QzQ0NEQ5NTU2OTdENzczOTkxNjFEXzI1MzAwNTkuanBnLzEweDEwL3Jlc2l6ZS82MDB4L3F1YWxpdHkvOTUv",
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzI1My9CXzlGMUY4OEI2ODY5MDQ2NTg4RTA1RUEzQjQwRTE4OEJEXzI1MzAwNTkuanBnLzEweDEwL3Jlc2l6ZS82MDB4L3F1YWxpdHkvOTUv",
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzI1My9CXzJDQ0I1MEZGNUE1NTRFNkVCNDFGREIzNjM5RUEyOTc4XzI1MzAwNTkuanBnLzEweDEwL3Jlc2l6ZS82MDB4L3F1YWxpdHkvOTUv"
            ],
            "item_image": "aHR0cDovL3RodW1ibmFpbC4xMHgxMC5jby5rci93ZWJpbWFnZS9pbWFnZS90ZW50ZW4vMjUzL1QwMDI1MzAwNTkuanBnP2NtZD10aHVtYiZmaXQ9dHJ1ZSZ3cz1mYWxzZSZ3PTYwMCZ3aD02MDA",
            "user_id": "yemom**",
            "total_point": 5,
            "move_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL2NhdGVnb3J5L2NhdGVnb3J5X2l0ZW1QcmQuYXNwP2l0ZW1pZD0yNTMwMDU5",
            "sell_yn": "N",
            "more_view_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL2NvbW1vbi9Qb3BJdGVtRXZhbHVhdGUuYXNwP2l0ZW1pZD0yNTMwMDU5"
          },
          {
            "idx": 9052166,
            "item_id": 2523634,
            "item_name": "[Peanuts] 아이패드 파우치",
            "content": "스누피 사려다가 라이너스 샀는데 빨간색이 쨍한 밝은 빨간색이라서 너무 예뻐요!스누피 키링도 따로 사서 달았더니 너무 귀엽네요.\r\n안에 팬슬꽂이가 있는데 생펜슬꽂으면 조금 남아요. 실리콘 케이스끼우고 넣어도 들어갈 것 같아요.\r\n여러 후기에서 봤듯이 정말 두툼해서 그냥 떨어뜨려도 안깨질 것 같네요 ㅋㅋㅋㅋ \r\n너무 예뻐요. 고민은 배송만 늦출 뿐",
            "review_images": [
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzI1Mi9BXzkwNzU2QTBCM0E0MDRDODlCMzdCQ0M0Mzg3NTdENUZCXzI1MjM2MzQuanBnLzEweDEwL3Jlc2l6ZS82MDB4L3F1YWxpdHkvOTUv",
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzI1Mi9CX0Q4OUU2Mzk4MUI3QTQ5REFBMTlFODlENzk0MDkxODIxXzI1MjM2MzQuanBnLzEweDEwL3Jlc2l6ZS82MDB4L3F1YWxpdHkvOTUv",
              "aHR0cDovL2ltZ3N0YXRpYy4xMHgxMC5jby5rci9nb29kc2ltYWdlLzI1Mi9CXzMxNEFEREY5NUE4ODQ3MUY4RTJDNzE4NDhGNjAxMDlGXzI1MjM2MzQuanBnLzEweDEwL3Jlc2l6ZS82MDB4L3F1YWxpdHkvOTUv"
            ],
            "item_image": "aHR0cDovL3RodW1ibmFpbC4xMHgxMC5jby5rci93ZWJpbWFnZS9pbWFnZS9iYXNpYy8yNTIvQjAwMjUyMzYzNC00LmpwZz9jbWQ9dGh1bWImZml0PXRydWUmd3M9ZmFsc2Umdz02MDAmd2g9NjAw",
            "user_id": "shopcy04**",
            "total_point": 5,
            "move_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL2NhdGVnb3J5L2NhdGVnb3J5X2l0ZW1QcmQuYXNwP2l0ZW1pZD0yNTIzNjM0",
            "sell_yn": "N",
            "more_view_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL2NvbW1vbi9Qb3BJdGVtRXZhbHVhdGUuYXNwP2l0ZW1pZD0yNTIzNjM0"
          }
        ]
    },
    getters : {
        reviews : function(state) {
            var reviews = [];
            for( idx in state.reviews ) {
                var temp_review = state.reviews[idx];

                // 상품명, 내용 하이라이트 처리
                var add_highlight = function(str, replaceStr) {
                    return str.replaceAll(replaceStr, '<mark class="match">' + replaceStr + '</mark>');
                }
                var keyword_arr = state.params.keyword.split(' ');
                for( var i=0 ; i<keyword_arr.length ; i++ ) {
                    temp_review.item_name = add_highlight(temp_review.item_name, keyword_arr[i]);
                    temp_review.content = add_highlight(temp_review.content, keyword_arr[i]);
                }

                // Decode Base64
                temp_review.item_image = decodeBase64(temp_review.item_image);
                temp_review.move_url = decodeBase64(temp_review.move_url);
                temp_review.more_view_url = decodeBase64(temp_review.more_view_url);
                if( temp_review.review_images != null ) {
                    for( var i=0 ; i < temp_review.review_images.length ; i++ ) {
                        temp_review.review_images[i] = decodeBase64(temp_review.review_images[i]);
                    }
                }


                reviews.push(temp_review);
            }
            return reviews;
        }
    },
    mutations : {
        
    },
    actions : {
        
    }
});