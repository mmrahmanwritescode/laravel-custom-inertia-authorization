
<template>
    <div class="reset-password-page">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-5 col-md-7 col-sm-9">
                    <div class="reset-password-container form-container" :class="{ 'loaded': isLoaded }">
                        <div class="text-center mb-4">
                            <div class="brand-logo mb-3">
                                <i class="fas fa-lock-open fa-3x text-primary"></i>
                            </div>
                            <h3 class="reset-title">Reset with new password</h3>
                            <p class="reset-subtitle">Please choose a strong password</p>
                        </div>
                        
                        <div class="reset-password-card">
                            <form @submit.prevent="submit">
                                <!-- New Password Field -->
                                <div class="modern-form-group mb-4">
                                    <label for="password" class="form-label">
                                        <i class="fas fa-lock me-2 text-danger"></i>
                                        New Password
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light">
                                            <i class="fas fa-key"></i>
                                        </span>
                                        <input 
                                            id="password" 
                                            v-model="form.password" 
                                            placeholder="Enter new password" 
                                            class="form-control modern-input" 
                                            :type="showPassword ? 'text' : 'password'"
                                            :class="{ 'is-invalid': passwordError }"
                                            autocomplete="new-password"
                                            ref="passwordInput"
                                            autofocus
                                        />
                                        <button 
                                            type="button" 
                                            class="input-group-text bg-light toggle-password" 
                                            @click="togglePassword"
                                        >
                                            <i class="fas" :class="showPassword ? 'fa-eye-slash' : 'fa-eye'"></i>
                                        </button>
                                    </div>
                                    <small v-if="passwordError" class="error-message">
                                        <i class="fas fa-exclamation-circle me-1"></i>
                                        {{ passwordError }}
                                    </small>
                                    
                                    <!-- Password Strength Meter -->
                                    <div class="password-strength mt-2" v-if="form.password">
                                        <div class="progress" style="height: 5px;">
                                            <div class="progress-bar" :class="passwordStrengthClass" :style="{ width: passwordStrength + '%' }"></div>
                                        </div>
                                        <small class="d-flex justify-content-between mt-1">
                                            <span>Strength:</span>
                                            <span :class="passwordStrengthTextClass">{{ passwordStrengthText }}</span>
                                        </small>
                                    </div>
                                </div>
                                
                                <!-- Confirm Password Field -->
                                <div class="modern-form-group mb-4">
                                    <label for="cpassword" class="form-label">
                                        <i class="fas fa-lock me-2 text-danger"></i>
                                        Confirm New Password
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light">
                                            <i class="fas fa-key"></i>
                                        </span>
                                        <input 
                                            id="cpassword" 
                                            v-model="form.cpassword" 
                                            placeholder="Type new password again" 
                                            class="form-control modern-input" 
                                            :type="showConfirmPassword ? 'text' : 'password'"
                                            :class="{ 'is-invalid': confirmPasswordError }"
                                            autocomplete="new-password"
                                        />
                                        <button 
                                            type="button" 
                                            class="input-group-text bg-light toggle-password" 
                                            @click="toggleConfirmPassword"
                                        >
                                            <i class="fas" :class="showConfirmPassword ? 'fa-eye-slash' : 'fa-eye'"></i>
                                        </button>
                                    </div>
                                    <small v-if="confirmPasswordError" class="error-message">
                                        <i class="fas fa-exclamation-circle me-1"></i>
                                        {{ confirmPasswordError }}
                                    </small>
                                </div>
                                
                                <div class="form-actions mt-4">
                                    <div class="d-grid gap-2">
                                        <button 
                                            type="submit" 
                                            class="btn btn-primary reset-btn"
                                            :disabled="form.processing"
                                        >
                                            <span v-if="form.processing">
                                                <span class="spinner-border spinner-border-sm me-2" role="status"></span>
                                                Wait...
                                            </span>
                                            <span v-else>
                                                <i class="fas fa-check-circle me-2"></i>
                                                Change Password
                                            </span>
                                        </button>
                                    </div>
                                    
                                    <div class="text-center mt-3">
                                        <Link href="/login" class="text-decoration-none">
                                            <i class="fas fa-arrow-left me-1"></i>
                                            Back to Login
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
import { createToaster } from "@meforma/vue-toaster";
import { ref, computed, onMounted } from 'vue'

