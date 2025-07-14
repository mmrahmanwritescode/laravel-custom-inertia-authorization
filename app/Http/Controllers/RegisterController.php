<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Inertia\Inertia;

class RegisterController extends Controller
{

    public function RegistrationPage(Request $request)
    {
        $email=$request->session()->get('email','default'); //dd($email);

        if($email != 'default') {
            return redirect()->route('DashboardPage');
        }
        return Inertia::render('User/Register');
    }   
    
    function register(Request $request){

        try {
            $email=$request->input('email');
            $name=$request->input('name');
            $password=$request->input('password');

            $user = User::create([
                'name'=>$name,
                'email'=>$email,
                'password'=>Hash::make($password)
            ]);

            // Assign default 'staff' role to new users
            $staffRole = \App\Models\Role::where('name', 'staff')->first();
            if ($staffRole) {
                $user->roles()->attach($staffRole);
            }

            session()->flash('message', 'Registration Successful');
            session()->flash('status', true);
            session()->flash('error', '');

            return  redirect()->route('RegistrationPage');
        }
        catch (\Exception $e) {
            session()->flash('message', 'Registration Fail');
            session()->flash('status', false);
            session()->flash('error', $e->getMessage());
        }

    } 
}
