const app = new Vue({
    el: '#app',
    template: `
<body :class="['default-font', isApp ? 'item_week' : 'body-popup item_week']">
  <header class="tenten-header header-popup" v-if="!isApp">
    <div class="title-wrap">
      <h1>{{headerText}}</h1>
      <button type="button" class="btn-close" onclick="self.close();">닫기</button>      
    </div>
  </header>

  <!-- contents -->
  <div id="content" class="content deal-item">
    <div class="deal_wrap">
      <div class="slide">
        <!-- item info -->
        <section class="items item-detail">
          <div class="desc">
            <span class="brand">{{itemDetail.brandName}}</span>
            <h2 class="name">{{itemDetail.itemName}}</h2>
          </div>
        </section>
        <!-- item etc info -->
        
        <div class="deal_detail" style="display:none;">
          <!-- 상세 이미지 영역 -->
          <div class="imgArea" id="imgArea">
            <div v-html="replaceContent(itemDetail.itemContent)"></div>
            <!-- 추가 이미지 -->
            <template v-for="addImg in itemDetail.itemAddImages_mobile">
                 <img :src="addImg" alt="">
            </template>
            <template v-if="itemDetail.mainImage != null"><img :src="itemDetail.mainImage" alt=""></template>
            <template v-if="itemDetail.mainImage2 != null"><img :src="itemDetail.mainImage2" alt=""></template>
            <template v-if="itemDetail.mainImage3 != null"><img :src="itemDetail.mainImage3" alt=""></template>            
          </div>

          <!-- 상품설명 탭에 들어가는 내용 -->
          <div class="pdtCaptionV16a">
            <p><strong>상품코드 : {{itemid}}</strong></p>
            <p style="margin-top:0.43rem;"><strong>적립 마일리지 : {{itemDetail.mileage}} Point</strong></p>
            <dl class="odrNoteV16a" v-if="itemDetail.orderComment || getDeliverNotice()">
              <dt>주문 유의사항</dt>
              <dd>
                <template v-if="getDeliverNotice()">
                    <div v-html="getDeliverNotice()"></div>
                </template>
                <template v-if="itemDetail.orderComment">{{itemDetail.orderComment}}</template>                
              </dd>
            </dl>
          </div>
        </div>
        
        <div class="deal_list" style="display:none;">
          <ul class="pro_list">
            <li v-for="(item,index) in dealItemDetails">
              <div class="prd_img">
                <img :src="item.basicImageImageUrl" alt="상품명">
                <span class="prd_mask"></span>
              </div>
              <p class="prd_num">상품 {{index+1}}</p>
              <p class="prd_name">{{item.itemName}}</p>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
  <!-- //contents -->

  <!-- #include virtual="/html/lib/inc/footer.asp" -->
</body>
    `,
    created() {
        if(itemid == '' || openDate == '') {
            alert('잘못된 접근입니다.');
            self.close();
        }
        this.setItemInfo();
        this.setHeader();
    },
    data: function () {
        return {
            itemid: itemid,
            headerText: '',
            isApp: isApp,
            itemDetail: {},
            dealItemDetails: []            
        }
    },
    updated: function() {
        this.$nextTick(function () {
            let contents = $("#imgArea");
            contents.find("table").css("width","100%");
            contents.find("div").css("width","100%");
            contents.find("img").css("width","100%");
            contents.find("img").css("height","auto");
        })
    },
    methods: {
        /**
         * 헤더명 세팅
         */
        setHeader() {
            this.headerText = this.getHeaderText();
            if(isApp){
                fnAPPchangPopCaption(this.headerText);
            }
        },
        /**
         * 헤더명 조회
         * @returns {string}
         */
        getHeaderText(){
            let yyyy = openDate.substr(0, 4);
            let mm = openDate.substr(4, 2);
            let dd = openDate.substr(6, 2);
            let week_array = new Array('일', '월', '화', '수', '목', '금', '토');
            let today_num = new Date(yyyy + '-' + mm + '-' + dd).getDay();
            return mm +'/' + dd + ' ' +week_array[today_num] + '요일 제품 미리보기';
        },
        /**
         * 상품 상세 컨텐츠 치환
         * @param content
         * @returns {*}
         */
        replaceContent(content) {
            if(content){
                // 링크는 새창으로
                content = content.replaceAll("<a ","<a target='_blank' ");
                content = content.replaceAll("<A ","<A target='_blank' ");
                // 높이태그 제거
                content = content.replaceAll("height=","h=");
                content = content.replaceAll("HEIGHT=","h=");
                // 너비태그 제거
                content = content.replaceAll("width=","w=");
                content = content.replaceAll("WIDTH=","w=");
                return content;
            }
        },
        /**
         * 상품정보 조회
         */
        setItemInfo() {
            let _this = this;
            // 딜 상세 초기화
            _this.dealItemDetails = [];
            let data = {
                'itemIds': itemid
            };
            let url = '/item-week/items';
            let method = 'GET';
            getFrontApiData(method, url, data,
                data => {
                    if(data.length < 1){
                        alert('존재하지 않는 상품입니다.');
                        self.close();
                    } else if(data[0].itemDiv == '21'){
                        _this.setDealItenInfo(itemid);
                    }
                    _this.itemDetail = data[0];
                    _this.itemDisplay('item');
                },
                xhr => {
                    const error = JSON.parse(xhr.responseText);
                    if (xhr.status == 400){
                        alert(error.message);
                    } else {
                        alert('서버에 오류가 발생하였습니다.');
                    }
                }
            );
        },
        /**
         * 딜 정보 조회
         */
        setDealItenInfo() {
            let _this = this;
            let data = {
                'dealItemId': itemid
            };
            let url = '/item-week/deal/items';
            let method = 'GET';
            let success = function (data) {
                if (data.length < 1) {
                    alert('존재하지 않는 상품입니다.');
                    return;
                }
                _this.dealItemDetails = data;
                _this.itemDisplay('deal');
            }
            call_api(method, url, data, success, this.error);
        },
        /**
         * 일반상품/딜상품 구분해서 디스플레이
         * @param type
         */
        itemDisplay(type) {
            if(type == 'deal'){
                $('.deal_detail').hide();
                $('.deal_list').show();
            } else {
                $('.deal_detail').show();
                $('.deal_list').hide();
            }
        },
        /**
         * 베송안내
         * @returns {string}
         */
        getDeliverNotice() {
            let val = this.itemDetail;
            if(this.isUpcheParticleDeliverItem()) {
                return val.brandName + '(' + val.brandName_kor + ') 제품으로만 <br>'
                    + this.number_format(val.defaultFreeBeasongLimit) + '원 이상 구매시 무료배송 됩니다.'
                    + '배송비(' + this.number_format(val.defaultDeliverPay) + '원)';
            } else if(this.isUpcheReceivePayDeliverItem()) {
                return '착불 배송비는 지역에 따라 차이가 있습니다. 상품성명의 \'배송안내\'를 꼭 읽어보세요.';
            }
        },
        /**
         * 업체별 배송비 부과 상품(업체 조건 배송)
         * @returns {boolean}
         */
        isUpcheParticleDeliverItem() {
            let val = this.itemDetail;
            return val.defaultFreeBeasongLimit > 0 && val.defaultDeliverPay > 0 && val.deliveryType == '9';
        },
        /**
         * 업체착불 배송여부
         * @returns {boolean}
         */
        isUpcheReceivePayDeliverItem() {
            return this.itemDetail.deliveryType == '7';
        }
    }
});