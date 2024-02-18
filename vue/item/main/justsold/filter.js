Vue.component('CategoryFilter',{
    template : `
        <nav class="swiper-container">
            <ul class="swiper-wrapper">
                <li v-for="c in categories" :key="c.catecode" class="swiper-slide">
                    <input type="radio" :value="c.catecode" name="category" v-model="category" :id="'cate' + c.catecode">
                    <label :for="'cate' + c.catecode">{{c.catename}}</label>
                </li>
            </ul>
        </nav>
    `,
    props : {
        categories : {
            catecode : { type:String, default:'' },
            catename : { type:String, default:'' }
        }
    },
    computed: {
        category : {
            get : function() {
                return this.$store.state.params.category;
            },
            set : function(value) {
                this.$store.commit('SET_CATEGORY', value);
                this.$store.commit('CLEAR_ITEMLISTS');
                this.$store.dispatch('GET_ITEMLISTS');
            }
        },
    },
    mounted : function(){
        this.$nextTick(function() {
			setTimeout(function(){
                var swiper = new Swiper(".sold-now nav", {
                    slidesPerView:'auto'
                });
			},100);
		});
    }
})