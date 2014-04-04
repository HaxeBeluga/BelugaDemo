package ;

import beluga.core.Beluga;
import beluga.core.api.BelugaApi;
import beluga.core.Trigger;
import beluga.core.Widget;
import beluga.core.BelugaException;
import haxe.web.Dispatch;
import php.Web;
import haxe.Resource;
import haxe.crypto.Md5;
import beluga.module.account.model.User;
import AccountDemo;
import src.view.Renderer;

/**
 * Beluga #1
 * Load the account class
 * Use it to generate login form, subscribe form, logged homepage
 * @author Masadow
 */

class Main 
{
	public static var beluga : Beluga;

	static function main()
	{
		try {
			beluga = Beluga.getInstance();
//			var server : String = untyped $_SERVER['SCRIPT_NAME'];
			var src : String = untyped __var__('_SERVER', 'SCRIPT_NAME');
			var url : String = StringTools.replace(Web.getURI(), src.substr(0, src.length - "/index.php".length), "");
			Dispatch.run(url, Web.getParams(), new Main());
			//Dispatch.run(Web.getParamsString(), Web.getParams(), new Main());
			
			//Custom trigger a déplacer dans des tests unitaire
			/*
			var route : Array<Dynamic> = [
				{object: new Main(), method:"customTrigger", access: INSTANCE },
				{object: Main, method:"customTriggerStatic", access: STATIC }
			];
			beluga.triggerDispatcher.register(new Trigger({action: "customTrigger", route: route}));
			beluga.triggerDispatcher.dispatch("customTrigger");
			beluga.triggerDispatcher.dispatch("login_request");
			*/
			beluga.cleanup();
		} catch (e : BelugaException) {
			trace(e);
		}
	}
	
	public function customTrigger()
	{
		Sys.println("<br />Custom non-static");
	}
	
	public function customTriggerStatic()
	{
		Sys.println("<br />Custom static");
	}

	public function new() {

	}

	public function doBeluga(d : Dispatch) {
		d.dispatch(beluga.api);
	}

	public function doDebug(d : Dispatch) {
		Web.setHeader("Content-Type", "text/plain");
		trace(Web.getParamsString());
	}

	public function doDefault(d : Dispatch) {
		if (d.parts[0] != "" ) {
			d.dispatch(beluga.api);
		} else {
			doAccueil();
		}
	}

	public function doAccountDemo(d : Dispatch) {
		d.dispatch(new AccountDemo(beluga));
	}

	public function doAccueil() {
			var html = Renderer.renderDefault("page_accueil", "Accueil",{});
			Sys.print(html);
	}

}