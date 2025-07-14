<template>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-7 animated fadeIn col-lg-6 center-screen">
                <div class="card w-90 food-card p-4">
                    <div class="text-center mb-4">
                        <Link href="/" class="text-decoration-none">
                            <h3 class="mt-3 food-heading font-lobster">Demo Site</h3>
                        </Link>
                        <p class="text-muted">Register</p>
                    </div>                 
                    <form @submit.prevent="submit">
                        <div class="card-body">
                                    <div class="input-group mb-3 auth-input-group">
                                        <span class="input-group-text"><i class="fa fa-user"></i></span>
                                        <input id="name" v-model="form.name" placeholder="Your Name" class="form-control" type="text"/>
                                    </div>

                                    <div class="input-group mb-3 auth-input-group">
                                        <span class="input-group-text"><i class="fa fa-envelope"></i></span>
                                        <input id="email" v-model="form.email" placeholder="Email Address" class="form-control" type="email"/>
                                    </div>

                                    <div class="input-group mb-3 auth-input-group">
                                        <span class="input-group-text"><i class="fa fa-lock"></i></span>
                                        <input id="password" v-model="form.password" placeholder="Create Password" class="form-control" type="password"/>
                                    </div>
                                
                                    <button type="submit" class="btn w-100 btn-success">
                                    Register
                                    </button>
                            </div>
                        </form>
                            
                            <div class="text-center mt-4">
                                <p class="mb-0">
                                    <span class="text-muted">Already have an account?</span>
                                    <Link class="ms-2 food-link elegant-link" :href="route('LoginPage')">Sign in here</Link>
                                </p>
                            </div>
                    
                </div>
            </div>
        </div>
    </div>
</template>



<script setup>
import {useForm, router, usePage, Link} from '@inertiajs/vue3'
const form = useForm({email:'', name:'', mobile:'', password:''})
import { createToaster } from "@meforma/vue-toaster";

const toaster = createToaster();
const page = usePage()
function submit(){
    if(form.email.length===0){
        toaster.error("Email Required")
    }
    else if(form.name.length===0) {
        toaster.error("Name Required")
    }
    else if(form.password.length===0) {
        toaster.error("Password Required")
    }
    else {
        form.post(route('register'),{
            onSuccess:()=>{
                if(page.props.flash.status===true){
                    router.get(route('LoginPage'))
                }
                else {                    
                    toaster.error(page.props.flash.message)
                }
            }
        })
    }
}
</script>

