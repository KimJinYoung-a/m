Vue.component('SearchFilter',{
    template : `
            <div>
                <div class="type">
                    <ul>
                        <li>
                            <input type="radio" value="-1" name="category" v-model="category" id="typeAll" />
                            <label for="typeAll">#전체</label>
                        </li>
                        <li>
                            <input type="radio" value=10 name="category" v-model="category" id="type1" />
                            <label for="type1">#트리</label>
                        </li>
                        <li>
                            <input type="radio" value=20 name="category" v-model="category" id="type2" />
                            <label for="type2">#조명</label>
                        </li>
                        <li>
                            <input type="radio" value=30 name="category" v-model="category" id="type3" />
                            <label for="type3">#리스/가랜드</label>
                        </li>
                        <li>
                            <input type="radio" value=40 name="category" v-model="category" id="type4" />
                            <label for="type4">#오너먼트</label>
                        </li>
                        <li>
                            <input type="radio" value=50 name="category" v-model="category" id="type5" />
                            <label for="type5">#캔들/디퓨저</label>
                        </li>
                        <li>
                            <input type="radio" value=60 name="category" v-model="category" id="type7" />
                            <label for="type7">#크리스마스카드</label>
                        </li>
                    </ul>
                </div>
                <div class="sortbar">
                    <div class="sort_r">
                        <button id="sorted1" @click="toggleOnOff(8)" class="on">인기순</button>
                        <button id="sorted2" @click="toggleOnOff(2)">신규순</button>
                    </div>
                </div>
            </div>
    `,
    computed: {
        category : {
            get : function() {
                return this.$store.state.params.category;
            },
            set : function(value) {
                this.$store.commit('SET_CATEGORY', value);
                this.$store.commit('CLEAR_ITEMLISTS');
                this.$store.dispatch('GET_ITEMLISTS'); // Search Action
            }
        },
    },
    methods: {
        toggleOnOff: function(value){
            if(value=="8"){
                $("#sorted1").addClass("on");
                $("#sorted2").removeClass("on");
            }else{
                $("#sorted2").addClass("on");
                $("#sorted1").removeClass("on");
            }
            this.$store.commit('SET_SORT', value);
            this.$store.commit('CLEAR_ITEMLISTS');
            this.$store.dispatch('GET_ITEMLISTS');
        }
    },
})