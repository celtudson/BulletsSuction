package;

import kha.CompilerDefines;
#if kha_html5
import js.html.CanvasElement;
import js.Browser.document;
#end
import kha.System;
import kha.Assets;
import kha.Font;
import kha.Framebuffer;
import kha.Scheduler;
import kha.input.Mouse;

class Main {

	static var font: Font;

	public static function main() {
		System.start({title: "BulletsSuction", width: 640, height: 480}, function (_) {
			#if kha_html5
			document.documentElement.style.padding = "0";
			document.documentElement.style.margin = "0";
			document.body.style.padding = "0";
			document.body.style.margin = "0";
			var canvas:CanvasElement = cast document.getElementById(CompilerDefines.canvas_id);
			canvas.width = 640;
			canvas.height = 480;
			#end
			Assets.loadEverything(
				function() {
					font = Assets.fonts.pixcyr2;
					Scheduler.addTimeTask(onUpdate, 0, 1 / 60);
					System.notifyOnFrames(onRender);
					Mouse.get().notify(onMouseDown, null, null, null);
					Bullets.onInit();
				}
			);
		});
	}

	static function onMouseDown(button: Int, x: Int, y: Int): Void {
		Bullets.onMouseDown(button, x, y);
	}

	static function onUpdate(): Void {
		Bullets.onUpdate();
	}

	static function onRender(framebuffers: Array<Framebuffer>): Void {
		final g = framebuffers[0].g2;
		g.begin();
		g.font = font;
		g.fontSize = 16;

		Bullets.onRender(g);

		g.end();
	}
}
