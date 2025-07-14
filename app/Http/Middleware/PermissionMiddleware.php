<?php

namespace App\Http\Middleware;

use App\Models\User;
use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class PermissionMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, string $permission): Response
    {

        $user_id=$request->session()->get('user_id','default');

        /** @var \App\Models\User $user */
        $user = User::find($user_id);
        if (!$user) {
            return redirect()->route('LoginPage');
        }
        if (!$user->hasPermission($permission)) {
            abort(403, 'Unauthorized. You do not have the required permission.');
        }

        return $next($request);
    }
}
