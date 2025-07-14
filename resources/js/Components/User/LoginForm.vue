<template>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-7 animated fadeIn col-lg-6 center-screen">
                <div class="card w-90 food-card p-4">
                    <div class="text-center mb-4">
                        <Link href="/" class="text-decoration-none">
                            <h3 class="mt-3 food-heading font-lobster">Demo Site</h3>
                        </Link>
                        <p class="text-muted">Sign in</p>
                    </div>
                    <form @submit.prevent="submit">
                        <div class="card-body">
                            <div class="input-group mb-3 auth-input-group">
                                <span class="input-group-text"><i class="fa fa-envelope"></i></span>
                                <input id="email" v-model="form.email" placeholder="Email Address" class="form-control" type="email"/>
                            </div>
                            
                            <div class="input-group mb-3 auth-input-group">
                                <span class="input-group-text"><i class="fa fa-lock"></i></span>
                                <input id="password" v-model="form.password" placeholder="Password" class="form-control" type="password"/>
                            </div>
                            
                            <button type="submit" class="btn w-100 btn-success">
                                Login
                            </button>
                            
                            <div class="text-center mt-4">
                                <p class="mb-0">
                                    <span class="text-muted">Don't have an account?</span>
                                    <Link class="ms-2 food-link elegant-link" :href="route('RegistrationPage')">Register</Link>
                                </p>
                                <div class="mt-2 credential-hint">
                                    <small class="text-muted"><strong>Admin:</strong> <br>admin@example.com | password</small> <br>
                                    <small class="text-muted"><strong>Stuff:</strong> <br>staff@example.com | password</small>
                                </div>                            
                            </div>
                        </div>
                    </form>
                </div>
                <div class="food-quotes text-center mt-3">
                    <!-- <p><i class="fa fa-quote-left me-2"></i>Food is our common ground, a universal experience.<i class="fa fa-quote-right ms-2"></i></p> -->
                </div>
            </div>
        </div>
    </div>
</template>


<script setup>
import { useForm, router, usePage, Link } from '@inertiajs/vue3';
import { createToaster } from "@meforma/vue-toaster";

const toaster = createToaster();

const form = useForm({
    email: '',
    password: ''
});

const page = usePage();

function submit() {
    if (!form.email) {
        toaster.error("Email Required");
    } else if (!form.password) {
        toaster.error("Password Required");
    } else {
        form.post(route('login'), {
            onSuccess: () => {
                if (page.props.flash.status) {
                    router.get(route('DashboardPage'));
                } else {
                    toaster.error(page.props.flash.message);
                }
            }
        });
    }
}
</script>
