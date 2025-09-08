<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Inertia\Inertia;
use App\Mail\OTPMail;

class LoginController extends Controller
{
 public function LoginPage(Request $request)
    {
        $email=$request->session()->get('email','default'); //dd($email);

        if($email != 'default') {
            return redirect()->route('DashboardPage');
        }

        return Inertia::render('Auth/Login');
    }  
    
    function login(Request $request) { //dd(Hash::make($request->input('password')));

        $request->validate([
            'email' => 'required|string|email|max:255',
            'password' => 'required|string|min:6',
        ]);

        // Retrieving the user by email
        $user = User::where('email', $request->input('email'))->first();

        // Checking if user exists and verify password
        if ($user && Hash::check($request->input('password'), $user->password)) {

            // Regenerate session for security
            $request->session()->regenerate(); //dd($user);
            
            $email=$request->input('email');
            $request->session()->put('email',$email);
            $request->session()->put('user_id',$user->id);
            $request->session()->put('name',$user->name);
            $request->session()->put('role',$user->role);

            return redirect()->route('DashboardPage')->with([
                'message' => 'Login Successful',
                'status' => true,
                'error' => ''
            ]);
        }

        // Login failed
        return back()->with([
            'message' => 'Login Failed - Invalid email or password!',
            'status' => false,
            'error' => 'Invalid email or password'
        ]);

    }    

    function logout(Request $request){
//        echo 'logout'; exit;
        $request->session()->invalidate();
        $request->session()->regenerateToken();
        return redirect()->route('LoginPage');

    }    


    public function SendOtpPage(Request $request)
    {
        $email=$request->session()->get('email','default'); //dd($email);

        if($email != 'default') {
            return redirect()->route('DashboardPage');
        }
        
        // Return with metadata for better SEO
        return Inertia::render('Auth/SendOTP', [
            'meta' => [
                'title' => 'Reset Password',
                'description' => 'Send OTP to reset your password'
            ]
        ]);
    }    


    function SendOTPCode(Request $request){

        $email=$request->input('email');
        $otp=rand(1000,9999);
        $count=User::where('email','=',$email)->count();

        if($count==1){
            Mail::to($email)->send(new OTPMail($otp));
            User::where('email','=',$email)->update(['otp'=>$otp]);

            $request->session()->put('otp-verify-email',$email);

             return redirect()->route('VerifyOtpPage')->with([
                'message' => 'OTP sent to your email',
                'status' => true,
                'error' => ''
            ]);
        }

        return back()->with([
            'message' => 'We could not find your account!',
            'status' => false,
            'error' => 'Invalid email'
        ]);
    }    


    public function VerifyOtpPage(Request $request)
    {
        $email=$request->session()->get('email','default'); //dd($email);

        if($email != 'default') {
            return redirect()->route('DashboardPage');
        }
        
        // Return with metadata for better SEO
        return Inertia::render('Auth/VerifyOTP', [
            'meta' => [
                'title' => 'Verify OTP',
                'description' => 'Verify OTP to reset your password'
            ]
        ]);
    }

    function VerifyOTP(Request $request){
        $email=$request->session()->get('otp-verify-email','default');

        $otp=$request->input('otp');
        $count=User::where('email','=',$email)->where('otp','=',$otp)->count();

        if($count==1){
            User::where('email','=',$email)->update(['otp'=>'0']);
            $request->session()->put('otp_verify','yes');

            return redirect()->route('ResetPasswordPage')->with([
                'message' => 'OTP verified, you can reset your password now',
                'status' => true,
                'error' => ''
            ]);
        }
        return back()->with([
            'message' => 'Invalid OTP, please try again',
            'status' => false,
            'error' => 'Invalid OTP'
        ]);
    }

    public function ResetPasswordPage(Request $request)
    {
        $email=$request->session()->get('email','default'); //dd($email);

        if($email != 'default') {
            return redirect()->route('DashboardPage');
        }
        
        // Return with metadata for better SEO
        return Inertia::render('Auth/ResetPassword', [
            'meta' => [
                'title' => 'Reset Password',
                'description' => 'Reset your password'
            ]
        ]);
    }   

    function ResetPassword(Request $request){

        try{
            $email=$request->session()->get('otp-verify-email','default');
            $password=$request->input('password');
            $otp_verify=$request->session()->get('otp_verify','default');

            if($otp_verify==="yes"){
                // Hash the password before saving
                User::where('email','=',$email)->update(['password'=>Hash::make($password)]);

                $request->session()->put('otp-verify-email',''); // resetting otp-verify-email to empty
                $request->session()->put('otp_verify','');  // resetting otp_verify to empty
                
                return redirect()->route('LoginPage')->with([
                    'message' => 'Password changed successfully, you can login now',
                    'status' => true,
                    'error' => ''
                ]);
            }

            return redirect()->route('SendOtpPage')->with([
                'message' => 'Unauthorized access, please verify OTP first',
                'status' => false,
                'error' => true
            ]);

        } catch (\Exception $e){
            return redirect()->route('ResetPasswordPage')->with([
                'message' => 'Failed to reset password',
                'status' => false,
                'error' => $e->getMessage()
            ]);
        }
    }    
}
