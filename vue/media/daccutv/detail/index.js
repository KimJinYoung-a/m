var detailsUrl = "/apps/appCom/wish/webapi/media/getContentsView.asp"
var keywordUrl = "/apps/appCom/wish/webapi/media/getContentsKeywordsList.asp"
var relatedItemsUrl = "/apps/appCom/wish/webapi/media/getContentsItemsList.asp"
var wishUrl = "/apps/appCom/wish/webapi/media/setWishProc.asp"

var app = new Vue({
    el: '#app',
    template: '\
    <div class="diary-tv diary-tv-detail">\
        <media-player\
            :video-url="contentsDetails.videoUrl"\
            :is-new="contentsDetails.isNew"\
            :main-image="contentsDetails.mainImage"\
        ></media-player>            <!-- 파일명 : player.js           -->\
        <vod-info\
            v-if="gotContentsCnt == 3"\
            :is-login="contentsDetails.isLogin"\
            :c-idx="cidx"\
            :view-count="contentsDetails.viewCount"\
            :c-title="contentsDetails.contentsTitle"\
            :like-count="contentsDetails.likeCount"\
            :content-text="contentsDetails.contentsText"\
            :content-tag="keyWords"\
            :main-image="contentsDetails.mainImage"\
            :is-new="contentsDetails.isNew"\
            :set-comma="setComma"\
            :my-like-count="contentsDetails.myLikeCount"\
        ></vod-info>                <!-- 파일명 : vod-info.js         -->\
        <related-products\
            :related-products="relatedProducts"\
            :handle-media-item-wish="handleMediaItemWish"\
            :wish-item="wishItem"\
        ></related-products>        <!-- 파일명 : related-product.js  -->\
        <banner-list\
            :addon-event-image1="contentsDetails.addonEventImage1"\
            :addon-event-image2="contentsDetails.addonEventImage2"\
            :addon-event-image3="contentsDetails.addonEventImage3"\
            :addon-event-image4="contentsDetails.addonEventImage4"\
            :addon-event-image5="contentsDetails.addonEventImage5"\
            :addon-event-code1="contentsDetails.addonEventCode1"\
            :addon-event-code2="contentsDetails.addonEventCode2"\
            :addon-event-code3="contentsDetails.addonEventCode3"\
            :addon-event-code4="contentsDetails.addonEventCode4"\
            :addon-event-code5="contentsDetails.addonEventCode5"\
        ></banner-list>             <!-- 파일명 : banner-list.js      -->\
        <owner-info\
            :profile-image="contentsDetails.profileImage"\
            :group-name="contentsDetails.groupName"\
            :profile-description="contentsDetails.profile"\
        ></owner-info>              <!-- 파일명 : owner.js            -->\
        <event-comment\
            v-if="commentEventCode != 0"\
            :event-code="commentEventCode"\
        ></event-comment>           <!-- 파일명 : event-comment.js    -->\
        <related-contents\
            :related-contents="relatedContents"\
        ></related-contents>        <!-- 파일명 : relatedContents.js  -->\
    </div>\
    ',
    data: function(){
        return{
            cidx: '',
            commentEventCode: 0,
            contentsDetails: {},
            keyWords: [],
            relatedProducts: [],
            wishItem: {
                itemId: 0,
                flag: false
            },
            relatedContents: [],
            gotContentsCnt: 0
        }
    },
    methods: {
        getContentsDetails: function(params){
            var _this = this;

            $.getJSON(params.url, params, function (data, status, xhr) {
                var tmpKeyArr = [];
                if (status == "success") {
                    for( var key in data ) {
                        _this.$data[key] = data[key]
                        tmpKeyArr.push(key)
                    }
                    if(params.dataForProps){
                        tmpKeyArr.forEach(function(keyName){
                            _this.setDataForProps(keyName, params.dataForProps)
                        })
                    }
                    _this.gotContentsCnt++
                } else {
                    console.log("JSON data not Loaded.");
                }
            });
        },
        getParameterByName: function(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[\[\]]/g, "\\$&");
            var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
                results = regex.exec(url);
            return results[2];
        },
        setDataForProps: function(keyName, data){
            this.$data[data] = this.$data[keyName][data]
        },
        setComma: function(x){
            return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        },
        handleMediaItemWish: function(param){
            var result
            var _this = this;

            $.ajax({
                type: "post",
                url: wishUrl,
                data: {
                    mediaName: param.mediaName,
                    itemId: param.itemId
                },
                async: false,
				success : function(data, textStatus, jqXHR){
                    if(data.response == 'ok'){
                        _this.wishItem.itemId = data.item_id;
                        _this.wishItem.flag = data.my_wish;

                        result = true;
                    }else if(data.response == 'fail'){
                        if(data.faildesc == 'login'){
                            _this.linkLogin();
                            result = false;
                        }else{
                            alert('시스템 에러입니다.');
                            result = false;
                        }
                    }else{
                        alert('시스템 에러입니다.');
                        result = false;
                    }
				},
				error:function(jqXHR, textStatus, errorThrown){
					alert("잘못된 접근 입니다.");
					result = false;
				}
            })

            return result;
        },
        linkLogin: function(){
            var url = window.location.pathname + window.location.search;
            if(isapp == 1){
                calllogin();
                return false;
            }else{
                jsChklogin_mobile('',url);
            }
        }
    },
    created: function(){
        try {
            this.cidx = this.getParameterByName('cidx')
        } catch (error) {
            alert('콘텐츠 번호가 잘못되었습니다.')
            window.location.history(-1)
        }

        this.getContentsDetails({
            cidx: this.cidx,
            url: detailsUrl,
            dataForProps: "commentEventCode"
        });
        this.getContentsDetails({
            cidx: this.cidx,
            url: keywordUrl,
            dataForProps: ''
        });
        this.getContentsDetails({
            cidx: this.cidx,
            url: relatedItemsUrl,
            dataForProps: ''
        });
        // console.log(`isapp : ${isapp}`)
        // console.log(`debugMode : ${debugMode}`)
    }
})
