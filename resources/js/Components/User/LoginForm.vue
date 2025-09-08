<template>
    <div class="login-page">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-5 col-md-7 col-sm-9">
                    <div class="login-container form-container">
                        <div class="text-center mb-4">
                            <div class="brand-logo mb-3">
                                <i class="fas fa-store-alt fa-3x text-primary"></i>
                            </div>
                            <h3 class="login-title">Login</h3>
                            <p class="login-subtitle">Log into your account</p>
                        </div>
                        
                        <div class="login-card">
                            <form @submit.prevent="submit">
                                <div class="modern-form-group mb-4">
                                    <label for="email" class="form-label">
                                        <i class="fas fa-envelope me-2 text-primary"></i>
                                        Email Address
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light">
                                            <i class="fas fa-at"></i>
                                        </span>
                                        <input 
                                            id="email" 
                                            v-model="form.email" 
                                            placeholder="Enter your email address" 
                                            class="form-control modern-input" 
                                            type="email"
                                            :class="{ 'is-invalid': form.errors.email }"
                                        />                                   
                                    </div>
                                    <div v-if="form.errors.email" class="error-message">
                                            <small >
                                                <i class="fas fa-exclamation-circle me-1"></i>
                                                {{ form.errors.email }}
                                            </small>
                                    </div>                                      
                                </div>
                                
                                <div class="modern-form-group mb-4">
                                    <label for="password" class="form-label">
                                        <i class="fas fa-lock me-2 text-danger"></i>
                                        Password
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light">
                                            <i class="fas fa-key"></i>
                                        </span>
                                        <input 
                                            id="password" 
                                            v-model="form.password" 
                                            placeholder="Enter your Password" 
                                            class="form-control modern-input" 
                                            type="password"
                                            :class="{ 'is-invalid': form.errors.password }"
                                        />
                                        <button 
                                            type="button" 
                                            class="input-group-text bg-light toggle-password" 
                                            @click="togglePassword"
                                        >
                                            <i class="fas" :class="showPassword ? 'fa-eye-slash' : 'fa-eye'"></i>
                                        </button>
                                    </div>
                                    <div v-if="form.errors.password" class="error-message">
                                        <small >
                                            <i class="fas fa-exclamation-circle me-1"></i>
                                            {{ form.errors.password }}
                                        </small>
                                    </div>  
                                </div>
                                
                                <div class="form-actions mt-4">
                                    <button 
                                        type="submit" 
                                        class="btn btn-primary login-btn me-2"
                                        :disabled="form.processing"
                                    >
                                        <span v-if="form.processing">
                                            <span class="spinner-border spinner-border-sm me-2" role="status"></span>
                                            Logging in...
                                        </span>
                                        <span v-else>
                                            <i class="fas fa-sign-in-alt me-2 pl-2"></i>
                                            Login
                                        </span>
                                    </button>
                                    
                                    <!-- Forgot Password Link -->
                                    <div class="text-end mt-2">
                                        <Link href="/send-otp" class="text-decoration-none forgot-password-link">
                                            <i class="fas fa-question-circle me-1"></i>
                                            Forgotten your password?
                                        </Link>
                                    </div>
                                </div>
                                
                                <!-- Alternative Options -->
                                <div class="alternative-options mt-4">
                                    <div class="separator">
                                        <span>OR</span>
                                    </div>
                                    
                                    <div class="row g-3 mt-3">
                                        <!-- Register Button -->
                                        <div class="col-6">
                                            <Link :href="route('RegistrationPage')" class="btn w-100 register-btn">
                                                <i class="fas fa-user-plus me-2"></i>
                                                Create New Account
                                            </Link>
                                        </div>
                                        
                                        <!-- Homepage Link -->
                                        <div class="col-6">
                                            <Link href="/" class="btn btn-outline-info w-100 home-btn">
                                                <i class="fas fa-home me-2"></i>
                                                Back to Homepage
                                            </Link>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="demo-credentials mt-4">
                                    <div class="alert alert-info">
                                        <h6 class="mb-2"><i class="fas fa-info-circle me-2"></i>Admin Demo Account</h6>
                                        <p class="mb-1"><strong>Email:</strong> admin@example.com</p>
                                        <p class="mb-0"><strong>Password:</strong> password</p>
                                    </div>
                                    <div class="alert alert-success">
                                        <h6 class="mb-2"><i class="fas fa-info-circle me-2"></i>Staff Demo Account</h6>
                                        <p class="mb-1"><strong>Email:</strong> staff@example.com</p>
                                        <p class="mb-0"><strong>Password:</strong> password</p>
                                    </div>                                    
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>


<script setup>
import { useForm, router, usePage, Link } from '@inertiajs/vue3';
import { createToaster } from "@meforma/vue-toaster";
import { ref, onMounted } from 'vue';

const toaster = createToaster();
const page = usePage();

// Form and validation
const form = useForm({
    email: '',
    password: ''
});

// Watch for toaster notification to show errors for unauthenticated access
if (page.props.flash.error) {
    toaster.error(page.props.flash.error);
}

// Password visibility toggle
const showPassword = ref(false);

function togglePassword() {
    showPassword.value = !showPassword.value;
    const passwordInput = document.getElementById('password');
    passwordInput.type = showPassword.value ? 'text' : 'password';
}

function submit() {
    form.post(route('login'), {
        onSuccess: () => {
            if (page.props.flash.status) {
                router.get(route('DashboardPage'));
            } else {
                toaster.error(page.props.flash.message);
            }
        },
        onError: (errors) => {
            Object.keys(errors).forEach(key => {
                if (errors[key]) {
                toaster.error(errors[key]);
                }
            });
        }
    });
}    

onMounted(() => {
    // Add animation class after component is mounted
    setTimeout(() => {
        document.querySelector('.form-container').classList.add('loaded');
    }, 100);
});
</script>

<style scoped>
@import '@/Assets/css/formStyles.css';

/* Component-specific mobile adjustments */
@media (max-width: 576px) {
    .login-card {
        padding: 1.5rem;
    }
    
    .login-title {
        font-size: 1.75rem;
    }
}
</style>
