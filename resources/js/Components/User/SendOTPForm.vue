
<template>
    <div class="send-otp-page">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-5 col-md-7 col-sm-9">
                    <div class="send-otp-container form-container" :class="{ 'loaded': isLoaded }">
                        <div class="text-center mb-4">
                            <div class="brand-logo mb-3">
                                <i class="fas fa-envelope-open-text fa-3x text-primary"></i>
                            </div>
                            <h3 class="send-otp-title">Reset Password</h3>
                            <p class="send-otp-subtitle">An OTP will be sent to your email address</p>
                        </div>
                        
                        <div class="send-otp-card">
                            <form @submit.prevent="submit">
                                <div class="modern-form-group mb-4">
                                    <label for="email" class="form-label">
                                        <i class="fas fa-envelope me-2 text-primary"></i>
                                        Email
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light">
                                            <i class="fas fa-at"></i>
                                        </span>
                                        <input 
                                            id="email" 
                                            v-model="form.email" 
                                            placeholder="Enter your email" 
                                            class="form-control modern-input" 
                                            type="email"
                                            :class="{ 'is-invalid': emailError }"
                                            autofocus
                                        />
                                    </div>
                                    <small v-if="emailError" class="error-message">
                                        <i class="fas fa-exclamation-circle me-1"></i>
                                        {{ emailError }}
                                    </small>
                                    <p class="form-text mt-2">
                                        <i class="fas fa-info-circle me-1 text-primary"></i>
                                        We will send a One Time Password (OTP) to this email address
                                    </p>
                                </div>
                                
                                <div class="form-actions mt-4">
                                    <div class="d-grid gap-2">
                                        <button 
                                            type="submit" 
                                            class="btn btn-primary send-otp-btn"
                                            :disabled="form.processing"
                                        >
                                            <span v-if="form.processing">
                                                <span class="spinner-border spinner-border-sm me-2" role="status"></span>
                                                Sending OTP...
                                            </span>
                                            <span v-else>
                                                <i class="fas fa-paper-plane me-2"></i>
                                                Send OTP
                                            </span>
                                        </button>
                                    </div>
                                </div>
                                
                                <div class="additional-options mt-4 text-center">
                                    <p class="mb-0">
                                        <Link href="/login" class="text-decoration-none">
                                            <i class="fas fa-arrow-left me-1"></i>
                                            Back to Login
                                        </Link>
                                    </p>
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
import { useForm, router, usePage, Link } from '@inertiajs/vue3'
import { ref, onMounted } from 'vue'
import { createToaster } from "@meforma/vue-toaster";

const form = useForm({ email: '' })
const toaster = createToaster();
const page = usePage()
const emailError = ref('')
const isLoaded = ref(false)

// Initialize component
onMounted(() => {
    isLoaded.value = true;
})

function validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return re.test(email)
}

function submit(){
    // Reset error message
    emailError.value = ''
    
    // Validate email
    if(!form.email || form.email.length === 0){
        emailError.value = 'Email is required'
        toaster.error("Provide Your Email")
        return
    }
    
    if(!validateEmail(form.email)) {
        emailError.value = 'Invalid Email Address'
        toaster.error("Invalid email address")
        return
    }
    
    // Store email in localStorage for potential use in OTP verification
    localStorage.setItem('reset_email', form.email)
    
    // Submit the form
    form.post("/send-otp", {
        onSuccess: () => {
            if(page.props.flash.status === true){
                toaster.success("ওটিপি পাঠানো হয়েছে")
                router.get("/verify-otp")
            } else {
                emailError.value = page.props.flash.message || "ইমেইল পাওয়া যায়নি"
                toaster.error(page.props.flash.message || "ইমেইল পাওয়া যায়নি")
            }
        },
        onError: (errors) => {
            if(errors.email) {
                emailError.value = errors.email
            }
        }
    })
}
</script>

<style scoped>
@import '@/Assets/css/formStyles.css';

/* Page specific styles */
.send-otp-page {
    padding: 40px 0;
}

.send-otp-container {
    max-width: 500px;
    margin: 0 auto;
}

/* Override form container styles */
.form-container {
    background-color: #ffffff;
    border-radius: 12px;
    box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
    padding: 2.5rem;
    opacity: 1;
    transition: transform 0.3s ease;
}

.form-container:hover {
    transform: translateY(-5px);
}

.brand-logo {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    background-color: rgba(13, 110, 253, 0.1);
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto;
}

.send-otp-title {
    font-weight: 700;
    color: #333;
    margin-bottom: 0.5rem;
}

.send-otp-subtitle {
    color: #6c757d;
    margin-bottom: 1.5rem;
}

.send-otp-btn {
    padding: 0.75rem 1.5rem;
    font-weight: 600;
    transition: all 0.3s ease;
}

.send-otp-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(13, 110, 253, 0.2);
}
</style>