const toaster = createToaster();
const form = useForm({ password: '', cpassword: '' })
const page = usePage()

const passwordError = ref('')
const confirmPasswordError = ref('')
const showPassword = ref(false)
const showConfirmPassword = ref(false)
const passwordInput = ref(null)
const isLoaded = ref(false)

// Toggle password visibility
function togglePassword() {
    showPassword.value = !showPassword.value
}

// Toggle confirm password visibility
function toggleConfirmPassword() {
    showConfirmPassword.value = !showConfirmPassword.value
}

// Password strength calculation
const passwordStrength = computed(() => {
    if (!form.password) return 0
    
    let strength = 0
    const password = form.password
    
    // Length check
    if (password.length >= 8) strength += 25
    
    // Contains uppercase letters
    if (password.match(/[A-Z]/)) strength += 25
    
    // Contains lowercase letters
    if (password.match(/[a-z]/)) strength += 25
    
    // Contains numbers or special characters
    if (password.match(/[0-9!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?]/)) strength += 25
    
    return strength
})

// Password strength text
const passwordStrengthText = computed(() => {
    const strength = passwordStrength.value
    if (strength === 0) return ''
    if (strength <= 25) return 'Weak'
    if (strength <= 50) return 'Fair'
    if (strength <= 75) return 'Good'
    return 'Strong'
})

// Password strength class
const passwordStrengthClass = computed(() => {
    const strength = passwordStrength.value
    if (strength <= 25) return 'bg-danger'
    if (strength <= 50) return 'bg-warning'
    if (strength <= 75) return 'bg-info'
    return 'bg-success'
})

// Password strength text color
const passwordStrengthTextClass = computed(() => {
    const strength = passwordStrength.value
    if (strength <= 25) return 'text-danger'
    if (strength <= 50) return 'text-warning'
    if (strength <= 75) return 'text-info'
    return 'text-success'
})

// Validate password
function validatePassword(password) {
    if (!password || password.length < 6) {
        return 'Password must be at least 6 characters long'
    }
    return ''
}

// Form submission
function submit() {
    // Reset error messages
    passwordError.value = ''
    confirmPasswordError.value = ''
    
    // Validate password
    if (!form.password) {
        passwordError.value = 'Password is required'
        toaster.error("Password is required")
        return
    }
    
    // Validate password strength
    const passValidation = validatePassword(form.password)
    if (passValidation) {
        passwordError.value = passValidation
        toaster.error(passValidation)
        return
    }
    
    // Validate confirm password
    if (!form.cpassword) {
        confirmPasswordError.value = 'Confirm your password'
        toaster.error("Confirm your password")
        return
    }
    
    // Check if passwords match
    if (form.password !== form.cpassword) {
        confirmPasswordError.value = 'Passwords do not match'
        toaster.error("Passwords do not match")
        return
    }
    
    // Submit the form
    form.post("/reset-password", {
        onSuccess: () => {
            if (page.props.flash.status === true) {
                toaster.success("Password has been reset successfully!")
                router.get("/login")
            } else {
                toaster.error(page.props.flash.message || "Password reset failed")
            }
        },
        onError: (errors) => {
            if (errors.password) {
                passwordError.value = errors.password
            }
            if (errors.cpassword) {
                confirmPasswordError.value = errors.cpassword
            }
        }
    })
}

// Focus on password input when component is mounted
onMounted(() => {
    if (passwordInput.value) {
        passwordInput.value.focus()
    }
    
    // Set form container to loaded immediately
    isLoaded.value = true
})
</script>

<style scoped>
@import '@/Assets/css/formStyles.css';

/* Page specific styles */
.reset-password-page {
    padding: 40px 0;
}

.reset-password-container {
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

.reset-title {
    font-weight: 700;
    color: #333;
    margin-bottom: 0.5rem;
}

.reset-subtitle {
    color: #6c757d;
    margin-bottom: 1.5rem;
}

.toggle-password {
    cursor: pointer;
}

.reset-btn {
    padding: 0.75rem 1.5rem;
    font-weight: 600;
    transition: all 0.3s ease;
}

.reset-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(13, 110, 253, 0.2);
}

.password-strength {
    font-size: 0.8rem;
}
</style>