import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AuthService } from '../../services/auth'; 
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  imports: [CommonModule, FormsModule],
  templateUrl: './login.html',
  styleUrl: './login.css',
})
export class Login {
credentials = { email: '', password: '' };

  constructor(private authService: AuthService, private router: Router) {}

  onLogin(event: Event) {
    event.preventDefault();
    this.authService.login(this.credentials).subscribe({
      next: (res) => {
        console.log('¡Token recibido!', res.token);
        this.authService.saveToken(res.token);
        this.router.navigate(['/tiendas']);
      },
      error: (err) => {
        console.error('Error en login', err);
        alert('Credenciales incorrectas');
      }
    });
  }
}
