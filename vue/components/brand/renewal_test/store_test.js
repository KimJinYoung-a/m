//var apiurl = "http://testfapi.10x10.co.kr:8080/api/web/v1";
var apiurl = "http://localhost:8080/api/web/v1";
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
            keyword: '에코'
        },
        options : { // 옵션
            
        },
        brands : [
          {
            "brand_id": "BLUESKY03",
            "brand_name": "에코청운",
            "cate_name": "디자인문구",
            "main_image": "aHR0cDovL3RodW1ibmFpbC4xMHgxMC5jby5rci93ZWJpbWFnZS9pbWFnZS9tYWluLzUzL00wMDA1MzY2MzYuanBnP2NtZD10aHVtYiZmaXQ9dHJ1ZSZ3cz1mYWxzZSZ3PTYwMCZ3aD02MDA",
            "move_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL3N0cmVldC9zdHJlZXRfYnJhbmQuYXNwP21ha2VyaWQ9QkxVRVNLWTAz",
            "wish_yn": false,
            "best_yn": false
          },
          {
            "brand_id": "echodiy",
            "brand_name": "에코상사",
            "cate_name": "가구/수납",
            "main_image": "aHR0cDovL3RodW1ibmFpbC4xMHgxMC5jby5rci93ZWJpbWFnZS9pbWFnZS9iYXNpYy8yMzgvQjAwMjM4NTU3MS5qcGc_Y21kPXRodW1iJmZpdD10cnVlJndzPWZhbHNlJnc9NjAwJndoPTYwMA",
            "move_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL3N0cmVldC9zdHJlZXRfYnJhbmQuYXNwP21ha2VyaWQ9ZWNob2RpeQ",
            "wish_yn": false,
            "best_yn": false
          },
          {
            "brand_id": "dngtrading",
            "brand_name": "에코앤드",
            "cate_name": "키친",
            "main_image": "aHR0cDovL3RodW1ibmFpbC4xMHgxMC5jby5rci93ZWJpbWFnZS9pbWFnZS9iYXNpYy8yNjEvQjAwMjYxMzM5Mi5qcGc_Y21kPXRodW1iJmZpdD10cnVlJndzPWZhbHNlJnc9NjAwJndoPTYwMA",
            "move_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL3N0cmVldC9zdHJlZXRfYnJhbmQuYXNwP21ha2VyaWQ9ZG5ndHJhZGluZw",
            "wish_yn": true,
            "best_yn": true
          },
          {
            "brand_id": "dio002",
            "brand_name": "에코 팩토리",
            "cate_name": "데코/조명",
            "main_image": "aHR0cDovL3RodW1ibmFpbC4xMHgxMC5jby5rci93ZWJpbWFnZS9pbWFnZS9tYWluLzEwNi9NMDAxMDYxMjYzLmpwZz9jbWQ9dGh1bWImZml0PXRydWUmd3M9ZmFsc2Umdz02MDAmd2g9NjAw",
            "move_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL3N0cmVldC9zdHJlZXRfYnJhbmQuYXNwP21ha2VyaWQ9ZGlvMDAy",
            "wish_yn": false,
            "best_yn": false
          },
          {
            "brand_id": "ecodivers01",
            "brand_name": "에코다이버스",
            "cate_name": "토이/취미",
            "main_image": "aHR0cDovL3RodW1ibmFpbC4xMHgxMC5jby5rci93ZWJpbWFnZS9pbWFnZS9iYXNpYy8yMzkvQjAwMjM5NDk1NC0xLmpwZz9jbWQ9dGh1bWImZml0PXRydWUmd3M9ZmFsc2Umdz02MDAmd2g9NjAw",
            "move_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL3N0cmVldC9zdHJlZXRfYnJhbmQuYXNwP21ha2VyaWQ9ZWNvZGl2ZXJzMDE",
            "wish_yn": false,
            "best_yn": false
          },
          {
            "brand_id": "ekobo1010",
            "brand_name": "에코보",
            "cate_name": "키친",
            "main_image": "aHR0cDovL3RodW1ibmFpbC4xMHgxMC5jby5rci93ZWJpbWFnZS9pbWFnZS9iYXNpYy8yNDcvQjAwMjQ3NjE4Mi0yLmpwZz9jbWQ9dGh1bWImZml0PXRydWUmd3M9ZmFsc2Umdz02MDAmd2g9NjAw",
            "move_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL3N0cmVldC9zdHJlZXRfYnJhbmQuYXNwP21ha2VyaWQ9ZWtvYm8xMDEw",
            "wish_yn": false,
            "best_yn": false
          },
          {
            "brand_id": "ecomate",
            "brand_name": "에코메이트",
            "cate_name": "키친",
            "main_image": "aHR0cDovL3RodW1ibmFpbC4xMHgxMC5jby5rci93ZWJpbWFnZS9pbWFnZS9iYXNpYy8yMjMvQjAwMjIzMjk1MS5qcGc_Y21kPXRodW1iJmZpdD10cnVlJndzPWZhbHNlJnc9NjAwJndoPTYwMA",
            "move_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL3N0cmVldC9zdHJlZXRfYnJhbmQuYXNwP21ha2VyaWQ9ZWNvbWF0ZQ",
            "wish_yn": false,
            "best_yn": false
          },
          {
            "brand_id": "ecopet",
            "brand_name": "에코펫위드",
            "cate_name": "Cat & Dog",
            "main_image": "aHR0cDovL3RodW1ibmFpbC4xMHgxMC5jby5rci93ZWJpbWFnZS9pbWFnZS9iYXNpYy8yNTQvQjAwMjU0NTM3MC5qcGc_Y21kPXRodW1iJmZpdD10cnVlJndzPWZhbHNlJnc9NjAwJndoPTYwMA",
            "move_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL3N0cmVldC9zdHJlZXRfYnJhbmQuYXNwP21ha2VyaWQ9ZWNvcGV0",
            "wish_yn": false,
            "best_yn": false
          },
          {
            "brand_id": "sjeco2013",
            "brand_name": "서전에코",
            "cate_name": "패브릭/생활",
            "main_image": "aHR0cDovL3RodW1ibmFpbC4xMHgxMC5jby5rci93ZWJpbWFnZS9pbWFnZS9iYXNpYy8yNzgvQjAwMjc4ODI4Ni5qcGc_Y21kPXRodW1iJmZpdD10cnVlJndzPWZhbHNlJnc9NjAwJndoPTYwMA",
            "move_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL3N0cmVldC9zdHJlZXRfYnJhbmQuYXNwP21ha2VyaWQ9c2plY28yMDEz",
            "wish_yn": false,
            "best_yn": false
          },
          {
            "brand_id": "woongskitchen",
            "brand_name": "웅스키친 린넨 에코백",
            "cate_name": "패션잡화",
            "main_image": "aHR0cDovL3RodW1ibmFpbC4xMHgxMC5jby5rci93ZWJpbWFnZS9pbWFnZS9iYXNpYy8yNDYvQjAwMjQ2NTU0Ni5qcGc_Y21kPXRodW1iJmZpdD10cnVlJndzPWZhbHNlJnc9NjAwJndoPTYwMA",
            "move_url": "aHR0cDovL3Rlc3RtLjEweDEwLmNvLmtyL3N0cmVldC9zdHJlZXRfYnJhbmQuYXNwP21ha2VyaWQ9d29vbmdza2l0Y2hlbg",
            "wish_yn": false,
            "best_yn": false
          }
        ]
    },
    getters : {
        brands : function(state) {
            var brands = [];
            for( idx in state.brands ) {
                var temp_brand = state.brands[idx];

                // 상품명, 내용 하이라이트 처리
                var add_highlight = function(str, replaceStr) {
                    return str.replaceAll(replaceStr, '<mark class="match">' + replaceStr + '</mark>');
                }
                var keyword_arr = state.params.keyword.split(' ');
                for( var i=0 ; i<keyword_arr.length ; i++ ) {
                  temp_brand.brand_name = add_highlight(temp_brand.brand_name, keyword_arr[i]);
                }

                // Decode Base64
                temp_brand.main_image = decodeBase64(temp_brand.main_image);
                temp_brand.move_url = decodeBase64(temp_brand.move_url);

                brands.push(temp_brand);
            }
            return brands;
        }
    },
    mutations : {
        
    },
    actions : {
        
    }
});