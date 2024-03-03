import { Component } from '@angular/core';
import {Router} from "@angular/router";
import {LobbyService} from "../../shared/lobby.service";

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [],
  templateUrl: './login.component.html',
  styleUrl: './login.component.css'
})
export class LoginComponent {
  public username: string = "";

  constructor (
    private router: Router,
    private lobbyService: LobbyService,
  ) {}

  public onKey(event: KeyboardEvent): void {
    if (event.key === "Enter") {
      if (!this.lobbyService.setUsername(this.username)) {
        return;
      }

      this.router.navigate(["lobby"]).catch(e => console.error(e));
      return;
    }

    this.username += (event.target as HTMLInputElement).value;
  }
}
