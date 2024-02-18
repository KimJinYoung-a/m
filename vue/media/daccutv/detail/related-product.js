Vue.component('related-products', {
    template: '\
    <div class="related-prd"\
        v-if="relatedProducts.length > 0"\
    >\
        <h3>영상에 등장한 상품</h3>\
        <div class="prd-list">\
            <ul>\
                <li\
                    v-for="(item, index) in relatedProducts"\
                    v-if="index < itemLimit"\
                >\
                    <a @click="productLink(item.linkurl, item.itemid)">\
                        <div class="thumbnail"><img :src="item.itemimage" alt=""></div>\
                        <div class="desc">\
                            <p class="name">{{item.itemname}}</p>\
                            <span class="plf-rating">\
                                <i\
                                    v-bind:style="{\'width\': item.totalpoint + \'%\'}">\
                                    style="width:50%;"\
                                >\
                                </i>\
                            </span>\
                        </div>\
                    </a>\
                    <!-- for dev msg : 위시등록 후 .btn-wish 에 클래스 on 추가 -->\
                    <button class="btn-wish"\
                        :class=" item.isWishItem ? \'on\' : \'\' "\
                        @click="handleClickWish(item.itemid, index)"\
                    >\
                        <i>wish</i><span>{{item.wishcnt}}</span>\
                    </button>\
                </li>\
            </ul>\
            <div class="btn-area"\
                v-if="relatedProducts.length >= 4"\
            >\
                <button class="btn-more"\
                    v-if="itemLimit!=20"\
                    @click="viewAllItems"\
                >상품 전체보기</button>\
            </div>\
        </div>\
    </div>\
    ',
    data: function(){
        return {
            itemLimit: 3,
            wishParam: {
                itemId: '',
                mediaName: '다꾸티비'
            }
        }
    },
    props: {
        relatedProducts: {
            type: Array,
            default: []
        },
        handleMediaItemWish: {
            type: Function,
            default: function(){
                alert('default wish button clicked')
            }
        },
        wishItem: {
            type: Object,
            default: function(){
                return {
                    itemId: 0,
                    flag: false
                }
            }
        }
    },
    methods: {
        handleClickWish: function(itemId, idx){
            this.wishParam.itemId = itemId

            if(this.handleMediaItemWish(this.wishParam, idx)){
                if(this.relatedProducts[idx].isWishItem){
                    this.relatedProducts[idx].wishcnt--;
                }else{
                    this.relatedProducts[idx].wishcnt++;
                }

                this.relatedProducts[idx].isWishItem = this.wishItem.flag;
            }
            // console.log(this.relatedProducts[idx].wishcnt)
        },
        viewAllItems: function(){
            this.itemLimit = 20
        },
        productLink: function(link, itemId){
            if(isapp == 1){
                TnGotoProduct(itemId);
            }else{
                window.location.href = link
            }
            return false;
        }
    },
    // watch: {
    //     relatedProducts: {
    //         handler(){
    //             this.relatedProducts[this.clickedWishIdx].wishcnt--
    //         },
    //         deep: true
    //     }
    // }
})
