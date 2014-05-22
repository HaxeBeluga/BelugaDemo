package modules.mail_demo;

// Beluga
import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.module.mail.Mail;
import beluga.module.account.Account;

// BelugaDemo
import main_view.Renderer;

// haxe web
import haxe.web.Dispatch;
import haxe.Resource;

// Haxe PHP specific resource
#if php
import php.Web;
#end

class MailDemo {
    public var beluga(default, null) : Beluga;
    public var mail(default, null) : Mail;
    private var error_msg : String;
    private var success_msg : String;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.mail = beluga.getModuleInstance(Mail);
        this.error_msg = "";
        this.success_msg = "";
    }

    public static function _doDefault() {
       new MailDemo(Beluga.getInstance()).doDefault();
    }

    public function doDefault() {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        var widget = mail.getWidget("mail");
        widget.context = {mails : mail.getSentMails(), user : user, error : error_msg, success : success_msg, path : "/mailDemo/"};

        var mailWidget = widget.render();

        var html = Renderer.renderDefault("page_mail", "Mails list", {
            mailWidget: mailWidget
        });
        Sys.print(html);
    }

    public static function _doCreate() {
       new MailDemo(Beluga.getInstance()).subCreate({receiver : "", subject : "", message : ""});
    }

    public function subCreate(args : {receiver : String, subject : String, message : String}) {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            this.doDefault();
            return;
        }
        var widget = mail.getWidget("sendMail");
        widget.context = {user : user, error : error_msg, success : success_msg, path : "/mailDemo/",
                            receiver : args.receiver, subject : args.subject, message : args.message};

        var mailWidget = widget.render();

        var html = Renderer.renderDefault("page_mail", "Mails list", {
            mailWidget: mailWidget
        });
        Sys.print(html);
    }

    public function doCreate() {
        this.subCreate({receiver : "", subject : "", message : ""});
    }

    public static function _doSend(args : {receiver : String, subject : String, message : String}) {
        new MailDemo(Beluga.getInstance()).doSend(args);
    }

    public function doSend(args : {receiver : String, subject : String, message : String}) {
        this.mail.sendMail(args);
    }

    public static function _doSendFail(args : {error : String, receiver : String, subject : String, message : String}) {
        new MailDemo(Beluga.getInstance()).doSendFail(args);
    }

    public function doSendFail(args : {error : String, receiver : String, subject : String, message : String}) {
        this.error_msg = args.error;
        this.subCreate({receiver : args.receiver, subject : args.subject, message : args.message});
    }

    public static function _doSendSuccess() {
        new MailDemo(Beluga.getInstance()).doSendSuccess();
    }

    public function doSendSuccess() {
        success_msg = "Mail has been sent successfully";
        this.doDefault();
    }

    public static function _doPrint(args : {id : Int}) {
        new MailDemo(Beluga.getInstance()).doPrint(args);
    }

    public function doPrint(args : {id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            error_msg = "You have to log in";
            this.doDefault();
            return;
        }
        var mail = this.mail.getMail(args.id);
        if (mail == null) {
            error_msg = "Unknown mail";
            this.doDefault();
            return;
        }
        var widget = this.mail.getWidget("print");
        widget.context = {path : "/mailDemo/", receiver : mail.receiver, subject : mail.subject, text : mail.text, date : mail.sentDate};

        var mailWidget = widget.render();

        var html = Renderer.renderDefault("page_mail", "Mails list", {
            mailWidget: mailWidget
        });
        Sys.print(html);
    }
}