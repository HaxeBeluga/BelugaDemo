package modules.account_demo;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.module.account.model.User;
import beluga.module.account.ESubscribeFailCause;
import beluga.module.account.Account;
import haxe.Resource;
import main_view.Renderer;

#if php
import php.Web;
#end

/**
 * Beluga #1
 * @author Masadow
 */

class AccountDemo
{

	public var beluga(default, null) : Beluga;
	public var acc(default, null) : Account;

	public function new(beluga : Beluga) {
		this.beluga = beluga;
		this.acc = beluga.getModuleInstance(Account);
	}

	/*
	 * Logination
	 */
	@trigger("beluga_account_login_success")
	public static function _loginSuccess(u:User) {
		new AccountDemo(Beluga.getInstance()).loginSuccess();
	}

	public function loginSuccess() {
		var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "Authentification succeeded !"});
		Sys.print(html);
	}

	@trigger("beluga_account_login_fail")
	public static function _loginFail() {
		new AccountDemo(Beluga.getInstance()).loginFail();
	}

	public function loginFail() {
		var widget = acc.getWidget("login");
		widget.context = {error : "Invalid login and/or password"};
		var loginWidget = widget.render();
		var html = Renderer.renderDefault("page_login", "Authentification", {
			loginWidget: loginWidget
		});
		Sys.print(html);
	}

	@trigger("beluga_account_logout")
	public static function _logout() {
		new AccountDemo(Beluga.getInstance()).logout();
	}

	public function logout() {
		var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "You're disconnected"});
		Sys.print(html);
	}

	/*
	 *  Subscription
	 */
	@trigger("beluga_account_subscribe_success")
	public static function _subscribeSuccess(user : User) {
		new AccountDemo(Beluga.getInstance()).subscribeSuccess(user);
	}
	 
	public function subscribeSuccess(user : User) {
		var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "Subscribe succeeded !"});
		Sys.print(html);
	}

	@trigger("beluga_account_subscribe_fail")
	public static function _subscribeFail(error : String) {
		new AccountDemo(Beluga.getInstance()).subscribeFail(error);
	}

	public function subscribeFail(error : String) {
		var subscribeWidget = acc.getWidget("subscribe");

		subscribeWidget.context = {error : error};
		var html = Renderer.renderDefault("page_subscribe", "Inscription", {
			subscribeWidget: subscribeWidget.render(), error : error
		});
		Sys.print(html);
	}

	@trigger("beluga_account_show_user")
	public function _printCustomUserInfo(args: { id: Int }) {
		new AccountDemo(Beluga.getInstance()).printCustomUserInfo(args);
	}

	public function printCustomUserInfo(args: { id: Int }) {
		var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

		if (user == null) {
			var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "", error : ""});
			Sys.print(html);
			return;
		}
		var subscribeWidget = acc.getWidget("info");
		subscribeWidget.context = {user : user, path : "/accountDemo/"};

		var html = Renderer.renderDefault("page_subscribe", "Information", {
			subscribeWidget: subscribeWidget.render()
		});
		Sys.print(html);
	}
}