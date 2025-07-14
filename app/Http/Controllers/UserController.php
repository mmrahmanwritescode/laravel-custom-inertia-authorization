<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Role;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Inertia\Inertia;
use Inertia\Response;

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): Response
    {
        $users = User::with('roles')->get();
        
        return Inertia::render('Users/Index', [
            'users' => $users
        ]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): Response
    {
        $roles = Role::all();
        
        return Inertia::render('Users/Create', [
            'roles' => $roles
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        try {
            $request->validate([
                'name' => 'required|string|max:255',
                'email' => 'required|string|email|max:255|unique:users',
                'password' => 'required|string|min:3|confirmed',
                'password_confirmation' => 'required|string|min:3',
                'roles' => 'array',
                'roles.*' => 'exists:roles,id'
            ], [
                'password.required' => 'Password is required.',
                'password.min' => 'Password must be at least 8 characters long.',
                'password.confirmed' => 'Password confirmation does not match.',
                'password_confirmation.required' => 'Password confirmation is required.',
                'password_confirmation.min' => 'Password confirmation must be at least 8 characters long.',
            ]);

            $user = User::create([
                'name' => $request->name,
                'email' => $request->email,
                'password' => Hash::make($request->password),
            ]);

            if ($request->roles) {
                $user->roles()->attach($request->roles);
            }

            return redirect()->route('users.index')->with([
                'message' => 'User Created Successfully',
                'status' => true,
                'error' => ''
            ]);
        } catch (\Exception $e) {
            return redirect()->back()->with([
                'message' => 'Failed to create user',
                'status' => false,
                'error' => $e->getMessage()
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(User $user): Response
    {
        $user->load('roles');
        $roles = Role::all();
        
        return Inertia::render('Users/Edit', [
            'user' => $user,
            'roles' => $roles
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, User $user)
    {
        try {
            $request->validate([
                'name' => 'required|string|max:255',
                'email' => 'required|string|email|max:255|unique:users,email,' . $user->id,
                'password' => 'nullable|string|min:3|confirmed',
                'password_confirmation' => 'nullable|string|min:3',
                'roles' => 'array',
                'roles.*' => 'exists:roles,id'
            ], [
                'password.min' => 'Password must be at least 8 characters long.',
                'password.confirmed' => 'Password confirmation does not match.',
                'password_confirmation.min' => 'Password confirmation must be at least 8 characters long.',
            ]);

            // Additional validation: if password is provided, password_confirmation must also be provided
            if ($request->filled('password') && !$request->filled('password_confirmation')) {
                return redirect()->back()
                    ->withErrors(['password_confirmation' => 'Password confirmation is required when changing password.'])
                    ->withInput()
                    ->with([
                        'message' => 'Password confirmation is required.',
                        'status' => false,
                        'error' => 'Validation failed.'
                    ]);
            }

            // Additional validation: if password_confirmation is provided, password must also be provided
            if ($request->filled('password_confirmation') && !$request->filled('password')) {
                return redirect()->back()
                    ->withErrors(['password' => 'Password is required when providing password confirmation.'])
                    ->withInput()
                    ->with([
                        'message' => 'Password is required when providing confirmation.',
                        'status' => false,
                        'error' => 'Validation failed.'
                    ]);
            }

            $updateData = [
                'name' => $request->name,
                'email' => $request->email,
            ];

            if ($request->filled('password')) {
                $updateData['password'] = Hash::make($request->password);
            }

            $user->update($updateData);
            $user->roles()->sync($request->roles ?? []);

            return redirect()->route('users.edit', $user)->with([
                'message' => 'User Updated Successfully',
                'status' => true,
                'error' => ''
            ]);
        } catch (\Exception $e) {
            return redirect()->back()->with([
                'message' => 'Failed to update user',
                'status' => false,
                'error' => $e->getMessage()
            ]);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(User $user)
    {
        $user->delete();

        $data = ['message' => 'User Deleted Successfully', 'status' => true, 'error' => ''];
        return redirect()->route('users.index')->with($data);
    }
}
