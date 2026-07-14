import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, tap } from 'rxjs';

@Injectable({
    providedIn: 'root'
})
export class AuthService {
    private readonly ACCESS_TOKEN_KEY = 'access_token';
    private readonly REFRESH_TOKEN_KEY = 'refresh_token';

    constructor(private http: HttpClient) {}

    public setTokens(accessToken: string, refreshToken: string): void {
        localStorage.setItem(this.ACCESS_TOKEN_KEY, accessToken);
        localStorage.setItem(this.REFRESH_TOKEN_KEY, refreshToken);
    }

    public getAccessToken(): string | null {
        return localStorage.getItem(this.ACCESS_TOKEN_KEY);
    }

    public getRefreshToken(): string | null {
        return localStorage.getItem(this.REFRESH_TOKEN_KEY);
    }

    public clearTokens(): void {
        localStorage.removeItem(this.ACCESS_TOKEN_KEY);
        localStorage.removeItem(this.REFRESH_TOKEN_KEY);
    }

    public refreshAccessToken(): Observable<any> {
        const refreshToken = this.getRefreshToken();
        return this.http.post('/api/auth/refresh', { refreshToken }).pipe(
            tap((response: any) => {
                this.setTokens(response.accessToken, response.refreshToken);
            })
        );
    }

    public login(email: string, password: string): Observable<any> {
        return this.http.post('/api/auth/login', { email, password }).pipe(
            tap((response: any) => {
                this.setTokens(response.accessToken, response.refreshToken);
            })
        );
    }

    public loginWithGoogle(token: string): Observable<any> {
        return this.http.post('/api/auth/google', { token }).pipe(
            tap((response: any) => {
                this.setTokens(response.accessToken, response.refreshToken);
            })
        );
    }

    public logout(): void {
        this.clearTokens();
    }
}