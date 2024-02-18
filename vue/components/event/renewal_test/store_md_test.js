let apiurl;
const this_url = unescape(location.href);
if( this_url.startsWith('http://localhost') ) {
    console.log('local');
    apiurl = "//localhost:8080/api/web/v1";
} else if( this_url.startsWith('http://testm') ) {
    console.log('develop');
    apiurl = "//testfapi.10x10.co.kr:8080/api/web/v1";
} else if( this_url.startsWith('http://stgm') ) {
    console.log('staging');
    apiurl = "//stgfapi.10x10.co.kr:8080/api/web/v1";
} else if( this_url.startsWith('http://m') || this_url.startsWith('https://m') ) {
    console.log('master');
    apiurl = "//fapi.10x10.co.kr/api/web/v1";
} else {
    console.log('error');
    alert('api url error');
    apiurl = "//testfapi.10x10.co.kr:8080/api/web/v1";
}
let exhibition_dataurl = apiurl + "/search/exhibitionSearch";

// Decode Base64
function decodeBase64(str) {
    if( str != null && str != '' )
        return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
    else
        return '';
}
String.prototype.replaceAll = function(searchStr, replaceStr) {
    return this.split(searchStr).join(replaceStr);
}

var store = new Vuex.Store({
    state : {
        params : { // 파라미터
            keywords : '스누피'
        },
        exhibitions : []
    },
    getters : {
        exhibitions : function(state) {
            return state.exhibitions;
        }
    },
    mutations : {
        SET_EXHIBITIONS : function(state, payload) { // Set 기획전 리스트
            let exhibitions = [];
            for( let idx=0 ; idx < payload.length ; idx++ ) {
                let temp_exhibition = payload[idx];

                // Decode Base64
                temp_exhibition.banner_img = decodeBase64(temp_exhibition.banner_img);
                temp_exhibition.move_url = decodeBase64(temp_exhibition.move_url);

                exhibitions.push(temp_exhibition);
            }
            state.exhibitions = exhibitions;
        }
    },
    actions : {
        GET_EXHIBITIONS : function(context) { // 기획전 리스트 state에 저장
            var _url = exhibition_dataurl + '?keywords=' + context.state.params.keywords;

            $.ajax({
                type : "GET",
                url: _url,
                ContentType : "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function(data) {
                    console.log(data);
                    context.commit('SET_EXHIBITIONS', data.items);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
    }
});