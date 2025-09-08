<template>
    <div class="verify-otp-page">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-5 col-md-7 col-sm-9">
                    <div class="verify-otp-container form-container" :class="{ 'loaded': isLoaded }">
                        <div class="text-center mb-4">
                            <div class="brand-logo mb-3">
                                <i class="fas fa-shield-alt fa-3x text-primary"></i>
                            </div>
                            <h3 class="verify-title">Verify OTP</h3>
                            <p class="verify-subtitle">Enter the 4-digit code sent to your email</p>
                        </div>
                        
                        <div class="verify-card">
                            <form @submit.prevent="submit">
                                <div class="modern-form-group mb-4">
                                    <label for="otp" class="form-label">
                                        <i class="fas fa-key me-2 text-warning"></i>
                                        OTP Code
                                    </label>
                                    
                                    <div class="otp-input-container">
                                        <div class="otp-input-wrapper">
                                            <input 
                                                id="otp" 
                                                v-model="form.otp" 
                                                placeholder="Enter 4-digit code" 
                                                class="form-control modern-input text-center" 
                                                type="text" 
                                                maxlength="4"
                                                :class="{ 'is-invalid': otpError }"
                                                autofocus
                                            />
                                        </div>
                                    </div>
                                    
                                    <small v-if="otpError" class="error-message">
                                        <i class="fas fa-exclamation-circle me-1"></i>
                                        {{ otpError }}
                                    </small>
                                    
                                    <p class="form-text mt-2">
                                        <i class="fas fa-info-circle me-1 text-primary"></i>
                                        Enter the 4-digit code sent to your email
                                    </p>
                                    
                                    <div class="countdown-timer text-center mt-3" v-if="countdown > 0">
                                        <p class="mb-0">
                                            <i class="fas fa-clock me-1"></i>
                                            <span class="text-danger">{{ formatTime(countdown) }}</span> seconds left to enter the code
                                        </p>
                                    </div>
                                </div>
                                
                                <div class="form-actions mt-4">
                                    <div class="d-grid gap-2">
                                        <button 
                                            type="submit" 
                                            class="btn btn-primary verify-btn"
                                            :disabled="form.processing"
                                        >
                                            <span v-if="form.processing">
                                                <span class="spinner-border spinner-border-sm me-2" role="status"></span>
                                                Please wait...
                                            </span>
                                            <span v-else>
                                                <i class="fas fa-check-circle me-2"></i>
                                                Verify
                                            </span>
                                        </button>
                                    </div>
                                    
                                    <div class="text-center mt-4">
                                        <p class="mb-2">Didn’t receive the code?</p>
                                        <button 
                                            type="button" 
                                            class="btn btn-link p-0"
                                            @click="resendOtp"
                                            :disabled="countdown > 0 || resending"
                                        >
                                            <i class="fas fa-sync-alt me-1" :class="{ 'fa-spin': resending }"></i>
                                            Resend Code
                                        </button>
                                    </div>
                                    
                                    <div class="text-center mt-3">
                                        <Link href="/send-otp" class="text-decoration-none">
                                            <i class="fas fa-arrow-left me-1"></i>
                                            Back to Send OTP Page
                                        </Link>
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
import { useForm, router, usePage, Link } from '@inertiajs/vue3'
import { ref, onMounted, onBeforeUnmount } from 'vue'
import { createToaster } from "@meforma/vue-toaster";

const form = useForm({ otp: '' })
const toaster = createToaster();
const page = usePage()

const otpError = ref('')
const countdown = ref(300) // 5 minutes in seconds
const timer = ref(null)
const resending = ref(false)
const isLoaded = ref(false)

// Format time to MM:SS
function formatTime(seconds) {
    const mins = Math.floor(seconds / 60)
    const secs = seconds % 60
    return `${mins}:${secs < 10 ? '0' + secs : secs}`
}

// Start countdown timer
function startCountdown() {
    timer.value = setInterval(() => {
        if (countdown.value > 0) {
            countdown.value--
        } else {
            clearInterval(timer.value)
        }
    }, 1000)
}

// Reset countdown timer
function resetCountdown() {
    countdown.value = 300 // 5 minutes
    clearInterval(timer.value)
    startCountdown()
}

// Validate OTP input
function validateOtp(otp) {
    return /^\d{4}$/.test(otp)
}

// Resend OTP
function resendOtp() {
    resending.value = true
    
    const emailForm = useForm({
        email: localStorage.getItem('reset_email') || ''
    })
    
    if (!emailForm.email) {
        toaster.error("Email not found, please try again")
        router.get('/send-otp')
        return
    }
    
    emailForm.post("/send-otp", {
        onSuccess: () => {
            if (page.props.flash.status === true) {
                resetCountdown()
                toaster.success("New OTP code has been sent")
            } else {
                toaster.error(page.props.flash.message || "Failed to send OTP")
            }
            resending.value = false
        },
        onError: () => {
            toaster.error("Please try again later")
            resending.value = false
        }
    })
}

// Submit form
function submit() {
    // Reset error messages
    otpError.value = ''
    
    // Basic validation
    if(!form.otp || form.otp.length === 0) {
        otpError.value = 'OTP code is required'
        toaster.error("Please enter the OTP code")
        return
    }
    
    if(!validateOtp(form.otp)) {
        otpError.value = 'Please enter a valid 4-digit OTP code'
        toaster.error("Please enter a valid 4-digit OTP code")
        return
    }
    
    // Submit the form
    form.post("/verify-otp", {
        onSuccess: () => {
            if(page.props.flash.status === true) {
                toaster.success("OTP verification successful")
                router.get("/reset-password")
            } else {
                otpError.value = page.props.flash.message || "Wrong OTP code"
                toaster.error(page.props.flash.message || "Wrong OTP code")
            }
        },
        onError: (errors) => {
            if(errors.otp) {
                otpError.value = errors.otp
                toaster.error(errors.otp)
            }
        }
    })
}

// Save email to localStorage when coming from send-otp page
onMounted(() => {
    // Start countdown timer
    startCountdown()
    
    // Check if email is in page props and save it
    if (page.props.flash && page.props.flash.email) {
        localStorage.setItem('reset_email', page.props.flash.email)
    }
    
    // Set form container to loaded immediately
    isLoaded.value = true
})

// Clear timer when component is destroyed
onBeforeUnmount(() => {
    clearInterval(timer.value)
})
</script>

<style scoped>
@import '@/Assets/css/formStyles.css';

/* Page specific styles */
.verify-otp-page {
    padding: 40px 0;
}

.verify-otp-container {
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

.verify-title {
    font-weight: 700;
    color: #333;
    margin-bottom: 0.5rem;
}

.verify-subtitle {
    color: #6c757d;
    margin-bottom: 1.5rem;
}

.otp-input-container {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-bottom: 1rem;
}

.otp-input-wrapper {
    width: 100%;
    max-width: 200px;
}

/* Override modern-input styles for OTP */
.modern-input.text-center {
    font-size: 1.25rem;
    font-weight: 600;
    letter-spacing: 4px;
}

.verify-btn {
    padding: 0.75rem 1.5rem;
    font-weight: 600;
    transition: all 0.3s ease;
}

.verify-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(13, 110, 253, 0.2);
}

.countdown-timer {
    background-color: rgba(13, 110, 253, 0.05);
    border-radius: 8px;
    padding: 10px;
}
</style>

